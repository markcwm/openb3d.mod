
Type TAnimation

	' Openb3d
	
	' manual animation mode, called by UpdateEntityAnim (in UpdateWorld)
	Function AnimateMesh3( ent1:TEntity )
	
		AnimateMesh3_( TEntity.GetInstance(ent1) )
		
	End Function
	
	' Minib3d
	
	' like AnimateMesh2 but does not interpolate between one animation sequence and the next,
	' called by SetAnimTime and UpdateEntityAnim (in UpdateWorld)
	Function AnimateMesh( ent1:TEntity,framef:Float,start_frame:Int,end_frame:Int )
		
		AnimateMesh_( TEntity.GetInstance(ent1),framef,start_frame,end_frame )
		
	End Function
	
	' AnimateMesh2, used to animate transitions between animations, very similar to AnimateMesh
	' except it interpolates between current animation pose (via saved keyframe) and first
	' keyframe of new animation. framef:Float interpolates between 0 and 1.
	Function AnimateMesh2( ent1:TEntity,framef:Float,start_frame:Int,end_frame:Int )
		
		AnimateMesh2_( TEntity.GetInstance(ent1),framef,start_frame,end_frame )
		
	End Function
	
	' used by AnimateMesh functions
	Function VertexDeform( ent:TMesh )
	
		VertexDeform_( TMesh.GetInstance(ent) )
		
	End Function
	
	Rem
	' this function will normalise weights if their sum doesn't equal 1.0 (unused)
	Function NormaliseWeights( mesh:TMesh )
	
		
		
	End Function
	EndRem
	
End Type

