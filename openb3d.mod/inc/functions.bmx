' functions.bmx

' *** Todo

Rem
bbdoc: Currently does nothing
End Rem
Function BackBuffer()
End Function

Rem
bbdoc: Currently does nothing
End Rem
Function FrontBuffer()
End Function

Rem
bbdoc: Currently does nothing
End Rem
Function ImageBuffer( handle%,frame%=0 )
End Function

Rem
bbdoc: Currently does nothing
End Rem
Function SetBuffer( buffer:Int=0 )
End Function

Rem
bbdoc: Currently does nothing
End Rem
Function CopyRect( src_x%,src_y%,src_width%,src_height%,dest_x%,dest_y%,src_buffer%=0,dest_buffer%=0 )
End Function

' *** Blitz3D functions, A-Z (in Minib3d)

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddMesh">Online doc</a>
End Rem
Function AddMesh( mesh1:TMesh,mesh2:TMesh )
	mesh1.AddMesh( mesh2 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddTriangle">Online doc</a>
End Rem
Function AddTriangle:Int( surf:TSurface,v0:Int,v1:Int,v2:Int )
	Return surf.AddTriangle( v0,v1,v2 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddVertex">Online doc</a>
End Rem
Function AddVertex:Int( surf:TSurface,x:Float,y:Float,z:Float,u:Float=0,v:Float=0,w:Float=0 )
	Return surf.AddVertex( x,y,z,u,v,w )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AmbientLight">Online doc</a>
End Rem
Function AmbientLight( r:Float,g:Float,b:Float )
	TGlobal.AmbientLight( r,g,b )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animate">Online doc</a>
End Rem
Function Animate( ent:TEntity,Mode:Int=1,speed:Float=1,seq:Int=0,trans:Int=0 )
	ent.Animate( Mode,speed,seq,trans )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animating">Online doc</a>
End Rem
Function Animating:Int( ent:TEntity )
	Return Animating_( TEntity.GetInstance(ent) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimLength">Online doc</a>
End Rem
Function AnimLength:Int( ent:TEntity )
	Return ent.AnimLength()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimSeq">Online doc</a>
End Rem
Function AnimSeq:Int( ent:TEntity )
	Return AnimSeq_( TEntity.GetInstance(ent) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimTime">Online doc</a>
End Rem
Function AnimTime:Float( ent:TEntity )
	Return ent.AnimTime()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AntiAlias">Online doc</a>
End Rem
Rem
' removed since it was too slow and used the accum buffer
Function AntiAlias( samples:Int )
	TGlobal.AntiAlias( samples )
End Function
EndRem

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushAlpha">Online doc</a>
End Rem
Function BrushAlpha( brush:TBrush,a:Float )
	brush.BrushAlpha( a )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushBlend">Online doc</a>
End Rem
Function BrushBlend( brush:TBrush,blend:Int )
	brush.BrushBlend( blend )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushColor">Online doc</a>
End Rem
Function BrushColor( brush:TBrush,r:Float,g:Float,b:Float )
	brush.BrushColor( r,g,b )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushFX">Online doc</a>
End Rem
Function BrushFX( brush:TBrush,fx:Int )
	brush.BrushFX( fx )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushShininess">Online doc</a>
End Rem
Function BrushShininess( brush:TBrush,s:Float )
	brush.BrushShininess( s )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushTexture">Online doc</a>
End Rem
Function BrushTexture( brush:TBrush,tex:TTexture,frame:Int=0,index:Int=0 )
	brush.BrushTexture( tex,frame,index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsColor">Online doc</a>
End Rem
Function CameraClsColor( cam:TCamera,r:Float,g:Float,b:Float )
	cam.CameraClsColor( r,g,b )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsMode">Online doc</a>
End Rem
Function CameraClsMode( cam:TCamera,cls_depth:Int,cls_zbuffer:Int )
	cam.CameraClsMode( cls_depth,cls_zbuffer )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogColor">Online doc</a>
End Rem
Function CameraFogColor( cam:TCamera,r:Float,g:Float,b:Float )
	cam.CameraFogColor( r,g,b )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogMode">Online doc</a>
End Rem
Function CameraFogMode( cam:TCamera,Mode:Int )
	cam.CameraFogMode( Mode )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogRange">Online doc</a>
End Rem
Function CameraFogRange( cam:TCamera,nnear:Float,nfar:Float )
	cam.CameraFogRange( nnear,nfar )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraPick">Online doc</a>
End Rem
Function CameraPick:TEntity( cam:TCamera,x:Float,y:Float )
	Return cam.CameraPick( x,y )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProject">Online doc</a>
End Rem
Function CameraProject( cam:TCamera,x:Float,y:Float,z:Float )
	cam.CameraProject( x,y,z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProjMode">Online doc</a>
End Rem
Function CameraProjMode( cam:TCamera,Mode:Int )
	cam.CameraProjMode( Mode )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraRange">Online doc</a>
End Rem
Function CameraRange( cam:TCamera,nnear:Float,nfar:Float )
	cam.CameraRange( nnear,nfar )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraViewport">Online doc</a>
End Rem
Function CameraViewport( cam:TCamera,x:Int,y:Int,width:Int,height:Int )
	cam.CameraViewport( x,y,width,height )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraZoom">Online doc</a>
End Rem
Function CameraZoom( cam:TCamera,zoom:Float )
	cam.CameraZoom( zoom )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearCollisions">Online doc</a>
End Rem
Function ClearCollisions()
	TGlobal.ClearCollisions()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearSurface">Online doc</a>
End Rem
Function ClearSurface( surf:TSurface,clear_verts:Int=True,clear_tris:Int=True )
	surf.ClearSurface( clear_verts,clear_tris )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearTextureFilters">Online doc</a>
End Rem
Function ClearTextureFilters()
	TTexture.ClearTextureFilters()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearWorld">Online doc</a>
End Rem
Function ClearWorld( entities:Int=True,brushes:Int=True,textures:Int=True )
	TGlobal.ClearWorld( entities,brushes,textures )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionEntity">Online doc</a>
End Rem
Function CollisionEntity:TEntity( ent:TEntity,index:Int )
	Return ent.CollisionEntity( index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNX">Online doc</a>
End Rem
Function CollisionNX:Float( ent:TEntity,index:Int )
	Return ent.CollisionNX( index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNY">Online doc</a>
End Rem
Function CollisionNY:Float( ent:TEntity,index:Int )
	Return ent.CollisionNY( index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNZ">Online doc</a>
End Rem
Function CollisionNZ:Float( ent:TEntity,index:Int )
	Return ent.CollisionNZ( index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Collisions">Online doc</a>
End Rem
Function Collisions( src_no:Int,dest_no:Int,method_no:Int,response_no:Int=0 )
	TGlobal.Collisions( src_no,dest_no,method_no,response_no )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionSurface">Online doc</a>
End Rem
Function CollisionSurface:TSurface( ent:TEntity,index:Int )
	Return ent.CollisionSurface( index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTime">Online doc</a>
End Rem
Function CollisionTime:Float( ent:TEntity,index:Int )
	Return ent.CollisionTime( index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTriangle">Online doc</a>
End Rem
Function CollisionTriangle:Int( ent:TEntity,index:Int )
	Return ent.CollisionTriangle( index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionX">Online doc</a>
End Rem
Function CollisionX:Float( ent:TEntity,index:Int )
	Return ent.CollisionX( index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionY">Online doc</a>
End Rem
Function CollisionY:Float( ent:TEntity,index:Int )
	Return ent.CollisionY( index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionZ">Online doc</a>
End Rem
Function CollisionZ:Float( ent:TEntity,index:Int )
	Return ent.CollisionZ( index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyEntity">Online doc</a>
End Rem
Function CopyEntity:TEntity( ent:TEntity,parent:TEntity=Null )
	Return ent.CopyEntity( parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyMesh">Online doc</a>
End Rem
Function CopyMesh:TMesh( mesh:TMesh,parent:TEntity=Null )
	Return mesh.CopyMesh( parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountChildren">Online doc</a>
End Rem
Function CountChildren:Int( ent:TEntity )
	Return ent.CountChildren()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountCollisions">Online doc</a>
End Rem
Function CountCollisions:Int( ent:TEntity )
	Return ent.CountCollisions()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountSurfaces">Online doc</a>
End Rem
Function CountSurfaces:Int( mesh:TMesh )
	Return mesh.CountSurfaces()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountTriangles">Online doc</a>
End Rem
Function CountTriangles:Int( surf:TSurface )
	Return surf.CountTriangles()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountVertices">Online doc</a>
End Rem
Function CountVertices:Int( surf:TSurface )
	Return surf.CountVertices()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateBrush">Online doc</a>
End Rem
Function CreateBrush:TBrush( r:Float=255,g:Float=255,b:Float=255 )
	Return TBrush.CreateBrush( r,g,b )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCamera">Online doc</a>
End Rem
Function CreateCamera:TCamera( parent:TEntity=Null )
	Return TCamera.CreateCamera( parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCone">Online doc</a>
End Rem
Function CreateCone:TMesh( segments:Int=8,solid:Int=True,parent:TEntity=Null )
	Return TMesh.CreateCone( segments,solid,parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCylinder">Online doc</a>
End Rem
Function CreateCylinder:TMesh( segments:Int=8,solid:Int=True,parent:TEntity=Null )
	Return TMesh.CreateCylinder( segments,solid,parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCube">Online doc</a>
End Rem
Function CreateCube:TMesh( parent:TEntity=Null )
	Return TMesh.CreateCube( parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateMesh">Online doc</a>
End Rem
Function CreateMesh:TMesh( parent:TEntity=Null )
	Return TMesh.CreateMesh( parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateLight">Online doc</a>
End Rem
Function CreateLight:TLight( light_type:Int=1,parent:TEntity=Null )
	Return TLight.CreateLight( light_type,parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreatePivot">Online doc</a>
End Rem
Function CreatePivot:TPivot( parent:TEntity=Null )
	Return TPivot.CreatePivot( parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSphere">Online doc</a>
End Rem
Function CreateSphere:TMesh( segments:Int=8,parent:TEntity=Null )
	Return TMesh.CreateSphere( segments,parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSprite">Online doc</a>
End Rem
Function CreateSprite:TSprite( parent:TEntity=Null )
	Return TSprite.CreateSprite( parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSurface">Online doc</a>
End Rem
Function CreateSurface:TSurface( mesh:TMesh,brush:TBrush=Null )
	Return TSurface.CreateSurface( mesh,brush )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateTexture">Online doc</a>
End Rem
Function CreateTexture:TTexture( width:Int,height:Int,flags:Int=9,frames:Int=1 )
	Return TTexture.CreateTexture( width,height,flags,frames )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaPitch">Online doc</a>
End Rem
Function DeltaPitch:Float( ent1:TEntity,ent2:TEntity )
	Return ent1.DeltaPitch( ent2 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaYaw">Online doc</a>
End Rem
Function DeltaYaw:Float( ent1:TEntity,ent2:TEntity )
	Return ent1.DeltaYaw( ent2 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAlpha">Online doc</a>
End Rem
Function EntityAlpha( ent:TEntity,alpha:Float )
	ent.EntityAlpha( alpha )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAutoFade">Online doc</a>
End Rem
Rem
' removed due to having lots of checks per entity - alternative is octrees
Function EntityAutoFade( ent:TEntity,near:Float,far:Float )
	ent.EntityAutoFade( near,far )
End Function
EndRem

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBlend">Online doc</a>
End Rem
Function EntityBlend( ent:TEntity,blend:Int )
	ent.EntityBlend( blend )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBox">Online doc</a>
End Rem
Function EntityBox( ent:TEntity,x:Float,y:Float,z:Float,w:Float,h:Float,d:Float )
	ent.EntityBox( x,y,z,w,h,d )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityClass">Online doc</a>
End Rem
Function EntityClass:String( ent:TEntity )
	Return ent.EntityClass()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityCollided">Online doc</a>
End Rem
Function EntityCollided:TEntity( ent:TEntity,type_no:Int )
	Return ent.EntityCollided( type_no )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityColor">Online doc</a>
End Rem
Function EntityColor( ent:TEntity,red:Float,green:Float,blue:Float )
	ent.EntityColor( red,green,blue )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityDistance">Online doc</a>
End Rem
Function EntityDistance:Float( ent1:TEntity,ent2:TEntity )
	Return ent1.EntityDistance( ent2 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityFX">Online doc</a>
End Rem
Function EntityFX( ent:TEntity,fx:Int )
	ent.EntityFX( fx )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityInView">Online doc</a>
End Rem
Function EntityInView:Int( ent:TEntity,cam:TCamera )
	Return cam.EntityInView( ent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityName">Online doc</a>
End Rem
Function EntityName:String( ent:TEntity )
	Return ent.EntityName()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityOrder">Online doc</a>
End Rem
Function EntityOrder( ent:TEntity,order:Int )
	ent.EntityOrder( order )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityParent">Online doc</a>
End Rem
Function EntityParent( ent:TEntity,parent_ent:TEntity,glob:Int=True )
	ent.EntityParent( parent_ent,glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPick">Online doc</a>
End Rem
Function EntityPick:TEntity( ent:TEntity,Range:Float )
	Return ent.EntityPick( Range )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPickMode">Online doc</a>
End Rem
Function EntityPickMode( ent:TEntity,pick_mode:Int,obscurer:Int=True )
	ent.EntityPickMode( pick_mode,obscurer )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPitch">Online doc</a>
End Rem
Function EntityPitch:Float( ent:TEntity,glob:Int=False )
	Return ent.EntityPitch( glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRadius">Online doc</a>
End Rem
Function EntityRadius( ent:TEntity,radius_x:Float,radius_y:Float=0 )
	ent.EntityRadius( radius_x,radius_y )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRoll">Online doc</a>
End Rem
Function EntityRoll:Float( ent:TEntity,glob:Int=True )
	Return ent.EntityRoll( glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityShininess">Online doc</a>
End Rem
Function EntityShininess( ent:TEntity,shine:Float )
	ent.EntityShininess( shine )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityTexture">Online doc</a>
End Rem
Function EntityTexture( ent:TEntity,tex:TTexture,frame:Int=0,index:Int=0 )
	ent.EntityTexture( tex,frame,index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityType">Online doc</a>.
about: If type_no is negative, collision checking is dynamic, if zero entity is removed.
End Rem
Function EntityType( ent:TEntity,type_no:Int,recursive:Int=False )
	ent.EntityType( type_no,recursive )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityVisible">Online doc</a>
End Rem
Function EntityVisible:Int( src_ent:TEntity,dest_ent:TEntity )
	Return TPick.EntityVisible( src_ent,dest_ent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityX">Online doc</a>
End Rem
Function EntityX:Float( ent:TEntity,glob:Int=False )
	Return ent.EntityX( glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityY">Online doc</a>
End Rem
Function EntityY:Float( ent:TEntity,glob:Int=False )
	Return ent.EntityY( glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityYaw">Online doc</a>
End Rem
Function EntityYaw:Float( ent:TEntity,glob:Int=False )
	Return ent.EntityYaw( glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityZ">Online doc</a>
End Rem
Function EntityZ:Float( ent:TEntity,glob:Int=False )
	Return ent.EntityZ( glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ExtractAnimSeq">Online doc</a>
End Rem
Function ExtractAnimSeq:Int( ent:TEntity,first_frame:Int,last_frame:Int,seq:Int=0 )
	Return ent.ExtractAnimSeq( first_frame,last_frame,seq )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindChild">Online doc</a>
End Rem
Function FindChild:TEntity( ent:TEntity,child_name:String )
	Return ent.FindChild( child_name )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindSurface">Online doc</a>
End Rem
Function FindSurface:TSurface( mesh:TMesh,brush:TBrush )
	Return mesh.FindSurface( brush )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FitMesh">Online doc</a>
End Rem
Function FitMesh( mesh:TMesh,x:Float,y:Float,z:Float,width:Float,height:Float,depth:Float,uniform:Int=False )
	mesh.FitMesh( x,y,z,width,height,depth,uniform )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FlipMesh">Online doc</a>
End Rem
Function FlipMesh( mesh:TMesh )
	mesh.FlipMesh()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeBrush">Online doc</a>
End Rem
Function FreeBrush( brush:TBrush )
	brush.FreeBrush()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeEntity">Online doc</a>
End Rem
Function FreeEntity( ent:TEntity )
	ent.FreeEntity()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeTexture">Online doc</a>
End Rem
Function FreeTexture( tex:TTexture )
	tex.FreeTexture()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetBrushTexture">Online doc</a>.
about: Unlike Blitz3D, you don't need to free the returned texture as it is not a copy.
End Rem
Function GetBrushTexture:TTexture( brush:TBrush,index:Int=0 )	
	Return brush.GetBrushTexture( index )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetChild">Online doc</a>
End Rem
Function GetChild:TEntity( ent:TEntity,child_no:Int )
	Return ent.GetChild( child_no )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityBrush">Online doc</a>
End Rem
Function GetEntityBrush:TBrush( ent:TEntity )
	Return ent.GetEntityBrush()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityType">Online doc</a>
End Rem
Function GetEntityType:Int( ent:TEntity )
	Return ent.GetEntityType()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetMatElement">Online doc</a>
End Rem
Function GetMatElement:Float( ent:TEntity,row:Int,col:Int )
	ent.GetMatElement( row,col )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetParent">Online doc</a>
End Rem
Function GetParent:TEntity( ent:TEntity )
	Return ent.GetParent() ' uses GetParentEntity_
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurface">Online doc</a>
End Rem
Function GetSurface:TSurface( mesh:TMesh,surf_no:Int )
	Return mesh.GetSurface( surf_no )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurfaceBrush">Online doc</a>
End Rem
Function GetSurfaceBrush:TBrush( surf:TSurface )
	Return surf.GetSurfaceBrush()
End Function

' Graphics3D is in B3dglgraphics.mod

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HandleSprite">Online doc</a>
End Rem
Function HandleSprite( sprite:TSprite,h_x:Float,h_y:Float )
	sprite.HandleSprite( h_x,h_y )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HideEntity">Online doc</a>
End Rem
Function HideEntity( ent:TEntity )
	ent.HideEntity()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightColor">Online doc</a>
End Rem
Function LightColor( light:TLight,red:Float,green:Float,blue:Float )
	light.LightColor( red,green,blue )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightConeAngles">Online doc</a>
End Rem
Function LightConeAngles( light:TLight,inner_ang:Float,outer_ang:Float )
	light.LightConeAngles( inner_ang,outer_ang )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightRange">Online doc</a>
End Rem
Function LightRange( light:TLight,Range:Float )
	light.LightRange( Range )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LinePick">Online doc</a>
End Rem
Function LinePick:TEntity( x:Float,y:Float,z:Float,dx:Float,dy:Float,dz:Float,radius:Float=0 )
	Return TPick.LinePick( x,y,z,dx,dy,dz,radius )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimMesh">Online doc</a>
End Rem
Function LoadAnimMesh:TMesh( file:String,parent:TEntity=Null )
	Return TMesh.LoadAnimMesh( file,parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimTexture">Online doc</a>
End Rem
Function LoadAnimTexture:TTexture( file:String,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int )
	Return TTexture.LoadAnimTexture( file,flags,frame_width,frame_height,first_frame,frame_count )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadBrush">Online doc</a>
End Rem
Function LoadBrush:TBrush( file:String,flags:Int=9,u_scale:Float=1,v_scale:Float=1 )
	Return TBrush.LoadBrush( file,flags,u_scale,v_scale )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadMesh">Online doc</a>
End Rem
Function LoadMesh:TMesh( file:String,parent:TEntity=Null )
	Return TMesh.LoadMesh( file,parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadTexture">Online doc</a>
End Rem
Function LoadTexture:TTexture( file:String,flags:Int=9 )
	Return TTexture.LoadTexture( file,flags )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadSprite">Online doc</a>
End Rem
Function LoadSprite:TSprite( tex_file:String,tex_flag:Int=1,parent:TEntity=Null )
	Return TSprite.LoadSprite( tex_file,tex_flag,parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshDepth">Online doc</a>
End Rem
Function MeshDepth:Float( mesh:TMesh )
	Return mesh.MeshDepth()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshHeight">Online doc</a>
End Rem
Function MeshHeight:Float( mesh:TMesh )
	Return mesh.MeshHeight()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshWidth">Online doc</a>
End Rem
Function MeshWidth:Float( mesh:TMesh )
	Return mesh.MeshWidth()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MoveEntity">Online doc</a>
End Rem
Function MoveEntity( ent:TEntity,x:Float,y:Float,z:Float )
	ent.MoveEntity( x,y,z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=NameEntity">Online doc</a>
End Rem
Function NameEntity( ent:TEntity,name:String )
	ent.NameEntity( name )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintEntity">Online doc</a>
End Rem
Function PaintEntity( ent:TEntity,brush:TBrush )
	ent.PaintEntity( brush )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintMesh">Online doc</a>
End Rem
Function PaintMesh( mesh:TMesh,brush:TBrush )
	mesh.PaintMesh( brush )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintSurface">Online doc</a>
End Rem
Function PaintSurface( surf:TSurface,brush:TBrush )
	surf.PaintSurface( brush )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedEntity">Online doc</a>
End Rem
Function PickedEntity:TEntity()
	Return TPick.PickedEntity()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNX">Online doc</a>
End Rem
Function PickedNX:Float()
	Return TPick.PickedNX()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNY">Online doc</a>
End Rem
Function PickedNY:Float()
	Return TPick.PickedNY()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNZ">Online doc</a>
End Rem
Function PickedNZ:Float()
	Return TPick.PickedNZ()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedSurface">Online doc</a>
End Rem
Function PickedSurface:TSurface()
	Return TPick.PickedSurface()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTime">Online doc</a>
End Rem
Function PickedTime:Float()
	Return TPick.PickedTime()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTriangle">Online doc</a>
End Rem
Function PickedTriangle:Int()
	Return TPick.PickedTriangle()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedX">Online doc</a>
End Rem
Function PickedX:Float()
	Return TPick.PickedX()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedY">Online doc</a>
End Rem
Function PickedY:Float()
	Return TPick.PickedY()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedZ">Online doc</a>
End Rem
Function PickedZ:Float()
	Return TPick.PickedZ()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PointEntity">Online doc</a>
End Rem
Function PointEntity( ent:TEntity,target_ent:TEntity,roll:Float=0 )
	ent.PointEntity( target_ent,roll )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionEntity">Online doc</a>
End Rem
Function PositionEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
	ent.PositionEntity( x,y,z,glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionMesh">Online doc</a>
End Rem
Function PositionMesh( mesh:TMesh,px:Float,py:Float,pz:Float )
	mesh.PositionMesh( px,py,pz )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionTexture">Online doc</a>
End Rem
Function PositionTexture( tex:TTexture,u_pos:Float,v_pos:Float )
	tex.PositionTexture( u_pos,v_pos )
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
	TGlobal.RenderWorld()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ResetEntity">Online doc</a>
End Rem
Function ResetEntity( ent:TEntity )
	ent.ResetEntity()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateEntity">Online doc</a>
End Rem
Function RotateEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
	ent.RotateEntity( x,y,z,glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateMesh">Online doc</a>
End Rem
Function RotateMesh( mesh:TMesh,pitch:Float,yaw:Float,roll:Float )
	mesh.RotateMesh( pitch,yaw,roll )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateSprite">Online doc</a>
End Rem
Function RotateSprite( sprite:TSprite,ang:Float )
	sprite.RotateSprite( ang )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateTexture">Online doc</a>
End Rem
Function RotateTexture( tex:TTexture,ang:Float )
	tex.RotateTexture( ang )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleEntity">Online doc</a>
End Rem
Function ScaleEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
	ent.ScaleEntity( x,y,z,glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleMesh">Online doc</a>
End Rem
Function ScaleMesh( mesh:TMesh,sx:Float,sy:Float,sz:Float )
	mesh.ScaleMesh( sx,sy,sz )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleSprite">Online doc</a>
End Rem
Function ScaleSprite( sprite:TSprite,s_x:Float,s_y:Float )
	sprite.ScaleSprite( s_x,s_y )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleTexture">Online doc</a>
End Rem
Function ScaleTexture( tex:TTexture,u_scale:Float,v_scale:Float )
	tex.ScaleTexture( u_scale,v_scale )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetAnimTime">Online doc</a>
End Rem
Function SetAnimTime( ent:TEntity,time:Float,seq:Int=0 )
	ent.SetAnimTime( time,seq )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeFace">Online doc</a>
End Rem
Function SetCubeFace( tex:TTexture,face:Int )
	SetCubeFace_( TTexture.GetInstance(tex),face )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeMode">Online doc</a>
End Rem
Function SetCubeMode( tex:TTexture,Mode:Int )
	SetCubeMode_( TTexture.GetInstance(tex),Mode )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ShowEntity">Online doc</a>
End Rem
Function ShowEntity( ent:TEntity )
	ent.ShowEntity()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SpriteViewMode">Online doc</a>
End Rem
Function SpriteViewMode( sprite:TSprite,Mode:Int )
	sprite.SpriteViewMode( Mode )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureBlend">Online doc</a>
End Rem
Function TextureBlend( tex:TTexture,blend:Int )
	tex.TextureBlend( blend )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureCoords">Online doc</a>
End Rem
Function TextureCoords( tex:TTexture,coords:Int )
	tex.TextureCoords( coords )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureHeight">Online doc</a>
End Rem
Function TextureHeight:Int( tex:TTexture )
	Return TextureHeight_( TTexture.GetInstance(tex) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureFilter">Online doc</a>
End Rem
Function TextureFilter( match_text:String,flags:Int )
	TTexture.TextureFilter( match_text,flags )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureName">Online doc</a>
End Rem
Function TextureName:String( tex:TTexture )
	Return tex.TextureName()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureWidth">Online doc</a>
End Rem
Function TextureWidth:Int( tex:TTexture )
	Return TextureWidth_( TTexture.GetInstance(tex) )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedX">Online doc</a>
End Rem
Function TFormedX:Float()
	Return TEntity.TFormedX()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedY">Online doc</a>
End Rem
Function TFormedY:Float()
	Return TEntity.TFormedY()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedZ">Online doc</a>
End Rem
Function TFormedZ:Float()
	Return TEntity.TFormedZ()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormNormal">Online doc</a>
End Rem
Function TFormNormal( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
	TEntity.TFormNormal( x,y,z,src_ent,dest_ent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormPoint">Online doc</a>
End Rem
Function TFormPoint( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
	TEntity.TFormPoint( x,y,z,src_ent,dest_ent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormVector">Online doc</a>
End Rem
Function TFormVector( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
	TEntity.TFormVector( x,y,z,src_ent,dest_ent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TranslateEntity">Online doc</a>
End Rem
Function TranslateEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
	ent.TranslateEntity( x,y,z,glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TriangleVertex">Online doc</a>
End Rem
Function TriangleVertex:Int( surf:TSurface,tri_no:Int,corner:Int )
	Return surf.TriangleVertex( tri_no,corner )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TurnEntity">Online doc</a>
End Rem
Function TurnEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
	ent.TurnEntity( x,y,z,glob )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateNormals">Online doc</a>
End Rem
Function UpdateNormals( mesh:TMesh )
	mesh.UpdateNormals()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateWorld">Online doc</a>
End Rem
Function UpdateWorld( anim_speed:Float=1 )
	TGlobal.UpdateWorld( anim_speed )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorPitch">Online doc</a>
End Rem
Function VectorPitch:Float( vx:Float,vy:Float,vz:Float )
	Return TVector.VectorPitch( vx,vy,vz )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorYaw">Online doc</a>
End Rem
Function VectorYaw:Float( vx:Float,vy:Float,vz:Float )
	Return TVector.VectorYaw( vx,vy,vz )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexAlpha">Online doc</a>
End Rem
Function VertexAlpha:Float( surf:TSurface,vid:Int )
	Return surf.VertexAlpha( vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexBlue">Online doc</a>
End Rem
Function VertexBlue:Float( surf:TSurface,vid:Int )
	Return surf.VertexBlue( vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexColor">Online doc</a>
End Rem
Function VertexColor( surf:TSurface,vid:Int,r:Float,g:Float,b:Float,a:Float=1 )
	surf.VertexColor( vid,r,g,b,a )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexCoords">Online doc</a>
End Rem
Function VertexCoords( surf:TSurface,vid:Int,x:Float,y:Float,z:Float )
	surf.VertexCoords( vid,x,y,z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexGreen">Online doc</a>
End Rem
Function VertexGreen:Float( surf:TSurface,vid:Int )
	Return surf.VertexGreen( vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNormal">Online doc</a>
End Rem
Function VertexNormal( surf:TSurface,vid:Int,nx:Float,ny:Float,nz:Float )
	surf.VertexNormal( vid,nx,ny,nz )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNX">Online doc</a>
End Rem
Function VertexNX:Float( surf:TSurface,vid:Int )
	Return surf.VertexNX( vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNY">Online doc</a>
End Rem
Function VertexNY:Float( surf:TSurface,vid:Int )
	Return surf.VertexNY( vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNZ">Online doc</a>
End Rem
Function VertexNZ:Float( surf:TSurface,vid:Int )
	Return surf.VertexNZ( vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexRed">Online doc</a>
End Rem
Function VertexRed:Float( surf:TSurface,vid:Int )
	Return surf.VertexRed( vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexTexCoords">Online doc</a>
End Rem
Function VertexTexCoords( surf:TSurface,vid:Int,u:Float,v:Float,w:Float=0,coord_set:Int=0 )
	surf.VertexTexCoords( vid,u,v,w,coord_set )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexU">Online doc</a>
End Rem
Function VertexU:Float( surf:TSurface,vid:Int,coord_set:Int=0 )
	Return surf.VertexU( vid,coord_set )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexV">Online doc</a>
End Rem
Function VertexV:Float( surf:TSurface,vid:Int,coord_set:Int=0 )
	Return surf.VertexV( vid,coord_set )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexW">Online doc</a>
End Rem
Function VertexW:Float( surf:TSurface,vid:Int,coord_set:Int=0 )
	Return surf.VertexW( vid,coord_set )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexX">Online doc</a>
End Rem
Function VertexX:Float( surf:TSurface,vid:Int )
	Return surf.VertexX( vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexY">Online doc</a>
End Rem
Function VertexY:Float( surf:TSurface,vid:Int )
	Return surf.VertexY( vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexZ">Online doc</a>
End Rem
Function VertexZ:Float( surf:TSurface,vid:Int )
	Return surf.VertexZ( vid )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Wireframe">Online doc</a>
End Rem
Function Wireframe( enable:Int )
	Wireframe_( enable )
End Function

' *** Blitz3D functions, A-Z (in Openb3d)

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddAnimSeq">Online doc</a>
End Rem
Function AddAnimSeq:Int( ent:TEntity,length:Int )
	Return ent.AddAnimSeq( length )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AlignToVector">Online doc</a>
End Rem
Function AlignToVector( entity:TEntity,x:Float,y:Float,z:Float,axis:Int,rate:Int=1 )
	entity.AlignToVector( x,y,z,axis,rate )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreatePlane">Online doc</a>
End Rem
Function CreatePlane:TMesh( divisions:Int=1,parent:TEntity=Null )
	Return TMesh.CreatePlane( divisions,parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateTerrain">Online doc</a>
End Rem
Function CreateTerrain:TTerrain( size:Int,parent:TEntity=Null )
	Return TTerrain.CreateTerrain( size,parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimSeq">Online doc</a>
End Rem
Function LoadAnimSeq:Int( ent:TEntity,file:String )
	Return ent.LoadAnimSeq( file )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadTerrain">Online doc</a>
End Rem
Function LoadTerrain:TTerrain( file:String,parent:TEntity=Null )
	Return TTerrain.LoadTerrain( file,parent )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshesIntersect">Online doc</a>
End Rem
Function MeshesIntersect:Int( mesh1:TMesh,mesh2:TMesh )
	Return mesh1.MeshesIntersect( mesh2 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ModifyTerrain">Online doc</a>
End Rem
Function ModifyTerrain( terr:TTerrain,x:Int,z:Int,new_height:Float )
	terr.ModifyTerrain( x,z,new_height )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetAnimKey">Online doc</a>
End Rem
Function SetAnimKey( ent:TEntity,frame:Float,pos_key:Int=True,rot_key:Int=True,scale_key:Int=True )
	ent.SetAnimKey( frame,pos_key,rot_key,scale_key )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainHeight">Online doc</a>
End Rem
Function TerrainHeight:Float( terr:TTerrain,x:Int,z:Int )
	Return terr.TerrainHeight( x,z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainX">Online doc</a>
End Rem
Function TerrainX:Float( terr:TTerrain,x:Float,y:Float,z:Float )
	Return terr.TerrainX( x,y,z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainY">Online doc</a>
End Rem
Function TerrainY:Float( terr:TTerrain,x:Float,y:Float,z:Float )
	Return terr.TerrainY( x,y,z )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainZ">Online doc</a>
End Rem
Function TerrainZ:Float( terr:TTerrain,x:Float,y:Float,z:Float )
	Return terr.TerrainZ( x,y,z )
End Function
