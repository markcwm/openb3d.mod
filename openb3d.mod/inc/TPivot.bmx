
Rem
bbdoc: Pivot entity
End Rem
Type TPivot Extends TEntity

	Function CreateObject:TPivot( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TPivot=New TPivot
	?bmxng
		ent_map.Insert( inst,obj )
	?Not bmxng
		ent_map.Insert( String(Long(inst)),obj )
	?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		Super.InitFields()
				
	End Method
	
	' Minib3d
	
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
	
	Method FreeEntity()
	
		Super.FreeEntity() 
			
	End Method
	
	Function CreatePivot:TPivot( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreatePivot_( GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	' Internal
	
	Method CopyEntity:TPivot( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Local pivot:TPivot=CreateObject(inst)
		If pick_mode[0] Then TPick.AddList_(TPick.ent_list)
		Return pivot
		
	End Method
	
	Method Update() ' empty
	
		
		
	End Method
	
End Type
