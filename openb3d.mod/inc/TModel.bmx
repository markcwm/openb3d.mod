
Rem
Type TModel

	' Minib3d
	
	' called by LoadAnimMesh and LoadAnimSeq
	Function LoadAnimB3D:TMesh( f_name$,parent_ent_ext:TEntity=Null )
	
		
		
	End Function
	
	' Due to the .b3d format not being an exact fit with B3D, we need to slice vert arrays
	' Otherwise we duplicate all vert information per surf
	Function TrimVerts( surf:TSurface Var )
			
		
		
	End Function
	
	' called by LoadAnimB3D
	Function b3dReadString:String( file:TStream Var )
	
		
		
	End Function
	
	' called by LoadAnimB3D
	Function ReadTag$( file:TStream )
	
		
		
	End Function
	
	' called by LoadAnimB3D
	Function NewTag:Int( tag$ )
	
		
		
	End Function
	
End Type
EndRem
