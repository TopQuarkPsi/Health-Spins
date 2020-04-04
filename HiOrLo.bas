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
	Public hiloprize As Int = 1000
	Dim bg, bn As Bitmap
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
	Private Label1 As Label
	Private hi As Button
	Private Lo As Button
	Dim one, two As Int
	Dim spinsleep As Int = 40
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	bg.Initialize(File.DirAssets,"HiLobackground.bmp")
	bn.Initialize(File.DirAssets,"HiLobutton.bmp")
	Activity.SetBackgroundImage(bg)
	Label1.Initialize("Label1")
	Activity.AddView(Label1,30%x,30%y,40%x,40%y)
	Label1.TextSize = 81
	Label1.Text = "*"
	hi.Initialize("hi")
	hi.SetBackgroundImage(bn)
	Activity.AddView(hi,35%x,5%y,30%x,20%y)
	hi.Text = "Hi"
	Lo.Initialize("Lo")
	Lo.SetBackgroundImage(bn)
	Activity.AddView(Lo,35%x,75%y,30%x,20%y)
	Lo.Text = "Lo"
	Log("hiorlo started")
End Sub

Sub Activity_Resume
	one = Rnd(2,10)
	two = Rnd(2,10)
	hi.Enabled = False
	Lo.Enabled = False
	roll
	Log("roll done")
	hi.Enabled = True
	Lo.Enabled = True
End Sub

Sub Activity_Pause (UserClosed As Boolean)
End Sub

Sub roll
	For i = 1 To (15)
		
		Label1.Text = "|"
		Sleep(spinsleep)
		Label1.Text = "/"
		Sleep(spinsleep)
		Label1.Text = "-"
		Sleep(spinsleep)
		Label1.Text = "\"
		Sleep(spinsleep)
		Label1.Text = one
	Next
End Sub

Sub Hi_Click
	roll
	If two > one Then
		Label1.Text = "WIN"
		MainGame.hiscore = MainGame.hiscore + Prizecost.hiloprize
		Sleep(5*spinsleep)
	End If
	Activity.Finish
End Sub

Sub Lo_Click
	roll
	If two < one Then
		Label1.Text = "WIN"
		MainGame.hiscore = MainGame.hiscore + Prizecost.hiloprize
		Sleep(5*spinsleep)
	End If
	Activity.Finish
End Sub