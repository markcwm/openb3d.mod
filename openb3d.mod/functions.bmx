' functions.bmx

' Wrapper only (not in original)
' ------------------------------

Rem
bbdoc: Copy the contents of the depthbuffer to a texture.
End Rem
Function DepthBufferToTex( tex:TTexture, frame:Int=0 )
	DepthBufferToTex_( TObject.IsObject( tex ), frame )
End Function

Rem
bbdoc: Update screen size
End Rem
Function GraphicsResize( width:Int, height:Int )
	GraphicsResize_( width, height )
End Function

Rem
bbdoc: Set render state capability flags
End Rem
Function SetRenderState( capability:Int, flag:Int )
	SetRenderState_( capability, flag )
End Function

' Wrapper functions with Byte Ptr arguments
' -----------------------------------------

' Minib3d Only

Rem
bbdoc: undocumented
End Rem
Function MeshCullRadius( ent:TEntity, radius:Float )
	MeshCullRadius_( TObject.IsObject( ent ), radius )
End Function

' Blitz3D functions, A-Z

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddAnimSeq">Online doc</a>
End Rem
Function AddAnimSeq:Int( ent:TEntity, length:Int )
	Return AddAnimSeq_( TObject.IsObject( ent ), length )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddMesh">Online doc</a>