' called by LoadAnimB3D (in LoadAnimMesh) and LoadAnimSeq
Rem
bbdoc: AnimationKeys data
End Rem
Type TAnimationKeys

	Field frames:Int Ptr ' 0
	Field flags:Int Ptr ' vector
	Field px:Float Ptr ' vector
	Field py:Float Ptr ' vector
	Field pz:Float Ptr ' vector
	Field sx:Float Ptr ' vector
	Field sy:Float Ptr ' vector
	Field sz:Float Ptr ' vector
	Field qw:Float Ptr ' vector
	Field qx:Float Ptr ' vector
	Field qy:Float Ptr ' vector
	Field qz:Float Ptr ' vector
	
	' wrapper
	?bmxng
	Global animkeys_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global animkeys_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	
	Function CreateObject:TAnimationKeys( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TAnimationKeys=New TAnimationKeys
		?bmxng
		animkeys_map.Insert( inst,obj )
		?Not bmxng
		animkeys_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		animkeys_map.Remove( inst )
		?Not bmxng
		animkeys_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TAnimationKeys( inst:Byte Ptr )
	
		?bmxng
		Return TAnimationKeys( animkeys_map.ValueForKey( inst ) )
		?Not bmxng
		Return TAnimationKeys( animkeys_map.ValueForKey( String(Int(inst)) ) )
		?
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TAnimationKeys ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		' int
		frames=AnimationKeysInt_( GetInstance(Self),ANIMATIONKEYS_frames )
		flags=AnimationKeysInt_( GetInstance(Self),ANIMATIONKEYS_flags )
		
		' float
		px=AnimationKeysFloat_( GetInstance(Self),ANIMATIONKEYS_px )
		py=AnimationKeysFloat_( GetInstance(Self),ANIMATIONKEYS_py )
		pz=AnimationKeysFloat_( GetInstance(Self),ANIMATIONKEYS_pz )
		sx=AnimationKeysFloat_( GetInstance(Self),ANIMATIONKEYS_sx )
		sy=AnimationKeysFloat_( GetInstance(Self),ANIMATIONKEYS_sy )
		sz=AnimationKeysFloat_( GetInstance(Self),ANIMATIONKEYS_sz )
		qw=AnimationKeysFloat_( GetInstance(Self),ANIMATIONKEYS_qw )
		qx=AnimationKeysFloat_( GetInstance(Self),ANIMATIONKEYS_qx )
		qy=AnimationKeysFloat_( GetInstance(Self),ANIMATIONKEYS_qy )
		qz=AnimationKeysFloat_( GetInstance(Self),ANIMATIONKEYS_qz )
		
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
		DebugLog pad+" AnimationKeys instance: "+StringPtr(GetInstance(Self))
		
		' int
		If frames<>Null Then DebugLog(pad+" frames: "+frames[0]) Else DebugLog(pad+" frames: Null")
		DebugLog pad+" flags: "+StringPtr(flags)
		If flags<>Null Then DebugLog(pad+" flags[0] = "+flags[0]+" [1] = "+flags[1]+" ...")
		
		' float
		DebugLog pad+" px: "+StringPtr(px)
		If px<>Null Then DebugLog(pad+" px[0] = "+px[0]+" [1] = "+px[1]+" ...")
		DebugLog pad+" py: "+StringPtr(py)
		If py<>Null Then DebugLog(pad+" py[0] = "+py[0]+" [1] = "+py[1]+" ...")
		DebugLog pad+" pz: "+StringPtr(pz)
		If pz<>Null Then DebugLog(pad+" pz[0] = "+pz[0]+" [1] = "+pz[1]+" ...")
		DebugLog pad+" sx: "+StringPtr(sx)
		If sx<>Null Then DebugLog(pad+" sx[0] = "+sx[0]+" [1] = "+sx[1]+" ...")
		DebugLog pad+" sy: "+StringPtr(sy)
		If sy<>Null Then DebugLog(pad+" sy[0] = "+sy[0]+" [1] = "+sy[1]+" ...")
		DebugLog pad+" sz: "+StringPtr(sz)
		If sz<>Null Then DebugLog(pad+" sz[0] = "+sz[0]+" [1] = "+sz[1]+" ...")
		DebugLog pad+" qw: "+StringPtr(qw)
		If qw<>Null Then DebugLog(pad+" qw[0] = "+qw[0]+" [1] = "+qw[1]+" ...")
		DebugLog pad+" qx: "+StringPtr(qx)
		If qx<>Null Then DebugLog(pad+" qx[0] = "+qx[0]+" [1] = "+qx[1]+" ...")
		DebugLog pad+" qy: "+StringPtr(qy)
		If qy<>Null Then DebugLog(pad+" qy[0] = "+qy[0]+" [1] = "+qy[1]+" ...")
		DebugLog pad+" qz: "+StringPtr(qz)
		If qz<>Null Then DebugLog(pad+" qz[0] = "+qz[0]+" [1] = "+qz[1]+" ...")
		
		DebugLog ""
		
	End Method
	
	Function NewAnimationKeys:TAnimationKeys( bone:TBone=Null )
	
		Local inst:Byte Ptr=NewAnimationKeys_( TBone.GetInstance(bone) )
		Local animkeys:TAnimationKeys=CreateObject(inst)
		
		If bone<>Null
			inst=BoneAnimationKeys_( TBone.GetInstance(bone),BONE_keys )
			bone.keys=GetObject(inst)
		EndIf
		Return animkeys
		
	End Function
	
	Method AnimationKeysIntArrayResize:Int Ptr( varid:Int,size:Int )
	
		Select varid
			Case ANIMATIONKEYS_flags
				Return AnimationKeysResizeIntArray_( TAnimationKeys.GetInstance(Self),ANIMATIONKEYS_flags,size )
			End Select
		
	End Method
	
	Method AnimationKeysFloatArrayResize:Float Ptr( varid:Int,size:Int )
	
		Select varid
			Case ANIMATIONKEYS_px
				Return AnimationKeysResizeFloatArray_( TAnimationKeys.GetInstance(Self),ANIMATIONKEYS_px,size )
			Case ANIMATIONKEYS_py
				Return AnimationKeysResizeFloatArray_( TAnimationKeys.GetInstance(Self),ANIMATIONKEYS_py,size )
			Case ANIMATIONKEYS_pz
				Return AnimationKeysResizeFloatArray_( TAnimationKeys.GetInstance(Self),ANIMATIONKEYS_pz,size )
			Case ANIMATIONKEYS_sx
				Return AnimationKeysResizeFloatArray_( TAnimationKeys.GetInstance(Self),ANIMATIONKEYS_sx,size )
			Case ANIMATIONKEYS_sy
				Return AnimationKeysResizeFloatArray_( TAnimationKeys.GetInstance(Self),ANIMATIONKEYS_sy,size )
			Case ANIMATIONKEYS_sz
				Return AnimationKeysResizeFloatArray_( TAnimationKeys.GetInstance(Self),ANIMATIONKEYS_sz,size )
			Case ANIMATIONKEYS_qw
				Return AnimationKeysResizeFloatArray_( TAnimationKeys.GetInstance(Self),ANIMATIONKEYS_qw,size )
			Case ANIMATIONKEYS_qx
				Return AnimationKeysResizeFloatArray_( TAnimationKeys.GetInstance(Self),ANIMATIONKEYS_qx,size )
			Case ANIMATIONKEYS_qy
				Return AnimationKeysResizeFloatArray_( TAnimationKeys.GetInstance(Self),ANIMATIONKEYS_qy,size )
			Case ANIMATIONKEYS_qz
				Return AnimationKeysResizeFloatArray_( TAnimationKeys.GetInstance(Self),ANIMATIONKEYS_qz,size )
		End Select
		
	End Method
	
	' Minib3d
	
	Method New()
	
		If TGlobal3D.Log_New
			DebugLog " New TAnimationKeys"
		EndIf
		
	End Method
	
	Method Delete()
	
		If TGlobal3D.Log_Del
			DebugLog " Del TAnimationKeys"
		EndIf
	
	End Method
	
	Method Copy:TAnimationKeys()
	
		Local inst:Byte Ptr=AnimationKeysCopy_( GetInstance(Self) )
		Return CreateObject(inst)
		
	End Method
	
End Type
