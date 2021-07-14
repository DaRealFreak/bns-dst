SetKeyDelay, -1, -1
SetWinDelay, -1

#Include %A_ScriptDir%\lib\utility.ahk
#Include %A_ScriptDir%\lib\log.ahk

#Include %A_ScriptDir%\class.ahk
#Include %A_ScriptDir%\config.ahk
#Include %A_ScriptDir%\ui.ahk

class DreamSongTheater
{
    static runCount := 0

    ; functionality to use the escape functionality to escape to the start of the dungeon, used only when we're stuck somewhere
    EscapeDungeon()
    {
        log.addLogEntry("$time: escaping dungeon")

        ; safety deactivation
        Configuration.DeactivateCheatEngine()

        ; open escape menu and wait half a second until it appeared
        send {Esc}
        sleep 0.5 * 1000

        ; click on escape
        if (Configuration.IsRunningOverCrossServer()) {
            UserInterface.ClickEscapeCrossServer()
        } else {
            UserInterface.ClickEscape()
        }

        ; get out of possible combat
        sleep 10 * 1000
    }

    ; function we can call when we expect a loading screen and want to wait until the loading screen is over
    WaitLoadingScreen()
    {
        log.addLogEntry("$time: wait for loading screen")

        ; just sleep while we're in the loading screen
        while (UserInterface.IsInLoadingScreen()) {
            sleep 5
        }

        ; check any of the skills if they are visible
        while (!UserInterface.IsAnySkillVisible()) {
            sleep 5
        }

        sleep 250
    }

    ; simply check for the buff food and use 
    CheckBuffFood()
    {
        log.addLogEntry("$time: checking buff food")

        ; check if buff food icon is visible
        if (!UserInterface.IsBuffFoodIconVisible()) {
            log.addLogEntry("$time: using buff food")

            Configuration.UseBuffFood()
            sleep 750
        }
    }

    ; enter the dungeon either by walking straigt into it or walking backwards and using ss
    ; can also be abused as exit dungeon function when the script got stuck
    EnterDungeon(notAbusedModeKek := true)
    {
        if (notAbusedModeKek) {
            log.addLogEntry("$time: entering dungeon, runs done: " this.runCount)
            DreamSongTheater.CheckBuffFood()
        }

        if (Configuration.IsRunningOverCrossServer() && notAbusedModeKek) {
            send {w down}
            send {ShiftDown}
        } else {
            send {s down}
        }

        ; walk backwards until we're in the loading screen
        while (!UserInterface.IsInLoadingScreen()) {
            ; if we're walking backwards in/out of the dugneon add ss skill to be faster than slow walking
            if (!(Configuration.IsRunningOverCrossServer() && useAsExitDungeon) && UserInterface.IsSSAvailable()) {
                send ss
                sleep 5
                send {s down}
            }
            sleep 5
        }

        ; we're in the loading screen, release the keys now
        if (Configuration.IsRunningOverCrossServer() && notAbusedModeKek) {
            send {w up}
            send {ShiftUp}
        } else {
            send {s up}
        }

        ; wait until the loading screen is over
        DreamSongTheater.WaitLoadingScreen()

        ; continue with the script or return false
        if (notAbusedModeKek) {
            return DreamSongTheater.MoveFirstMiniBoss()
        } else {
            return false
        }
    }

    ; move to the first mini boss
    MoveFirstMiniBoss()
    {
        log.addLogEntry("$time: moving to first mini boss")

        send {w down}
        send {ShiftDown}

        ; speed it up and walk on the right height
        Configuration.ActivateCheatEngine()
        sleep 11.55 * 1000 / Configuration.CheatEngineSpeed()

        ; stop walking forwards
        send {ShiftUp}
        send {w up}

        ; move left to the mini boss
        send {a down}
        sleep 8.07 * 1000 / Configuration.CheatEngineSpeed()
        send {a up}
        Configuration.DeactivateCheatEngine()

        ; let the character come to a stop
        sleep 250

        ; continue with our first fight
        return DreamSongTheater.FightFirstMiniBoss()
    }

