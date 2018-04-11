
Rem
bbdoc: Mesh entity
End Rem
Type TMesh Extends TEntity

	Field no_surfs:Int Ptr ' 0
	
	Field surf_list:TList=CreateList() ' Surface list
	Field anim_surf_list:TList=CreateList() ' Surface list ' only used if mesh contains anim info, only contains vertex coords array, initialised upon loading b3d
	
	Field bones:TList=CreateList() ' Bone vector
	
	Field mat_sp:TMatrix ' used in TMesh's Update to provide necessary additional transform matrix for sprites
	
	'Field c_col_tree:TMeshCollider ' openb3d: used for terrain collisions - NULL
	Field reset_col_tree:Int Ptr ' true (reset flag) - 0
	
	' reset flags are set when mesh shape is changed by various commands in TMesh
	Field reset_bounds:Int Ptr ' true (reset flag) - true
	
	Field min_x:Float Ptr,min_y:Float Ptr,min_z:Float Ptr ' 0.0/0.0/0.0
	Field max_x:Float Ptr,max_y:Float Ptr,max_z:Float Ptr ' 0.0/0.0/0.0
	
	' minib3d
	'Field no_bones:Int=0
	'Field col_tree:TColTree=New TColTree
	
	' wrapper
	Field surf_list_id:Int=0
	Field anim_surf_list_id:Int=0
	Field bones_id:Int=0
	
	Function CreateObject:TMesh( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TMesh=New TMesh
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
	
		CopyList(surf_list) ' CopyList should be called before InitFields
		CopyList(anim_surf_list)
		CopyList(bones)
		
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
		mat_sp=TMatrix.GetObject(inst)
		If mat_sp=Null And inst<>Null Then mat_sp=TMatrix.CreateObject(inst)
				
	End Method
	
	Method AddList( list:TList ) ' Field list
	
		Super.AddList(list)
		
		Select list
			Case surf_list
				If MeshListSize_( GetInstance(Self),MESH_surf_list )
					Local inst:Byte Ptr=MeshIterListSurface_( GetInstance(Self),MESH_surf_list,Varptr(surf_list_id) )
					Local obj:TSurface=TSurface.GetObject(inst)
					If obj=Null And inst<>Null Then obj=TSurface.CreateObject(inst)
					If obj Then ListAddLast( list,obj )
				EndIf
			Case anim_surf_list
				If MeshListSize_( GetInstance(Self),MESH_anim_surf_list )
					Local inst:Byte Ptr=MeshIterListSurface_( GetInstance(Self),MESH_anim_surf_list,Varptr(anim_surf_list_id) )
					Local obj:TSurface=TSurface.GetObject(inst)
					If obj=Null And inst<>Null Then obj=TSurface.CreateObject(inst)
					If obj Then ListAddLast( list,obj )
				EndIf
			Case bones
				If MeshListSize_( GetInstance(Self),MESH_bones )
					Local inst:Byte Ptr=MeshIterVectorBone_( GetInstance(Self),MESH_bones,Varptr(bones_id) )
					Local obj:TBone=TBone( TEntity.GetObject(inst) )
					If obj=Null And inst<>Null Then obj=TBone.CreateObject(inst)
					If obj Then ListAddLast( list,obj )
				EndIf
			End Select
						
	End Method
	
	Method CopyList( list:TList ) ' Field list
	
		Super.CopyList(list) ' calls ClearList
		
		Select list
			Case surf_list
				surf_list_id=0
				For Local id:Int=0 To MeshListSize_( GetInstance(Self),MESH_surf_list )-1
					Local inst:Byte Ptr=MeshIterListSurface_( GetInstance(Self),MESH_surf_list,Varptr(surf_list_id) )
					Local obj:TSurface=TSurface.GetObject(inst)
					If obj=Null And inst<>Null Then obj=TSurface.CreateObject(inst)
					If obj Then ListAddLast( list,obj )
				Next
			Case anim_surf_list
				anim_surf_list_id=0
				For Local id:Int=0 To MeshListSize_( GetInstance(Self),MESH_anim_surf_list )-1
					Local inst:Byte Ptr=MeshIterListSurface_( GetInstance(Self),MESH_anim_surf_list,Varptr(anim_surf_list_id) )
					Local obj:TSurface=TSurface.GetObject(inst)
					If obj=Null And inst<>Null Then obj=TSurface.CreateObject(inst)
					If obj Then ListAddLast( list,obj )
				Next
			Case bones
				bones_id=0
				For Local id:Int=0 To MeshListSize_( GetInstance(Self),MESH_bones )-1
					Local inst:Byte Ptr=MeshIterVectorBone_( GetInstance(Self),MESH_bones,Varptr(bones_id) )
					Local obj:TBone=TBone( TEntity.GetObject(inst) )
					If obj=Null And inst<>Null Then obj=TBone.CreateObject(inst)
					If obj Then ListAddLast( list,obj )
				Next
			End Select
			
	End Method
	
	Method ListPushBack( list:TList,value:Object ) ' Field list value
	
		Super.ListPushBack( list,value )
		
		Local surf:TSurface=TSurface(value)
		Local bone:TBone=TBone(value)
		
		Select list
			Case surf_list
				If surf
					MeshListPushBackSurface_( GetInstance(Self),MESH_surf_list,TSurface.GetInstance(surf) )
					AddList(list)
				EndIf
			Case anim_surf_list
				If surf
					MeshListPushBackSurface_( GetInstance(Self),MESH_anim_surf_list,TSurface.GetInstance(surf) )
					AddList(list)
				EndIf
			Case bones
				If bone
					MeshListPushBackBone_( GetInstance(Self),MESH_bones,TBone.GetInstance(bone) )
					AddList(list)
				EndIf
		End Select
		
	End Method
	
	Function NewMesh:TMesh()
	
		Local inst:Byte Ptr=NewMesh_()
		Return CreateObject(inst)
		
	End Function
	
	Method NewSurface:TSurface() ' use ListPushBack(list,value)
	
		Local inst:Byte Ptr=NewSurface_( GetInstance(Self) )
		Return TSurface.CreateObject(inst)
				
	End Method
	
	Method NewBone:TBone()
	
		Local inst:Byte Ptr=NewBone_( GetInstance(Self) )
		Return TBone.CreateObject(inst)
		
	End Method
	
	Method CreateAllChildren()
	
		Local child_ent:TEntity=Null ' this will store child entity of anim mesh
		Local child_no%=1 ' used to select child entity
		Local count_children%=CountAllChildren(Self) ' total no. of children belonging to entity
		
		For Local child_no% = 1 To count_children
			Local count%=0
			Local inst:Byte Ptr=GetChildFromAll_( GetInstance(Self),child_no,Varptr(count),Null )
			child_ent=GetObject(inst)
			If child_ent=Null And inst<>Null Then child_ent=CreateObject(inst)
		Next
		
	End Method
	
	' unlike B3d divisions can be more than 16
	Function CreatePlane:TMesh( divisions:Int=1,parent:TEntity=Null )
	
		'Local inst:Byte Ptr=CreatePlane_( divisions,GetInstance(parent) )
		'Return CreateObject(inst)
		
		Local mesh:TMesh=CreateMesh(parent)
		Local surf:TSurface=mesh.CreateSurface()
		
		Local size#=50000/divisions
		Local uvscale#=50000/5000 ' 10 - increases texture resolution
		Local iv%,ix%,iz%,ptx#,ptz#
		
		' create grid vertices
		For iz=0 To divisions
			For ix=0 To divisions
				ptx=(ix*size)-(divisions*size*0.5) ' ipos-midpos
				ptz=(iz*size)-(divisions*size*0.5)
				iv=ix+(iz*(divisions+1)) ' iv=x+(z*x1)
				surf.AddVertex(ptx,0,ptz)
				surf.VertexTexCoords(iv,iz*uvscale,ix*uvscale)
				surf.VertexNormal(iv,0.0,1.0,0.0)
			Next
		Next
		
		' fill in quad triangles
		For iz=0 To divisions-1
			For ix=0 To divisions-1
				iv=ix+(iz*(divisions+1))
				surf.AddTriangle(iv,iv+divisions+1,iv+divisions+2) ' 0,x1,x2
				surf.AddTriangle(iv+divisions+2,iv+1,iv) ' x2,1,0
			Next
		Next
		
		mesh.RotateMesh(0,-90,0) ' just to match CreatePlane rotation
		Return mesh
		
	End Function
	
	' Openb3d
	
	Method CreateBone:TBone( parent_ent:TEntity=Null ) ' same as function in TBone
	
		Local inst:Byte Ptr=CreateBone_( GetInstance(Self),GetInstance(parent_ent) )
		CopyList(bones)
		If is_anim=0
			is_anim=1
			CopyList(anim_surf_list)
			For Local surf:TSurface=EachIn anim_surf_list
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
		Return TBone.CreateObject(inst)
		
	End Method
	
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
		Local mesh:TMesh=CreateObject(inst)
		If pick_mode[0] Then TPick.AddList_(TPick.ent_list)
		Return mesh
		
	End Method
	
	Method SkinMesh( surf_no_get:Int,vid:Int,bone1:Int,weight1:Float=1.0,bone2:Int=0,weight2:Float=0,bone3:Int=0,weight3:Float=0,bone4:Int=0,weight4:Float=0 )
	
		SkinMesh_( GetInstance(Self),surf_no_get,vid,bone1,weight1,bone2,weight2,bone3,weight3,bone4,weight4 )
		
	End Method
	
	' Warner
	
	Method SetMatrix( matrix:TMatrix )
	
		If parent <> Null
			Local invpar:TMatrix = NewMatrix()
			parent.mat.GetInverse(invpar)
			invpar.Multiply(matrix)
		EndIf
		
		'Local pos_x# = matrix.grid[(4*3)+0]
		'Local pos_y# = matrix.grid[(4*3)+1]
		'Local pos_z# = matrix.grid[(4*3)+2]
		'PositionMesh(pos_x, pos_y, pos_z) ' makes a mess
		
		Local rot:TQuaternion = NewQuaternion()
		matrix.ToQuat(rot.x[0], rot.y[0], rot.z[0], rot.w[0])
		RotateMesh(rot.x[0], rot.y[0], rot.z[0])
		
		Local size:TVector = matrix.GetMatrixScale()
		ScaleMesh(size.x, size.y, size.z)
		
	End Method
	
	Method PositionAnimMesh( px#,py#,pz# )
	
		Local count_children% = TEntity.CountAllChildren(Self)
		Local pos:TVector = New TVector
		For Local child_no% = 1 To count_children
			Local count%=0
			Local child_ent:TEntity = GetChildFromAll(child_no, count)
			TMesh(child_ent).PositionMesh(px, py, pz)
		Next
		
	End Method
	
	Method RotateAnimMesh( rx#,ry#,rz# )
	
		Local count_children% = TEntity.CountAllChildren(Self)
		For Local child_no% = 1 To count_children
			Local count%=0
			Local child_ent:TEntity = GetChildFromAll(child_no, count)
			TMesh(child_ent).RotateMesh(rx, ry, rz)
		Next
		
	End Method
	
	Method ScaleAnimMesh( sx#,sy#,sz# )
	
		Local count_children% = TEntity.CountAllChildren(Self)
		For Local child_no% = 1 To count_children
			Local count%=0
			Local child_ent:TEntity = GetChildFromAll(child_no, count)
			TMesh(child_ent).ScaleMesh(sx, sy, sz)
		Next
		
	End Method
	
	Method TransformVertices( matrix:TMatrix )
	
		Local pos:TVector = New TVector
		For Local surf:TSurface = EachIn surf_list
			For Local v% = 0 To surf.no_verts[0]-1
				pos.x = surf.vert_coords[v*3 + 0]
				pos.y = surf.vert_coords[v*3 + 1]
				pos.z = surf.vert_coords[v*3 + 2]
				matrix.TransformVec(pos.x, pos.y, pos.z, 1)
				surf.vert_coords[v*3 + 0] = pos.x
				surf.vert_coords[v*3 + 1] = pos.y
				surf.vert_coords[v*3 + 2] = pos.z
			Next
		Next
		
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
	
		If exists
			TMatrix.FreeObject( TMatrix.GetInstance(mat_sp) ) ; mat_sp=Null
			
			For Local surf:TSurface=EachIn surf_list
				TBrush.FreeObject( TBrush.GetInstance(surf.brush) ) ; surf.brush=Null
				TSurface.FreeObject( TSurface.GetInstance(surf) ) ; surf=Null
			Next
			For Local anim_surf:TSurface=EachIn anim_surf_list
				TBrush.FreeObject( TBrush.GetInstance(anim_surf.brush) ) ; anim_surf.brush=Null
				TSurface.FreeObject( TSurface.GetInstance(anim_surf) ) ; anim_surf=Null
			Next
			For Local bone:TBone=EachIn bones
				bone.FreeEntity()
			Next
			
			ClearList(surf_list) ; surf_list_id=0
			ClearList(anim_surf_list) ; anim_surf_list_id=0
			ClearList(bones) ; bones_id=0
			
			Super.FreeEntity()
		EndIf
		
	End Method
	
	Function CreateMesh:TMesh( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateMesh_( GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Function LoadMesh:TMesh( file:String,parent:TEntity=Null )
	
		Select MESH_LOADER
		
			Case 2 ' library
				Local cString:Byte Ptr=file.ToCString()
				Local inst:Byte Ptr=LoadMesh_( cString,GetInstance(parent) )
				Local mesh:TMesh=CreateObject(inst)
				MemFree cString
				Return mesh ' no children, mesh is collapsed
				
			Default ' wrapper
				Local ent:TMesh=LoadAnimMesh(file)
				ent.HideEntity()
				Local mesh:TMesh=ent.CollapseAnimMesh()
				ent.FreeEntity()
				
				mesh.SetString(mesh.class_name,"Mesh")
				mesh.AddParent(parent)
				mesh.EntityListAdd(entity_list)
				
				' update matrix
				If mesh.parent<>Null
					mesh.mat.Overwrite(mesh.parent.mat)
					mesh.UpdateMat()
				Else
					mesh.UpdateMat(True)
				EndIf
				Return mesh
				
		EndSelect
		
	End Function
	
	Function LoadAnimMesh:TMesh( file:String,parent:TEntity=Null )
	
		Select MESH_LOADER
		
			Case 2 ' library
				Local cString:Byte Ptr=file.ToCString()
				Local inst:Byte Ptr=LoadAnimMesh_( cString,GetInstance(parent) )
				Local mesh:TMesh=CreateObject(inst)
				MemFree cString
				mesh.CreateAllChildren() ' create child mesh objects
				Return mesh
				
			Default ' wrapper
				If ExtractExt(file)="b3d"
					Return TB3D.LoadAnimB3D( file,parent )
				ElseIf ExtractExt(file)="md2"
					' md2 todo!
				ElseIf ExtractExt(file)="3ds"
					Local obj:T3DS = New T3DS ' hierarchy animation todo
					Return obj.LoadMesh3DS( file,parent )
				EndIf
				
		EndSelect
		
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
	
	Method PaintMesh( bru:TBrush )
	
		PaintMesh_( GetInstance(Self),TBrush.GetInstance(bru) )
		
		For Local surf:TSurface=EachIn surf_list
			If surf.brush<>Null Then surf.brush.InitFields()
		Next
		
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
		Local surf:TSurface=TSurface.CreateObject(inst)
		CopyList(surf_list)
		Return surf
		
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
		Return TSurface.GetObject(inst) ' no CreateObject
		
	End Method
	
	' *** note: unlike B3D version, this will find a surface with no brush, if a null brush is supplied
	Method FindSurface:TSurface( brush:TBrush )
	
		For Local surf:TSurface=EachIn surf_list
			If TBrush.CompareBrushes( brush,surf.brush )=True Then Return surf
		Next
		Return Null
		
	End Method
	
	' Internal
	
	Method CopyEntity:TMesh( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Local mesh:TMesh=CreateObject(inst)
		If pick_mode[0] Then TPick.AddList_(TPick.ent_list)
		Return mesh
		
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
	' has to be function as we need to use this function with all entities and not just meshes(?)
	Method CollapseChildren:TMesh( ent0:TEntity,mesh:TMesh=Null )
	
		Local inst:Byte Ptr=CollapseChildren_( GetInstance(Self),GetInstance(ent0),GetInstance(mesh) )
		Local mesh2:TMesh=TMesh( GetObject(inst) )
		If mesh2=Null And inst<>Null Then mesh2=CreateObject(inst)
		Return mesh2
		
	End Method

	' used by LoadMesh
	Method TransformMesh( mat:TMatrix )
	
		TransformMesh_( GetInstance(Self),TMatrix.GetInstance(mat) )
		
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
	
	' Note: operator overloads not added as build breaks on NG older than v0.87
	Rem
	?bmxng
	Const CSG_SUBTRACT:Int	= 0 ' Method 0 subtracts mesh2 from mesh1
	Const CSG_ADD:Int		= 1 ' Method 1 adds meshes
	Const CSG_INTERSECT:Int	= 2 ' Method 2 intersects meshes
	
	' Operator overloading in bmx-ng allows adding/subtracting meshes
	' eg. "Local csg:TMesh=tube+tube2" to produce new mesh with CSG operations
	
	Method Operator+:TMesh( add_mesh:TMesh )
		Return MeshCSG( Self,add_mesh,CSG_ADD )
	End Method
	
	Method Operator-:TMesh( add_mesh:TMesh )
		Return MeshCSG( Self,add_mesh,CSG_SUBTRACT )
	End Method
	?
	EndRem
	
End Type
