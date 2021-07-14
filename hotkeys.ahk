#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

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