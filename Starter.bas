B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Service
Version=9.801
@EndOfDesignText@
#Region  Service Attributes 
	#StartAtBoot: False
	#ExcludeFromLibrary: True
#End Region

Sub Process_Globals
	'The Service module will act to load and save the hi score, load settings etc 
	Public hiscore As Int
	Public scores As Map
End Sub

Sub Service_Create
	'This is the program entry point.
	'This is a good place to load resources that are not specific to a single activity.
	scores.Initialize
	If File.Exists(File.DirInternal,"scores.txt") Then
		scores = File.Readmap(File.DirInternal, "scores.txt")
		Else
		Private mrRandom As String = "Chipotle"
		scores.Put(mrRandom,2)
		File.WriteMap(File.DirInternal,"scores.txt",scores)
	End If
End Sub

Sub Service_Start (StartingIntent As Intent)
	Service.StopAutomaticForeground 'Starter service can start in the foreground state in some edge cases.
End Sub

Sub Service_TaskRemoved
	'This event will be raised when the user removes the app from the recent apps list.
End Sub

'Return true to allow the OS default exceptions handler to handle the uncaught exception.
Sub Application_Error (Error As Exception, StackTrace As String) As Boolean
	Return True
End Sub

Sub Service_Destroy

End Sub
Sub newuser
	scores.Put(Main.name, 1000)
	File.WriteMap(File.DirInternal,"scores.txt",scores)
	hiscore = 1000
	
End Sub
Sub puthiscore
	hiscore = MainGame.hiscore
	scores.Put(Main.name, hiscore)
	File.WriteMap(File.DirInternal,"scores.txt",scores)
End Sub

Sub puthiscoreb
	hiscore = Bonus1.hiscore
	scores.Put(Main.name, hiscore)
	File.WriteMap(File.DirInternal,"scores.txt",scores)
End Sub

