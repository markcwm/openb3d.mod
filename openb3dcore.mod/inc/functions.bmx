' functions.bmx

' *** Extra

Rem
bbdoc: Use manual collision mode between entities, diables automatic collisions
End Rem
Function ManualCollision( ent:TEntity,ent2:TEntity,col_method:Int,col_response:Int ) ' KippyKip
	ManualCollision_( TEntity.GetInstance(ent),TEntity.GetInstance(ent2),col_method,col_response )
End Function

Rem
bbdoc: Check for framebuffer errors
End Rem
Function CheckFramebufferStatus( target% )
	TGlobal3D.CheckFramebufferStatus( target )
End Function

Rem
bbdoc: Returns terrain triangles count
End Rem
Function TerrainCountTriangles( terr:TTerrain )
	terr.TerrainCountTriangles()
End Function

Rem
bbdoc: Returns terrain vertices count
End Rem
Function TerrainCountVertices( terr:TTerrain )
	terr.TerrainCountVertices()
End Function

Rem
bbdoc: Set terrain texture coordinates scale, range is 1 to terrain size
End Rem
Function TerrainScaleTexCoords( terr:TTerrain,u_scale:Float,v_scale:Float,coords_set:Int=0 )
	terr.TerrainScaleTexCoords( u_scale,v_scale,coords_set )
End Function

Rem
bbdoc: Set terrain level of detail, default is 100 and maximum is 2000
End Rem
Function TerrainDetail( terr:TTerrain,detail_level:Float )
	terr.TerrainDetail( detail_level )
End Function

Rem
bbdoc: Enables or disables hardware multisample antialiasing if supported
End Rem
Function MSAntiAlias( multisample:Int=0 )
	TGlobal3D.MSAntiAlias( multisample )
End Function

Rem
bbdoc: Sets global width and height of screen resolution
about: Only needed when changing screen resolution, these globals are used in 
CreateCamera, CameraViewport, CameraPick, BackBufferToTex and DepthBufferToTex.
End Rem
Function GlobalResolution( width:Int,height:Int )
	TGlobal3D.width[0]=width
	TGlobal3D.height[0]=height
End Function

Rem
bbdoc: Returns global width of screen resolution
End Rem
Function GlobalWidth:Int()
	Return TGlobal3D.width[0]
End Function

Rem
bbdoc: Returns global height of screen resolution
End Rem
Function GlobalHeight:Int()
	Return TGlobal3D.height[0]
End Function

Rem
bbdoc: Returns string cast of byte pointer
End Rem
Function StringPtr:String( inst:Byte Ptr ) 
	?bmxng
	Return String(inst)
	?Not bmxng
	Return String(Int(inst))
	?
End Function

Rem
bbdoc: Returns the number of mipmaps a texture has
End Rem
Function CountMipmaps:Int( tex:TTexture )
	Return tex.CountMipmaps()
End Function

Rem
bbdoc: Set discard value (as 0..1) above which to ignore pixel's alpha value, default is 1 (only if flag 2)
End Rem
Function AlphaDiscard( tex:TTexture,alpha:Float=0.01 )
	Return tex.AlphaDiscard( alpha )
End Function

Rem
bbdoc: Loads an md2 entity and returns its handle
End Rem
Function LoadMD2:TMesh( url:Object,parent:TEntity=Null )
	Return TMD2.LoadMD2( String(url),parent )
End Function

Rem
bbdoc: Loads an anim mesh, see MeshLoader
returns: A mesh object with child meshes if any
End Rem
Function LoadAnimMesh:TMesh( url:Object,parent:TEntity=Null,flags:Int = -1 )
	Local stream:TStream=LittleEndianStream(ReadFile(url))
	If Not stream
		DebugLog " Invalid "+ExtractExt(String(url))+" stream: "+String(url)
		Return Null
	EndIf
	
	Local pos=stream.Pos()
	If pos=-1
		stream.Close
		Return
	EndIf
	
	Local mesh:TMesh
	Local loader:TMeshLoader=mesh_loaders
	While loader
		stream.Seek pos
		Try
			mesh=loader.LoadAnimMesh( stream,url,parent,flags )
		Catch ex:TStreamException
		End Try
		If mesh Then Exit
		loader=loader._succ
	Wend
	stream.Close
	Return mesh
End Function

Rem
bbdoc: Loads a single mesh, see MeshLoader
returns: A mesh object
End Rem
Function LoadMesh:TMesh( url:Object,parent:TEntity=Null,flags:Int = -1 )
	Local stream:TStream=LittleEndianStream(ReadFile(url))
	If Not stream
		DebugLog " Invalid "+ExtractExt(String(url))+" stream: "+String(url)
		Return Null
	EndIf
	
	Local pos=stream.Pos()
	If pos=-1
		stream.Close
		Return
	EndIf
	
	Local mesh:TMesh
	Local loader:TMeshLoader=mesh_loaders
	
	While loader
		stream.Seek pos
		Try
			mesh=loader.LoadMesh( stream,url,parent,flags )
		Catch ex:TStreamException
		End Try
		If mesh Then Exit
		loader=loader._succ
	Wend
	stream.Close
	Return mesh
End Function

' warning: Mesh/TextureLoader have now replaced with UseLibraryMeshes and other functions starting 
' with "Use", this is because these functions were not easy to understand.

'Rem
'bbdoc: Set mesh loaders to use, default is "bmx"
'about: Set meshid to "bmx" or "max" for Blitzmax streamed mesh loaders, use "cpp" or "lib" 
'for standard Openb3d library mesh loaders, use "all" for all available loaders. Use "3ds2" 
'for alternative 3DS loader or "3ds" for default 3DS loader. Use "trans" to transform mesh 
'vertices (if supported) or disable with "notrans" (only for 3DS files). Use "debug" for mesh 
'loader debug information or disable with "nodebug".
'EndRem
'Function MeshLoader( meshid:String,flags:Int=-1 )
'End Function

'Rem
'bbdoc: Set texture loaders to use (default is streamed), also sets cubemap faces or frames
'about: Set texid to "bb" or "bmx" for Blitzmax streamed textures, use "cpp", "lib" or "open" 
'for Openb3d library textures (only loads local files). As an extra feature you can define the 
'cubemap face order with "faces",0,1,2,3,4,5 and cubemap anim texture frame order with 
'"frames",0,1,2,3,4,5 (these are the default layouts).
'EndRem
'Function TextureLoader( texid:String,lf0:Int=0,fr1:Int=0,rt2:Int=0,bk3:Int=0,dn4:Int=0,up5:Int=0 )
'End Function

Rem
bbdoc: Loader flag for meshes
about: Set flag to False for Blitzmax streamed loaders, default is True for Openb3d library direct loaders.
End Rem
Function UseLibraryMeshes( flag:Int=True )
	TUse.LibraryMeshes( flag )
End Function

