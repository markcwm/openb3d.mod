Rem
bbdoc: Light entity
End Rem
Type TLight Extends TEntity

	Global light_no:Int=0
	Global no_lights:Int=0
	Global max_lights:Int=8
	
	' enter gl consts here for each available light
	Global gl_light:Int[]=[GL_LIGHT0,GL_LIGHT1,GL_LIGHT2,GL_LIGHT3,GL_LIGHT4,GL_LIGHT5,GL_LIGHT6,GL_LIGHT7]

	Global light_list:TList=CreateList()

	Field light_type:Int=0
	Field Range#=1.0/1000.0
	Field red#=1.0,green#=1.0,blue#=1.0
	Field inner_ang#=0.0,outer_ang#=45.0
	
	' Create and map object from C++ instance
	Function NewObject:TLight( inst:Byte Ptr )
	
		Local obj:TLight=New TLight
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TLight"
		EndIf
		
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TLight"
		EndIf
	
	End Method
	
	Method CopyEntity:TLight( parent:TEntity=Null )

		Local instance:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return NewObject(instance)
		
	End Method
	
	Method Update()

		
																	
	End Method		
	
	Method FreeEntity()
	
		Super.FreeEntity()
		
	End Method
	
	Function CreateLight:TLight( light_type:Int=1,parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateLight_( light_type,GetInstance(parent) )
		Return NewObject(instance)
		
	End Function
	
	Method LightRange( Range:Float )
	
		LightRange_( GetInstance(Self),Range )
		
	End Method
	
	Method LightColor( red:Float,green:Float,blue:Float )
	
		LightColor_( GetInstance(Self),red,green,blue )
		
	End Method
	
	Method LightConeAngles( inner_ang:Float,outer_ang:Float )
	
		LightConeAngles_( GetInstance(Self),inner_ang,outer_ang )
		
	End Method
	
End Type
