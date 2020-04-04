B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.801
@EndOfDesignText@
Sub Class_Globals
	Public leftpos, toppos As Int
	Public MaxColumns As Int = 10
	Public MaxRows As Int = 8
	Public spritesizex As Int = 100dip
	Public spritesizey As Int = 100dip
	Public move As Int
	Public SrcRect As Rect
	Public DestRect As Rect
	Public match As String
	Public bonus1trigger As Int
	Private minx, manx As Int
	Private count As Int
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(num As Int, Level As Int)
	leftpos = Rnd(0,10)
	toppos = Rnd(1,9)
	Dim factorx As Int
	factorx = 100 / MainGame.Level - (100 Mod MainGame.Level)
	SrcRect.Initialize(leftpos*spritesizex,toppos*spritesizey,leftpos*spritesizex + spritesizex, toppos*spritesizey + spritesizey)
	DestRect.Initialize(num*factorx*1%x + 2%x,40%y,num*factorx*1%x + factorx*1%x + 2%x,60%y)
End Sub

Sub getSrc As Rect
	Return SrcRect
End Sub

Sub getDest As Rect
	Return DestRect
End Sub

Sub spin As Rect
	minx = Rnd(1,59)
	manx = Rnd(60,101)
	move = Rnd(minx,manx)
	For count = 0 To move
		SrcRect.Top = SrcRect.Top + move
		SrcRect.Bottom = SrcRect.Bottom + spritesizey
		If SrcRect.Top > MaxRows * spritesizey Then
			SrcRect.Top = spritesizey
			SrcRect.Bottom = 2*spritesizey
			SrcRect.Left = SrcRect.Left + spritesizex
			SrcRect.Right = SrcRect.Right + spritesizex
			
			If SrcRect.Right > MaxColumns * spritesizex Then
				SrcRect.Left = 0
				SrcRect.Right = spritesizex
			End If
		End If
	Next
	SrcRect.Top = SrcRect.Top - (SrcRect.Top Mod spritesizey)
	SrcRect.Bottom = SrcRect.Top + spritesizey
	
	leftpos = SrcRect.Left/ spritesizex
	toppos = SrcRect.Top / spritesizey
	Log(toppos & leftpos)
	match = MainGame.shapes(MaxRows*(leftpos)+(toppos-1))
	bonus1trigger = MaxRows*(leftpos)+(toppos-1)
	Return SrcRect
End Sub

Sub gettop As Int
	Return toppos
End Sub

Sub getleft As Int
	Return leftpos
End Sub