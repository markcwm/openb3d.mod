' openb3dlib.bmx

SuperStrict

Rem
bbdoc: OpenB3D library wrapper
about:
The library source with declarations for functions, methods and fields.
End Rem
Module Openb3d.Openb3dlib

ModuleInfo "Version: 1.26"
ModuleInfo "License: zlib"
ModuleInfo "Copyright: Wrapper - 2014-2021 Mark Mcvittie"
ModuleInfo "Copyright: Library - 2010-2021 Angelo Rosina"

ModuleInfo "History: 1.26 Release - Jul 2021"
ModuleInfo "History: 1.25 Release - Jan 2019"
ModuleInfo "History: 1.12 Release - Mar 2016"
ModuleInfo "History: 1.1 Release - Sep 2015"
ModuleInfo "History: 1.0 Release - Jun 2015"
ModuleInfo "History: 0.9 Release - Nov 2014"
ModuleInfo "History: 0.8 Release - Initial commit Oct 2014"

'ModuleInfo "CC_OPTS: -std=c++11" ' just a reminder that forcing C++11 standard fails on older compilers
'ModuleInfo "CC_OPTS: -DOPENB3D_GLEE" ' force use of GLee instead of Glew

?debug
ModuleInfo "CC_OPTS: -DOPENB3D_DEBUG" ' use C++ debug logger (by Spinduluz)
?win32
ModuleInfo "CC_OPTS: -DGLEW_STATIC" ' build static .a otherwise .dll (Win only)

Import Pub.Glew
Import Pub.OpenGL ' order is important, glew before OpenGL
?macos
Import Pub.Glew
Import Pub.OpenGL
?linux
Import Pub.Glew
Import Pub.OpenGL
?opengles
ModuleInfo "CC_OPTS: -UGLES2" ' untested!

Import Pub.OpenGLES
?
Import "source.bmx"

