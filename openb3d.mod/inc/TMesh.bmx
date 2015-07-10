Rem
bbdoc: Mesh entity
End Rem
Type TMesh Extends TEntity
	
	Field min_x#,min_y#,min_z#,max_x#,max_y#,max_z#

	Field no_surfs:Int=0
	Field surf_list:TList=CreateList()
	Field anim_surf_list:TList=CreateList() ' only used if mesh contains anim info, only contains vertex coords array, initialised upon loading b3d
	
	Field no_bones:Int=0
	Field bones:TBone[]
	
	Field mat_sp:TMatrix=New TMatrix ' mat_sp used in TMesh's Update to provide necessary additional transform matrix for sprites
		
	Field col_tree:TColTree=New TColTree

	' reset flags - these are set when mesh shape is changed by various commands in TMesh
	Field reset_bounds:Int=True
	'Field reset_col_tree=True
	
	' Create and map object from C++ instance
	Function NewObject:TMesh( inst:Byte Ptr )
	
		Local obj:TMesh=New TMesh
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	Function CreateBone:TBone( mesh:TMesh,parent_ent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateBone_( GetInstance(mesh),GetInstance(parent_ent) )
		Return TBone.NewObject(instance)
		
	End Function
	
	Function CreatePlane:TMesh( divisions:Int=1,parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreatePlane_( divisions,GetInstance(parent) )
		Return NewObject(instance)
		
	End Function
	
	Function CreateQuad:TMesh( parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateQuad_( GetInstance(parent) )
		Return NewObject(instance)
		
	End Function
	
	Function MeshCSG:TMesh( m1:TMesh,m2:TMesh,method_no:Int=1 )
	
		Local instance:Byte Ptr=MeshCSG_( GetInstance(m1),GetInstance(m2),method_no )
		Local mesh:TMesh=NewObject(instance)
		Return mesh
		
	End Function
	
	Method MeshesIntersect:Int( mesh2:TMesh )
	
		Return MeshesIntersect_( GetInstance(Self),GetInstance(mesh2) )
		
	End Method
	
	Method RepeatMesh:TMesh( parent:TEntity=Null )
	
		Local instance:Byte Ptr=RepeatMesh_( GetInstance(Self),GetInstance(parent) )
		Return NewObject(instance)
		
	End Method
	
	Method SkinMesh( surf_no_get:Int,vid:Int,bone1:Int,weight1:Float=1.0,bone2:Int=0,weight2:Float=0,bone3:Int=0,weight3:Float=0,bone4:Int=0,weight4:Float=0 )
	
		SkinMesh_( GetInstance(Self),surf_no_get,vid,bone1,weight1,bone2,weight2,bone3,weight3,bone4,weight4 )
		
	End Method
	
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
	
	Method CopyEntity:TMesh( parent:TEntity=Null )
	
		Local instance:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return NewObject(instance)
		
	End Method
	
	' used by RenderWorld
	Method Update()
	
		
		
	End Method
	
	Method FreeEntity()
	
		Super.FreeEntity()
		
	End Method
	
	Function CreateMesh:TMesh( parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateMesh_( GetInstance(parent) )
		Return NewObject(instance)
		
	End Function
	
	Function LoadMesh:TMesh( file:String,parent:TEntity=Null )
	
		Local cString:Byte Ptr=file.ToCString()
		Local instance:Byte Ptr=LoadMesh_( cString,GetInstance(parent) )
		Local mesh:TMesh=NewObject(instance)
		MemFree cString
		Return mesh
		
	End Function
	
	Function LoadAnimMesh:TMesh( file:String,parent:TEntity=Null )
	
		Local cString:Byte Ptr=file.ToCString()
		Local instance:Byte Ptr=LoadAnimMesh_( cString,GetInstance(parent) )
		Local mesh:TMesh=NewObject(instance)
		MemFree cString
		Return mesh
		
	End Function
	
	Function CreateCube:TMesh( parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateCube_( GetInstance(parent) )
		Return NewObject(instance)
		
	End Function
	
	' Function by Coyote
	Function CreateSphere:TMesh( segments:Int=8,parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateSphere_( segments,GetInstance(parent) )
		Return NewObject(instance)
		
	End Function
	
	' Function by Coyote
	Function CreateCylinder:TMesh( segments:Int=8,solid:Int=True,parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateCylinder_( segments,solid,GetInstance(parent) )
		Return NewObject(instance)
		
	End Function
	
	' Function by Coyote
	Function CreateCone:TMesh( segments:Int=8,solid:Int=True,parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateCone_( segments,solid,GetInstance(parent) )
		Return NewObject(instance)
		
	End Function
	
	Method CopyMesh:TMesh( parent:TEntity=Null )
	
		Local instance:Byte Ptr=CopyMesh_( GetInstance(Self),GetInstance(parent) )
		Return NewObject(instance)
		
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
	
	Method CreateSurface:TSurface( mesh:TMesh,brush:TBrush=Null )
	
		Local instance:Byte Ptr=CreateSurface_( GetInstance(mesh),TBrush.GetInstance(brush) )
		Return TSurface.NewObject(instance)
		
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
	
		Local instance:Byte Ptr=GetSurface_( GetInstance(Self),surf_no )
		Local surf:TSurface=TSurface.GetObject(instance)
		If surf=Null And instance<>Null Then surf=TSurface.NewObject(instance)
		Return surf
		
	End Method
	
	Method FindSurface:TSurface( brush:TBrush )
	
		Local instance:Byte Ptr=FindSurface_( GetInstance(Self),TBrush.GetInstance(brush) )
		Local surf:TSurface=TSurface.GetObject(instance)
		If surf=Null And instance<>Null Then surf=TSurface.NewObject(instance)
		Return surf
		
	End Method
	
	' returns total no. of vertices in mesh
	Method CountVertices:Int()
	
		
	
	End Method
	
	' returns total no. of triangles in mesh
	Method CountTriangles:Int()
	
		
	
	End Method
		
	 ' used by CopyEntity
	Function CopyBonesList(ent:TEntity,bones:TBone[] Var,no_bones:Int Var)

		

	End Function
	
	 ' used by LoadMesh
	Method CollapseAnimMesh:TMesh(mesh:TMesh=Null)
	
		

	End Method
	
	' used by LoadMesh
	' has to be function as we need to use this function with all entities and not just meshes
	Function CollapseChildren:TMesh(ent0:TEntity,mesh:TMesh=Null)

		
		
	End Function

	' used by LoadMesh
	Method TransformMesh(mat:TMatrix)

		

	End Method
	
	' used by MeshWidth, MeshHeight, MeshDepth, RenderWorld
	Method GetBounds()
	
		

	End Method

	' returns true if mesh is to be drawn with alpha, i.e alpha<1.0.
	' this func is used in MeshListAdd to see whether entity should be manually depth sorted (if alpha=true then yes).
	' alpha_enable true/false is also set for surfaces - this is used to sort alpha surfaces and enable/disable alpha blending 
	' in TMesh.Update.
	Method Alpha:Int()
	
		

	End Method
	
End Type

