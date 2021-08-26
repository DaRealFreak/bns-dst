#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

class Timings
{
    ; bm doesn't really have animation locks but other classes may have some we should wait for before we try looting the boss
    PossibleAnimationLocks()
    {
        return 0.5
    }

    ; time to reach loot, only really needed for range classes who have no approach skill and could be 
    WalkToLoot()
    {
        return 0.5
    }

    MiniBossKnockback()
    {
        return 2.0
    }

    ; timing of the boss 1 phase jump (changes depending on if you open with cc's)
    BossOnePhaseJump()
    {
        ; 3 is the default value if you open with double kd and you can push it to 90% in the kd duration
        return 3
    }

    BossTwoKnockdown()
    {
        ; if you start with double kd the knockdown will come after 8.5 seconds
        return 9.5
    }

    BossTwoSpin()
    {
        ; if you start with double kd the spin will happen after 16 seconds
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
        ; use hmb for the 3 hit knockback (+ double swipe on lower dps)
        send 1
        sleep 500
        send f
        sleep 250
        
        ; enter flock stance
        send {tab}
        sleep 350

        ; approach the boss
        send 2
        sleep 350

        ; make sure to start with spirit vortex
        send v
        sleep 150
    }

    ; really simple auto combat, just spam keys, you can also add more complex checks if you ever want to, most of the times this is enough
    AutoCombat()
    {
        send r
        sleep 5
        send t
        sleep 5
        send 4
        sleep 5
        send v
        sleep 5
    }

    ; bm can cover the 3 hit knockback with hmb already, bubble iframe would be perfect, non bubble iframe can be forced with full duration with sleep
    IframeMiniBoss()
    {
    }

    ; if you can unroot or want to cleanse bleeding stacks from mini boss you can do so here
    CleanseMiniBossRoot()
    {
        ; possible gcd from slices
        sleep 500

        ; get out of flock stance to keep autoblock for b1
        send y
        sleep 500

        ; use cyclone to remove root so move timings are correct
        send 1
        sleep 350

        send y
        sleep 450
    }

    ; prestacking function for bosses
    Prestack()
    {
    }

    ; both bosses can't be range tanked, approach them here
    ApproachBoss()
    {
        ; go into flock stance
        send {tab}
        sleep 350

        ; use e dash
        send e
        sleep 250

        ; cancel it with the target approach (we keep the iframe duration from the e dash for our 2 approach)
        send 2
        sleep 750

        ; make sure to start with spirit vortex
        send v
        sleep 150
    }

    ; skills you don't want to use on the mini boss like starstrike/bluebuff/fireworks etc but want to use in the real fight
    DpsSkills()
    {
        ; starstrike
        send {tab}
        sleep 5

        ; my talisman is bound to 9
        send 9
        sleep 5
    }

    ; iframe you want to use for phase jump/knockdown attack of boss 1 and boss 2, preferred bubble iframe, else add a sleep duration
    Iframe()
    {
        send c
    }

    ; block for second boss spin attack if you see it, classes aside from bm will need a sleep duration, bm just triggers autoblock
    Block()
    {
        send 1
    }

    ; whatever you want to do at the end of a fight, I use it to hmb for additional movement speed
    EndFight()
    {
        ; get out of flock stance
        send y
        sleep 500

        ; block
        send 1
        sleep 500

        ; hmb
        send f
        sleep 5
    }
}