' functions.cpp
Extern

	' *** Extra
	Function TerrainScaleTexCoords_( terr:Byte Ptr,u_scale:Float,v_scale:Float,coords_set:Int )
	Function TerrainCountTriangles_:Int( terr:Byte Ptr )
	Function TerrainCountVertices_:Int( terr:Byte Ptr )
	Function TerrainDetail_( terr:Byte Ptr,detail_level:Float )
	Function TextureAnIsotropic_( tex:Byte Ptr,f:Float )
	Function UseTextureFrames_( lf0:Int,fr1:Int,rt2:Int,bk3:Int,dn4:Int,up5:Int )
	Function UseTextureFaces_( lf0:Int,fr1:Int,rt2:Int,bk3:Int,dn4:Int,up5:Int )
	Function UseCubemapFlip_( flag:Int )
	Function MSAntiAlias_( multisample:Int )
	Function CountMipmaps_:Int( tex:Byte Ptr )
	Function TextureMultitex_( tex:Byte Ptr,f:Float )
	Function TrisRendered_:Int()
	Function VertsRendered_:Int()
	Function SurfsRendered_:Int()
	Function NewSprite_:Byte Ptr()
	Function NewTexture_:Byte Ptr()
	Function NewMesh_:Byte Ptr()
	Function NewSurface_:Byte Ptr()
	Function NewBone_:Byte Ptr()
	Function CreateShaderMaterial_:Byte Ptr( ShaderName:Byte Ptr )
	Function CreateFragShader_:Byte Ptr( shader:Byte Ptr,shaderFileName:Byte Ptr )
	Function CreateFragShaderFromString_:Byte Ptr( shader:Byte Ptr,shadercode:Byte Ptr )
	Function CreateVertShader_:Byte Ptr( shader:Byte Ptr,shaderFileName:Byte Ptr )
	Function CreateVertShaderFromString_:Byte Ptr( shader:Byte Ptr,shadercode:Byte Ptr )
	Function AttachFragShader_:Int( shader:Byte Ptr,myShader:Byte Ptr )
	Function AttachVertShader_:Int( shader:Byte Ptr,myShader:Byte Ptr )
	Function LinkShader_:Int( shader:Byte Ptr )
	Function DeleteFragShader_( myShader:Byte Ptr )
	Function DeleteVertShader_( myShader:Byte Ptr )
	Function FreeShader_( shader:Byte Ptr )
	Function FreeStencil_( stencil:Byte Ptr )
	Function TextureFlags_( tex:Byte Ptr,flags:Int )
	Function FreeSurface_( surf:Byte Ptr )
	Function TextureGLTexEnvi_( tex:Byte Ptr,target:Int,pname:Int,param:Int )
	Function TextureGLTexEnvf_( tex:Byte Ptr,target:Int,pname:Int,param:Float )
	Function BrushGLColor_( brush:Byte Ptr,r:Float,g:Float,b:Float,a:Float )
	Function BrushGLBlendFunc_( brush:Byte Ptr,sfactor:Int,dfactor:Int )
	Function LightMesh_( m:Byte Ptr,red:Float,green:Float,blue:Float,range:Float,light_x:Float,light_y:Float,light_z:Float )
	
	' *** Minib3d only
	Function BackBufferToTex_( tex:Byte Ptr,mipmap_no:Int,frame:Int,fastinvert:Int )
	Function MeshCullRadius_( ent:Byte Ptr,radius:Float )
	Function EntityScaleX_:Float( ent:Byte Ptr,glob:Int )
	Function EntityScaleY_:Float( ent:Byte Ptr,glob:Int )
	Function EntityScaleZ_:Float( ent:Byte Ptr,glob:Int )
	
	' *** Blitz3D functions, A-Z
	Function AddMesh_( mesh1:Byte Ptr,mesh2:Byte Ptr )
	Function AddTriangle_:Int( surf:Byte Ptr,v0:Int,v1:Int,v2:Int )
	Function AddVertex_:Int( surf:Byte Ptr,x:Float,y:Float,z:Float,u:Float,v:Float,w:Float )
	Function AmbientLight_( r:Float,g:Float,b:Float )
	Function Animate_( ent:Byte Ptr,Mode:Int,speed:Float,seq:Int,trans:Int )
	Function Animating_:Int( ent:Byte Ptr )
	Function AnimLength_:Int( ent:Byte Ptr )
	Function AnimSeq_:Int( ent:Byte Ptr )
	Function AnimTime_:Float( ent:Byte Ptr )
	Function AntiAlias_( samples:Int )
	Function BrushAlpha_( brush:Byte Ptr,a:Float )
	Function BrushBlend_( brush:Byte Ptr,blend:Int )
	Function BrushColor_( brush:Byte Ptr,r:Float,g:Float,b:Float )
	Function BrushFX_( brush:Byte Ptr,fx:Int )
	Function BrushShininess_( brush:Byte Ptr,s:Float )
	Function BrushTexture_( brush:Byte Ptr,tex:Byte Ptr,frame:Int,index:Int )
	Function CameraClsColor_( cam:Byte Ptr,r:Float,g:Float,b:Float )
	Function CameraClsMode_( cam:Byte Ptr,cls_depth:Int,cls_zbuffer:Int )
	Function CameraFogColor_( cam:Byte Ptr,r:Float,g:Float,b:Float )
	Function CameraFogMode_( cam:Byte Ptr,Mode:Int )
	Function CameraFogRange_( cam:Byte Ptr,nnear:Float,nfar:Float )
	Function CameraPick_:Byte Ptr( cam:Byte Ptr,x:Float,y:Float )
	Function CameraProject_( cam:Byte Ptr,x:Float,y:Float,z:Float )
	Function CameraProjMode_( cam:Byte Ptr,Mode:Int )
	Function CameraRange_( cam:Byte Ptr,nnear:Float,nfar:Float )
	Function CameraViewport_( cam:Byte Ptr,x:Int,y:Int,width:Int,height:Int )
	Function CameraZoom_( cam:Byte Ptr,zoom:Float )
	Function ClearCollisions_()
	Function ClearSurface_( surf:Byte Ptr,clear_verts:Int,clear_tris:Int )
	Function ClearTextureFilters_()
	Function ClearWorld_( entities:Int,brushes:Int,textures:Int )
	Function CollisionEntity_:Byte Ptr( ent:Byte Ptr,index:Int )
	Function CollisionNX_:Float( ent:Byte Ptr,index:Int )
	Function CollisionNY_:Float( ent:Byte Ptr,index:Int )
	Function CollisionNZ_:Float( ent:Byte Ptr,index:Int )
	Function Collisions_( src_no:Int,dest_no:Int,method_no:Int,response_no:Int )
	Function CollisionSurface_:Byte Ptr( ent:Byte Ptr,index:Int )
	Function CollisionTime_:Float( ent:Byte Ptr,index:Int )
	Function CollisionTriangle_:Int( ent:Byte Ptr,index:Int )
	Function CollisionX_:Float( ent:Byte Ptr,index:Int )
	Function CollisionY_:Float( ent:Byte Ptr,index:Int )
	Function CollisionZ_:Float( ent:Byte Ptr,index:Int )
	Function CopyEntity_:Byte Ptr( ent:Byte Ptr,parent:Byte Ptr )
	Function CopyMesh_:Byte Ptr( mesh:Byte Ptr,parent:Byte Ptr )
	Function CountChildren_:Int( ent:Byte Ptr )
	Function CountCollisions_:Int( ent:Byte Ptr )
	Function CountSurfaces_:Int( mesh:Byte Ptr )
	Function CountTriangles_:Int( surf:Byte Ptr )
	Function CountVertices_:Int( surf:Byte Ptr )
	Function CreateBrush_:Byte Ptr( r:Float,g:Float,b:Float )
	Function CreateCamera_:Byte Ptr( parent:Byte Ptr )
	Function CreateCone_:Byte Ptr( segments:Int,solid:Int,parent:Byte Ptr )
	Function CreateCylinder_:Byte Ptr( segments:Int,solid:Int,parent:Byte Ptr )
	Function CreateCube_:Byte Ptr( parent:Byte Ptr )
	Function CreateMesh_:Byte Ptr( parent:Byte Ptr )
	Function CreateLight_:Byte Ptr( light_type:Int,parent:Byte Ptr )
	Function CreatePivot_:Byte Ptr( parent:Byte Ptr )
	Function CreateSphere_:Byte Ptr( segments:Int,parent:Byte Ptr )
	Function CreateSprite_:Byte Ptr( parent:Byte Ptr )
	Function CreateSurface_:Byte Ptr( mesh:Byte Ptr,brush:Byte Ptr )
	Function CreateTexture_:Byte Ptr( width:Int,height:Int,flags:Int,frames:Int )
	Function DeltaPitch_:Float( ent1:Byte Ptr,ent2:Byte Ptr )
	Function DeltaYaw_:Float( ent1:Byte Ptr,ent2:Byte Ptr )
	Function EntityAlpha_( ent:Byte Ptr,alpha:Float )
	'Function EntityAutoFade_( ent:Byte Ptr,near:Float,far:Float )
	Function EntityBlend_( ent:Byte Ptr,blend:Int )
	Function EntityBox_( ent:Byte Ptr,x:Float,y:Float,z:Float,w:Float,h:Float,d:Float )
	Function EntityClass_:Byte Ptr( ent:Byte Ptr )
	Function EntityCollided_:Byte Ptr( ent:Byte Ptr,type_no:Int )
	Function EntityColor_( ent:Byte Ptr,red:Float,green:Float,blue:Float,recursive:Int )
	Function EntityDistance_:Float( ent1:Byte Ptr,ent2:Byte Ptr )
	Function EntityFX_( ent:Byte Ptr,fx:Int )
	Function EntityInView_:Int( ent:Byte Ptr,cam:Byte Ptr )
	Function EntityName_:Byte Ptr( ent:Byte Ptr )
	Function EntityOrder_( ent:Byte Ptr,order:Int )
	Function EntityParent_( ent:Byte Ptr,parent_ent:Byte Ptr,glob:Int )
	Function EntityPick_:Byte Ptr( ent:Byte Ptr,Range:Float )
	Function EntityPickMode_( ent:Byte Ptr,pick_mode:Int,obscurer:Int )
	Function EntityPitch_:Float( ent:Byte Ptr,glob:Int )
	Function EntityRadius_( ent:Byte Ptr,radius_x:Float,radius_y:Float )
	Function EntityRoll_:Float( ent:Byte Ptr,glob:Int )
	Function EntityShininess_( ent:Byte Ptr,shine:Float )
	Function EntityTexture_( ent:Byte Ptr,tex:Byte Ptr,frame:Int,index:Int )
	Function EntityType_( ent:Byte Ptr,type_no:Int,recursive:Int )
	Function EntityVisible_:Int( src_ent:Byte Ptr,dest_ent:Byte Ptr )
	Function EntityX_:Float( ent:Byte Ptr,glob:Int )
	Function EntityY_:Float( ent:Byte Ptr,glob:Int )
	Function EntityYaw_:Float( ent:Byte Ptr,glob:Int )
	Function EntityZ_:Float( ent:Byte Ptr,glob:Int )
	Function ExtractAnimSeq_:Int( ent:Byte Ptr,first_frame:Int,last_frame:Int,seq:Int )
	Function FindChild_:Byte Ptr( ent:Byte Ptr,child_name:Byte Ptr )
	Function FindSurface_:Byte Ptr( mesh:Byte Ptr,brush:Byte Ptr )
	Function FitMesh_( mesh:Byte Ptr,x:Float,y:Float,z:Float,width:Float,height:Float,depth:Float,uniform:Int )
	Function FlipMesh_( mesh:Byte Ptr )
	Function FreeBrush_( brush:Byte Ptr )
	Function FreeEntity_( ent:Byte Ptr )
	Function FreeTexture_( tex:Byte Ptr )
	Function GetBrushTexture_:Byte Ptr( brush:Byte Ptr,index:Int )
	Function GetChild_:Byte Ptr( ent:Byte Ptr,child_no:Int )
	Function GetEntityBrush_:Byte Ptr( ent:Byte Ptr )
	Function GetEntityType_:Int( ent:Byte Ptr )
	'Function GetMatElement_:Float( ent:Byte Ptr,row:Int,col:Int )
	Function GetParentEntity_:Byte Ptr( ent:Byte Ptr )
	Function GetSurface_:Byte Ptr( mesh:Byte Ptr,surf_no:Int )
	Function GetSurfaceBrush_:Byte Ptr( surf:Byte Ptr )
	Function Graphics3D_( width:Int,height:Int,depth:Int,mode:Int,rate:Int )
	Function HandleSprite_( sprite:Byte Ptr,h_x:Float,h_y:Float )
	Function HideEntity_( ent:Byte Ptr )
	Function LightColor_( light:Byte Ptr,red:Float,green:Float,blue:Float )
	Function LightConeAngles_( light:Byte Ptr,inner_ang:Float,outer_ang:Float )
	Function LightRange_( light:Byte Ptr,Range:Float )
	Function LinePick_:Byte Ptr( x:Float,y:Float,z:Float,dx:Float,dy:Float,dz:Float,radius:Float )
	Function LoadAnimMesh_:Byte Ptr( file:Byte Ptr,parent:Byte Ptr )
	Function LoadAnimTexture_:Byte Ptr( file:Byte Ptr,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int,tex:Byte Ptr )
	Function LoadBrush_:Byte Ptr( file:Byte Ptr,flags:Int,u_scale:Float,v_scale:Float )
	Function LoadMesh_:Byte Ptr( file:Byte Ptr,parent:Byte Ptr )
	Function LoadTexture_:Byte Ptr( file:Byte Ptr,flags:Int,tex:Byte Ptr )
	Function LoadSprite_:Byte Ptr( tex_file:Byte Ptr,tex_flag:Int,parent:Byte Ptr )
	Function MeshDepth_:Float( mesh:Byte Ptr )
	Function MeshHeight_:Float( mesh:Byte Ptr )
	Function MeshWidth_:Float( mesh:Byte Ptr )
	Function MoveEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float )
	Function NameEntity_( ent:Byte Ptr,name:Byte Ptr )
	Function PaintEntity_( ent:Byte Ptr,brush:Byte Ptr )
	Function PaintMesh_( mesh:Byte Ptr,brush:Byte Ptr )
	Function PaintSurface_( surf:Byte Ptr,brush:Byte Ptr )
	Function PickedEntity_:Byte Ptr()
	Function PickedNX_:Float()
	Function PickedNY_:Float()
	Function PickedNZ_:Float()
	Function PickedSurface_:Byte Ptr()
	Function PickedTime_:Float()
	Function PickedTriangle_:Int()
	Function PickedX_:Float()
	Function PickedY_:Float()
	Function PickedZ_:Float()
	Function PointEntity_( ent:Byte Ptr,target_ent:Byte Ptr,roll:Float )
	Function PositionEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )
	Function PositionMesh_( mesh:Byte Ptr,px:Float,py:Float,pz:Float )
	Function PositionTexture_( tex:Byte Ptr,u_pos:Float,v_pos:Float )
	Function ProjectedX_:Float()
	Function ProjectedY_:Float()
	Function ProjectedZ_:Float()
	Function RenderWorld_()
	Function ResetEntity_( ent:Byte Ptr )
	Function RotateEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )
	Function RotateMesh_( mesh:Byte Ptr,pitch:Float,yaw:Float,roll:Float )
	Function RotateSprite_( sprite:Byte Ptr,ang:Float )
	Function RotateTexture_( tex:Byte Ptr,ang:Float )
	Function ScaleEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )
	Function ScaleMesh_( mesh:Byte Ptr,sx:Float,sy:Float,sz:Float )
	Function ScaleSprite_( sprite:Byte Ptr,s_x:Float,s_y:Float )
	Function ScaleTexture_( tex:Byte Ptr,u_scale:Float,v_scale:Float )
	Function SetAnimTime_( ent:Byte Ptr,time:Float,seq:Int )
	Function SetCubeFace_( tex:Byte Ptr,face:Int )
	Function SetCubeMode_( tex:Byte Ptr,Mode:Int )
	Function ShowEntity_( ent:Byte Ptr )
	Function SpriteViewMode_( sprite:Byte Ptr,Mode:Int )
	Function TextureBlend_( tex:Byte Ptr,blend:Int )
	Function TextureCoords_( tex:Byte Ptr,coords:Int )
	Function TextureHeight_:Int( tex:Byte Ptr )
	Function TextureFilter_( match_text:Byte Ptr,flags:Int )
	Function TextureName_:Byte Ptr( tex:Byte Ptr )
	Function TextureWidth_:Int( tex:Byte Ptr )
	Function TFormedX_:Float()
	Function TFormedY_:Float()
	Function TFormedZ_:Float()
	Function TFormNormal_( x:Float,y:Float,z:Float,src_ent:Byte Ptr,dest_ent:Byte Ptr )
	Function TFormPoint_( x:Float,y:Float,z:Float,src_ent:Byte Ptr,dest_ent:Byte Ptr )
	Function TFormVector_( x:Float,y:Float,z:Float,src_ent:Byte Ptr,dest_ent:Byte Ptr )
	Function TranslateEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )
	Function TriangleVertex_:Int( surf:Byte Ptr,tri_no:Int,corner:Int )
	Function TurnEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )
	Function UpdateNormals_( mesh:Byte Ptr )
	Function UpdateWorld_( anim_speed:Float )
	Function VectorPitch_:Float( vx:Float,vy:Float,vz:Float )
	Function VectorYaw_:Float( vx:Float,vy:Float,vz:Float )
	Function VertexAlpha_:Float( surf:Byte Ptr,vid:Int )
	Function VertexBlue_:Float( surf:Byte Ptr,vid:Int )
	Function VertexColor_( surf:Byte Ptr,vid:Int,r:Float,g:Float,b:Float,a:Float )
	Function VertexCoords_( surf:Byte Ptr,vid:Int,x:Float,y:Float,z:Float )
	Function VertexGreen_:Float( surf:Byte Ptr,vid:Int )
	Function VertexNormal_( surf:Byte Ptr,vid:Int,nx:Float,ny:Float,nz:Float )
	Function VertexNX_:Float( surf:Byte Ptr,vid:Int )
	Function VertexNY_:Float( surf:Byte Ptr,vid:Int )
	Function VertexNZ_:Float( surf:Byte Ptr,vid:Int )
	Function VertexRed_:Float( surf:Byte Ptr,vid:Int )
	Function VertexTexCoords_( surf:Byte Ptr,vid:Int,u:Float,v:Float,w:Float,coord_set:Int )
	Function VertexU_:Float( surf:Byte Ptr,vid:Int,coord_set:Int )
	Function VertexV_:Float( surf:Byte Ptr,vid:Int,coord_set:Int )
	Function VertexW_:Float( surf:Byte Ptr,vid:Int,coord_set:Int )
	Function VertexX_:Float( surf:Byte Ptr,vid:Int )
	Function VertexY_:Float( surf:Byte Ptr,vid:Int )
	Function VertexZ_:Float( surf:Byte Ptr,vid:Int )
	Function Wireframe_( enable:Int )
	
	' *** Blitz3D functions, A-Z (in Openb3d)
	Function AddAnimSeq_:Int( ent:Byte Ptr,length:Int )
	'AlignToVector_ is in openb3dlib.mod
	Function CreatePlane_:Byte Ptr( divisions:Int,parent:Byte Ptr )
	Function CreateTerrain_:Byte Ptr( size:Int,parent:Byte Ptr )
	Function LoadAnimSeq_:Int( ent:Byte Ptr,file:Byte Ptr )
	Function LoadTerrain_:Byte Ptr( file:Byte Ptr,parent:Byte Ptr )
	Function MeshesIntersect_:Int( mesh1:Byte Ptr,mesh2:Byte Ptr )
	Function ModifyTerrain_( terr:Byte Ptr,x:Int,z:Int,new_height:Float )
	Function SetAnimKey_( ent:Byte Ptr,frame:Float,pos_key:Int,rot_key:Int,scale_key:Int )
	Function TerrainHeight_:Float( terr:Byte Ptr,x:Int,z:Int )
	Function TerrainX_:Float( terr:Byte Ptr,x:Float,y:Float,z:Float )
	Function TerrainY_:Float( terr:Byte Ptr,x:Float,y:Float,z:Float )
	Function TerrainZ_:Float( terr:Byte Ptr,x:Float,y:Float,z:Float )
	
	' *** Openb3d only
	Function BufferToTex_( tex:Byte Ptr,buffer:Byte Ptr,frame:Int )
	Function CameraToTex_( tex:Byte Ptr,cam:Byte Ptr,frame:Int )
	Function CreateBone_:Byte Ptr( mesh:Byte Ptr,parent_ent:Byte Ptr )
	Function CreateQuad_:Byte Ptr( parent:Byte Ptr )
	Function DepthBufferToTex_( tex:Byte Ptr,cam:Byte Ptr )
	Function MeshCSG_:Byte Ptr( m1:Byte Ptr,m2:Byte Ptr,method_no:Int )
	Function RepeatMesh_:Byte Ptr( mesh:Byte Ptr,parent:Byte Ptr )
	Function SkinMesh_( mesh:Byte Ptr,surf_no_get:Int,vid:Int,bone1:Int,weight1:Float,bone2:Int,weight2:Float,bone3:Int,weight3:Float,bone4:Int,weight4:Float )
	Function SpriteRenderMode_( sprite:Byte Ptr,Mode:Int )
	Function TexToBuffer_( tex:Byte Ptr,buffer:Byte Ptr,frame:Int )
	Function UpdateTexCoords_( surf:Byte Ptr )
	Function CameraProjMatrix_:Float Ptr( cam:Byte Ptr )
	Function EntityMatrix_:Float Ptr( ent:Byte Ptr )
	
	' *** Action
	Function ActMoveBy_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )
	Function ActTurnBy_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )
	Function ActVector_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float )
	Function ActMoveTo_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )
	Function ActTurnTo_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )
	Function ActScaleTo_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )
	Function ActFadeTo_:Byte Ptr( ent:Byte Ptr,a:Float,rate:Float )
	Function ActTintTo_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )
	Function ActTrackByPoint_:Byte Ptr( ent:Byte Ptr,target:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )
	Function ActTrackByDistance_:Byte Ptr( ent:Byte Ptr,target:Byte Ptr,a:Float,rate:Float )
	Function ActNewtonian_:Byte Ptr( ent:Byte Ptr,rate:Float )
	Function AppendAction_( act1:Byte Ptr,act2:Byte Ptr )
	Function FreeAction_( act:Byte Ptr )
	Function EndAction_( act:Byte Ptr )
	
	' *** Constraint
	Function CreateConstraint_:Byte Ptr( p1:Byte Ptr,p2:Byte Ptr,l:Float )
	Function CreateRigidBody_:Byte Ptr( body:Byte Ptr,p1:Byte Ptr,p2:Byte Ptr,p3:Byte Ptr,p4:Byte Ptr )
	
	' *** Fluid
	Function CreateBlob_:Byte Ptr( fluid:Byte Ptr,radius:Float,parent_ent:Byte Ptr )
	Function CreateFluid_:Byte Ptr()
	Function FluidArray_( fluid:Byte Ptr,Array:Float Ptr,w:Int,h:Int,d:Int)
	Function FluidFunction_( fluid:Byte Ptr,FieldFunction:Float( x:Float,y:Float,z:Float ) )
	Function FluidThreshold_( fluid:Byte Ptr,threshold:Float )
	
	' *** Geosphere
	Function CreateGeosphere_:Byte Ptr( size:Int,parent:Byte Ptr )
	Function GeosphereHeight_( geo:Byte Ptr,h:Float )
	Function LoadGeosphere_:Byte Ptr( file:Byte Ptr,parent:Byte Ptr )
	Function ModifyGeosphere_( geo:Byte Ptr,x:Int,z:Int,new_height:Float )
	
	' *** Octree
	Function CreateOcTree_:Byte Ptr( w:Float,h:Float,d:Float,parent_ent:Byte Ptr )
	Function OctreeBlock_( octree:Byte Ptr,mesh:Byte Ptr,level:Int,X:Float,Y:Float,Z:Float,Near:Float,Far:Float )
	Function OctreeMesh_( octree:Byte Ptr,mesh:Byte Ptr,level:Int,X:Float,Y:Float,Z:Float,Near:Float,Far:Float )
	
	' *** Particle
	Function CreateParticleEmitter_:Byte Ptr( particle:Byte Ptr,parent_ent:Byte Ptr )
	Function EmitterVector_( emit:Byte Ptr,startx:Float,starty:Float,startz:Float,endx:Float,endy:Float,endz:Float )
	Function EmitterRate_( emit:Byte Ptr,r:Float )
	Function EmitterParticleLife_( emit:Byte Ptr,startl:Int,endl:Int,randl:Int )
	Function EmitterParticleFunction_( emit:Byte Ptr,EmitterFunction( ent:Byte Ptr,life:Int ) )
	Function EmitterParticleSpeed_( emit:Byte Ptr,starts:Float,ends:Float )
	Function EmitterVariance_( emit:Byte Ptr,v:Float )
	Function EmitterParticleAlpha_( emit:Byte Ptr,starta:Float,enda:Float,mida:Float,midlife:Int )
	Function EmitterParticleScale_( emit:Byte Ptr,startsx:Float,startsy:Float,endsx:Float,endsy:Float,midsx:Float,midsy:Float,midlife:Int )
	Function EmitterParticleColor_( emit:Byte Ptr,startr:Float,startg:Float,startb:Float,endr:Float,endg:Float,endb:Float,midr:Float,midg:Float,midb:Float,midlife:Int )
	Function EmitterParticleRotate_( emit:Byte Ptr,startr:Float,endr:Float,midr:Float,midlife:Int )
	Function ParticleColor_( sprite:Byte Ptr,r:Float,g:Float,b:Float,a:Float )
	Function ParticleVector_( sprite:Byte Ptr,x:Float,y:Float,z:Float )
	Function ParticleTrail_( sprite:Byte Ptr,length:Int )
	
	' *** PostFX
	Function CreatePostFX_:Byte Ptr( cam:Byte Ptr,passes:Int )
	Function AddRenderTarget_( fx:Byte Ptr,pass_no:Int,numColBufs:Int,depth:Int,format:Int,scale:Float )
	Function PostFXShader_( fx:Byte Ptr,pass_no:Int,shader:Byte Ptr )
	Function PostFXShaderPass_( fx:Byte Ptr,pass_no:Int,name:Byte Ptr,v:Int )
	Function PostFXBuffer_( fx:Byte Ptr,pass_no:Int,source_pass:Int,index:Int,slot:Int )
	Function PostFXTexture_( fx:Byte Ptr,pass_no:Int,tex:Byte Ptr,slot:Int,frame:Int )
	Function PostFXFunction_( fx:Byte Ptr,pass_no:Int,PassFunction() )
	
	' *** Shader
	Function LoadShader_:Byte Ptr( ShaderName:Byte Ptr,VshaderFileName:Byte Ptr,FshaderFileName:Byte Ptr )
	Function CreateShader_:Byte Ptr( ShaderName:Byte Ptr,VshaderString:Byte Ptr,FshaderString:Byte Ptr )
	Function LoadShaderVGF_:Byte Ptr( ShaderName:Byte Ptr,VshaderFileName:Byte Ptr,GshaderFileName:Byte Ptr,FshaderFileName:Byte Ptr )
	Function CreateShaderVGF_:Byte Ptr( ShaderName:Byte Ptr,VshaderString:Byte Ptr,GshaderString:Byte Ptr,FshaderString:Byte Ptr )
	Function ShadeSurface_( surf:Byte Ptr,material:Byte Ptr )
	Function ShadeMesh_( mesh:Byte Ptr,material:Byte Ptr )
	Function ShadeEntity_( ent:Byte Ptr,material:Byte Ptr )
	Function ShaderTexture_:Byte Ptr( material:Byte Ptr,tex:Byte Ptr,name:Byte Ptr,index:Int )
	Function SetFloat_( material:Byte Ptr,name:Byte Ptr,v1:Float )
	Function SetFloat2_( material:Byte Ptr,name:Byte Ptr,v1:Float,v2:Float )
	Function SetFloat3_( material:Byte Ptr,name:Byte Ptr,v1:Float,v2:Float,v3:Float )
	Function SetFloat4_( material:Byte Ptr,name:Byte Ptr,v1:Float,v2:Float,v3:Float,v4:Float )
	Function UseFloat_( material:Byte Ptr,name:Byte Ptr,v1:Float Ptr )
	Function UseFloat2_( material:Byte Ptr,name:Byte Ptr,v1:Float Ptr,v2:Float Ptr )
	Function UseFloat3_( material:Byte Ptr,name:Byte Ptr,v1:Float Ptr,v2:Float Ptr,v3:Float Ptr )
	Function UseFloat4_( material:Byte Ptr,name:Byte Ptr,v1:Float Ptr,v2:Float Ptr,v3:Float Ptr,v4:Float Ptr )
	Function SetInteger_( material:Byte Ptr,name:Byte Ptr,v1:Int )
	Function SetInteger2_( material:Byte Ptr,name:Byte Ptr,v1:Int,v2:Int )
	Function SetInteger3_( material:Byte Ptr,name:Byte Ptr,v1:Int,v2:Int,v3:Int )
	Function SetInteger4_( material:Byte Ptr,name:Byte Ptr,v1:Int,v2:Int,v3:Int,v4:Int )
	Function UseInteger_( material:Byte Ptr,name:Byte Ptr,v1:Int Ptr )
	Function UseInteger2_( material:Byte Ptr,name:Byte Ptr,v1:Int Ptr,v2:Int Ptr )
	Function UseInteger3_( material:Byte Ptr,name:Byte Ptr,v1:Int Ptr,v2:Int Ptr,v3:Int Ptr )
	Function UseInteger4_( material:Byte Ptr,name:Byte Ptr,v1:Int Ptr,v2:Int Ptr,v3:Int Ptr,v4:Int Ptr )
	Function UseSurface_( material:Byte Ptr,name:Byte Ptr,surf:Byte Ptr,vbo:Int )
	Function UseMatrix_( material:Byte Ptr,name:Byte Ptr,Mode:Int )
	Function LoadMaterial_:Byte Ptr( filename:Byte Ptr,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int )
	Function ShaderMaterial_( material:Byte Ptr,tex:Byte Ptr,name:Byte Ptr,index:Int )
	Function AmbientShader_( material:Byte Ptr )
	Function UseEntity_( material:Byte Ptr,name:Byte Ptr,ent:Byte Ptr,mode:Int )
	Function ShaderFunction_( material:Byte Ptr,EnableFunction(),DisableFunction() )
	Function GetShaderProgram_:Int( material:Byte Ptr )
	
	' *** Shadow
	Function CreateShadow_:Byte Ptr( parent:Byte Ptr,Static:Int )
	Function FreeShadow_( shad:Byte Ptr )
	
	' *** Stencil
	Function CreateStencil_:Byte Ptr()
	Function StencilAlpha_( stencil:Byte Ptr,a:Float )
	Function StencilClsColor_( stencil:Byte Ptr,r:Float,g:Float,b:Float )
	Function StencilClsMode_( stencil:Byte Ptr,cls_color:Int,cls_zbuffer:Int )
	Function StencilMesh_( stencil:Byte Ptr,mesh:Byte Ptr,Mode:Int )
	Function StencilMode_( stencil:Byte Ptr,m:Int,o:Int )
	Function UseStencil_( stencil:Byte Ptr )
	
	' *** VoxelSprite
	Function CreateVoxelSprite_:Byte Ptr( slices:Int,parent:Byte Ptr )
	Function VoxelSpriteMaterial_( voxelspr:Byte Ptr,mat:Byte Ptr )
	
