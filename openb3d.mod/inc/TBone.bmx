
Rem
bbdoc: Bone entity
End Rem
Type TBone Extends TEntity

	Field n_px:Float Ptr,n_py:Float Ptr,n_pz:Float Ptr
	Field n_sx:Float Ptr,n_sy:Float Ptr,n_sz:Float Ptr
	Field n_rx:Float Ptr,n_ry:Float Ptr,n_rz:Float Ptr
	Field n_qx:Float Ptr,n_qy:Float Ptr,n_qz:Float Ptr,n_qw:Float Ptr
	
	Field keys:TAnimationKeys
	
	' additional matrices used for animation purposes
	Field mat2:TMatrix
	Field inv_mat:TMatrix ' set in TModel, when loading anim mesh
	Field tform_mat:TMatrix
	
	' used to store current keyframe in AnimateMesh, for use with transition
	Field kx:Float Ptr,ky:Float Ptr,kz:Float Ptr
	Field kqx:Float Ptr,kqy:Float Ptr,kqz:Float Ptr,kqw:Float Ptr
	
	Function CreateObject:TBone( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TBone=New TBone
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
		n_qx=BoneFloat_( GetInstance(Self),BONE_n_qx )		
		n_qy=BoneFloat_( GetInstance(Self),BONE_n_qy )
		n_qz=BoneFloat_( GetInstance(Self),BONE_n_qz )
		n_qw=BoneFloat_( GetInstance(Self),BONE_n_qw )
		kx=BoneFloat_( GetInstance(Self),BONE_kx )
		ky=BoneFloat_( GetInstance(Self),BONE_ky )
		kz=BoneFloat_( GetInstance(Self),BONE_kz )
		kqx=BoneFloat_( GetInstance(Self),BONE_kqx )
		kqy=BoneFloat_( GetInstance(Self),BONE_kqy )
		kqz=BoneFloat_( GetInstance(Self),BONE_kqz )
		kqw=BoneFloat_( GetInstance(Self),BONE_kqw )
		
		' animationkeys
		Local inst:Byte Ptr=BoneAnimationKeys_( GetInstance(Self),BONE_keys )
		keys=TAnimationKeys.GetObject(inst)
		If keys=Null And inst<>Null Then keys=TAnimationKeys.CreateObject(inst)
		
		' matrix
		inst=BoneMatrix_( GetInstance(Self),BONE_mat2 )
		mat2=TMatrix.GetObject(inst)
		If mat2=Null And inst<>Null Then mat2=TMatrix.CreateObject(inst)
		inst=BoneMatrix_( GetInstance(Self),BONE_inv_mat )
		inv_mat=TMatrix.GetObject(inst)
		If inv_mat=Null And inst<>Null Then inv_mat=TMatrix.CreateObject(inst)
		inst=BoneMatrix_( GetInstance(Self),BONE_tform_mat )
		tform_mat=TMatrix.GetObject(inst)
		If tform_mat=Null And inst<>Null Then tform_mat=TMatrix.CreateObject(inst)
		
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
		DebugLog pad+" Bone instance: "+StringPtr(GetInstance(Self))
		
		' float
		If n_px<>Null Then DebugLog(pad+" n_px: "+n_px[0]) Else DebugLog(pad+" n_px: Null")
		If n_py<>Null Then DebugLog(pad+" n_py: "+n_py[0]) Else DebugLog(pad+" n_py: Null")
		If n_pz<>Null Then DebugLog(pad+" n_pz: "+n_pz[0]) Else DebugLog(pad+" n_pz: Null")
		If n_sx<>Null Then DebugLog(pad+" n_sx: "+n_sx[0]) Else DebugLog(pad+" n_sx: Null")
		If n_sy<>Null Then DebugLog(pad+" n_sy: "+n_sy[0]) Else DebugLog(pad+" n_sy: Null")
		If n_sz<>Null Then DebugLog(pad+" n_sz: "+n_sz[0]) Else DebugLog(pad+" n_sz: Null")
		If n_rx<>Null Then DebugLog(pad+" n_rx: "+n_rx[0]) Else DebugLog(pad+" n_rx: Null")
		If n_ry<>Null Then DebugLog(pad+" n_ry: "+n_ry[0]) Else DebugLog(pad+" n_ry: Null")
		If n_rz<>Null Then DebugLog(pad+" n_rz: "+n_rz[0]) Else DebugLog(pad+" n_rz: Null")
		If n_qx<>Null Then DebugLog(pad+" n_qx: "+n_qx[0]) Else DebugLog(pad+" n_qx: Null")
		If n_qy<>Null Then DebugLog(pad+" n_qy: "+n_qy[0]) Else DebugLog(pad+" n_qy: Null")
		If n_qz<>Null Then DebugLog(pad+" n_qz: "+n_qz[0]) Else DebugLog(pad+" n_qz: Null")
		If n_qw<>Null Then DebugLog(pad+" n_qw: "+n_qw[0]) Else DebugLog(pad+" n_qw: Null")
		If kx<>Null Then DebugLog(pad+" kx: "+kx[0]) Else DebugLog(pad+" kx: Null")
		If ky<>Null Then DebugLog(pad+" ky: "+ky[0]) Else DebugLog(pad+" ky: Null")
		If kz<>Null Then DebugLog(pad+" kz: "+kz[0]) Else DebugLog(pad+" kz: Null")
		If kqx<>Null Then DebugLog(pad+" kqx: "+kqx[0]) Else DebugLog(pad+" kqx: Null")
		If kqy<>Null Then DebugLog(pad+" kqy: "+kqy[0]) Else DebugLog(pad+" kqy: Null")
		If kqz<>Null Then DebugLog(pad+" kqz: "+kqz[0]) Else DebugLog(pad+" kqz: Null")
		If kqw<>Null Then DebugLog(pad+" kqw: "+kqw[0]) Else DebugLog(pad+" kqw: Null")
		
		' animationkeys
		DebugLog pad+" keys: "+StringPtr(TAnimationKeys.GetInstance(keys))
		If debug_subobjects And keys<>Null Then keys.DebugFields( debug_subobjects,debug_base_types )
		
		' matrix
		DebugLog pad+" mat2: "+StringPtr(TMatrix.GetInstance(mat2))
		If debug_subobjects And mat2<>Null Then mat2.DebugFields( debug_subobjects,debug_base_types )
		DebugLog pad+" inv_mat: "+StringPtr(TMatrix.GetInstance(inv_mat))
		If debug_subobjects And inv_mat<>Null Then inv_mat.DebugFields( debug_subobjects,debug_base_types )
		DebugLog pad+" tform_mat: "+StringPtr(TMatrix.GetInstance(tform_mat))
		If debug_subobjects And tform_mat<>Null Then tform_mat.DebugFields( debug_subobjects,debug_base_types )
		
		DebugLog ""
		
	End Method
	
	Function NewBone:TBone()
	
		Local inst:Byte Ptr=NewBone_()
		Return CreateObject(inst)
		
	End Function
	
	Function Create:TBone()
	
		Local inst:Byte Ptr=NewBone_()
		Return CreateObject(inst)
		
	End Function
	
	' Openb3d
	
	Function CreateBone:TBone( mesh:TMesh,parent_ent:TEntity=Null ) ' same as method in TMesh
	
		Local inst:Byte Ptr=CreateBone_( GetInstance(mesh),GetInstance(parent_ent) )
		CopyList(mesh.bones)
		If mesh.is_anim=0
			mesh.is_anim=1
			CopyList(mesh.anim_surf_list)
			For Local surf:TSurface=EachIn mesh.anim_surf_list
				surf.vert_coords=SurfaceFloat_( TSurface.GetInstance(surf),SURFACE_vert_coords )
				surf.vert_bone1_no=SurfaceInt_( TSurface.GetInstance(surf),SURFACE_vert_bone1_no )
				surf.vert_bone2_no=SurfaceInt_( TSurface.GetInstance(surf),SURFACE_vert_bone2_no )
				surf.vert_bone3_no=SurfaceInt_( TSurface.GetInstance(surf),SURFACE_vert_bone3_no )
				surf.vert_bone4_no=SurfaceInt_( TSurface.GetInstance(surf),SURFACE_vert_bone4_no )
				surf.vert_weight1=SurfaceFloat_( TSurface.GetInstance(surf),SURFACE_vert_weight1 )
				surf.vert_weight2=SurfaceFloat_( TSurface.GetInstance(surf),SURFACE_vert_weight2 )
				surf.vert_weight3=SurfaceFloat_( TSurface.GetInstance(surf),SURFACE_vert_weight3 )
				surf.vert_weight4=SurfaceFloat_( TSurface.GetInstance(surf),SURFACE_vert_weight4 )
			Next
		EndIf
		Return CreateObject(inst)
		
	End Function
	
	' Minib3d
	
	Method New()
	
		If TGlobal3D.Log_New
			DebugLog " New TBone"
		EndIf
		
	End Method
	
	Method Delete()
	
		If TGlobal3D.Log_Del
			DebugLog " Del TBone"
		EndIf
	
	End Method
	
	Method FreeEntity()
	
		If exists
			exists=0
			TAnimationKeys.FreeObject( TAnimationKeys.GetInstance(keys) ) ; keys=Null
			TMatrix.FreeObject( TMatrix.GetInstance(mat2) ) ; mat2=Null
			TMatrix.FreeObject( TMatrix.GetInstance(inv_mat) ) ; inv_mat=Null
			TMatrix.FreeObject( TMatrix.GetInstance(tform_mat) ) ; tform_mat=Null
			
			FreeObject( GetInstance(Self) ) ' no FreeEntity_
		EndIf
		
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
