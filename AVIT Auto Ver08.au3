;Ver 02:  Added for loop for mouse clicks -- 17/03/21 -- TC
;Ver 03:  Added minutes to the timer label.  Made form wider. -- 17/03/21 -- TC
;Ver 05:  Replaced mouseclicks with imageSearch & mouse click
;Ver 08:  We now click AVIT images instead of random windows images -- 17/04/24 -- TC

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
$Form1 = GUICreate("Auto AVIT", 159, 400, 212, 114)
$txtX = GUICtrlCreateInput("", 72, 32, 81, 21)
$txtY = GUICtrlCreateInput("", 72, 64, 81, 21)
$txtTimer = GUICtrlCreateInput("30", 72, 96, 81, 21)
$lblLocX = GUICtrlCreateLabel("Loc X", 12, 36, 32, 17)
$lblLocY = GUICtrlCreateLabel("Loc Y", 13, 67, 32, 17)
$lblLocY = GUICtrlCreateLabel("Timer (min)", 13, 99, 58, 30)
$lblMouseLoc = GUICtrlCreateLabel('Get Mouse = F2', 13, 360, 100, 15)	;x, y, width, height of text label
$lblQuit = GUICtrlCreateLabel('Quit = F10', 13, 375, 50, 15)		;x, y, width, height of text label
$btnBegin = GUICtrlCreateButton("Begin", 48, 144, 81, 33)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;Settings
HotKeySet("{F10}", 'ExitProgram') 	;Exits program
HotKeySet("{F2}", "GetMyMousePos") 	;Gets current mouse pos
AutoItSetOption("SendKeyDelay", 25)

;Variables
Global $imageArray[5]
Global $xArray[5]
Global $yArray[5]
Global $startPic
$xStartPos = 0
$yStartPos = 0



While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnBegin
			$startPic = @ScriptDir & "\Start1.png"		;We have a separate variable for the start photo because we individually click start
			GUICtrlSetBkColor($btnBegin, 0x4EFC49)					;Sets button to green color to show test has begun
			GetTargetImageArray()									;Get Images
			;*** start clicking, wait timer, start clicking again ***
			while 1
				Local $iTimer = GUICtrlRead($txtTimer)				;We put this inside the while loop in case someone changes the value while the test is running
				ClickImages()										;Click the images saved in this directory
				ClickStart()
				Sleep($iTimer * 60 * 1000)							;Time entered in minutes * 60 seconds * milliseconds
			WEnd
	EndSwitch
WEnd


Func GetTargetImageArray()
	For $i = 0 To 2 Step 1										;Loop thru the number of images we have
		$imageArray[$i] = @ScriptDir & "\Test" & $i & ".png"	;Will = dir\Test1.png
		;MsgBox(0, "ImageArray = ", $imageArray[$i])
		;MsgBox(0, "GetTargetImageArray", "Array " & $xArray[$i] & "|| NonArray: " & $x1)
	Next
EndFunc		;End GetTargetImageArray


Func ClickStart()
	$result = _ImageSearch($startPic,1,$xStartPos, $yStartPos,0)

	If $result = 1 Then											;If we find an image
		MouseClick('primary', $xStartPos, $yStartPos, 1)		;Click on the image
	Else
		MsgBox(16,"Error!", "Image not found: Image# Start")
	EndIf

	Sleep(700)
EndFunc


Func ClickImages()
	For $i = 0 to 2 Step 1
		$result = _ImageSearch($imageArray[$i],1,$xArray[$i],$yArray[$i],0)

		If $result = 1 Then											;If we find an image
			MouseClick('primary', $xArray[$i], $yArray[$i], 1)		;Click on the image
		Else
			MsgBox(16,"Error!", "Image not found: Image# " & $i)
		EndIf

		Sleep(700)
	Next
EndFunc


Func GetMyMousePos()
	Local $aPos = MouseGetPos()										;Get mouse position

	GUICtrlSetData($txtX, $aPos[0])									;Enter mouse pos in txtbox
	GUICtrlSetData($txtY, $aPos[1])									;Enter mouse pos in txt box
EndFunc		;==>End Func GetMyMousePos


Func ExitProgram()
	Exit
EndFunc   	;==>ExitProgram