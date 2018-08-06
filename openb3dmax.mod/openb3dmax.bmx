' openb3dmax.bmx

Strict

Rem
bbdoc: OpenB3DMax extended functions, not found in Blitz3D
about: Descriptions and some extra information.
End Rem
Module Openb3dmax.Openb3dmax

ModuleInfo "Version: 1.12"
ModuleInfo "License: zlib"
ModuleInfo "Copyright: Wrapper - 2014-2018 Mark Mcvittie, Bruce A Henderson"
ModuleInfo "Copyright: Library - 2010-2018 Angelo Rosina"

Import Openb3dmax.Openb3dlib
Import Brl.GLMax2d			' imports BRL.Max2D, BRL.GLGraphics
Import Brl.GLGraphics		' imports BRL.Graphics, BRL.Pixmap, PUB.OpenGL
Import Brl.Retro			' imports BRL.Basic
Import Brl.Map

' functions.cpp
Extern

	' *** Extra
	Function VertexTangent_( surf:Byte Ptr,vid:Int,tx:Float,ty:Float,tz:Float )
	Function VertexTX_:Float( surf:Byte Ptr,vid:Int )
	Function VertexTY_:Float( surf:Byte Ptr,vid:Int )
	Function VertexTZ_:Float( surf:Byte Ptr,vid:Int )
	Function VertexBitangent_( surf:Byte Ptr,vid:Int,bx:Float,by:Float,bz:Float )
	Function VertexBX_:Float( surf:Byte Ptr,vid:Int )
	Function VertexBY_:Float( surf:Byte Ptr,vid:Int )
	Function VertexBZ_:Float( surf:Byte Ptr,vid:Int )
	Function TextureMultitex_( tex:Byte Ptr,f:Float )
	Function TrisRendered_:Int()
	Function NewTexture_:Byte Ptr()
	Function NewMesh_:Byte Ptr()
	Function NewSurface_:Byte Ptr( mesh:Byte Ptr )
	Function NewBone_:Byte Ptr( mesh:Byte Ptr )
	Function CreateShaderMaterial_:Byte Ptr( ShaderName:Byte Ptr )
	Function CreateFragShader_:Byte Ptr( shader:Byte Ptr,shaderFileName:Byte Ptr )
	Function CreateFragShaderFromString_:Byte Ptr( shader:Byte Ptr,shadercode:Byte Ptr )
	Function CreateVertShader_:Byte Ptr( shader:Byte Ptr,shaderFileName:Byte Ptr )
	Function CreateVertShaderFromString_:Byte Ptr( shader:Byte Ptr,shadercode:Byte Ptr )
	Function AttachFragShader_:Int( shader:Byte Ptr,myShader:Byte Ptr )
	Function AttachVertShader_:Int( shader:Byte Ptr,myShader:Byte Ptr )
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
	
	' *** Minib3d only
	Function BackBufferToTex_( tex:Byte Ptr,frame:Int )
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
	Function AnimLength_( ent:Byte Ptr )
	Function AnimSeq_:Int( ent:Byte Ptr )
	Function AnimTime_:Float( ent:Byte Ptr )
	'Function AntiAlias_( samples:Int )
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
	Function EntityColor_( ent:Byte Ptr,red:Float,green:Float,blue:Float )
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
	'AlignToVector_ is in Openb3dlib.mod
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
	Function EmitterVector_( emit:Byte Ptr,x:Float,y:Float,z:Float )
	Function EmitterRate_( emit:Byte Ptr,r:Float )
	Function EmitterParticleLife_( emit:Byte Ptr,l:Int )
	Function EmitterParticleFunction_( emit:Byte Ptr,EmitterFunction( ent:Byte Ptr,life:Int ) )
	Function EmitterParticleSpeed_( emit:Byte Ptr,s:Float )
	Function EmitterVariance_( emit:Byte Ptr,v:Float )
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

' *** Globals moved to TGlobal

Const GRAPHICS_MULTISAMPLE2X:Int=$40
Const GRAPHICS_MULTISAMPLE4X:Int=$80
Const GRAPHICS_MULTISAMPLE8X:Int=$100
Const GRAPHICS_MULTISAMPLE16X:Int=$200

