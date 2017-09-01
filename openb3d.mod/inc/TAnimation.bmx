
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
		animkeys_map.Insert( String(Long(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		animkeys_map.Remove( inst )
		?Not bmxng
		animkeys_map.Remove( String(Long(inst)) )
		?
		
	End Function
	
	Function GetObject:TAnimationKeys( inst:Byte Ptr )
	
		?bmxng
		Return TAnimationKeys( animkeys_map.ValueForKey( inst ) )
		?Not bmxng
		Return TAnimationKeys( animkeys_map.ValueForKey( String(Long(inst)) ) )
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
	
	Function NewAnimationKeys:TAnimationKeys()
	
		Local inst:Byte Ptr=NewAnimationKeys_()
		Return CreateObject(inst)
		
	End Function
	
	' Minib3d
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TAnimationKeys"
		EndIf
		
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TAnimationKeys"
		EndIf
	
	End Method
	
	Method Copy:TAnimationKeys()
	
		Local inst:Byte Ptr=AnimationKeysCopy_( GetInstance(Self) )
		Return CreateObject(inst)
		
	End Method
	
End Type
