
Rem
bbdoc: Mesh entity
End Rem
Type TMesh Extends TEntity

	Field no_surfs:Int Ptr ' 0
	
	Field surf_list:TList=CreateList() ' Surface list
	Field anim_surf_list:TList=CreateList() ' Surface list ' only used if mesh contains anim info, only contains vertex coords array, initialised upon loading b3d
	
	Field bones:TList=CreateList() ' Bone vector
	
	Field mat_sp:TMatrix2 ' used in TMesh's Update to provide necessary additional transform matrix for sprites
	
	'Field c_col_tree:TMeshCollider ' openb3d: used for terrain collisions - NULL
	Field reset_col_tree:Int Ptr ' true (reset flag) - 0
	
	' reset flags are set when mesh shape is changed by various commands in TMesh
	Field reset_bounds:Int Ptr ' true (reset flag) - true
	
	Field min_x:Float Ptr,min_y:Float Ptr,min_z:Float Ptr ' 0.0/0.0/0.0
	Field max_x:Float Ptr,max_y:Float Ptr,max_z:Float Ptr ' 0.0/0.0/0.0
	
	' minib3d
	'Field no_bones:Int=0
	'Field col_tree:TColTree=New TColTree
	
	Function CreateObject:TMesh( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TMesh=New TMesh
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		Super.InitFields()
		
		' int
		no_surfs=MeshInt_( GetInstance(Self),MESH_no_surfs )
		reset_col_tree=MeshInt_( GetInstance(Self),MESH_reset_col_tree )
		reset_bounds=MeshInt_( GetInstance(Self),MESH_reset_bounds )
		
		' float
		min_x=MeshFloat_( GetInstance(Self),MESH_min_x )
		min_y=MeshFloat_( GetInstance(Self),MESH_min_y )
		min_z=MeshFloat_( GetInstance(Self),MESH_min_z )
		max_x=MeshFloat_( GetInstance(Self),MESH_max_x )
		max_y=MeshFloat_( GetInstance(Self),MESH_max_y )
		max_z=MeshFloat_( GetInstance(Self),MESH_max_z )
		
		' matrix
		Local inst:Byte Ptr=MeshMatrix_( GetInstance(Self),MESH_mat_sp )
		mat_sp=TMatrix2.CreateObject(inst)
		
		' meshcollider
		'inst=MeshMeshCollider_( GetInstance(Self),MESH_c_col_tree )
		'c_col_tree=TMeshCollider.CreateObject(inst)
		
	End Method
	
	Method CopyList( list:TList ) ' Field list
	
		Local inst:Byte Ptr
		ClearList list
		
		Select list
			Case surf_list
				For Local id:Int=0 To MeshListSize_( GetInstance(Self),MESH_surf_list )-1
					inst=MeshIterListSurface_( GetInstance(Self),MESH_surf_list )
					Local obj:TSurface=TSurface.GetObject(inst)
					If obj=Null And inst<>Null Then obj=TSurface.CreateObject(inst)
					ListAddLast list,obj
				Next
			Case anim_surf_list
				For Local id:Int=0 To MeshListSize_( GetInstance(Self),MESH_anim_surf_list )-1
					inst=MeshIterListSurface_( GetInstance(Self),MESH_anim_surf_list )
					Local obj:TSurface=TSurface.GetObject(inst)
					If obj=Null And inst<>Null Then obj=TSurface.CreateObject(inst)
					ListAddLast list,obj
				Next
			Case bones
				For Local id:Int=0 To MeshListSize_( GetInstance(Self),MESH_bones )-1
					inst=MeshIterVectorBone_( GetInstance(Self),MESH_bones )
					Local obj:TBone=TBone( GetObject(inst) )
					If obj=Null And inst<>Null Then obj=TBone.CreateObject(inst)
					ListAddLast list,obj
				Next
			End Select
			
	End Method
	
	' Openb3d
	
	Function CreateBone:TBone( mesh:TMesh,parent_ent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateBone_( GetInstance(mesh),GetInstance(parent_ent) )
		Return TBone.CreateObject(inst)
		
	End Function
	
	Function CreatePlane:TMesh( divisions:Int=1,parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreatePlane_( divisions,GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Function CreateQuad:TMesh( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateQuad_( GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Function MeshCSG:TMesh( m1:TMesh,m2:TMesh,method_no:Int=1 )
	
		Local inst:Byte Ptr=MeshCSG_( GetInstance(m1),GetInstance(m2),method_no )
		Return CreateObject(inst)
		
	End Function
	
	Method MeshesIntersect:Int( mesh2:TMesh )
	
		Return MeshesIntersect_( GetInstance(Self),GetInstance(mesh2) )
		
	End Method
	
	Method RepeatMesh:TMesh( parent:TEntity=Null )
	
		Local inst:Byte Ptr=RepeatMesh_( GetInstance(Self),GetInstance(parent) )
		Return CreateObject(inst)
		
	End Method
	
	Method SkinMesh( surf_no_get:Int,vid:Int,bone1:Int,weight1:Float=1.0,bone2:Int=0,weight2:Float=0,bone3:Int=0,weight3:Float=0,bone4:Int=0,weight4:Float=0 )
	
		SkinMesh_( GetInstance(Self),surf_no_get,vid,bone1,weight1,bone2,weight2,bone3,weight3,bone4,weight4 )
		
	End Method
	
	' Minib3d
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TMesh"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TMesh"
		EndIf
	
	End Method
	
	Method FreeEntity()
	
		Super.FreeEntity()
		
	End Method
	
	Function CreateMesh:TMesh( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateMesh_( GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Function LoadMesh:TMesh( file:String,parent:TEntity=Null )
	
		Local cString:Byte Ptr=file.ToCString()
		Local inst:Byte Ptr=LoadMesh_( cString,GetInstance(parent) )
		Local mesh:TMesh=CreateObject(inst)
		MemFree cString
		Return mesh
		
	End Function
	
	Function LoadAnimMesh:TMesh( file:String,parent:TEntity=Null )
	
		Local cString:Byte Ptr=file.ToCString()
		Local inst:Byte Ptr=LoadAnimMesh_( cString,GetInstance(parent) )
		Local mesh:TMesh=CreateObject(inst)
		MemFree cString
		Return mesh
		
	End Function
	
	Function CreateCube:TMesh( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateCube_( GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Function CreateSphere:TMesh( segments:Int=8,parent:TEntity=Null ) ' Function by Coyote
	
		Local inst:Byte Ptr=CreateSphere_( segments,GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Function CreateCylinder:TMesh( segments:Int=8,solid:Int=True,parent:TEntity=Null ) ' Function by Coyote
	
		Local inst:Byte Ptr=CreateCylinder_( segments,solid,GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Function CreateCone:TMesh( segments:Int=8,solid:Int=True,parent:TEntity=Null ) ' Function by Coyote
	
		Local inst:Byte Ptr=CreateCone_( segments,solid,GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Method CopyMesh:TMesh( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CopyMesh_( GetInstance(Self),GetInstance(parent) )
		Return CreateObject(inst)
		
	End Method
	
	Method AddMesh( mesh2:TMesh )
	
		AddMesh_( GetInstance(Self),GetInstance(mesh2) )
		
	End Method
	
	Method FlipMesh()
	
		FlipMesh_( GetInstance(Self) )
		
	EndMethod
	
	Method PaintMesh( brush:TBrush )
	
		PaintMesh_( GetInstance(Self),TBrush.GetInstance(brush) )
		
	End Method
	
	Method FitMesh( x:Float,y:Float,z:Float,width:Float,height:Float,depth:Float,uniform:Int=False )
	
		FitMesh_( GetInstance(Self),x,y,z,width,height,depth,uniform )
		
	End Method
	
	Method ScaleMesh( sx:Float,sy:Float,sz:Float )
	
		ScaleMesh_( GetInstance(Self),sx,sy,sz )
		
	End Method
	
	Method RotateMesh( pitch:Float,yaw:Float,roll:Float )
	
		RotateMesh_( GetInstance(Self),-pitch,yaw,roll ) ' inverted pitch
		
	End Method
	
	Method PositionMesh( px:Float,py:Float,pz:Float )
	
		PositionMesh_( GetInstance(Self),px,py,pz )
		
	End Method
	
	Method UpdateNormals()
	
		UpdateNormals_( GetInstance(Self) )
		
	End Method
	
	Method CreateSurface:TSurface( brush:TBrush=Null ) ' same as function in TSurface
	
		Local inst:Byte Ptr=CreateSurface_( GetInstance(Self),TBrush.GetInstance(brush) )
		Return TSurface.CreateObject(inst)
		
	End Method
	
	Method MeshWidth:Float()
	
		Return MeshWidth_( GetInstance(Self) )
		
	End Method
	
	Method MeshHeight:Float()

		Return MeshHeight_( GetInstance(Self) )
		
	End Method
	
	Method MeshDepth:Float()
	
		Return MeshDepth_( GetInstance(Self) )
		
	End Method
	
	Method CountSurfaces:Int()
	
		Return CountSurfaces_( GetInstance(Self) )
		
	End Method
	
	Method GetSurface:TSurface( surf_no:Int )
	
		Local inst:Byte Ptr=GetSurface_( GetInstance(Self),surf_no )
		Local surf:TSurface=TSurface.GetObject(inst)
		If surf=Null And inst<>Null Then surf=TSurface.CreateObject(inst)
		Return surf
		
	End Method
	
	' *** note: unlike B3D version, this will find a surface with no brush, if a null brush is supplied
	Method FindSurface:TSurface( brush:TBrush )
	
		CopyList( surf_list )
		
		For Local surf:TSurface=EachIn surf_list
			If TBrush.CompareBrushes( brush,surf.brush )=True
				Return surf
			EndIf
		Next
		
		Return Null
		
	End Method
	
	' Internal
	
	Method CopyEntity:TMesh( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return CreateObject(inst)
		
	End Method
	
	' same as Render
	Method Update()
	
		MeshRender_( GetInstance(Self) )
		
	End Method
	
	' returns total no. of vertices in mesh
	Method CountVertices:Int()
	
		Local verts:Int=0
		
		For Local s:Int=1 To CountSurfaces()
			Local surf:TSurface=GetSurface(s)
			verts=verts+surf.CountVertices()
		Next
		
		Return verts
		
	End Method
	
	' returns total no. of triangles in mesh
	Method CountTriangles:Int()
	
		Local tris:Int=0
		
		For Local s:Int=1 To CountSurfaces()
			Local surf:TSurface=GetSurface(s)
			tris=tris+surf.CountTriangles()
		Next
		
		Return tris
		
	End Method
		
	 ' used by CopyEntity
	Function CopyBonesList( ent:TEntity )
	
		Local inst:Byte Ptr=MeshVectorBone_( GetInstance(ent),MESH_bones )
		CopyBonesList_( GetInstance(ent),inst )
		
	End Function
	
	 ' used by LoadMesh
	Method CollapseAnimMesh:TMesh( mesh:TMesh=Null )
	
		Local inst:Byte Ptr=CollapseAnimMesh_( GetInstance(Self),GetInstance(mesh) )
		Local mesh2:TMesh=TMesh( GetObject(inst) )
		If mesh2=Null And inst<>Null Then mesh2=CreateObject(inst)
		Return mesh2
		
	End Method
	
	' used by CollapseAnimMesh
	' has to be function(?) as we need to use this function with all entities and not just meshes
	Method CollapseChildren:TMesh( ent0:TEntity,mesh:TMesh=Null )
	
		Local inst:Byte Ptr=CollapseChildren_( GetInstance(Self),GetInstance(ent0),GetInstance(mesh) )
		Local mesh2:TMesh=TMesh( GetObject(inst) )
		If mesh2=Null And inst<>Null Then mesh2=CreateObject(inst)
		Return mesh2
		
	End Method

	' used by LoadMesh
	Method TransformMesh( mat:TMatrix2 )
	
		TransformMesh_( GetInstance(Self),TMatrix2.GetInstance(mat) )
		
	End Method
	
	' used by MeshWidth, MeshHeight, MeshDepth, RenderWorld
	Method GetBounds()
	
		GetBounds_( GetInstance(Self) )
		
	End Method
	
	' returns true if mesh is to be drawn with alpha, i.e alpha<1.0. this func is used in
	' Camera::Render and UpdateEntityRender to see whether entity should be manually depth sorted
	' (if alpha=true then yes). alpha_enable true/false is also set for surfaces - this is used
	' to sort alpha surfaces and enable/disable alpha blending in TMesh.Update.
	Method Alpha:Int()
	
		Return Alpha_( GetInstance(Self) )
		
	End Method
	
	' Openb3d
	
	' sets the vertex colors of a mesh (unused)
	Method MeshColor( r:Float,g:Float,b:Float,a:Float=1.0 )
	
		MeshColor_( GetInstance(Self),r,g,b,a )
		
	End Method
	
	' sets the red component of the vertex colors of a mesh (unused)
	Method MeshRed( r:Float )
	
		MeshRed_( GetInstance(Self),r )
		
	End Method
	
	' sets the green component of the vertex colors of a mesh (unused)
	Method MeshGreen( g:Float )
	
		MeshGreen_( GetInstance(Self),g )
		
	End Method
	
	' sets the blue component of the vertex colors of a mesh (unused)
	Method MeshBlue( b:Float )
	
		MeshBlue_( GetInstance(Self),b )
		
	End Method
	
	' sets the alpha component of the vertex colors of a mesh (unused)
	Method MeshAlpha( a:Float )
	
		MeshAlpha_( GetInstance(Self),a )
		
	End Method
	
	' creates a collision tree for a mesh if necessary
	Method TreeCheck() ' moved from ColTree
	
		TreeCheck_( GetInstance(Self) )
		
	End Method
	
	' same as Update
	Method Render()
	
		MeshRender_( GetInstance(Self) )
		
	End Method
	
	' called by UseStencil and RenderVolume (in ShadowObject::Update)
	Method UpdateShadow()
	
		UpdateShadow_( GetInstance(Self) )
		
	End Method
	
End Type

