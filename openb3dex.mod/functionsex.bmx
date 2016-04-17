' functionsex.bmx

' *** Wrapper only

Rem
bbdoc: GL equivalent.
End Rem
Function BrushGLColor( brush:TBrush,r:Float,g:Float,b:Float,a:Float=1.0 )
	BrushGLColor_( TBrush.GetInstance(brush),r,g,b,a )
End Function

Rem
bbdoc: GL equivalent.
End Rem
Function BrushGLBlendFunc( brush:TBrush,sfactor:Int,dfactor:Int )
	BrushGLBlendFunc_( TBrush.GetInstance(brush),sfactor,dfactor )
End Function

Rem
bbdoc: GL equivalent.
End Rem
Function TextureGLTexEnv( tex:TTexture,target:Int=0,pname:Int=0,param:Int=0 )
	TextureGLTexEnv_( TTexture.GetInstance(tex),target,pname,param )
End Function

Rem
bbdoc: Set texture flags, see LoadTexture for values.
End Rem
Function TextureFlags( tex:TTexture,flags:Int )
	tex.TextureFlags(flags)
End Function

Rem
bbdoc: Frees VBO data and brush.
End Rem
Function FreeSurface( surf:TSurface )
	Return surf.FreeSurface()
End Function

Rem
bbdoc: Returns a copy of the new brush.
End Rem
Function CopyBrush:TBrush( brush:TBrush )
	Return brush.Copy()
End Function

Rem
bbdoc: Returns a copy of the new surface.
End Rem
Function CopySurface:TSurface( surf:TSurface )
	Return surf.Copy()
End Function

Rem
bbdoc: Returns a copy of the new texture.
End Rem
Function CopyTexture:TTexture( tex:TTexture )
	Return tex.Copy()
End Function

' *** Minib3d only

Rem
bbdoc: Copy the contents of the backbuffer to a texture
about: OpenB3D does not have the same buffer commands as Blitz3D.
The region copied from the backbuffer will start at 0,0 and end at the texture's width and height.
So if you want to copy a 3D scene to a texture, first resize the camera viewport to the texture size, 
use RenderWorld to render the camera, then use this command.
End Rem
Function BackBufferToTex( tex:TTexture,frame:Int=0 )
	tex.BackBufferToTex( frame ) ' frame currently does nothing
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
bbdoc: Set animated surface (vid is vertex index) for each of the bone no and weights arrays
about: bone no references the bones list in a mesh, weights is a normalizing value.
End Rem
Function SkinMesh( mesh:TMesh,surf_no_get:Int,vid:Int,bone1:Int,weight1:Float=1.0,bone2:Int=0,weight2:Float=0,bone3:Int=0,weight3:Float=0,bone4:Int=0,weight4:Float=0 )
	mesh.SkinMesh( surf_no_get,vid,bone1,weight1,bone2,weight2,bone3,weight3,bone4,weight4 )
End Function

Rem
bbdoc: If mode is 1 rendering is normal, 2 is batch sprites on a single surface, 3 is batch particles
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
bbdoc: Frees action from memory
End Rem
Function FreeAction( act:TAction )
	act.FreeAction()
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
bbdoc: Create particle emitter from sprite
End Rem
Function CreateParticleEmitter:TParticleEmitter( particle:TEntity,parent_ent:TEntity=Null )
	Return TParticleEmitter.CreateParticleEmitter( particle,parent_ent )
End Function

Rem
bbdoc: Set vector (direction and speed) for wind or gravity effects
End Rem
Function EmitterVector( emit:TParticleEmitter,x:Float,y:Float,z:Float )
	emit.EmitterVector( x,y,z )
End Function

Rem
bbdoc: Rate between each emission in range 0..1, smaller is slower
End Rem
Function EmitterRate( emit:TParticleEmitter,r:Float )
	emit.EmitterRate( r )
End Function

Rem
bbdoc: Particle lifespan in frames
End Rem
Function EmitterParticleLife( emit:TParticleEmitter,l:Int )
	emit.EmitterParticleLife( l )
End Function

Rem
bbdoc: Set custom rendering callback function for particle emitter
End Rem
Function EmitterParticleFunction( emit:TParticleEmitter,EmitterFunction( ent:Byte Ptr,life:Int ) )
	emit.EmitterParticleFunction( EmitterFunction ) ' note: use TEntity.GetInstance(ent)
End Function

Rem
bbdoc: Set initial speed, use Rotate/TurnEntity to change direction
End Rem
Function EmitterParticleSpeed( emit:TParticleEmitter,s:Float )
	emit.EmitterParticleSpeed( s )
End Function

Rem
bbdoc: Set randomness of emission (direction and speed)
End Rem
Function EmitterVariance( emit:TParticleEmitter,v:Float )
	emit.EmitterVariance( v )
End Function

Rem
bbdoc: Set color of particle trails
End Rem
Function ParticleColor( sprite:TSprite,r:Float,g:Float,b:Float,a:Float=0 )
	ParticleColor_( TSprite.GetInstance(sprite),r,g,b,a )
End Function

Rem
bbdoc: Set vector (direction and speed) of particle trails
End Rem
Function ParticleVector( sprite:TSprite,x:Float,y:Float,z:Float )
	ParticleVector_( TSprite.GetInstance(sprite),x,y,z )
End Function

Rem
bbdoc: Set number of particles in trail
End Rem
Function ParticleTrail( sprite:TSprite,length:Int )
	ParticleTrail_( TSprite.GetInstance(sprite),length )
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
Function ShaderTexture( material:TShader,tex:TTexture,name:String,index:Int=0 )
	material.ShaderTexture( tex,name,index )
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
	TGlobal.ambient_shader=material
	AmbientShader_( TShader.GetInstance(material) )
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
