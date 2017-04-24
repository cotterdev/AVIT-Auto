;Ver 02:  Added for loop for mouse clicks -- 17/03/21 -- TC
;Ver 03:  Added minutes to the timer label.  Made form wider. -- 17/03/21 -- TC
;Ver 05:  Replaced mouseclicks with imageSearch & mouse click

;C:\Users\miniAVIT\Documents\AutoIT\AVIT Auto

#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ColorConstants.au3>
#include <ImageSearch2015.au3>

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Auto AVIT", 159, 302, 212, 114)
$txtX = GUICtrlCreateInput("", 72, 32, 81, 21)
$txtY = GUICtrlCreateInput("", 72, 64, 81, 21)
$txtTimer = GUICtrlCreateInput("30", 72, 96, 81, 21)
$lblLocX = GUICtrlCreateLabel("Loc X", 12, 36, 32, 17)
$lblLocY = GUICtrlCreateLabel("Loc Y", 13, 67, 32, 17)
$lblLocY = GUICtrlCreateLabel("Timer (min)", 13, 99, 58, 30)
$lblMouseLoc = GUICtrlCreateLabel('Get Mouse = F2', 13, 260, 100, 15)	;x, y, width, height of text label
$lblQuit = GUICtrlCreateLabel('Quit = F10', 13, 275, 50, 15)		;x, y, width, height of text label
$btnBegin = GUICtrlCreateButton("Begin", 48, 144, 81, 33)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;Settings
HotKeySet("{F10}", 'ExitProgram') 	;Exits program
HotKeySet("{F2}", "GetMyMousePos") 	;Gets current mouse pos
AutoItSetOption("SendKeyDelay", 25)

;Variables
$x1=0
$y1=0
Global $imageArray[5]

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnBegin
			GUICtrlSetBkColor($btnBegin, 0x4EFC49)			;Sets button to green color to show test has begun
			;Get images
			GetTargetImageArray()
			;*** start clicking, wait timer, start clicking again ***
			while 1
				;Get timer
				Local $iTimer = GUICtrlRead($txtTimer)		;We put this inside the while loop in case someone changes the value while the test is running

				;Click images
				BeginAutomation()
				;After beginning test, wait for AVIT test to execute
				Sleep($iTimer * 60 * 1000)					;Time entered in minutes * 60 seconds * milliseconds
			WEnd
	EndSwitch
WEnd


Func BeginAutomation()
	MsgBox(0,"Begin","About to being auto")
	$result = 0

	$result = _ImageSearch($imageArray[0],1,$x1,$y1,0)			;C:\Users\miniAVIT\Documents\AutoIT\AVIT Auto
	If $result = 1 Then
		MsgBox(0,"Success", "It found the image!",1)
		MouseMove($x1, $y1, 3)
	Else
		MsgBox(0,"Error", "No Image found!")
	EndIf


	;Read mouse click coord
	;Local $mouseClickArray = FileReadToArray('c:\AVIT_20x20_Support_Files\AutoIT\MouseCoord.txt')
	;If @error Then
	;	MsgBox($MB_SYSTEMMODAL, "", "There was an error reading the file. @error: " & @error) ; An error occurred reading the current script file.
	;Else
		;Mouseclicks!!
	;	For $i = 0 To UBound($mouseClickArray) - 1 Step 2
	;		MouseClick('primary', $mouseClickArray[$i], $mouseClickArray[$i+1], 1)
	;		Sleep(700)
	;	Next
	;EndIf
EndFunc		;End BeginAutomation


Func GetTargetImageArray()
	;$imageArray[0] = "C:\Users\miniAVIT\Documents\AutoIT\AVIT Auto\Test1.png"
	$imageArray[0] = @ScriptDir & "\Test1.png"
	MsgBox(0,"GetTargetImageArray", $imageArray[0])
EndFunc		;End GetTargetImageArray


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