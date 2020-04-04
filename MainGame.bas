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
	'variables from settings
	Public Level As Int = 5
	Public offset As Int = 15
	'MainGame will be the Activity to display the slots levels according to saved settings HiOrLo, BonusGame and Settings will be accessible from here
	Dim background As BitmapData
	Dim timer1 As Timer
	Private fps As Float
	fps = 30
	Private scale As Int : scale = 5
	Public spincost As Int 
	Public Jackpot As Int = 500
	Public sprite90 As BitmapData
	Public size90 As Int = 1000dip
	Public prizematch() As String
	prizematch = Array As String("up","rt","dn","4s","lt","pent","sq","hx","6s","tsq","bon","tri","cir","5s")
	Public shapes() As String
	shapes = Array As String("up","rt","dn","4s","lt","pent","sq","hx", _
							"dn","4s","lt","rt","6s","hx","tsq","bon", _
							"lt","tri","up","dn","pent","sq","4s","rt", _
							"up","cir","tri","6s","hx","tsq","pent","4s", _
							"4s","lt","hx","tsq","sq","tri","rt","up", _
							"hx","sq","cir","lt","dn","pent","4s","5s", _
							"6s","up","tsq","sq","tri","cir","dn","5s", _
							"sq","lt","up","cir","pent","rt","up","tri", _
							"4s","tsq","pent","rt","up","4s","cir","5s", _
							"bon","sq","rt","bon","pent","6s","5s","4s")
	Public hiscore As Int 
	Public hasmatched As Map
	Public w(Level) As wheel
End Sub

Sub Globals
	'gvM
	Dim gvM As GameView
	Dim lblFPS As Label
	Public backrects(20) As Rect
	Private lasttime As Long
	Public wbd(Level) As BitmapData
	'interface
	Dim settingsbtn As Button
	Dim currentscore As Label
	Dim pressme As Button
	Public spinstarttime As Long
	Public interval As Long = 2500
	Public frames As Int = 60
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	background = CreateBackground
	gvM.Initialize("gvM")
	Activity.AddView(gvM,0,0,100%x,100%y)

	settingsbtn.Initialize("settingsbtn")
	Activity.AddView(settingsbtn,55%x,80%y,40%x,15%y)
	pressme.Initialize("pressme")
	Activity.AddView(pressme,5%x,80%y,40%x,15%y)
	currentscore.Initialize("currentscore")
	Activity.AddView(currentscore,5%x,5%y,90%x,15%y)
	settingsbtn.Text = "Settings"
	pressme.TextSize = 18
	pressme.Text = "Press to spin"
		
	background = CreateBackground
	gvM.BitmapsData.Add(background)

	For i = 0 To Level - 1
		w(i).Initialize(i,Level)
		wbd(i).Bitmap = LoadBitmapResize(File.DirAssets,"sprite90.bmp",size90,size90,True)
		gvM.BitmapsData.Add(wbd(i))
		wbd(i).SrcRect = w(i).getSrc
		wbd(i).DestRect = w(i).getDest
	Next
	hasmatched.Initialize
	For i = 0 To prizematch.Length - 1
		hasmatched.Put(prizematch(i),0)
	Next

	lblFPS.Initialize("")
	lblFPS.TextSize = 18
	lblFPS.TextColor = Colors.White
	Activity.AddView(lblFPS,0,100%y-30dip,50dip,30dip)
	timer1.Initialize("Timer1",frames)
	currentscore.TextSize = 48

End Sub

Sub Activity_Resume
	hiscore = Starter.hiscore
	currentscore.Text = hiscore
	timer1.Enabled = True
End Sub

Sub Activity_Pause (UserClosed As Boolean)
	CallSubDelayed(Starter,"puthiscore")
End Sub

Sub CreateBackground As BitmapData
	Dim bd As BitmapData
	bd.Bitmap.InitializeMutable(100%x,100%y)
	bd.SrcRect.Initialize(0,0,100%x,100%y)
	bd.DestRect.Initialize(0,0,100%x,100%y)
	Dim cvs As Canvas
	cvs.Initialize2(bd.Bitmap)
	For j = 0 To 9
		backrects(j).Initialize(50%x - (j * scale * 1%x + 3dip),50%y - (j * scale * 1%y - 3dip),50%x + (j * scale * 1%x - 3dip),50%y + (j * scale * 1%y - 3dip))
	Next

	For i = 0 To 9
		cvs.DrawRect(backrects(i),Colors.ARGB(255,Rnd(0,256),Rnd(0,256),Rnd(0,256)),False,3dip)
	Next
	Dim destRect As Rect
	destRect.Initialize(0,0,100%x,100%y)
	cvs.DrawBitmap(cvs.Bitmap,bd.SrcRect,destRect)
	Return bd
End Sub

Sub pressme_Click
	hiscore = hiscore - spincost
	pressme.Enabled = False
	If hiscore < 10 Then
		Msgbox2Async("Would you like to start again at 1000 points?","Low score - Not enough points!","Yes","","No",Null,False)
		Wait For Msgbox_Response (result As Int)
		If result = DialogResponse.POSITIVE Then
			hiscore = 1000
		Else	
		Activity.Finish
		End If
	End If
	spinstarttime = DateTime.Now
	currentscore.Text = hiscore
	Log("pressme")
End Sub
Sub settingsbtn_Click
	Starter.hiscore = hiscore
	Activity.Finish
	StartActivity(Settings)
End Sub

	'game in play
Sub prize
	If hiscore < 10000 Then
		Prizecost.level1
	Else If hiscore >= 10000 And hiscore < 100000 Then
		Prizecost.level2
	Else If hiscore >= 100000 And hiscore < 500000 Then
		Prizecost.level3
	Else If hiscore >= 500000 And hiscore < 1000000 Then
		Prizecost.level4
	Else If hiscore >= 1000000 And hiscore < 10000000 Then
		Prizecost.level5
	Else
		Prizecost.level6
	End If
	currentscore.Text = hiscore
End Sub

Sub Timer1_Tick
	fps = (1000/ Max(10, (DateTime.Now - lasttime)) + 20*fps)/21
	lblFPS.Text = NumberFormat(fps, 0,0)
	lasttime = DateTime.Now
	If DateTime.Now < spinstarttime + interval Then
		Log("about to spin")
		For i = 0 To Level - 1
			wbd(i).SrcRect = w(i).spin
		Next
		Log("spun")
	Else If DateTime.Now < spinstarttime + interval + 2*frames Then
		pressme.Enabled = True
		prize
	End If
	
	'Animate background
	If background.SrcRect.Left > 35%x Then
		background.SrcRect.Left = 0
		background.SrcRect.Right = 100%x
		background.SrcRect.Top = 0
		background.SrcRect.Bottom = 100%y
	End If
		background.SrcRect.Left = (background.SrcRect.Left + 2%x)
		background.SrcRect.Right = (background.SrcRect.Right - 2%x)
		background.SrcRect.Top = (background.SrcRect.Top + 2%y)
		background.SrcRect.Bottom = (background.SrcRect.Bottom - 2%y)
	gvM.Invalidate
End Sub
