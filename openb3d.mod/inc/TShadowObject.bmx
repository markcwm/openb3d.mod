
' TShadowTriangle

' TEdge

Rem
bbdoc: Shadow object
End Rem
Type TShadowObject

	Global shadow_list:TList=CreateList() ' ShadowObject list
	
	Field Parent:TMesh ' caster mesh
	Field cnt_tris:Int Ptr ' shadow triangle count
	'Field Tri:TList=CreateList() ' ShadowTriangle vector
	Field ShadowMesh:TMesh ' shadow mesh
	Field ShadowVolume:TSurface ' shadow surface
	'Field ShadowCap:TSurface ' unused
	Field Render:Byte Ptr ' render shadow flag
	Field Static:Byte Ptr ' static shadow flag
	Field VCreated:Byte Ptr ' shadow created flag
	
	Global VolumeLength:Float Ptr ' 1000
	
	Global top_caps:Byte Ptr ' true
	Global parallel:Int Ptr ' light transform - 0
	
	Global light_x:Float Ptr ' current light position
	Global light_y:Float Ptr
	Global light_z:Float Ptr
	Global midStencilVal:Int Ptr ' stencil bits
	Global ShadowRed:Float Ptr ' 0
	Global ShadowGreen:Float Ptr ' 0
	Global ShadowBlue:Float Ptr ' 0
	Global ShadowAlpha:Float Ptr ' 0.5
	
	' wrapper
?bmxng
	Global shad_map:TPtrMap=New TPtrMap
?Not bmxng
	Global shad_map:TMap=New TMap
