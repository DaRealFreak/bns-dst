#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

class Timings
{
    PossibleAnimationLocks()
    {
        return 7
    }

    BossOnePhaseJump()
    {
        ; we are in godmode, so we don't care about the jump
        return 99
    }

    BossTwoKnockdown()
    {
        return 9.2
    }

    BossTwoSpin()
    {
        return 16
    }
}

class Combat
{
    ; if you can prestack something like lux, sunsparks or whatever you can do so here, bm can't, so just an example how you can duplicate funcionality
    PrestackMiniBoss()
    {
        Combat.Prestack()
    }

    ; mini boss can be tanked on range, so not all classes have to approach it
    ApproachMiniBoss()
    {
        ; approach the boss
        send e
        sleep 500

        ; enter overcharge
        send r
        sleep 1*1000

        ; enter godmode
        send r
    }

    ; really simple auto combat, just spam keys, you can also add more complex checks if you ever want to, most of the times this is enough
    AutoCombat()
    {
        send 2
        sleep 5
        send t
        sleep 5
        send 4
        sleep 5
        send c
        sleep 5
        send x
        sleep 5
        send z
        sleep 5
    }

    ; bm can cover the 3 hit knockback with hmb already, bubble iframe would be perfect, non bubble iframe can be forced with full duration with sleep
    IframeMiniBoss()
    {

    }

    ; if you can unroot or want to cleanse bleeding stacks from mini boss you can do so here
    CleanseMiniBossRoot()
    {
        ; wait for godmode cooldown
        sleep 12*1000
    }

    ; prestacking function for bosses
    Prestack()
    {
        loop, 4 {
            send r
            sleep 1*1000
        }
    }

    ; both bosses can't be range tanked, approach them here
    ApproachBoss()
    {
        sleep 50
        send q
        sleep 400
        send e
        sleep 150

        ; enter overcharge
        send r
        sleep 1*1000

        ; enter godmode
        send r
    }

    ; skills you don't want to use on the mini boss like starstrike/bluebuff/fireworks etc but want to use in the real fight
    DpsSkills()
    {
    }

    ; iframe you want to use for phase jump/knockdown attack of boss 1 and boss 2, preferred bubble iframe, else add a sleep duration
    Iframe()
    {
        send {tab}
        sleep 1000
        send {tab}
    }

    ; block for second boss spin attack if you see it, classes aside from bm will need a sleep duration, bm just triggers autoblock
    Block()
    {
        send 1
    }

    ; whatever you want to do at the end of a fight, I use it to hmb for additional movement speed
    EndFight()
    {
    }
}