    ; fight the first mini boss, the most annoying enemy in the dungeon for many classes
    FightFirstMiniBoss()
    {
        log.addLogEntry("$time: fighting first mini boss")

        ; prestack and approach the mini boss
        Combat.PrestackMiniBoss()
        Combat.ApproachMiniBoss()

        start := A_TickCount
        while (A_TickCount < start + 18 * 1000) {
            ; if the target skill is greyed out the miniboss is dead
            if (UserInterface.IsTargetSkillUnavailable()) {
                log.addLogEntry("$time: target skill is greyed out, breaking combat")
                break
            }

            ; start including an iframe 4.5 seconds into the fight to iframe the 3 hit knockback
            if (A_TickCount > start + 4.5 * 1000) {
                Combat.IframeMiniBoss()
            }

            Combat.AutoCombat()
        }

        ; cleanse root/bleeding debuffs
        Combat.CleanseMiniBossRoot()

        ; if we should wait for the long soul we are going to wait for the taisman with has a similar cd and is not bugging out like the longsoul cd
        if (Configuration.WaitForLongSoul()) {
            DreamSongTheater.WaitTalisman()
        }

        ; continue moving to the first boss
        return DreamSongTheater.MoveFirstBoss()
    }

    ; function to wait for your talisman which is similar to long soul cooldown
    WaitTalisman()
    {
        log.addLogEntry("$time: wait for talisman")

        while (!Availability.IsTalismanAvailable()) {
            sleep 5
        }
    }

    ; move to the first boss of dst
    MoveFirstBoss()
    {
        log.addLogEntry("$time: moving to first boss")

        ; walk forwards to the first boss, add time running against the wall in case we got knocked back a bit or were rooted
        send {w down}
        send {ShiftDown}
        Configuration.ActivateCheatEngine()
        sleep 12 * 1000 / Configuration.CheatEngineSpeed()
        Configuration.DeactivateCheatEngine()

        ; in case we didn't get out of combat yet
        sleep 4 * 1000
        send {ShiftUp}
        send {w up}

        ; jump on the platform
        send {w down}
        send {ShiftDown}

        ; wait until we're running before jumping
        sleep 0.5 * 1000
        send {space}

        start := A_TickCount
        while (!UserInterface.IsEnemyHealthbarVisible())
        {
            ; probably didn't even attack mini boss, happens if speedhack is too fast
            if (A_TickCount > start + 20 * 1000) {
                log.addLogEntry("$time: moving to first boss took longer than expected, escaping")
                ; quit walking
                send {ShiftUp}
                send {w up}

                DreamSongTheater.EscapeDungeon()

                ; exit dungeon by walking backwards (same as entering the dungeon)
                DreamSongTheater.EnterDungeon(false)
                ; go back into the dungeon
                return DreamSongTheater.EnterDungeon()
            }

            ; user died
            if (UserInterface.IsReviveVisible()) {
                log.addLogEntry("$time: died while moving to first boss, mini boss probably not dead, reviving and starting again")
                ; quit walking
                send {ShiftUp}
                send {w up}
                ; revive
                send 4
                ; we're not sure if we died on mini boss or boss so better leave the dungeon and abandon this run
                sleep 5 * 1000

                ; exit dungeon by walking backwards (same as entering the dungeon)
                DreamSongTheater.EnterDungeon(false)
                ; go back into the dungeon
                return DreamSongTheater.EnterDungeon()
            }

            sleep 5
        }

        send {ShiftUp}
        send {w up}

        ; onto fighting the first boss
        return DreamSongTheater.FightFirstBoss()
    }

    ; fight the first boss of dst
    FightFirstBoss()
    {
        log.addLogEntry("$time: fighting first boss")

        Combat.Prestack()
        Combat.ApproachBoss()

        start := A_TickCount
        while (A_TickCount < start + 18 * 1000) {
            ; if the target skill is greyed out boss 1 should be dead
            if (UserInterface.IsTargetSkillUnavailable()) {
                log.addLogEntry("$time: target skill is greyed out, breaking combat")
                break
            }

            ; skills you don't want to waste on the mini boss but want to use on the real boss
            Combat.DpsSkills()

            ; start including iframes for phase jump
            if (A_TickCount > start + Timings.BossOnePhaseJump() * 1000 && A_TickCount < start + (Timings.BossOnePhaseJump() + 1.5) * 1000) {
                Combat.Iframe()
                sleep 5
            }

            Combat.AutoCombat()
        }

        Combat.EndFight()

        ; continue moving to the second boss
        return DreamSongTheater.MoveSecondBoss()
    }

