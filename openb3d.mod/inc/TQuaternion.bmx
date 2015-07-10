Type TQuaternion

	Field w#,x#,y#,z#

	Method New()
	
		If LOG_NEW
			DebugLog "New TQuaternion"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TQuaternion"
		EndIf
	
	End Method

	Function QuatToMat(w#,x#,y#,z#,mat:TMatrix Var)
	
		
	
	End Function
	
	Function QuatToEuler(w#,x#,y#,z#,pitch# Var,yaw# Var,roll# Var)
	
		
	
	End Function
			
	Function Slerp:Int(Ax#,Ay#,Az#,Aw#,Bx#,By#,Bz#,Bw#,Cx# Var,Cy# Var,Cz# Var,Cw# Var,t#)
	
		
		
	End Function
		
End Type
