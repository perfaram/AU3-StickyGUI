#include <GUIConstants.au3>


Global Const $SC_MOVE                       = 0xF010
Global Const $SC_SIZE                       = 0xF000

Global $nRange                              = 20
Global $IsSideWinStick                      = False ;True for sticking to all visible windows ( it's hangs up CPU).
GLobal $stickyRange=25

Global $main=GUICreate("Main Window", 400, 300, 0, 0)
GUISetState()

Global $hGUI = GUICreate("GUI Stickable!", 280, 150, Default, Default, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE))
GUIRegisterMsg($WM_SYSCOMMAND, "WM_SYSCOMMAND")
GUIRegisterMsg($WM_EXITSIZEMOVE, "WM_EXITSIZEMOVE")
GUIRegisterMsg($WM_WINDOWPOSCHANGING, "WM_WINDOWPOSCHANGING")

$useless_shit = GUICtrlCreateCheckbox("I'm a nice useless shit", 20, 20)
GUICtrlSetState(-1, $GUI_CHECKED)

$another = GUICtrlCreateCheckbox("I'm another useless shit", 20, 40)

$Range_Input = GUICtrlCreateInput($nRange, 20, 70, 40, 20, $ES_READONLY)
$UpDown = GUICtrlCreateUpdown(-1)
GUICtrlSetLimit(-1, 80, 5)

GUISetState()

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            ExitLoop
        Case $UpDown
            $nRange = GUICtrlRead($Range_Input)
    EndSwitch
WEnd

Func WM_WINDOWPOSCHANGING($hWnd, $Msg, $wParam, $lParam)
	If $hWnd=$hGUI Then
    Local $stWinPos         = DllStructCreate("uint;uint;int;int;int;int;uint", $lParam)
    Local $nLeft            = DllStructGetData($stWinPos, 3)
    Local $nTop             = DllStructGetData($stWinPos, 4)

    Local $aCurWinPos       = WinGetPos($hWnd)
    Local $aWorkArea        = _GetWorkingArea()

    ;Left
    If Abs($aWorkArea[0] - $nLeft) <= $nRange Then DllStructSetData($stWinPos, 3, $aWorkArea[0])
    ;Right
    If Abs($nLeft + $aCurWinPos[2] - $aWorkArea[2]) <= $nRange Then DllStructSetData($stWinPos, 3, $aWorkArea[2] - $aCurWinPos[2])
    ;Top
    If Abs($aWorkArea[1] - $nTop) <= $nRange Then DllStructSetData($stWinPos, 4, $aWorkArea[1])
    ;Bottom
    If Abs($nTop + $aCurWinPos[3] - $aWorkArea[3]) <= $nRange Then DllStructSetData($stWinPos, 4, $aWorkArea[3] - $aCurWinPos[3])

    ;If Not $IsSideWinStick Then Return 0


    ;For $i = 1 To UBound($ahWnd) - 1
		;If $ahWnd[$i][1] = $maingui Then
        ;If $ahWnd[$i][1] = $hWnd Or Not BitAND(WinGetState($ahWnd[$i][1]), 2) Then ContinueLoop

        $aSideWinPos = WinGetPos($main)
        ;If UBound($aSideWinPos) < 3 Then ContinueLoop

        Local $XPoint = $aSideWinPos[0]+15
        Local $YPoint = $aSideWinPos[1]+15

        If $XPoint < 0 Then $XPoint = 5
        If $YPoint < 0 Then $YPoint = 5

        If $aCurWinPos[1] + $aCurWinPos[3] >= $aSideWinPos[1] And $aCurWinPos[1] <= $aSideWinPos[1] + $aSideWinPos[3] Then
            ;Left
            If Abs(($aSideWinPos[0] + $aSideWinPos[2]) - $nLeft) <= $stickyRange And _
                WindowFromPoint($XPoint, $YPoint) = $main Then _
                    DllStructSetData($stWinPos, 3, $aSideWinPos[0] + $aSideWinPos[2])

            ;Right
            If Abs($nLeft + $aCurWinPos[2] - $aSideWinPos[0]) <= $stickyRange And _
                WindowFromPoint($XPoint, $YPoint) = $main Then _
                    DllStructSetData($stWinPos, 3, $aSideWinPos[0] - $aCurWinPos[2])
        EndIf

        If $aCurWinPos[0] + $aCurWinPos[2] >= $aSideWinPos[0] And $aCurWinPos[0] <= $aSideWinPos[0] + $aSideWinPos[2] Then
            ;Top
            If Abs(($aSideWinPos[1] + $aSideWinPos[3]) - $nTop) <= $stickyRange And _
                WindowFromPoint($XPoint, $YPoint) = $main Then _
                    DllStructSetData($stWinPos, 4, $aSideWinPos[1] + $aSideWinPos[3])

            ;Bottom
            If Abs($nTop + $aCurWinPos[3] - $aSideWinPos[1]) <= $stickyRange And _
                WindowFromPoint($XPoint, $YPoint) = $main Then _
                    DllStructSetData($stWinPos, 4, $aSideWinPos[1] - $aCurWinPos[3])
        EndIf
   ; Next
   EndIf

    Return 0
