Rem
bbdoc: Bone entity
End Rem
Type TBone Extends TEntity

	Field n_px#,n_py#,n_pz#,n_sx#,n_sy#,n_sz#,n_rx#,n_ry#,n_rz#,n_qw#,n_qx#,n_qy#,n_qz#

	Field keys:TAnimationKeys
	
	' additional matrices used for animation purposes
	Field mat2:TMatrix=New TMatrix
	Field inv_mat:TMatrix ' set in TModel, when loading anim mesh
	Field tform_mat:TMatrix=New TMatrix
	
	Field kx#,ky#,kz#,kqw#,kqx#,kqy#,kqz# ' used to store current keyframe in AnimateMesh, for use with transition
	
	Field instance:Byte Ptr
	
	' Create and map object from C++ instance
	Function NewObject:TBone( inst:Byte Ptr )
	
		Local obj:TBone=New TBone
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	Function CreateBone:TBone( mesh:TMesh,parent_ent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateBone_( GetInstance(mesh),GetInstance(parent_ent) )
		Return NewObject(instance)
		
	End Function
	
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
	
	Method CopyEntity:TBone( parent:TEntity=Null )
	
		Local instance:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return NewObject(instance)
		
	End Method
	
	Method Update()
	
		
		
	End Method
	
	Method FreeEntity()
	
		Super.FreeEntity()
		
	End Method
	
	' Same as UpdateChildren in TEntity except it negates z value of bone matrices so that children are transformed
	' in correct z direction
	Function UpdateBoneChildren(ent_p:TEntity)
		
		
		
	End Function
	
End Type