End Extern

' methods.cpp
Extern

	' Animation
	Function AnimateMesh_( ent1:Byte Ptr,framef:Float,start_frame:Int,end_frame:Int )
	Function AnimateMesh2_( ent1:Byte Ptr,framef:Float,start_frame:Int,end_frame:Int )
	Function AnimateMesh3_( ent1:Byte Ptr )
	Function VertexDeform_( ent:Byte Ptr )
	
	' AnimationKeys
	Function AnimationKeysCopy_:Byte Ptr( obj:Byte Ptr )
	
	' Brush
	Function BrushCopy_:Byte Ptr( obj:Byte Ptr )
	Function CompareBrushes_:Int( brush1:Byte Ptr,brush2:Byte Ptr )
	
	' Camera
	Function ExtractFrustum_( obj:Byte Ptr )
	Function EntityInFrustum_:Float( obj:Byte Ptr,ent:Byte Ptr )
	Function CameraUpdate_( obj:Byte Ptr )
	Function CameraRender_( obj:Byte Ptr )
	Function UpdateSprite_( obj:Byte Ptr,sprite:Byte Ptr )
	Function AddTransformedSpriteToSurface_( obj:Byte Ptr,sprite:Byte Ptr,surf:Byte Ptr )
	Function RenderListAdd_( obj:Byte Ptr,mesh:Byte Ptr )
	Function accPerspective_( obj:Byte Ptr,fovy:Float,aspect:Float,zNear:Float,zFar:Float,pixdx:Float,pixdy:Float,eyedx:Float,eyedy:Float,focus:Float )
	Function accFrustum_( obj:Byte Ptr,left_:Float,right_:Float,bottom:Float,top:Float,zNear:Float,zFar:Float,pixdx:Float,pixdy:Float,eyedx:Float,eyedy:Float,focus:Float )
	Function UpdateProjMatrix_( obj:Byte Ptr )
	Function CameraUpdateEntityRender_( ent:Byte Ptr,cam:Byte Ptr )
	
	' Collision
	Function FreeCollisionPivots_()
	
	' Collision2
	Function ManualCollision_( ent:Byte Ptr,ent2:Byte Ptr,col_method:Int,col_response:Int ) ' KippyKip
	
	' Global
	Function UpdateEntityAnim_( mesh:Byte Ptr )
	
	' Light
	Function LightUpdate_( obj:Byte Ptr )
	
	' Entity
	Function CountAllChildren_:Int( obj:Byte Ptr,no_children:Int )
	Function GetChildFromAll_:Byte Ptr( obj:Byte Ptr,child_no:Int,no_children:Int Ptr,ent:Byte Ptr )
	Function Hidden_:Int( obj:Byte Ptr )
	Function AlignToVector_( obj:Byte Ptr,x:Float,y:Float,z:Float,axis:Int,rate:Float )
	Function UpdateMat_( obj:Byte Ptr,load_identity:Byte )
	Function AddParent_( obj:Byte Ptr,parent_ent:Byte Ptr )
	Function UpdateChildren_( ent_p:Byte Ptr )
	Function EntityDistanceSquared_:Float( obj:Byte Ptr,ent2:Byte Ptr )
	Function MQ_Update_( obj:Byte Ptr )
	Function MQ_GetInvMatrix_( obj:Byte Ptr,mat0:Byte Ptr )
	Function MQ_GetMatrix_( obj:Byte Ptr,mat3:Byte Ptr )
	Function MQ_GetScaleXYZ_( obj:Byte Ptr,width:Float Ptr,height:Float Ptr,depth:Float Ptr )
	Function MQ_Turn_( obj:Byte Ptr,ang:Float,vx:Float,vy:Float,vz:Float,glob:Int )
	Function MQ_ApplyNewtonTransform_:Int( obj:Byte Ptr,newtonMatrix:Byte Ptr )
	
	' Matrix
	Function MatrixLoadIdentity_( obj:Byte Ptr )
	Function MatrixCopy_:Byte Ptr( obj:Byte Ptr )
	Function MatrixOverwrite_( obj:Byte Ptr,mat:Byte Ptr )
	Function MatrixGetInverse_( obj:Byte Ptr,mat:Byte Ptr )
	Function MatrixMultiply_( obj:Byte Ptr,mat:Byte Ptr )
	Function MatrixTranslate_( obj:Byte Ptr,x:Float,y:Float,z:Float )
	Function MatrixScale_( obj:Byte Ptr,x:Float,y:Float,z:Float )
	Function MatrixRotate_( obj:Byte Ptr,rx:Float,ry:Float,rz:Float )
	Function MatrixRotatePitch_( obj:Byte Ptr,ang:Float )
	Function MatrixRotateYaw_( obj:Byte Ptr,ang:Float )
	Function MatrixRotateRoll_( obj:Byte Ptr,ang:Float )
	Function MatrixFromQuaternion_( obj:Byte Ptr,x:Float,y:Float,z:Float,w:Float )
	Function MatrixTransformVec_( obj:Byte Ptr,rx:Float Ptr,ry:Float Ptr,rz:Float Ptr,addTranslation:Int )
	Function MatrixTranspose_( obj:Byte Ptr )
	Function MatrixSetTranslate_( obj:Byte Ptr,x:Float,y:Float,z:Float )
	Function MatrixMultiply2_( obj:Byte Ptr,mat:Byte Ptr )
	Function MatrixGetInverse2_( obj:Byte Ptr,mat:Byte Ptr )
	Function MatrixGetPitch_:Float( obj:Byte Ptr )
	Function MatrixGetYaw_:Float( obj:Byte Ptr )
	Function MatrixGetRoll_:Float( obj:Byte Ptr )
	Function MatrixFromToRotation_( obj:Byte Ptr,ix:Float,iy:Float,iz:Float,jx:Float,jy:Float,jz:Float )
	Function MatrixToQuat_( obj:Byte Ptr,qx:Float Ptr,qy:Float Ptr,qz:Float Ptr,qw:Float Ptr )
	Function MatrixQuaternion_FromAngleAxis_( angle:Float,ax:Float,ay:Float,az:Float,rx:Float Ptr,ry:Float Ptr,rz:Float Ptr,rw:Float Ptr )
	Function MatrixQuaternion_MultiplyQuat_( x1:Float,y1:Float,z1:Float,w1:Float,x2:Float,y2:Float,z2:Float,w2:Float,rx:Float Ptr,ry:Float Ptr,rz:Float Ptr,rw:Float Ptr )
	Function MatrixInterpolateMatrix_( m:Byte Ptr,a:Byte Ptr,alpha:Float )
	
	' Mesh
	Function MeshColor_( obj:Byte Ptr,r:Float,g:Float,b:Float,a:Float )
	Function MeshRed_( obj:Byte Ptr,r:Float )
	Function MeshGreen_( obj:Byte Ptr,g:Float )
	Function MeshBlue_( obj:Byte Ptr,b:Float )
	Function MeshAlpha_( obj:Byte Ptr,a:Float )
	Function CopyBonesList_( ent:Byte Ptr,bones:Byte Ptr )
	Function CollapseAnimMesh_:Byte Ptr( obj:Byte Ptr,mesh:Byte Ptr )
	Function CollapseChildren_:Byte Ptr( obj:Byte Ptr,ent0:Byte Ptr,mesh:Byte Ptr )
	Function TransformMesh_( obj:Byte Ptr,mat:Byte Ptr )
	Function GetBounds_( obj:Byte Ptr )
	Function Alpha_:Int( obj:Byte Ptr )
	Function TreeCheck_( obj:Byte Ptr )
	Function MeshRender_( obj:Byte Ptr )
	Function UpdateShadow_( obj:Byte Ptr )
	
	' Model
	Function ModelTrimVerts_( obj:Byte Ptr )
	
	' Pick
	Function PickMain_:Byte Ptr( ax:Float,ay:Float,az:Float,bx:Float,by:Float,bz:Float,radius:Float )
	
	' Quaternion
	Function QuaternionToMat_( w:Float,x:Float,y:Float,z:Float,mat:Byte Ptr )
	Function QuaternionToEuler_( w:Float,x:Float,y:Float,z:Float,pitch:Float Ptr,yaw:Float Ptr,roll:Float Ptr )
	Function QuaternionSlerp_( Ax:Float,Ay:Float,Az:Float,Aw:Float,Bx:Float,By:Float,Bz:Float,Bw:Float,Cx:Float Ptr,Cy:Float Ptr,Cz:Float Ptr,Cw:Float Ptr,t:Float )
	
	' ShadowObject
	Function SetShadowColor_( R:Int,G:Int,B:Int,A:Int )
	Function ShadowInit_()
	Function RemoveShadowfromMesh_( obj:Byte Ptr,M:Byte Ptr )
	Function ShadowObjectUpdate_( Cam:Byte Ptr )
	Function RenderVolume_()
	Function UpdateAnim_( obj:Byte Ptr )
	Function ShadowObjectInit_( obj:Byte Ptr )
	Function InitShadow_( obj:Byte Ptr )
	Function UpdateCaster_( obj:Byte Ptr )
	Function ShadowRenderWorldZFail_()
	
	' Sprite
	Function SpriteTexCoords_( obj:Byte Ptr,cell_x:Int,cell_y:Int,cell_w:Int,cell_h:Int,tex_w:Int,tex_h:Int,uv_set:Int )
	Function SpriteVertexColor_( obj:Byte Ptr,v:Int,r:Float,g:Float,b:Float )
	
	' Surface
	Function SurfaceCopy_:Byte Ptr( obj:Byte Ptr )
	Function SurfaceColor_( obj:Byte Ptr,r:Float,g:Float,b:Float,a:Float )
	Function SurfaceRed_( obj:Byte Ptr,r:Float )
	Function SurfaceGreen_( obj:Byte Ptr,g:Float )
	Function SurfaceBlue_( obj:Byte Ptr,b:Float )
	Function SurfaceAlpha_( obj:Byte Ptr,a:Float )
	Function SurfaceUpdateNormals_( obj:Byte Ptr )
	Function TriangleNX_:Float( obj:Byte Ptr,tri_no:Int )
	Function TriangleNY_:Float( obj:Byte Ptr,tri_no:Int )
	Function TriangleNZ_:Float( obj:Byte Ptr,tri_no:Int )
	Function UpdateVBO_( obj:Byte Ptr )
	Function FreeVBO_( obj:Byte Ptr )
	Function RemoveTri_( obj:Byte Ptr,tri:Int )
	
	' Terrain
	Function UpdateTerrain_( obj:Byte Ptr )
	Function TerrainUpdateNormals_( obj:Byte Ptr )
	'Function RecreateROAM_( obj:Byte Ptr )
	'Function drawsub_( obj:Byte Ptr,l:Int,v0:Float Ptr,v1:Float Ptr,v2:Float Ptr )
	'Function col_tree_sub_( obj:Byte Ptr,l:Int,v0:Float Ptr,v1:Float Ptr,v2:Float Ptr )
	
	' Texture
	Function TextureCopy_:Byte Ptr( obj:Byte Ptr,copyflags:Int )
	Function TexInList_:Byte Ptr( obj:Byte Ptr,list_ref:Byte Ptr )
	Function FilterFlags_( obj:Byte Ptr )
	Function CopyRect_( src:Byte Ptr,srcW:Int,srcH:Int,srcX:Int,srcY:Int,dst:Byte Ptr,dstW:Int,dstH:Int,bPP:Int,invert:Int )
	
