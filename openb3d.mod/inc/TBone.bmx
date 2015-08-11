
Rem
bbdoc: Bone entity
End Rem
Type TBone Extends TEntity

	Field n_px:Float Ptr,n_py:Float Ptr,n_pz:Float Ptr
	Field n_sx:Float Ptr,n_sy:Float Ptr,n_sz:Float Ptr
	Field n_rx:Float Ptr,n_ry:Float Ptr,n_rz:Float Ptr
	Field n_qw:Float Ptr,n_qx:Float Ptr,n_qy:Float Ptr,n_qz:Float Ptr
	
	Field keys:TAnimationKeys
	
	' additional matrices used for animation purposes
	Field mat2:TMatrix2
	Field inv_mat:TMatrix2 ' set in TModel, when loading anim mesh
	Field tform_mat:TMatrix2
	
	' used to store current keyframe in AnimateMesh, for use with transition
	Field kx:Float Ptr,ky:Float Ptr,kz:Float Ptr
	Field kqw:Float Ptr,kqx:Float Ptr,kqy:Float Ptr,kqz:Float Ptr
	
	Function CreateObject:TBone( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TBone=New TBone
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		Super.InitFields()
		
		' float
		n_px=BoneFloat_( GetInstance(Self),BONE_n_px )
		n_py=BoneFloat_( GetInstance(Self),BONE_n_py )
		n_pz=BoneFloat_( GetInstance(Self),BONE_n_pz )
		n_sx=BoneFloat_( GetInstance(Self),BONE_n_sx )
		n_sy=BoneFloat_( GetInstance(Self),BONE_n_sy )
		n_sz=BoneFloat_( GetInstance(Self),BONE_n_sz )
		n_rx=BoneFloat_( GetInstance(Self),BONE_n_rx )
		n_ry=BoneFloat_( GetInstance(Self),BONE_n_ry )
		n_rz=BoneFloat_( GetInstance(Self),BONE_n_rz )
		n_qw=BoneFloat_( GetInstance(Self),BONE_n_qw )
		n_qx=BoneFloat_( GetInstance(Self),BONE_n_qx )		
		n_qy=BoneFloat_( GetInstance(Self),BONE_n_qy )
		n_qz=BoneFloat_( GetInstance(Self),BONE_n_qz )
		kx=BoneFloat_( GetInstance(Self),BONE_kx )
		ky=BoneFloat_( GetInstance(Self),BONE_ky )
		kz=BoneFloat_( GetInstance(Self),BONE_kz )
		kqw=BoneFloat_( GetInstance(Self),BONE_kqw )
		kqx=BoneFloat_( GetInstance(Self),BONE_kqx )
		kqy=BoneFloat_( GetInstance(Self),BONE_kqy )
		kqz=BoneFloat_( GetInstance(Self),BONE_kqz )
		
		' animationkeys
		Local inst:Byte Ptr=BoneAnimationKeys_( GetInstance(Self),BONE_keys )
		keys=TAnimationKeys.CreateObject(inst)
		
		' matrix
		inst=BoneMatrix_( GetInstance(Self),BONE_mat2 )
		mat2=TMatrix2.CreateObject(inst)
		inst=BoneMatrix_( GetInstance(Self),BONE_inv_mat )
		inv_mat=TMatrix2.CreateObject(inst)
		inst=BoneMatrix_( GetInstance(Self),BONE_tform_mat )
		tform_mat=TMatrix2.CreateObject(inst)
		
	End Method
	
	' Openb3d
	
	Function CreateBone:TBone( mesh:TMesh,parent_ent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateBone_( GetInstance(mesh),GetInstance(parent_ent) )
		Return CreateObject(inst)
		
	End Function
	
	' Minib3d
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TBone"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TBone"
		EndIf
	
	End Method
	
	Method FreeEntity()
	
		Super.FreeEntity()
		
	End Method
	
	' Internal
	
	Method CopyEntity:TBone( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return CreateObject(inst)
		
	End Method
	
	Method Update() ' empty
	
		
		
	End Method
	
	Rem
	' Same as UpdateChildren in TEntity except it negates z value of bone matrices
	' so that children are transformed in correct z direction
	Function UpdateBoneChildren( ent_p:TEntity )
		
		
		
	End Function
	EndRem
	
End Type
