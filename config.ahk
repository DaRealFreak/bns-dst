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

    ; hotkey where the buff food is placed, leave function empty if you don't want to take any buff food
    UseBuffFood()
    {
        send 5
    }

    ; hotkey where the field repair hammers are placed
    UseRepairTools()
    {
        send 7
    }

    ; after how many runs should we repair our weapon
    UseRepairToolsAfterRunCount()
    {
        return 10
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
        return 3/1
    }
}