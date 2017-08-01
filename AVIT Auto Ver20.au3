;Ver 02:  Added for loop for mouse clicks -- 17/03/21 -- TC
;Ver 03:  Added minutes to the timer label.  Made form wider. -- 17/03/21 -- TC
;Ver 05:  Replaced mouseclicks with imageSearch & mouse click
;Ver 08:  We now click AVIT images instead of random windows images -- 17/04/24 -- TC
;Ver 11:  Removed mouse coord from form.  Added screenshot capability -- 17/06/23 -- TC
;Ver 13:  Works!  Test All had a checkmark in it, also sometimes we do a
;Ver 18:  Now retries taking SS.  If the image is clicked it may be blue, then again it may not be, now we click on both -- 17/07/28 -- TC
;Ver 19:  Made array that holds testing photos bigger -- 17/08/01 -- TC
;Ver 20:  Array didn't loop enough.  Line 95



#include <MsgBoxConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ColorConstants.au3>
#include <ImageSearch2015.au3>
#include <ScreenCapture.au3>


#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Auto AVIT", 250, 400, 212, 200)
$txtTimer = GUICtrlCreateInput("30", 90, 96, 81, 21)
$lblTimer = GUICtrlCreateLabel("Timer (min)", 30, 99, 58, 30)
$lblQuit = GUICtrlCreateLabel('Quit = F10', 13, 375, 50, 15)		;x, y, width, height of text label
$btnBegin = GUICtrlCreateButton("Begin", 90, 200, 81, 33)
$btnTry = GUICtrlCreateButton("Debug", 90, 250, 81, 33)
$takeScreenShots =  GUICtrlCreateCheckbox("Take Screenshots", 75, 140, 129, 33) ;64, 56, 129, 33
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;Settings
HotKeySet("{F10}", 'ExitProgram') 	;Exits program
;HotKeySet("{F2}", "GetMyMousePos") 	;Gets current mouse pos
AutoItSetOption("SendKeyDelay", 25)

;Variables
Global $imageArray[20]
Global $ssImageArray[21]
Global $retryImage
Global $retrySSImage
Global $xArray[5]
Global $yArray[5]
Global $startPic
Global $xStartPos = 0						;Start has it's own variable because we click this last on it's own
Global $yStartPos = 0
Global $iStartExists = 1
Global $ssNum = 1
Global $ssStatus


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnBegin
			SetStartImage()
			$retryImage = @ScriptDir & "\Test1_retry.png"			;Used because the image may be different depending on whether a test passed or failed
			$retrySSImage = @ScriptDir & "\SS0_retry.png"
			GUICtrlSetBkColor($btnBegin, 0x4EFC49)					;Sets button to green color to show test has begun
			SetTargetImageArray()									;Get Images
			SetSSImageArray()										;Get Images to click on for screenshots
			;*** start clicking, wait timer, take screenshots, start clicking again ***
			while 1
				Local $iTimer = GUICtrlRead($txtTimer)				;We put this inside the while loop in case someone changes the value while the test is running
				ClickImages($imageArray)							;Clicks the images that will kickoff a test
				ClickStart()
				Sleep($iTimer * 60 * 1000)							;Time entered in minutes * 60 seconds * milliseconds
				$ssStatus = GUICtrlRead ($takeScreenShots)
				If($ssStatus == 1) Then
					;Take Screenshots
					ClickImageThenSS($ssImageArray)						;Clicks the images that will take screenshots
				EndIf
			WEnd
		Case $btnTry
			$ssStatus = GUICtrlRead ($takeScreenShots)
			MsgBox(0,"SS Value", $ssStatus)
	EndSwitch
WEnd


Func SetStartImage()
	$startPic = @ScriptDir & "\Start1.png"					;We have a separate variable for the start photo because we individually click start
	$iStartExists = FileExists($startPic)
	If $iStartExists <> 1 Then
		MsgBox(0,"Error","We did not find Start1.png!!!",5)
	EndIf
EndFunc