End Extern

' data.cpp
Extern

	' Static
	Function StaticChar_:Byte Ptr( classid:Int,varid:Int )
	Function StaticInt_:Int Ptr( classid:Int,varid:Int )
	Function StaticFloat_:Float Ptr( classid:Int,varid:Int )
	Function StaticEntity_:Byte Ptr( classid:Int,varid:Int )
	Function StaticCamera_:Byte Ptr( classid:Int,varid:Int )
	Function StaticPivot_:Byte Ptr( classid:Int,varid:Int )
	Function StaticShader_:Byte Ptr( classid:Int,varid:Int )
	Function StaticSurface_:Byte Ptr( classid:Int,varid:Int )
	Function StaticListSize_:Int( classid:Int,varid:Int )
	Function StaticIterListAction_:Byte Ptr( classid:Int,varid:Int,id:Int Ptr )
	Function StaticIterListBrush_:Byte Ptr( classid:Int,varid:Int,id:Int Ptr )
	Function StaticIterListCamera_:Byte Ptr( classid:Int,varid:Int,id:Int Ptr )
	Function StaticIterListEntity_:Byte Ptr( classid:Int,varid:Int,id:Int Ptr )
	Function StaticIterListShadowObject_:Byte Ptr( classid:Int,varid:Int,id:Int Ptr )
	Function StaticIterListTerrain_:Byte Ptr( classid:Int,varid:Int,id:Int Ptr )
	Function StaticIterListTexture_:Byte Ptr( classid:Int,varid:Int,id:Int Ptr )
	'Function StaticIterVectorFloat_:Float( classid:Int,varid:Int,id:Int Ptr )
	Function StaticIterVectorLight_:Byte Ptr( classid:Int,varid:Int,id:Int Ptr )

	' Action
	Function ActionInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function ActionFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	Function ActionEntity_:Byte Ptr( obj:Byte Ptr,varid:Int )
	
	' AnimationKeys
	Function AnimationKeysInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function AnimationKeysFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	Function NewAnimationKeys_:Byte Ptr( obj:Byte Ptr )
	
	' Bone
	Function BoneFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	Function BoneAnimationKeys_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function BoneMatrix_:Byte Ptr( obj:Byte Ptr,varid:Int )
	
	' Brush
	Function BrushInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function BrushUInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function BrushFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	Function BrushString_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function BrushTextureArray_:Byte Ptr( obj:Byte Ptr,varid:Int,index:Int )
	Function SetBrushString_( obj:Byte Ptr,varid:Int,cstr:Byte Ptr )
	
	' Camera
	Function CameraBool_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function CameraInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function CameraFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	Function GlobalListPushBackCamera_( varid:Int,obj:Byte Ptr )
	Function GlobalListRemoveCamera_( varid:Int,obj:Byte Ptr )
	
	' Entity
	Function EntityInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function EntityFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	Function EntityString_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function EntityEntity_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function EntityBrush_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function EntityMatrix2_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function EntityListSize_:Int( obj:Byte Ptr,varid:Int )
	Function EntityIterListEntity_:Byte Ptr( obj:Byte Ptr,varid:Int,id:Int Ptr )
	Function EntityListPushBackEntity_( obj:Byte Ptr,varid:Int,ent:Byte Ptr )
	Function EntityListRemoveEntity_( obj:Byte Ptr,varid:Int,ent:Byte Ptr )
	Function GlobalListPushBackEntity_( varid:Int,obj:Byte Ptr )
	Function GlobalListRemoveEntity_( varid:Int,obj:Byte Ptr )
	Function SetEntityString_( obj:Byte Ptr,varid:Int,cstr:Byte Ptr )
	
	' Light
	Function LightChar_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function LightFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	
	' MatPtr
	Function MatPtrFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	Function NewMatPtr_:Byte Ptr()
	
	' Mesh
	Function MeshInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function MeshFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	Function MeshMatrix_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function MeshListSize_:Int( obj:Byte Ptr,varid:Int )
	Function MeshIterListSurface_:Byte Ptr( obj:Byte Ptr,varid:Int,id:Int Ptr )
	Function MeshIterVectorBone_:Byte Ptr( obj:Byte Ptr,varid:Int,id:Int Ptr )
	Function MeshVectorBone_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function MeshListPushBackSurface_( obj:Byte Ptr,varid:Int,surf:Byte Ptr )
	Function MeshListRemoveSurface_( obj:Byte Ptr,varid:Int,surf:Byte Ptr )
	Function MeshListPushBackBone_( obj:Byte Ptr,varid:Int,bone:Byte Ptr )
	Function MeshListRemoveBone_( obj:Byte Ptr,varid:Int,bone:Byte Ptr )
	
	' Model
	Function SurfaceCopyFloatArray_:Float Ptr( obj:Byte Ptr,varid:Int,surf:Byte Ptr )
	Function SurfaceResizeFloatArray_:Float Ptr( obj:Byte Ptr,varid:Int,size:Int )
	Function SurfaceResizeIntArray_:Int Ptr( obj:Byte Ptr,varid:Int,size:Int )
	Function AnimationKeysResizeFloatArray_:Float Ptr( obj:Byte Ptr,varid:Int,size:Int )
	Function AnimationKeysResizeIntArray_:Int Ptr( obj:Byte Ptr,varid:Int,size:Int )
	Function MeshResizeBoneVector_:Byte Ptr( obj:Byte Ptr,varid:Int,size:Int )
	Function MeshSetBoneVector_( obj:Byte Ptr,varid:Int,pos:Int,bone:Byte Ptr )
	
	' MD2
	Function SurfaceVectorPushBackFloat_( obj:Byte Ptr,varid:Int,value:Float )
	
	' QuatPtr
	Function QuatPtrFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	Function NewQuatPtr_:Byte Ptr()
	
	' ShadowObject
	Function ShadowObjectChar_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function ShadowObjectInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function ShadowObjectMesh_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function ShadowObjectSurface_:Byte Ptr( obj:Byte Ptr,varid:Int )
	
	' Sprite
	Function SpriteInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function SpriteFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	
	' Surface
	Function SurfaceUShort_:Short Ptr( obj:Byte Ptr,varid:Int )
	Function SurfaceInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function SurfaceUInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function SurfaceFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	Function SurfaceBrush_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function SurfaceShader_:Byte Ptr( obj:Byte Ptr,varid:Int )
	
	' Terrain
	Function TerrainInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function TerrainFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	Function TerrainCamera_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function TerrainShader_:Byte Ptr( obj:Byte Ptr,varid:Int )
	
	' Texture
	Function TextureInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function TextureUInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function TextureNewUIntArray_:Int Ptr( obj:Byte Ptr,varid:Int,array_size:Int )
	Function TextureFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	Function TextureString_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function TextureListTexture_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function GlobalListPushBackTexture_( varid:Int,obj:Byte Ptr )
	Function GlobalListRemoveTexture_( varid:Int,obj:Byte Ptr )
	Function SetTextureString_( obj:Byte Ptr,varid:Int,cstr:Byte Ptr )
	
	' VecPtr
	Function VecPtrFloat_:Float Ptr( obj:Byte Ptr,varid:Int )
	Function NewVecPtr_:Byte Ptr()
	Function VecPtrCopy_:Byte Ptr( v:Byte Ptr )
	Function VecPtrNegate_:Byte Ptr( v:Byte Ptr )
	Function VecPtrAdd_:Byte Ptr( v:Byte Ptr,q:Byte Ptr )
	Function VecPtrSubtract_:Byte Ptr( v:Byte Ptr,q:Byte Ptr )
	Function VecPtrMultiply_:Byte Ptr( v:Byte Ptr,scale:Float )
	Function VecPtrMultiply2_:Byte Ptr( v:Byte Ptr,q:Byte Ptr )
	Function VecPtrDivide_:Byte Ptr( v:Byte Ptr,scale:Float )
	Function VecPtrDivide2_:Byte Ptr( v:Byte Ptr,q:Byte Ptr )
	Function VecPtrDot_:Float( v:Byte Ptr,q:Byte Ptr )
	Function VecPtrCross_:Byte Ptr( v:Byte Ptr,q:Byte Ptr )
	Function VecPtrLength_:Float( v:Byte Ptr )
	Function VecPtrDistance_:Float( v:Byte Ptr,q:Byte Ptr )
	Function VecPtrNormalized_:Byte Ptr( v:Byte Ptr )
	Function VecPtrNormalize_( v:Byte Ptr )
	Function VecPtrClear_( v:Byte Ptr )
	