' Texture/Brush flags - flags 1024,2048,4096,8192,16384 seem to be unassigned
'Const TEX_COLOR:Int=1
'Const TEX_ALPHA:Int=2
'Const TEX_MASKED:Int=4
'Const TEX_MIPMAP:Int=8
'Const TEX_CLAMPU:Int=16
'Const TEX_CLAMPV:Int=32
'Const TEX_SPHEREMAP:Int=64
'Const TEX_CUBEMAP:Int=128
'Const TEX_VRAM:Int=256
'Const TEX_HIGHCOLOR:Int=512
'Const TEX_SECONDUV:Int=65536

' *** Wrapper functions

Rem
bbdoc: New begin Max2D function, allows instant resolution switch
End Rem
Function BeginMax2DEx()
	TBlitz2D.BeginMax2DEx()
End Function

Rem
bbdoc: New end Max2D function, allows instant resolution switch
End Rem
Function EndMax2DEx()
	TBlitz2D.EndMax2DEx()
End Function

Rem
bbdoc: Old begin Max2d, using pop matrix
End Rem
Function BeginMax2D()
	TBlitz2D.BeginMax2D()
End Function

Rem
bbdoc: Old end Max2d, using push matrix
End Rem
Function EndMax2D()
	TBlitz2D.EndMax2D()
End Function

Rem
bbdoc: Copy a list or vector. To copy a field list use as a method
about: Use either mesh with surf_list/anim_surf_list/bones or ent with child_list.
End Rem
Function CopyList( list:TList )
	TGlobal.CopyList( list )
End Function

Rem
bbdoc: Like using ListAddLast(list,value) in Minib3d, except ent parameter
about: Only field lists currently supported, either mesh with surf_list, anim_surf_list, bones or ent with child_list.
EndRem
Function EntityListAdd( list:TList,value:Object,ent:TEntity )
	TGlobal.EntityListAdd( list,value,ent )
End Function

Rem
bbdoc: Add an existing surface to a mesh
End Rem
Function AddSurface( mesh:TMesh,surf:TSurface,anim_surf%=False )
	If anim_surf=False
		mesh.MeshListAdd( mesh.surf_list,surf )
	Else
		mesh.MeshListAdd( mesh.anim_surf_list,surf )
	EndIf
End Function

' *** Includes

' global
Include "inc/TGlobal.bmx"

' entity
Include "inc/TEntity.bmx"
Include "inc/TCamera.bmx"
Include "inc/TLight.bmx"
Include "inc/TPivot.bmx"
Include "inc/TMesh.bmx"
Include "inc/TSprite.bmx"
Include "inc/TBone.bmx"

' mesh structure
Include "inc/TSurface.bmx"
Include "inc/TTexture.bmx"
Include "inc/TBrush.bmx"
Include "inc/TAnimation.bmx"
Include "inc/T3DS.bmx"
Include "inc/TB3D.bmx"
Include "inc/TMD2.bmx"

' picking/collision
Include "inc/TPick.bmx"

' geom
Include "inc/TVector.bmx"
Include "inc/TMatrix.bmx"
Include "inc/TQuaternion.bmx"
Include "inc/BoxSphere.bmx"

' misc
Include "inc/TBlitz2D.bmx"
Include "inc/TUtility.bmx"
'Include "inc/TDebug.bmx"
Include "inc/TMeshLoader.bmx"

' extra
Include "inc/TTerrain.bmx"
Include "inc/TShader.bmx"
Include "inc/TShadowObject.bmx"
Include "inc/THardwareInfo.bmx"
Include "inc/TStencil.bmx"
Include "inc/TFluid.bmx"
Include "inc/TGeosphere.bmx"
Include "inc/TOcTree.bmx"
Include "inc/TVoxelSprite.bmx"
Include "inc/TAction.bmx"
Include "inc/TConstraint.bmx"
Include "inc/TParticleBatch.bmx"
Include "inc/TPostFX.bmx"

' functions
Include "inc/functions.bmx"