Func SetTargetImageArray()
	For $i = 0 To 15 Step 1											;Loop thru the number of images we have
		$imageArray[$i] = @ScriptDir & "\Test" & $i & ".png"		;Will = dir\Test1.png
	Next
EndFunc		;End GetTargetImageArray


Func SetSSImageArray()
	For $i = 0 To 20 Step 1											;Loop thru the number of images we have
		$ssImageArray[$i] = @ScriptDir & "\SS" & $i & ".png"		;Will = dir\SS#.png
	Next
EndFunc		;End GetTargetImageArray


Func ClickStart()
	$result = _ImageSearch($startPic,1,$xStartPos, $yStartPos,0)	;Changed from 1 to 255

	If $result == "True" Then										;If we find an image
		MouseClick('primary', $xStartPos, $yStartPos, 1)			;Click on the image
	Else
		MsgBox(16,"Error!", "Image not found: Image# Start",5)
	EndIf

	Sleep(700)
EndFunc



Func ClickImages($disImageArray)
	Local $i = 0
	Local $iFileExists = 1
	While($iFileExists == 1)										;We want to keep looping until a file does not exist
		;MsgBox(0,"Starting Test", "About to click next image",1)
		$iFileExists = FileExists($disImageArray[$i])

		If $iFileExists == 1 Then
			$result = _ImageSearch($disImageArray[$i],1,$xArray[$i],$yArray[$i],0)

			If $result = "True" Then
				MouseClick('primary', $xArray[$i], $yArray[$i], 1)	;Click on the image
			Else
				If $i == 1 Then										;Try clicking retest instead
					$result = _ImageSearch($retryImage,1,$xArray[$i],$yArray[$i],0)
					MsgBox(0,0,"We are testing retry image",1)
					If $result = "True" Then
						MouseClick('primary', $xArray[$i], $yArray[$i], 1)	;Click on the retry image (sometimes it may say testall, sometimes it may say retest)
					EndIf
				Else
					MsgBox(16,"Error!", "Image not found: Image# " & $i,5)	;We have a file in the directory to search for but did not find it
				EndIf
			EndIf
		EndIf
		$i=$i+1														;Used to increment for the array
		Sleep(700)													;Time between mouse clicks
	WEnd
EndFunc


Func ClickImageThenSS($disImageArray)
	Local $i = 0
	Local $iFileExists = 1

	While($iFileExists == 1)	;We want to keep looping until a file does not exist
		MsgBox(0,"Taking SS","About to click on SS",1)
		$iFileExists = FileExists($disImageArray[$i])

		If $iFileExists == 1 Then
			;**** Search for image ****
			$result = _ImageSearch($disImageArray[$i],1,$xArray[$i],$yArray[$i],0)

			If $result = "True" Then
				;*** Click Mouse ***
				MouseClick('primary', $xArray[$i], $yArray[$i], 1)	;Click on the image
				Sleep(250)
				;**** Take Screenshot ****
				TakeSS()
			Else
				;if screenshot not found (probably because the 'image to click' is now blue
				$result = _ImageSearch($retrySSImage,1,$xArray[$i],$yArray[$i],0)
				MsgBox(0,0,"We are testing retry image",1)
				;**** Mouse Click ****
				MouseClick('primary', $xArray[$i], $yArray[$i], 1)	;Click on the retry image (after running once, the click may be blue because we enabled it last time
				Sleep(250)
				;**** Take Screenshot ****
				TakeSS()
			EndIf
		EndIf
		$i=$i+1														;Used to increment for the array
		Sleep(500)													;Time between mouse clicks
	WEnd
EndFunc


Func TakeSS()
    ;Capture full screen
	Local $ssPath = @MyDocumentsDir & "\ss" & $ssNum & ".jpg"
	_ScreenCapture_Capture($ssPath)
	$ssNum = $ssNum + 1												;increment so the next screenshot is a different name
    ;ShellExecute(@MyDocumentsDir & "\GDIPlus_Image1.jpg")
EndFunc


Func ExitProgram()
	Exit
EndFunc   	;==>ExitProgram