End Extern

' Classid - used with static data fields
Const ACTION_class:Int=			1
Const ANIMATION_class:Int=		2
Const ANIMATIONKEYS_class:Int=	3
Const BONE_class:Int=			4
Const BRUSH_class:Int=			5
Const CAMERA_class:Int=			6
Const COLLISION_class:Int=		7 ' collision.h
Const COLLISIONINFO_class:Int=	8
Const COLLISIONPAIR_class:Int=	9 ' collision2.h
Const COLLISIONIMPACT_class:Int=10
Const CSGTRIANGLE_class:Int=	11 ' csg.h
Const ENTITY_class:Int=			12
Const VECTOR_class:Int=			13 ' geom.h
Const LINE_class:Int=			14
Const PLANE_class:Int=			15
Const QUAT_class:Int=			16
Const MMATRIX_class:Int=		17
Const BOX_class:Int=			18
Const TRANSFORM_class:Int=		19
Const GEOSPHERE_class:Int=		20
Const GLOBAL_class:Int=			21
Const FLUID_class:Int=			22 ' isosurface.h
Const BLOB_class:Int=			23
Const FIELDARRAY_class:Int=		24
Const LIGHT_class:Int=			25
Const MATERIALPLUGIN_class:Int=	26 ' material.h
Const MATPTR_class:Int=			27
Const MESH_class:Int=			28
Const OCTREE_class:Int=			29 ' octree.h
Const OCTREECHILD_class:Int=	30
Const PARTICLEBATCH_class:Int=	31 ' particle.h
Const PARTICLEEMITTER_class:Int=32
Const CONSTRAINT_class:Int=		33 ' physics.h
Const RIGIDBODY_class:Int=		34
Const PICK_class:Int=			35
Const PIVOT_class:Int=			36
Const QUATPTR_class:Int=		37
Const SHADERDATA_class:Int=		38 ' shadermat.h
Const SAMPLER_class:Int=		39
Const MATERIAL_class:Int=		40
Const SHADER_class:Int=			41
Const SHADEROBJECT_class:Int=	42 ' shaderobject.h
Const PROGRAMOBJECT_class:Int=	43
Const SHADOWTRIANGLE_class:Int=	44 ' shadow.h
Const EDGE_class:Int=			45
Const SHADOWOBJECT_class:Int=	46
Const SPRITE_class:Int=			47
Const SPRITEBATCH_class:Int=	48
Const STENCIL_class:Int=		49
Const SURFACE_class:Int=		50
Const TERRAIN_class:Int=		51
Const TEXTURE_class:Int=		52
Const TEXTUREFILTER_class:Int=	53
Const TILT_class:Int=			54
Const TOUCH_class:Int=			55
Const MESHCOLLIDER_class:Int=	56 ' tree.h
Const MESHINFO_class:Int=		57
Const VOXELSPRITE_class:Int=	58 ' voxel.h
'Const BATCHSPRITE_class:Int=	59