Rem
bbdoc: Loader flags for Assimp meshes
about: Set flag to False to use Assimp direct loaders, default is True for Assimp streamed loaders.
Set meshflags to -1 for smooth normals, -2 for flat shaded normals and -4 to load as single mesh.
End Rem
Function UseAssimpStreamMeshes( flag:Int=True,meshflags:Int=-1 )
	TUse.AssimpStreamMeshes( flag,meshflags )
End Function

Rem
bbdoc: Debug all mesh loaders
about: Set flag to False to not debug Blitzmax mesh loaders, default is True to enable debug log.
End Rem
Function UseMeshDebugLog( flag:Int=True )
	TUse.MeshDebugLog( flag )
End Function

Rem
bbdoc: Transform mesh loaders
about: Set flag to False to not transform meshes, default is True to enable transforms (Blitzmax 3DS only).
End Rem
Function UseMeshTransform( flag:Int=True )
	TUse.MeshTransform( flag )
End Function

Rem
bbdoc: Set 3DS model loader coordinates system (matrix), values should be 0,1,-1
End Rem
Function UseMatrix3DS( xx#,xy#,xz#,yx#,yy#,yz#,zx#,zy#,zz# )
	TUse.Matrix3DS( xx,xy,xz,yx,yy,yz,zx,zy,zz )
End Function

Rem
bbdoc: Set MD2 model loader coordinates system (matrix), values should be 0,1,-1
End Rem
Function UseMatrixMD2( xx#,xy#,xz#,yx#,yy#,yz#,zx#,zy#,zz# )
	TUse.MatrixMD2( xx,xy,xz,yx,yy,yz,zx,zy,zz )
End Function

Rem
bbdoc: Loader flag for textures
about: Set flag to False for Blitzmax streamed loaders, default is True for Openb3d library direct loaders.
End Rem
Function UseLibraryTextures( flag:Int=True )
	TUse.LibraryTextures( flag )
End Function

Rem
bbdoc: Order for anim texture frames
about: Define the order to load anim texture frames, default is 0,1,2,3,4,5.
End Rem
Function UseTextureFrames( lf0:Int=0,fr1:Int=0,rt2:Int=0,bk3:Int=0,dn4:Int=0,up5:Int=0 )
	TUse.TextureFrames( lf0,fr1,rt2,bk3,dn4,up5 )
End Function

Rem
bbdoc: Order for cubemap faces
about: Define the order to load cubemap faces, default is 0,1,2,3,4,5 (B3D layout).
End Rem
Function UseTextureFaces( lf0:Int=0,fr1:Int=0,rt2:Int=0,bk3:Int=0,dn4:Int=0,up5:Int=0 )
	TUse.TextureFaces( lf0,fr1,rt2,bk3,dn4,up5 )
End Function

Rem
bbdoc: Flip cubemap texture flag
about: Set flag to True to flip cubemap textures, default is False to not flip (invert).
End Rem
Function UseCubemapFlip( flag:Int=False )
	TUse.CubemapFlip( flag )
End Function

Rem
bbdoc: Set mesh texture flags
about: Override mesh texture flags manually, default is -1 (only for 3DS and OBJ).
End Rem
Function UseMeshTextureFlags( texflags:Int=-1 )
	TUse.MeshTextureFlags( texflags )
End Function

Rem
bbdoc: Frees all brush textures, FreeBrush does not free textures
End Rem
Function FreeBrushTextures( brush:TBrush )
	brush.FreeBrushTextures()
End Function

Rem
bbdoc: Moves all vertices of mesh and every child mesh
End Rem
Function PositionAnimMesh( mesh:TMesh,px#,py#,pz# )
	mesh.PositionAnimMesh( px#,py#,pz# )
End Function

Rem
bbdoc: Rotates all vertices of mesh and every child mesh
End Rem
Function RotateAnimMesh( mesh:TMesh,rx#,ry#,rz# )
	mesh.RotateAnimMesh( rx#,ry#,rz# )
End Function

Rem
bbdoc: Scales all vertices of mesh and every child mesh
End Rem
Function ScaleAnimMesh( mesh:TMesh,sx#,sy#,sz# )
	mesh.ScaleAnimMesh( sx#,sy#,sz# )
End Function

Rem
bbdoc: Copy rectangle of source pixmap pixels to destination, not exactly like B3D
about: srcW/H is src size, srcX/srcY top-left position, dstW/H is dst size, bytes per pixel defaults to 4.
End Rem
Function CopyRect( srcX:Int,srcY:Int,srcW:Int,srcH:Int,dstW:Int,dstH:Int,src:Byte Ptr,dst:Byte Ptr,bPP:Int=4,invert:Int=0 )
	CopyRect_( src,srcW,srcH,srcX,srcY,dst,dstW,dstH,bPP,invert )
End Function

Rem
bbdoc: Gets a Blitz string from a C string
End Rem
Function GetString:String( obj:Object,strPtr:Byte Ptr )
	Local bru:TBrush=TBrush(obj)
	Local ent:TEntity=TEntity(obj)
	Local tex:TTexture=TTexture(obj)
	If bru
		Select strPtr
			Case bru.name
				Return String.FromCString( BrushString_( TBrush.GetInstance(bru),BRUSH_name ) )
		End Select
	ElseIf ent
		Select strPtr
			Case ent.name
				Return String.FromCString( EntityString_( TEntity.GetInstance(ent),ENTITY_name ) )
			Case ent.class_name
				Return String.FromCString( EntityString_( TEntity.GetInstance(ent),ENTITY_class_name ) )
		End Select
	ElseIf tex
		Select strPtr
			Case tex.file
				Return String.FromCString( TextureString_( TTexture.GetInstance(tex),TEXTURE_file ) )
			Case tex.file_abs
				Return String.FromCString( TextureString_( TTexture.GetInstance(tex),TEXTURE_file_abs ) )
		End Select
	EndIf
End Function

Rem
bbdoc: Sets a C string from a Blitz string
End Rem
Function SetString:String( obj:Object,strPtr:Byte Ptr,strValue:String )
	Local bru:TBrush=TBrush(obj)
	Local ent:TEntity=TEntity(obj)
	Local tex:TTexture=TTexture(obj)
	If bru
		Select strPtr
			Case bru.name
				bru.SetString(bru.name,strValue)
		End Select
	ElseIf ent
		Select strPtr
			Case ent.name
				ent.SetString(ent.name,strValue)
			Case ent.class_name
				ent.SetString(ent.class_name,strValue)
		End Select
	ElseIf tex
		Select strPtr
			Case tex.file
				tex.SetString(tex.file,strValue)
			Case tex.file_abs
				tex.SetString(tex.file_abs,strValue)
		End Select
	EndIf
End Function

Rem
bbdoc: Set global texture anisotropic (default for all), TextureAnIsotropic overrides it
EndRem
Function GlobalAnIsotropic( f:Float )
	TTexture.global_aniso[0]=f
End Function

Rem
bbdoc: Set texture anisotropic factor, usually from 2-16
End Rem
Function TextureAnIsotropic( tex:TTexture,f:Float )
	TextureAnIsotropic_( TTexture.GetInstance(tex),f )
End Function

Rem
bbdoc: Set texture multitex factor, used in interpolate and custom TexBlend options
End Rem
Function TextureMultitex( tex:TTexture,f:Float )
	TextureMultitex_( TTexture.GetInstance(tex),f )
End Function

Rem
bbdoc: Number of triangles currently being rendered
End Rem
Function TrisRendered:Int()
	Return TrisRendered_()
End Function

Rem
bbdoc: Number of vertices currently being rendered
End Rem
Function VertsRendered:Int()
	Return VertsRendered_()
End Function

Rem
bbdoc: Number of surfaces currently being rendered
End Rem
Function SurfsRendered:Int()
	Return SurfsRendered_()
End Function

Rem
bbdoc: Create a new TSprite object
about: spr=NewSprite()
End Rem
Function NewSprite:TSprite()
	Return TSprite.Create()
End Function

Rem
bbdoc: Create a new TTexture object
about: tex=NewTexture()
End Rem
Function NewTexture:TTexture()
	Return TTexture.Create()
End Function

Rem
bbdoc: Create a new TMesh object
about: mesh=NewMesh()
End Rem
Function NewMesh:TMesh()
	Return TMesh.Create()
End Function

Rem
bbdoc: Create a new TSurface object
about: surf=NewSurface()
End Rem
Function NewSurface:TSurface()
	Return TSurface.Create()
End Function

Rem
bbdoc: Create a new TBone object
about: bone=NewBone()
End Rem
Function NewBone:TBone()
	Return TBone.Create()
End Function

Rem
bbdoc: Create a new TAnimationKeys object
about: keys=NewAnimationKeys()
End Rem
Function NewAnimationKeys:TAnimationKeys( bone:TBone=Null )
	Return TAnimationKeys.Create( bone )
End Function

Rem
bbdoc: Create a new TMatPtr object, returns a Float Ptr matrix
about: mat=NewMatPtr()
End Rem
Function NewMatPtr:TMatPtr()
	Return TMatPtr.Create()
End Function

Rem
bbdoc: Create a new TQuatPtr object, returns a Float Ptr quaternion
about: quat=NewQuatPtr()
End Rem
Function NewQuatPtr:TQuatPtr()
	Return TQuatPtr.Create()
End Function

Rem
bbdoc: Create a new TVecPtr object, returns a Float Ptr vector
about: vec=NewVecPtr()
End Rem
Function NewVecPtr:TVecPtr()
	Return TVecPtr.Create()
End Function

Rem
bbdoc: GL equivalent, experimental
End Rem
Function BrushGLColor( brush:TBrush,r:Float,g:Float,b:Float,a:Float=1.0 )
	BrushGLColor_( TBrush.GetInstance(brush),r,g,b,a )
End Function

Rem
bbdoc: GL equivalent, experimental
End Rem
Function BrushGLBlendFunc( brush:TBrush,sfactor:Int,dfactor:Int )
	BrushGLBlendFunc_( TBrush.GetInstance(brush),sfactor,dfactor )
End Function

Rem
bbdoc: GL equivalent, param is a const, limited to 12 calls per texture, experimental
End Rem
Function TextureGLTexEnvi( tex:TTexture,target:Int,pname:Int,param:Int )
	TextureGLTexEnvi_( TTexture.GetInstance(tex),target,pname,param )
End Function

Rem
bbdoc: GL equivalent, param is a float, limited to 12 calls per texture, experimental
End Rem
Function TextureGLTexEnvf( tex:TTexture,target:Int,pname:Int,param:Float )
	TextureGLTexEnvf_( TTexture.GetInstance(tex),target,pname,param )
End Function

Rem
bbdoc: Returns a copy of the new brush
End Rem
Function CopyBrush:TBrush( brush:TBrush )
	Return brush.Copy()
End Function

Rem
bbdoc: Returns a copy of the new surface
End Rem
Function CopySurface:TSurface( surf:TSurface )
	Return surf.Copy()
End Function

Rem
bbdoc: Returns a copy of the new texture
End Rem
Function CopyTexture:TTexture( tex:TTexture,flags:Int )
	Return tex.Copy( flags )
End Function

Rem
bbdoc: Returns a new shader material without creating any shader objects
End Rem
Function CreateShaderMaterial:TShader( ShaderName:String )
	Return TShader.CreateShaderMaterial( ShaderName )
End Function

Rem
bbdoc: Returns a new frag shader object from file
End Rem
Function CreateFragShader:TShaderObject( shader:TShader,shaderFileName:String )
	Return TShaderObject.CreateFragShader( shader,shaderFileName )
End Function

Rem
bbdoc: Returns a new frag shader object from string
End Rem
Function CreateFragShaderString:TShaderObject( shader:TShader,shadercode:String )
	Return TShaderObject.CreateFragShaderString( shader,shadercode )
End Function

Rem
bbdoc: Returns a new vert shader object from file
End Rem
Function CreateVertShader:TShaderObject( shader:TShader,shaderFileName:String )
	Return TShaderObject.CreateVertShader( shader,shaderFileName )
End Function

Rem
bbdoc: Returns a new vert shader object from string
End Rem
Function CreateVertShaderString:TShaderObject( shader:TShader,shadercode:String )
	Return TShaderObject.CreateVertShaderString( shader,shadercode )
End Function

Rem
bbdoc: Link shader to a program object, as created by CreateShaderMaterial
End Rem
Function LinkShader:Int( shader:TShader )
	Return shader.LinkShader()
End Function

Rem
bbdoc: Attaches a fragment shader object to a program object, attach vertex first or older compilers will crash
End Rem
Function AttachFragShader:Int( shader:TShader,myShader:TShaderObject )
	Return myShader.AttachFragShader( shader )
End Function

Rem
bbdoc: Attaches a vertex shader object to a program object
End Rem
Function AttachVertShader:Int( shader:TShader,myShader:TShaderObject )
	Return myShader.AttachVertShader( shader )
End Function

Rem
bbdoc: Deletes a frag shader object from a program object
End Rem
Function DeleteFragShader( myShader:TShaderObject )
	myShader.DeleteFragShader()
End Function

Rem
bbdoc: Deletes a vert shader object from a program object
End Rem
Function DeleteVertShader( myShader:TShaderObject )
	myShader.DeleteVertShader()
End Function

Rem
bbdoc: Frees a shader material
End Rem
Function FreeShader( shader:TShader ) ' Spinduluz
	shader.FreeShader()
End Function

Rem
bbdoc: Frees a stencil object
End Rem
Function FreeStencil( stencil:TStencil ) ' Spinduluz
	stencil.FreeStencil()
End Function

Rem
bbdoc: Frees VBO data and brush
End Rem
Function FreeSurface( surf:TSurface )
	Return surf.FreeSurface()
End Function

Rem
bbdoc: Set texture flags, see LoadTexture for values
End Rem
Function TextureFlags( tex:TTexture,flags:Int )
	tex.TextureFlags(flags)
End Function

Rem
bbdoc: Performs a 'fake' lighting operation on a mesh.
about: You need to use EntityFX ent,2 to enable vertex colors on the target mesh before you can see any results.
End Rem
Function LightMesh( mesh:TMesh,red:Float,green:Float,blue:Float,range:Float=0,light_x:Float=0,light_y:Float=0,light_z:Float=0 )
	mesh.LightMesh( red,green,blue,range,light_x,light_y,light_z )
End Function

' *** Minib3d only

Rem
bbdoc: Copy the contents of the backbuffer to a texture
about: OpenB3D does not have the same buffer commands as Blitz3D.
The region copied from the backbuffer will start at 0,0 and end at the texture's width and height.
So if you want to copy a 3D scene to a texture, first resize the camera viewport to the texture size, 
use RenderWorld to render the camera, then use this command. 
Back buffer is upside-down so set fastinvert to True to invert texture uvs, False to flip texture data (slower).
End Rem
Function BackBufferToTex( tex:TTexture,mipmap_no:Int=0,frame:Int=0,fastinvert:Int=True )
	tex.BackBufferToTex( mipmap_no,frame,fastinvert ) ' frame currently does nothing
End Function

Rem
bbdoc: Equivalent of Blitz3D's MeshCullBox command. It sets the radius of a mesh's 'cull sphere'
about: If the 'cull sphere' is not inside the viewing area, the mesh will not be rendered.
A mesh's cull radius is set automatically, therefore in most cases you will not have to use this command. 
One time you may have to use it is for animated meshes where the default cull radius may not take into 
account all animation positions, resulting in the mesh being wrongly culled at extreme positions.
End Rem
Function MeshCullRadius( ent:TEntity,radius:Float )
	MeshCullRadius_( TEntity.GetInstance(ent),radius )
End Function

Rem
bbdoc: Returns the scale for the x axis of an entity set with ScaleEntity
about: If glob is true then it's relative to any parents.
End Rem
Function EntityScaleX:Float( ent:TEntity,glob:Int=False )
	Return ent.EntityScaleX( glob )
End Function

Rem
bbdoc: Returns the scale for the y axis of an entity set with ScaleEntity
about: If glob is true then it's relative to any parents.
End Rem
Function EntityScaleY:Float( ent:TEntity,glob:Int=False )
	Return ent.EntityScaleY( glob )
End Function

Rem
bbdoc: Returns the scale for the z axis of an entity set with ScaleEntity
about: If glob is true then it's relative to any parents.
End Rem
Function EntityScaleZ:Float( ent:TEntity,glob:Int=False )
	Return ent.EntityScaleZ( glob )
End Function

' *** Openb3d only

Rem
bbdoc: Copy pixmap buffer to texture, buffer must be a byte ptr
End Rem
Function BufferToTex( tex:TTexture,buffer:Byte Ptr,frame:Int=0 ) ' frame currently does nothing
	tex.BufferToTex( buffer,frame )
End Function

Rem
bbdoc: Copy rendered camera view to texture
End Rem
Function CameraToTex( tex:TTexture,cam:TCamera,frame:Int=0 ) ' frame currently does nothing
	tex.CameraToTex( cam,frame )
End Function

Rem
bbdoc: Create bone
End Rem
Function CreateBone:TBone( mesh:TMesh,parent_ent:TEntity=Null )
	Return TBone.CreateBone( mesh,parent_ent )
End Function

Rem
bbdoc: Create flat quad
End Rem
Function CreateQuad:TMesh( parent:TEntity=Null )
	Return TMesh.CreateQuad( parent )
End Function

Rem
bbdoc: Copy the contents of the depth buffer to a texture
End Rem
Function DepthBufferToTex( tex:TTexture,cam:TCamera=Null )
	tex.DepthBufferToTex( cam )
End Function

Rem
bbdoc: Method 0 subtracts mesh2 from mesh1, 1 adds meshes, 2 intersects meshes. Returns a new mesh
End Rem
Function MeshCSG:TMesh( m1:TMesh,m2:TMesh,method_no:Int=1 )
	Return TMesh.MeshCSG( m1,m2,method_no )
End Function

Rem
bbdoc: Like CopyMesh but for instancing effects
End Rem
Function RepeatMesh:TMesh( mesh:TMesh,parent:TEntity=Null )
	Return mesh.RepeatMesh( parent )
End Function

Rem
bbdoc: Set animated surface for each of the bone no and weights arrays
about: bone no references the bones list in a mesh, weights is a normalizing value.
End Rem
Function SkinMesh( mesh:TMesh,surf_no_get:Int,vid:Int,bone1:Int,weight1:Float=1.0,bone2:Int=0,weight2:Float=0,bone3:Int=0,weight3:Float=0,bone4:Int=0,weight4:Float=0 )
	mesh.SkinMesh( surf_no_get,vid,bone1,weight1,bone2,weight2,bone3,weight3,bone4,weight4 )
End Function

Rem
bbdoc: If mode is 1 rendering is normal, 2 is for batch sprites like particles
about: Batch particle render mode (3) is not working.
End Rem
Function SpriteRenderMode( sprite:TSprite,Mode:Int )
	sprite.SpriteRenderMode( Mode )
End Function

Rem
bbdoc: Copy texture to a pixmap buffer, buffer must be a byte ptr
End Rem
Function TexToBuffer( tex:TTexture,buffer:Byte Ptr,frame:Int=0 )
	tex.TexToBuffer( buffer,frame )
End Function

Rem
bbdoc: Recalculates the surface's uvw coord set 1 based on vertices
End Rem
Function UpdateTexCoords( surf:TSurface )
	surf.UpdateTexCoords()
End Function

Rem
bbdoc: undocumented
End Rem
Function CameraProjMatrix:Float Ptr( cam:TCamera )
	Return CameraProjMatrix_( TCamera.GetInstance(cam) )
End Function

Rem
bbdoc: undocumented
End Rem
Function EntityMatrix:Float Ptr( ent:TEntity )
	Return EntityMatrix_( TEntity.GetInstance(ent) )
End Function

' *** Action

Rem
bbdoc: Moves entity by an x y z position increment at the speed of rate
End Rem
Function ActMoveBy:TAction( ent:TEntity,a:Float,b:Float,c:Float,rate:Float )
	Local inst:Byte Ptr=ActMoveBy_( TEntity.GetInstance(ent),a,b,c,rate )
	Local act:TAction=TAction.GetObject(inst)
	If act=Null And inst<>Null Then act=TAction.CreateObject(inst)
	Return act
End Function

Rem
bbdoc: Turns entity by an x y z rotation increment at the speed of rate
End Rem
Function ActTurnBy:TAction( ent:TEntity,a:Float,b:Float,c:Float,rate:Float )
	Local inst:Byte Ptr=ActTurnBy_( TEntity.GetInstance(ent),a,b,c,rate )
	Local act:TAction=TAction.GetObject(inst)
	If act=Null And inst<>Null Then act=TAction.CreateObject(inst)
	Return act
End Function

Rem
bbdoc: Positions entity according the given x y z vector
End Rem
Function ActVector:TAction( ent:TEntity,a:Float,b:Float,c:Float )
	Local inst:Byte Ptr=ActVector_( TEntity.GetInstance(ent),a,b,c )
	Local act:TAction=TAction.GetObject(inst)
	If act=Null And inst<>Null Then act=TAction.CreateObject(inst)
	Return act
End Function

Rem
bbdoc: Moves entity to the given x y z position at the speed of rate
End Rem
Function ActMoveTo:TAction( ent:TEntity,a:Float,b:Float,c:Float,rate:Float )
	Local inst:Byte Ptr=ActMoveTo_( TEntity.GetInstance(ent),a,b,c,rate )
	Local act:TAction=TAction.GetObject(inst)
	If act=Null And inst<>Null Then act=TAction.CreateObject(inst)
	Return act
End Function

Rem
bbdoc: Turns entity to the given x y z rotation at the speed of rate
End Rem
Function ActTurnTo:TAction( ent:TEntity,a:Float,b:Float,c:Float,rate:Float )
	Local inst:Byte Ptr=ActTurnTo_( TEntity.GetInstance(ent),a,b,c,rate )
	Local act:TAction=TAction.GetObject(inst)
	If act=Null And inst<>Null Then act=TAction.CreateObject(inst)
	Return act
End Function

Rem
bbdoc: Scales entity to the given x y z dimensions at the speed of rate
End Rem
Function ActScaleTo:TAction( ent:TEntity,a:Float,b:Float,c:Float,rate:Float )
	Local inst:Byte Ptr=ActScaleTo_( TEntity.GetInstance(ent),a,b,c,rate )
	Local act:TAction=TAction.GetObject(inst)
	If act=Null And inst<>Null Then act=TAction.CreateObject(inst)
	Return act
End Function

Rem
bbdoc: Fades entity to the given alpha value (0..1) at the speed of rate
End Rem
Function ActFadeTo:TAction( ent:TEntity,a:Float,rate:Float )
	Local inst:Byte Ptr=ActFadeTo_( TEntity.GetInstance(ent),a,rate )
	Local act:TAction=TAction.GetObject(inst)
	If act=Null And inst<>Null Then act=TAction.CreateObject(inst)
	Return act
End Function

Rem
bbdoc: Tints entity to the given r g b value (0..255) at the speed of rate
End Rem
Function ActTintTo:TAction( ent:TEntity,a:Float,b:Float,c:Float,rate:Float )
	Local inst:Byte Ptr=ActTintTo_( TEntity.GetInstance(ent),a,b,c,rate )
	Local act:TAction=TAction.GetObject(inst)
	If act=Null And inst<>Null Then act=TAction.CreateObject(inst)
	Return act
End Function

Rem
bbdoc: Tracks target entity at a given point from the entity at the speed of rate
End Rem
Function ActTrackByPoint:TAction( ent:TEntity,target:TEntity,a:Float,b:Float,c:Float,rate:Float )
	Local inst:Byte Ptr=ActTrackByPoint_( TEntity.GetInstance(ent),TEntity.GetInstance(target),a,b,c,rate )
	Local act:TAction=TAction.GetObject(inst)
	If act=Null And inst<>Null Then act=TAction.CreateObject(inst)
	Return act
End Function

Rem
bbdoc: Tracks target entity up to a given distance at the speed of rate
End Rem
Function ActTrackByDistance:TAction( ent:TEntity,target:TEntity,a:Float,rate:Float )
	Local inst:Byte Ptr=ActTrackByDistance_( TEntity.GetInstance(ent),TEntity.GetInstance(target),a,rate )
	Local act:TAction=TAction.GetObject(inst)
	If act=Null And inst<>Null Then act=TAction.CreateObject(inst)
	Return act
End Function

Rem
bbdoc: Translates entity in the direction it is moving, rate should be below 1
End Rem
Function ActNewtonian:TAction( ent:TEntity,rate:Float )
	Local inst:Byte Ptr=ActNewtonian_( TEntity.GetInstance(ent),rate )
	Local act:TAction=TAction.GetObject(inst)
	If act=Null And inst<>Null Then act=TAction.CreateObject(inst)
	Return act
End Function

Rem
bbdoc: Adds action to the end of another one, where act1 happens before act2
End Rem
Function AppendAction( act1:TAction,act2:TAction )
	act1.AppendAction( act2 )
End Function

Rem
bbdoc: Frees action from memory when it has ended
End Rem
Function FreeAction( act:TAction )
	act.FreeAction()
End Function

Rem
bbdoc: Ends action so it can be freed, 1 = automatically ended, 2 = manually ended
End Rem
Function EndAction( act:TAction )
	act.EndAction()
End Function

' *** Constraint

Rem
bbdoc: Create constraint force between two entities of given length, doesn't affect rotation
End Rem
Function CreateConstraint:TConstraint( p1:TEntity,p2:TEntity,l:Float )
	Return TConstraint.CreateConstraint( p1,p2,l )
End Function

Rem
bbdoc: Create rigid physics body attached to four entities
End Rem
Function CreateRigidBody:TRigidBody( body:TEntity,p1:TEntity,p2:TEntity,p3:TEntity,p4:TEntity )
	Return TRigidBody.CreateRigidBody( body,p1,p2,p3,p4 )
End Function

' *** Fluid

Rem
bbdoc: Create blob from a fluid mesh where radius is the size of the blob
End Rem
Function CreateBlob:TBlob( fluid:TFluid,radius:Float,parent_ent:TEntity=Null )
	Return TBlob.CreateBlob( fluid,radius,parent_ent )
End Function

Rem
bbdoc: Create fluid mesh for blobs to use
End Rem
Function CreateFluid:TFluid()
	Return TFluid.CreateFluid()
End Function

Rem
bbdoc: Create custom rendering array data for fluid mesh and set width, height and depth
End Rem
Function FluidArray( fluid:TFluid,Array:Float Var,w:Int,h:Int,d:Int )
	fluid.FluidArray( Array,w,h,d )
End Function

Rem
bbdoc: Set custom rendering callback function for fluid mesh
End Rem
Function FluidFunction( fluid:TFluid,FieldFunction:Float( x:Float,y:Float,z:Float ) )
	fluid.FluidFunction( FieldFunction )
End Function

Rem
bbdoc: Set threshold value used in fluid rendering algorithm, 0.5 is default
End Rem
Function FluidThreshold( fluid:TFluid,threshold:Float )
	FluidThreshold_( TFluid.GetInstance(fluid),threshold )
End Function

' *** Geosphere

Rem
bbdoc: Create geodesic sphere and set terrain size
End Rem
Function CreateGeosphere:TGeosphere( size:Int,parent:TEntity=Null )
	Return TGeosphere.CreateGeosphere( size,parent )
End Function

Rem
bbdoc: Set terrain height normalizing value, 0.05 is default
End Rem
Function GeosphereHeight( geo:TGeosphere,h:Float )
	GeosphereHeight_( TGeosphere.GetInstance(geo),h )
End Function

Rem
bbdoc: Load geodesic sphere terrain from heightmap image
End Rem
Function LoadGeosphere:TGeosphere( file:String,parent:TEntity=Null )
	Return TGeosphere.LoadGeosphere( file,parent )
End Function

Rem
bbdoc: Set height of a given point, like ModifyTerrain
End Rem
Function ModifyGeosphere( geo:TGeosphere,x:Int,z:Int,new_height:Float )
	geo.ModifyGeosphere( x,z,new_height )
End Function

' *** Octree

Rem
bbdoc: Create octree and set its width, height and depth
End Rem
Function CreateOcTree:TOcTree( w:Float,h:Float,d:Float,parent_ent:TEntity=Null )
	Return TOcTree.CreateOcTree( w,h,d,parent_ent )
End Function

Rem
bbdoc: Place mesh into a node of an octree, the mesh can be duplicated using no more memory
about: Since a block is not an entity it has no position, etc. it has the properties of the node it is in.
Level defaults to 0, the higher the level the smaller the cell. XYZ is the position in the octree.
Near defaults to 0, this is the minimum distance at which that node is visible, if 0 that node is
always visible, if higher the mesh/block won't be rendered when it's closer.
Far defaults to 1000, this is the maximum distance at which the node can be split in children,
if the node is set at a higher range than the camera, its children won't be rendered.
End Rem
Function OctreeBlock( octree:TOcTree,mesh:TMesh,level:Int,X:Float,Y:Float,Z:Float,Near:Float=0,Far:Float=1000 )
	octree.OctreeBlock( mesh,level,X,Y,Z,Near,Far )
End Function

Rem
bbdoc: Place mesh into a node of an octree, the mesh can't be duplicated so to do that use CopyEntity
End Rem
Function OctreeMesh( octree:TOcTree,mesh:TMesh,level:Int,X:Float,Y:Float,Z:Float,Near:Float=0,Far:Float=1000 )
	octree.OctreeMesh( mesh,level,X,Y,Z,Near,Far )
End Function

' *** Particle

Rem
bbdoc: Create particle emitter and set sprite for it to use
End Rem
Function CreateParticleEmitter:TParticleEmitter( particle:TEntity,parent_ent:TEntity=Null )
	Return TParticleEmitter.CreateParticleEmitter( particle,parent_ent )
End Function

Rem
bbdoc: Set emitters start and end 3d vectors
about: Vectors are affected by speed. Minus end values can be used to slow particles.
End Rem
Function EmitterVector( emit:TParticleEmitter,startx:Float,starty:Float,startz:Float,endx:Float,endy:Float,endz:Float )
	emit.EmitterVector( startx,starty,startz,endx,endy,endz )
End Function

Rem
bbdoc: Rate between each emission, range is 0.01..1.01
about: This is a way to slow particle emissions down. A rate of 1.01 is full rate.
End Rem
Function EmitterRate( emit:TParticleEmitter,r:Float )
	emit.EmitterRate( r )
End Function

Rem
bbdoc: Set particles start, end and random lifespan
about: startl sets when a particle becomes visible, endl is full life and randl is the random range.
End Rem
Function EmitterParticleLife( emit:TParticleEmitter,startl:Int,endl:Int,randl:Int=0 )
	emit.EmitterParticleLife( startl,endl,randl )
End Function

Rem
bbdoc: Points to callback function for emitter
about: This gives access to each particle and also current life left.
End Rem
Function EmitterParticleFunction( emit:TParticleEmitter,EmitterFunction( ent:Byte Ptr,life:Int ) )
	emit.EmitterParticleFunction( EmitterFunction ) ' note: use TEntity.GetInstance(ent)
End Function

Rem
bbdoc: Set particles start and end speed
about: Minus end values can be used to slow particles down.
End Rem
Function EmitterParticleSpeed( emit:TParticleEmitter,starts:Float,ends:Float=0 )
	emit.EmitterParticleSpeed( starts,ends )
End Function

Rem
bbdoc: Set random variance of particles, range is 0.001..0.1
about: Variance will be increasing chaotic above 0.1.
End Rem
Function EmitterVariance( emit:TParticleEmitter,v:Float )
	emit.EmitterVariance( v )
End Function

Rem
bbdoc: Set particles alpha at start and end, range is 0..1
End Rem
Function EmitterParticleAlpha( emit:TParticleEmitter,starta:Float,enda:Float,mida:Float=0,midlife:Int=0 )
	emit.EmitterParticleAlpha( starta,enda,mida,midlife )
End Function

Rem
bbdoc: Set particles scale at start and end, default is 1
End Rem
Function EmitterParticleScale( emit:TParticleEmitter,startx:Float,starty:Float,endx:Float,endy:Float,midsx:Float=1,midsy:Float=1,midlife:Int=0 )
	emit.EmitterParticleScale( startx,starty,endx,endy,midsx,midsy,midlife )
End Function

Rem
bbdoc: Set particles RGB color at start and end, default is 255,255,255
End Rem
Function EmitterParticleColor( emit:TParticleEmitter,startr:Float,startg:Float,startb:Float,endr:Float,endg:Float,endb:Float,midr:Float=255,midg:Float=255,midb:Float=255,midlife:Int=0 )
	emit.EmitterParticleColor( startr,startg,startb,endr,endg,endb,midr,midg,midb,midlife )
End Function

Rem
bbdoc: Set particles rotation angle at start and end
about: Minus values will rotate clockwise
End Rem
Function EmitterParticleRotate( emit:TParticleEmitter,startr:Float,endr:Float,midr:Float=0,midlife:Int=0 )
	emit.EmitterParticleRotate( startr,endr,midr,midlife )
End Function

Rem
bbdoc: Sets color of batch particle trails
about: Batch particle render mode (3) is not working.
End Rem
Function ParticleColor( sprite:TSprite,r:Float,g:Float,b:Float,a:Float=0 )
	ParticleColor_( TSprite.GetInstance(sprite),r,g,b,a )
End Function

Rem
bbdoc: Sets 3d vector of batch particle trails
about: Batch particle render mode (3) is not working.
End Rem
Function ParticleVector( sprite:TSprite,x:Float,y:Float,z:Float )
	ParticleVector_( TSprite.GetInstance(sprite),x,y,z )
End Function

Rem
bbdoc: Sets number of batch particles in trail
about: Batch particle render mode (3) is not working.
End Rem
Function ParticleTrail( sprite:TSprite,length:Int )
	ParticleTrail_( TSprite.GetInstance(sprite),length )
End Function

' *** PostFX

Rem
bbdoc: undocumented
End Rem
Function CreatePostFX:TPostFX( cam:TCamera,passes:Int=1 )
	Return TPostFX.CreatePostFX( cam,passes )
End Function

Rem
bbdoc: undocumented
End Rem
Function AddRenderTarget( fx:TPostFX,pass_no:Int,numColBufs:Int,depth:Int,format:Int=8,scale:Float=1.0 )
	fx.AddRenderTarget( pass_no,numColBufs,depth,format,scale )
End Function

Rem
bbdoc: undocumented
End Rem
Function PostFXShader( fx:TPostFX,pass_no:Int,shader:TShader )
	fx.PostFXShader( pass_no,shader )
End Function

Rem
bbdoc: undocumented
End Rem
Function PostFXShaderPass( fx:TPostFX,pass_no:Int,name:String,v:Int )
	fx.PostFXShaderPass( pass_no,name,v )
End Function

Rem
bbdoc: undocumented
End Rem
Function PostFXBuffer( fx:TPostFX,pass_no:Int,source_pass:Int,index:Int,slot:Int )
	fx.PostFXBuffer( pass_no,source_pass,index,slot )
End Function

Rem
bbdoc: undocumented
End Rem
Function PostFXTexture( fx:TPostFX,pass_no:Int,tex:TTexture,slot:Int,frame:Int=0 )
	fx.PostFXTexture( pass_no,tex,slot,frame )
End Function

Rem
bbdoc: undocumented
End Rem
Function PostFXFunction( fx:TPostFX,pass_no:Int,PassFunction() )
	fx.PostFXFunction( pass_no,PassFunction )
End Function

' *** Shader

Rem
bbdoc: Load shader from two files, vertex and fragment
End Rem
Function LoadShader:TShader( ShaderName:String,VshaderFileName:String,FshaderFileName:String )
	Return TShader.LoadShader( ShaderName,VshaderFileName,FshaderFileName )
End Function

Rem
bbdoc: Load shader from two strings, vertex and fragment
End Rem
Function CreateShader:TShader( ShaderName:String,VshaderString:String,FshaderString:String )
	Return TShader.CreateShader( ShaderName,VshaderString,FshaderString )
End Function

Rem
bbdoc: Load shader from three files, vertex, geometry and fragment
End Rem
Function LoadShaderVGF:TShader( ShaderName:String,VshaderFileName:String,GshaderFileName:String,FshaderFileName:String )
	Return TShader.LoadShaderVGF( ShaderName,VshaderFileName,GshaderFileName,FshaderFileName )
End Function

Rem
bbdoc: Load shader from three strings, vertex, geometry and fragment
End Rem
Function CreateShaderVGF:TShader( ShaderName:String,VshaderString:String,GshaderString:String,FshaderString:String )
	Return TShader.CreateShaderVGF( ShaderName,VshaderString,GshaderString,FshaderString )
End Function

Rem
bbdoc: Apply shader to a surface
End Rem
Function ShadeSurface( surf:TSurface,material:TShader )
	ShadeSurface_( TSurface.GetInstance(surf),TShader.GetInstance(material) )
End Function

Rem
bbdoc: Apply shader to a mesh
End Rem
Function ShadeMesh( mesh:TMesh,material:TShader )
	ShadeMesh_( TMesh.GetInstance(mesh),TShader.GetInstance(material) )
End Function

Rem
bbdoc: Apply shader to an entity
End Rem
Function ShadeEntity( ent:TEntity,material:TShader )
	ShadeEntity_( TEntity.GetInstance(ent),TShader.GetInstance(material) )
End Function

Rem
bbdoc: Load a texture for 2D texture sampling
End Rem
Function ShaderTexture:TTexture( material:TShader,tex:TTexture,name:String,index:Int=0 )
	Return material.ShaderTexture( tex,name,index )
End Function

Rem
bbdoc: Set a shader variable name of a uniform float type to a float value
End Rem
Function SetFloat( material:TShader,name:String,v1:Float )
	material.SetFloat( name,v1 )
End Function

Rem
bbdoc: Set a shader variable name of a uniform vec2 type to 2 float values
End Rem
Function SetFloat2( material:TShader,name:String,v1:Float,v2:Float )
	material.SetFloat2( name,v1,v2 )
End Function

Rem
bbdoc: Set a shader variable name of a uniform vec3 type to 3 float values
End Rem
Function SetFloat3( material:TShader,name:String,v1:Float,v2:Float,v3:Float )
	material.SetFloat3( name,v1,v2,v3 )
End Function

Rem
bbdoc: Set a shader variable name of a uniform vec4 type to 4 float values
End Rem
Function SetFloat4( material:TShader,name:String,v1:Float,v2:Float,v3:Float,v4:Float )
	material.SetFloat4( name,v1,v2,v3,v4 )
End Function

Rem
bbdoc: Bind a float variable to a shader variable name of a uniform float type
End Rem
Function UseFloat( material:TShader,name:String,v1:Float Var )
	material.UseFloat( name,v1 )
End Function

Rem
bbdoc: Bind 2 float variables to a shader variable name of a uniform vec2 Type
End Rem
Function UseFloat2( material:TShader,name:String,v1:Float Var,v2:Float Var )
	material.UseFloat2( name,v1,v2 )
End Function

Rem
bbdoc: Bind 3 float variables to a shader variable name of a uniform vec3 type
End Rem
Function UseFloat3( material:TShader,name:String,v1:Float Var,v2:Float Var,v3:Float Var )
	material.UseFloat3( name,v1,v2,v3 )
End Function

Rem
bbdoc: Bind 4 float variables to a shader variable name of a uniform vec4 type
End Rem
Function UseFloat4( material:TShader,name:String,v1:Float Var,v2:Float Var,v3:Float Var,v4:Float Var )
	material.UseFloat4( name,v1,v2,v3,v4 )
End Function

Rem
bbdoc: Set a shader variable name of a uniform int type to an integer value
End Rem
Function SetInteger( material:TShader,name:String,v1:Int )
	material.SetInteger( name,v1 )
End Function

Rem
bbdoc: Set a shader variable name of a uniform ivec2 type to 2 integer values
End Rem
Function SetInteger2( material:TShader,name:String,v1:Int,v2:Int )
	material.SetInteger2( name,v1,v2 )
End Function

Rem
bbdoc: Set a shader variable name of a uniform ivec3 type to 3 integer values
End Rem
Function SetInteger3( material:TShader,name:String,v1:Int,v2:Int,v3:Int )
	material.SetInteger3( name,v1,v2,v3 )
End Function

Rem
bbdoc: Set a shader variable name of a uniform ivec4 type to 4 integer values
End Rem
Function SetInteger4( material:TShader,name:String,v1:Int,v2:Int,v3:Int,v4:Int )
	material.SetInteger4( name,v1,v2,v3,v4 )
End Function

Rem
bbdoc: Bind an integer variable to a shader variable name of a uniform int type
End Rem
Function UseInteger( material:TShader,name:String,v1:Int Var )
	material.UseInteger( name,v1 )
End Function

Rem
bbdoc: Bind 2 integer variables to a shader variable name of a uniform ivec2 type
End Rem
Function UseInteger2( material:TShader,name:String,v1:Int Var,v2:Int Var )
	material.UseInteger2( name,v1,v2 )
End Function

Rem
bbdoc: Bind 3 integer variables to a shader variable name of a uniform ivec3 type
End Rem
Function UseInteger3( material:TShader,name:String,v1:Int Var,v2:Int Var,v3:Int Var )
	material.UseInteger3( name,v1,v2,v3 )
End Function

Rem
bbdoc: Bind 4 integer variables to a shader variable name of a uniform ivec4 type
End Rem
Function UseInteger4( material:TShader,name:String,v1:Int Var,v2:Int Var,v3:Int Var,v4:Int Var )
	material.UseInteger4( name,v1,v2,v3,v4 )
End Function

Rem
bbdoc: Sends surface data to a shader variable name
about: Vbo is in range 1..6 which selects what vertex buffer data to access, where 1 is vertex positions, 
2/3 is tex coords 0/1, 4 is vertex normals, 5 is vertex color, 6 is triangles.
End Rem
Function UseSurface( material:TShader,name:String,surf:TSurface,vbo:Int )
	material.UseSurface( name,surf,vbo )
End Function

Rem
bbdoc: Sends matrix data to a shader variable name of a uniform mat4 type
End Rem
Function UseMatrix( material:TShader,name:String,Mode:Int )
	material.UseMatrix( name,Mode )
End Function

Rem
bbdoc: Load a texture from image for 3D texture sampling, use with voxelsprites
about: Flags are texture flags, frame width/height is the size in pixels of each slice,
first frame is the index of the slice and frame count is how many slices.
End Rem
Function LoadMaterial:TMaterial( filename:String,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int )
	Return TMaterial.LoadMaterial( filename,flags,frame_width,frame_height,first_frame,frame_count )
End Function

Rem
bbdoc: Set a 3d texture for sampling
End Rem
Function ShaderMaterial( material:TShader,tex:TMaterial,name:String,index:Int=0 )
	material.ShaderMaterial( tex,name,index )
End Function

Rem
bbdoc: Set default shader for surfaces
End Rem
Function AmbientShader( material:TShader )
	TGlobal3D.ambient_shader=material
	material.AmbientShader()
End Function

Rem
bbdoc: undocumented
End Rem
Function UseEntity( material:TShader,name:String,ent:TEntity,mode:Int )
	material.UseEntity( name,ent,mode )
End Function

Rem
bbdoc: undocumented
End Rem
Function ShaderFunction( material:TShader,EnableFunction(),DisableFunction() )
	material.ShaderFunction( EnableFunction,DisableFunction )
End Function

Rem
bbdoc: Get a shader program object reference
End Rem
Function GetShaderProgram:Int( material:TShader )
	Return material.GetShaderProgram()
End Function

' *** Shadow

Rem
bbdoc: Create stencil shadow, static is for static or dynamic shadows
End Rem
Function CreateShadow:TShadowObject( parent:TMesh,Static:Int=False )
	Return TShadowObject.CreateShadow( parent,Static )
End Function

Rem
bbdoc: Free stencil shadow
End Rem
Function FreeShadow( shad:TShadowObject )
	shad.FreeShadow()
End Function

Rem
bbdoc: Reset created flag to update static shadow
End Rem
Function ResetShadow( shad:TShadowObject )
	shad.VCreated[0]=0
End Function

Rem
bbdoc: Set color R/G/B in range 0..255 and A in range 0..1
End Rem
Function SetShadowColor( R:Int,G:Int,B:Int,A:Int )	
	SetShadowColor_( R,G,B,A )
End Function


' *** Stencil

Rem
bbdoc: Create stencil object
End Rem
Function CreateStencil:TStencil()
	Return TStencil.CreateStencil()
End Function

Rem
bbdoc: Set stencil alpha value
End Rem
Function StencilAlpha( stencil:TStencil,a:Float )
	stencil.StencilAlpha( a )
End Function

Rem
bbdoc: Set stencil clear screen color in range 0..255
End Rem
Function StencilClsColor( stencil:TStencil,r:Float,g:Float,b:Float )
	stencil.StencilClsColor( r,g,b )
End Function

Rem
bbdoc: Set stencil clear screen modes
about: Cls_color is true to use the color buffer, cls_zbuffer is true to use the depth buffer.
End Rem
Function StencilClsMode( stencil:TStencil,cls_color:Int,cls_zbuffer:Int )
	stencil.StencilClsMode( cls_color,cls_zbuffer )
End Function

Rem
bbdoc: Set mesh to be used as stencil
about: Mode is stencil action for glStencilOp in range -2..2 where 1 is INCR (default), 
2 is INCR for stencil shadow meshes and negative values are DECR.
End Rem
Function StencilMesh( stencil:TStencil,mesh:TMesh,Mode:Int=1 )
	stencil.StencilMesh( mesh,Mode )
End Function

Rem
bbdoc: Set stencil render modes
about:  M is stencil action mode for glStencilOp in range -2..2 where 1 is INCR (default), 
2 is INCR for stencil shadow meshes and negative values are DECR. O is comparison operator for
glStencilFunc in range 0..3 which stands for one of NOTEQUAL, EQUAL, LEQUAL or GEQUAL.
End Rem
Function StencilMode( stencil:TStencil,m:Int,o:Int=1 )
	stencil.StencilMode( m,o )
End Function

Rem
bbdoc: Stencil to use, set to Null to disable stencil
End Rem
Function UseStencil( stencil:TStencil )
	UseStencil_( TStencil.GetInstance(stencil) )
End Function

' *** VoxelSprite

Rem
bbdoc: Create voxel sprite where slices is the number of sprites
End Rem
Function CreateVoxelSprite:TVoxelSprite( slices:Int=64,parent:TEntity=Null )
	Return TVoxelSprite.CreateVoxelSprite( slices,parent )
End Function

Rem
bbdoc: Set material for voxel sprite
End Rem
Function VoxelSpriteMaterial( voxelspr:TVoxelSprite,mat:TMaterial )
	voxelspr.VoxelSpriteMaterial( mat )
End Function