?
	Field instance:Byte Ptr
	
	Global shadow_list_id:Int=0
	Field exists:Int=0 ' FreeShadow
	
	Function CreateObject:TShadowObject( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TShadowObject=New TShadowObject
	?bmxng
		shad_map.Insert( inst,obj )
	?Not bmxng
		shad_map.Insert( String(Long(inst)),obj )
	?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	?bmxng
		shad_map.Remove( inst )
	?Not bmxng
		shad_map.Remove( String(Long(inst)) )
	?
	End Function
	
	Function GetObject:TShadowObject( inst:Byte Ptr )
	?bmxng
		Return TShadowObject( shad_map.ValueForKey( inst ) )
	?Not bmxng
		Return TShadowObject( shad_map.ValueForKey( String(Long(inst)) ) )
	?
	End Function
	
	Function GetInstance:Byte Ptr( obj:TShadowObject ) ' ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Function InitGlobals() ' Once per Graphics3D
	
		VolumeLength=StaticFloat_( SHADOWOBJECT_class,SHADOWOBJECT_VolumeLength )
		top_caps=StaticChar_( SHADOWOBJECT_class,SHADOWOBJECT_top_caps )
		parallel=StaticInt_( SHADOWOBJECT_class,SHADOWOBJECT_parallel )
		light_x=StaticFloat_( SHADOWOBJECT_class,SHADOWOBJECT_light_x )
		light_y=StaticFloat_( SHADOWOBJECT_class,SHADOWOBJECT_light_y )
		light_z=StaticFloat_( SHADOWOBJECT_class,SHADOWOBJECT_light_z )
		midStencilVal=StaticInt_( SHADOWOBJECT_class,SHADOWOBJECT_midStencilVal )
		ShadowRed=StaticFloat_( SHADOWOBJECT_class,SHADOWOBJECT_ShadowRed )
		ShadowGreen=StaticFloat_( SHADOWOBJECT_class,SHADOWOBJECT_ShadowGreen )
		ShadowBlue=StaticFloat_( SHADOWOBJECT_class,SHADOWOBJECT_ShadowBlue )
		ShadowAlpha=StaticFloat_( SHADOWOBJECT_class,SHADOWOBJECT_ShadowAlpha )
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		' char
		Render=ShadowObjectChar_( GetInstance(Self),SHADOWOBJECT_Render )
		Static=ShadowObjectChar_( GetInstance(Self),SHADOWOBJECT_Static )
		VCreated=ShadowObjectChar_( GetInstance(Self),SHADOWOBJECT_VCreated )
		
		' int
		cnt_tris=ShadowObjectInt_( GetInstance(Self),SHADOWOBJECT_cnt_tris )
		
		' mesh
		Local inst:Byte Ptr=ShadowObjectMesh_( GetInstance(Self),SHADOWOBJECT_Parent )
		Parent=TMesh( TEntity.GetObject(inst) ) ' no CreateObject
		
		inst=ShadowObjectMesh_( GetInstance(Self),SHADOWOBJECT_ShadowMesh )
		ShadowMesh=TMesh( TEntity.GetObject(inst) )
		If ShadowMesh=Null And inst<>Null Then ShadowMesh=TMesh.CreateObject(inst)
		
		' surface
		'inst=ShadowObjectSurface_( GetInstance(Self),SHADOWOBJECT_ShadowVolume )
		'ShadowVolume=TSurface.GetObject(inst)
		'If ShadowVolume=Null And inst<>Null Then ShadowVolume=TSurface.CreateObject(inst)
		
		AddList_(shadow_list)
		exists=1
		
	End Method
	
	Function AddList_( list:TList ) ' Global list
	
		Select list
			Case shadow_list
				If StaticListSize_( SHADOWOBJECT_class,SHADOWOBJECT_shadow_list )
					Local inst:Byte Ptr=StaticIterListShadowObject_( SHADOWOBJECT_class,SHADOWOBJECT_shadow_list,Varptr(shadow_list_id) )
					Local obj:TShadowObject=GetObject(inst) ' no CreateObject
					If obj Then ListAddLast( list,obj )
				EndIf
		End Select
		
	End Function
	
	Function CopyList_( list:TList ) ' Global list (unused)
	
		ClearList list
		
		Select list
			Case shadow_list
				shadow_list_id=0
				For Local id:Int=0 To StaticListSize_( SHADOWOBJECT_class,SHADOWOBJECT_shadow_list )-1
					Local inst:Byte Ptr=StaticIterListShadowObject_( SHADOWOBJECT_class,SHADOWOBJECT_shadow_list,Varptr(shadow_list_id) )
					Local obj:TShadowObject=GetObject(inst) ' no CreateObject
					If obj Then ListAddLast( list,obj )
				Next
		End Select
		
	End Function
	
	' Openb3d
	
	Function CreateShadow:TShadowObject( parent:TMesh,Static:Int=False )
	
		Local inst:Byte Ptr=CreateShadow_( TMesh.GetInstance(parent),Static )
		Return CreateObject(inst)
		
	End Function
	
	Method FreeShadow()
	
		If exists
			ListRemove( shadow_list,Self ) ; shadow_list_id:-1
			ListRemove( TEntity.entity_list,ShadowMesh ) ; TEntity.entity_list_id:-1
			
			TMesh.FreeObject( TMesh.GetInstance(ShadowMesh) ) ; ShadowMesh=Null  ' no FreeEntity
			'TSurface.FreeObject( TSurface.GetInstance(ShadowVolume) ) ; ShadowVolume=Null
			
			FreeShadow_( GetInstance(Self) )
			FreeObject( GetInstance(Self) )
			exists=0
		EndIf
		
	End Method
	
	' Internal
	
	' clears stencil, called in InitShadow
	Function ShadowInit()
	
		ShadowInit_()
		
	End Function
	
	' removes a shadow from shadow list
	Method RemoveShadowfromMesh( M:TMesh )
	
		RemoveShadowfromMesh_( GetInstance(Self),TMesh.GetInstance(M) )
		
	End Method
	
	' called in RenderWorld and CameraToTex
	Function Update( Cam:TCamera )
	
		ShadowObjectUpdate_( TCamera.GetInstance(Cam) )
		
	End Function
	
	' renders shadow list, called in ShadowRenderWorldZFail (uses Mesh::UpdateShadow)
	Function RenderVolume()
	
		RenderVolume_()
		
	End Function
	
	' updates shadow mesh, called in UpdateCaster
	Method UpdateAnim()
	
		UpdateAnim_( GetInstance(Self) )
		
	End Method
	
	' creates shadow mesh, called in Create
	Method Init()
	
		ShadowObjectInit_( GetInstance(Self) )
		
	End Method
	
	' inits triangle data, called in Init
	Method InitShadow()
	
		InitShadow_( GetInstance(Self) )
		
	End Method
	
	' calculates shadow, called in Update
	Method UpdateCaster()
	
		UpdateCaster_( GetInstance(Self) )
		
	End Method
	
	' stencil rendering, called in Update
	Function ShadowRenderWorldZFail()
	
		ShadowRenderWorldZFail_()
		
	End Function
	
	' reset flag to update static shadow
	Method ResetShadow()
	
		VCreated[0]=0
		
	End Method
	
End Type