EndFunc


Func WM_INDOWPOSCHANGING($hWnd, $Msg, $wParam, $lParam)
	If $hWnd=$hGUI Then
    Local $stWinPos         = DllStructCreate("uint;uint;int;int;int;int;uint", $lParam)
    Local $nLeft            = DllStructGetData($stWinPos, 3)
    Local $nTop             = DllStructGetData($stWinPos, 4)

    Local $aCurWinPos       = WinGetPos($hWnd)
    Local $aWorkArea        = _GetWorkingArea()
	;$aCurWinPos[2]=$aCurWinPos[2]+5
	;$aCurWinPos[3]=$aCurWinPos[3]+5
    ;Left
    ;If Abs($aWorkArea[0] - $nLeft) <= $stickyRange Then DllStructSetData($stWinPos, 3, $aWorkArea[0])
    ;Right
    ;If Abs($nLeft + $aCurWinPos[2] - $aWorkArea[2]) <= $stickyRange Then DllStructSetData($stWinPos, 3, $aWorkArea[2] - $aCurWinPos[2])
    ;Top
    ;If Abs($aWorkArea[1] - $nTop) <= $stickyRange Then DllStructSetData($stWinPos, 4, $aWorkArea[1])
    ;Bottom
    ;If Abs($nTop + $aCurWinPos[3] - $aWorkArea[3]) <= $stickyRange Then DllStructSetData($stWinPos, 4, $aWorkArea[3] - $aCurWinPos[3])

    ;If Not $IsSideWinStick Then Return 0

    ;Local $ahWnd = WinList()

    ;For $i = 1 To UBound($ahWnd) - 1
		;If $ahWnd[$i][1] = $hGUI Then
        ;If $ahWnd[$i][1] = $hWnd Or Not BitAND(WinGetState($ahWnd[$i][1]), 2) Then ContinueLoop

        $aSideWinPos = WinGetPos($hGUI)
        ;If UBound($aSideWinPos) < 3 Then ContinueLoop

        Local $XPoint = $aSideWinPos[0]+15
        Local $YPoint = $aSideWinPos[1]+15

        If $XPoint < 0 Then $XPoint = 5
        If $YPoint < 0 Then $YPoint = 5

        If $aCurWinPos[1] + $aCurWinPos[3] >= $aSideWinPos[1] And $aCurWinPos[1] <= $aSideWinPos[1] + $aSideWinPos[3] Then
            ;Left
            If Abs(($aSideWinPos[0] + $aSideWinPos[2]) - $nLeft) <= $stickyRange And _
                WindowFromPoint($XPoint, $YPoint) = $hGUI Then _
                    DllStructSetData($stWinPos, 3, $aSideWinPos[0] + $aSideWinPos[2])

            ;Right
            If Abs($nLeft + $aCurWinPos[2] - $aSideWinPos[0]) <= $stickyRange And _
                WindowFromPoint($XPoint, $YPoint) = $hGUI Then _
                    DllStructSetData($stWinPos, 3, $aSideWinPos[0] - $aCurWinPos[2])
        EndIf

        If $aCurWinPos[0] + $aCurWinPos[2] >= $aSideWinPos[0] And $aCurWinPos[0] <= $aSideWinPos[0] + $aSideWinPos[2] Then
            ;Top
            If Abs(($aSideWinPos[1] + $aSideWinPos[3]) - $nTop) <= $stickyRange And _
                WindowFromPoint($XPoint, $YPoint) = $hGUI Then _
                    DllStructSetData($stWinPos, 4, $aSideWinPos[1] + $aSideWinPos[3])

            ;Bottom
            If Abs($nTop + $aCurWinPos[3] - $aSideWinPos[1]) <= $stickyRange And _
                WindowFromPoint($XPoint, $YPoint) = $hGUI Then _
                    DllStructSetData($stWinPos, 4, $aSideWinPos[1] - $aCurWinPos[3])
        EndIf
	;EndIf
    ;Next

    Return 0
