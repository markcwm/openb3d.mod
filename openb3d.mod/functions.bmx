' functions.bmx

' Wrapper functions with Byte Ptr arguments
' -----------------------------------------

' Minib3d Only

Rem
bbdoc: undocumented
End Rem
Function MeshCullRadius( ent:TEntity, radius:Float )
	MeshCullRadius_( ent.instance, radius )
End Function

' Blitz3D functions, A-Z

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddAnimSeq">Online doc</a>
End Rem
Function AddAnimSeq:Int( ent:TEntity, length:Int )
	Return AddAnimSeq_( ent.instance, length )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddMesh">Online doc</a>
End Rem
Function AddMesh( mesh1:TMesh, mesh2:TMesh )
	AddMesh_( mesh1.instance, mesh2.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddTriangle">Online doc</a>
End Rem
Function AddTriangle:Int( surf:TSurface, v0:Int, v1:Int, v2:Int )
	Return AddTriangle_( surf.instance, v0, v1, v2 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animating">Online doc</a>
End Rem
Function Animating:Int( ent:TEntity )
	Return Animating_( ent.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimLength">Online doc</a>
End Rem
Function AnimLength( ent:TEntity )
	AnimLength_( ent.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimSeq">Online doc</a>
End Rem
Function AnimSeq:Int( ent:TEntity )
	Return AnimSeq_( ent.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimTime">Online doc</a>
End Rem
Function AnimTime:Float( ent:TEntity )
	Return AnimTime_( ent.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushAlpha">Online doc</a>
End Rem
Function BrushAlpha( brush:TBrush, a:Float )
	BrushAlpha_( brush.instance, a )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushBlend">Online doc</a>
End Rem
Function BrushBlend( brush:TBrush, blend:Int )
	BrushBlend_( brush.instance, blend )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushColor">Online doc</a>
End Rem
Function BrushColor( brush:TBrush, r:Float, g:Float, b:Float )
	BrushColor_( brush.instance, r, g, b )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushFX">Online doc</a>
End Rem
Function BrushFX( brush:TBrush, fx:Int )
	BrushFX_( brush.instance, fx )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushShininess">Online doc</a>
End Rem
Function BrushShininess( brush:TBrush, s:Float )
	BrushShininess_( brush.instance, s )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsColor">Online doc</a>
End Rem
Function CameraClsColor( cam:TCamera, r:Float, g:Float, b:Float )
	CameraClsColor_( cam.instance, r, g, b )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsMode">Online doc</a>
End Rem
Function CameraClsMode( cam:TCamera, cls_depth:Int, cls_zbuffer:Int )
	CameraClsMode_( cam.instance, cls_depth, cls_zbuffer )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogColor">Online doc</a>
End Rem
Function CameraFogColor( cam:TCamera, r:Float, g:Float, b:Float )
	CameraFogColor_( cam.instance, r, g, b )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogMode">Online doc</a>
End Rem
Function CameraFogMode( cam:TCamera, Mode:Int )
	CameraFogMode_( cam.instance, Mode )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogRange">Online doc</a>
End Rem
Function CameraFogRange( cam:TCamera, nnear:Float, nfar:Float )
	CameraFogRange_( cam.instance, nnear, nfar )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraPick">Online doc</a>
End Rem
Function CameraPick:TEntity( cam:TCamera, x:Float, y:Float )
	Return globals.ent.EntityValue( CameraPick_( cam.instance, x, GraphicsHeight()-y ) ) ' inverted y
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProject">Online doc</a>
End Rem
Function CameraProject( cam:TCamera, x:Float, y:Float, z:Float )
	CameraProject_( cam.instance, x, y, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProjMode">Online doc</a>
End Rem
Function CameraProjMode( cam:TCamera, Mode:Int )
	CameraProjMode_( cam.instance, Mode )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraRange">Online doc</a>
End Rem
Function CameraRange( cam:TCamera, nnear:Float, nfar:Float )
	CameraRange_( cam.instance, nnear, nfar )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraViewport">Online doc</a>
End Rem
Function CameraViewport( cam:TCamera, x:Int, y:Int, width:Int, height:Int )
	CameraViewport_( cam.instance, x, GraphicsHeight()-height, width, height ) ' inverted y
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraZoom">Online doc</a>
End Rem
Function CameraZoom( cam:TCamera, zoom:Float )
	CameraZoom_( cam.instance, zoom )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionEntity">Online doc</a>
End Rem
Function CollisionEntity:TEntity( ent:TEntity, index:Int )
	Return globals.ent.EntityValue( CollisionEntity_( ent.instance, index ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNX">Online doc</a>
End Rem
Function CollisionNX:Float( ent:TEntity, index:Int )
	Return CollisionNX_( ent.instance, index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNY">Online doc</a>
End Rem
Function CollisionNY:Float( ent:TEntity, index:Int )
	Return CollisionNY_( ent.instance, index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNZ">Online doc</a>
End Rem
Function CollisionNZ:Float( ent:TEntity, index:Int )
	Return CollisionNZ_( ent.instance, index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionSurface">Online doc</a>
End Rem
Function CollisionSurface:TSurface( ent:TEntity, index:Int )
	Local instance:Byte Ptr=CollisionSurface_( ent.instance, index )
	Local surf:TSurface=globals.surf.SurfaceValue( instance )
	If surf=Null And instance<>Null Then surf=globals.surf.NewSurface( instance )
	Return surf
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTime">Online doc</a>
End Rem
Function CollisionTime:Float( ent:TEntity, index:Int )
	Return CollisionTime_( ent.instance, index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTriangle">Online doc</a>
End Rem
Function CollisionTriangle:Int( ent:TEntity, index:Int )
	Return CollisionTriangle_( ent.instance, index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionX">Online doc</a>
End Rem
Function CollisionX:Float( ent:TEntity, index:Int )
	Return CollisionX_( ent.instance, index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionY">Online doc</a>
End Rem
Function CollisionY:Float( ent:TEntity, index:Int )
	Return CollisionY_( ent.instance, index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionZ">Online doc</a>
End Rem
Function CollisionZ:Float( ent:TEntity, index:Int )
	Return CollisionZ_( ent.instance, index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountChildren">Online doc</a>
End Rem
Function CountChildren:Int( ent:TEntity )
	Return CountChildren_( ent.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountCollisions">Online doc</a>
End Rem
Function CountCollisions:Int( ent:TEntity )
	Return CountCollisions_( ent.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountSurfaces">Online doc</a>
End Rem
Function CountSurfaces:Int( mesh:TMesh )
	Return CountSurfaces_( mesh.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountTriangles">Online doc</a>
End Rem
Function CountTriangles:Int( surf:TSurface )
	Return CountTriangles_( surf.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountVertices">Online doc</a>
End Rem
Function CountVertices:Int( surf:TSurface )
	Return CountVertices_( surf.instance )
End Function

Rem
bbdoc: undocumented
End Rem
Function CreateStencil:TStencil()
	Local instance:Byte Ptr=CreateStencil_()
	Local stencil:TStencil=globals.stencil.NewStencil( instance )
	Return stencil
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaPitch">Online doc</a>
End Rem
Function DeltaPitch:Float( ent1:TEntity, ent2:TEntity )
	Return -DeltaPitch_( ent1.instance, ent2.instance ) ' inverted pitch
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaYaw">Online doc</a>
End Rem
Function DeltaYaw:Float( ent1:TEntity, ent2:TEntity )
	Return DeltaYaw_( ent1.instance, ent2.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAlpha">Online doc</a>
End Rem
Function EntityAlpha( ent:TEntity, alpha:Float )
	EntityAlpha_( ent.instance, alpha )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAutoFade">Online doc</a>
End Rem
Function EntityAutoFade( ent:TEntity, near:Float, far:Float )
	EntityAutoFade_( ent.instance, near, far )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBlend">Online doc</a>
End Rem
Function EntityBlend( ent:TEntity, blend:Int )
	EntityBlend_( ent.instance, blend )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBox">Online doc</a>
End Rem
Function EntityBox( ent:TEntity, x:Float, y:Float, z:Float, w:Float, h:Float, d:Float )
	EntityBox_( ent.instance, x, y, z, w, h, d )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityClass">Online doc</a>
End Rem
Function EntityClass:String( ent:TEntity )
	Return String.FromCString( EntityClass_( ent.instance ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityCollided">Online doc</a>
End Rem
Function EntityCollided:TEntity( ent:TEntity, type_no:Int )
	Return globals.ent.EntityValue( EntityCollided_( ent.instance, type_no ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityColor">Online doc</a>
End Rem
Function EntityColor( ent:TEntity, red:Float, green:Float, blue:Float )
	EntityColor_( ent.instance, red, green, blue )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityDistance">Online doc</a>
End Rem
Function EntityDistance:Float( ent1:TEntity, ent2:TEntity )
	Return EntityDistance_( ent1.instance, ent2.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityFX">Online doc</a>
End Rem
Function EntityFX( ent:TEntity, fx:Int )
	EntityFX_( ent.instance, fx )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityInView">Online doc</a>
End Rem
Function EntityInView:Int( ent:TEntity, cam:TCamera )
	Return EntityInView_( ent.instance, cam.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityName">Online doc</a>
End Rem
Function EntityName:String( ent:TEntity )
	Return String.FromCString( EntityName_( ent.instance ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityOrder">Online doc</a>
End Rem
Function EntityOrder( ent:TEntity, order:Int )
	EntityOrder_( ent.instance, order )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPick">Online doc</a>
End Rem
Function EntityPick:TEntity( ent:TEntity, Range:Float )
	Return globals.ent.EntityValue( EntityPick_( ent.instance, Range ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityShininess">Online doc</a>
End Rem
Function EntityShininess( ent:TEntity, shine:Float )
	EntityShininess_( ent.instance, shine )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityVisible">Online doc</a>
End Rem
Function EntityVisible:Int( src_ent:TEntity, dest_ent:TEntity )
	Return EntityVisible_( src_ent.instance, dest_ent.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindChild">Online doc</a>
End Rem
Function FindChild:TEntity( ent:TEntity, child_name:String )
	Local instance:Byte Ptr=FindChild_( ent.instance, child_name.ToCString() )
	Local child:TEntity=globals.ent.EntityValue( instance )
	If child=Null And instance<>Null Then child=globals.ent.NewEntity( instance )
	Return child
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindSurface">Online doc</a>
End Rem
Function FindSurface:TSurface( mesh:TMesh, brush:TBrush )
	Local instance:Byte Ptr=FindSurface_( mesh.instance, brush.instance )
	Local surf:TSurface=globals.surf.SurfaceValue( instance )
	If surf=Null And instance<>Null Then surf=globals.surf.NewSurface( instance )
	Return surf
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FlipMesh">Online doc</a>
End Rem
Function FlipMesh( mesh:TMesh )
	FlipMesh_( mesh.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeBrush">Online doc</a>
End Rem
Function FreeBrush( brush:TBrush )
	brush.DeleteBrush( brush.instance )
	FreeBrush_( brush.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeEntity">Online doc</a>
End Rem
Function FreeEntity( ent:TEntity )
	ent.DeleteEntity( ent.instance )
	FreeEntity_( ent.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeTexture">Online doc</a>
End Rem
Function FreeTexture( tex:TTexture )
	tex.DeleteTexture( tex.instance )
	FreeTexture_( tex.instance )
End Function

Rem
bbdoc: undocumented
End Rem
Function GeosphereHeight( geo:TGeosphere, h:Float )
	GeosphereHeight_( geo.instance, h )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetChild">Online doc</a>
End Rem
Function GetChild:TEntity( ent:TEntity, child_no:Int )
	Local instance:Byte Ptr=GetChild_( ent.instance, child_no )
	Local child:TEntity=globals.ent.EntityValue( instance )
	If child=Null And instance<>Null Then child=globals.ent.NewEntity( instance )
	Return child
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityBrush">Online doc</a>
End Rem
Function GetEntityBrush:TBrush( ent:TEntity )
	Local instance:Byte Ptr=GetEntityBrush_( ent.instance )
	Local brush:TBrush=globals.brush.BrushValue( instance )
	If brush=Null And instance<>Null Then brush=globals.brush.NewBrush( instance )
	Return brush
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityType">Online doc</a>
End Rem
Function GetEntityType:Int( ent:TEntity )
	Return GetEntityType_( ent.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetMatElement">Online doc</a>
End Rem
Function GetMatElement:Float( ent:TEntity, row:Int, col:Int )
	Return GetMatElement_( ent.instance, row, col )
End Function

Rem
bbdoc: undocumented
End Rem
Function GetParentEntity:TEntity( ent:TEntity )
	Return globals.ent.EntityValue( GetParentEntity_( ent.instance ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurface">Online doc</a>
End Rem
Function GetSurface:TSurface( mesh:TMesh, surf_no:Int )
	Local instance:Byte Ptr=GetSurface_( mesh.instance, surf_no )
	Local surf:TSurface=globals.surf.SurfaceValue( instance )
	If surf=Null And instance<>Null Then surf=globals.surf.NewSurface( instance )
	Return surf
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurfaceBrush">Online doc</a>
End Rem
Function GetSurfaceBrush:TBrush( surf:TSurface )
	Local instance:Byte Ptr=GetSurfaceBrush_( surf.instance )
	Local brush:TBrush=globals.brush.BrushValue( instance )
	If brush=Null And instance<>Null Then brush=globals.brush.NewBrush( instance )
	Return brush
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HandleSprite">Online doc</a>
End Rem
Function HandleSprite( sprite:TSprite, h_x:Float, h_y:Float )
	HandleSprite_( sprite.instance, h_x, h_y )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HideEntity">Online doc</a>
End Rem
Function HideEntity( ent:TEntity )
	HideEntity_( ent.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightColor">Online doc</a>
End Rem
Function LightColor( light:TLight, red:Float, green:Float, blue:Float )
	LightColor_( light.instance, red, green, blue )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightConeAngles">Online doc</a>
End Rem
Function LightConeAngles( light:TLight, inner_ang:Float, outer_ang:Float )
	LightConeAngles_( light.instance, inner_ang, outer_ang )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightRange">Online doc</a>
End Rem
Function LightRange( light:TLight, Range:Float )
	LightRange_( light.instance, Range )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimTexture">Online doc</a>
End Rem
Function LoadAnimTexture:TTexture( file:String, flags:Int, frame_width:Int, frame_height:Int, first_frame:Int, frame_count:Int )
	Local instance:Byte Ptr=LoadAnimTexture_( file.ToCString(), flags, frame_width, frame_height, first_frame, frame_count )
	Local tex:TTexture=globals.tex.NewTexture( instance )
	Return tex
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshDepth">Online doc</a>
End Rem
Function MeshDepth:Float( mesh:TMesh )
	Return MeshDepth_( mesh.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshesIntersect">Online doc</a>
End Rem
Function MeshesIntersect:Int( mesh1:TMesh, mesh2:TMesh )
	Return MeshesIntersect_( mesh1.instance, mesh2.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshHeight">Online doc</a>
End Rem
Function MeshHeight:Float( mesh:TMesh )
	Return MeshHeight_( mesh.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshWidth">Online doc</a>
End Rem
Function MeshWidth:Float( mesh:TMesh )
	Return MeshWidth_( mesh.instance )
End Function

Rem
bbdoc: undocumented
End Rem
Function ModifyGeosphere( geo:TGeosphere, x:Int, z:Int, new_height:Float )
	ModifyGeosphere_( geo.instance, x, z, new_height )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ModifyTerrain">Online doc</a>
End Rem
Function ModifyTerrain( terr:TTerrain, x:Int, z:Int, new_height:Float )
	ModifyTerrain_( terr.instance, x, z, new_height )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MoveEntity">Online doc</a>
End Rem
Function MoveEntity( ent:TEntity, x:Float, y:Float, z:Float )
	MoveEntity_( ent.instance, x, y, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=NameEntity">Online doc</a>
End Rem
Function NameEntity( ent:TEntity, name:String )
	NameEntity_( ent.instance, name.ToCString() )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintEntity">Online doc</a>
End Rem
Function PaintEntity( ent:TEntity, brush:TBrush )
	PaintEntity_( ent.instance, brush.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintMesh">Online doc</a>
End Rem
Function PaintMesh( mesh:TMesh, brush:TBrush )
	PaintMesh_( mesh.instance, brush.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintSurface">Online doc</a>
End Rem
Function PaintSurface( surf:TSurface, brush:TBrush )
	PaintSurface_( surf.instance, brush.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedEntity">Online doc</a>
End Rem
Function PickedEntity:TEntity()
	Return globals.ent.EntityValue( PickedEntity_() )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedSurface">Online doc</a>
End Rem
Function PickedSurface:TSurface()
	Local instance:Byte Ptr=PickedSurface_()
	Local surf:TSurface=globals.surf.SurfaceValue( instance )
	If surf=Null And instance<>Null Then surf=globals.surf.NewSurface( instance )
	Return surf
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionMesh">Online doc</a>
End Rem
Function PositionMesh( mesh:TMesh, px:Float, py:Float, pz:Float )
	PositionMesh_( mesh.instance, px, py, pz )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionTexture">Online doc</a>
End Rem
Function PositionTexture( tex:TTexture, u_pos:Float, v_pos:Float )
	PositionTexture_( tex.instance, u_pos, v_pos )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ResetEntity">Online doc</a>
End Rem
Function ResetEntity( ent:TEntity )
	ResetEntity_( ent.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateMesh">Online doc</a>
End Rem
Function RotateMesh( mesh:TMesh, pitch:Float, yaw:Float, roll:Float )
	RotateMesh_( mesh.instance, -pitch, yaw, roll ) ' inverted pitch
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateSprite">Online doc</a>
End Rem
Function RotateSprite( sprite:TSprite, ang:Float )
	RotateSprite_( sprite.instance, ang )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateTexture">Online doc</a>
End Rem
Function RotateTexture( tex:TTexture, ang:Float )
	RotateTexture_( tex.instance, ang )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleMesh">Online doc</a>
End Rem
Function ScaleMesh( mesh:TMesh, sx:Float, sy:Float, sz:Float )
	ScaleMesh_( mesh.instance, sx, sy, sz )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleSprite">Online doc</a>
End Rem
Function ScaleSprite( sprite:TSprite, s_x:Float, s_y:Float )
	ScaleSprite_( sprite.instance, s_x, s_y )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleTexture">Online doc</a>
End Rem
Function ScaleTexture( tex:TTexture, u_scale:Float, v_scale:Float )
	ScaleTexture_( tex.instance, u_scale, v_scale )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeFace">Online doc</a>
End Rem
Function SetCubeFace( tex:TTexture, face:Int )
	SetCubeFace_( tex.instance, face )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeMode">Online doc</a>
End Rem
Function SetCubeMode( tex:TTexture, Mode:Int )
	SetCubeMode_( tex.instance, Mode )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ShowEntity">Online doc</a>
End Rem
Function ShowEntity( ent:TEntity )
	ShowEntity_( ent.instance )
End Function

Rem
bbdoc: undocumented
End Rem
Function SpriteRenderMode( sprite:TSprite, Mode:Int )
	SpriteRenderMode_( sprite.instance, Mode )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SpriteViewMode">Online doc</a>
End Rem
Function SpriteViewMode( sprite:TSprite, Mode:Int )
	SpriteViewMode_( sprite.instance, Mode )
End Function

Rem
bbdoc: undocumented
End Rem
Function StencilAlpha( stencil:TStencil, a:Float )
	StencilAlpha_( stencil.instance, a )
End Function

Rem
bbdoc: undocumented
End Rem
Function StencilClsColor( stencil:TStencil, r:Float, g:Float, b:Float )
	StencilClsColor_( stencil.instance, r, g, b )
End Function

Rem
bbdoc: undocumented
End Rem
Function StencilClsMode( stencil:TStencil, cls_depth:Int, cls_zbuffer:Int )
	StencilClsMode_( stencil.instance, cls_depth, cls_zbuffer )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainHeight">Online doc</a>
End Rem
Function TerrainHeight:Float( terr:TTerrain, x:Int, z:Int )
	Return TerrainHeight_( terr.instance, x, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainX">Online doc</a>
End Rem
Function TerrainX:Float( terr:TTerrain, x:Float, y:Float, z:Float )
	Return TerrainX_( terr.instance, x, y, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainY">Online doc</a>
End Rem
Function TerrainY:Float( terr:TTerrain, x:Float, y:Float, z:Float )
	Return TerrainY_( terr.instance, x, y, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainZ">Online doc</a>
End Rem
Function TerrainZ:Float( terr:TTerrain, x:Float, y:Float, z:Float )
	Return TerrainZ_( terr.instance, x, y, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureBlend">Online doc</a>
End Rem
Function TextureBlend( tex:TTexture, blend:Int )
	TextureBlend_( tex.instance, blend )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureCoords">Online doc</a>
End Rem
Function TextureCoords( tex:TTexture, coords:Int )
	TextureCoords_( tex.instance, coords )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureHeight">Online doc</a>
End Rem
Function TextureHeight:Int( tex:TTexture )
	Return TextureHeight_( tex.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureFilter">Online doc</a>
End Rem
Function TextureFilter( match_text:String, flags:Int )
	TextureFilter_( match_text.ToCString(), flags )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureName">Online doc</a>
End Rem
Function TextureName:String( tex:TTexture )
	Return String.FromCString( TextureName_( tex.instance ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureWidth">Online doc</a>
End Rem
Function TextureWidth:Int( tex:TTexture )
	Return TextureWidth_( tex.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormNormal">Online doc</a>
End Rem
Function TFormNormal( x:Float, y:Float, z:Float, src_ent:TEntity, dest_ent:TEntity )
	TFormNormal_( x, y, z, TEntity.EntityExists( src_ent ), TEntity.EntityExists( dest_ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormPoint">Online doc</a>
End Rem
Function TFormPoint( x:Float, y:Float, z:Float, src_ent:TEntity, dest_ent:TEntity )
	TFormPoint_( x, y, z, TEntity.EntityExists( src_ent ), TEntity.EntityExists( dest_ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormVector">Online doc</a>
End Rem
Function TFormVector( x:Float, y:Float, z:Float, src_ent:TEntity, dest_ent:TEntity )
	TFormVector_( x, y, z, TEntity.EntityExists( src_ent ), TEntity.EntityExists( dest_ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TriangleVertex">Online doc</a>
End Rem
Function TriangleVertex:Int( surf:TSurface, tri_no:Int, corner:Int )
	Return TriangleVertex_( surf.instance, tri_no, corner )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateNormals">Online doc</a>
End Rem
Function UpdateNormals( mesh:TMesh )
	UpdateNormals_( mesh.instance )
End Function

Rem
bbdoc: undocumented
End Rem
Function UpdateTexCoords( surf:TSurface )
	UpdateTexCoords_( surf.instance )
End Function

Rem
bbdoc: undocumented
End Rem
Function UseStencil( stencil:TStencil )
	UseStencil_( stencil.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexAlpha">Online doc</a>
End Rem
Function VertexAlpha:Float( surf:TSurface, vid:Int )
	Return VertexAlpha_( surf.instance, vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexBlue">Online doc</a>
End Rem
Function VertexBlue:Float( surf:TSurface, vid:Int )
	Return VertexBlue_( surf.instance, vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexCoords">Online doc</a>
End Rem
Function VertexCoords( surf:TSurface, vid:Int, x:Float, y:Float, z:Float )
	VertexCoords_( surf.instance, vid, x, y, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexGreen">Online doc</a>
End Rem
Function VertexGreen:Float( surf:TSurface, vid:Int )
	Return VertexGreen_( surf.instance, vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNormal">Online doc</a>
End Rem
Function VertexNormal( surf:TSurface, vid:Int, nx:Float, ny:Float, nz:Float )
	VertexNormal_( surf.instance, vid, nx, ny, nz )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNX">Online doc</a>
End Rem
Function VertexNX:Float( surf:TSurface, vid:Int )
	Return VertexNX_( surf.instance, vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNY">Online doc</a>
End Rem
Function VertexNY:Float( surf:TSurface, vid:Int )
	Return VertexNY_( surf.instance, vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNZ">Online doc</a>
End Rem
Function VertexNZ:Float( surf:TSurface, vid:Int )
	Return VertexNZ_( surf.instance, vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexRed">Online doc</a>
End Rem
Function VertexRed:Float( surf:TSurface, vid:Int )
	Return VertexRed_( surf.instance, vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexX">Online doc</a>
End Rem
Function VertexX:Float( surf:TSurface, vid:Int )
	Return VertexX_( surf.instance, vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexY">Online doc</a>
End Rem
Function VertexY:Float( surf:TSurface, vid:Int )
	Return VertexY_( surf.instance, vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexZ">Online doc</a>
End Rem
Function VertexZ:Float( surf:TSurface, vid:Int )
	Return VertexZ_( surf.instance, vid )
End Function

Rem
bbdoc: undocumented
End Rem
Function VoxelSpriteMaterial( voxelspr:TVoxelSprite, mat:TMaterial )
	VoxelSpriteMaterial_( voxelspr.instance, mat.instance )
End Function

' ***extras***

Rem
bbdoc: Load shader from two files, vertex and fragment.
End Rem
Function LoadShader:TShader( ShaderName:String, VshaderFileName:String, FshaderFileName:String )
	Local instance:Byte Ptr=LoadShader_( ShaderName.ToCString(), VshaderFileName.ToCString(), FshaderFileName.ToCString() )
	Local material:TShader=globals.material.NewShader( instance )
	Return material
End Function

Rem
bbdoc: Load shader from two strings, vertex and fragment.
End Rem
Function CreateShader:TShader( ShaderName:String, VshaderString:String, FshaderString:String )
	Local instance:Byte Ptr=CreateShader_( ShaderName.ToCString(), VshaderString.ToCString(), FshaderString.ToCString() )
	Local material:TShader=globals.material.NewShader( instance )
	Return material
End Function

Rem
bbdoc: Apply shader to a surface.
End Rem
Function ShadeSurface( surf:TSurface, material:TShader )
	ShadeSurface_( surf.instance, material.instance )
End Function

Rem
bbdoc: Apply shader to a mesh.
End Rem
Function ShadeMesh( mesh:TMesh, material:TShader )
	ShadeMesh_( mesh.instance, material.instance )
End Function

Rem
bbdoc: Apply shader to an entity.
End Rem
Function ShadeEntity( ent:TEntity, material:TShader )
	ShadeEntity_( ent.instance, material.instance )
End Function

Rem
bbdoc: Set a shader variable name of a uniform float type to a float value.
End Rem
Function SetFloat( material:TShader, name:String, v1:Float )
	SetFloat_( material.instance, name.ToCString(), v1 )
End Function

Rem
bbdoc: Set a shader variable name of a uniform vec2 type to 2 float values.
End Rem
Function SetFloat2( material:TShader, name:String, v1:Float, v2:Float )
	SetFloat2_( material.instance, name.ToCString(), v1, v2 )
End Function

Rem
bbdoc: Set a shader variable name of a uniform vec3 type to 3 float values.
End Rem
Function SetFloat3( material:TShader, name:String, v1:Float, v2:Float, v3:Float )
	SetFloat3_( material.instance, name.ToCString(), v1, v2, v3 )
End Function

Rem
bbdoc: Set a shader variable name of a uniform vec4 type to 4 float values.
End Rem
Function SetFloat4( material:TShader, name:String, v1:Float, v2:Float, v3:Float, v4:Float )
	SetFloat4_( material.instance, name.ToCString(), v1, v2, v3, v4 )
End Function

Rem
bbdoc: Bind a float variable to a shader variable name of a uniform float type.
End Rem
Function UseFloat( material:TShader, name:String, v1:Float Var )
	UseFloat_( material.instance, name.ToCString(), Varptr(v1) )
End Function

Rem
bbdoc: Bind 2 float variables to a shader variable name of a uniform vec2 type.
End Rem
Function UseFloat2( material:TShader, name:String, v1:Float Var, v2:Float Var )
	UseFloat2_( material.instance, name.ToCString(), Varptr(v1), Varptr(v2) )
End Function

Rem
bbdoc: Bind 3 float variables to a shader variable name of a uniform vec3 type.
End Rem
Function UseFloat3( material:TShader, name:String, v1:Float Var, v2:Float Var, v3:Float Var )
	UseFloat3_( material.instance, name.ToCString(), Varptr(v1), Varptr(v2), Varptr(v3) )
End Function

Rem
bbdoc: Bind 4 float variables to a shader variable name of a uniform vec4 type.
End Rem
Function UseFloat4( material:TShader, name:String, v1:Float Var, v2:Float Var, v3:Float Var, v4:Float Var )
	UseFloat4_( material.instance, name.ToCString(), Varptr(v1), Varptr(v2), Varptr(v3), Varptr(v4) )
End Function

Rem
bbdoc: Set a shader variable name of a uniform int type to an integer value.
End Rem
Function SetInteger( material:TShader, name:String, v1:Int )
	SetInteger_( material.instance, name.ToCString(), v1 )
End Function

Rem
bbdoc: Set a shader variable name of a uniform ivec2 type to 2 integer values.
End Rem
Function SetInteger2( material:TShader, name:String, v1:Int, v2:Int )
	SetInteger2_( material.instance, name.ToCString(), v1, v2 )
End Function

Rem
bbdoc: Set a shader variable name of a uniform ivec3 type to 3 integer values.
End Rem
Function SetInteger3( material:TShader, name:String, v1:Int, v2:Int, v3:Int )
	SetInteger3_( material.instance, name.ToCString(), v1, v2, v3 )
End Function

Rem
bbdoc: Set a shader variable name of a uniform ivec4 type to 4 integer values.
End Rem
Function SetInteger4( material:TShader, name:String, v1:Int, v2:Int, v3:Int, v4:Int )
	SetInteger4_( material.instance, name.ToCString(), v1, v2, v3, v4 )
End Function

Rem
bbdoc: Bind an integer variable to a shader variable name of a uniform int type.
End Rem
Function UseInteger( material:TShader, name:String, v1:Int Var )
	UseInteger_( material.instance, name.ToCString(), Varptr(v1) )
End Function

Rem
bbdoc: Bind 2 integer variables to a shader variable name of a uniform ivec2 type.
End Rem
Function UseInteger2( material:TShader, name:String, v1:Int Var, v2:Int Var )
	UseInteger2_( material.instance, name.ToCString(), Varptr(v1), Varptr(v2) )
End Function

Rem
bbdoc: Bind 3 integer variables to a shader variable name of a uniform ivec3 type.
End Rem
Function UseInteger3( material:TShader, name:String, v1:Int Var, v2:Int Var, v3:Int Var )
	UseInteger3_( material.instance, name.ToCString(), Varptr(v1), Varptr(v2), Varptr(v3) )
End Function

Rem
bbdoc: Bind 4 integer variables to a shader variable name of a uniform ivec4 type.
End Rem
Function UseInteger4( material:TShader, name:String, v1:Int Var, v2:Int Var, v3:Int Var, v4:Int Var )
	UseInteger4_( material.instance, name.ToCString(), Varptr(v1), Varptr(v2), Varptr(v3), Varptr(v4) )
End Function

Rem
bbdoc: undocumented
End Rem
Function UseSurface( material:TShader, name:String, surf:TSurface, vbo:Int )
	UseSurface_( material.instance, name.ToCString(), surf.instance, vbo )
End Function

Rem
bbdoc: Send matrix data to a shader variable name of a uniform mat4 type.
If mode is true it sends camera matrix otherwise projection matrix.
End Rem
Function UseMatrix( material:TShader, name:String, Mode:Int )
	UseMatrix_( material.instance, name.ToCString(), Mode )
End Function

Rem
bbdoc: undocumented
End Rem
Function LoadMaterial:TMaterial( filename:String, flags:Int, frame_width:Int, frame_height:Int, first_frame:Int, frame_count:Int )
	Local instance:Byte Ptr=LoadMaterial_( filename.ToCString(), flags, frame_width, frame_height, first_frame, frame_count )
	Local mat:TMaterial=globals.mat.NewMaterial( instance )
	Return mat
End Function


' Wrapper functions with default arguments (can't be set in declarations)
' -----------------------------------------------------------------------

Rem
bbdoc: Copy the contents of the backbuffer to a texture.
End Rem
Function BackBufferToTex( tex:TTexture, frame:Int=0 )
	BackBufferToTex_( tex.instance, frame )
End Function

Rem
bbdoc: Copy a pixmap buffer to texture, buffer must be a byte ptr.
End Rem
Function BufferToTex( tex:TTexture, buffer:Byte Ptr, frame:Int=0 )
	BufferToTex_( tex.instance, buffer, frame )
End Function

Rem
bbdoc: Copy the contents of the depthbuffer to a texture.
End Rem
Function DepthBufferToTex( tex:TTexture, frame:Int=0 )
	DepthBufferToTex_( tex.instance, frame )
End Function

Rem
bbdoc: Copy a rendered camera view to texture.
End Rem
Function CameraToTex( tex:TTexture, cam:TCamera, frame:Int=0 )
	CameraToTex_( tex.instance, cam.instance, frame )
End Function

Rem
bbdoc: Copy a texture to a pixmap buffer, buffer must be a byte ptr.
End Rem
Function TexToBuffer( tex:TTexture, buffer:Byte Ptr, frame:Int=0 )
	TexToBuffer_( tex.instance, buffer, frame )
End Function

' Blitz3D functions, A-Z

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddVertex">Online doc</a>
End Rem
Function AddVertex:Int( surf:TSurface, x:Float, y:Float, z:Float, u:Float=0, v:Float=0, w:Float=0 )
	Return AddVertex_( surf.instance, x, y, z, u, v, w )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animate">Online doc</a>
End Rem
Function Animate( ent:TEntity, Mode:Int=1, speed:Float=1, seq:Int=0, trans:Int=0 )
	Animate_( ent.instance, Mode, speed, seq, trans )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushTexture">Online doc</a>
End Rem
Function BrushTexture( brush:TBrush, tex:TTexture, frame:Int=0, index:Int=0 )
	BrushTexture_( brush.instance, tex.instance, frame, index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearSurface">Online doc</a>
End Rem
Function ClearSurface( surf:TSurface, clear_verts:Int=True, clear_tris:Int=True )
	ClearSurface_( surf.instance, clear_verts, clear_tris )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearWorld">Online doc</a>
End Rem
Function ClearWorld( entities:Int=True, brushes:Int=True, textures:Int=True )
	ClearWorld_( entities, brushes, textures )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Collisions">Online doc</a>
End Rem
Function Collisions( src_no:Int, dest_no:Int, method_no:Int, response_no:Int=0 )
	Collisions_( src_no, dest_no, method_no, response_no )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyEntity">Online doc</a>
End Rem
Function CopyEntity:TEntity( ent:TEntity, parent:TEntity=Null )
	Local instance:Byte Ptr=CopyEntity_( ent.instance, TEntity.EntityExists( parent ) )
	Local copy:TEntity=globals.ent.NewEntity( instance )
	Return copy
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyMesh">Online doc</a>
End Rem
Function CopyMesh:TMesh( mesh:TMesh, parent:TEntity=Null )
	Local instance:Byte Ptr=CopyMesh_( mesh.instance, TEntity.EntityExists( parent ) )
	Local copy:TMesh=globals.mesh.NewMesh( instance )
	Return copy
End Function

Rem
bbdoc: undocumented
End Rem
Function CreateBlob:TBlob( fluid:TFluid, radius:Float, parent_ent:TEntity=Null )
	Local instance:Byte Ptr=CreateBlob_( fluid.instance, radius, TEntity.EntityExists( parent_ent ) )
	Local blob:TBlob=globals.blob.NewBlob( instance )
	Return blob
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateBrush">Online doc</a>
End Rem
Function CreateBrush:TBrush( r:Float=255, g:Float=255, b:Float=255 )
	Local instance:Byte Ptr=CreateBrush_( r, g, b )
	Local brush:TBrush=globals.brush.NewBrush( instance )
	Return brush
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCamera">Online doc</a>
End Rem
Function CreateCamera:TCamera( parent:TEntity=Null )
	Local instance:Byte Ptr=CreateCamera_( TEntity.EntityExists( parent ) )
	Local cam:TCamera=globals.cam.NewCamera( instance )
	Return cam
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCone">Online doc</a>
End Rem
Function CreateCone:TMesh( segments:Int=8, solid:Int=True, parent:TEntity=Null )
	Local instance:Byte Ptr=CreateCone_( segments, solid, TEntity.EntityExists( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCylinder">Online doc</a>
End Rem
Function CreateCylinder:TMesh( segments:Int=8, solid:Int=True, parent:TEntity=Null )
	Local instance:Byte Ptr=CreateCylinder_( segments, solid, TEntity.EntityExists( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCube">Online doc</a>
End Rem
Function CreateCube:TMesh( parent:TEntity=Null )
	Local instance:Byte Ptr=CreateCube_( TEntity.EntityExists( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: undocumented
End Rem
Function CreateFluid:TFluid()
	Local instance:Byte Ptr=CreateFluid_()
	Local fluid:TFluid=globals.fluid.NewFluid( instance )
	Return fluid
End Function

Rem
bbdoc: undocumented
End Rem
Function CreateGeosphere:TGeosphere( size:Int, parent:TEntity=Null )
	Local instance:Byte Ptr=CreateGeosphere_( size, TEntity.EntityExists( parent ) )
	Local geo:TGeosphere=globals.geo.NewGeosphere( instance )
	Return geo
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateMesh">Online doc</a>
End Rem
Function CreateMesh:TMesh( parent:TEntity=Null )
	Local instance:Byte Ptr=CreateMesh_( TEntity.EntityExists( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateLight">Online doc</a>
End Rem
Function CreateLight:TLight( light_type:Int=1, parent:TEntity=Null )
	Local instance:Byte Ptr=CreateLight_( light_type, TEntity.EntityExists( parent ) )
	Local light:TLight=globals.light.NewLight( instance )
	Return light
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreatePivot">Online doc</a>
End Rem
Function CreatePivot:TPivot( parent:TEntity=Null )
	Local instance:Byte Ptr=CreatePivot_( TEntity.EntityExists( parent ) )
	Local piv:TPivot=globals.piv.NewPivot( instance )
	Return piv
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreatePlane">Online doc</a>
End Rem
Function CreatePlane:TMesh( divisions:Int=1, parent:TEntity=Null )
	Local instance:Byte Ptr=CreatePlane_( divisions, TEntity.EntityExists( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: undocumented
End Rem
Function CreateQuad:TMesh( parent:TEntity=Null )
	Local instance:Byte Ptr=CreateQuad_( TEntity.EntityExists( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: undocumented
End Rem
Function CreateShadow:TShadowObject( parent:TMesh, Static:Int=False )
	Local instance:Byte Ptr=CreateShadow_( parent.instance, Static )
	Local shad:TShadowObject=globals.shad.NewShadowObject( instance )
	Return shad
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSphere">Online doc</a>
End Rem
Function CreateSphere:TMesh( segments:Int=8, parent:TEntity=Null )
	Local instance:Byte Ptr=CreateSphere_( segments, TEntity.EntityExists( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSprite">Online doc</a>
End Rem
Function CreateSprite:TSprite( parent:TEntity=Null )
	Local instance:Byte Ptr=CreateSprite_( TEntity.EntityExists( parent ) )
	Local sprite:TSprite=globals.sprite.NewSprite( instance )
	Return sprite
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSurface">Online doc</a>
End Rem
Function CreateSurface:TSurface( mesh:TMesh, brush:TBrush=Null )
	Local instance:Byte Ptr=CreateSurface_( mesh.instance, globals.brush.BrushExists( brush ) )
	Local surf:TSurface=globals.surf.NewSurface( instance )
	Return surf
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateTerrain">Online doc</a>
End Rem
Function CreateTerrain:TTerrain( size:Int, parent:TEntity=Null )
	Local instance:Byte Ptr=CreateTerrain_( size, TEntity.EntityExists( parent ) )
	Local terr:TTerrain=globals.terr.NewTerrain( instance )
	Return terr
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateTexture">Online doc</a>
End Rem
Function CreateTexture:TTexture( width:Int, height:Int, flags:Int=9, frames:Int=1 )
	Local instance:Byte Ptr=CreateTexture_( width, height, flags, frames )
	Local tex:TTexture=globals.tex.NewTexture( instance )
	Return tex
End Function

Rem
bbdoc: undocumented
End Rem
Function CreateVoxelSprite:TVoxelSprite( slices:Int=64, parent:TEntity=Null )
	Local instance:Byte Ptr=CreateVoxelSprite_( slices, TEntity.EntityExists( parent ) )
	Local voxelspr:TVoxelSprite=globals.voxelspr.NewVoxelSprite( instance )
	Return voxelspr
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityParent">Online doc</a>
End Rem
Function EntityParent( ent:TEntity, parent_ent:TEntity, glob:Int=True )
	EntityParent_( ent.instance, TEntity.EntityExists( parent_ent ), glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPickMode">Online doc</a>
End Rem
Function EntityPickMode( ent:TEntity, pick_mode:Int, obscurer:Int=True )
	EntityPickMode_( ent.instance, pick_mode, obscurer )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPitch">Online doc</a>
End Rem
Function EntityPitch:Float( ent:TEntity, glob:Int=False )
	Return -EntityPitch_( ent.instance, glob ) ' inverted pitch
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRadius">Online doc</a>
End Rem
Function EntityRadius( ent:TEntity, radius_x:Float, radius_y:Float=0 )
	EntityRadius_( ent.instance, radius_x, radius_y )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRoll">Online doc</a>
End Rem
Function EntityRoll:Float( ent:TEntity, glob:Int=True )
	Return EntityRoll_( ent.instance, glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityTexture">Online doc</a>
End Rem
Function EntityTexture( ent:TEntity, tex:TTexture, frame:Int=0, index:Int=0 )
	EntityTexture_( ent.instance, tex.instance, frame, index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityType">Online doc</a>
End Rem
Function EntityType( ent:TEntity, type_no:Int, recursive:Int=False )
	EntityType_( ent.instance, type_no, recursive )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityX">Online doc</a>
End Rem
Function EntityX:Float( ent:TEntity, glob:Int=False )
	Return EntityX_( ent.instance, glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityY">Online doc</a>
End Rem
Function EntityY:Float( ent:TEntity, glob:Int=False )
	Return EntityY_( ent.instance, glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityYaw">Online doc</a>
End Rem
Function EntityYaw:Float( ent:TEntity, glob:Int=False )
	Return EntityYaw_( ent.instance, glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityZ">Online doc</a>
End Rem
Function EntityZ:Float( ent:TEntity, glob:Int=False )
	Return EntityZ_( ent.instance, glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ExtractAnimSeq">Online doc</a>
End Rem
Function ExtractAnimSeq:Int( ent:TEntity, first_frame:Int, last_frame:Int, seq:Int=0 )
	Return ExtractAnimSeq_( ent.instance, first_frame, last_frame, seq )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FitMesh">Online doc</a>
End Rem
Function FitMesh( mesh:TMesh, x:Float, y:Float, z:Float, width:Float, height:Float, depth:Float, uniform:Int=False )
	FitMesh_( mesh.instance, x, y, z, width, height, depth, uniform )
End Function

Rem
bbdoc: undocumented
End Rem
Function FreeShadow( shad:TShadowObject )
	shad.DeleteShadowObject( shad.instance )
	FreeShadow_( shad.instance )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetBrushTexture">Online doc</a>
End Rem
Function GetBrushTexture:TTexture( brush:TBrush, index:Int=0 )
	Local instance:Byte Ptr=GetBrushTexture_( brush.instance, index )
	Local tex:TTexture=globals.tex.TextureValue( instance )
	If tex=Null And instance<>Null Then tex=globals.tex.NewTexture( instance )
	Return tex
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LinePick">Online doc</a>
End Rem
Function LinePick:TEntity( x:Float, y:Float, z:Float, dx:Float, dy:Float, dz:Float, radius:Float=0 )
	Return globals.ent.EntityValue( LinePick_( x, y, z, dx, dy, dz, radius ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimMesh">Online doc</a>
End Rem
Function LoadAnimMesh:TMesh( file:String, parent:TEntity=Null )
	Local instance:Byte Ptr=LoadAnimMesh_( file.ToCString(), TEntity.EntityExists( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadBrush">Online doc</a>
End Rem
Function LoadBrush:TBrush( file:String, flags:Int=1, u_scale:Float=1, v_scale:Float=1 )
	Local instance:Byte Ptr=LoadBrush_( file.ToCString(), flags, u_scale, v_scale )
	Local brush:TBrush=globals.brush.NewBrush( instance )
	Return brush
End Function

Rem
bbdoc: undocumented
End Rem
Function LoadGeosphere:TGeosphere( file:String, parent:TEntity=Null )
	Local instance:Byte Ptr=LoadGeosphere_( file.ToCString(), TEntity.EntityExists( parent ) )
	Local geo:TGeosphere=globals.geo.NewGeosphere( instance )
	Return geo
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadMesh">Online doc</a>
End Rem
Function LoadMesh:TMesh( file:String, parent:TEntity=Null )
	Local instance:Byte Ptr=LoadMesh_( file.ToCString(), TEntity.EntityExists( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadTerrain">Online doc</a>
End Rem
Function LoadTerrain:TTerrain( file:String, parent:TEntity=Null )
	Local instance:Byte Ptr=LoadTerrain_( file.ToCString(), TEntity.EntityExists( parent ) )
	Local terr:TTerrain=globals.terr.NewTerrain( instance )
	Return terr
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadTexture">Online doc</a>
End Rem
Function LoadTexture:TTexture( file:String, flags:Int=1 )
	Local instance:Byte Ptr=LoadTexture_( file.ToCString(), flags )
	Local tex:TTexture=globals.tex.NewTexture( instance )
	Return tex
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadSprite">Online doc</a>
End Rem
Function LoadSprite:TSprite( tex_file:String, tex_flag:Int=1, parent:TEntity=Null )
	Local instance:Byte Ptr=LoadSprite_( tex_file.ToCString(), tex_flag, TEntity.EntityExists( parent ) )
	Local sprite:TSprite=globals.sprite.NewSprite( instance )
	Return sprite
End Function

Rem
bbdoc: undocumented
End Rem
Function MeshCSG:TMesh( m1:TMesh, m2:TMesh, method_no:Int=1 )
	Local instance:Byte Ptr=MeshCSG_( m1.instance, m2.instance, method_no )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PointEntity">Online doc</a>
End Rem
Function PointEntity( ent:TEntity, target_ent:TEntity, roll:Float=0 )
	PointEntity_( ent.instance, target_ent.instance, roll )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionEntity">Online doc</a>
End Rem
Function PositionEntity( ent:TEntity, x:Float, y:Float, z:Float, glob:Int=False )
	PositionEntity_( ent.instance, x, y, z, glob )
End Function

Rem
bbdoc: Like CopyMesh but for instancing effects.
End Rem
Function RepeatMesh:TMesh( mesh:TMesh, parent:TEntity=Null )
	Local instance:Byte Ptr=RepeatMesh_( mesh.instance, TEntity.EntityExists( parent ) )
	Local copy:TMesh=globals.mesh.NewMesh( instance )
	Return copy
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateEntity">Online doc</a>
End Rem
Function RotateEntity( ent:TEntity, x:Float, y:Float, z:Float, glob:Int=False )
	RotateEntity_( ent.instance, -x, y, z, glob ) ' inverted pitch
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleEntity">Online doc</a>
End Rem
Function ScaleEntity( ent:TEntity, x:Float, y:Float, z:Float, glob:Int=False )
	ScaleEntity_( ent.instance, x, y, z, glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetAnimTime">Online doc</a>
End Rem
Function SetAnimTime( ent:TEntity, time:Float, seq:Int=0 )
	SetAnimTime_( ent.instance, time, seq )
End Function

Rem
bbdoc: undocumented
End Rem
Function StencilMesh( stencil:TStencil, mesh:TMesh, Mode:Int=1 )
	StencilMesh_( stencil.instance, mesh.instance, Mode )
End Function

Rem
bbdoc: undocumented
End Rem
Function StencilMode( stencil:TStencil, m:Int, o:Int=1 )
	StencilMode_( stencil.instance, m, o )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TranslateEntity">Online doc</a>
End Rem
Function TranslateEntity( ent:TEntity, x:Float, y:Float, z:Float, glob:Int=False )
	TranslateEntity_( ent.instance, x, y, z, glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TurnEntity">Online doc</a>
End Rem
Function TurnEntity( ent:TEntity, x:Float, y:Float, z:Float, glob:Int=False )
	TurnEntity_( ent.instance, -x, y, z, glob ) ' inverted pitch
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateWorld">Online doc</a>
End Rem
Function UpdateWorld( anim_speed:Float=1 )
	UpdateWorld_( anim_speed )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexColor">Online doc</a>
End Rem
Function VertexColor( surf:TSurface, vid:Int, r:Float, g:Float, b:Float, a:Float=1 )
	VertexColor_( surf.instance, vid, r, g, b, a )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexTexCoords">Online doc</a>
End Rem
Function VertexTexCoords( surf:TSurface, vid:Int, u:Float, v:Float, w:Float=0, coord_set:Int=0 )
	VertexTexCoords_( surf.instance, vid, u, v, w, coord_set )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexU">Online doc</a>
End Rem
Function VertexU:Float( surf:TSurface, vid:Int, coord_set:Int=0 )
	Return VertexU_( surf.instance, vid, coord_set )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexV">Online doc</a>
End Rem
Function VertexV:Float( surf:TSurface, vid:Int, coord_set:Int=0 )
	Return VertexV_( surf.instance, vid, coord_set )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexW">Online doc</a>
End Rem
Function VertexW:Float( surf:TSurface, vid:Int, coord_set:Int=0 )
	Return VertexW_( surf.instance, vid, coord_set )
End Function

' ***extras***

Rem
bbdoc: undocumented
End Rem
Function EntityScaleX:Float( ent:TEntity, glob:Int=False )
	Return EntityScaleX_( ent.instance, glob )
End Function

Rem
bbdoc: undocumented
End Rem
Function EntityScaleY:Float( ent:TEntity, glob:Int=False )
	Return EntityScaleY_( ent.instance, glob )
End Function

Rem
bbdoc: undocumented
End Rem
Function EntityScaleZ:Float( ent:TEntity, glob:Int=False )
	Return EntityScaleZ_( ent.instance, glob )
End Function

Rem
bbdoc: Load a texture for 2D texture sampling.
End Rem
Function ShaderTexture( material:TShader, tex:TTexture, name:String, index:Int=0 )
	ShaderTexture_( material.instance, tex.instance, name.ToCString(), index )
End Function

Rem
bbdoc: Load a texture for 3D texture sampling.
End Rem
Function ShaderMaterial( material:TShader, tex:TMaterial, name:String, index:Int=0 )
	ShaderMaterial_( material.instance, tex.instance, name.ToCString(), index )
End Function

Rem
bbdoc: undocumented
End Rem
Function CreateOcTree:TOcTree( w:Float, h:Float, d:Float, parent_ent:TEntity=Null )
	Local instance:Byte Ptr=CreateOcTree_( w, h, d, TEntity.EntityExists( parent_ent ) )
	Local octree:TOcTree=globals.octree.NewOcTree( instance )
	Return octree
End Function

Rem
bbdoc: undocumented
End Rem
Function OctreeBlock( octree:TOcTree, mesh:TMesh, level:Int, X:Float, Y:Float, Z:Float, Near:Float=0, Far:Float=1000 )
	OctreeBlock_( octree.instance, mesh.instance, level, X, Y, Z, Near, Far )
End Function

Rem
bbdoc: undocumented
End Rem
Function OctreeMesh( octree:TOcTree, mesh:TMesh, level:Int, X:Float, Y:Float, Z:Float, Near:Float=0, Far:Float=1000 )
	OctreeMesh_( octree.instance, mesh.instance, level, X, Y, Z, Near, Far )
End Function


' Remaining functions (wrapped for docs)
' --------------------------------------

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AmbientLight">Online doc</a>
End Rem
Function AmbientLight( r:Float, g:Float, b:Float )
	AmbientLight_( r, g, b )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AntiAlias">Online doc</a>
End Rem
Function AntiAlias( samples:Int )
	AntiAlias_( samples )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearCollisions">Online doc</a>
End Rem
Function ClearCollisions()
	ClearCollisions_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearTextureFilters">Online doc</a>
End Rem
Function ClearTextureFilters()
	ClearTextureFilters_()
End Function

Rem
bbdoc: Update screen size
End Rem
Function GraphicsResize( width:Int, height:Int )
	GraphicsResize_( width, height )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNX">Online doc</a>
End Rem
Function PickedNX:Float()
	Return PickedNX_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNY">Online doc</a>
End Rem
Function PickedNY:Float()
	Return PickedNY_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNZ">Online doc</a>
End Rem
Function PickedNZ:Float()
	Return PickedNZ_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTime">Online doc</a>
End Rem
Function PickedTime:Float()
	Return PickedTime_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTriangle">Online doc</a>
End Rem
Function PickedTriangle:Int()
	Return PickedTriangle_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedX">Online doc</a>
End Rem
Function PickedX:Float()
	Return PickedX_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedY">Online doc</a>
End Rem
Function PickedY:Float()
	Return PickedY_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedZ">Online doc</a>
End Rem
Function PickedZ:Float()
	Return PickedZ_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedX">Online doc</a>
End Rem
Function ProjectedX:Float()
	Return ProjectedX_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedY">Online doc</a>
End Rem
Function ProjectedY:Float()
	Return ProjectedY_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedZ">Online doc</a>
End Rem
Function ProjectedZ:Float()
	Return ProjectedZ_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RenderWorld">Online doc</a>
End Rem
Function RenderWorld()
	'TGlobal.DisableStates()
	RenderWorld_()
End Function

Rem
bbdoc: Update fx flag 2 - vertex colours
End Rem
Function SetColorState( fx2:Int )
	SetColorState_( fx2 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedX">Online doc</a>
End Rem
Function TFormedX:Float()
	Return TFormedX_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedY">Online doc</a>
End Rem
Function TFormedY:Float()
	Return TFormedY_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedZ">Online doc</a>
End Rem
Function TFormedZ:Float()
	Return TFormedZ_()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorPitch">Online doc</a>
End Rem
Function VectorPitch:Float( vx:Float, vy:Float, vz:Float )
	Return -VectorPitch_( vx, vy, vz ) ' inverted pitch
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorYaw">Online doc</a>
End Rem
Function VectorYaw:Float( vx:Float, vy:Float, vz:Float )
	Return VectorYaw_( vx, vy, vz )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Wireframe">Online doc</a>
End Rem
Function Wireframe( enable:Int )
	Wireframe_( enable )
End Function
