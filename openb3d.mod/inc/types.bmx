' types.bmx

' Extra types
' -----------

Rem
bbdoc: Blob entity
End Rem
Type TBlob Extends TEntity
	
	' Create and map object from C++ instance
	Function NewObject:TBlob( inst:Byte Ptr )
	
		Local obj:TBlob=New TBlob
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	Method CopyEntity:TBlob( parent:TEntity=Null )
	
		
		
	End Method
	
	Method Update()
	
		
		
	End Method
	
	Function CreateBlob:TBlob( fluid:TFluid,radius:Float,parent_ent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateBlob_( GetInstance(fluid),radius,GetInstance(parent_ent) )
		Return NewObject(instance)
		
	End Function
	
End Type

Rem
bbdoc: Fluid mesh entity
End Rem
Type TFluid Extends TMesh
	
	' Create and map object from C++ instance
	Function NewObject:TFluid( inst:Byte Ptr )
	
		Local obj:TFluid=New TFluid
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	Function CreateFluid:TFluid()
	
		Local instance:Byte Ptr=CreateFluid_()
		Return NewObject(instance)
		
	End Function
	
	Method FluidArray( Array:Float Var,w:Int,h:Int,d:Int )
	
		FluidArray_( GetInstance(Self),Varptr(Array),w,h,d )
		
	End Method
	
	Method FluidFunction( FieldFunction:Float( x:Float,y:Float,z:Float ) )
	
		FluidFunction_( GetInstance(Self),FieldFunction )
		
	End Method
	
	Method FluidThreshold( threshold:Float )
	
		FluidThreshold_( GetInstance(Self),threshold )
		
	End Method
	
End Type

Rem
bbdoc: Geosphere terrain entity
End Rem
Type TGeosphere Extends TTerrain
	
	' Create and map object from C++ instance
	Function NewObject:TGeosphere( inst:Byte Ptr )
	
		Local obj:TGeosphere=New TGeosphere
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	Function CreateGeosphere:TGeosphere( size:Int,parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateGeosphere_( size,GetInstance(parent) )
		Return NewObject(instance)
		
	End Function
	
	Function LoadGeosphere:TGeosphere( file:String,parent:TEntity=Null )
	
		Local cString:Byte Ptr=file.ToCString()
		Local instance:Byte Ptr=LoadGeosphere_( cString,GetInstance(parent) )
		Local geo:TGeosphere=NewObject(instance)
		MemFree cString
		Return geo
		
	End Function
	
	Method ModifyGeosphere( x:Int,z:Int,new_height:Float )
	
		ModifyGeosphere_( GetInstance(Self),x,z,new_height )
		
	End Method
	
	Method GeosphereHeight( h:Float )
	
		GeosphereHeight_( GetInstance(Self),h )
		
	End Method
	
End Type

Rem
bbdoc: Material texture
End Rem
Type TMaterial Extends TTexture
	
	' Create and map object from C++ instance
	Function NewObject:TMaterial( inst:Byte Ptr )
	
		Local obj:TMaterial=New TMaterial
		tex_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	Function LoadMaterial:TMaterial( filename:String,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int )
	
		Local cString:Byte Ptr=filename.ToCString()
		Local instance:Byte Ptr=LoadMaterial_( cString,flags,frame_width,frame_height,first_frame,frame_count )
		Local mat:TMaterial=NewObject(instance)
		MemFree cString
		Return mat
		
	End Function
	
End Type

Rem
bbdoc: Octree terrain entity
End Rem
Type TOcTree Extends TTerrain
	
	' Create and map object from C++ instance
	Function NewObject:TOcTree( inst:Byte Ptr )
	
		Local obj:TOcTree=New TOcTree
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	Function CreateOcTree:TOcTree( w:Float,h:Float,d:Float,parent_ent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateOcTree_( w,h,d,GetInstance(parent_ent) )
		Return NewObject(instance)
		
	End Function
	
	Method OctreeBlock( mesh:TMesh,level:Int,X:Float,Y:Float,Z:Float,Near:Float=0,Far:Float=1000 )
	
		OctreeBlock_( GetInstance(Self),GetInstance(mesh),level,X,Y,Z,Near,Far )
		
	End Method
	
	Method OctreeMesh( mesh:TMesh,level:Int,X:Float,Y:Float,Z:Float,Near:Float=0,Far:Float=1000 )
	
		OctreeMesh_( GetInstance(Self),GetInstance(mesh),level,X,Y,Z,Near,Far )
		
	End Method
	
End Type

Rem
bbdoc: Shader
End Rem
Type TShader

	Field instance:Byte Ptr
	
	' Create and map object from C++ instance
	Function NewObject:TShader( inst:Byte Ptr )
	
		Local obj:TShader=New TShader
		obj.instance=inst
		Return obj
		
	End Function
	
	' Get C++ instance from object (used for passing object to C++ function)
	Function GetInstance:Byte Ptr( obj:TShader )
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Function LoadShader:TShader( ShaderName:String,VshaderFileName:String,FshaderFileName:String )
	
		Local cString:Byte Ptr=ShaderName.ToCString()
		Local vcString:Byte Ptr=VshaderFileName.ToCString()
		Local fcString:Byte Ptr=FshaderFileName.ToCString()
		Local instance:Byte Ptr=LoadShader_( cString,vcString,fcString )
		Local material:TShader=NewObject(instance)
		MemFree cString
		MemFree vcString
		MemFree fcString
		Return material
		
	End Function
	
	Function CreateShader:TShader( ShaderName:String,VshaderString:String,FshaderString:String )
	
		Local cString:Byte Ptr=ShaderName.ToCString()
		Local vcString:Byte Ptr=VshaderString.ToCString()
		Local fcString:Byte Ptr=FshaderString.ToCString()
		Local instance:Byte Ptr=CreateShader_( cString,vcString,fcString )
		Local material:TShader=NewObject(instance)
		MemFree cString
		MemFree vcString
		MemFree fcString
		Return material
		
	End Function
	
	Method ShadeSurface( surf:TSurface )
	
		ShadeSurface_( TSurface.GetInstance(surf),GetInstance(Self) )
		
	End Method
	
	Method ShadeMesh( mesh:TMesh )
	
		ShadeMesh_( TMesh.GetInstance(mesh),GetInstance(Self) )
		
	End Method
	
	Method ShadeEntity( ent:TEntity )
	
		ShadeEntity_( TEntity.GetInstance(ent),GetInstance(Self) )
		
	End Method
	
	Method ShaderTexture( tex:TTexture,name:String,index:Int=0 )
	
		Local cString:Byte Ptr=name.ToCString()
		ShaderTexture_( GetInstance(Self),TTexture.GetInstance(tex),cString,index )
		MemFree cString
		
	End Method
	
	Method SetFloat( name:String,v1:Float )
	
		Local cString:Byte Ptr=name.ToCString()
		SetFloat_( GetInstance(Self),cString,v1 )
		MemFree cString
		
	End Method
	
	Method SetFloat2( name:String,v1:Float,v2:Float )
	
		Local cString:Byte Ptr=name.ToCString()
		SetFloat2_( GetInstance(Self),cString,v1,v2 )
		MemFree cString
		
	End Method
	
	Method SetFloat3( name:String,v1:Float,v2:Float,v3:Float )
	
		Local cString:Byte Ptr=name.ToCString()
		SetFloat3_( GetInstance(Self),cString,v1,v2,v3 )
		MemFree cString
		
	End Method
	
	Method SetFloat4( name:String,v1:Float,v2:Float,v3:Float,v4:Float )
	
		Local cString:Byte Ptr=name.ToCString()
		SetFloat4_( GetInstance(Self),cString,v1,v2,v3,v4 )
		MemFree cString
		
	End Method
	
	Method UseFloat( name:String,v1:Float Var )
	
		Local cString:Byte Ptr=name.ToCString()
		UseFloat_( GetInstance(Self),cString,Varptr(v1) )
		MemFree cString
		
	End Method
	
	Method UseFloat2( name:String,v1:Float Var,v2:Float Var )
	
		Local cString:Byte Ptr=name.ToCString()
		UseFloat2_( GetInstance(Self),cString,Varptr(v1),Varptr(v2) )
		MemFree cString
		
	End Method
	
	Method UseFloat3( name:String,v1:Float Var,v2:Float Var,v3:Float Var )
	
		Local cString:Byte Ptr=name.ToCString()
		UseFloat3_( GetInstance(Self),cString,Varptr(v1),Varptr(v2),Varptr(v3) )
		MemFree cString
		
	End Method
	
	Method UseFloat4( name:String,v1:Float Var,v2:Float Var,v3:Float Var,v4:Float Var )
	
		Local cString:Byte Ptr=name.ToCString()
		UseFloat4_( GetInstance(Self),cString,Varptr(v1),Varptr(v2),Varptr(v3),Varptr(v4) )
		MemFree cString
		
	End Method
	
	Method SetInteger( name:String,v1:Int )
	
		Local cString:Byte Ptr=name.ToCString()
		SetInteger_( GetInstance(Self),cString,v1 )
		MemFree cString
		
	End Method
	
	Method SetInteger2( name:String,v1:Int,v2:Int )
	
		Local cString:Byte Ptr=name.ToCString()
		SetInteger2_( GetInstance(Self),cString,v1,v2 )
		MemFree cString
		
	End Method
	
	Method SetInteger3( name:String,v1:Int,v2:Int,v3:Int )
	
		Local cString:Byte Ptr=name.ToCString()
		SetInteger3_( GetInstance(Self),cString,v1,v2,v3 )
		MemFree cString
		
	End Method
	
	Method SetInteger4( name:String,v1:Int,v2:Int,v3:Int,v4:Int )
	
		Local cString:Byte Ptr=name.ToCString()
		SetInteger4_( GetInstance(Self),cString,v1,v2,v3,v4 )
		MemFree cString
		
	End Method
	
	Method UseInteger( name:String,v1:Int Var )
	
		Local cString:Byte Ptr=name.ToCString()
		UseInteger_( GetInstance(Self),cString,Varptr(v1) )
		MemFree cString
		
	End Method
	
	Method UseInteger2( name:String,v1:Int Var,v2:Int Var )
	
		Local cString:Byte Ptr=name.ToCString()
		UseInteger2_( GetInstance(Self),cString,Varptr(v1),Varptr(v2) )
		MemFree cString
		
	End Method
	
	Method UseInteger3( name:String,v1:Int Var,v2:Int Var,v3:Int Var )
	
		Local cString:Byte Ptr=name.ToCString()
		UseInteger3_( GetInstance(Self),cString,Varptr(v1),Varptr(v2),Varptr(v3) )
		MemFree cString
		
	End Method
	
	Method UseInteger4( name:String,v1:Int Var,v2:Int Var,v3:Int Var,v4:Int Var )
	
		Local cString:Byte Ptr=name.ToCString()
		UseInteger4_( GetInstance(Self),cString,Varptr(v1),Varptr(v2),Varptr(v3),Varptr(v4) )
		MemFree cString
		
	End Method
	
	Method UseSurface( name:String,surf:TSurface,vbo:Int )
	
		Local cString:Byte Ptr=name.ToCString()
		UseSurface_( GetInstance(Self),cString,TSurface.GetInstance(surf),vbo )
		MemFree cString
		
	End Method
	
	Method UseMatrix( name:String,Mode:Int )
	
		Local cString:Byte Ptr=name.ToCString()
		UseMatrix_( GetInstance(Self),cString,Mode )
		MemFree cString
		
	End Method
	
	Method ShaderMaterial( tex:TMaterial,name:String,index:Int=0 )
	
		Local cString:Byte Ptr=name.ToCString()
		ShaderMaterial_( GetInstance(Self),TMaterial.GetInstance(tex),cString,index )
		MemFree cString
		
	End Method
	
End Type

Rem
bbdoc: Shadow-object
End Rem
Type TShadowObject

	Global shad_map:TMap=New TMap
	Field instance:Byte Ptr
	
	' Create and map object from C++ instance
	Function NewObject:TShadowObject( inst:Byte Ptr )
	
		Local obj:TShadowObject=New TShadowObject
		shad_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	' Delete object from C++ instance
	Function DeleteObject( inst:Byte Ptr )
	
		shad_map.Remove( String(Long(inst)) )
		
	End Function
	
	' Get C++ instance from object (used for passing object to C++ function)
	Function GetInstance:Byte Ptr( obj:TShadowObject )
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Function CreateShadow:TShadowObject( parent:TMesh,Static:Int=False )
	
		Local instance:Byte Ptr=CreateShadow_( TMesh.GetInstance(parent),Static )
		Return NewObject(instance)
		
	End Function
	
	Method FreeShadow()
	
		DeleteObject( GetInstance(Self) )
		FreeShadow_( GetInstance(Self) )
		
	End Method
	
End Type

Rem
bbdoc: Stencil
End Rem
Type TStencil

	Field instance:Byte Ptr
	
	' Create and map object from C++ instance
	Function NewObject:TStencil( inst:Byte Ptr )
	
		Local obj:TStencil=New TStencil
		obj.instance=inst
		Return obj
		
	End Function
	
	' Get C++ instance from object (used for passing object to C++ function)
	Function GetInstance:Byte Ptr( obj:TStencil )
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Function CreateStencil:TStencil()
	
		Local instance:Byte Ptr=CreateStencil_()
		Return NewObject(instance)
		
	End Function
	
	Method StencilAlpha( a:Float )
	
		StencilAlpha_( GetInstance(Self),a )
		
	End Method
	
	Method StencilClsColor( r:Float,g:Float,b:Float )
	
		StencilClsColor_( GetInstance(Self),r,g,b )
		
	End Method
	
	Method StencilClsMode( cls_depth:Int,cls_zbuffer:Int )
	
		StencilClsMode_( GetInstance(Self),cls_depth,cls_zbuffer )
		
	End Method
	
	Method StencilMesh( mesh:TMesh,Mode:Int=1 )
	
		StencilMesh_( GetInstance(Self),TMesh.GetInstance(mesh),Mode )
		
	End Method
	
	Method StencilMode( m:Int,o:Int=1 )
	
		StencilMode_( GetInstance(Self),m,o )
		
	End Method
	
	Method UseStencil()
	
		UseStencil_( GetInstance(Self) )
		
	End Method
	
End Type

Rem
bbdoc: Terrain entity
End Rem
Type TTerrain Extends TEntity
	
	' Create and map object from C++ instance
	Function NewObject:TTerrain( inst:Byte Ptr )
	
		Local obj:TTerrain=New TTerrain
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	Method CopyEntity:TTerrain( parent:TEntity=Null )
	
		
		
	End Method
	
	Method Update()
	
		
		
	End Method
	
	Function CreateTerrain:TTerrain( size:Int,parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateTerrain_( size,GetInstance(parent) )
		Return NewObject(instance)
		
	End Function
	
	Function LoadTerrain:TTerrain( file:String,parent:TEntity=Null )
	
		Local cString:Byte Ptr=file.ToCString()
		Local instance:Byte Ptr=LoadTerrain_( cString,GetInstance(parent) )
		Local terr:TTerrain=NewObject(instance)
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
	
End Type

Rem
bbdoc: Voxelsprite mesh entity
End Rem
Type TVoxelSprite Extends TMesh
	
	' Create and map object from C++ instance
	Function NewObject:TVoxelSprite( inst:Byte Ptr )
	
		Local obj:TVoxelSprite=New TVoxelSprite
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	Function CreateVoxelSprite:TVoxelSprite( slices:Int=64,parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateVoxelSprite_( slices,GetInstance(parent) )
		Return NewObject(instance)
		
	End Function
	
	Method VoxelSpriteMaterial( mat:TMaterial )
	
		VoxelSpriteMaterial_( GetInstance(Self),TMaterial.GetInstance(mat) )
		
	End Method
	
End Type
