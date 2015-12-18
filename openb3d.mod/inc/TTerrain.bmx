
Rem
bbdoc: Terrain entity
End Rem
Type TTerrain Extends TEntity

	Global terrain_list:TList=CreateList() ' Terrain list
	Global triangleindex:Int Ptr
	'Global mesh_info:TMeshInfo ' current collision data
	
	Field size:Float Ptr ' TerrainSize - 0
	Field vsize:Float Ptr ' TerrainHeight
	Field level2dzsize:Float Ptr ' Max midpoint displacement per level - array [ROAM_LMAX+1]
	Field height:Float Ptr ' heightmap
	
	'Field c_col_tree:TMeshCollider ' used for terrain collisions
	Field eyepoint:TCamera ' reference to camera
	Field ShaderMat:TShader ' NULL
	
	Function CreateObject:TTerrain( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TTerrain=New TTerrain
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function InitGlobals() ' Once per Graphics3D
	
		triangleindex=StaticInt_( TERRAIN_class,TERRAIN_triangleindex )
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		Super.InitFields()
		
		' float
		size=TerrainFloat_( GetInstance(Self),TERRAIN_size )
		vsize=TerrainFloat_( GetInstance(Self),TERRAIN_vsize )
		level2dzsize=TerrainFloat_( GetInstance(Self),TERRAIN_level2dzsize )
		height=TerrainFloat_( GetInstance(Self),TERRAIN_height )
		
		' camera_
		Local inst:Byte Ptr=TerrainCamera_( GetInstance(Self),TERRAIN_eyepoint )
		eyepoint=TCamera( TEntity.GetObject(inst) )
		If eyepoint=Null And inst<>Null Then eyepoint=TCamera.CreateObject(inst)
		
		' shader
		inst=TerrainShader_( GetInstance(Self),TERRAIN_ShaderMat )
		ShaderMat=TShader.GetObject(inst)
		If ShaderMat=Null And inst<>Null Then ShaderMat=TShader.CreateObject(inst)
		
	End Method
	
	Function CopyList_( list:TList ) ' Global list
	
		Local inst:Byte Ptr
		ClearList list
		
		Select list
			Case terrain_list
				For Local id:Int=0 To StaticListSize_( TERRAIN_class,TERRAIN_terrain_list )-1
					inst=StaticIterListTerrain_( TERRAIN_class,TERRAIN_terrain_list )
					Local obj:TTerrain=TTerrain( GetObject(inst) )
					If obj=Null And inst<>Null Then obj=TTerrain.CreateObject(inst)
					ListAddLast list,obj
				Next
		End Select
		
	End Function
	
	' Openb3d
	
	Function CreateTerrain:TTerrain( size:Int,parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateTerrain_( size,GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Function LoadTerrain:TTerrain( file:String,parent:TEntity=Null )
	
		Local cString:Byte Ptr=file.ToCString()
		Local inst:Byte Ptr=LoadTerrain_( cString,GetInstance(parent) )
		Local terr:TTerrain=CreateObject(inst)
		MemFree cString
		Return terr
		
	End Function
	
	Method ModifyTerrain( x:Int,z:Int,new_height:Float )
	
		ModifyTerrain_( GetInstance(Self),x,z,new_height )
		
	End Method
	
	Method TerrainHeight:Float( x:Int,z:Int )
	
		Return TerrainHeight_( GetInstance(Self),x,z )
		
	End Method
	
	Method TerrainX:Float( x:Float,y:Float,z:Float )
	
		Return TerrainX_( GetInstance(Self),x,y,z )
		
	End Method
	
	Method TerrainY:Float( x:Float,y:Float,z:Float )
	
		Return TerrainY_( GetInstance(Self),x,y,z )
		
	End Method
	
	Method TerrainZ:Float( x:Float,y:Float,z:Float )
	
		Return TerrainZ_( GetInstance(Self),x,y,z )
		
	End Method
	
	' Internal
	
	Method CopyEntity:TTerrain( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return CreateObject(inst)
		
	End Method
	
	Method Update() ' empty
	
		
		
	End Method
	
	' called in UpdateEntityRender (in Render)
	Method UpdateTerrain()
	
		UpdateTerrain_( GetInstance(Self) )
		
	End Method
	
	' called in UpdateTerrain
	Method RecreateROAM()
	
		RecreateROAM_( GetInstance(Self) )
		
	End Method
	
	' called in RecreateROAM and recursively
	Method drawsub( l:Int,v0:Float[],v1:Float[],v2:Float[] )
	
		drawsub_( GetInstance(Self),l,v0,v1,v2 )
		
	End Method
	
	' called in LoadTerrain
	Method UpdateNormals()
	
		TerrainUpdateNormals_( GetInstance(Self) )
		
	End Method
	
	'void TreeCheck(CollisionInfo* ci);
	
	' called in TreeCheck and recursively
	Method col_tree_sub( l:Int,v0:Float[],v1:Float[],v2:Float[] )
	
		col_tree_sub_( GetInstance(Self),l,v0,v1,v2 )
		
	End Method
	
End Type
