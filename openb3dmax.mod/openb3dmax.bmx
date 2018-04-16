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
	Function TextureMultitex_( tex:Byte Ptr,f:Float )' = "TextureMultitex"
	Function TrisRendered_:Int()' = "TrisRendered"
	Function NewTexture_:Byte Ptr()' = "NewTexture"
	Function NewMesh_:Byte Ptr()' = "NewMesh"
	Function NewSurface_:Byte Ptr( mesh:Byte Ptr )' = "NewSurface"
	Function NewBone_:Byte Ptr( mesh:Byte Ptr )' = "NewBone"
	Function CreateShaderMaterial_:Byte Ptr( ShaderName:Byte Ptr )' = "CreateShaderMaterial"
	Function CreateFragShader_:Byte Ptr( shader:Byte Ptr,shaderFileName:Byte Ptr )' = "CreateFragShader"
	Function CreateFragShaderFromString_:Byte Ptr( shader:Byte Ptr,shadercode:Byte Ptr )' = "CreateFragShaderFromString"
	Function CreateVertShader_:Byte Ptr( shader:Byte Ptr,shaderFileName:Byte Ptr )' = "CreateVertShader"
	Function CreateVertShaderFromString_:Byte Ptr( shader:Byte Ptr,shadercode:Byte Ptr )' = "CreateVertShaderFromString"
	Function AttachFragShader_:Int( shader:Byte Ptr,myShader:Byte Ptr )' = "AttachFragShader"
	Function AttachVertShader_:Int( shader:Byte Ptr,myShader:Byte Ptr )' = "AttachVertShader"
	Function DeleteFragShader_( myShader:Byte Ptr )' = "DeleteFragShader"
	Function DeleteVertShader_( myShader:Byte Ptr )' = "DeleteVertShader"
	Function FreeShader_( shader:Byte Ptr )' = "FreeShader"
	Function FreeStencil_( stencil:Byte Ptr )' = "FreeStencil"
	Function TextureFlags_( tex:Byte Ptr,flags:Int )' = "TextureFlags"
	Function FreeSurface_( surf:Byte Ptr )' = "FreeSurface"
	Function TextureGLTexEnvi_( tex:Byte Ptr,target:Int,pname:Int,param:Int )' = "TextureGLTexEnvi"
	Function TextureGLTexEnvf_( tex:Byte Ptr,target:Int,pname:Int,param:Float )' = "TextureGLTexEnvf"
	Function BrushGLColor_( brush:Byte Ptr,r:Float,g:Float,b:Float,a:Float )' = "BrushGLColor"
	Function BrushGLBlendFunc_( brush:Byte Ptr,sfactor:Int,dfactor:Int )' = "BrushGLBlendFunc"
	
	' *** Minib3d only
	Function BackBufferToTex_( tex:Byte Ptr,frame:Int )' = "BackBufferToTex"
	Function MeshCullRadius_( ent:Byte Ptr,radius:Float )' = "MeshCullRadius"
	Function EntityScaleX_:Float( ent:Byte Ptr,glob:Int )' = "EntityScaleX"
	Function EntityScaleY_:Float( ent:Byte Ptr,glob:Int )' = "EntityScaleY"
	Function EntityScaleZ_:Float( ent:Byte Ptr,glob:Int )' = "EntityScaleZ"
	
	' *** Blitz3D functions, A-Z
	Function AddMesh_( mesh1:Byte Ptr,mesh2:Byte Ptr )' = "AddMesh"
	Function AddTriangle_:Int( surf:Byte Ptr,v0:Int,v1:Int,v2:Int )' = "AddTriangle"
	Function AddVertex_:Int( surf:Byte Ptr,x:Float,y:Float,z:Float,u:Float,v:Float,w:Float )' = "AddVertex"
	Function AmbientLight_( r:Float,g:Float,b:Float )' = "AmbientLight"
	Function Animate_( ent:Byte Ptr,Mode:Int,speed:Float,seq:Int,trans:Int )' = "Animate"
	Function Animating_:Int( ent:Byte Ptr )' = "Animating"
	Function AnimLength_( ent:Byte Ptr )' = "AnimLength"
	Function AnimSeq_:Int( ent:Byte Ptr )' = "AnimSeq"
	Function AnimTime_:Float( ent:Byte Ptr )' = "AnimTime"
	'Function AntiAlias_( samples:Int )' = "AntiAlias"
	Function BrushAlpha_( brush:Byte Ptr,a:Float )' = "BrushAlpha"
	Function BrushBlend_( brush:Byte Ptr,blend:Int )' = "BrushBlend"
	Function BrushColor_( brush:Byte Ptr,r:Float,g:Float,b:Float )' = "BrushColor"
	Function BrushFX_( brush:Byte Ptr,fx:Int )' = "BrushFX"
	Function BrushShininess_( brush:Byte Ptr,s:Float )' = "BrushShininess"
	Function BrushTexture_( brush:Byte Ptr,tex:Byte Ptr,frame:Int,index:Int )' = "BrushTexture"
	Function CameraClsColor_( cam:Byte Ptr,r:Float,g:Float,b:Float )' = "CameraClsColor"
	Function CameraClsMode_( cam:Byte Ptr,cls_depth:Int,cls_zbuffer:Int )' = "CameraClsMode"
	Function CameraFogColor_( cam:Byte Ptr,r:Float,g:Float,b:Float )' = "CameraFogColor"
	Function CameraFogMode_( cam:Byte Ptr,Mode:Int )' = "CameraFogMode"
	Function CameraFogRange_( cam:Byte Ptr,nnear:Float,nfar:Float )' = "CameraFogRange"
	Function CameraPick_:Byte Ptr( cam:Byte Ptr,x:Float,y:Float )' = "CameraPick"
	Function CameraProject_( cam:Byte Ptr,x:Float,y:Float,z:Float )' = "CameraProject"
	Function CameraProjMode_( cam:Byte Ptr,Mode:Int )' = "CameraProjMode"
	Function CameraRange_( cam:Byte Ptr,nnear:Float,nfar:Float )' = "CameraRange"
	Function CameraViewport_( cam:Byte Ptr,x:Int,y:Int,width:Int,height:Int )' = "CameraViewport"
	Function CameraZoom_( cam:Byte Ptr,zoom:Float )' = "CameraZoom"
	Function ClearCollisions_()' = "ClearCollisions"
	Function ClearSurface_( surf:Byte Ptr,clear_verts:Int,clear_tris:Int )' = "ClearSurface"
	Function ClearTextureFilters_()' = "ClearTextureFilters"
	Function ClearWorld_( entities:Int,brushes:Int,textures:Int )' = "ClearWorld"
	Function CollisionEntity_:Byte Ptr( ent:Byte Ptr,index:Int )' = "CollisionEntity"
	Function CollisionNX_:Float( ent:Byte Ptr,index:Int )' = "CollisionNX"
	Function CollisionNY_:Float( ent:Byte Ptr,index:Int )' = "CollisionNY"
	Function CollisionNZ_:Float( ent:Byte Ptr,index:Int )' = "CollisionNZ"
	Function Collisions_( src_no:Int,dest_no:Int,method_no:Int,response_no:Int )' = "Collisions"
	Function CollisionSurface_:Byte Ptr( ent:Byte Ptr,index:Int )' = "CollisionSurface"
	Function CollisionTime_:Float( ent:Byte Ptr,index:Int )' = "CollisionTime"
	Function CollisionTriangle_:Int( ent:Byte Ptr,index:Int )' = "CollisionTriangle"
	Function CollisionX_:Float( ent:Byte Ptr,index:Int )' = "CollisionX"
	Function CollisionY_:Float( ent:Byte Ptr,index:Int )' = "CollisionY"
	Function CollisionZ_:Float( ent:Byte Ptr,index:Int )' = "CollisionZ"
	Function CopyEntity_:Byte Ptr( ent:Byte Ptr,parent:Byte Ptr )' = "CopyEntity"
	Function CopyMesh_:Byte Ptr( mesh:Byte Ptr,parent:Byte Ptr )' = "CopyMesh"
	Function CountChildren_:Int( ent:Byte Ptr )' = "CountChildren"
	Function CountCollisions_:Int( ent:Byte Ptr )' = "CountCollisions"
	Function CountSurfaces_:Int( mesh:Byte Ptr )' = "CountSurfaces"
	Function CountTriangles_:Int( surf:Byte Ptr )' = "CountTriangles"
	Function CountVertices_:Int( surf:Byte Ptr )' = "CountVertices"
	Function CreateBrush_:Byte Ptr( r:Float,g:Float,b:Float )' = "CreateBrush"
	Function CreateCamera_:Byte Ptr( parent:Byte Ptr )' = "CreateCamera"
	Function CreateCone_:Byte Ptr( segments:Int,solid:Int,parent:Byte Ptr )' = "CreateCone"
	Function CreateCylinder_:Byte Ptr( segments:Int,solid:Int,parent:Byte Ptr )' = "CreateCylinder"
	Function CreateCube_:Byte Ptr( parent:Byte Ptr )' = "CreateCube"
	Function CreateMesh_:Byte Ptr( parent:Byte Ptr )' = "CreateMesh"
	Function CreateLight_:Byte Ptr( light_type:Int,parent:Byte Ptr )' = "CreateLight"
	Function CreatePivot_:Byte Ptr( parent:Byte Ptr )' = "CreatePivot"
	Function CreateSphere_:Byte Ptr( segments:Int,parent:Byte Ptr )' = "CreateSphere"
	Function CreateSprite_:Byte Ptr( parent:Byte Ptr )' = "CreateSprite"
	Function CreateSurface_:Byte Ptr( mesh:Byte Ptr,brush:Byte Ptr )' = "CreateSurface"
	Function CreateTexture_:Byte Ptr( width:Int,height:Int,flags:Int,frames:Int )' = "CreateTexture"
	Function DeltaPitch_:Float( ent1:Byte Ptr,ent2:Byte Ptr )' = "DeltaPitch"
	Function DeltaYaw_:Float( ent1:Byte Ptr,ent2:Byte Ptr )' = "DeltaYaw"
	Function EntityAlpha_( ent:Byte Ptr,alpha:Float )' = "EntityAlpha"
	'Function EntityAutoFade_( ent:Byte Ptr,near:Float,far:Float )' = "EntityAutoFade"
	Function EntityBlend_( ent:Byte Ptr,blend:Int )' = "EntityBlend"
	Function EntityBox_( ent:Byte Ptr,x:Float,y:Float,z:Float,w:Float,h:Float,d:Float )' = "EntityBox"
	Function EntityClass_:Byte Ptr( ent:Byte Ptr )' = "EntityClass"
	Function EntityCollided_:Byte Ptr( ent:Byte Ptr,type_no:Int )' = "EntityCollided"
	Function EntityColor_( ent:Byte Ptr,red:Float,green:Float,blue:Float )' = "EntityColor"
	Function EntityDistance_:Float( ent1:Byte Ptr,ent2:Byte Ptr )' = "EntityDistance"
	Function EntityFX_( ent:Byte Ptr,fx:Int )' = "EntityFX"
	Function EntityInView_:Int( ent:Byte Ptr,cam:Byte Ptr )' = "EntityInView"
	Function EntityName_:Byte Ptr( ent:Byte Ptr )' = "EntityName"
	Function EntityOrder_( ent:Byte Ptr,order:Int )' = "EntityOrder"
	Function EntityParent_( ent:Byte Ptr,parent_ent:Byte Ptr,glob:Int )' = "EntityParent"
	Function EntityPick_:Byte Ptr( ent:Byte Ptr,Range:Float )' = "EntityPick"
	Function EntityPickMode_( ent:Byte Ptr,pick_mode:Int,obscurer:Int )' = "EntityPickMode"
	Function EntityPitch_:Float( ent:Byte Ptr,glob:Int )' = "EntityPitch"
	Function EntityRadius_( ent:Byte Ptr,radius_x:Float,radius_y:Float )' = "EntityRadius"
	Function EntityRoll_:Float( ent:Byte Ptr,glob:Int )' = "EntityRoll"
	Function EntityShininess_( ent:Byte Ptr,shine:Float )' = "EntityShininess"
	Function EntityTexture_( ent:Byte Ptr,tex:Byte Ptr,frame:Int,index:Int )' = "EntityTexture"
	Function EntityType_( ent:Byte Ptr,type_no:Int,recursive:Int )' = "EntityType"
	Function EntityVisible_:Int( src_ent:Byte Ptr,dest_ent:Byte Ptr )' = "EntityVisible"
	Function EntityX_:Float( ent:Byte Ptr,glob:Int )' = "EntityX"
	Function EntityY_:Float( ent:Byte Ptr,glob:Int )' = "EntityY"
	Function EntityYaw_:Float( ent:Byte Ptr,glob:Int )' = "EntityYaw"
	Function EntityZ_:Float( ent:Byte Ptr,glob:Int )' = "EntityZ"
	Function ExtractAnimSeq_:Int( ent:Byte Ptr,first_frame:Int,last_frame:Int,seq:Int )' = "ExtractAnimSeq"
	Function FindChild_:Byte Ptr( ent:Byte Ptr,child_name:Byte Ptr )' = "FindChild"
	Function FindSurface_:Byte Ptr( mesh:Byte Ptr,brush:Byte Ptr )' = "FindSurface"
	Function FitMesh_( mesh:Byte Ptr,x:Float,y:Float,z:Float,width:Float,height:Float,depth:Float,uniform:Int )' = "FitMesh"
	Function FlipMesh_( mesh:Byte Ptr )' = "FlipMesh"
	Function FreeBrush_( brush:Byte Ptr )' = "FreeBrush"
	Function FreeEntity_( ent:Byte Ptr )' = "FreeEntity"
	Function FreeTexture_( tex:Byte Ptr )' = "FreeTexture"
	Function GetBrushTexture_:Byte Ptr( brush:Byte Ptr,index:Int )' = "GetBrushTexture"
	Function GetChild_:Byte Ptr( ent:Byte Ptr,child_no:Int )' = "GetChild"
	Function GetEntityBrush_:Byte Ptr( ent:Byte Ptr )' = "GetEntityBrush"
	Function GetEntityType_:Int( ent:Byte Ptr )' = "GetEntityType"
	'Function GetMatElement_:Float( ent:Byte Ptr,row:Int,col:Int )' = "GetMatElement"
	Function GetParentEntity_:Byte Ptr( ent:Byte Ptr )' = "GetParentEntity"
	Function GetSurface_:Byte Ptr( mesh:Byte Ptr,surf_no:Int )' = "GetSurface"
	Function GetSurfaceBrush_:Byte Ptr( surf:Byte Ptr )' = "GetSurfaceBrush"	
	Function Graphics3D_( width:Int,height:Int,depth:Int,mode:Int,rate:Int )' = "Graphics3D"
	Function HandleSprite_( sprite:Byte Ptr,h_x:Float,h_y:Float )' = "HandleSprite"
	Function HideEntity_( ent:Byte Ptr )' = "HideEntity"
	Function LightColor_( light:Byte Ptr,red:Float,green:Float,blue:Float )' = "LightColor"
	Function LightConeAngles_( light:Byte Ptr,inner_ang:Float,outer_ang:Float )' = "LightConeAngles"
	Function LightRange_( light:Byte Ptr,Range:Float )' = "LightRange"
	Function LinePick_:Byte Ptr( x:Float,y:Float,z:Float,dx:Float,dy:Float,dz:Float,radius:Float )' = "LinePick"
	Function LoadAnimMesh_:Byte Ptr( file:Byte Ptr,parent:Byte Ptr )' = "LoadAnimMesh"
	Function LoadAnimTexture_:Byte Ptr( file:Byte Ptr,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int,tex:Byte Ptr )' = "LoadAnimTexture"
	Function LoadBrush_:Byte Ptr( file:Byte Ptr,flags:Int,u_scale:Float,v_scale:Float )' = "LoadBrush"
	Function LoadMesh_:Byte Ptr( file:Byte Ptr,parent:Byte Ptr )' = "LoadMesh"
	Function LoadTexture_:Byte Ptr( file:Byte Ptr,flags:Int,tex:Byte Ptr )' = "LoadTexture"
	Function LoadSprite_:Byte Ptr( tex_file:Byte Ptr,tex_flag:Int,parent:Byte Ptr )' = "LoadSprite"
	Function MeshDepth_:Float( mesh:Byte Ptr )' = "MeshDepth"
	Function MeshHeight_:Float( mesh:Byte Ptr )' = "MeshHeight"
	Function MeshWidth_:Float( mesh:Byte Ptr )' = "MeshWidth"
	Function MoveEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float )' = "MoveEntity"
	Function NameEntity_( ent:Byte Ptr,name:Byte Ptr )' = "NameEntity"
	Function PaintEntity_( ent:Byte Ptr,brush:Byte Ptr )' = "PaintEntity"
	Function PaintMesh_( mesh:Byte Ptr,brush:Byte Ptr )' = "PaintMesh"
	Function PaintSurface_( surf:Byte Ptr,brush:Byte Ptr )' = "PaintSurface"
	Function PickedEntity_:Byte Ptr()' = "PickedEntity"
	Function PickedNX_:Float()' = "PickedNX"
	Function PickedNY_:Float()' = "PickedNY"
	Function PickedNZ_:Float()' = "PickedNZ"
	Function PickedSurface_:Byte Ptr()' = "PickedSurface"
	Function PickedTime_:Float()' = "PickedTime"
	Function PickedTriangle_:Int()' = "PickedTriangle"
	Function PickedX_:Float()' = "PickedX"
	Function PickedY_:Float()' = "PickedY"
	Function PickedZ_:Float()' = "PickedZ"
	Function PointEntity_( ent:Byte Ptr,target_ent:Byte Ptr,roll:Float )' = "PointEntity"
	Function PositionEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )' = "PositionEntity"
	Function PositionMesh_( mesh:Byte Ptr,px:Float,py:Float,pz:Float )' = "PositionMesh"
	Function PositionTexture_( tex:Byte Ptr,u_pos:Float,v_pos:Float )' = "PositionTexture"
	Function ProjectedX_:Float()' = "ProjectedX"
	Function ProjectedY_:Float()' = "ProjectedY"
	Function ProjectedZ_:Float()' = "ProjectedZ"
	Function RenderWorld_()' = "RenderWorld"
	Function ResetEntity_( ent:Byte Ptr )' = "ResetEntity"
	Function RotateEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )' = "RotateEntity"
	Function RotateMesh_( mesh:Byte Ptr,pitch:Float,yaw:Float,roll:Float )' = "RotateMesh"
	Function RotateSprite_( sprite:Byte Ptr,ang:Float )' = "RotateSprite"
	Function RotateTexture_( tex:Byte Ptr,ang:Float )' = "RotateTexture"
	Function ScaleEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )' = "ScaleEntity"
	Function ScaleMesh_( mesh:Byte Ptr,sx:Float,sy:Float,sz:Float )' = "ScaleMesh"
	Function ScaleSprite_( sprite:Byte Ptr,s_x:Float,s_y:Float )' = "ScaleSprite"
	Function ScaleTexture_( tex:Byte Ptr,u_scale:Float,v_scale:Float )' = "ScaleTexture"
	Function SetAnimTime_( ent:Byte Ptr,time:Float,seq:Int )' = "SetAnimTime"
	Function SetCubeFace_( tex:Byte Ptr,face:Int )' = "SetCubeFace"
	Function SetCubeMode_( tex:Byte Ptr,Mode:Int )' = "SetCubeMode"
	Function ShowEntity_( ent:Byte Ptr )' = "ShowEntity"
	Function SpriteViewMode_( sprite:Byte Ptr,Mode:Int )' = "SpriteViewMode"
	Function TextureBlend_( tex:Byte Ptr,blend:Int )' = "TextureBlend"
	Function TextureCoords_( tex:Byte Ptr,coords:Int )' = "TextureCoords"
	Function TextureHeight_:Int( tex:Byte Ptr )' = "TextureHeight"
	Function TextureFilter_( match_text:Byte Ptr,flags:Int )' = "TextureFilter"
	Function TextureName_:Byte Ptr( tex:Byte Ptr )' = "TextureName"
	Function TextureWidth_:Int( tex:Byte Ptr )' = "TextureWidth"
	Function TFormedX_:Float()' = "TFormedX"
	Function TFormedY_:Float()' = "TFormedY"
	Function TFormedZ_:Float()' = "TFormedZ"
	Function TFormNormal_( x:Float,y:Float,z:Float,src_ent:Byte Ptr,dest_ent:Byte Ptr )' = "TFormNormal"
	Function TFormPoint_( x:Float,y:Float,z:Float,src_ent:Byte Ptr,dest_ent:Byte Ptr )' = "TFormPoint"
	Function TFormVector_( x:Float,y:Float,z:Float,src_ent:Byte Ptr,dest_ent:Byte Ptr )' = "TFormVector"
	Function TranslateEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )' = "TranslateEntity"
	Function TriangleVertex_:Int( surf:Byte Ptr,tri_no:Int,corner:Int )' = "TriangleVertex"
	Function TurnEntity_( ent:Byte Ptr,x:Float,y:Float,z:Float,glob:Int )' = "TurnEntity"
	Function UpdateNormals_( mesh:Byte Ptr )' = "UpdateNormals"
	Function UpdateWorld_( anim_speed:Float )' = "UpdateWorld"
	Function VectorPitch_:Float( vx:Float,vy:Float,vz:Float )' = "VectorPitch"
	Function VectorYaw_:Float( vx:Float,vy:Float,vz:Float )' = "VectorYaw"
	Function VertexAlpha_:Float( surf:Byte Ptr,vid:Int )' = "VertexAlpha"
	Function VertexBlue_:Float( surf:Byte Ptr,vid:Int )' = "VertexBlue"
	Function VertexColor_( surf:Byte Ptr,vid:Int,r:Float,g:Float,b:Float,a:Float )' = "VertexColor"
	Function VertexCoords_( surf:Byte Ptr,vid:Int,x:Float,y:Float,z:Float )' = "VertexCoords"
	Function VertexGreen_:Float( surf:Byte Ptr,vid:Int )' = "VertexGreen"
	Function VertexNormal_( surf:Byte Ptr,vid:Int,nx:Float,ny:Float,nz:Float )' = "VertexNormal"
	Function VertexNX_:Float( surf:Byte Ptr,vid:Int )' = "VertexNX"
	Function VertexNY_:Float( surf:Byte Ptr,vid:Int )' = "VertexNY"
	Function VertexNZ_:Float( surf:Byte Ptr,vid:Int )' = "VertexNZ"
	Function VertexRed_:Float( surf:Byte Ptr,vid:Int )' = "VertexRed"
	Function VertexTexCoords_( surf:Byte Ptr,vid:Int,u:Float,v:Float,w:Float,coord_set:Int )' = "VertexTexCoords"
	Function VertexU_:Float( surf:Byte Ptr,vid:Int,coord_set:Int )' = "VertexU"
	Function VertexV_:Float( surf:Byte Ptr,vid:Int,coord_set:Int )' = "VertexV"
	Function VertexW_:Float( surf:Byte Ptr,vid:Int,coord_set:Int )' = "VertexW"
	Function VertexX_:Float( surf:Byte Ptr,vid:Int )' = "VertexX"
	Function VertexY_:Float( surf:Byte Ptr,vid:Int )' = "VertexY"
	Function VertexZ_:Float( surf:Byte Ptr,vid:Int )' = "VertexZ"
	Function Wireframe_( enable:Int )' = "Wireframe"
	
	' *** Blitz3D functions, A-Z (in Openb3d)
	Function AddAnimSeq_:Int( ent:Byte Ptr,length:Int )' = "AddAnimSeq"
	'AlignToVector_ is in Openb3dlib.mod
	Function CreatePlane_:Byte Ptr( divisions:Int,parent:Byte Ptr )' = "CreatePlane"
	Function CreateTerrain_:Byte Ptr( size:Int,parent:Byte Ptr )' = "CreateTerrain"
	Function LoadAnimSeq_:Int( ent:Byte Ptr,file:Byte Ptr )' = "LoadAnimSeq"
	Function LoadTerrain_:Byte Ptr( file:Byte Ptr,parent:Byte Ptr )' = "LoadTerrain"
	Function MeshesIntersect_:Int( mesh1:Byte Ptr,mesh2:Byte Ptr )' = "MeshesIntersect"
	Function ModifyTerrain_( terr:Byte Ptr,x:Int,z:Int,new_height:Float )' = "ModifyTerrain"
	Function SetAnimKey_( ent:Byte Ptr,frame:Float,pos_key:Int,rot_key:Int,scale_key:Int )' = "SetAnimKey"
	Function TerrainHeight_:Float( terr:Byte Ptr,x:Int,z:Int )' = "TerrainHeight"
	Function TerrainX_:Float( terr:Byte Ptr,x:Float,y:Float,z:Float )' = "TerrainX"
	Function TerrainY_:Float( terr:Byte Ptr,x:Float,y:Float,z:Float )' = "TerrainY"
	Function TerrainZ_:Float( terr:Byte Ptr,x:Float,y:Float,z:Float )' = "TerrainZ"
	
	' *** Openb3d only
	Function BufferToTex_( tex:Byte Ptr,buffer:Byte Ptr,frame:Int )' = "BufferToTex"
	Function CameraToTex_( tex:Byte Ptr,cam:Byte Ptr,frame:Int )' = "CameraToTex"
	Function CreateBone_:Byte Ptr( mesh:Byte Ptr,parent_ent:Byte Ptr )' = "CreateBone"
	Function CreateQuad_:Byte Ptr( parent:Byte Ptr )' = "CreateQuad"
	Function DepthBufferToTex_( tex:Byte Ptr,cam:Byte Ptr )' = "DepthBufferToTex"
	Function MeshCSG_:Byte Ptr( m1:Byte Ptr,m2:Byte Ptr,method_no:Int )' = "MeshCSG"
	Function RepeatMesh_:Byte Ptr( mesh:Byte Ptr,parent:Byte Ptr )' = "RepeatMesh"
	Function SkinMesh_( mesh:Byte Ptr,surf_no_get:Int,vid:Int,bone1:Int,weight1:Float,bone2:Int,weight2:Float,bone3:Int,weight3:Float,bone4:Int,weight4:Float )' = "SkinMesh"
	Function SpriteRenderMode_( sprite:Byte Ptr,Mode:Int )' = "SpriteRenderMode"
	Function TexToBuffer_( tex:Byte Ptr,buffer:Byte Ptr,frame:Int )' = "TexToBuffer"
	Function UpdateTexCoords_( surf:Byte Ptr )' = "UpdateTexCoords"
	
	' *** Action
	Function ActMoveBy_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "ActMoveBy"
	Function ActTurnBy_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "ActTurnBy"
	Function ActVector_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float )' = "ActVector"
	Function ActMoveTo_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "ActMoveTo"
	Function ActTurnTo_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "ActTurnTo"
	Function ActScaleTo_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "ActScaleTo"
	Function ActFadeTo_:Byte Ptr( ent:Byte Ptr,a:Float,rate:Float )' = "ActFadeTo"
	Function ActTintTo_:Byte Ptr( ent:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "ActTintTo"
	Function ActTrackByPoint_:Byte Ptr( ent:Byte Ptr,target:Byte Ptr,a:Float,b:Float,c:Float,rate:Float )' = "ActTrackByPoint"
	Function ActTrackByDistance_:Byte Ptr( ent:Byte Ptr,target:Byte Ptr,a:Float,rate:Float )' = "ActTrackByDistance"
	Function ActNewtonian_:Byte Ptr( ent:Byte Ptr,rate:Float )' = "ActNewtonian"
	Function AppendAction_( act1:Byte Ptr,act2:Byte Ptr )' = "AppendAction"
	Function FreeAction_( act:Byte Ptr )' = "FreeAction"
	Function EndAction_( act:Byte Ptr )' = "EndAction"
	
	' *** Constraint
	Function CreateConstraint_:Byte Ptr( p1:Byte Ptr,p2:Byte Ptr,l:Float )' = "CreateConstraint"
	Function CreateRigidBody_:Byte Ptr( body:Byte Ptr,p1:Byte Ptr,p2:Byte Ptr,p3:Byte Ptr,p4:Byte Ptr )' = "CreateRigidBody"
	
	' *** Fluid
	Function CreateBlob_:Byte Ptr( fluid:Byte Ptr,radius:Float,parent_ent:Byte Ptr )' = "CreateBlob"
	Function CreateFluid_:Byte Ptr()' = "CreateFluid"
	Function FluidArray_( fluid:Byte Ptr,Array:Float Ptr,w:Int,h:Int,d:Int)' = "FluidArray"
	Function FluidFunction_( fluid:Byte Ptr,FieldFunction:Float( x:Float,y:Float,z:Float ) )' = "FluidFunction"
	Function FluidThreshold_( fluid:Byte Ptr,threshold:Float )' = "FluidThreshold"
	
	' *** Geosphere
	Function CreateGeosphere_:Byte Ptr( size:Int,parent:Byte Ptr )' = "CreateGeosphere"
	Function GeosphereHeight_( geo:Byte Ptr,h:Float )' = "GeosphereHeight"
	Function LoadGeosphere_:Byte Ptr( file:Byte Ptr,parent:Byte Ptr )' = "LoadGeosphere"
	Function ModifyGeosphere_( geo:Byte Ptr,x:Int,z:Int,new_height:Float )' = "ModifyGeosphere"
	
	' *** Octree
	Function CreateOcTree_:Byte Ptr( w:Float,h:Float,d:Float,parent_ent:Byte Ptr )' = "CreateOcTree"
	Function OctreeBlock_( octree:Byte Ptr,mesh:Byte Ptr,level:Int,X:Float,Y:Float,Z:Float,Near:Float,Far:Float )' = "OctreeBlock"
	Function OctreeMesh_( octree:Byte Ptr,mesh:Byte Ptr,level:Int,X:Float,Y:Float,Z:Float,Near:Float,Far:Float )' = "OctreeMesh"
	
	' *** Particle
	Function CreateParticleEmitter_:Byte Ptr( particle:Byte Ptr,parent_ent:Byte Ptr )' = "CreateParticleEmitter"
	Function EmitterVector_( emit:Byte Ptr,x:Float,y:Float,z:Float )' = "EmitterVector"
	Function EmitterRate_( emit:Byte Ptr,r:Float )' = "EmitterRate"
	Function EmitterParticleLife_( emit:Byte Ptr,l:Int )' = "EmitterParticleLife"
	Function EmitterParticleFunction_( emit:Byte Ptr,EmitterFunction( ent:Byte Ptr,life:Int ) )' = "EmitterParticleFunction"
	Function EmitterParticleSpeed_( emit:Byte Ptr,s:Float )' = "EmitterParticleSpeed"
	Function EmitterVariance_( emit:Byte Ptr,v:Float )' = "EmitterVariance"
	Function ParticleColor_( sprite:Byte Ptr,r:Float,g:Float,b:Float,a:Float )' = "ParticleColor"
	Function ParticleVector_( sprite:Byte Ptr,x:Float,y:Float,z:Float )' = "ParticleVector"
	Function ParticleTrail_( sprite:Byte Ptr,length:Int )' = "ParticleTrail"
	
	' *** Shader
	Function LoadShader_:Byte Ptr( ShaderName:Byte Ptr,VshaderFileName:Byte Ptr,FshaderFileName:Byte Ptr )' = "LoadShader"
	Function CreateShader_:Byte Ptr( ShaderName:Byte Ptr,VshaderString:Byte Ptr,FshaderString:Byte Ptr )' = "CreateShader"
	Function ShadeSurface_( surf:Byte Ptr,material:Byte Ptr )' = "ShadeSurface"
	Function ShadeMesh_( mesh:Byte Ptr,material:Byte Ptr )' = "ShadeMesh"
	Function ShadeEntity_( ent:Byte Ptr,material:Byte Ptr )' = "ShadeEntity"
	Function ShaderTexture_:Byte Ptr( material:Byte Ptr,tex:Byte Ptr,name:Byte Ptr,index:Int )' = "ShaderTexture"
	Function SetFloat_( material:Byte Ptr,name:Byte Ptr,v1:Float )' = "SetFloat"
	Function SetFloat2_( material:Byte Ptr,name:Byte Ptr,v1:Float,v2:Float )' = "SetFloat2"
	Function SetFloat3_( material:Byte Ptr,name:Byte Ptr,v1:Float,v2:Float,v3:Float )' = "SetFloat3"
	Function SetFloat4_( material:Byte Ptr,name:Byte Ptr,v1:Float,v2:Float,v3:Float,v4:Float )' = "SetFloat4"
	Function UseFloat_( material:Byte Ptr,name:Byte Ptr,v1:Float Ptr )' = "UseFloat"
	Function UseFloat2_( material:Byte Ptr,name:Byte Ptr,v1:Float Ptr,v2:Float Ptr )' = "UseFloat2"
	Function UseFloat3_( material:Byte Ptr,name:Byte Ptr,v1:Float Ptr,v2:Float Ptr,v3:Float Ptr )' = "UseFloat3"
	Function UseFloat4_( material:Byte Ptr,name:Byte Ptr,v1:Float Ptr,v2:Float Ptr,v3:Float Ptr,v4:Float Ptr )' = "UseFloat4"
	Function SetInteger_( material:Byte Ptr,name:Byte Ptr,v1:Int )' = "SetInteger"
	Function SetInteger2_( material:Byte Ptr,name:Byte Ptr,v1:Int,v2:Int )' = "SetInteger2"
	Function SetInteger3_( material:Byte Ptr,name:Byte Ptr,v1:Int,v2:Int,v3:Int )' = "SetInteger3"
	Function SetInteger4_( material:Byte Ptr,name:Byte Ptr,v1:Int,v2:Int,v3:Int,v4:Int )' = "SetInteger4"
	Function UseInteger_( material:Byte Ptr,name:Byte Ptr,v1:Int Ptr )' = "UseInteger"
	Function UseInteger2_( material:Byte Ptr,name:Byte Ptr,v1:Int Ptr,v2:Int Ptr )' = "UseInteger2"
	Function UseInteger3_( material:Byte Ptr,name:Byte Ptr,v1:Int Ptr,v2:Int Ptr,v3:Int Ptr )' = "UseInteger3"
	Function UseInteger4_( material:Byte Ptr,name:Byte Ptr,v1:Int Ptr,v2:Int Ptr,v3:Int Ptr,v4:Int Ptr )' = "UseInteger4"
	Function UseSurface_( material:Byte Ptr,name:Byte Ptr,surf:Byte Ptr,vbo:Int )' = "UseSurface"
	Function UseMatrix_( material:Byte Ptr,name:Byte Ptr,Mode:Int )' = "UseMatrix"
	Function LoadMaterial_:Byte Ptr( filename:Byte Ptr,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int )' = "LoadMaterial"
	Function ShaderMaterial_( material:Byte Ptr,tex:Byte Ptr,name:Byte Ptr,index:Int )' = "ShaderMaterial"
	Function AmbientShader_( material:Byte Ptr )' = "AmbientShader"
	
	' *** Shadow
	Function CreateShadow_:Byte Ptr( parent:Byte Ptr,Static:Int )' = "CreateShadow"
	Function FreeShadow_( shad:Byte Ptr )' = "FreeShadow"
	
	' *** Stencil
	Function CreateStencil_:Byte Ptr()' = "CreateStencil"
	Function StencilAlpha_( stencil:Byte Ptr,a:Float )' = "StencilAlpha"
	Function StencilClsColor_( stencil:Byte Ptr,r:Float,g:Float,b:Float )' = "StencilClsColor"
	Function StencilClsMode_( stencil:Byte Ptr,cls_color:Int,cls_zbuffer:Int )' = "StencilClsMode"
	Function StencilMesh_( stencil:Byte Ptr,mesh:Byte Ptr,Mode:Int )' = "StencilMesh"
	Function StencilMode_( stencil:Byte Ptr,m:Int,o:Int )' = "StencilMode"
	Function UseStencil_( stencil:Byte Ptr )' = "UseStencil"
	
	' *** VoxelSprite
	Function CreateVoxelSprite_:Byte Ptr( slices:Int,parent:Byte Ptr )' = "CreateVoxelSprite"
	Function VoxelSpriteMaterial_( voxelspr:Byte Ptr,mat:Byte Ptr )' = "VoxelSpriteMaterial"
	
End Extern

' *** Constants

'Const USE_MAX2D:Int=True	' True to enable Max2d in 3d integration
'Const USE_VBO:Int=True		' True to use vbos if supported by hardware
'Const VBO_MIN_TRIS:Int=250	' if USE_VBO=True and vbos are supported by hardware, then surface must also have this minimum no.
							' of tris before vbo is used for surface (vbos work best with surfaces with high amount of tris)

Global LOG_NEW:Int=False		' True to DebugLog when new 3d object created
Global LOG_DEL:Int=False		' True to DebugLog when 3d object destroyed
Global LOG_B3D:Int=False		' True to DebugLog B3D chunks
Global LOG_MD2:Int=False		' True to DebugLog MD2 chunks
Global LOG_3DS:Int=False		' True to DebugLog 3DS chunks

Global TEXTURE_LOADER:Int=1		' 1 for stream texture loaders (with OpenB3dMax.StbImageLoader), 2 for library loaders
Global MESH_LOADER:Int=1		' 1 for stream mesh loaders, 2 for library loaders

Global MATRIX_3DS:TMatrix=NewMatrix()
Global MATRIX_B3D:TMatrix=NewMatrix()

' Texture/Brush flags
Const TEX_COLOR:Int=1
Const TEX_ALPHA:Int=2
Const TEX_MASKED:Int=4
Const TEX_MIPMAP:Int=8
Const TEX_CLAMPU:Int=16
Const TEX_CLAMPV:Int=32
Const TEX_SPHEREMAP:Int=64
Const TEX_CUBEMAP:Int=128
Const TEX_VRAM:Int=256
Const TEX_HIGHCOLOR:Int=512 ' 1024,2048,4096,8192,16384 unassigned AFAIK
Const TEX_FLIPX:Int=8192 ' new, used in LoadAnimTextureStream
Const TEX_FLIPY:Int=16384 ' new
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
about: Only field lists currently supported, either mesh with surf_list, anim_surf_list, bones or ent with child_list.
EndRem
Function EntityListAdd( list:TList,value:Object,ent:TEntity )
	TGlobal.EntityListAdd( list,value,ent )
End Function

Rem
bbdoc: Add an existing surface to a mesh.
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
Include "inc/TTerrain.bmx"
Include "inc/TShader.bmx"
Include "inc/TShadowObject.bmx"
Include "inc/THardwareInfo.bmx"
'Include "inc/TGLShader.bmx" ' AdamStrange
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
