; #INDEX# =======================================================================================================================
; Title .........: _StringsEx
; AutoIt Version : 3.3.10 +
; Language ......: English
; Description ...: Custom string functions to simplify some common usages.
; Author ........: Sam Coates (inpho)
; ===============================================================================================================================

#AutoIt3Wrapper_Au3Check_Parameters=-d -w- 1 -w 2 -w 3 -w 4 -w 5 -w 6

; #INCLUDES# ====================================================================================================================
#include-once

; #CURRENT# =====================================================================================================================
; _StringsEx_DateTimeGet:					Returns the date and time formatted for use in sortable filenames, logs, listviews, etc.
; _StringsEx_FileToFileExtension:			Returns a file extension from a filename/FQPN (Fully Qualified Path Name).
; _StringsEx_FileToFileName:				Returns a filename from a FQPN (Fully Qualified Path Name).
; _StringsEx_FileToFilePath:				Returns a folder path from a FQPN (Fully Qualified Path Name).
; _StringsEx_StringLeft:					Searches for a string inside a string, then removes everything from the right of it.
; _StringsEx_StringRandom:					Returns a string of random characters.
; _StringsEx_StringToType:					Converts a string to the relevant datatype.
; _StringsEx_StringTrimLeft:				Searches for a string inside a string, then removes everything from the left of it.
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name ..........:	_StringsEx_DateTimeGet
; Description ...:	Returns the date and time formatted for use in sortable filenames, logs, listviews, etc.
; Syntax ........:	_StringsEx_DateTimeGet(iType = 1[, $bHumanFormat = False])
; Parameters ....:	$iType				- [optional] Integer. Default is 1.
;										1 - Date and time in file-friendly format; 20190115_113756
;										2 - Date in file-friendly format; 20190115
;										3 - Time in file friendly format; 113756
;                 	$bHumanFormat		- [optional] Boolean. Default is False.
;										True - Includes slashes in the date and colons in the time with a space inbetween
;										False - No slashes or colons included with an underscore inbetween
; Return values .:	Success				- String
;					Failure				- Sets @error to non-zero and returns an empty string
; Author ........:	Sam Coates (inpho)
; ===============================================================================================================================
Func _StringsEx_DateTimeGet($iType = 1, $bHumanFormat = False)

	If $iType < 1 Or $iType > 3 Then Return (SetError(-1, 0, ""))

	;; Param1:
	;; 1 = Date and time in file friendly format: 	20190115_113756
	;; 2 = Date in file friendly format:			20190115
	;; 3 = Time in file friendly format:			113756

	;; Param2:
	;; True = Use human-readable format:			15/01/2019 11:37:56

	Local $sTime = @HOUR & ":" & @MIN & ":" & @SEC
	Local $sDate = @MDAY & "/" & @MON & "/" & @YEAR

	If $iType = 1 Then
		If $bHumanFormat = False Then
			$sTime = StringReplace($sTime, ":", "")
			$sDate = StringReplace($sDate, "/", "")
			$sDate = StringTrimLeft($sDate, 4) & StringMid($sDate, 3, 2) & StringLeft($sDate, 2)
			Return ($sDate & "_" & $sTime)
		Else
			Return ($sDate & " " & $sTime)
		EndIf
	ElseIf $iType = 2 Then
		If $bHumanFormat = False Then
			$sDate = StringReplace($sDate, "/", "")
			$sDate = StringTrimLeft($sDate, 4) & StringMid($sDate, 3, 2) & StringLeft($sDate, 2)
		EndIf
		Return ($sDate)
	ElseIf $iType = 3 Then
		If $bHumanFormat = False Then
			$sTime = StringReplace($sTime, "/", "")
		EndIf
		Return ($sTime)
	EndIf

EndFunc   ;==>_StringsEx_DateTimeGet

; #FUNCTION# ====================================================================================================================
; Name ..........:	_StringsEx_FileToFileExtension
; Description ...:	Returns a file extension from a filename/FQPN (Fully Qualified Path Name).
; Syntax ........:	_StringsEx_FileToFileExtension($sPath)
; Parameters ....:	$sPath				- String. The path to return the extension from
; Return values .:	Success 			- String
;					Failure				- Empty string as returned from StringTrimLeft()
; Author ........:	Sam Coates (inpho)
; ===============================================================================================================================
Func _StringsEx_FileToFileExtension($sPath)

	Return (StringTrimLeft($sPath, StringInStr($sPath, ".", 0, -1)))

