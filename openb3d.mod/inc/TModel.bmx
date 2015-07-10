Type TModel

	Function LoadAnimB3D:TMesh(f_name$,parent_ent_ext:TEntity=Null)
	
		
	
	End Function

	' Due to the .b3d format not being an exact fit with B3D, we need to slice vert arrays
	' Otherwise we duplicate all vert information per surf
	Function TrimVerts(surf:TSurface Var)
				
		
		
	End Function

	Function b3dReadString:String(file:TStream Var)
	
		
		
	End Function
	
	Function ReadTag$(file:TStream)
		
		
		
	End Function
	
	Function NewTag:Int(tag$)
	
		
	
	End Function

End Type
