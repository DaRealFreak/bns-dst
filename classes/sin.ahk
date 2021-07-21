#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

class Timings
{
    ; sin doesn't really have animation locks but other classes may have some we should wait for before we try looting the boss
    PossibleAnimationLocks()
    {
        return 1.5
    }

    ; time to reach loot, only really needed for range classes who have no approach skill and could be 
    WalkToLoot()
    {
        return 0.5
    }

    ; timing of the boss 1 phase jump (changes depending on if you open with cc's)
    BossOnePhaseJump()
    {                                                       
        ; 3 is the default value if you open with double kd and you can push it to 90% in the kd duration
        return 2
    }

    BossTwoKnockdown()
    {
        ; if you start with double kd the knockdown will come after 8.5 seconds
        return 8.5                                                                                                                          
    }

    BossTwoSpin()
    {
        ; time in seconds the boss two needs to do the spin attack
        return 16.5
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
        send 1
        sleep 750

        ; we are lacking on damage that's why we use phantom
        send {tab}
        sleep 250
    }

    ; really simple auto combat, just spam keys, you can also add more complex checks if you ever want to, most of the times this is enough
    AutoCombat()
    {   
        ; make sure to disable ultra violet to prevent getting locked in animation
        send 4
        sleep 5
        
        send 0
        sleep 5

        send t
        sleep 5
    }

    IframeMiniBoss()
    {
        send c
        sleep 5
    }

    ; if you can unroot or want to cleanse bleeding stacks from mini boss you can do so here. Also can be used to wait for your phantom cooldown.
    CleanseMiniBossRoot()
    {
        sleep 10000
    }

    ; prestacking function for bosses
    Prestack()
    {

    }

    ; both bosses can't be range tanked, approach them here
    ApproachBoss()
    {
        send 1
        sleep 750
    }

    ; starting rotation on bosses
    StartRotation() 
    {
        ; make sure to start with phantom stance
        send {tab}
        sleep 250
        
        send 4
        sleep 25
        
        send 0
        sleep 25
        
        send v
        sleep 5
    }

    ; skills you don't want to use on the mini boss like starstrike/bluebuff/fireworks etc but want to use in the real fight
    DpsSkills()
    {
        ; add phantom stance to the dps rotation to reactivate it if the fight takes longar than 12 seconds 
        send {tab}
        sleep 5

        ; activate talisman
        send r
        sleep 5

        ; use bluebuff
        send v
        sleep 5
    }

    ; iframe you want to use for phase jump/knockdown attack of boss 1 and boss 2, preferred bubble iframe, else add a sleep duration
    Iframe()
    {   
        ; using the pp stealth on red aoe to prevent randomly blocking of yellow attacks
        send 2
        sleep 100
        send 2
        sleep 5
    }

    ; block for second boss spin attack if you see it, classes aside from bm will need a sleep duration, bm just triggers autoblock
    Block() 
    {
        ; using the c iframe instead of the 2 block to avoid getting teleported behind the boss
        send c
        sleep 5
    }

    ; whatever you want to do at the end of a fight, I use it to hmb for additional movement speed
    EndFight()
    {

    }
}