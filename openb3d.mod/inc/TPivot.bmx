Rem
bbdoc: Pivot entity
End Rem
Type TPivot Extends TEntity

	' Create and map object from C++ instance
	Function NewObject:TPivot( inst:Byte Ptr )
	
		Local obj:TPivot=New TPivot
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TPivot"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TPivot"
		EndIf
	
	End Method
	
	Method CopyEntity:TPivot( parent:TEntity=Null )
	
		Local instance:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return NewObject(instance)
		
	End Method
	
	Method Update()
	
		
		
	End Method
	
	Method FreeEntity()
	
		Super.FreeEntity() 
			
	End Method
	
	Function CreatePivot:TPivot( parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreatePivot_( GetInstance(parent) )
		Return NewObject(instance)
		
	End Function
	
End Type
