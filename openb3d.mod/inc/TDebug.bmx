Type TDebug
	
	Global cno:Int ' child no (numpad keys - + to change)
	Global surf_no:Int ' surf no (numpad keys / * to change)
	
	Global info:Int=1 ' current info page (numpad keys 1-4)
	Global show_ents:Int=True ' show/hide debug ents (key 0)
	
	' debug entities
	Global bounding_sphere:TMesh
	Global debug_mesh:TMesh
	Global debug_surf:TSurface
	Global marker:TMesh

	Function DebugWorld()
	
		
	
	End Function

	Function DebugEntity:TEntity(ent:TEntity,cam:TCamera=Null)

		
	
	End Function

	Function UpdateBoundingSphere(ent:TEntity)
			
		
		
	End Function
	
	Function UpdateSurface(ent:TEntity,surf:TSurface)

		
	
	End Function
	
	Function UpdateMarker(ent:TEntity,cam:TCamera)
	
		
				
	End Function
	
	Function EntityInfo1(ent:TEntity) ' entity info
	
		
	
	End Function
	
	Function EntityInfo2(ent:TEntity,surf:TSurface) ' surface info
	
		
				
	End Function
	
	Function EntityInfo3(ent:TEntity,surf:TSurface) ' brush info
		
		
		
	End Function

	Function EntityInfo4(ent:TEntity,cam:TCamera) ' cam info
	
		
				
	End Function
	
End Type