    ; move to the second boss of dst
    MoveSecondBoss()
    {
        log.addLogEntry("$time: moving to second boss")

        ; portal will reset our sprint, so we just ignore it
        Configuration.ActivateCheatEngine()
        send {w down}

        start := A_TickCount
        while (!UserInterface.IsEnemyHealthbarVisible())
        {
            ; died
            if (UserInterface.IsReviveVisible()) {
                log.addLogEntry("$time: died while walking to second boss, probably died on first boss, reentering dungeon")
                ; quit walking
                send {w up}
                Configuration.DeactivateCheatEngine()

                ; revive and wait for the animation
                send 4
                sleep 5 * 1000

                ; we're not sure if we died on mini boss or boss so better leave the dungeon and abandon this run
                DreamSongTheater.EnterDungeon(false)
                ; go back into the dungeon
                return DreamSongTheater.EnterDungeon()                
            }

            sleep 5
        }

        if (A_TickCount < start + 1 * 1000) {
            ; target skill is greyed out for a short amount of time and we still see the boss healthbar, so script thinks we're instantly at the second boss
            log.addLogEntry("$time: walking to the second boss took an unexpected amount of time, we probably got range checked by the first boss, reentering dungeon")

            ; wait until the first boss killed us
            while (!UserInterface.IsReviveVisible()) {
                sleep 5
            }

            ; quit walking
            send {w up}
            Configuration.DeactivateCheatEngine()
            ; revive
            send 4
            ; we're not sure if we died on mini boss or boss so better leave the dungeon and abandon this run
            sleep 5 * 1000

            ; exit dungeon by walking backwards (same as entering the dungeon)
            DreamSongTheater.EnterDungeon(false)
            ; go back into the dungeon
            return DreamSongTheater.EnterDungeon()                
        }

        Configuration.DeactivateCheatEngine()
        send {w up}
        sleep 5

        return DreamSongTheater.FightSecondBoss()
    }

    ; fight the second boss of dst
    FightSecondBoss()
    {
        log.addLogEntry("$time: fighting second boss")

        Combat.Prestack()
        Combat.ApproachBoss()

        start := A_TickCount
        while (A_TickCount < start + 20 * 1000) {
            ; if the target skill is greyed out boss 2 should be dead
            if (UserInterface.IsTargetSkillUnavailable()) {
                log.addLogEntry("$time: target skill is greyed out, breaking combat")
                break
            }

            ; skills you don't want to waste on the mini boss but want to use on the real boss
            Combat.DpsSkills()

            ; start including iframes for rotation knockdown
            if (A_TickCount > start + Timings.BossTwoKnockdown() * 1000 && A_TickCount < start + (Timings.BossTwoKnockdown() + 1.5) * 1000) {
                Combat.Iframe()
                sleep 5
            }

            ; start blocking or second iframe for spin of the boss
            if (A_TickCount > start + Timings.BossTwoSpin() * 1000 && A_TickCount < start + (Timings.BossTwoSpin() + 1.5) * 1000) {
                Combat.Block()
                sleep 5
            }

            Combat.AutoCombat()
        }

        return DreamSongTheater.LootBoss()
    }