' Action varid
Const ACTION_action_list:Int=	1
Const ACTION_act:Int=			2
Const ACTION_ent:Int=			3
Const ACTION_target:Int=		4
Const ACTION_rate:Int=			5
Const ACTION_a:Int=				6
Const ACTION_b:Int=				7
Const ACTION_c:Int=				8
Const ACTION_nextActions:Int=	9
Const ACTION_delete_list:Int=	10
Const ACTION_endact:Int=		11
Const ACTION_lifetime:Int=		12

' AnimationKeys varid
Const ANIMATIONKEYS_frames:Int=	1
Const ANIMATIONKEYS_flags:Int=	2
Const ANIMATIONKEYS_px:Int=		3
Const ANIMATIONKEYS_py:Int=		4
Const ANIMATIONKEYS_pz:Int=		5
Const ANIMATIONKEYS_sx:Int=		6
Const ANIMATIONKEYS_sy:Int=		7
Const ANIMATIONKEYS_sz:Int=		8
Const ANIMATIONKEYS_qw:Int=		9
Const ANIMATIONKEYS_qx:Int=		10
Const ANIMATIONKEYS_qy:Int=		11
Const ANIMATIONKEYS_qz:Int=		12

' Bone varid
Const BONE_n_px:Int=		1
Const BONE_n_py:Int=		2
Const BONE_n_pz:Int=		3
Const BONE_n_sx:Int=		4
Const BONE_n_sy:Int=		5
Const BONE_n_sz:Int=		6
Const BONE_n_rx:Int=		7
Const BONE_n_ry:Int=		8
Const BONE_n_rz:Int=		9
Const BONE_n_qw:Int=		10
Const BONE_n_qx:Int=		11
Const BONE_n_qy:Int=		12
Const BONE_n_qz:Int=		13
Const BONE_keys:Int=		14
Const BONE_mat2:Int=		15
Const BONE_inv_mat:Int=		16
Const BONE_tform_mat:Int=	17
Const BONE_kx:Int=			18
Const BONE_ky:Int=			19
Const BONE_kz:Int=			20
Const BONE_kqw:Int=			21
Const BONE_kqx:Int=			22
Const BONE_kqy:Int=			23
Const BONE_kqz:Int=			24

