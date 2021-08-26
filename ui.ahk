#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

/*
This class is used for differences in the user interfaces.
If the resolution and ClientConfiguration.xml are not identical you'll always have to change these settings
*/
class UserInterface
{
    ; escape position in the menu on the server
    ClickEscape()
    {
        MouseClick, left, 1790, 772
    }

    ; escape position in the menu in cross server (more menu points due to return to server and exit options)
    ClickEscapeCrossServer()
    {
        MouseClick, left, 1766, 745
    }

    ; whenever you want to refresh your buff food (basically one of the last pixels which will become darker)
    IsBuffFoodIconVisible()
    {
        return Utility.GetColor(21,5) == "0x4C3747"
    }

    ; any position of the revive skill
    IsReviveVisible()
    {
        return Utility.GetColor(1033,904) == "0x665846"
    }

    ; literally any skill, just used for checking if we're out of the loading screen
    IsAnySkillVisible()
    {
        return Utility.GetColor(826,912) == "0x354482"
    }

    ; any skill which requires a target and is not used during combat during it's unavailable phase so we know we don't have a target anymore (target hopefully dead)
    IsTargetSkillUnavailable()
    {
        return Utility.GetColor(1034,894) == "0x2A2A2A"
    }

    ; any position on the loot icon
    IsLootIconVisible()
    {
        return Utility.GetColor(1177,693) == "0xD9C6B0"
    }

    ; any position on the exit portal
    IsExitPortalIconVisible()
    {
        return Utility.GetColor(1177,693) == "0x271A0E"
    }

    ; preferably the small sword on the left side of the boss healthbar, since the healthbar itself has slightly different colors sometimes
    IsEnemyHealthbarVisible()
    {
        ; locals and no locals cause differences between healthbar colors
        color := Utility.GetColor(716,60)
        return color == "0xB59C5D" || color == "0x645832"
    }

    ; some of the filled out bar in the loading screen on the bottom of the screen
    IsInLoadingScreen()
    {
        return Utility.GetColor(10,1061) == "0x0066FF"
    }

    ; check for ss availability for faster entry/exit
    IsSSAvailable()
    {
        return Utility.GetColor(682,961) == "0x875049"
    }

    ; check if sprint is visible (green bar value > 100 in my case since it's slightly transparent)
    IsSprintVisible()
    {
        Utility.GetColor(925,816, r, g)
        return g > 100
    }

    ; check for talisman cooldown border, basically only needed if you have to wait for your long soul
    IsTalismanAvailable()
    {
        return Utility.GetColor(557,635) != "0xE46B14"
    }
}