End Rem
Function AddMesh( mesh1:TMesh, mesh2:TMesh )
	AddMesh_( TObject.IsObject( mesh1 ), TObject.IsObject( mesh2 ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddTriangle">Online doc</a>
End Rem
Function AddTriangle:Int( surf:TSurface, v0:Int, v1:Int, v2:Int )
	Return AddTriangle_( TObject.IsObject( surf ), v0, v1, v2 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animating">Online doc</a>
End Rem
Function Animating:Int( ent:TEntity )
	Return Animating_( TObject.IsObject( ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimLength">Online doc</a>
End Rem
Function AnimLength( ent:TEntity )
	AnimLength_( TObject.IsObject( ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimSeq">Online doc</a>
End Rem
Function AnimSeq:Int( ent:TEntity )
	Return AnimSeq_( TObject.IsObject( ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimTime">Online doc</a>
End Rem
Function AnimTime:Float( ent:TEntity )
	Return AnimTime_( TObject.IsObject( ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushAlpha">Online doc</a>
End Rem
Function BrushAlpha( brush:TBrush, a:Float )
	BrushAlpha_( TObject.IsObject( brush ), a )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushBlend">Online doc</a>
End Rem
Function BrushBlend( brush:TBrush, blend:Int )
	BrushBlend_( TObject.IsObject( brush ), blend )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushColor">Online doc</a>
End Rem
Function BrushColor( brush:TBrush, r:Float, g:Float, b:Float )
	BrushColor_( TObject.IsObject( brush ), r, g, b )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushFX">Online doc</a>
End Rem
Function BrushFX( brush:TBrush, fx:Int )
	BrushFX_( TObject.IsObject( brush ), fx )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushShininess">Online doc</a>
End Rem
Function BrushShininess( brush:TBrush, s:Float )
	BrushShininess_( TObject.IsObject( brush ), s )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsColor">Online doc</a>
End Rem
Function CameraClsColor( cam:TCamera, r:Float, g:Float, b:Float )
	CameraClsColor_( TObject.IsObject( cam ), r, g, b )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsMode">Online doc</a>
End Rem
Function CameraClsMode( cam:TCamera, cls_depth:Int, cls_zbuffer:Int )
	CameraClsMode_( TObject.IsObject( cam ), cls_depth, cls_zbuffer )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogColor">Online doc</a>
End Rem
Function CameraFogColor( cam:TCamera, r:Float, g:Float, b:Float )
	CameraFogColor_( TObject.IsObject( cam ), r, g, b )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogMode">Online doc</a>
End Rem
Function CameraFogMode( cam:TCamera, Mode:Int )
	CameraFogMode_( TObject.IsObject( cam ), Mode )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogRange">Online doc</a>
End Rem
Function CameraFogRange( cam:TCamera, nnear:Float, nfar:Float )
	CameraFogRange_( TObject.IsObject( cam ), nnear, nfar )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraPick">Online doc</a>
End Rem
Function CameraPick:TEntity( cam:TCamera, x:Float, y:Float )
	Return globals.ent.EntityValue( CameraPick_( TObject.IsObject( cam ), x, GraphicsHeight()-y ) ) ' inverted y
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProject">Online doc</a>
End Rem
Function CameraProject( cam:TCamera, x:Float, y:Float, z:Float )
	CameraProject_( TObject.IsObject( cam ), x, y, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProjMode">Online doc</a>
End Rem
Function CameraProjMode( cam:TCamera, Mode:Int )
	CameraProjMode_( TObject.IsObject( cam ), Mode )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraRange">Online doc</a>
End Rem
Function CameraRange( cam:TCamera, nnear:Float, nfar:Float )
	CameraRange_( TObject.IsObject( cam ), nnear, nfar )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraViewport">Online doc</a>
End Rem
Function CameraViewport( cam:TCamera, x:Int, y:Int, width:Int, height:Int )
	CameraViewport_( TObject.IsObject( cam ), x, GraphicsHeight()-height, width, height ) ' inverted y
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraZoom">Online doc</a>
End Rem
Function CameraZoom( cam:TCamera, zoom:Float )
	CameraZoom_( TObject.IsObject( cam ), zoom )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionEntity">Online doc</a>
End Rem
Function CollisionEntity:TEntity( ent:TEntity, index:Int )
	Return globals.ent.EntityValue( CollisionEntity_( TObject.IsObject( ent ), index ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNX">Online doc</a>
End Rem
Function CollisionNX:Float( ent:TEntity, index:Int )
	Return CollisionNX_( TObject.IsObject( ent ), index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNY">Online doc</a>
End Rem
Function CollisionNY:Float( ent:TEntity, index:Int )
	Return CollisionNY_( TObject.IsObject( ent ), index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNZ">Online doc</a>
End Rem
Function CollisionNZ:Float( ent:TEntity, index:Int )
	Return CollisionNZ_( TObject.IsObject( ent ), index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionSurface">Online doc</a>
End Rem
Function CollisionSurface:TSurface( ent:TEntity, index:Int )
	Local instance:Byte Ptr=CollisionSurface_( TObject.IsObject( ent ), index )
	Local surf:TSurface=globals.surf.SurfaceValue( instance )
	If surf=Null And instance<>Null Then surf=globals.surf.NewSurface( instance )
	Return surf
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTime">Online doc</a>
End Rem
Function CollisionTime:Float( ent:TEntity, index:Int )
	Return CollisionTime_( TObject.IsObject( ent ), index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTriangle">Online doc</a>
End Rem
Function CollisionTriangle:Int( ent:TEntity, index:Int )
	Return CollisionTriangle_( TObject.IsObject( ent ), index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionX">Online doc</a>
End Rem
Function CollisionX:Float( ent:TEntity, index:Int )
	Return CollisionX_( TObject.IsObject( ent ), index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionY">Online doc</a>
End Rem
Function CollisionY:Float( ent:TEntity, index:Int )
	Return CollisionY_( TObject.IsObject( ent ), index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionZ">Online doc</a>
End Rem
Function CollisionZ:Float( ent:TEntity, index:Int )
	Return CollisionZ_( TObject.IsObject( ent ), index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountChildren">Online doc</a>
End Rem
Function CountChildren:Int( ent:TEntity )
	Return CountChildren_( TObject.IsObject( ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountCollisions">Online doc</a>
End Rem
Function CountCollisions:Int( ent:TEntity )
	Return CountCollisions_( TObject.IsObject( ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountSurfaces">Online doc</a>
End Rem
Function CountSurfaces:Int( mesh:TMesh )
	Return CountSurfaces_( TObject.IsObject( mesh ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountTriangles">Online doc</a>
End Rem
Function CountTriangles:Int( surf:TSurface )
	Return CountTriangles_( TObject.IsObject( surf ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountVertices">Online doc</a>
End Rem
Function CountVertices:Int( surf:TSurface )
	Return CountVertices_( TObject.IsObject( surf ) )
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
	Return -DeltaPitch_( TObject.IsObject( ent1 ), TObject.IsObject( ent2 ) ) ' inverted pitch
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaYaw">Online doc</a>
End Rem
Function DeltaYaw:Float( ent1:TEntity, ent2:TEntity )
	Return DeltaYaw_( TObject.IsObject( ent1 ), TObject.IsObject( ent2 ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAlpha">Online doc</a>
End Rem
Function EntityAlpha( ent:TEntity, alpha:Float )
	EntityAlpha_( TObject.IsObject( ent ), alpha )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAutoFade">Online doc</a>
End Rem
Function EntityAutoFade( ent:TEntity, near:Float, far:Float )
	EntityAutoFade_( TObject.IsObject( ent ), near, far )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBlend">Online doc</a>
End Rem
Function EntityBlend( ent:TEntity, blend:Int )
	EntityBlend_( TObject.IsObject( ent ), blend )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBox">Online doc</a>
End Rem
Function EntityBox( ent:TEntity, x:Float, y:Float, z:Float, w:Float, h:Float, d:Float )
	EntityBox_( TObject.IsObject( ent ), x, y, z, w, h, d )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityClass">Online doc</a>
End Rem
Function EntityClass:String( ent:TEntity )
	Return String.FromCString( EntityClass_( TObject.IsObject( ent ) ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityCollided">Online doc</a>
End Rem
Function EntityCollided:TEntity( ent:TEntity, type_no:Int )
	Return globals.ent.EntityValue( EntityCollided_( TObject.IsObject( ent ), type_no ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityColor">Online doc</a>
End Rem
Function EntityColor( ent:TEntity, red:Float, green:Float, blue:Float )
	EntityColor_( TObject.IsObject( ent ), red, green, blue )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityDistance">Online doc</a>
End Rem
Function EntityDistance:Float( ent1:TEntity, ent2:TEntity )
	Return EntityDistance_( TObject.IsObject( ent1 ), TObject.IsObject( ent2 ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityFX">Online doc</a>
End Rem
Function EntityFX( ent:TEntity, fx:Int )
	EntityFX_( TObject.IsObject( ent ), fx )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityInView">Online doc</a>
End Rem
Function EntityInView:Int( ent:TEntity, cam:TCamera )
	Return EntityInView_( TObject.IsObject( ent ), TObject.IsObject( cam ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityName">Online doc</a>
End Rem
Function EntityName:String( ent:TEntity )
	Return String.FromCString( EntityName_( TObject.IsObject( ent ) ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityOrder">Online doc</a>
End Rem
Function EntityOrder( ent:TEntity, order:Int )
	EntityOrder_( TObject.IsObject( ent ), order )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPick">Online doc</a>
End Rem
Function EntityPick:TEntity( ent:TEntity, Range:Float )
	Return globals.ent.EntityValue( EntityPick_( TObject.IsObject( ent ), Range ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityShininess">Online doc</a>
End Rem
Function EntityShininess( ent:TEntity, shine:Float )
	EntityShininess_( TObject.IsObject( ent ), shine )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityVisible">Online doc</a>
End Rem
Function EntityVisible:Int( src_ent:TEntity, dest_ent:TEntity )
	Return EntityVisible_( TObject.IsObject( src_ent ), TObject.IsObject( dest_ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindChild">Online doc</a>
End Rem
Function FindChild:TEntity( ent:TEntity, child_name:String )
	Local cString:Byte Ptr=child_name.ToCString()
	Local instance:Byte Ptr=FindChild_( TObject.IsObject( ent ), cString )
	Local child:TEntity=globals.ent.EntityValue( instance )
	If child=Null And instance<>Null Then child=globals.ent.NewEntity( instance )
	MemFree cString
	Return child
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindSurface">Online doc</a>
End Rem
Function FindSurface:TSurface( mesh:TMesh, brush:TBrush )
	Local instance:Byte Ptr=FindSurface_( TObject.IsObject( mesh ), TObject.IsObject( brush ) )
	Local surf:TSurface=globals.surf.SurfaceValue( instance )
	If surf=Null And instance<>Null Then surf=globals.surf.NewSurface( instance )
	Return surf
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FlipMesh">Online doc</a>
End Rem
Function FlipMesh( mesh:TMesh )
	FlipMesh_( TObject.IsObject( mesh ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeBrush">Online doc</a>
End Rem
Function FreeBrush( brush:TBrush )
	brush.DeleteBrush( TObject.IsObject( brush ) )
	FreeBrush_( TObject.IsObject( brush ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeEntity">Online doc</a>
End Rem
Function FreeEntity( ent:TEntity )
	ent.DeleteEntity( TObject.IsObject( ent ) )
	FreeEntity_( TObject.IsObject( ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeTexture">Online doc</a>
End Rem
Function FreeTexture( tex:TTexture )
	tex.DeleteTexture( TObject.IsObject( tex ) )
	FreeTexture_( TObject.IsObject( tex ) )
End Function

Rem
bbdoc: undocumented
End Rem
Function GeosphereHeight( geo:TGeosphere, h:Float )
	GeosphereHeight_( TObject.IsObject( geo ), h )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetChild">Online doc</a>
End Rem
Function GetChild:TEntity( ent:TEntity, child_no:Int )
	Local instance:Byte Ptr=GetChild_( TObject.IsObject( ent ), child_no )
	Local child:TEntity=globals.ent.EntityValue( instance )
	If child=Null And instance<>Null Then child=globals.ent.NewEntity( instance )
	Return child
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityBrush">Online doc</a>
End Rem
Function GetEntityBrush:TBrush( ent:TEntity )
	Local instance:Byte Ptr=GetEntityBrush_( TObject.IsObject( ent ) )
	Local brush:TBrush=globals.brush.BrushValue( instance )
	If brush=Null And instance<>Null Then brush=globals.brush.NewBrush( instance )
	Return brush
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityType">Online doc</a>
End Rem
Function GetEntityType:Int( ent:TEntity )
	Return GetEntityType_( TObject.IsObject( ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetMatElement">Online doc</a>
End Rem
Function GetMatElement:Float( ent:TEntity, row:Int, col:Int )
	Return GetMatElement_( TObject.IsObject( ent ), row, col )
End Function

Rem
bbdoc: undocumented
End Rem
Function GetParentEntity:TEntity( ent:TEntity )
	Return globals.ent.EntityValue( GetParentEntity_( TObject.IsObject( ent ) ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurface">Online doc</a>
End Rem
Function GetSurface:TSurface( mesh:TMesh, surf_no:Int )
	Local instance:Byte Ptr=GetSurface_( TObject.IsObject( mesh ), surf_no )
	Local surf:TSurface=globals.surf.SurfaceValue( instance )
	If surf=Null And instance<>Null Then surf=globals.surf.NewSurface( instance )
	Return surf
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurfaceBrush">Online doc</a>
End Rem
Function GetSurfaceBrush:TBrush( surf:TSurface )
	Local instance:Byte Ptr=GetSurfaceBrush_( TObject.IsObject( surf ) )
	Local brush:TBrush=globals.brush.BrushValue( instance )
	If brush=Null And instance<>Null Then brush=globals.brush.NewBrush( instance )
	Return brush
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HandleSprite">Online doc</a>
End Rem
Function HandleSprite( sprite:TSprite, h_x:Float, h_y:Float )
	HandleSprite_( TObject.IsObject( sprite ), h_x, h_y )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HideEntity">Online doc</a>
End Rem
Function HideEntity( ent:TEntity )
	HideEntity_( TObject.IsObject( ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightColor">Online doc</a>
End Rem
Function LightColor( light:TLight, red:Float, green:Float, blue:Float )
	LightColor_( TObject.IsObject( light ), red, green, blue )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightConeAngles">Online doc</a>
End Rem
Function LightConeAngles( light:TLight, inner_ang:Float, outer_ang:Float )
	LightConeAngles_( TObject.IsObject( light ), inner_ang, outer_ang )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightRange">Online doc</a>
End Rem
Function LightRange( light:TLight, Range:Float )
	LightRange_( TObject.IsObject( light ), Range )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimTexture">Online doc</a>
End Rem
Function LoadAnimTexture:TTexture( file:String, flags:Int, frame_width:Int, frame_height:Int, first_frame:Int, frame_count:Int )
	Local cString:Byte Ptr=file.ToCString()
	Local instance:Byte Ptr=LoadAnimTexture_( cString, flags, frame_width, frame_height, first_frame, frame_count )
	Local tex:TTexture=globals.tex.NewTexture( instance )
	MemFree cString
	Return tex
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshDepth">Online doc</a>
End Rem
Function MeshDepth:Float( mesh:TMesh )
	Return MeshDepth_( TObject.IsObject( mesh ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshesIntersect">Online doc</a>
End Rem
Function MeshesIntersect:Int( mesh1:TMesh, mesh2:TMesh )
	Return MeshesIntersect_( TObject.IsObject( mesh1 ), TObject.IsObject( mesh2 ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshHeight">Online doc</a>
End Rem
Function MeshHeight:Float( mesh:TMesh )
	Return MeshHeight_( TObject.IsObject( mesh ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshWidth">Online doc</a>
End Rem
Function MeshWidth:Float( mesh:TMesh )
	Return MeshWidth_( TObject.IsObject( mesh ) )
End Function

Rem
bbdoc: undocumented
End Rem
Function ModifyGeosphere( geo:TGeosphere, x:Int, z:Int, new_height:Float )
	ModifyGeosphere_( TObject.IsObject( geo ), x, z, new_height )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ModifyTerrain">Online doc</a>
End Rem
Function ModifyTerrain( terr:TTerrain, x:Int, z:Int, new_height:Float )
	ModifyTerrain_( TObject.IsObject( terr ), x, z, new_height )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MoveEntity">Online doc</a>
End Rem
Function MoveEntity( ent:TEntity, x:Float, y:Float, z:Float )
	MoveEntity_( TObject.IsObject( ent ), x, y, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=NameEntity">Online doc</a>
End Rem
Function NameEntity( ent:TEntity, name:String )
	Local cString:Byte Ptr=name.ToCString()
	NameEntity_( TObject.IsObject( ent ), cString )
	MemFree cString
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintEntity">Online doc</a>
End Rem
Function PaintEntity( ent:TEntity, brush:TBrush )
	PaintEntity_( TObject.IsObject( ent ), TObject.IsObject( brush ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintMesh">Online doc</a>
End Rem
Function PaintMesh( mesh:TMesh, brush:TBrush )
	PaintMesh_( TObject.IsObject( mesh ), TObject.IsObject( brush ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintSurface">Online doc</a>
End Rem
Function PaintSurface( surf:TSurface, brush:TBrush )
	PaintSurface_( TObject.IsObject( surf ), TObject.IsObject( brush ) )
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
	PositionMesh_( TObject.IsObject( mesh ), px, py, pz )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionTexture">Online doc</a>
End Rem
Function PositionTexture( tex:TTexture, u_pos:Float, v_pos:Float )
	PositionTexture_( TObject.IsObject( tex ), u_pos, v_pos )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ResetEntity">Online doc</a>
End Rem
Function ResetEntity( ent:TEntity )
	ResetEntity_( TObject.IsObject( ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateMesh">Online doc</a>
End Rem
Function RotateMesh( mesh:TMesh, pitch:Float, yaw:Float, roll:Float )
	RotateMesh_( TObject.IsObject( mesh ), -pitch, yaw, roll ) ' inverted pitch
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateSprite">Online doc</a>
End Rem
Function RotateSprite( sprite:TSprite, ang:Float )
	RotateSprite_( TObject.IsObject( sprite ), ang )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateTexture">Online doc</a>
End Rem
Function RotateTexture( tex:TTexture, ang:Float )
	RotateTexture_( TObject.IsObject( tex ), ang )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleMesh">Online doc</a>
End Rem
Function ScaleMesh( mesh:TMesh, sx:Float, sy:Float, sz:Float )
	ScaleMesh_( TObject.IsObject( mesh ), sx, sy, sz )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleSprite">Online doc</a>
End Rem
Function ScaleSprite( sprite:TSprite, s_x:Float, s_y:Float )
	ScaleSprite_( TObject.IsObject( sprite ), s_x, s_y )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleTexture">Online doc</a>
End Rem
Function ScaleTexture( tex:TTexture, u_scale:Float, v_scale:Float )
	ScaleTexture_( TObject.IsObject( tex ), u_scale, v_scale )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeFace">Online doc</a>
End Rem
Function SetCubeFace( tex:TTexture, face:Int )
	SetCubeFace_( TObject.IsObject( tex ), face )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeMode">Online doc</a>
End Rem
Function SetCubeMode( tex:TTexture, Mode:Int )
	SetCubeMode_( TObject.IsObject( tex ), Mode )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ShowEntity">Online doc</a>
End Rem
Function ShowEntity( ent:TEntity )
	ShowEntity_( TObject.IsObject( ent ) )
End Function

Rem
bbdoc: undocumented
End Rem
Function SpriteRenderMode( sprite:TSprite, Mode:Int )
	SpriteRenderMode_( TObject.IsObject( sprite ), Mode )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SpriteViewMode">Online doc</a>
End Rem
Function SpriteViewMode( sprite:TSprite, Mode:Int )
	SpriteViewMode_( TObject.IsObject( sprite ), Mode )
End Function

Rem
bbdoc: undocumented
End Rem
Function StencilAlpha( stencil:TStencil, a:Float )
	StencilAlpha_( TObject.IsObject( stencil ), a )
End Function

Rem
bbdoc: undocumented
End Rem
Function StencilClsColor( stencil:TStencil, r:Float, g:Float, b:Float )
	StencilClsColor_( TObject.IsObject( stencil ), r, g, b )
End Function

Rem
bbdoc: undocumented
End Rem
Function StencilClsMode( stencil:TStencil, cls_depth:Int, cls_zbuffer:Int )
	StencilClsMode_( TObject.IsObject( stencil ), cls_depth, cls_zbuffer )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainHeight">Online doc</a>
End Rem
Function TerrainHeight:Float( terr:TTerrain, x:Int, z:Int )
	Return TerrainHeight_( TObject.IsObject( terr ), x, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainX">Online doc</a>
End Rem
Function TerrainX:Float( terr:TTerrain, x:Float, y:Float, z:Float )
	Return TerrainX_( TObject.IsObject( terr ), x, y, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainY">Online doc</a>
End Rem
Function TerrainY:Float( terr:TTerrain, x:Float, y:Float, z:Float )
	Return TerrainY_( TObject.IsObject( terr ), x, y, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainZ">Online doc</a>
End Rem
Function TerrainZ:Float( terr:TTerrain, x:Float, y:Float, z:Float )
	Return TerrainZ_( TObject.IsObject( terr ), x, y, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureBlend">Online doc</a>
End Rem
Function TextureBlend( tex:TTexture, blend:Int )
	TextureBlend_( TObject.IsObject( tex ), blend )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureCoords">Online doc</a>
End Rem
Function TextureCoords( tex:TTexture, coords:Int )
	TextureCoords_( TObject.IsObject( tex ), coords )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureHeight">Online doc</a>
End Rem
Function TextureHeight:Int( tex:TTexture )
	Return TextureHeight_( TObject.IsObject( tex ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureFilter">Online doc</a>
End Rem
Function TextureFilter( match_text:String, flags:Int )
	Local cString:Byte Ptr=match_text.ToCString()
	TextureFilter_( cString, flags )
	MemFree cString
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureName">Online doc</a>
End Rem
Function TextureName:String( tex:TTexture )
	Return String.FromCString( TextureName_( TObject.IsObject( tex ) ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureWidth">Online doc</a>
End Rem
Function TextureWidth:Int( tex:TTexture )
	Return TextureWidth_( TObject.IsObject( tex ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormNormal">Online doc</a>
End Rem
Function TFormNormal( x:Float, y:Float, z:Float, src_ent:TEntity, dest_ent:TEntity )
	TFormNormal_( x, y, z, TObject.IsObject( src_ent ), TObject.IsObject( dest_ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormPoint">Online doc</a>
End Rem
Function TFormPoint( x:Float, y:Float, z:Float, src_ent:TEntity, dest_ent:TEntity )
	TFormPoint_( x, y, z, TObject.IsObject( src_ent ), TObject.IsObject( dest_ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormVector">Online doc</a>
End Rem
Function TFormVector( x:Float, y:Float, z:Float, src_ent:TEntity, dest_ent:TEntity )
	TFormVector_( x, y, z, TObject.IsObject( src_ent ), TObject.IsObject( dest_ent ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TriangleVertex">Online doc</a>
End Rem
Function TriangleVertex:Int( surf:TSurface, tri_no:Int, corner:Int )
	Return TriangleVertex_( TObject.IsObject( surf ), tri_no, corner )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateNormals">Online doc</a>
End Rem
Function UpdateNormals( mesh:TMesh )
	UpdateNormals_( TObject.IsObject( mesh ) )
End Function

Rem
bbdoc: undocumented
End Rem
Function UpdateTexCoords( surf:TSurface )
	UpdateTexCoords_( TObject.IsObject( surf ) )
End Function

Rem
bbdoc: undocumented
End Rem
Function UseStencil( stencil:TStencil )
	UseStencil_( TObject.IsObject( stencil ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexAlpha">Online doc</a>
End Rem
Function VertexAlpha:Float( surf:TSurface, vid:Int )
	Return VertexAlpha_( TObject.IsObject( surf ), vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexBlue">Online doc</a>
End Rem
Function VertexBlue:Float( surf:TSurface, vid:Int )
	Return VertexBlue_( TObject.IsObject( surf ), vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexCoords">Online doc</a>
End Rem
Function VertexCoords( surf:TSurface, vid:Int, x:Float, y:Float, z:Float )
	VertexCoords_( TObject.IsObject( surf ), vid, x, y, z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexGreen">Online doc</a>
End Rem
Function VertexGreen:Float( surf:TSurface, vid:Int )
	Return VertexGreen_( TObject.IsObject( surf ), vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNormal">Online doc</a>
End Rem
Function VertexNormal( surf:TSurface, vid:Int, nx:Float, ny:Float, nz:Float )
	VertexNormal_( TObject.IsObject( surf ), vid, nx, ny, nz )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNX">Online doc</a>
End Rem
Function VertexNX:Float( surf:TSurface, vid:Int )
	Return VertexNX_( TObject.IsObject( surf ), vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNY">Online doc</a>
End Rem
Function VertexNY:Float( surf:TSurface, vid:Int )
	Return VertexNY_( TObject.IsObject( surf ), vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNZ">Online doc</a>
End Rem
Function VertexNZ:Float( surf:TSurface, vid:Int )
	Return VertexNZ_( TObject.IsObject( surf ), vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexRed">Online doc</a>
End Rem
Function VertexRed:Float( surf:TSurface, vid:Int )
	Return VertexRed_( TObject.IsObject( surf ), vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexX">Online doc</a>
End Rem
Function VertexX:Float( surf:TSurface, vid:Int )
	Return VertexX_( TObject.IsObject( surf ), vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexY">Online doc</a>
End Rem
Function VertexY:Float( surf:TSurface, vid:Int )
	Return VertexY_( TObject.IsObject( surf ), vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexZ">Online doc</a>
End Rem
Function VertexZ:Float( surf:TSurface, vid:Int )
	Return VertexZ_( TObject.IsObject( surf ), vid )
End Function

Rem
bbdoc: undocumented
End Rem
Function VoxelSpriteMaterial( voxelspr:TVoxelSprite, mat:TMaterial )
	VoxelSpriteMaterial_( TObject.IsObject( voxelspr ), TObject.IsObject( mat ) )
End Function

' ***extras***

Rem
bbdoc: Load shader from two files, vertex and fragment.
End Rem
Function LoadShader:TShader( ShaderName:String, VshaderFileName:String, FshaderFileName:String )
	Local cString:Byte Ptr=ShaderName.ToCString()
	Local vcString:Byte Ptr=VshaderFileName.ToCString()
	Local fcString:Byte Ptr=FshaderFileName.ToCString()
	Local instance:Byte Ptr=LoadShader_( cString, vcString, fcString )
	Local material:TShader=globals.material.NewShader( instance )
	MemFree cString
	MemFree vcString
	MemFree fcString
	Return material
End Function

Rem
bbdoc: Load shader from two strings, vertex and fragment.
End Rem
Function CreateShader:TShader( ShaderName:String, VshaderString:String, FshaderString:String )
	Local cString:Byte Ptr=ShaderName.ToCString()
	Local vcString:Byte Ptr=VshaderString.ToCString()
	Local fcString:Byte Ptr=FshaderString.ToCString()
	Local instance:Byte Ptr=CreateShader_( cString, vcString, fcString )
	Local material:TShader=globals.material.NewShader( instance )
	MemFree cString
	MemFree vcString
	MemFree fcString
	Return material
End Function

Rem
bbdoc: Apply shader to a surface.
End Rem
Function ShadeSurface( surf:TSurface, material:TShader )
	ShadeSurface_( TObject.IsObject( surf ), TObject.IsObject( material ) )
End Function

Rem
bbdoc: Apply shader to a mesh.
End Rem
Function ShadeMesh( mesh:TMesh, material:TShader )
	ShadeMesh_( TObject.IsObject( mesh ), TObject.IsObject( material ) )
End Function

Rem
bbdoc: Apply shader to an entity.
End Rem
Function ShadeEntity( ent:TEntity, material:TShader )
	ShadeEntity_( TObject.IsObject( ent ), TObject.IsObject( material ) )
End Function

Rem
bbdoc: Set a shader variable name of a uniform float type to a float value.
End Rem
Function SetFloat( material:TShader, name:String, v1:Float )
	Local cString:Byte Ptr=name.ToCString()
	SetFloat_( TObject.IsObject( material ), cString, v1 )
	MemFree cString
End Function

Rem
bbdoc: Set a shader variable name of a uniform vec2 type to 2 float values.
End Rem
Function SetFloat2( material:TShader, name:String, v1:Float, v2:Float )
	Local cString:Byte Ptr=name.ToCString()
	SetFloat2_( TObject.IsObject( material ), cString, v1, v2 )
	MemFree cString
End Function

Rem
bbdoc: Set a shader variable name of a uniform vec3 type to 3 float values.
End Rem
Function SetFloat3( material:TShader, name:String, v1:Float, v2:Float, v3:Float )
	Local cString:Byte Ptr=name.ToCString()
	SetFloat3_( TObject.IsObject( material ), cString, v1, v2, v3 )
	MemFree cString
End Function

Rem
bbdoc: Set a shader variable name of a uniform vec4 type to 4 float values.
End Rem
Function SetFloat4( material:TShader, name:String, v1:Float, v2:Float, v3:Float, v4:Float )
	Local cString:Byte Ptr=name.ToCString()
	SetFloat4_( TObject.IsObject( material ), cString, v1, v2, v3, v4 )
	MemFree cString
End Function

Rem
bbdoc: Bind a float variable to a shader variable name of a uniform float type.
End Rem
Function UseFloat( material:TShader, name:String, v1:Float Var )
	Local cString:Byte Ptr=name.ToCString()
	UseFloat_( TObject.IsObject( material ), cString, Varptr(v1) )
	MemFree cString
End Function

Rem
bbdoc: Bind 2 float variables to a shader variable name of a uniform vec2 type.
End Rem
Function UseFloat2( material:TShader, name:String, v1:Float Var, v2:Float Var )
	Local cString:Byte Ptr=name.ToCString()
	UseFloat2_( TObject.IsObject( material ), cString, Varptr(v1), Varptr(v2) )
	MemFree cString
End Function

Rem
bbdoc: Bind 3 float variables to a shader variable name of a uniform vec3 type.
End Rem
Function UseFloat3( material:TShader, name:String, v1:Float Var, v2:Float Var, v3:Float Var )
	Local cString:Byte Ptr=name.ToCString()
	UseFloat3_( TObject.IsObject( material ), cString, Varptr(v1), Varptr(v2), Varptr(v3) )
	MemFree cString
End Function

Rem
bbdoc: Bind 4 float variables to a shader variable name of a uniform vec4 type.
End Rem
Function UseFloat4( material:TShader, name:String, v1:Float Var, v2:Float Var, v3:Float Var, v4:Float Var )
	Local cString:Byte Ptr=name.ToCString()
	UseFloat4_( TObject.IsObject( material ), cString, Varptr(v1), Varptr(v2), Varptr(v3), Varptr(v4) )
	MemFree cString
End Function

Rem
bbdoc: Set a shader variable name of a uniform int type to an integer value.
End Rem
Function SetInteger( material:TShader, name:String, v1:Int )
	Local cString:Byte Ptr=name.ToCString()
	SetInteger_( TObject.IsObject( material ), cString, v1 )
	MemFree cString
End Function

Rem
bbdoc: Set a shader variable name of a uniform ivec2 type to 2 integer values.
End Rem
Function SetInteger2( material:TShader, name:String, v1:Int, v2:Int )
	Local cString:Byte Ptr=name.ToCString()
	SetInteger2_( TObject.IsObject( material ), cString, v1, v2 )
	MemFree cString
End Function

Rem
bbdoc: Set a shader variable name of a uniform ivec3 type to 3 integer values.
End Rem
Function SetInteger3( material:TShader, name:String, v1:Int, v2:Int, v3:Int )
	Local cString:Byte Ptr=name.ToCString()
	SetInteger3_( TObject.IsObject( material ), cString, v1, v2, v3 )
	MemFree cString
End Function

Rem
bbdoc: Set a shader variable name of a uniform ivec4 type to 4 integer values.
End Rem
Function SetInteger4( material:TShader, name:String, v1:Int, v2:Int, v3:Int, v4:Int )
	Local cString:Byte Ptr=name.ToCString()
	SetInteger4_( TObject.IsObject( material ), cString, v1, v2, v3, v4 )
	MemFree cString
End Function

Rem
bbdoc: Bind an integer variable to a shader variable name of a uniform int type.
End Rem
Function UseInteger( material:TShader, name:String, v1:Int Var )
	Local cString:Byte Ptr=name.ToCString()
	UseInteger_( TObject.IsObject( material ), cString, Varptr(v1) )
	MemFree cString
End Function

Rem
bbdoc: Bind 2 integer variables to a shader variable name of a uniform ivec2 type.
End Rem
Function UseInteger2( material:TShader, name:String, v1:Int Var, v2:Int Var )
	Local cString:Byte Ptr=name.ToCString()
	UseInteger2_( TObject.IsObject( material ), cString, Varptr(v1), Varptr(v2) )
	MemFree cString
End Function

Rem
bbdoc: Bind 3 integer variables to a shader variable name of a uniform ivec3 type.
End Rem
Function UseInteger3( material:TShader, name:String, v1:Int Var, v2:Int Var, v3:Int Var )
	Local cString:Byte Ptr=name.ToCString()
	UseInteger3_( TObject.IsObject( material ), cString, Varptr(v1), Varptr(v2), Varptr(v3) )
	MemFree cString
End Function

Rem
bbdoc: Bind 4 integer variables to a shader variable name of a uniform ivec4 type.
End Rem
Function UseInteger4( material:TShader, name:String, v1:Int Var, v2:Int Var, v3:Int Var, v4:Int Var )
	Local cString:Byte Ptr=name.ToCString()
	UseInteger4_( TObject.IsObject( material ), cString, Varptr(v1), Varptr(v2), Varptr(v3), Varptr(v4) )
	MemFree cString
End Function

Rem
bbdoc: undocumented
End Rem
Function UseSurface( material:TShader, name:String, surf:TSurface, vbo:Int )
	Local cString:Byte Ptr=name.ToCString()
	UseSurface_( TObject.IsObject( material ), cString, TObject.IsObject( surf ), vbo )
	MemFree cString
End Function

Rem
bbdoc: Send matrix data to a shader variable name of a uniform mat4 type.
If mode is true it sends camera matrix otherwise projection matrix.
End Rem
Function UseMatrix( material:TShader, name:String, Mode:Int )
	Local cString:Byte Ptr=name.ToCString()
	UseMatrix_( TObject.IsObject( material ), cString, Mode )
	MemFree cString
End Function

Rem
bbdoc: undocumented
End Rem
Function LoadMaterial:TMaterial( filename:String, flags:Int, frame_width:Int, frame_height:Int, first_frame:Int, frame_count:Int )
	Local cString:Byte Ptr=filename.ToCString()
	Local instance:Byte Ptr=LoadMaterial_( cString, flags, frame_width, frame_height, first_frame, frame_count )
	Local mat:TMaterial=globals.mat.NewMaterial( instance )
	MemFree cString
	Return mat
End Function


' Wrapper functions with default arguments (can't be set in declarations)
' -----------------------------------------------------------------------

Rem
bbdoc: Copy the contents of the backbuffer to a texture.
End Rem
Function BackBufferToTex( tex:TTexture, frame:Int=0 )
	BackBufferToTex_( TObject.IsObject( tex ), frame )
End Function

Rem
bbdoc: Copy a pixmap buffer to texture, buffer must be a byte ptr.
End Rem
Function BufferToTex( tex:TTexture, buffer:Byte Ptr, frame:Int=0 )
	BufferToTex_( TObject.IsObject( tex ), buffer, frame )
End Function

Rem
bbdoc: Copy a rendered camera view to texture.
End Rem
Function CameraToTex( tex:TTexture, cam:TCamera, frame:Int=0 )
	CameraToTex_( TObject.IsObject( tex ), TObject.IsObject( cam ), frame )
End Function

Rem
bbdoc: Copy a texture to a pixmap buffer, buffer must be a byte ptr.
End Rem
Function TexToBuffer( tex:TTexture, buffer:Byte Ptr, frame:Int=0 )
	TexToBuffer_( TObject.IsObject( tex ), buffer, frame )
End Function

' Blitz3D functions, A-Z

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddVertex">Online doc</a>
End Rem
Function AddVertex:Int( surf:TSurface, x:Float, y:Float, z:Float, u:Float=0, v:Float=0, w:Float=0 )
	Return AddVertex_( TObject.IsObject( surf ), x, y, z, u, v, w )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animate">Online doc</a>
End Rem
Function Animate( ent:TEntity, Mode:Int=1, speed:Float=1, seq:Int=0, trans:Int=0 )
	Animate_( TObject.IsObject( ent ), Mode, speed, seq, trans )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushTexture">Online doc</a>
End Rem
Function BrushTexture( brush:TBrush, tex:TTexture, frame:Int=0, index:Int=0 )
	BrushTexture_( TObject.IsObject( brush ), TObject.IsObject( tex ), frame, index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearSurface">Online doc</a>
End Rem
Function ClearSurface( surf:TSurface, clear_verts:Int=True, clear_tris:Int=True )
	ClearSurface_( TObject.IsObject( surf ), clear_verts, clear_tris )
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
	Local instance:Byte Ptr=CopyEntity_( TObject.IsObject( ent ), TObject.IsObject( parent ) )
	Local copy:TEntity=globals.ent.NewEntity( instance )
	Return copy
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyMesh">Online doc</a>
End Rem
Function CopyMesh:TMesh( mesh:TMesh, parent:TEntity=Null )
	Local instance:Byte Ptr=CopyMesh_( TObject.IsObject( mesh ), TObject.IsObject( parent ) )
	Local copy:TMesh=globals.mesh.NewMesh( instance )
	Return copy
End Function

Rem
bbdoc: undocumented
End Rem
Function CreateBlob:TBlob( fluid:TFluid, radius:Float, parent_ent:TEntity=Null )
	Local instance:Byte Ptr=CreateBlob_( TObject.IsObject( fluid ), radius, TObject.IsObject( parent_ent ) )
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
	Local instance:Byte Ptr=CreateCamera_( TObject.IsObject( parent ) )
	Local cam:TCamera=globals.cam.NewCamera( instance )
	Return cam
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCone">Online doc</a>
End Rem
Function CreateCone:TMesh( segments:Int=8, solid:Int=True, parent:TEntity=Null )
	Local instance:Byte Ptr=CreateCone_( segments, solid, TObject.IsObject( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCylinder">Online doc</a>
End Rem
Function CreateCylinder:TMesh( segments:Int=8, solid:Int=True, parent:TEntity=Null )
	Local instance:Byte Ptr=CreateCylinder_( segments, solid, TObject.IsObject( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCube">Online doc</a>
End Rem
Function CreateCube:TMesh( parent:TEntity=Null )
	Local instance:Byte Ptr=CreateCube_( TObject.IsObject( parent ) )
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
	Local instance:Byte Ptr=CreateGeosphere_( size, TObject.IsObject( parent ) )
	Local geo:TGeosphere=globals.geo.NewGeosphere( instance )
	Return geo
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateMesh">Online doc</a>
End Rem
Function CreateMesh:TMesh( parent:TEntity=Null )
	Local instance:Byte Ptr=CreateMesh_( TObject.IsObject( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateLight">Online doc</a>
End Rem
Function CreateLight:TLight( light_type:Int=1, parent:TEntity=Null )
	Local instance:Byte Ptr=CreateLight_( light_type, TObject.IsObject( parent ) )
	Local light:TLight=globals.light.NewLight( instance )
	Return light
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreatePivot">Online doc</a>
End Rem
Function CreatePivot:TPivot( parent:TEntity=Null )
	Local instance:Byte Ptr=CreatePivot_( TObject.IsObject( parent ) )
	Local piv:TPivot=globals.piv.NewPivot( instance )
	Return piv
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreatePlane">Online doc</a>
End Rem
Function CreatePlane:TMesh( divisions:Int=1, parent:TEntity=Null )
	Local instance:Byte Ptr=CreatePlane_( divisions, TObject.IsObject( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: undocumented
End Rem
Function CreateQuad:TMesh( parent:TEntity=Null )
	Local instance:Byte Ptr=CreateQuad_( TObject.IsObject( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: undocumented
End Rem
Function CreateShadow:TShadowObject( parent:TMesh, Static:Int=False )
	Local instance:Byte Ptr=CreateShadow_( TObject.IsObject( parent ), Static )
	Local shad:TShadowObject=globals.shad.NewShadowObject( instance )
	Return shad
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSphere">Online doc</a>
End Rem
Function CreateSphere:TMesh( segments:Int=8, parent:TEntity=Null )
	Local instance:Byte Ptr=CreateSphere_( segments, TObject.IsObject( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSprite">Online doc</a>
End Rem
Function CreateSprite:TSprite( parent:TEntity=Null )
	Local instance:Byte Ptr=CreateSprite_( TObject.IsObject( parent ) )
	Local sprite:TSprite=globals.sprite.NewSprite( instance )
	Return sprite
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSurface">Online doc</a>
End Rem
Function CreateSurface:TSurface( mesh:TMesh, brush:TBrush=Null )
	Local instance:Byte Ptr=CreateSurface_( TObject.IsObject( mesh ), TObject.IsObject( brush ) )
	Local surf:TSurface=globals.surf.NewSurface( instance )
	Return surf
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateTerrain">Online doc</a>
End Rem
Function CreateTerrain:TTerrain( size:Int, parent:TEntity=Null )
	Local instance:Byte Ptr=CreateTerrain_( size, TObject.IsObject( parent ) )
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
	Local instance:Byte Ptr=CreateVoxelSprite_( slices, TObject.IsObject( parent ) )
	Local voxelspr:TVoxelSprite=globals.voxelspr.NewVoxelSprite( instance )
	Return voxelspr
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityParent">Online doc</a>
End Rem
Function EntityParent( ent:TEntity, parent_ent:TEntity, glob:Int=True )
	EntityParent_( TObject.IsObject( ent ), TObject.IsObject( parent_ent ), glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPickMode">Online doc</a>
End Rem
Function EntityPickMode( ent:TEntity, pick_mode:Int, obscurer:Int=True )
	EntityPickMode_( TObject.IsObject( ent ), pick_mode, obscurer )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPitch">Online doc</a>
End Rem
Function EntityPitch:Float( ent:TEntity, glob:Int=False )
	Return -EntityPitch_( TObject.IsObject( ent ), glob ) ' inverted pitch
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRadius">Online doc</a>
End Rem
Function EntityRadius( ent:TEntity, radius_x:Float, radius_y:Float=0 )
	EntityRadius_( TObject.IsObject( ent ), radius_x, radius_y )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRoll">Online doc</a>
End Rem
Function EntityRoll:Float( ent:TEntity, glob:Int=True )
	Return EntityRoll_( TObject.IsObject( ent ), glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityTexture">Online doc</a>
End Rem
Function EntityTexture( ent:TEntity, tex:TTexture, frame:Int=0, index:Int=0 )
	EntityTexture_( TObject.IsObject( ent ), TObject.IsObject( tex ), frame, index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityType">Online doc</a>
End Rem
Function EntityType( ent:TEntity, type_no:Int, recursive:Int=False )
	EntityType_( TObject.IsObject( ent ), type_no, recursive )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityX">Online doc</a>
End Rem
Function EntityX:Float( ent:TEntity, glob:Int=False )
	Return EntityX_( TObject.IsObject( ent ), glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityY">Online doc</a>
End Rem
Function EntityY:Float( ent:TEntity, glob:Int=False )
	Return EntityY_( TObject.IsObject( ent ), glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityYaw">Online doc</a>
End Rem
Function EntityYaw:Float( ent:TEntity, glob:Int=False )
	Return EntityYaw_( TObject.IsObject( ent ), glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityZ">Online doc</a>
End Rem
Function EntityZ:Float( ent:TEntity, glob:Int=False )
	Return EntityZ_( TObject.IsObject( ent ), glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ExtractAnimSeq">Online doc</a>
End Rem
Function ExtractAnimSeq:Int( ent:TEntity, first_frame:Int, last_frame:Int, seq:Int=0 )
	Return ExtractAnimSeq_( TObject.IsObject( ent ), first_frame, last_frame, seq )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FitMesh">Online doc</a>
End Rem
Function FitMesh( mesh:TMesh, x:Float, y:Float, z:Float, width:Float, height:Float, depth:Float, uniform:Int=False )
	FitMesh_( TObject.IsObject( mesh ), x, y, z, width, height, depth, uniform )
End Function

Rem
bbdoc: undocumented
End Rem
Function FreeShadow( shad:TShadowObject )
	shad.DeleteShadowObject( TObject.IsObject( shad ) )
	FreeShadow_( TObject.IsObject( shad ) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetBrushTexture">Online doc</a>
End Rem
Function GetBrushTexture:TTexture( brush:TBrush, index:Int=0 )
	Local instance:Byte Ptr=GetBrushTexture_( TObject.IsObject( brush ), index )
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
	Local cString:Byte Ptr=file.ToCString()
	Local instance:Byte Ptr=LoadAnimMesh_( cString, TObject.IsObject( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	MemFree cString
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadBrush">Online doc</a>
End Rem
Function LoadBrush:TBrush( file:String, flags:Int=1, u_scale:Float=1, v_scale:Float=1 )
	Local cString:Byte Ptr=file.ToCString()
	Local instance:Byte Ptr=LoadBrush_( cString, flags, u_scale, v_scale )
	Local brush:TBrush=globals.brush.NewBrush( instance )
	MemFree cString
	Return brush
End Function

Rem
bbdoc: undocumented
End Rem
Function LoadGeosphere:TGeosphere( file:String, parent:TEntity=Null )
	Local cString:Byte Ptr=file.ToCString()
	Local instance:Byte Ptr=LoadGeosphere_( cString, TObject.IsObject( parent ) )
	Local geo:TGeosphere=globals.geo.NewGeosphere( instance )
	MemFree cString
	Return geo
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadMesh">Online doc</a>
End Rem
Function LoadMesh:TMesh( file:String, parent:TEntity=Null )
	Local cString:Byte Ptr=file.ToCString()
	Local instance:Byte Ptr=LoadMesh_( cString, TObject.IsObject( parent ) )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	MemFree cString
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadTerrain">Online doc</a>
End Rem
Function LoadTerrain:TTerrain( file:String, parent:TEntity=Null )
	Local cString:Byte Ptr=file.ToCString()
	Local instance:Byte Ptr=LoadTerrain_( cString, TObject.IsObject( parent ) )
	Local terr:TTerrain=globals.terr.NewTerrain( instance )
	MemFree cString
	Return terr
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadTexture">Online doc</a>
End Rem
Function LoadTexture:TTexture( file:String, flags:Int=1 )
	Local cString:Byte Ptr=file.ToCString()
	Local instance:Byte Ptr=LoadTexture_( cString, flags )
	Local tex:TTexture=globals.tex.NewTexture( instance )
	MemFree cString
	Return tex
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadSprite">Online doc</a>
End Rem
Function LoadSprite:TSprite( tex_file:String, tex_flag:Int=1, parent:TEntity=Null )
	Local cString:Byte Ptr=tex_file.ToCString()
	Local instance:Byte Ptr=LoadSprite_( cString, tex_flag, TObject.IsObject( parent ) )
	Local sprite:TSprite=globals.sprite.NewSprite( instance )
	MemFree cString
	Return sprite
End Function

Rem
bbdoc: undocumented
End Rem
Function MeshCSG:TMesh( m1:TMesh, m2:TMesh, method_no:Int=1 )
	Local instance:Byte Ptr=MeshCSG_( TObject.IsObject( m1 ), TObject.IsObject( m2 ), method_no )
	Local mesh:TMesh=globals.mesh.NewMesh( instance )
	Return mesh
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PointEntity">Online doc</a>
End Rem
Function PointEntity( ent:TEntity, target_ent:TEntity, roll:Float=0 )
	PointEntity_( TObject.IsObject( ent ), TObject.IsObject( target_ent ), roll )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionEntity">Online doc</a>
End Rem
Function PositionEntity( ent:TEntity, x:Float, y:Float, z:Float, glob:Int=False )
	PositionEntity_( TObject.IsObject( ent ), x, y, z, glob )
End Function

Rem
bbdoc: Like CopyMesh but for instancing effects.
End Rem
Function RepeatMesh:TMesh( mesh:TMesh, parent:TEntity=Null )
	Local instance:Byte Ptr=RepeatMesh_( TObject.IsObject( mesh ), TObject.IsObject( parent ) )
	Local copy:TMesh=globals.mesh.NewMesh( instance )
	Return copy
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateEntity">Online doc</a>
End Rem
Function RotateEntity( ent:TEntity, x:Float, y:Float, z:Float, glob:Int=False )
	RotateEntity_( TObject.IsObject( ent ), -x, y, z, glob ) ' inverted pitch
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleEntity">Online doc</a>
End Rem
Function ScaleEntity( ent:TEntity, x:Float, y:Float, z:Float, glob:Int=False )
	ScaleEntity_( TObject.IsObject( ent ), x, y, z, glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetAnimTime">Online doc</a>
End Rem
Function SetAnimTime( ent:TEntity, time:Float, seq:Int=0 )
	SetAnimTime_( TObject.IsObject( ent ), time, seq )
End Function

Rem
bbdoc: undocumented
End Rem
Function StencilMesh( stencil:TStencil, mesh:TMesh, Mode:Int=1 )
	StencilMesh_( TObject.IsObject( stencil ), TObject.IsObject( mesh ), Mode )
End Function

Rem
bbdoc: undocumented
End Rem
Function StencilMode( stencil:TStencil, m:Int, o:Int=1 )
	StencilMode_( TObject.IsObject( stencil ), m, o )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TranslateEntity">Online doc</a>
End Rem
Function TranslateEntity( ent:TEntity, x:Float, y:Float, z:Float, glob:Int=False )
	TranslateEntity_( TObject.IsObject( ent ), x, y, z, glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TurnEntity">Online doc</a>
End Rem
Function TurnEntity( ent:TEntity, x:Float, y:Float, z:Float, glob:Int=False )
	TurnEntity_( TObject.IsObject( ent ), -x, y, z, glob ) ' inverted pitch
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
	VertexColor_( TObject.IsObject( surf ), vid, r, g, b, a )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexTexCoords">Online doc</a>
End Rem
Function VertexTexCoords( surf:TSurface, vid:Int, u:Float, v:Float, w:Float=0, coord_set:Int=0 )
	VertexTexCoords_( TObject.IsObject( surf ), vid, u, v, w, coord_set )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexU">Online doc</a>
End Rem
Function VertexU:Float( surf:TSurface, vid:Int, coord_set:Int=0 )
	Return VertexU_( TObject.IsObject( surf ), vid, coord_set )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexV">Online doc</a>
End Rem
Function VertexV:Float( surf:TSurface, vid:Int, coord_set:Int=0 )
	Return VertexV_( TObject.IsObject( surf ), vid, coord_set )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexW">Online doc</a>
End Rem
Function VertexW:Float( surf:TSurface, vid:Int, coord_set:Int=0 )
	Return VertexW_( TObject.IsObject( surf ), vid, coord_set )
End Function

' ***extras***

Rem
bbdoc: undocumented
End Rem
Function EntityScaleX:Float( ent:TEntity, glob:Int=False )
	Return EntityScaleX_( TObject.IsObject( ent ), glob )
End Function

Rem
bbdoc: undocumented
End Rem
Function EntityScaleY:Float( ent:TEntity, glob:Int=False )
	Return EntityScaleY_( TObject.IsObject( ent ), glob )
End Function

Rem
bbdoc: undocumented
End Rem
Function EntityScaleZ:Float( ent:TEntity, glob:Int=False )
	Return EntityScaleZ_( TObject.IsObject( ent ), glob )
End Function

Rem
bbdoc: Load a texture for 2D texture sampling.
End Rem
Function ShaderTexture( material:TShader, tex:TTexture, name:String, index:Int=0 )
	Local cString:Byte Ptr=name.ToCString()
	ShaderTexture_( TObject.IsObject( material ), TObject.IsObject( tex ), cString, index )
	MemFree cString
End Function

Rem
bbdoc: Load a texture for 3D texture sampling.
End Rem
Function ShaderMaterial( material:TShader, tex:TMaterial, name:String, index:Int=0 )
	Local cString:Byte Ptr=name.ToCString()
	ShaderMaterial_( TObject.IsObject( material ), TObject.IsObject( tex ), cString, index )
	MemFree cString
End Function

Rem
bbdoc: undocumented
End Rem
Function CreateOcTree:TOcTree( w:Float, h:Float, d:Float, parent_ent:TEntity=Null )
	Local instance:Byte Ptr=CreateOcTree_( w, h, d, TObject.IsObject( parent_ent ) )
	Local octree:TOcTree=globals.octree.NewOcTree( instance )
	Return octree
End Function

Rem
bbdoc: undocumented
End Rem
Function OctreeBlock( octree:TOcTree, mesh:TMesh, level:Int, X:Float, Y:Float, Z:Float, Near:Float=0, Far:Float=1000 )
	OctreeBlock_( TObject.IsObject( octree ), TObject.IsObject( mesh ), level, X, Y, Z, Near, Far )
End Function

Rem
bbdoc: undocumented
End Rem
Function OctreeMesh( octree:TOcTree, mesh:TMesh, level:Int, X:Float, Y:Float, Z:Float, Near:Float=0, Far:Float=1000 )
	OctreeMesh_( TObject.IsObject( octree ), TObject.IsObject( mesh ), level, X, Y, Z, Near, Far )
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
	RenderWorld_()
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