' Brush varid
Const BRUSH_no_texs:Int=	1
Const BRUSH_name:Int=		2
Const BRUSH_red:Int=		3
Const BRUSH_green:Int=		4
Const BRUSH_blue:Int=		5
Const BRUSH_alpha:Int=		6
Const BRUSH_shine:Int=		7
Const BRUSH_blend:Int=		8
Const BRUSH_fx:Int=			9
Const BRUSH_cache_frame:Int=10
Const BRUSH_tex:Int=		11
Const BRUSH_brush_list:Int=	12

' Camera varid
Const CAMERA_cam_list:Int=			1
Const CAMERA_render_list:Int=		2
Const CAMERA_vx:Int=				3
Const CAMERA_vy:Int=				4
Const CAMERA_vwidth:Int=			5
Const CAMERA_vheight:Int=			6
Const CAMERA_cls_r:Int=				7
Const CAMERA_cls_g:Int=				8
Const CAMERA_cls_b:Int=				9
Const CAMERA_cls_color:Int=			10
Const CAMERA_cls_zbuffer:Int=		11
Const CAMERA_range_near:Int=		12
Const CAMERA_range_far:Int=			13
Const CAMERA_zoom:Int=				14
Const CAMERA_proj_mode:Int=			15
Const CAMERA_fog_mode:Int=			16
Const CAMERA_fog_r:Int=				17
Const CAMERA_fog_g:Int=				18
Const CAMERA_fog_b:Int=				19
Const CAMERA_fog_range_near:Int=	20
Const CAMERA_fog_range_far:Int=		21
Const CAMERA_project_enabled:Int=	22
Const CAMERA_mod_mat:Int=			23 ' array [16]
Const CAMERA_proj_mat:Int=			24 ' array [16]
Const CAMERA_viewport:Int=			25 ' array [4]
Const CAMERA_projected_x:Int=		26
Const CAMERA_projected_y:Int=		27
Const CAMERA_projected_z:Int=		28
Const CAMERA_frustum:Int=			29 ' array [6][4]

' CollisionPair varid
Const COLLISIONPAIR_cp_list:Int=	1
Const COLLISIONPAIR_ent_lists:Int=	2
Const COLLISIONPAIR_src_type:Int=	3
Const COLLISIONPAIR_des_type:Int=	4
Const COLLISIONPAIR_col_method:Int=	5
Const COLLISIONPAIR_response:Int=	6
Const COLLISIONPAIR_pivots_exist:Int=7
Const COLLISIONPAIR_piv1o:Int=		8
Const COLLISIONPAIR_piv1:Int=		9
Const COLLISIONPAIR_piv11:Int=		10
Const COLLISIONPAIR_piv111:Int=		11
Const COLLISIONPAIR_piv2o:Int=		12
Const COLLISIONPAIR_piv2:Int=		13

' CollisionImpact varid
Const COLLISIONIMPACT_x:Int=	1
Const COLLISIONIMPACT_y:Int=	2
Const COLLISIONIMPACT_z:Int=	3
Const COLLISIONIMPACT_nx:Int=	4
Const COLLISIONIMPACT_ny:Int=	5
Const COLLISIONIMPACT_nz:Int=	6
Const COLLISIONIMPACT_time:Int=	7
Const COLLISIONIMPACT_ent:Int=	8
Const COLLISIONIMPACT_surf:Int=	9
Const COLLISIONIMPACT_tri:Int=	10

' Entity varid
Const ENTITY_entity_list:Int=		1
Const ENTITY_child_list:Int=		2
Const ENTITY_parent:Int=			3
Const ENTITY_mat:Int=				4
Const ENTITY_rotmat:Int=			5
Const ENTITY_px:Int=				6
Const ENTITY_py:Int=				7
Const ENTITY_pz:Int=				8
Const ENTITY_sx:Int=				9
Const ENTITY_sy:Int=				10
Const ENTITY_sz:Int=				11
Const ENTITY_rx:Int=				12
Const ENTITY_ry:Int=				13
Const ENTITY_rz:Int=				14
Const ENTITY_qw:Int=				15
Const ENTITY_qx:Int=				16
Const ENTITY_qy:Int=				17
Const ENTITY_qz:Int=				18
Const ENTITY_brush:Int=				19
Const ENTITY_order:Int=				20
Const ENTITY_alpha_order:Int=		21
Const ENTITY_hide:Int=				22
Const ENTITY_cull_radius:Int=		23
Const ENTITY_name:Int=				24
Const ENTITY_class_name:Int=		25
Const ENTITY_animate_list:Int=		26
Const ENTITY_anim:Int=				27
Const ENTITY_anim_render:Int=		28
Const ENTITY_anim_mode:Int=			29
Const ENTITY_anim_time:Int=			30
Const ENTITY_anim_speed:Int=		31
Const ENTITY_anim_seq:Int=			32
Const ENTITY_anim_trans:Int=		33
Const ENTITY_anim_dir:Int=			34
Const ENTITY_anim_seqs_first:Int=	35
Const ENTITY_anim_seqs_last:Int=	36
Const ENTITY_no_seqs:Int=			37
Const ENTITY_anim_update:Int=		38
Const ENTITY_anim_list:Int=			39
Const ENTITY_collision_type:Int=	40
Const ENTITY_radius_x:Int=			41
Const ENTITY_radius_y:Int=			42
Const ENTITY_box_x:Int=				43
Const ENTITY_box_y:Int=				44
Const ENTITY_box_z:Int=				45
Const ENTITY_box_w:Int=				46
Const ENTITY_box_h:Int=				47
Const ENTITY_box_d:Int=				48
Const ENTITY_no_collisions:Int=		49
Const ENTITY_collision:Int=			50
Const ENTITY_old_x:Int=				51
Const ENTITY_old_y:Int=				52
Const ENTITY_old_z:Int=				53
Const ENTITY_old_pitch:Int=			54
Const ENTITY_old_yaw:Int=			55
Const ENTITY_old_roll:Int=			56
Const ENTITY_new_x:Int=				57
Const ENTITY_new_y:Int=				58
Const ENTITY_new_z:Int=				59
Const ENTITY_new_no:Int=			60
Const ENTITY_old_mat:Int=			61
Const ENTITY_dynamic:Int=			62
Const ENTITY_dynamic_x:Int=			63
Const ENTITY_dynamic_y:Int=			64
Const ENTITY_dynamic_z:Int=			65
Const ENTITY_dynamic_yaw:Int=		66
Const ENTITY_dynamic_pitch:Int=		67
Const ENTITY_dynamic_roll:Int=		68
Const ENTITY_pick_mode:Int=			69
Const ENTITY_obscurer:Int=			70
Const ENTITY_tformed_x:Int=			71
Const ENTITY_tformed_y:Int=			72
Const ENTITY_tformed_z:Int=			73

