#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ColorConstants.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 159, 302, 192, 114)
$txtX = GUICtrlCreateInput("", 47, 32, 81, 21)
$txtY = GUICtrlCreateInput("", 48, 64, 81, 21)
$txtTimer = GUICtrlCreateInput("30", 48, 96, 81, 21)
$lblLocX = GUICtrlCreateLabel("Loc X", 12, 36, 32, 17)
$lblLocY = GUICtrlCreateLabel("Loc Y", 13, 67, 32, 17)
$lblLocY = GUICtrlCreateLabel("Timer", 13, 99, 32, 17)
$lblMouseLoc = GUICtrlCreateLabel('Get Mouse = F2', 13, 260, 100, 15)	;x, y, width, height of text label
$lblQuit = GUICtrlCreateLabel('Quit = F10', 13, 275, 50, 15)		;x, y, width, height of text label
$btnBegin = GUICtrlCreateButton("Begin", 48, 144, 81, 33)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

HotKeySet("{F10}", 'ExitProgram') 	;Exits program
HotKeySet("{F2}", "GetMyMousePos") 	;Gets current mouse pos
AutoItSetOption("SendKeyDelay", 25)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnBegin
			BeginTimer()
	EndSwitch
WEnd


Func BeginTimer()
	While 1
		Local $iTimer = GUICtrlRead($txtTimer)		;We put this inside the while loop in case someone changes the value while the test is running
		BeginAutomation()
		;After beginning test, wait for AVIT test to execute
		Sleep($iTimer * 60 * 1000)		;Time entered in minutes * 60 seconds * milliseconds
	WEnd
EndFunc


Func BeginAutomation()
	GUICtrlSetBkColor($btnBegin, $COLOR_BLUE)			;Sets button to green color

	;Read mouse click coord
	Local $mouseClickArray = FileReadToArray('c:\AVIT_20x20_Support_Files\AutoIT\MouseCoord.txt')
	If @error Then
		MsgBox($MB_SYSTEMMODAL, "", "There was an error reading the file. @error: " & @error) ; An error occurred reading the current script file.
	Else
		;Click Mouse Coord
		;Click Play
		MouseClick('primary', $mouseClickArray[0], $mouseClickArray[1], 1) 	;Click Play
		Sleep(1000)

		;Click Test Type
		MouseClick('primary', $mouseClickArray[2], $mouseClickArray[3], 1) 	;Click Test Type
		Sleep(500)

		;Click Test All
		MouseClick('primary', $mouseClickArray[4], $mouseClickArray[5], 1) 	;Click Test All
		Sleep(1000)

		;Click Start
		;Coming soon

	EndIf
	;Click Play
	;FiberQA AVIT - JSF-Tier II Configuration

EndFunc		;End BeginAutomation


Func ClickThisPos($posX, $posY)


EndFunc


Func GetMyMousePos()
	;msgbox(0,0,'Getting current mouse pos',2)
	Local $aPos = MouseGetPos()	;Get mouse position
	;MsgBox($MB_SYSTEMMODAL, "Mouse x, y:", $aPos[0] & ", " & $aPos[1])
	GUICtrlSetData($txtX, $aPos[0])	;Enter mouse pos in txtbox
	GUICtrlSetData($txtY, $aPos[1])	;Enter mouse pos in txt box
EndFunc	;==>End Func GetMyMousePos


Func ExitProgram()
	Exit
EndFunc   	;==>ExitProgram