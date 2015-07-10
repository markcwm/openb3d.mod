Type TColTree

	Field c_col_tree:Byte Ptr=Null
	Field reset_col_tree:Int=False

	Method New()
	
		If LOG_NEW
			DebugLog "New TColTree"
		EndIf
	
	End Method
	
	Method Delete()
	
		'If c_col_tree<>Null
			'C_DeleteColTree(c_col_tree)
			'c_col_tree=Null
		'EndIf
	
		If LOG_DEL
			DebugLog "Del TColTree"
		EndIf
	
	End Method
	
	' creates a collision tree for a mesh if necessary
	Method TreeCheck(mesh:TMesh)

		
						
	End Method
	
End Type