    ; loot loot loot
    LootBoss()
    {
        ; wait 1 second for ongoing animation locks
        sleep Timings.PossibleAnimationLocks() * 1000

        log.addLogEntry("$time: looting boss")

        ; walk a bit forward since loot can be out of reach
        send {w down}
        sleep 0.3 * 1000
        send {w up}
        sleep 150

        ; pick items up and start confirmation dialogue
        log.addLogEntry("$time: looting item")
        send f
        sleep 500
        send f
        sleep 500

        lootLoop := 0
        ; loot icon on f and we tried less than 10 times to loot the items
        while (UserInterface.IsLootIconVisible() && lootLoop <= 10) {
            ; after 3 items start dialogue again in case we skipped sth by accident/lag
            if (mod(lootLoop, 3) == 0) {
                send f
                sleep 500
            }

            log.addLogEntry("$time: looting confirmation item")
            send y
            sleep 500
            lootLoop += 1
        }

        log.addLogEntry("$time: stopped looting after confirmed item count: " lootLoop)

        ; increase our run counter
        this.runCount += 1

        ; repair weapon after the defined amount of runs
        if (mod(this.runCount, Configuration.UseRepairToolsAfterRunCount()) == 0) {
            DreamSongTheater.RepairWeapon()
        }

        ; delay end fight here so have a better uptime of f.e. movement speed buffs
        Combat.EndFight()

        return DreamSongTheater.ExitDungeon(true)
    }

    ; repair the weapon
    RepairWeapon()
    {
        log.addLogEntry("$time: repairing weapon")

        Configuration.UseRepairTools()
        sleep 4 * 1000
    }

    ; exit the dungeon from our loot location
    ExitDungeon(escaped := false)
    {
        log.addLogEntry("$time: exiting dungeon")

        if (!escaped) {
            send {a down}
        } else {
            send {w down}
        }

        start := A_TickCount
        while (true) {

            ; failsave if revive on 4, revive and repeat steps from second boss
            if (UserInterface.IsReviveVisible()) {
                log.addLogEntry("$time: died on second boss, retrying second boss")
                ; quit walking
                send {w up}
                send {a up}
                ; revive and waaait
                send 4

                ; since we don't wait for talisman for 2nd boss we wait for long/short soul
                if (Configuration.WaitForLongSoul()) {
                    ; long soul duration
                    sleep 45 * 1000
                } else {
                    ; short soul duration
                    sleep 18 * 1000
                }

                return DreamSongTheater.MoveSecondBoss()
            }

            ; exit portal icon on f
            if (UserInterface.IsExitPortalIconVisible()) {
                break
            }

            ; no idea when this normally happens
            if (A_TickCount > start + 20 * 1000) {
                log.addLogEntry("$time: exiting dungeon took longer than expected, escaping")
                ; quit walking
                send {w up}
                send {a up}

                DreamSongTheater.EscapeDungeon()

                return DreamSongTheater.ExitDungeon()
            }

            sleep 5
        }

        send {w up}
        send {a up}
        sleep 250

        ; use the exit portal and spam f in case we have no auto dynamic quests
        Configuration.ActivateCheatEngine()
        while (!UserInterface.IsInLoadingScreen()) {
            send f
            sleep 5
            send y
            sleep 5
            ; sleep 2.1 seconds in case there is any skill on f which is overwriting the exit portal
            sleep 2.1 * 1000 / Configuration.CheatEngineSpeed()
        }
        Configuration.DeactivateCheatEngine()

        ; wait until we're out and end this loop
        DreamSongTheater.WaitLoadingScreen()

        return true
    }
}

#IfWinActive ahk_class LaunchUnrealUWindowsClient
F1::
    MouseGetPos, mouseX, mouseY
    color := Utility.GetColor(mouseX, mouseY, r, g, b)
    tooltip, Coordinate: %mouseX%`, %mouseY% `nHexColor: %color%`nR:%r% G:%g% B:%b%
    Clipboard := "Utility.GetColor(" mouseX "," mouseY ") == `""" color "`"""
    SetTimer, RemoveToolTip, -5000
    return

RemoveToolTip:
    tooltip
    return

#IfWinActive ahk_class LaunchUnrealUWindowsClient
Numpad0::
    global log := new LogClass("dst_bot")
    log.initalizeNewLogFile(-1)
    log.addLogEntry("$time: starting dst")
    loop {
        if (!DreamSongTheater.EnterDungeon()) {
            break
        }
        sleep 250
    }

    return

NumpadDel::Reload
NumpadEnter::ExitApp