EndFunc   ;==>_StringsEx_FileToFileExtension

; #FUNCTION# ====================================================================================================================
; Name ..........:	_StringsEx_FileToFileName
; Description ...:	Returns a filename from a FQPN (Fully Qualified Path Name).
; Syntax ........:	_StringsEx_FileToFileName($sPath[, $bIncludeExtension = True])
; Parameters ....:	$sPath				- String. The path to return the filename from
;                 	$bIncludeExtension	- [optional] Boolean. Whether to include extension. Default is True.
; Return values .:	Success 			- String
;					Failure				- Empty string as returned from StringLeft()
; Author ........:	Sam Coates (inpho)
; ===============================================================================================================================
Func _StringsEx_FileToFileName($sPath, $bIncludeExtension = True)

	Local $sReturn = StringTrimLeft($sPath, StringInStr($sPath, "\", 0, -1))
	If $bIncludeExtension = False Then $sReturn = StringLeft($sReturn, StringInStr($sReturn, ".", 0, -1) - 1)
	Return ($sReturn)

EndFunc   ;==>_StringsEx_FileToFileName

; #FUNCTION# ====================================================================================================================
; Name ..........:	_StringsEx_FileToFilePath
; Description ...:	Returns a folder path from a FQPN (Fully Qualified Path Name).
; Syntax ........:	_StringsEx_FileToFilePath($sPath)
; Parameters ....:	$sPath				- String. The file path you want to extract the path from.
; Return values .:	Success 			- String. The directory $sPath is in.
;					Failure				- Empty string as returned from StringLeft()
; Author ........:	Sam Coates (inpho)
; ===============================================================================================================================
Func _StringsEx_FileToFilePath($sPath)

	Return (StringLeft($sPath, StringInStr($sPath, "\", 0, -1) - 1))

EndFunc   ;==>_StringsEx_FileToFilePath

; #FUNCTION# ====================================================================================================================
; Name ..........: _StringsEx_StringLeft
; Description ...: Searches for a string inside a string, then removes everything from the right of it.
; Syntax ........: _StringsEx_StringLeft($sString, $sRemove[, $iCaseSense = 0[, $iOccurrence = 1]])
; Parameters ....: 	$sString            - String. The string to search inside.
;                  	$sRemove            - String. The string to search for.
;                  	$iCaseSense			- Integer. Flag to indicate if the operations should be case sensitive.
;                  	$iOccurrence		- Integer. Which occurrence of the substring to find in the string. Use a
;										  negative occurrence to search from the right side.
; Return values .: 	Success				- String
;					Failure				- Empty string as returned from StringLeft()
; Author ........: 	Sam Coates (inpho)
; ===============================================================================================================================
Func _StringsEx_StringLeft($sString, $sRemove, $iCaseSense = 0, $iOccurrence = 1)

	Return (StringLeft($sString, StringInStr($sString, $sRemove, $iCaseSense, $iOccurrence) - 1))

EndFunc   ;==>_StringsEx_StringLeft

; #FUNCTION# ====================================================================================================================
; Name ..........: _StringsEx_StringRandom
; Description ...: Returns a string of random characters.
; Syntax ........: _StringsEx_StringRandom($iAmount[, $iType = 1])
; Parameters ....: 	$iAmount            - Integer. Length of returned string
;                  	$iType              - [optional] Integer. Default is 1.
;										1 - Return digits (0-9)
;										2 - Return hexadecimal (0-9, A - F)
;										3 - Return Alphanumeric upper (0-9, A - Z)
;										4 - Return Alphanumeric (0-9, A - Z, a - z)
;										5 - Return Alpha upper (A - Z)
;										6 - Return Alpha (A - Z, a - z)
; Return values .: 	Success 			- String
;					Failure				- Empty string and @error flag as follows:
;					@error : 			1 - $iAmount is not a positive integer
;										2 - $iType is out of bounds
; Author ........: 	Sam Coates (inpho)
; ===============================================================================================================================
Func _StringsEx_StringRandom($iAmount, $iType = 1)

	If $iAmount < 1 Or IsInt($iAmount) = 0 Then Return (SetError(-1, 0, ""))

	Local $sString = ""
	Local $iRandomLow = 1, $iRandomHigh = 62

#Tidy_Off
	Local Static $aCharId[63] = [0, Chr(48), Chr(49), Chr(50), Chr(51), Chr(52), Chr(53), Chr(54), Chr(55), Chr(56), Chr(57), Chr(65), Chr(66), Chr(67), _
									Chr(68), Chr(69), Chr(70), Chr(71), Chr(72), Chr(73), Chr(74), Chr(75), Chr(76), Chr(77), Chr(78), Chr(79), Chr(80), _
									Chr(81), Chr(82), Chr(83), Chr(84), Chr(85), Chr(86), Chr(87), Chr(88), Chr(89), Chr(90), Chr(97), Chr(98), Chr(99), _
									Chr(100), Chr(101), Chr(102), Chr(103), Chr(104), Chr(105), Chr(106), Chr(107), Chr(108), Chr(109), Chr(110), Chr(111), _
									Chr(112), Chr(113), Chr(114), Chr(115), Chr(116), Chr(117), Chr(118), Chr(119), Chr(120), Chr(121), Chr(122)]
#Tidy_On

	If $iType = 1 Then ;; digits: 1 - 10
		$iRandomHigh = 10
	ElseIf $iType = 2 Then ;; hexadecimal: 1 - 16
		$iRandomHigh = 16
	ElseIf $iType = 3 Then ;; alnumupper: 1 - 36
		$iRandomHigh = 36
	ElseIf $iType = 4 Then ;; alnum: 1 - 62
		$iRandomHigh = 62
	ElseIf $iType = 5 Then ;; alphaupper: 11 - 36
		$iRandomLow = 11
		$iRandomHigh = 36
	ElseIf $iType = 6 Then ;; alpha: 11 = 62
		$iRandomLow = 11
		$iRandomHigh = 62
	Else
		Return (SetError(-2, 0, ""))
	EndIf

	For $i = 1 To $iAmount
		$sString &= $aCharId[Random($iRandomLow, $iRandomHigh, 1)] ;; append string with corresponding random character from ascii array
	Next

	Return ($sString)

EndFunc   ;==>_StringsEx_StringRandom

; #FUNCTION# ====================================================================================================================
; Name ..........:	_StringsEx_StringToType
; Description ...:	Converts a string to the relevant datatype.
; Syntax ........:	_StringsEx_StringToType($vData)
; Parameters ....:	$vData				- A variant value
; Return values .:	Success				- Value dependant on input. Datatype is also dependant on input
;					Failure				- Original string
; Author ........:	Rex?
; ===============================================================================================================================
Func _StringsEx_StringToType($vData)
	; Converts a string to bool, Number or KeyWord
	Local $aData = StringRegExp($vData, "\bTrue\b|\bFalse\b|\bNull\b|\bDefault\b|\d{1,}", 3)
	If Not IsArray($aData) Then Return $vData
	Switch $aData[0]
		Case 'True'
			Return True
		Case 'False'
			Return False
		Case 'Null'
			Return Null
		Case 'Default'
			Return Default
		Case Else
			Return Number($aData[0])
	EndSwitch
EndFunc   ;==>_StringsEx_StringToType

; #FUNCTION# ====================================================================================================================
; Name ..........: _StringsEx_StringTrimLeft
; Description ...: Searches for a string inside a string, then removes everything from the left of it.
; Syntax ........: _StringsEx_StringTrimLeft($sString, $sRemove[, $iCaseSense = 0[, $iOccurrence = 1]])
; Parameters ....: 	$sString            - String. The string to search inside.
;                  	$sRemove            - String. The string to search for.
;                  	$iCaseSense			- Integer. Flag to indicate if the operations should be case sensitive.
;                  	$iOccurrence		- Integer. Which occurrence of the substring to find in the string. Use a
;										  negative occurrence to search from the right side.
; Return values .: 	Success				- String
;					Failure				- Empty string as returned from StringTrimLeft()
; Author ........: 	Sam Coates (inpho)
; ===============================================================================================================================
Func _StringsEx_StringTrimLeft($sString, $sRemove, $iCaseSense = 0, $iOccurrence = 1)

	Return (StringTrimLeft($sString, StringInStr($sString, $sRemove, $iCaseSense, $iOccurrence) + StringLen($sRemove) - 1))

EndFunc   ;==>_StringsEx_StringTrimLeft
