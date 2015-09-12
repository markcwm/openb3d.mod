
Rem
bbdoc: Light entity
End Rem
Type TLight Extends TEntity

	Global light_no:Int Ptr ' 0
	Global no_lights:Int Ptr ' 0
	Global max_lights:Int Ptr ' 8
	
	' enter gl consts here for each available light
	Global gl_light:Int Ptr ' array [] GL_LIGHT0..GL_LIGHT7
	
	Global light_list:TList=CreateList() ' Light vector
	
	Field light_type:Int Ptr ' 0
	Field Range:Float Ptr ' (1.0/1000.0)
	Field red:Float Ptr,green:Float Ptr,blue:Float Ptr ' 1.0/1.0/1.0
	Field inner_ang:Float Ptr,outer_ang:Float Ptr ' 0.0/45.0
	
	' wrapper
	Global ambient#[8,4] ' [0.0,0.0,0.0,1.0]
	Global diffuse#[8,4] ' [1.0,1.0,1.0,1.0]
	Global specular#[8,4] ' [1.0,1.0,1.0,1.0]
	Global position#[8,4] ' [0.0,0.0,1.0,0.0]
	'Global halfVector#[8,4] ' derived
	Global spotDirection#[8,3] ' [0.0,0.0,-1.0]
	Global spotExponent#[8,1] ' [0.0]
	Global spotCutoff#[8,1] ' [180.0] (Range: [0.0,90.0], 180.0)
	'Global spotCosCutoff#[8,1] ' derived
	Global constantAtt#[8,1] ' [1.0/0.0]
	Global linearAtt#[8,1] ' [0.0/0.001]
	Global quadraticAtt#[8,1] ' [0.0]
	
	Function CreateObject:TLight( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TLight=New TLight
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function InitGlobals() ' Once per Graphics3D
	
		light_no=StaticInt_( LIGHT_class,LIGHT_light_no )
		no_lights=StaticInt_( LIGHT_class,LIGHT_no_lights )
		max_lights=StaticInt_( LIGHT_class,LIGHT_max_lights )
		gl_light=StaticInt_( LIGHT_class,LIGHT_gl_light )
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		Super.InitFields()
		
		' int
		light_type=LightInt_( GetInstance(Self),LIGHT_light_type )
		
		' float
		Range=LightFloat_( GetInstance(Self),LIGHT_range )
		red=LightFloat_( GetInstance(Self),LIGHT_red )
		green=LightFloat_( GetInstance(Self),LIGHT_green )
		blue=LightFloat_( GetInstance(Self),LIGHT_blue )
		inner_ang=LightFloat_( GetInstance(Self),LIGHT_inner_ang )
		outer_ang=LightFloat_( GetInstance(Self),LIGHT_outer_ang )
				
	End Method
	
	Function CopyList_( list:TList ) ' Global list
	
		Local inst:Byte Ptr
		ClearList list
		
		Select list
			Case light_list
				For Local id:Int=0 To StaticListSize_( LIGHT_class,LIGHT_light_list )-1
					inst=StaticIterVectorLight_( LIGHT_class,LIGHT_light_list )
					Local obj:TLight=TLight( GetObject(inst) )
					If obj=Null And inst<>Null Then obj=TLight.CreateObject(inst)
					ListAddLast list,obj
				Next
		End Select
		
	End Function
	
	' Minib3d
	
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
	
	Method FreeEntity()
	
		Super.FreeEntity()
		
	End Method
	
	Function CreateLight:TLight( light_type:Int=1,parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateLight_( light_type,GetInstance(parent) )
		Return CreateObject(inst)
		
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
	
	' Internal
	
	Method CopyEntity:TLight( parent:TEntity=Null )

		Local inst:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return CreateObject(inst)
		
	End Method
	
	' called in Camera::Render
	Method Update()
	
		LightUpdate_( GetInstance(Self) )
		
	End Method
	
	' at init, call after a RenderWorld
	Function GetLightValues()
		
		For Local i%=0 To no_lights[0]-1
			glGetLightfv(GL_LIGHT0+i, GL_AMBIENT, Varptr(ambient[i,0]))
			glGetLightfv(GL_LIGHT0+i, GL_DIFFUSE, Varptr(diffuse[i,0]))
			glGetLightfv(GL_LIGHT0+i, GL_SPECULAR, Varptr(specular[i,0]))
			glGetLightfv(GL_LIGHT0+i, GL_POSITION, Varptr(position[i,0]))
			glGetLightfv(GL_LIGHT0+i, GL_SPOT_DIRECTION, Varptr(spotDirection[i,0]))
			glGetLightfv(GL_LIGHT0+i, GL_SPOT_EXPONENT, Varptr(spotExponent[i,0]))
			glGetLightfv(GL_LIGHT0+i, GL_SPOT_CUTOFF, Varptr(spotCutoff[i,0]))
			glGetLightfv(GL_LIGHT0+i, GL_CONSTANT_ATTENUATION, Varptr(constantAtt[i,0]))
			glGetLightfv(GL_LIGHT0+i, GL_LINEAR_ATTENUATION, Varptr(linearAtt[i,0]))
			glGetLightfv(GL_LIGHT0+i, GL_QUADRATIC_ATTENUATION, Varptr(quadraticAtt[i,0]))
		Next
		
	End Function
	
	' in main loop, call before RenderWorld
	Function SetLightValues()
	
		For Local i%=0 To no_lights[0]-1
			glLightfv(GL_LIGHT0+i, GL_AMBIENT, Varptr(ambient[i,0]))
			glLightfv(GL_LIGHT0+i, GL_DIFFUSE, Varptr(diffuse[i,0]))
			glLightfv(GL_LIGHT0+i, GL_SPECULAR, Varptr(specular[i,0]))
			glLightfv(GL_LIGHT0+i, GL_POSITION, Varptr(position[i,0]))
			glLightfv(GL_LIGHT0+i, GL_SPOT_DIRECTION, Varptr(spotDirection[i,0]))
			glLightfv(GL_LIGHT0+i, GL_SPOT_EXPONENT, Varptr(spotExponent[i,0]))
			glLightfv(GL_LIGHT0+i, GL_SPOT_CUTOFF, Varptr(spotCutoff[i,0]))
			glLightfv(GL_LIGHT0+i, GL_CONSTANT_ATTENUATION, Varptr(constantAtt[i,0]))
			glLightfv(GL_LIGHT0+i, GL_LINEAR_ATTENUATION, Varptr(linearAtt[i,0]))
			glLightfv(GL_LIGHT0+i, GL_QUADRATIC_ATTENUATION, Varptr(quadraticAtt[i,0]))
		Next
	
	End Function
	
End Type
