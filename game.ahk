#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

class Game
{
    static startingWindowHwid := 0x0

    ; set the current active window as starting window
    SetStartingWindowHwid()
    {
        ; A = active window
        WinGet, winId ,, A
        this.startingWindowHwid := winId
    }

    ; retrieve the window hwid of the game when we started the script
    GetStartingWindowHwid()
    {
        return this.startingWindowHwid
    }

    ; get hwids of twink account windows (excluded main window hwid) to switch f.e. windows for escaping
    GetOtherWindowHwids()
    {
        gameHwids := []

        WinGet, winIds, List , Blade & Soul
        Loop, %winIds%
        {
            hwnd := winIds%A_Index%
            if (hwnd != this.startingWindowHwid) {
                gameHwids.Push(hwnd)
            }
        }

        return gameHwids
    }

    ; get all relevant window hwids to send inputs to
    GetRelevantWindowHwids()
    {
        gameHwids := []
        gameHwids.Push(Game.GetStartingWindowHwid())

        if Configuration.UseMultiBoxing() {
            twinkWindowHwids := Game.GetOtherWindowHwids()

            for _, hwnd in twinkWindowHwids
            {
                gameHwids.Push(hwnd)
            }
        }



        return gameHwids
    }

    ; send the key to all relevant windows
    SendInput(key)
    {
        hwndList := Game.GetOtherWindowHwids()

        Send, %key%
        for _, hwnd in hwndList
        {
            ; control send is not working for down & up keys, but it sets the hwnd as "active" window internally, allowing for send to work
            ControlSend,, %key%, ahk_id %hwnd%
        }
    }

    ; small test function to test swapping to twink windows before swapping back to main window
    TestWindowSwaps()
    {
        Game.SetStartingWindowHwid()
        twinkWindowHwids := Game.GetOtherWindowHwids()

        for index, hwnd in twinkWindowHwids
        {
            MsgBox % "index: " . index . " hwnd: " . hwnd
            WinActivate, ahk_id %hwnd%
        }

        startingWindowHwid := Game.GetStartingWindowHwid()
        WinActivate, ahk_id %startingWindowHwid%
    }
}