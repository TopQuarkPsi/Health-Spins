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
'This activity can be either bonus 1 or bonus 2
Sub Process_Globals
	'variables from settings
	Public Level As Int = 3
	Public w(Level) As wheel
	Public hasmatched As Map

	Public hiscore As Int
	Dim background, rad, rad2 As BitmapData
	Dim timer1 As Timer
	Private fps As Float
	fps = 30
	Public Jackpot As Int = 2000
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
End Sub

Sub Globals
	'bvM
	Dim bvM As GameView
	Dim lblFPS As Label
	Public backrects(20) As Rect
	Private lasttime As Long
	Public wbd(Level) As BitmapData
	Public hasmatched As Map
	'interface
	Dim currentscore As Label
	Dim pressme As Button
	Public spinstarttime As Long
	Public interval As Long = 2500
	Public frames As Int = 60
	Dim Size1, vx, vy As Int 
	Size1 = 50dip
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	'Activity.LoadLayout("Layout1")
	background = CreateBackground
	rad.Bitmap  = LoadBitmap(File.DirAssets,"bonus.bmp")
	rad.DestRect.Initialize(100dip,50dip,100dip + Size1,50dip+Size1)
	vx = 25dip
	vy = 10dip
	If Prizecost.Bonustell = True Then
		rad2.Bitmap  = LoadBitmap(File.DirAssets,"myeye.bmp")
		rad2.DestRect.Initialize(50dip,100dip,50dip + Size1,100dip+Size1)
	End If
	bvM.Initialize("bvM")
	Activity.AddView(bvM,0,0,100%x,100%y)

	pressme.Initialize("pressme")
	Activity.AddView(pressme,5%x,80%y,90%x,15%y)
	currentscore.Initialize("currentscore")
	Activity.AddView(currentscore,5%x,5%y,90%x,15%y)
	currentscore.TextSize = 41
	pressme.TextSize = 30
	pressme.Text = "Press to spin"
		
	background = CreateBackground
	bvM.BitmapsData.Add(background)
	bvM.BitmapsData.Add(rad)
	If Prizecost.Bonustell = True Then
		bvM.BitmapsData.Add(rad2)
	End If

	For i = 0 To Level - 1
		w(i).Initialize(i+1,Level)
		wbd(i).Bitmap = LoadBitmapResize(File.DirAssets,"sprite90.bmp",size90,size90,True)
		bvM.BitmapsData.Add(wbd(i))
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
	

End Sub

Sub Activity_Resume
	hiscore = MainGame.hiscore
	currentscore.Text = hiscore
	timer1.Enabled = True
End Sub

Sub Activity_Pause (UserClosed As Boolean)
	CallSubDelayed(Starter,"puthiscoreb")
End Sub

Sub CreateBackground As BitmapData
	Dim bd As BitmapData
	bd.Bitmap.InitializeMutable(100%x,100%y)
	bd.SrcRect.Initialize(0,0,100%x,100%y)
	bd.DestRect.Initialize(0,0,100%x,100%y)
	Dim cvs As Canvas
	cvs.Initialize2(bd.Bitmap)

	For i = 0 To 19
		cvs.DrawCircle(50%x,50%y,i*7%y,Colors.ARGB(255,Rnd(0,256),Rnd(0,256),Rnd(0,256)),False,5dip)
	Next
	Dim destRect As Rect
	destRect.Initialize(0,0,100%x,100%y)
	cvs.DrawBitmap(cvs.Bitmap,bd.SrcRect,destRect)
	Return bd
End Sub

Sub pressme_Click
	Prizecost.Bonus1spinlimit = Prizecost.Bonus1spinlimit - 1
	If Prizecost.Bonus1spinlimit = 0 Then
		Activity.Finish
	End If
	pressme.Enabled = False
	spinstarttime = DateTime.Now
	currentscore.Text = hiscore
	Log("pressme")
End Sub

	'game in play
Sub prize
	If Prizecost.Bonustell = False Then
		Prizecost.bonus1prize
	Else
		Prizecost.bonus2prize
	End If
	Prizecost.bonuscleanup
	MainGame.hiscore = MainGame.hiscore + hiscore
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
	'Animate rad
	If rad.DestRect.Right > 99%x Then
		vx = -1 * Abs(vx)
	Else If rad.DestRect.Left < 1%x Then
		vx = Abs(vx)
	End If
	If rad.DestRect.Bottom > 99%y Then
		vy = -1 * Abs(vy)
	Else If rad.DestRect.Top < 1%y Then
		vy = Abs(vy)
	End If
	rad.DestRect.Left = rad.DestRect.Left + vx
	rad.DestRect.Top = rad.DestRect.Top + vy
	rad.DestRect.Right = rad.DestRect.Left + Size1
	rad.DestRect.Bottom = rad.DestRect.Top + Size1
	rad.Rotate = (rad.Rotate + 7) Mod 360
	
	'Animate rad2
	If Prizecost.Bonustell = True Then
		If rad2.DestRect.Right > 99%x Then
			vx = -1 * Abs(vx)
		Else If rad2.DestRect.Left < 1%x Then
			vx = Abs(vx)
		End If
		If rad2.DestRect.Bottom > 99%y Then
			vy = -1 * Abs(vy)
		Else If rad2.DestRect.Top < 1%y Then
			vy = Abs(vy)
		End If
		rad2.DestRect.Left = rad2.DestRect.Left + vx
		rad2.DestRect.Top = rad2.DestRect.Top + vy
		rad2.DestRect.Right = rad2.DestRect.Left + Size1
		rad2.DestRect.Bottom = rad2.DestRect.Top + Size1
		rad2.Rotate = (rad2.Rotate - 7) Mod 360
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
	bvM.Invalidate
End Sub
