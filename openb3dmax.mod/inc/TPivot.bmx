
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
		ent_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		Super.InitFields()
				
	End Method
	
	Method DebugFields( debug_subobjects:Int=0,debug_base_types:Int=0 )
	
		Local pad:String
		Local loop:Int=debug_subobjects
		If debug_base_types>debug_subobjects Then loop=debug_base_types
		For Local i%=1 Until loop
			pad:+"  "
		Next
		If debug_subobjects Then debug_subobjects:+1
		If debug_base_types Then debug_base_types:+1
		DebugLog pad+" Pivot instance: "+StringPtr(GetInstance(Self))
		
		DebugLog ""
		
		If debug_base_types Then Super.DebugFields( debug_subobjects,debug_base_types )
		
	End Method
	
	' Minib3d
	
	Method New()
	
		If TGlobal.Log_New
			DebugLog " New TPivot"
		EndIf
		
	End Method
	
	Method Delete()
	
		If TGlobal.Log_Del
			DebugLog " Del TPivot"
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
