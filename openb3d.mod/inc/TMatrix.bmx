Type TMatrix

	Field grid#[4,4]
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TMatrix"
		EndIf

	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TMatrix"
		EndIf

	End Method
	
	Method LoadIdentity()
	
		
	
	End Method
	
	' copy - create new copy and returns it
	
	Method Copy:TMatrix()
	
		
	
	End Method
	
	' overwrite - overwrites self with matrix passed as parameter
	
	Method Overwrite(mat:TMatrix)
	
		
		
	End Method
	
	Method Inverse:TMatrix()

		

	End Method

	Method Multiply(mat:TMatrix)
	
		
		
	End Method

	Method Translate(x#,y#,z#)
	
		

	End Method
		
	Method Scale(x#,y#,z#)
	
		
	
	End Method
	
	Method Rotate(rx#,ry#,rz#)
	
		
	
	End Method
	
	Method RotatePitch(ang#)
	
		

	End Method
	
	Method RotateYaw(ang#)
	
		

	End Method
	
	Method RotateRoll(ang#)
	
		

	End Method
		
End Type
