
' Minib3d

Type TUtility

	Function UpdateValue:Float( Current:Float,destination:Float,rate:Float )
	
		Current=Current+((destination-Current)*rate)
		Return Current
		
	End Function
	
End Type