' Global varid
Const GLOBAL_width:Int=				1
Const GLOBAL_height:Int=			2
Const GLOBAL_mode:Int=				3
Const GLOBAL_depth:Int=				4
Const GLOBAL_rate:Int=				5
Const GLOBAL_ambient_red:Int=		6
Const GLOBAL_ambient_green:Int=		7
Const GLOBAL_ambient_blue:Int=		8
Const GLOBAL_ambient_shader:Int=	9
Const GLOBAL_vbo_enabled:Int=		10
Const GLOBAL_vbo_min_tris:Int=		11
Const GLOBAL_Shadows_enabled:Int=	12
Const GLOBAL_anim_speed:Int=		13
Const GLOBAL_fog_enabled:Int=		14
Const GLOBAL_root_ent:Int=			15
Const GLOBAL_camera_in_use:Int=		16
Const GLOBAL_alpha_enable:Int=		17
Const GLOBAL_blend_mode:Int=		18
Const GLOBAL_fx1:Int=				19
Const GLOBAL_fx2:Int=				20

' Light varid
Const LIGHT_light_no:Int=	1
Const LIGHT_no_lights:Int=	2
Const LIGHT_max_lights:Int=	3	
Const LIGHT_gl_light:Int=	4
Const LIGHT_light_list:Int=	5
Const LIGHT_cast_shadow:Int=6
Const LIGHT_light_type:Int=	7
Const LIGHT_range:Int=		8
Const LIGHT_red:Int=		9
Const LIGHT_green:Int=		10
Const LIGHT_blue:Int=		11
Const LIGHT_inner_ang:Int=	12
Const LIGHT_outer_ang:Int=	13

' MatPtr varid
Const MATPTR_grid:Int=	1

' Mesh varid
Const MESH_no_surfs:Int=		1
Const MESH_surf_list:Int=		2
Const MESH_anim_surf_list:Int=	3
Const MESH_bones:Int=			4
Const MESH_mat_sp:Int=			5
Const MESH_c_col_tree:Int=		6
Const MESH_reset_col_tree:Int=	7
Const MESH_reset_bounds:Int=	8
Const MESH_min_x:Int=			9
Const MESH_min_y:Int=			10
Const MESH_min_z:Int=			11
Const MESH_max_x:Int=			12
Const MESH_max_y:Int=			13
Const MESH_max_z:Int=			14
Const MESH_shared_surf:Int=		15
Const MESH_shared_anim_surf:Int=16

' Pick varid
Const PICK_ent_list:Int=		1
Const PICK_picked_x:Int=		2
Const PICK_picked_y:Int=		3
Const PICK_picked_z:Int=		4
Const PICK_picked_nx:Int=		5
Const PICK_picked_ny:Int=		6
Const PICK_picked_nz:Int=		7
Const PICK_picked_time:Int=		8
Const PICK_picked_ent:Int=		9
Const PICK_picked_surface:Int=	10
Const PICK_picked_triangle:Int=	11

' Quaternion
Const QUATPTR_x:Int=1
Const QUATPTR_y:Int=2
Const QUATPTR_z:Int=3
Const QUATPTR_w:Int=4

' ShadowObject varid
Const SHADOWOBJECT_shadow_list:Int=		1
Const SHADOWOBJECT_Parent:Int=			2
Const SHADOWOBJECT_cnt_tris:Int=		3
Const SHADOWOBJECT_ShadowMesh:Int=		4
Const SHADOWOBJECT_ShadowVolume:Int=	5
Const SHADOWOBJECT_Render:Int=			6
Const SHADOWOBJECT_Static:Int=			7
Const SHADOWOBJECT_VCreated:Int=		8
Const SHADOWOBJECT_VolumeLength:Int=	9
Const SHADOWOBJECT_top_caps:Int=		10
Const SHADOWOBJECT_parallel:Int=		11
Const SHADOWOBJECT_light_x:Int=			12
Const SHADOWOBJECT_light_y:Int=			13
Const SHADOWOBJECT_light_z:Int=			14
Const SHADOWOBJECT_midStencilVal:Int=	15
Const SHADOWOBJECT_ShadowRed:Int=		16
Const SHADOWOBJECT_ShadowGreen:Int=		17
Const SHADOWOBJECT_ShadowBlue:Int=		18
Const SHADOWOBJECT_ShadowAlpha:Int=		19

' Sprite varid
Const SPRITE_angle:Int=			1
Const SPRITE_scale_x:Int=		2
Const SPRITE_scale_y:Int=		3
Const SPRITE_handle_x:Int=		4
Const SPRITE_handle_y:Int=		5 
Const SPRITE_view_mode:Int=		6
Const SPRITE_render_mode:Int=	7

' Surface varid
Const SURFACE_no_verts:Int=			1
Const SURFACE_no_tris:Int=			2
Const SURFACE_vert_coords:Int=		3
Const SURFACE_vert_norm:Int=		4
Const SURFACE_vert_tex_coords0:Int=	5
Const SURFACE_vert_tex_coords1:Int=	6
Const SURFACE_vert_col:Int=			7
Const SURFACE_tris:Int=				8
Const SURFACE_vert_bone1_no:Int=	9
Const SURFACE_vert_bone2_no:Int=	10
Const SURFACE_vert_bone3_no:Int=	11
Const SURFACE_vert_bone4_no:Int=	12
Const SURFACE_vert_weight1:Int=		13
Const SURFACE_vert_weight2:Int=		14
Const SURFACE_vert_weight3:Int=		15
Const SURFACE_vert_weight4:Int=		16
Const SURFACE_brush:Int=			17
Const SURFACE_ShaderMat:Int=		18
Const SURFACE_vbo_id:Int=			19
Const SURFACE_vert_array_size:Int=	20
Const SURFACE_tri_array_size:Int=	21
Const SURFACE_vmin:Int=				22
Const SURFACE_vmax:Int=				23
Const SURFACE_vbo_enabled:Int=		24
Const SURFACE_reset_vbo:Int=		25
Const SURFACE_alpha_enable:Int=		26

' Terrain varid
Const TERRAIN_terrain_list:Int=	1
Const TERRAIN_triangleindex:Int=2
Const TERRAIN_mesh_info:Int=	3
Const TERRAIN_vertices:Int=		4
Const TERRAIN_size:Int=			5
Const TERRAIN_vsize:Int=		6
Const TERRAIN_level2dzsize:Int=	7
Const TERRAIN_HeightMap:Int=	8
Const TERRAIN_c_col_tree:Int=	9
Const TERRAIN_eyepoint:Int=		10
Const TERRAIN_ShaderMat:Int=	11
Const TERRAIN_Roam_Detail:Int=	12
Const TERRAIN_NormalsMap:Int=	13
Const TERRAIN_vertexindex:Int=	14

' Texture varid
Const TEXTURE_texture:Int=		1
Const TEXTURE_tex_list:Int=		2
Const TEXTURE_file:Int=			3
Const TEXTURE_frames:Int=		4
Const TEXTURE_flags:Int=		5
Const TEXTURE_blend:Int=		6
Const TEXTURE_coords:Int=		7
Const TEXTURE_u_scale:Int=		8
Const TEXTURE_v_scale:Int=		9
Const TEXTURE_u_pos:Int=		10
Const TEXTURE_v_pos:Int=		11
Const TEXTURE_angle:Int=		12
Const TEXTURE_file_abs:Int=		13
Const TEXTURE_width:Int=		14
Const TEXTURE_height:Int=		15
Const TEXTURE_no_frames:Int=	16
Const TEXTURE_framebuffer:Int=	17
Const TEXTURE_cube_face:Int=	18
Const TEXTURE_cube_mode:Int=	19
Const TEXTURE_tex_list_all:Int=	20
Const TEXTURE_format:Int=		21
Const TEXTURE_AnIsoSupport:Int=	22
Const TEXTURE_global_aniso:Int=	23

' VecPtr
Const VECPTR_x:Int=1
Const VECPTR_y:Int=2
Const VECPTR_z:Int=3
