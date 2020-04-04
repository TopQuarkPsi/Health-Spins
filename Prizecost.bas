B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=9.801
@EndOfDesignText@
'Code module
'Subs in this code module will be accessible from all modules.

'******This module is designed to handle the prizes and costs for the different levels
'********Levels will be unlocked according to the points thresholds
'**********penalties will be introduced after 500000 points
'*******Level 1 - 0 - 10000 points. 0 spincost - Bonus round 1 with easy jackpots. No HiLo
'*******Level 2 - 10k - 100k HiLo unlocked. Spincost = 3% of points. Bonus round 1 harder.
'********Level 3 - 100k - 250k. Bonus round 2 unlocked. spincost = 2% points, HiLo lose  = 5000, 
'HiLo win = 10k points. Bigger jackpots. Bonus rounds harder to get
'********Level 4 - 250k - 500k. Introduce hazards in bonus round (lose x%points). Spin cost = 1% points
'********Level 5 - 500k - 750k. Unlock Bonus round 3. Hazards everywhere. spincost 1000 points
'******Level 6 - 750k - 900k. spincost = 10k. bigger hazards. less small prizes.
'********Level 7 - 900k - 1M. Death Round. Win to complete

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Public Bonus1spinlimit As Int
	Public Bonustell As Boolean = False
	Public Jackpot As Int
	Public hiloprize As Int
End Sub

Sub level1
	MainGame.spincost = 0
	Jackpot = 3000
	Bonus1spinlimit = 10
	prizecheck	
	Jackpot = 10000
	bonus1check
	cleanup
End Sub	
Sub level2
	MainGame.spincost = 2000
	Jackpot = 10000
	Bonus1spinlimit = 5
	prizecheck
	hiloprize = 5000
	hiorlocheck
	Jackpot = 10000
	bonus1check
	Jackpot = 100000
	Bonus1spinlimit = 5
	bonus2check
	cleanup	
End Sub
	
Sub level3
	MainGame.spincost = 20000
	Jackpot = 100000
	Bonus1spinlimit = 6
	prizecheck
	hiloprize = 50000
	hiorlocheck
	Jackpot = 200000
	bonus1check
	Jackpot = 1000000
	Bonus1spinlimit = 5
	bonus2check
	cleanup
End Sub

Sub level4
	MainGame.spincost = 20000
	Jackpot = 5000000
	Bonus1spinlimit = 5
	prizecheck
	hiloprize = 500000
	hiorlocheck
	Jackpot = 1000000
	bonus1check
	Jackpot = 10000000
	Bonus1spinlimit = 5
	bonus2check
	cleanup
End Sub

Sub level5
	MainGame.spincost = 200000
	Jackpot = 10000
	Bonus1spinlimit = 5
	prizecheck
	hiloprize = 50000
	hiorlocheck
	Jackpot = 1000000
	bonus1check
	Jackpot = 10000000
	Bonus1spinlimit = 5
	bonus2check
	cleanup
End Sub

Sub level6
	MainGame.spincost = 1000000
	Jackpot = 10000
	Bonus1spinlimit = 3
	prizecheck
	hiloprize = 50000
	hiorlocheck
	bonus1check
	bonus2check
	cleanup
End Sub

Sub hiorlocheck
	For i = 0 To MainGame.prizematch.Length - 1
		If MainGame.hasmatched.Get(MainGame.prizematch(13)) >= 1 Then
			StartActivity(HiOrLo)
		End If
	Next
End Sub
Sub cleanup
	For i = 0 To MainGame.prizematch.Length - 1
		MainGame.hasmatched.Put(MainGame.prizematch(i),0)
	Next
End Sub
Sub prizecheck
	For i = 0 To MainGame.Level - 1
		Dim tmp As Int = 0
		tmp = MainGame.hasmatched.Get(MainGame.w(i).match)
		tmp = tmp + 1
		MainGame.hasmatched.Put(MainGame.w(i).match,tmp)
		tmp = 0
	Next
	
	For i = 0 To MainGame.prizematch.Length - 1
		If MainGame.hasmatched.GetValueAt(i) = MainGame.Level Then
			MainGame.hiscore = MainGame.hiscore + Jackpot
		Else If MainGame.hasmatched.GetValueAt(i) > 2 Then
			MainGame.hiscore = MainGame.hiscore + Jackpot/2
		Else If MainGame.hasmatched.GetValueAt(i) > 1 Then
			MainGame.hiscore = MainGame.hiscore + Jackpot/4
		End If
	Next
End Sub

Sub bonus1prize
	For i = 0 To Bonus1.Level - 1
		Dim tmp As Int = 0
		tmp = Bonus1.hasmatched.Get(Bonus1.w(i).match)
		tmp = tmp + 1
		Bonus1.hasmatched.Put(Bonus1.w(i).match,tmp)
		tmp = 0
	Next
	
	For i = 0 To Bonus1.prizematch.Length - 1
		If Bonus1.hasmatched.GetValueAt(i) = Bonus1.Level Then
			Bonus1.hiscore = Bonus1.hiscore + Jackpot
		Else If Bonus1.hasmatched.GetValueAt(i) > 2 Then
			Bonus1.hiscore = Bonus1.hiscore + Jackpot/2
		Else If Bonus1.hasmatched.GetValueAt(i) > 1 Then
			Bonus1.hiscore = Bonus1.hiscore + Jackpot/4
		End If
	Next
	bonuscleanup
End Sub
Sub bonus2prize
	For i = 0 To Bonus1.Level - 1
		Dim tmp As Int = 0
		tmp = Bonus1.hasmatched.Get(Bonus1.w(i).match)
		tmp = tmp + 1
		Bonus1.hasmatched.Put(Bonus1.w(i).match,tmp)
		tmp = 0
		If Bonus1.w(i).bonus1trigger = 69 Or Bonus1.w(i).bonus1trigger = 7  Then
			Bonus1.hiscore = Bonus1.hiscore*10
		End If
	Next
	
	For i = 0 To Bonus1.prizematch.Length - 1
		If Bonus1.hasmatched.GetValueAt(i) = Bonus1.Level Then
			Bonus1.hiscore = Bonus1.hiscore + Jackpot
		End If
	Next
	bonuscleanup
End Sub
Sub bonuscleanup
	For i = 0 To Bonus1.prizematch.Length - 1
		Bonus1.hasmatched.Put(Bonus1.prizematch(i),0)
	Next
End Sub

Sub bonus1check
	For i = 0 To MainGame.Level - 1
		If MainGame.w(i).bonus1trigger > 70 And MainGame.w(i).bonus1trigger < 79  Then
			Bonustell = False
			StartActivity(Bonus1)
		End If
	Next
End Sub

Sub bonus2check
	For i = 0 To MainGame.Level - 1
		If MainGame.w(i).bonus1trigger > 18 And MainGame.w(i).bonus1trigger < 21 Then
			Bonustell = True
			StartActivity(Bonus1)
		End If
	Next
End Sub