EndIf
EndFunc


Func WM_SYSCOMMAND($hWnd, $Msg, $wParam, $lParam)
    Switch BitAND($wParam, 0xFFF0)
        Case $SC_SIZE, $SC_MOVE
            DllCall("user32.dll", "int", "SystemParametersInfo", "int", 37, "int", 1, "ptr", 0, "int", 2)
    EndSwitch
EndFunc

Func WM_EXITSIZEMOVE($hWnd, $Msg, $wParam, $lParam)
    Local $Old_Show_Content_Param = RegRead("HKEY_CURRENT_USER\Control Panel\Desktop", "DragFullWindows")
    DllCall("user32.dll", "int", "SystemParametersInfo", "int", 37, "int", $Old_Show_Content_Param, "ptr", 0, "int", 2)
EndFunc

Func WindowFromPoint($XPoint, $YPoint)
    Local $aResult = DllCall("User32.dll", "hwnd", "WindowFromPoint", "int", $XPoint, "int", $YPoint)
    Return $aResult[0]
EndFunc

;===============================================================================
;
; Function Name:    _GetWorkingArea()
; Description:      Returns the coordinates of desktop working area rectangle
; Parameter(s):     None
; Return Value(s):  On Success - Array containing coordinates:
;                        $a[0] = left
;                        $a[1] = top
;                        $a[2] = right
;                        $a[3] = bottom
;                   On Failure - 0
;
;BOOL WINAPI SystemParametersInfo(UINT uiAction, UINT uiParam, PVOID pvParam, UINT fWinIni);
;uiAction SPI_GETWORKAREA = 48
;===============================================================================
Func _GetWorkingArea()
    Local Const $SPI_GETWORKAREA = 48
    Local $stRECT = DllStructCreate("long; long; long; long")
    Local $SPIRet = DllCall("User32.dll", "int", "SystemParametersInfo", _
                        "uint", $SPI_GETWORKAREA, "uint", 0, "ptr", DllStructGetPtr($stRECT), "uint", 0)
    If @error Then Return 0
    If $SPIRet[0] = 0 Then Return 0

    Local $sLeftArea = DllStructGetData($stRECT, 1)
    Local $sTopArea = DllStructGetData($stRECT, 2)
    Local $sRightArea = DllStructGetData($stRECT, 3)
    Local $sBottomArea = DllStructGetData($stRECT, 4)

    Local $aRet[4] = [$sLeftArea, $sTopArea, $sRightArea, $sBottomArea]
    Return $aRet
EndFunc