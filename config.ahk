#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

/*
This class is primarily used for specific keys or optional settings like speedhack, cross server etc
*/
class Configuration 
{
    ; if you play and need long soul for b1 you can decide to wait for the talisman, which together with the walking time is approximately the downtime of your long soul
    ; make sure to include the talisman in your auto combat for the mini boss if this one is set to true
    WaitForLongSoul()
    {
        return false
    }

    ; simple setting, false -> running on the server, true -> running in cross server
    IsRunningOverCrossServer()
    {
        return true
    }

    ; should the character even use buff food
    ShouldUseBuffFood()
    {
        return true
    }

    ; pick up all loot including necklaces etc for the jewel powders or just rare elements
    PickupAllLoot()
    {
        return false
    }

    ; hotkey where the buff food is placed
    UseBuffFood()
    {
        send 6
    }

    ; hotkey where the field repair hammers are placed
    UseRepairTools()
    {
        send 7
    }

    ; after how many runs should we repair our weapon
    UseRepairToolsAfterRunCount()
    {
        return 20
    }

    ; hotkey for activating cheat engine/speed hack
    ActivateCheatEngine()
    {
        send {Numpad6 down}
    }

    ; hotkey for deactivating cheat engine/speed hack
    DeactivateCheatEngine()
    {
        send {Numpad6 up}
    }

    ; the speed the cheat engine is set to, so we can calculate how long the character has to walk
    CheatEngineSpeed()
    {
        return 4.0
    }

    ; depending on the kill time of the mini boss and stuck in combat state option to increase/decrease the time running towards the platform of boss one
    RunTimeToBossOne()
    {
        return 17
    }

    ; shortcut for shadowplay clip in case we want to debug how we got stuck or got to this point
    ClipShadowPlay()
    {
        send {alt down}{f10 down}
        sleep 1000
        send {alt up}{f10 up}
    }
}