B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=9.801
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Public hiscore As Int
	Public DIRTYEGO As Typeface
	Private img, background As Bitmap
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Private leave As Button
	Private score As Label
	Private view As Button
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	background.Initialize(File.DirAssets,"psychotic.jpg")
	Activity.SetBackgroundImage(background)


	img.Initialize(File.DirAssets,"psychotic3.jpg")
	leave.Initialize("leave")
	leave.SetBackgroundImage(img)
	Activity.AddView(leave,10%x,70%y,80%x,10%y)
	view.Initialize("view")
	view.SetColorAnimated(500,Colors.Black,Colors.Yellow)
	Activity.AddView(view,10%x,10%y,80%x,10%y)

	score.Initialize("")
	DIRTYEGO = Typeface.LoadFromAssets("DIRTYEGO.TTF")
	Activity.AddView(score,10%x,50%y,80%x,10%y)
	score.Color = Colors.Cyan
	score.TextColor = Colors.White
	score.TextSize = 40
	score.Typeface = DIRTYEGO

	view.Text = "View High scores"
	leave.Typeface = DIRTYEGO
	leave.TextSize = 30
	leave.TextColor = Colors.DarkGray
	leave.Text = "Exit Game"

End Sub

Sub Activity_Resume
	score.Text = Starter.hiscore
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub
Sub leave_Click
	Log("settings - before msg")
	Msgbox2Async("Are you sure you want to Quit?","Leave Game","Yes please","","No, continue game",img,False)	
	Wait For Msgbox_Result (result As Int)
	Log("settings - after msg")
	If result = DialogResponse.POSITIVE Then
		Log("settings - yes")
		CallSubDelayed(Starter,"puthiscore")
		StartActivity(Main)
		Activity.Finish
	Else
		Log("settings - no")
		StartActivity(MainGame)
		Activity.Finish
	End If
End Sub
Sub view_Click
	For i = 0 To Starter.scores.Size - 1
		MsgboxAsync(Starter.scores.GetKeyAt(i) & " - " & Starter.scores.GetValueAt(i),"Player " & i)
	Next
End Sub
