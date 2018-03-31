' openb3d.bmx

Strict

Rem
bbdoc: OpenB3D extended functions
about: Descriptions and some extra information.
End Rem
Module Openb3d.Openb3d

ModuleInfo "Version: 1.12"
ModuleInfo "License: zlib"
ModuleInfo "Copyright: Wrapper - 2014-2017 Mark Mcvittie, Bruce A Henderson"
ModuleInfo "Copyright: Library - 2010-2017 Angelo Rosina"

Import Openb3d.Openb3dlib
Import Brl.GLMax2d			' imports BRL.Max2D, BRL.GLGraphics
Import Brl.GLGraphics		' imports BRL.Graphics, BRL.Pixmap, PUB.OpenGL
Import Brl.Retro				' imports BRL.Basic
Import Brl.Map

' functions.cpp
Extern

	' *** Extra
	Function TextureMultitex_( tex:Byte Ptr,f:Float )' = "bbTextureMultitex"
	Function TrisRendered_:Int()' = "bbTrisRendered"
	Function NewTexture_:Byte Ptr()' = "bbNewTexture"
	Function NewMesh_:Byte Ptr()' = "bbNewMesh"
	Function NewSurface_:Byte Ptr( mesh:Byte Ptr )' = "bbNewSurface"
	Function NewBone_:Byte Ptr( mesh:Byte Ptr )' = "bbNewBone"
	Function CreateShaderMaterial_:Byte Ptr( ShaderName:Byte Ptr )' = "bbCreateShaderMaterial"
	Function CreateFragShader_:Byte Ptr( shader:Byte Ptr,shaderFileName:Byte Ptr )' = "bbCreateFragShader"
	Function CreateFragShaderFromString_:Byte Ptr( shader:Byte Ptr,shadercode:Byte Ptr )' = "bbCreateFragShaderFromString"
	Function CreateVertShader_:Byte Ptr( shader:Byte Ptr,shaderFileName:Byte Ptr )' = "bbCreateVertShader"
	Function CreateVertShaderFromString_:Byte Ptr( shader:Byte Ptr,shadercode:Byte Ptr )' = "bbCreateVertShaderFromString"
	Function AttachFragShader_:Int( shader:Byte Ptr,myShader:Byte Ptr )' = "bbAttachFragShader"
	Function AttachVertShader_:Int( shader:Byte Ptr,myShader:Byte Ptr )' = "bbAttachVertShader"
	Function DeleteFragShader_( myShader:Byte Ptr )' = "bbDeleteFragShader"
	Function DeleteVertShader_( myShader:Byte Ptr )' = "bbDeleteVertShader"
	Function FreeShader_( shader:Byte Ptr )' = "bbFreeShader"
	Function FreeStencil_( stencil:Byte Ptr )' = "bbFreeStencil"
	Function TextureFlags_( tex:Byte Ptr,flags:Int )' = "bbTextureFlags"
	Function FreeSurface_( surf:Byte Ptr )' = "bbFreeSurface"
	Function TextureGLTexEnvi_( tex:Byte Ptr,target:Int,pname:Int,param:Int )' = "bbTextureGLTexEnvi"
	Function TextureGLTexEnvf_( tex:Byte Ptr,target:Int,pname:Int,param:Float )' = "bbTextureGLTexEnvf"
	Function BrushGLColor_( brush:Byte Ptr,r:Float,g:Float,b:Float,a:Float )' = "bbBrushGLColor"
	Function BrushGLBlendFunc_( brush:Byte Ptr,sfactor:Int,dfactor:Int )' = "bbBrushGLBlendFunc"
	
	' *** Minib3d only
	Function BackBufferToTex_( tex:Byte Ptr,frame:Int )' = "bbBackBufferToTex"
	Function MeshCullRadius_( ent:Byte Ptr,radius:Float )' = "bbMeshCullRadius"
	Function EntityScaleX_:Float( ent:Byte Ptr,glob:Int )' = "bbEntityScaleX"
	Function EntityScaleY_:Float( ent:Byte Ptr,glob:Int )' = "bbEntityScaleY"
	Function EntityScaleZ_:Float( ent:Byte Ptr,glob:Int )' = "bbEntityScaleZ"
	
	' *** Blitz3D functions, A-Z
	Function AddMesh_( mesh1:Byte Ptr,mesh2:Byte Ptr )' = "bbAddMesh"
	Function AddTriangle_:Int( surf:Byte Ptr,v0:Int,v1:Int,v2:Int )' = "bbAddTriangle"
	Function AddVertex_:Int( surf:Byte Ptr,x:Float,y:Float,z:Float,u:Float,v:Float,w:Float )' = "bbAddVertex"
	Function AmbientLight_( r:Float,g:Float,b:Float )' = "bbAmbientLight"
	Function Animate_( ent:Byte Ptr,Mode:Int,speed:Float,seq:Int,trans:Int )' = "bbAnimate"
	Function Animating_:Int( ent:Byte Ptr )' = "bbAnimating"
	Function AnimLength_( ent:Byte Ptr )' = "bbAnimLength"
	Function AnimSeq_:Int( ent:Byte Ptr )' = "bbAnimSeq"
	Function AnimTime_:Float( ent:Byte Ptr )' = "bbAnimTime"
	'Function AntiAlias_( samples:Int )' = "bbAntiAlias"
	Function BrushAlpha_( brush:Byte Ptr,a:Float )' = "bbBrushAlpha"
	Function BrushBlend_( brush:Byte Ptr,blend:Int )' = "bbBrushBlend"
	Function BrushColor_( brush:Byte Ptr,r:Float,g:Float,b:Float )' = "bbBrushColor"
	Function BrushFX_( brush:Byte Ptr,fx:Int )' = "bbBrushFX"
	Function BrushShininess_( brush:Byte Ptr,s:Float )' = "bbBrushShininess"
	Function BrushTexture_( brush:Byte Ptr,tex:Byte Ptr,frame:Int,index:Int )' = "bbBrushTexture"
	Function CameraClsColor_( cam:Byte Ptr,r:Float,g:Float,b:Float )' = "bbCameraClsColor"
	Function CameraClsMode_( cam:Byte Ptr,cls_depth:Int,cls_zbuffer:Int )' = "bbCameraClsMode"
	Function CameraFogColor_( cam:Byte Ptr,r:Float,g:Float,b:Float )' = "bbCameraFogColor"
	Function CameraFogMode_( cam:Byte Ptr,Mode:Int )' = "bbCameraFogMode"
	Function CameraFogRange_( cam:Byte Ptr,nnear:Float,nfar:Float )' = "bbCameraFogRange"
	Function CameraPick_:Byte Ptr( cam:Byte Ptr,x:Float,y:Float )' = "bbCameraPick"
	Function CameraProject_( cam:Byte Ptr,x:Float,y:Float,z:Float )' = "bbCameraProject"
	Function CameraProjMode_( cam:Byte Ptr,Mode:Int )' = "bbCameraProjMode"
	Function CameraRange_( cam:Byte Ptr,nnear:Float,nfar:Float )' = "bbCameraRange"
	Function CameraViewport_( cam:Byte Ptr,x:Int,y:Int,width:Int,height:Int )' = "bbCameraViewport"
	Function CameraZoom_( cam:Byte Ptr,zoom:Float )' = "bbCameraZoom"
	Function ClearCollisions_()' = "bbClearCollisions"
	Function ClearSurface_( surf:Byte Ptr,clear_verts:Int,clear_tris:Int )' = "bbClearSurface"
	Function ClearTextureFilters_()' = "bbClearTextureFilters"
	Function ClearWorld_( entities:Int,brushes:Int,textures:Int )' = "bbClearWorld"
	Function CollisionEntity_:Byte Ptr( ent:Byte Ptr,index:Int )' = "bbCollisionEntity"
	Function CollisionNX_:Float( ent:Byte Ptr,index:Int )' = "bbCollisionNX"
	Function CollisionNY_:Float( ent:Byte Ptr,index:Int )' = "bbCollisionNY"
	Function CollisionNZ_:Float( ent:Byte Ptr,index:Int )' = "bbCollisionNZ"
	Function Collisions_( src_no:Int,dest_no:Int,method_no:Int,response_no:Int )' = "bbCollisions"
	Function CollisionSurface_:Byte Ptr( ent:Byte Ptr,index:Int )' = "bbCollisionSurface"
	Function CollisionTime_:Float( ent:Byte Ptr,index:Int )' = "bbCollisionTime"
	Function CollisionTriangle_:Int( ent:Byte Ptr,index:Int )' = "bbCollisionTriangle"
	Function CollisionX_:Float( ent:Byte Ptr,index:Int )' = "bbCollisionX"
	Function CollisionY_:Float( ent:Byte Ptr,index:Int )' = "bbCollisionY"
	Function CollisionZ_:Float( ent:Byte Ptr,index:Int )' = "bbCollisionZ"
	Function CopyEntity_:Byte Ptr( ent:Byte Ptr,parent:Byte Ptr )' = "bbCopyEntity"
	Function CopyMesh_:Byte Ptr( mesh:Byte Ptr,parent:Byte Ptr )' = "bbCopyMesh"
	Function CountChildren_:Int( ent:Byte Ptr )' = "bbCountChildren"
	Function CountCollisions_:Int( ent:Byte Ptr )' = "bbCountCollisions"
	Function CountSurfaces_:Int( mesh:Byte Ptr )' = "bbCountSurfaces"
	Function CountTriangles_:Int( surf:Byte Ptr )' = "bbCountTriangles"
	Function CountVertices_:Int( surf:Byte Ptr )' = "bbCountVertices"
	Function CreateBrush_:Byte Ptr( r:Float,g:Float,b:Float )' = "bbCreateBrush"
	Function CreateCamera_:Byte Ptr( parent:Byte Ptr )' = "bbCreateCamera"
	Function CreateCone_:Byte Ptr( segments:Int,solid:Int,parent:Byte Ptr )' = "bbCreateCone"
	Function CreateCylinder_:Byte Ptr( segments:Int,solid:Int,parent:Byte Ptr )' = "bbCreateCylinder"
	Function CreateCube_:Byte Ptr( parent:Byte Ptr )' = "bbCreateCube"
	Function CreateMesh_:Byte Ptr( parent:Byte Ptr )' = "bbCreateMesh"
	Function CreateLight_:Byte Ptr( light_type:Int,parent:Byte Ptr )' = "bbCreateLight"
	Function CreatePivot_:Byte Ptr( parent:Byte Ptr )' = "bbCreatePivot"
	Function CreateSphere_:Byte Ptr( segments:Int,parent:Byte Ptr )' = "bbCreateSphere"
	Function CreateSprite_:Byte Ptr( parent:Byte Ptr )' = "bbCreateSprite"
	Function CreateSurface_:Byte Ptr( mesh:Byte Ptr,brush:Byte Ptr )' = "bbCreateSurface"
	Function CreateTexture_:Byte Ptr( width:Int,height:Int,flags:Int,frames:Int )' = "bbCreateTexture"
	Function DeltaPitch_:Float( ent1:Byte Ptr,ent2:Byte Ptr )' = "bbDeltaPitch"
	Function DeltaYaw_:Float( ent1:Byte Ptr,ent2:Byte Ptr )' = "bbDeltaYaw"
	Function EntityAlpha_( ent:Byte Ptr,alpha:Float )' = "bbEntityAlpha"
	'Function EntityAutoFade_( ent:Byte Ptr,near:Float,far:Float )' = "bbEntityAutoFade"
	Function EntityBlend_( ent:Byte Ptr,blend:Int )' = "bbEntityBlend"
	Function EntityBox_( ent:Byte Ptr,x:Float,y:Float,z:Float,w:Float,h:Float,d:Float )' = "bbEntityBox"
	Function EntityClass_:Byte Ptr( ent:Byte Ptr )' = "bbEntityClass"
	Function EntityCollided_:Byte Ptr( ent:Byte Ptr,type_no:Int )' = "bbEntityCollided"
	Function EntityColor_( ent:Byte Ptr,red:Float,green:Float,blue:Float )' = "bbEntityColor"
	Function EntityDistance_:Float( ent1:Byte Ptr,ent2:Byte Ptr )' = "bbEntityDistance"
	Function EntityFX_( ent:Byte Ptr,fx:Int )' = "bbEntityFX"
	Function EntityInView_:Int( ent:Byte Ptr,cam:Byte Ptr )' = "bbEntityInView"
	Function EntityName_:Byte Ptr( ent:Byte Ptr )' = "bbEntityName"
	Function EntityOrder_( ent:Byte Ptr,order:Int )' = "bbEntityOrder"
	Function EntityParent_( ent:Byte Ptr,parent_ent:Byte Ptr,glob:Int )' = "bbEntityParent"
	Function EntityPick_:Byte Ptr( ent:Byte Ptr,Range:Float )' = "bbEntityPick"
	Function EntityPickMode_( ent:Byte Ptr,pick_mode:Int,obscurer:Int )' = "bbEntityPickMode"
	Function EntityPitch_:Float( ent:Byte Ptr,glob:Int )' = "bbEntityPitch"
	Function EntityRadius_( ent:Byte Ptr,radius_x:Float,radius_y:Float )' = "bbEntityRadius"
	Function EntityRoll_:Float( ent:Byte Ptr,glob:Int )' = "bbEntityRoll"
	Function EntityShininess_( ent:Byte Ptr,shine:Float )' = "bbEntityShininess"
	Function EntityTexture_( ent:Byte Ptr,tex:Byte Ptr,frame:Int,index:Int )' = "bbEntityTexture"
	Function EntityType_( ent:Byte Ptr,type_no:Int,recursive:Int )' = "bbEntityType"
	Function EntityVisible_:Int( src_ent:Byte Ptr,dest_ent:Byte Ptr )' = "bbEntityVisible"
	Function EntityX_:Float( ent:Byte Ptr,glob:Int )' = "bbEntityX"
	Function EntityY_:Float( ent:Byte Ptr,glob:Int )' = "bbEntityY"
	Function EntityYaw_:Float( ent:Byte Ptr,glob:Int )' = "bbEntityYaw"
	Function EntityZ_:Float( ent:Byte Ptr,glob:Int )' = "bbEntityZ"
	Function ExtractAnimSeq_:Int( ent:Byte Ptr,first_frame:Int,last_frame:Int,seq:Int )' = "bbExtractAnimSeq"
	Function FindChild_:Byte Ptr( ent:Byte Ptr,child_name:Byte Ptr )' = "bbFindChild"
	Function FindSurface_:Byte Ptr( mesh:Byte Ptr,brush:Byte Ptr )' = "bbFindSurface"
	Function FitMesh_( mesh:Byte Ptr,x:Float,y:Float,z:Float,width:Float,height:Float,depth:Float,uniform:Int )' = "bbFitMesh"
	Function FlipMesh_( mesh:Byte Ptr )' = "bbFlipMesh"
	Function FreeBrush_( brush:Byte Ptr )' = "bbFreeBrush"
	Function FreeEntity_( ent:Byte Ptr )' = "bbFreeEntity"
	Function FreeTexture_( tex:Byte Ptr )' = "bbFreeTexture"
	Function GetBrushTexture_:Byte Ptr( brush:Byte Ptr,index:Int )' = "bbGetBrushTexture"
	Function GetChild_:Byte Ptr( ent:Byte Ptr,child_no:Int )' = "bbGetChild"
	Function GetEntityBrush_:Byte Ptr( ent:Byte Ptr )' = "bbGetEntityBrush"
	Function GetEntityType_:Int( ent:Byte Ptr )' = "bbGetEntityType"
	'Function GetMatElement_:Float( ent:Byte Ptr,row:Int,col:Int )' = "bbGetMatElement"
	Function GetParentEntity_:Byte Ptr( ent:Byte Ptr )' = "bbGetParentEntity"
	Function GetSurface_:Byte Ptr( mesh:Byte Ptr,surf_no:Int )' = "bbGetSurface"
	Function GetSurfaceBrush_:Byte Ptr( surf:Byte Ptr )' = "bbGetSurfaceBrush"	
	Function Graphics3D_( width:Int,height:Int,depth:Int,mode:Int,rate:Int )' = "bbGraphics3D"
	Function HandleSprite_( sprite:Byte Ptr,h_x:Float,h_y:Float )' = "bbHandleSprite"
	Function HideEntity_( ent:Byte Ptr )' = "bbHideEntity"
	Function LightColor_( light:Byte Ptr,red:Float,green:Float,blue:Float )' = "bbLightColor"
	Function LightConeAngles_( light:Byte Ptr,inner_ang:Float,outer_ang:Float )' = "bbLightConeAngles"
	Function LightRange_( light:Byte Ptr,Range:Float )' = "bbLightRange"
	Function LinePick_:Byte Ptr( x:Float,y:Float,z:Float,dx:Float,dy:Float,dz:Float,radius:Float )' = "bbLinePick"
	Function LoadAnimMesh_:Byte Ptr( file:Byte Ptr,parent:Byte Ptr )' = "bbLoadAnimMesh"
	Function LoadAnimTexture_:Byte Ptr( file:Byte Ptr,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int,tex:Byte Ptr )' = "bbLoadAnimTexture"
	Function LoadBrush_:Byte Ptr( file:Byte Ptr,flags:Int,u_scale:Float,v_scale:Float )' = "bbLoadBrush"
	Function LoadMesh_:Byte Ptr( file:Byte Ptr,parent:Byte Ptr )' = "bbLoadMesh"
	Function LoadTexture_:Byte Ptr( file:Byte Ptr,flags:Int,tex:Byte Ptr )' = "bbLoadTexture"
	Function LoadSprite_:Byte Ptr( tex_file:Byte Ptr,tex_flag:Int,parent:Byte Ptr )' = "bbLoadSprite"
	Function MeshDepth_:Float( mesh:Byte Ptr )' = "bbMeshDepth"
	Function MeshHeight_:Float( mesh:Byte Ptr )' = "bbMeshHeight"
	Function MeshWidth_:Float( mesh:Byte Ptr )' = "bbMeshWidth"
	Function MoveEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float )' = "bbMoveEntity"
	Function NameEntity_( ent:Byte Ptr,name:Byte Ptr )' = "bbNameEntity"
	Function PaintEntity_( ent:Byte Ptr,brush:Byte Ptr )' = "bbPaintEntity"
	Function PaintMesh_( mesh:Byte Ptr,brush:Byte Ptr )' = "bbPaintMesh"
	Function PaintSurface_( surf:Byte Ptr,brush:Byte Ptr )' = "bbPaintSurface"
	Function PickedEntity_:Byte Ptr()' = "bbPickedEntity"
	Function PickedNX_:Float()' = "bbPickedNX"
	Function PickedNY_:Float()' = "bbPickedNY"
	Function PickedNZ_:Float()' = "bbPickedNZ"
	Function PickedSurface_:Byte Ptr()' = "bbPickedSurface"
	Function PickedTime_:Float()' = "bbPickedTime"
	Function PickedTriangle_:Int()' = "bbPickedTriangle"
	Function PickedX_:Float()' = "bbPickedX"
	Function PickedY_:Float()' = "bbPickedY"
	Function PickedZ_:Float()' = "bbPickedZ"
	Function PointEntity_( ent:Byte Ptr,target_ent:Byte Ptr,roll:Float )' = "bbPointEntity"
	Function PositionEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )' = "bbPositionEntity"
	Function PositionMesh_( mesh:Byte Ptr,px:Float,py:Float,pz:Float )' = "bbPositionMesh"
	Function PositionTexture_( tex:Byte Ptr,u_pos:Float,v_pos:Float )' = "bbPositionTexture"
	Function ProjectedX_:Float()' = "bbProjectedX"
	Function ProjectedY_:Float()' = "bbProjectedY"
	Function ProjectedZ_:Float()' = "bbProjectedZ"
	Function RenderWorld_()' = "bbRenderWorld"
	Function ResetEntity_( ent:Byte Ptr )' = "bbResetEntity"
	Function RotateEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )' = "bbRotateEntity"
	Function RotateMesh_( mesh:Byte Ptr,pitch:Float,yaw:Float,roll:Float )' = "bbRotateMesh"
	Function RotateSprite_( sprite:Byte Ptr,ang:Float )' = "bbRotateSprite"
	Function RotateTexture_( tex:Byte Ptr,ang:Float )' = "bbRotateTexture"
	Function ScaleEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )' = "bbScaleEntity"
	Function ScaleMesh_( mesh:Byte Ptr,sx:Float,sy:Float,sz:Float )' = "bbScaleMesh"
	Function ScaleSprite_( sprite:Byte Ptr,s_x:Float,s_y:Float )' = "bbScaleSprite"
	Function ScaleTexture_( tex:Byte Ptr,u_scale:Float,v_scale:Float )' = "bbScaleTexture"
	Function SetAnimTime_( ent:Byte Ptr,time:Float,seq:Int )' = "bbSetAnimTime"
	Function SetCubeFace_( tex:Byte Ptr,face:Int )' = "bbSetCubeFace"
	Function SetCubeMode_( tex:Byte Ptr,Mode:Int )' = "bbSetCubeMode"
	Function ShowEntity_( ent:Byte Ptr )' = "bbShowEntity"
	Function SpriteViewMode_( sprite:Byte Ptr,Mode:Int )' = "bbSpriteViewMode"
	Function TextureBlend_( tex:Byte Ptr,blend:Int )' = "bbTextureBlend"
	Function TextureCoords_( tex:Byte Ptr,coords:Int )' = "bbTextureCoords"
	Function TextureHeight_:Int( tex:Byte Ptr )' = "bbTextureHeight"
	Function TextureFilter_( match_text:Byte Ptr,flags:Int )' = "bbTextureFilter"
	Function TextureName_:Byte Ptr( tex:Byte Ptr )' = "bbTextureName"
	Function TextureWidth_:Int( tex:Byte Ptr )' = "bbTextureWidth"
	Function TFormedX_:Float()' = "bbTFormedX"
	Function TFormedY_:Float()' = "bbTFormedY"
	Function TFormedZ_:Float()' = "bbTFormedZ"
	Function TFormNormal_( x:Float,y:Float,z:Float,src_ent:Byte Ptr,dest_ent:Byte Ptr )' = "bbTFormNormal"
	Function TFormPoint_( x:Float,y:Float,z:Float,src_ent:Byte Ptr,dest_ent:Byte Ptr )' = "bbTFormPoint"
	Function TFormVector_( x:Float,y:Float,z:Float,src_ent:Byte Ptr,dest_ent:Byte Ptr )' = "bbTFormVector"
	Function TranslateEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )' = "bbTranslateEntity"
	Function TriangleVertex_:Int( surf:Byte Ptr,tri_no:Int,corner:Int )' = "bbTriangleVertex"
	Function TurnEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )' = "bbTurnEntity"
	Function UpdateNormals_( mesh:Byte Ptr )' = "bbUpdateNormals"
	Function UpdateWorld_( anim_speed:Float )' = "bbUpdateWorld"
	Function VectorPitch_:Float( vx:Float,vy:Float,vz:Float )' = "bbVectorPitch"
	Function VectorYaw_:Float( vx:Float,vy:Float,vz:Float )' = "bbVectorYaw"
	Function VertexAlpha_:Float( surf:Byte Ptr,vid:Int )' = "bbVertexAlpha"
	Function VertexBlue_:Float( surf:Byte Ptr,vid:Int )' = "bbVertexBlue"
	Function VertexColor_( surf:Byte Ptr,vid:Int,r:Float,g:Float,b:Float,a:Float )' = "bbVertexColor"
	Function VertexCoords_( surf:Byte Ptr,vid:Int,x:Float,y:Float,z:Float )' = "bbVertexCoords"
	Function VertexGreen_:Float( surf:Byte Ptr,vid:Int )' = "bbVertexGreen"
	Function VertexNormal_( surf:Byte Ptr,vid:Int,nx:Float,ny:Float,nz:Float )' = "bbVertexNormal"
	Function VertexNX_:Float( surf:Byte Ptr,vid:Int )' = "bbVertexNX"
	Function VertexNY_:Float( surf:Byte Ptr,vid:Int )' = "bbVertexNY"
	Function VertexNZ_:Float( surf:Byte Ptr,vid:Int )' = "bbVertexNZ"
	Function VertexRed_:Float( surf:Byte Ptr,vid:Int )' = "bbVertexRed"
	Function VertexTexCoords_( surf:Byte Ptr,vid:Int,u:Float,v:Float,w:Float,coord_set:Int )' = "bbVertexTexCoords"
	Function VertexU_:Float( surf:Byte Ptr,vid:Int,coord_set:Int )' = "bbVertexU"
	Function VertexV_:Float( surf:Byte Ptr,vid:Int,coord_set:Int )' = "bbVertexV"
	Function VertexW_:Float( surf:Byte Ptr,vid:Int,coord_set:Int )' = "bbVertexW"
	Function VertexX_:Float( surf:Byte Ptr,vid:Int )' = "bbVertexX"
	Function VertexY_:Float( surf:Byte Ptr,vid:Int )' = "bbVertexY"
	Function VertexZ_:Float( surf:Byte Ptr,vid:Int )' = "bbVertexZ"
	Function Wireframe_( enable:Int )' = "bbWireframe"
	
	' *** Blitz3D functions, A-Z (in Openb3d)
	Function AddAnimSeq_:Int( ent:Byte Ptr,length:Int )' = "bbAddAnimSeq"
	'AlignToVector_ is in Openb3dlib.mod
	Function CreatePlane_:Byte Ptr( divisions:Int,parent:Byte Ptr )' = "bbCreatePlane"
	Function CreateTerrain_:Byte Ptr( size:Int,parent:Byte Ptr )' = "bbCreateTerrain"
	Function LoadAnimSeq_:Int( ent:Byte Ptr,file:Byte Ptr )' = "bbLoadAnimSeq"
	Function LoadTerrain_:Byte Ptr( file:Byte Ptr,parent:Byte Ptr )' = "bbLoadTerrain"
	Function MeshesIntersect_:Int( mesh1:Byte Ptr,mesh2:Byte Ptr )' = "bbMeshesIntersect"
	Function ModifyTerrain_( terr:Byte Ptr,x:Int,z:Int,new_height:Float )' = "bbModifyTerrain"
	Function SetAnimKey_( ent:Byte Ptr,frame:Float,pos_key:Int,rot_key:Int,scale_key:Int )' = "bbSetAnimKey"
	Function TerrainHeight_:Float( terr:Byte Ptr,x:Int,z:Int )' = "bbTerrainHeight"
	Function TerrainX_:Float( terr:Byte Ptr,x:Float,y:Float,z:Float )' = "bbTerrainX"
	Function TerrainY_:Float( terr:Byte Ptr,x:Float,y:Float,z:Float )' = "bbTerrainY"
	Function TerrainZ_:Float( terr:Byte Ptr,x:Float,y:Float,z:Float )' = "bbTerrainZ"
	
	' *** Openb3d only
	Function BufferToTex_( tex:Byte Ptr,buffer:Byte Ptr,frame:Int )' = "bbBufferToTex"
	Function CameraToTex_( tex:Byte Ptr,cam:Byte Ptr,frame:Int )' = "bbCameraToTex"
	Function CreateBone_:Byte Ptr( mesh:Byte Ptr,parent_ent:Byte Ptr )' = "bbCreateBone"
	Function CreateQuad_:Byte Ptr( parent:Byte Ptr )' = "bbCreateQuad"
	Function DepthBufferToTex_( tex:Byte Ptr,cam:Byte Ptr )' = "bbDepthBufferToTex"
	Function MeshCSG_:Byte Ptr( m1:Byte Ptr,m2:Byte Ptr,method_no:Int )' = "bbMeshCSG"
	Function RepeatMesh_:Byte Ptr( mesh:Byte Ptr,parent:Byte Ptr )' = "bbRepeatMesh"
	Function SkinMesh_( mesh:Byte Ptr,surf_no_get:Int,vid:Int,bone1:Int,weight1:Float,bone2:Int,weight2:Float,bone3:Int,weight3:Float,bone4:Int,weight4:Float )' = "bbSkinMesh"
	Function SpriteRenderMode_( sprite:Byte Ptr,Mode:Int )' = "bbSpriteRenderMode"
	Function TexToBuffer_( tex:Byte Ptr,buffer:Byte Ptr,frame:Int )' = "bbTexToBuffer"
	Function UpdateTexCoords_( surf:Byte Ptr )' = "bbUpdateTexCoords"
	
	' *** Action
	Function ActMoveBy_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "bbActMoveBy"
	Function ActTurnBy_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "bbActTurnBy"
	Function ActVector_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float )' = "bbActVector"
	Function ActMoveTo_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "bbActMoveTo"
	Function ActTurnTo_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "bbActTurnTo"
	Function ActScaleTo_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "bbActScaleTo"
	Function ActFadeTo_:Byte Ptr( ent:Byte Ptr,a:Float,rate:Float )' = "bbActFadeTo"
	Function ActTintTo_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "bbActTintTo"
	Function ActTrackByPoint_:Byte Ptr( ent:Byte Ptr,target:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "bbActTrackByPoint"
	Function ActTrackByDistance_:Byte Ptr( ent:Byte Ptr,target:Byte Ptr,a:Float,rate:Float )' = "bbActTrackByDistance"
	Function ActNewtonian_:Byte Ptr( ent:Byte Ptr,rate:Float )' = "bbActNewtonian"
	Function AppendAction_( act1:Byte Ptr,act2:Byte Ptr )' = "bbAppendAction"
	Function FreeAction_( act:Byte Ptr )' = "bbFreeAction"
	Function EndAction_( act:Byte Ptr )' = "bbEndAction"
	
	' *** Constraint
	Function CreateConstraint_:Byte Ptr( p1:Byte Ptr,p2:Byte Ptr,l:Float )' = "bbCreateConstraint"
	Function CreateRigidBody_:Byte Ptr( body:Byte Ptr,p1:Byte Ptr,p2:Byte Ptr,p3:Byte Ptr,p4:Byte Ptr )' = "bbCreateRigidBody"
	
	' *** Fluid
	Function CreateBlob_:Byte Ptr( fluid:Byte Ptr,radius:Float,parent_ent:Byte Ptr )' = "bbCreateBlob"
	Function CreateFluid_:Byte Ptr()' = "bbCreateFluid"
	Function FluidArray_( fluid:Byte Ptr,Array:Float Ptr,w:Int,h:Int,d:Int)' = "bbFluidArray"
	Function FluidFunction_( fluid:Byte Ptr,FieldFunction:Float( x:Float,y:Float,z:Float ) )' = "bbFluidFunction"
	Function FluidThreshold_( fluid:Byte Ptr,threshold:Float )' = "bbFluidThreshold"
	
	' *** Geosphere
	Function CreateGeosphere_:Byte Ptr( size:Int,parent:Byte Ptr )' = "bbCreateGeosphere"
	Function GeosphereHeight_( geo:Byte Ptr,h:Float )' = "bbGeosphereHeight"
	Function LoadGeosphere_:Byte Ptr( file:Byte Ptr,parent:Byte Ptr )' = "bbLoadGeosphere"
	Function ModifyGeosphere_( geo:Byte Ptr,x:Int,z:Int,new_height:Float )' = "bbModifyGeosphere"
	
	' *** Octree
	Function CreateOcTree_:Byte Ptr( w:Float,h:Float,d:Float,parent_ent:Byte Ptr )' = "bbCreateOcTree"
	Function OctreeBlock_( octree:Byte Ptr,mesh:Byte Ptr,level:Int,X:Float,Y:Float,Z:Float,Near:Float,Far:Float )' = "bbOctreeBlock"
	Function OctreeMesh_( octree:Byte Ptr,mesh:Byte Ptr,level:Int,X:Float,Y:Float,Z:Float,Near:Float,Far:Float )' = "bbOctreeMesh"
	
	' *** Particle
	Function CreateParticleEmitter_:Byte Ptr( particle:Byte Ptr,parent_ent:Byte Ptr )' = "bbCreateParticleEmitter"
	Function EmitterVector_( emit:Byte Ptr,x:Float,y:Float,z:Float )' = "bbEmitterVector"
	Function EmitterRate_( emit:Byte Ptr,r:Float )' = "bbEmitterRate"
	Function EmitterParticleLife_( emit:Byte Ptr,l:Int )' = "bbEmitterParticleLife"
	Function EmitterParticleFunction_( emit:Byte Ptr,EmitterFunction( ent:Byte Ptr,life:Int ) )' = "bbEmitterParticleFunction"
	Function EmitterParticleSpeed_( emit:Byte Ptr,s:Float )' = "bbEmitterParticleSpeed"
	Function EmitterVariance_( emit:Byte Ptr,v:Float )' = "bbEmitterVariance"
	Function ParticleColor_( sprite:Byte Ptr,r:Float,g:Float,b:Float,a:Float )' = "bbParticleColor"
	Function ParticleVector_( sprite:Byte Ptr,x:Float,y:Float,z:Float )' = "bbParticleVector"
	Function ParticleTrail_( sprite:Byte Ptr,length:Int )' = "bbParticleTrail"
	
	' *** Shader
	Function LoadShader_:Byte Ptr( ShaderName:Byte Ptr,VshaderFileName:Byte Ptr,FshaderFileName:Byte Ptr )' = "bbLoadShader"
	Function CreateShader_:Byte Ptr( ShaderName:Byte Ptr,VshaderString:Byte Ptr,FshaderString:Byte Ptr )' = "bbCreateShader"
	Function ShadeSurface_( surf:Byte Ptr,material:Byte Ptr )' = "bbShadeSurface"
	Function ShadeMesh_( mesh:Byte Ptr,material:Byte Ptr )' = "bbShadeMesh"
	Function ShadeEntity_( ent:Byte Ptr,material:Byte Ptr )' = "bbShadeEntity"
	Function ShaderTexture_:Byte Ptr( material:Byte Ptr,tex:Byte Ptr,name:Byte Ptr,index:Int )' = "bbShaderTexture"
	Function SetFloat_( material:Byte Ptr,name:Byte Ptr,v1:Float )' = "bbSetFloat"
	Function SetFloat2_( material:Byte Ptr,name:Byte Ptr,v1:Float,v2:Float )' = "bbSetFloat2"
	Function SetFloat3_( material:Byte Ptr,name:Byte Ptr,v1:Float,v2:Float,v3:Float )' = "bbSetFloat3"
	Function SetFloat4_( material:Byte Ptr,name:Byte Ptr,v1:Float,v2:Float,v3:Float,v4:Float )' = "bbSetFloat4"
	Function UseFloat_( material:Byte Ptr,name:Byte Ptr,v1:Float Ptr )' = "bbUseFloat"
	Function UseFloat2_( material:Byte Ptr,name:Byte Ptr,v1:Float Ptr,v2:Float Ptr )' = "bbUseFloat2"
	Function UseFloat3_( material:Byte Ptr,name:Byte Ptr,v1:Float Ptr,v2:Float Ptr,v3:Float Ptr )' = "bbUseFloat3"
	Function UseFloat4_( material:Byte Ptr,name:Byte Ptr,v1:Float Ptr,v2:Float Ptr,v3:Float Ptr,v4:Float Ptr )' = "bbUseFloat4"
	Function SetInteger_( material:Byte Ptr,name:Byte Ptr,v1:Int )' = "bbSetInteger"
	Function SetInteger2_( material:Byte Ptr,name:Byte Ptr,v1:Int,v2:Int )' = "bbSetInteger2"
	Function SetInteger3_( material:Byte Ptr,name:Byte Ptr,v1:Int,v2:Int,v3:Int )' = "bbSetInteger3"
	Function SetInteger4_( material:Byte Ptr,name:Byte Ptr,v1:Int,v2:Int,v3:Int,v4:Int )' = "bbSetInteger4"
	Function UseInteger_( material:Byte Ptr,name:Byte Ptr,v1:Int Ptr )' = "bbUseInteger"
	Function UseInteger2_( material:Byte Ptr,name:Byte Ptr,v1:Int Ptr,v2:Int Ptr )' = "bbUseInteger2"
	Function UseInteger3_( material:Byte Ptr,name:Byte Ptr,v1:Int Ptr,v2:Int Ptr,v3:Int Ptr )' = "bbUseInteger3"
	Function UseInteger4_( material:Byte Ptr,name:Byte Ptr,v1:Int Ptr,v2:Int Ptr,v3:Int Ptr,v4:Int Ptr )' = "bbUseInteger4"
	Function UseSurface_( material:Byte Ptr,name:Byte Ptr,surf:Byte Ptr,vbo:Int )' = "bbUseSurface"
	Function UseMatrix_( material:Byte Ptr,name:Byte Ptr,Mode:Int )' = "bbUseMatrix"
	Function LoadMaterial_:Byte Ptr( filename:Byte Ptr,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int )' = "bbLoadMaterial"
	Function ShaderMaterial_( material:Byte Ptr,tex:Byte Ptr,name:Byte Ptr,index:Int )' = "bbShaderMaterial"
	Function AmbientShader_( material:Byte Ptr )' = "bbAmbientShader"
	
	' *** Shadow
	Function CreateShadow_:Byte Ptr( parent:Byte Ptr,Static:Int )' = "bbCreateShadow"
	Function FreeShadow_( shad:Byte Ptr )' = "bbFreeShadow"
	
	' *** Stencil
	Function CreateStencil_:Byte Ptr()' = "bbCreateStencil"
	Function StencilAlpha_( stencil:Byte Ptr,a:Float )' = "bbStencilAlpha"
	Function StencilClsColor_( stencil:Byte Ptr,r:Float,g:Float,b:Float )' = "bbStencilClsColor"
	Function StencilClsMode_( stencil:Byte Ptr,cls_color:Int,cls_zbuffer:Int )' = "bbStencilClsMode"
	Function StencilMesh_( stencil:Byte Ptr,mesh:Byte Ptr,Mode:Int )' = "bbStencilMesh"
	Function StencilMode_( stencil:Byte Ptr,m:Int,o:Int )' = "bbStencilMode"
	Function UseStencil_( stencil:Byte Ptr )' = "bbUseStencil"
	
	' *** VoxelSprite
	Function CreateVoxelSprite_:Byte Ptr( slices:Int,parent:Byte Ptr )' = "bbCreateVoxelSprite"
	Function VoxelSpriteMaterial_( voxelspr:Byte Ptr,mat:Byte Ptr )' = "bbVoxelSpriteMaterial"
	
End Extern

' *** Constants

Const USE_MAX2D:Int=	True ' true to enable max2d/minib3d integration
Const USE_VBO:Int=		True ' true to use vbos if supported by hardware
Const VBO_MIN_TRIS:Int=	250	' if USE_VBO=True and vbos are supported by hardware, then surface must also have this minimum no. of tris before vbo is used for surface (vbos work best with surfaces with high amount of tris)
Const LOG_NEW:Int=		False ' true to write to debuglog when new minib3d object created
Const LOG_DEL:Int=		False ' true to write to debuglog when minib3d object destroyed

' Texture flags, also Brush
Const TEX_COLOR:Int=1
Const TEX_ALPHA:Int=2
Const TEX_MASKED:Int=4
Const TEX_MIPMAP:Int=8
Const TEX_CLAMPU:Int=16
Const TEX_CLAMPV:Int=32
Const TEX_SPHEREMAP:Int=64
Const TEX_CUBEMAP:Int=128
Const TEX_VRAM:Int=256
Const TEX_HIGHCOLOR:Int=512 ' 1024,2048,8192,16384 unassigned
'Const TEX_STREAM:Int=4096 ' load texture from stream
Const TEX_SECONDUV:Int=65536

' *** Wrapper functions

Rem
bbdoc: New begin using Max2D, allows instant resolution switch.
End Rem
Function BeginMax2D()
	TBlitz2D.BeginMax2D()
End Function

Rem
bbdoc: New end using Max2D, allows instant resolution switch.
End Rem
Function EndMax2D()
	TBlitz2D.EndMax2D()
End Function

Rem
bbdoc: Old Minib3d begin using Max2d.
End Rem
Function BeginMini2D()
	TBlitz2D.BeginMini2D()
End Function

Rem
bbdoc: Old Minib3d end using Max2d.
End Rem
Function EndMini2D()
	TBlitz2D.EndMini2D()
End Function

Rem
bbdoc: Copy a list or vector. To copy a field list use as a method.
about: Use either mesh with surf_list/anim_surf_list/bones or ent with child_list.
End Rem
Function CopyList( list:TList )
	TGlobal.CopyList( list )
End Function

Rem
bbdoc: Like using ListAddLast(list,value) in Minib3d, except ent parameter.
about: Only field lists supported, use either mesh with surf_list/anim_surf_list/bones or ent with child_list.
EndRem
Function ListPushBack( list:TList,value:Object,ent:TEntity )
	TGlobal.ListPushBack( list,value,ent )
End Function

Rem
bbdoc: Add an existing surface to a mesh.
End Rem
Function AddSurface( mesh:TMesh,surf:TSurface,anim_surf%=False )
	If anim_surf=False
		mesh.ListPushBack( mesh.surf_list,surf )
	Else
		mesh.ListPushBack( mesh.anim_surf_list,surf )
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
'Include "TMeshLoader.bmx" ' not implemented

' extra
'Include "inc/TBuffer.bmx"
Include "inc/TTerrain.bmx"
Include "inc/TShader.bmx"
Include "inc/TShadowObject.bmx"
Include "inc/THardwareInfo.bmx"
Include "inc/TGLShader.bmx"
Include "inc/TStencil.bmx"
Include "inc/TFluid.bmx"
Include "inc/TGeosphere.bmx"
Include "inc/TOcTree.bmx"
Include "inc/TVoxelSprite.bmx"
Include "inc/TAction.bmx"
Include "inc/TConstraint.bmx"
Include "inc/TParticleBatch.bmx"

' functions
Include "inc/functions.bmx"
