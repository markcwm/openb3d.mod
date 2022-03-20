
Rem
bbdoc: Mesh entity
End Rem
Type TMesh Extends TEntity
	Global plane_list:TList=CreateList()
	
	Field no_surfs:Int Ptr ' 0
	
	Field surf_list:TList=CreateList() ' Surface list
	Field anim_surf_list:TList=CreateList() ' Surface list ' only used if mesh contains anim info, only contains vertex coords array, initialised upon loading b3d
	
	Field bones:TList=CreateList() ' Bone vector
	
	Field mat_sp:TMatPtr ' used in TMesh's Update to provide necessary additional transform matrix for sprites
	
	'Field c_col_tree:TMeshCollider ' openb3d: used for terrain collisions - NULL
	Field reset_col_tree:Int Ptr ' true (reset flag) - 0
	
	' reset flags are set when mesh shape is changed by various commands in TMesh
	Field reset_bounds:Int Ptr ' true (reset flag) - true
	
	Field min_x:Float Ptr,min_y:Float Ptr,min_z:Float Ptr ' 0.0/0.0/0.0
	Field max_x:Float Ptr,max_y:Float Ptr,max_z:Float Ptr ' 0.0/0.0/0.0
	
	' minib3d
	'Field no_bones:Int=0
	'Field col_tree:TColTree=New TColTree
	
	' extra
	Field shared_surf:Int Ptr ' for FreeEntity
	Field shared_anim_surf:Int Ptr
	Field plane_divisions:Int = 1
	
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
		shared_surf=MeshInt_( GetInstance(Self),MESH_shared_surf )
		shared_anim_surf=MeshInt_( GetInstance(Self),MESH_shared_anim_surf )
		
		' float
		min_x=MeshFloat_( GetInstance(Self),MESH_min_x )
		min_y=MeshFloat_( GetInstance(Self),MESH_min_y )
		min_z=MeshFloat_( GetInstance(Self),MESH_min_z )
		max_x=MeshFloat_( GetInstance(Self),MESH_max_x )
		max_y=MeshFloat_( GetInstance(Self),MESH_max_y )
		max_z=MeshFloat_( GetInstance(Self),MESH_max_z )
		
		' matrix
		Local inst:Byte Ptr=MeshMatrix_( GetInstance(Self),MESH_mat_sp )
		mat_sp=TMatPtr.GetObject(inst)
		If mat_sp=Null And inst<>Null Then mat_sp=TMatPtr.CreateObject(inst)
				
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
		DebugLog pad+" Mesh instance: "+StringPtr(GetInstance(Self))
		
		' int
		If no_surfs<>Null Then DebugLog(pad+" no_surfs: "+no_surfs[0]) Else DebugLog(pad+" no_surfs: Null")
		If reset_col_tree<>Null Then DebugLog(pad+" reset_col_tree: "+reset_col_tree[0]) Else DebugLog(pad+" reset_col_tree: Null")
		If reset_bounds<>Null Then DebugLog(pad+" reset_bounds: "+reset_bounds[0]) Else DebugLog(pad+" reset_bounds: Null")
		
		' float
		If min_x<>Null Then DebugLog(pad+" min_x: "+min_x[0]) Else DebugLog(pad+" min_x: Null")
		If min_y<>Null Then DebugLog(pad+" min_y: "+min_y[0]) Else DebugLog(pad+" min_y: Null")
		If min_z<>Null Then DebugLog(pad+" min_z: "+min_z[0]) Else DebugLog(pad+" min_z: Null")
		If max_x<>Null Then DebugLog(pad+" max_x: "+max_x[0]) Else DebugLog(pad+" max_x: Null")
		If max_y<>Null Then DebugLog(pad+" max_y: "+max_y[0]) Else DebugLog(pad+" max_y: Null")
		If max_z<>Null Then DebugLog(pad+" max_z: "+max_z[0]) Else DebugLog(pad+" max_z: Null")
		
		' matrix
		DebugLog pad+" mat_sp: "+StringPtr(TMatPtr.GetInstance(mat_sp))
		If debug_subobjects And mat_sp<>Null Then mat_sp.DebugFields( debug_subobjects,debug_base_types )
		
		' lists
		For Local surf:TSurface=EachIn surf_list
			DebugLog pad+" surf_list: "+StringPtr(TSurface.GetInstance(surf))
			If debug_subobjects And surf<>Null Then surf.DebugFields( debug_subobjects,debug_base_types )
		Next
		For Local anim_surf:TSurface=EachIn anim_surf_list
			DebugLog pad+" anim_surf_list: "+StringPtr(TSurface.GetInstance(anim_surf))
			If debug_subobjects And anim_surf<>Null Then anim_surf.DebugFields( debug_subobjects,debug_base_types )
		Next
		For Local bone:TBone=EachIn bones
			DebugLog pad+" bones list: "+StringPtr(TBone.GetInstance(bone))
			If debug_subobjects And bone<>Null Then bone.DebugFields( debug_subobjects,debug_base_types )
		Next
		
		DebugLog ""
		
		If debug_base_types Then Super.DebugFields( debug_subobjects,debug_base_types )
		
	End Method
	
	Method AddList( list:TList ) ' Field list
	
		Super.AddList(list)
		
		Select list
			Case surf_list
				If MeshListSize_( GetInstance(Self),MESH_surf_list )
					Local inst:Byte Ptr=MeshIterListSurface_( GetInstance(Self),MESH_surf_list,Varptr surf_list_id )
					Local obj:TSurface=TSurface.GetObject(inst)
					If obj=Null And inst<>Null Then obj=TSurface.CreateObject(inst)
					If obj Then ListAddLast( list,obj )
				EndIf
			Case anim_surf_list
				If MeshListSize_( GetInstance(Self),MESH_anim_surf_list )
					Local inst:Byte Ptr=MeshIterListSurface_( GetInstance(Self),MESH_anim_surf_list,Varptr anim_surf_list_id )
					Local obj:TSurface=TSurface.GetObject(inst)
					If obj=Null And inst<>Null Then obj=TSurface.CreateObject(inst)
					If obj Then ListAddLast( list,obj )
				EndIf
			Case bones
				If MeshListSize_( GetInstance(Self),MESH_bones )
					Local inst:Byte Ptr=MeshIterVectorBone_( GetInstance(Self),MESH_bones,Varptr bones_id )
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
					Local inst:Byte Ptr=MeshIterListSurface_( GetInstance(Self),MESH_surf_list,Varptr surf_list_id )
					Local obj:TSurface=TSurface.GetObject(inst)
					If obj=Null And inst<>Null Then obj=TSurface.CreateObject(inst)
					If obj Then ListAddLast( list,obj )
				Next
			Case anim_surf_list
				anim_surf_list_id=0
				For Local id:Int=0 To MeshListSize_( GetInstance(Self),MESH_anim_surf_list )-1
					Local inst:Byte Ptr=MeshIterListSurface_( GetInstance(Self),MESH_anim_surf_list,Varptr anim_surf_list_id )
					Local obj:TSurface=TSurface.GetObject(inst)
					If obj=Null And inst<>Null Then obj=TSurface.CreateObject(inst)
					If obj Then ListAddLast( list,obj )
				Next
			Case bones
				bones_id=0
				For Local id:Int=0 To MeshListSize_( GetInstance(Self),MESH_bones )-1
					Local inst:Byte Ptr=MeshIterVectorBone_( GetInstance(Self),MESH_bones,Varptr bones_id )
					Local obj:TBone=TBone( TEntity.GetObject(inst) )
					If obj=Null And inst<>Null Then obj=TBone.CreateObject(inst)
					If obj Then ListAddLast( list,obj )
				Next
			End Select
			
	End Method
	
	Method MeshListAdd( list:TList,value:Object )
	
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
	
	Method MeshListRemove( list:TList,value:Object )
	
		Local surf:TSurface=TSurface(value)
		Local bone:TBone=TBone(value)
		
		Select list
			Case surf_list
				If surf
					MeshListRemoveSurface_( GetInstance(Self),MESH_surf_list,TSurface.GetInstance(surf) )
					ListRemove( list,value ) ; surf_list_id:-1
				EndIf
			Case anim_surf_list
				If surf
					MeshListRemoveSurface_( GetInstance(Self),MESH_anim_surf_list,TSurface.GetInstance(surf) )
					ListRemove( list,value ) ; anim_surf_list_id:-1
				EndIf
			Case bones
				If bone
					MeshListRemoveBone_( GetInstance(Self),MESH_bones,TBone.GetInstance(bone) )
					ListRemove( list,value ) ; bones_id:-1
				EndIf
		End Select
		
	End Method
	
	Method MeshArrayResize( varid:Int,size:Int )
	
		Select varid
			Case MESH_bones
				MeshResizeBoneVector_( TEntity.GetInstance(Self),MESH_bones,size )
				CopyList(bones)
		End Select
		
	End Method
	
	Method MeshArraySet( varid:Int,pos:Int,value:Object )
	
		Local bone:TBone=TBone(value)
		
		Select varid
			Case MESH_bones
				If bone
					MeshSetBoneVector_( GetInstance(Self),MESH_bones,pos,GetInstance(bone) )
				EndIf
		End Select
		
	End Method
	
	Function NewMesh:TMesh()
	
		Local inst:Byte Ptr=NewMesh_()
		Return CreateObject(inst)
		
	End Function
	
	Function Create:TMesh()
	
		Local inst:Byte Ptr=NewMesh_()
		Return CreateObject(inst)
		
	End Function
	
	Rem
	Method NewSurface:TSurface() ' use MeshListAdd(list,value)
	
		Local inst:Byte Ptr=NewSurface_( GetInstance(Self) )
		Return TSurface.CreateObject(inst)
		
	End Method
	
	Method NewBone:TBone()
	
		Local inst:Byte Ptr=NewBone_( GetInstance(Self) )
		Return TBone.CreateObject(inst)
		
	End Method
	EndRem
	
	' Extra
	
	Method LightMesh( red:Float,green:Float,blue:Float,range:Float=0,light_x:Float=0,light_y:Float=0,light_z:Float=0 )
	
		LightMesh_( GetInstance(Self),red,green,blue,range,light_x,light_y,light_z )
		
	End Method
	
	Method CreateAllChildren()
	
		Local child_no%=1 ' used to select child entity
		Local count_children%=CountAllChildren(Self) ' total no. of children belonging to entity
		For Local child_no% = 1 To count_children
			Local count%=0
			Local inst:Byte Ptr=GetChildFromAll_( GetInstance(Self),child_no,Varptr count,Null )
			Local child_ent:TEntity=GetObject(inst) ' child entity of anim mesh
			If child_ent=Null And inst<>Null Then child_ent=CreateObject(inst)
		Next
		
	End Method
	
	Function CreatePlane:TMesh(divisions:Int=1, parent:TEntity=Null)
	
		Local mesh:TMesh = CreateMesh(parent)
		Local surf:TSurface = CreateSurface(mesh)
		mesh.plane_divisions = divisions
		ListAddLast plane_list, mesh
		Return mesh
		
	End Function
	
	' planes are updated in RenderWorld
	Function UpdatePlane(mesh:TMesh)
	
		Local iv%,ix%,iz%,ptx#,ptz#
		Local camera:TCamera = TGlobal3D.camera_in_use
		Local size# = camera.range_far[0] * 1.5 ' always size of range_far so it can be clipped
		Local surf:TSurface = GetSurface(mesh,1)
		If CountVertices(surf)>0 Then ClearSurface surf
		
		Local divisions% = mesh.plane_divisions
		If divisions>64 Then divisions = 64 ' limit of triangles
		If divisions<1 Then divisions = 1
		Local subsize# = size / divisions
		
		For iz = 0 To divisions
			For ix = 0 To divisions
				ptx = ((ix*subsize)-(divisions/2*subsize)) * 2 ' ipos-midpos
				ptz = ((iz*subsize)-(divisions/2*subsize)) * 2
				iv = ix+(iz*(divisions+1)) ' iv=x+(z*x1)
				surf.AddVertex ptx,0,ptz,ptx,-ptz,0
				surf.VertexNormal iv,0,1,0
			Next
		Next

		For iz = 0 To divisions-1
			For ix = 0 To divisions-1
				iv = ix+(iz*(divisions+1))
				surf.AddTriangle iv,iv+divisions+1,iv+divisions+2 ' 0,x1,x2
				surf.AddTriangle iv+divisions+2,iv+1,iv ' x2,1,0
			Next
		Next
		
		Rem
		AddVertex surf,-size,0,size,-size,-size,0
		AddVertex surf,size,0,size,size,-size,0
		AddVertex surf,size,0,-size,size,size,0
		AddVertex surf,-size,0,-size,-size,size,0
		
		AddTriangle surf,0,1,2
		AddTriangle surf,0,2,3
		
		VertexNormal surf,0,0,1,0
		VertexNormal surf,1,0,1,0
		VertexNormal surf,2,0,1,0
		VertexNormal surf,3,0,1,0
		EndRem
		
		Local cx# = EntityX(camera,True)
		Local cz# = EntityZ(camera,True)
		Local tex:TTexture = mesh.brush.tex[0]
		
		If tex<>Null Then PositionTexture tex,-cx*tex.u_scale[0],cz*tex.v_scale[0]
		PositionEntity mesh,cx,0,cz
		
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
	
	Method PositionAnimMesh( px#,py#,pz# )
	
		Self.PositionMesh(px, py, pz)
		Local count_children% = TEntity.CountAllChildren(Self)
		For Local child_no% = 1 To count_children
			Local count%=0
			Local child_ent:TEntity = GetChildFromAll(child_no, count)
			TMesh(child_ent).PositionMesh(px, py, pz)
		Next
		
	End Method
	
	Method RotateAnimMesh( rx#,ry#,rz# )
	
		Self.RotateMesh(rx, ry, rz)
		Local count_children% = TEntity.CountAllChildren(Self)
		For Local child_no% = 1 To count_children
			Local count%=0
			Local child_ent:TEntity = GetChildFromAll(child_no, count)
			TMesh(child_ent).RotateMesh(rx, ry, rz)
		Next
		
	End Method
	
	Method ScaleAnimMesh( sx#,sy#,sz# )
	
		Self.ScaleMesh(sx, sy, sz)
		Local count_children% = TEntity.CountAllChildren(Self)
		For Local child_no% = 1 To count_children
			Local count%=0
			Local child_ent:TEntity = GetChildFromAll(child_no, count)
			TMesh(child_ent).ScaleMesh(sx, sy, sz)
		Next
		
	End Method
	
	Method TransformVertices( matrix:TMatPtr )
	
		Local px:Float, py:Float, pz:Float
		For Local surf:TSurface = EachIn surf_list
			For Local v:Int = 0 Until surf.CountVertices()
				px = surf.vert_coords[(v*3)+0]
				py = surf.vert_coords[(v*3)+1]
				pz = surf.vert_coords[(v*3)+2]
				
				matrix.TransformVec(px, py, pz, 1)
				
				surf.vert_coords[(v*3)+0] = px
				surf.vert_coords[(v*3)+1] = py
				surf.vert_coords[(v*3)+2] = pz
			Next
		Next
		
	End Method
	
	' RemiD
	
	' Update normals according to vertex structure, see syntaxbomb topic 4342
	Method UpdateVerticesNormals%( Surface:TSurface )
	
		If Surface=Null Then Return 0
		
		'To store the temps indexes
		Local NumTris%=Surface.CountTriangles()
		Local TempsCount%
		Local TempI%[NumTris]
		
		'To store the normals of all triangles of a surface
		Local TrianglesCount%
		Local TriangleNX#[NumTris+1]
		Local TriangleNY#[NumTris+1]
		Local TriangleNZ#[NumTris+1]
		
		'To store the normals of the triangles which use a vertex
		Local NormalsCount%
		Local NormalNX#[]
		Local NormalNY#[]
		Local NormalNZ#[]
		
		'For each triangle of the surface
		TrianglesCount% = 0
		For Local TI% = 0 To Surface.CountTriangles()-1 Step 1
		
			'retrieve the X,Y,Z world coordinates of Vertex0, Vertex1, Vertex2 of this triangle
			'V0
			Local V0I% = TriangleVertex(Surface,TI,0)
			TFormPoint(VertexX(Surface,V0I),VertexY(Surface,V0I),VertexZ(Surface,V0I),Self,Null)
			Local V0GX# = TFormedX()
			Local V0GY# = TFormedY()
			Local V0GZ# = TFormedZ()
			'V1
			Local V1I% = TriangleVertex(Surface,TI,1)
			TFormPoint(VertexX(Surface,V1I),VertexY(Surface,V1I),VertexZ(Surface,V1I),Self,Null)
			Local V1GX# = TFormedX()
			Local V1GY# = TFormedY()
			Local V1GZ# = TFormedZ()
			'V2
			Local V2I% = TriangleVertex(Surface,TI,2)
			TFormPoint(VertexX(Surface,V2I),VertexY(Surface,V2I),VertexZ(Surface,V2I),Self,Null)
			Local V2GX# = TFormedX()
			Local V2GY# = TFormedY()
			Local V2GZ# = TFormedZ()
			
			'calculate the normal of the triangle by using the world position of its vertices
			'Vector 0->1
			Local Vec01X# = V0GX - V1GX
			Local Vec01Y# = V0GY - V1GY
			Local Vec01Z# = V0GZ - V1GZ
			'Vector 0->2
			Local Vec02X# = V0GX - V2GX
			Local Vec02Y# = V0GY - V2GY
			Local Vec02Z# = V0GZ - V2GZ
			
			Local CPX# = ( Vec01Y * Vec02Z ) - ( Vec01Z * Vec02Y )
			Local CPY# = ( Vec01Z * Vec02X ) - ( Vec01X * Vec02Z )
			Local CPZ# = ( Vec01X * Vec02Y ) - ( Vec01Y * Vec02X )
			
			Local Length# = Sqr( ( CPX * CPX ) + ( CPY * CPY ) + ( CPZ * CPZ ) )
			
			Local NX# = CPX / Length
			Local NY# = CPY / Length
			Local NZ# = CPZ / Length
			
			'store the normal in the triangles list
			TrianglesCount = TrianglesCount + 1
			Local TriI% = TrianglesCount
			TriangleNX[TriI] = NX
			TriangleNY[TriI] = NY
			TriangleNZ[TriI] = NZ
			
		Next
		
		'For each vertex
		For Local VI% = 0 To Surface.CountVertices()-1 Step 1
		
			'identify which triangles use this vertex
			Local TempsCount% = 0
			For Local TI% = 0 To Surface.CountTriangles()-1 Step 1
				If TriangleVertex(Surface,TI,0) = VI Or TriangleVertex(Surface,TI,1) = VI Or TriangleVertex(Surface,TI,2) = VI
					'add the triangle To the temps list
					TempsCount = TempsCount + 1
					Local TemI% = TempsCount
					TempI[TemI] = TI
				EndIf
			Next
			
			'For each identified triangle
			Local NormalsCount% = 0
			For Local TemI% = 1 To TempsCount Step 1
				Local TI% = TempI[TemI]
				
				'get the triangle normal (previously calculated)
				Local NX# = TriangleNX[TI+1]
				Local NY# = TriangleNY[TI+1]
				Local NZ# = TriangleNZ[TI+1]
				
				'add the normal To the normals list
				NormalsCount = NormalsCount + 1
				NormalNX=NormalNX[..NormalsCount+1]
				NormalNY=NormalNY[..NormalsCount+1]
				NormalNZ=NormalNZ[..NormalsCount+1]
				
				Local NorI% = NormalsCount
				NormalNX[NorI] = NX
				NormalNY[NorI] = NY
				NormalNZ[NorI] = NZ
			Next
			
			'calculate the average normal vector, by considering the normals of the triangles using this vertex
			Local VNX# = 0
			Local VNY# = 0
			Local VNZ# = 0
			For Local NorI% = 1 To NormalsCount Step 1
				VNX = VNX + NormalNX[NorI]
				VNY = VNY + NormalNY[NorI]
				VNZ = VNZ + NormalNZ[NorI]
			Next
			
			VNX = VNX / NormalsCount
			VNY = VNY / NormalsCount
			VNZ = VNZ / NormalsCount
			
			'set the normal of this vertex
			VertexNormal(Surface,VI,VNX,VNY,VNZ)
			
		Next
		
		Return 1
		
	End Method
	
	' Minib3d
	
	Method New()
		
		If TGlobal3D.Log_New
			DebugLog " New TMesh"
		EndIf
	
	End Method
	
	Method Delete()
	
		If TGlobal3D.Log_Del
			DebugLog " Del TMesh"
		EndIf
	
	End Method
	
	Method FreeEntity()
	
		If exists
			TMatPtr.FreeObject( TMatPtr.GetInstance(mat_sp) ) ; mat_sp=Null
			
			For Local surf:TSurface=EachIn surf_list
				TBrush.FreeObject( TBrush.GetInstance(surf.brush) ) ; surf.brush=Null
				TSurface.FreeObject( TSurface.GetInstance(surf) ) ; surf=Null
			Next
			
			ClearList(surf_list) ; surf_list_id=0
			
			For Local anim_surf:TSurface=EachIn anim_surf_list
				TBrush.FreeObject( TBrush.GetInstance(anim_surf.brush) ) ; anim_surf.brush=Null
				TSurface.FreeObject( TSurface.GetInstance(anim_surf) ) ; anim_surf=Null
			Next
			
			ClearList(anim_surf_list) ; anim_surf_list_id=0
			
			For Local bone:TBone=EachIn bones
				bone.FreeEntity()
			Next
			
			ClearList(bones) ; bones_id=0
			
			Super.FreeEntity()
		EndIf
		
	End Method
	
	Function CreateMesh:TMesh( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateMesh_( GetInstance(parent) )
		Return CreateObject(inst)
		
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
	
	 ' used by LoadMesh - replaced as not working right
	Rem
	Method CollapseAnimMesh:TMesh( mesh:TMesh=Null )
	
		Local inst:Byte Ptr=CollapseAnimMesh_( GetInstance(Self),GetInstance(mesh) )
		Local mesh2:TMesh=TMesh( GetObject(inst) )
		If mesh2=Null And inst<>Null Then mesh2=CreateObject(inst)
		Return mesh2
		
	End Method
	EndRem
	
	Method CollapseAnimMesh:TMesh()
	
		Local new_mesh:TMesh=Create()
		Local child_ent:TEntity=Null
		Local count_children%=TEntity.CountAllChildren(Self)
		For Local child_no%=0 To count_children
			Local count%=0
			If child_no=0
				child_ent=TEntity(Self)
			Else
				child_ent=GetChildFromAll(child_no, count)
			EndIf
			If TMesh(child_ent)<>Null
				TMesh(child_ent).TransformMesh(child_ent.mat)
				
				For Local surf:TSurface=EachIn TMesh(child_ent).surf_list
					Local new_surf:TSurface=surf.Copy()
					
					new_mesh.MeshListAdd(new_mesh.surf_list, new_surf)
					new_mesh.no_surfs[0]=new_mesh.no_surfs[0]+1
				Next
			EndIf
		Next
		
		Return new_mesh
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
	Method TransformMesh( mat:TMatPtr )
	
		TransformMesh_( GetInstance(Self),TMatPtr.GetInstance(mat) )
		
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
