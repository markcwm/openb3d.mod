Rem
bbdoc: Vector
EndRem
Type TVector

	Field x#,y#,z#
	
	Const EPSILON:Float=.0001

	Method New()
	
		If LOG_NEW
			DebugLog "New TVector"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TVector"
		EndIf
	
	End Method

	Function Create:TVector(x#,y#,z#)
	
		
		
	End Function
	
	Method Copy:TVector()
	
		
	
	End Method
	
	Method Add:TVector(vec:TVector)
	
		
	
	End Method
	
	Method Subtract:TVector(vec:TVector)
	
		
	
	End Method
	
	Method Multiply:TVector(val#)
	
		
	
	End Method
	
	Method Divide:TVector(val#)
	
		
	
	End Method
	
	Method Dot:Float(vec:TVector)
	
		'Return (x#*vec.x#)+(y#*vec.y#)+(z#*vec.z#)
	
	End Method
	
	Method Cross:TVector(vec:TVector)
	
		
	
	End Method
	
	Method Normalize()
	
		
		
	End Method
	
	Method Length:Float()
			
		'Return Sqr(x*x+y*y+z*z)

	End Method
	
	Method SquaredLength:Float()
	
		'Return x*x+y*y+z*z

	End Method
	
	Method SetLength:Float(val#)
	
		

	End Method
	
	Method Compare:Int( with:Object )
	
		
		
	End Method
	
	' Function by patmaba
	Function VectorYaw:Float( vx:Float,vy:Float,vz:Float )
	
		Return VectorYaw_( vx,vy,vz )
		
	End Function
	
	' Function by patmaba
	Function VectorPitch:Float( vx:Float,vy:Float,vz:Float )
	
		Return -VectorPitch_( vx,vy,vz ) ' inverted pitch
		
	End Function
	
End Type
