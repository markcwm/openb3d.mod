' functions.bmx

' *** Todo

'Rem
'bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BackBuffer">Online doc</a>
'End Rem
'Function BackBuffer:TBuffer()
	'Return TBuffer.BackBuffer()
'End Function

'Rem
'bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FrontBuffer">Online doc</a>
'End Rem
'Function FrontBuffer:TBuffer()
	'Return TBuffer.FrontBuffer()
'End Function

'Rem
'bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ImageBuffer">Online doc</a>
'End Rem
'Function ImageBuffer:TBuffer( image:TImage,frame%=0 )
	'Return TBuffer.ImageBuffer( image,frame )
'End Function

'Rem
'bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureBuffer">Online doc</a>
'End Rem
'Function TextureBuffer:TBuffer( tex:TTexture,frame%=0 )
	'Return TBuffer.TextureBuffer( tex,frame )
'End Function

'Rem
'bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetBuffer">Online doc</a>
'End Rem
'Function SetBuffer( buffer:TBuffer )
	'TBuffer.SetBuffer( buffer )
'End Function

'Rem
'bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyRect">Online doc</a>
'End Rem
'Function CopyRect( src_x%,src_y%,src_width%,src_height%,dest_x%=0,dest_y%=0,src_buffer%=0,dest_buffer%=0 )
	'TBuffer.CopyRect( src_x,src_y,src_width,src_height,dest_x,dest_y,src_buffer,dest_buffer )
'End Function

' *** Blitz3D functions, A-Z (in Minib3d)

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddMesh">Online doc</a>
End Rem
Function AddMesh( mesh1:TMesh,mesh2:TMesh )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddTriangle">Online doc</a>
End Rem
Function AddTriangle:Int( surf:TSurface,v0:Int,v1:Int,v2:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddVertex">Online doc</a>
End Rem
Function AddVertex:Int( surf:TSurface,x:Float,y:Float,z:Float,u:Float=0,v:Float=0,w:Float=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AmbientLight">Online doc</a>
End Rem
Function AmbientLight( r:Float,g:Float,b:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animate">Online doc</a>
End Rem
Function Animate( ent:TEntity,Mode:Int=1,speed:Float=1,seq:Int=0,trans:Int=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animating">Online doc</a>
End Rem
Function Animating:Int( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimLength">Online doc</a>
End Rem
Function AnimLength:Int( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimSeq">Online doc</a>
End Rem
Function AnimSeq:Int( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimTime">Online doc</a>
End Rem
Function AnimTime:Float( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AntiAlias">Online doc</a>
End Rem
Rem
' removed since it was too slow and used the accum buffer
Function AntiAlias( samples:Int )
End Function
EndRem

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushAlpha">Online doc</a>
End Rem
Function BrushAlpha( brush:TBrush,a:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushBlend">Online doc</a>
End Rem
Function BrushBlend( brush:TBrush,blend:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushColor">Online doc</a>
End Rem
Function BrushColor( brush:TBrush,r:Float,g:Float,b:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushFX">Online doc</a>
End Rem
Function BrushFX( brush:TBrush,fx:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushShininess">Online doc</a>
End Rem
Function BrushShininess( brush:TBrush,s:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushTexture">Online doc</a>
End Rem
Function BrushTexture( brush:TBrush,tex:TTexture,frame:Int=0,index:Int=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsColor">Online doc</a>
End Rem
Function CameraClsColor( cam:TCamera,r:Float,g:Float,b:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsMode">Online doc</a>
End Rem
Function CameraClsMode( cam:TCamera,cls_depth:Int,cls_zbuffer:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogColor">Online doc</a>
End Rem
Function CameraFogColor( cam:TCamera,r:Float,g:Float,b:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogMode">Online doc</a>
End Rem
Function CameraFogMode( cam:TCamera,Mode:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogRange">Online doc</a>
End Rem
Function CameraFogRange( cam:TCamera,nnear:Float,nfar:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraPick">Online doc</a>
End Rem
Function CameraPick:TEntity( cam:TCamera,x:Float,y:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProject">Online doc</a>
End Rem
Function CameraProject( cam:TCamera,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProjMode">Online doc</a>
End Rem
Function CameraProjMode( cam:TCamera,Mode:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraRange">Online doc</a>
End Rem
Function CameraRange( cam:TCamera,nnear:Float,nfar:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraViewport">Online doc</a>
End Rem
Function CameraViewport( cam:TCamera,x:Int,y:Int,width:Int,height:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraZoom">Online doc</a>
End Rem
Function CameraZoom( cam:TCamera,zoom:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearCollisions">Online doc</a>
End Rem
Function ClearCollisions()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearSurface">Online doc</a>
End Rem
Function ClearSurface( surf:TSurface,clear_verts:Int=True,clear_tris:Int=True )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearTextureFilters">Online doc</a>
End Rem
Function ClearTextureFilters()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearWorld">Online doc</a>
End Rem
Function ClearWorld( entities:Int=True,brushes:Int=True,textures:Int=True )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionEntity">Online doc</a>
End Rem
Function CollisionEntity:TEntity( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNX">Online doc</a>
End Rem
Function CollisionNX:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNY">Online doc</a>
End Rem
Function CollisionNY:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNZ">Online doc</a>
End Rem
Function CollisionNZ:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Collisions">Online doc</a>
End Rem
Function Collisions( src_no:Int,dest_no:Int,method_no:Int,response_no:Int=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionSurface">Online doc</a>
End Rem
Function CollisionSurface:TSurface( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTime">Online doc</a>
End Rem
Function CollisionTime:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTriangle">Online doc</a>
End Rem
Function CollisionTriangle:Int( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionX">Online doc</a>
End Rem
Function CollisionX:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionY">Online doc</a>
End Rem
Function CollisionY:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionZ">Online doc</a>
End Rem
Function CollisionZ:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyEntity">Online doc</a>
End Rem
Function CopyEntity:TEntity( ent:TEntity,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyMesh">Online doc</a>
End Rem
Function CopyMesh:TMesh( mesh:TMesh,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountChildren">Online doc</a>
End Rem
Function CountChildren:Int( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountCollisions">Online doc</a>
End Rem
Function CountCollisions:Int( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountSurfaces">Online doc</a>
End Rem
Function CountSurfaces:Int( mesh:TMesh )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountTriangles">Online doc</a>
End Rem
Function CountTriangles:Int( surf:TSurface )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountVertices">Online doc</a>
End Rem
Function CountVertices:Int( surf:TSurface )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateBrush">Online doc</a>
End Rem
Function CreateBrush:TBrush( r:Float=255,g:Float=255,b:Float=255 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCamera">Online doc</a>
End Rem
Function CreateCamera:TCamera( parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCone">Online doc</a>
End Rem
Function CreateCone:TMesh( segments:Int=8,solid:Int=True,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCylinder">Online doc</a>
End Rem
Function CreateCylinder:TMesh( segments:Int=8,solid:Int=True,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCube">Online doc</a>
End Rem
Function CreateCube:TMesh( parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateMesh">Online doc</a>
End Rem
Function CreateMesh:TMesh( parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateLight">Online doc</a>
End Rem
Function CreateLight:TLight( light_type:Int=1,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreatePivot">Online doc</a>
End Rem
Function CreatePivot:TPivot( parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSphere">Online doc</a>
End Rem
Function CreateSphere:TMesh( segments:Int=8,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSprite">Online doc</a>
End Rem
Function CreateSprite:TSprite( parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSurface">Online doc</a>
End Rem
Function CreateSurface:TSurface( mesh:TMesh,brush:TBrush=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateTexture">Online doc</a>
End Rem
Function CreateTexture:TTexture( width:Int,height:Int,flags:Int=9,frames:Int=1 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaPitch">Online doc</a>
End Rem
Function DeltaPitch:Float( ent1:TEntity,ent2:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaYaw">Online doc</a>
End Rem
Function DeltaYaw:Float( ent1:TEntity,ent2:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAlpha">Online doc</a>
End Rem
Function EntityAlpha( ent:TEntity,alpha:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAutoFade">Online doc</a>
End Rem
Rem
' removed due to having lots of checks per entity - alternative is octrees
Function EntityAutoFade( ent:TEntity,near:Float,far:Float )
End Function
EndRem

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBlend">Online doc</a>
End Rem
Function EntityBlend( ent:TEntity,blend:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBox">Online doc</a>
End Rem
Function EntityBox( ent:TEntity,x:Float,y:Float,z:Float,w:Float,h:Float,d:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityClass">Online doc</a>
End Rem
Function EntityClass:String( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityCollided">Online doc</a>
End Rem
Function EntityCollided:TEntity( ent:TEntity,type_no:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityColor">Online doc</a>
End Rem
Function EntityColor( ent:TEntity,red:Float,green:Float,blue:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityDistance">Online doc</a>
End Rem
Function EntityDistance:Float( ent1:TEntity,ent2:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityFX">Online doc</a>
End Rem
Function EntityFX( ent:TEntity,fx:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityInView">Online doc</a>
End Rem
Function EntityInView:Int( ent:TEntity,cam:TCamera )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityName">Online doc</a>
End Rem
Function EntityName:String( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityOrder">Online doc</a>
End Rem
Function EntityOrder( ent:TEntity,order:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityParent">Online doc</a>
End Rem
Function EntityParent( ent:TEntity,parent_ent:TEntity,glob:Int=True )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPick">Online doc</a>
End Rem
Function EntityPick:TEntity( ent:TEntity,Range:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPickMode">Online doc</a>
End Rem
Function EntityPickMode( ent:TEntity,pick_mode:Int,obscurer:Int=True )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPitch">Online doc</a>
End Rem
Function EntityPitch:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRadius">Online doc</a>
End Rem
Function EntityRadius( ent:TEntity,radius_x:Float,radius_y:Float=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRoll">Online doc</a>
End Rem
Function EntityRoll:Float( ent:TEntity,glob:Int=True )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityShininess">Online doc</a>
End Rem
Function EntityShininess( ent:TEntity,shine:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityTexture">Online doc</a>
End Rem
Function EntityTexture( ent:TEntity,tex:TTexture,frame:Int=0,index:Int=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityType">Online doc</a>.
about: If type_no is negative, collision checking is dynamic, if zero entity is removed.
End Rem
Function EntityType( ent:TEntity,type_no:Int,recursive:Int=False )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityVisible">Online doc</a>
End Rem
Function EntityVisible:Int( src_ent:TEntity,dest_ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityX">Online doc</a>
End Rem
Function EntityX:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityY">Online doc</a>
End Rem
Function EntityY:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityYaw">Online doc</a>
End Rem
Function EntityYaw:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityZ">Online doc</a>
End Rem
Function EntityZ:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ExtractAnimSeq">Online doc</a>
End Rem
Function ExtractAnimSeq:Int( ent:TEntity,first_frame:Int,last_frame:Int,seq:Int=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindChild">Online doc</a>
End Rem
Function FindChild:TEntity( ent:TEntity,child_name:String )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindSurface">Online doc</a>
End Rem
Function FindSurface:TSurface( mesh:TMesh,brush:TBrush )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FitMesh">Online doc</a>
End Rem
Function FitMesh( mesh:TMesh,x:Float,y:Float,z:Float,width:Float,height:Float,depth:Float,uniform:Int=False )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FlipMesh">Online doc</a>
End Rem
Function FlipMesh( mesh:TMesh )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeBrush">Online doc</a>
End Rem
Function FreeBrush( brush:TBrush )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeEntity">Online doc</a>
End Rem
Function FreeEntity( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeTexture">Online doc</a>
End Rem
Function FreeTexture( tex:TTexture )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetBrushTexture">Online doc</a>.
about: Unlike Blitz3D, you don't need to free the returned texture as it is not a copy.
End Rem
Function GetBrushTexture:TTexture( brush:TBrush,index:Int=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetChild">Online doc</a>
End Rem
Function GetChild:TEntity( ent:TEntity,child_no:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityBrush">Online doc</a>
End Rem
Function GetEntityBrush:TBrush( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityType">Online doc</a>
End Rem
Function GetEntityType:Int( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetMatElement">Online doc</a>
End Rem
Function GetMatElement:Float( ent:TEntity,row:Int,col:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetParent">Online doc</a>
End Rem
Function GetParent:TEntity( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurface">Online doc</a>
End Rem
Function GetSurface:TSurface( mesh:TMesh,surf_no:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurfaceBrush">Online doc</a>
End Rem
Function GetSurfaceBrush:TBrush( surf:TSurface )
End Function

' Graphics3D is in B3dglgraphics.mod

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HandleSprite">Online doc</a>
End Rem
Function HandleSprite( sprite:TSprite,h_x:Float,h_y:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HideEntity">Online doc</a>
End Rem
Function HideEntity( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightColor">Online doc</a>
End Rem
Function LightColor( light:TLight,red:Float,green:Float,blue:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightConeAngles">Online doc</a>
End Rem
Function LightConeAngles( light:TLight,inner_ang:Float,outer_ang:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightRange">Online doc</a>
End Rem
Function LightRange( light:TLight,Range:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LinePick">Online doc</a>
End Rem
Function LinePick:TEntity( x:Float,y:Float,z:Float,dx:Float,dy:Float,dz:Float,radius:Float=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimMesh">Online doc</a>
End Rem
Function LoadAnimMesh:TMesh( file:String,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimTexture">Online doc</a>
End Rem
Function LoadAnimTexture:TTexture( file:String,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadBrush">Online doc</a>
End Rem
Function LoadBrush:TBrush( file:String,flags:Int=9,u_scale:Float=1,v_scale:Float=1 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadMesh">Online doc</a>
End Rem
Function LoadMesh:TMesh( file:String,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadTexture">Online doc</a>
End Rem
Function LoadTexture:TTexture( file:String,flags:Int=9 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadSprite">Online doc</a>
End Rem
Function LoadSprite:TSprite( tex_file:String,tex_flag:Int=1,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshDepth">Online doc</a>
End Rem
Function MeshDepth:Float( mesh:TMesh )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshHeight">Online doc</a>
End Rem
Function MeshHeight:Float( mesh:TMesh )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshWidth">Online doc</a>
End Rem
Function MeshWidth:Float( mesh:TMesh )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MoveEntity">Online doc</a>
End Rem
Function MoveEntity( ent:TEntity,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=NameEntity">Online doc</a>
End Rem
Function NameEntity( ent:TEntity,name:String )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintEntity">Online doc</a>
End Rem
Function PaintEntity( ent:TEntity,brush:TBrush )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintMesh">Online doc</a>
End Rem
Function PaintMesh( mesh:TMesh,brush:TBrush )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintSurface">Online doc</a>
End Rem
Function PaintSurface( surf:TSurface,brush:TBrush )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedEntity">Online doc</a>
End Rem
Function PickedEntity:TEntity()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNX">Online doc</a>
End Rem
Function PickedNX:Float()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNY">Online doc</a>
End Rem
Function PickedNY:Float()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNZ">Online doc</a>
End Rem
Function PickedNZ:Float()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedSurface">Online doc</a>
End Rem
Function PickedSurface:TSurface()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTime">Online doc</a>
End Rem
Function PickedTime:Float()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTriangle">Online doc</a>
End Rem
Function PickedTriangle:Int()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedX">Online doc</a>
End Rem
Function PickedX:Float()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedY">Online doc</a>
End Rem
Function PickedY:Float()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedZ">Online doc</a>
End Rem
Function PickedZ:Float()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PointEntity">Online doc</a>
End Rem
Function PointEntity( ent:TEntity,target_ent:TEntity,roll:Float=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionEntity">Online doc</a>
End Rem
Function PositionEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionMesh">Online doc</a>
End Rem
Function PositionMesh( mesh:TMesh,px:Float,py:Float,pz:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionTexture">Online doc</a>
End Rem
Function PositionTexture( tex:TTexture,u_pos:Float,v_pos:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedX">Online doc</a>
End Rem
Function ProjectedX:Float()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedY">Online doc</a>
End Rem
Function ProjectedY:Float()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedZ">Online doc</a>
End Rem
Function ProjectedZ:Float()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RenderWorld">Online doc</a>
End Rem
Function RenderWorld()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ResetEntity">Online doc</a>
End Rem
Function ResetEntity( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateEntity">Online doc</a>
End Rem
Function RotateEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateMesh">Online doc</a>
End Rem
Function RotateMesh( mesh:TMesh,pitch:Float,yaw:Float,roll:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateSprite">Online doc</a>
End Rem
Function RotateSprite( sprite:TSprite,ang:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateTexture">Online doc</a>
End Rem
Function RotateTexture( tex:TTexture,ang:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleEntity">Online doc</a>
End Rem
Function ScaleEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleMesh">Online doc</a>
End Rem
Function ScaleMesh( mesh:TMesh,sx:Float,sy:Float,sz:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleSprite">Online doc</a>
End Rem
Function ScaleSprite( sprite:TSprite,s_x:Float,s_y:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleTexture">Online doc</a>
End Rem
Function ScaleTexture( tex:TTexture,u_scale:Float,v_scale:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetAnimTime">Online doc</a>
End Rem
Function SetAnimTime( ent:TEntity,time:Float,seq:Int=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeFace">Online doc</a>
End Rem
Function SetCubeFace( tex:TTexture,face:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeMode">Online doc</a>
End Rem
Function SetCubeMode( tex:TTexture,Mode:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ShowEntity">Online doc</a>
End Rem
Function ShowEntity( ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SpriteViewMode">Online doc</a>
End Rem
Function SpriteViewMode( sprite:TSprite,Mode:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureBlend">Online doc</a>
End Rem
Function TextureBlend( tex:TTexture,blend:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureCoords">Online doc</a>
End Rem
Function TextureCoords( tex:TTexture,coords:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureHeight">Online doc</a>
End Rem
Function TextureHeight:Int( tex:TTexture )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureFilter">Online doc</a>
End Rem
Function TextureFilter( match_text:String,flags:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureName">Online doc</a>
End Rem
Function TextureName:String( tex:TTexture )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureWidth">Online doc</a>
End Rem
Function TextureWidth:Int( tex:TTexture )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedX">Online doc</a>
End Rem
Function TFormedX:Float()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedY">Online doc</a>
End Rem
Function TFormedY:Float()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedZ">Online doc</a>
End Rem
Function TFormedZ:Float()
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormNormal">Online doc</a>
End Rem
Function TFormNormal( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormPoint">Online doc</a>
End Rem
Function TFormPoint( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormVector">Online doc</a>
End Rem
Function TFormVector( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TranslateEntity">Online doc</a>
End Rem
Function TranslateEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TriangleVertex">Online doc</a>
End Rem
Function TriangleVertex:Int( surf:TSurface,tri_no:Int,corner:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TurnEntity">Online doc</a>
End Rem
Function TurnEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateNormals">Online doc</a>
End Rem
Function UpdateNormals( mesh:TMesh )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateWorld">Online doc</a>
End Rem
Function UpdateWorld( anim_speed:Float=1 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorPitch">Online doc</a>
End Rem
Function VectorPitch:Float( vx:Float,vy:Float,vz:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorYaw">Online doc</a>
End Rem
Function VectorYaw:Float( vx:Float,vy:Float,vz:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexAlpha">Online doc</a>
End Rem
Function VertexAlpha:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexBlue">Online doc</a>
End Rem
Function VertexBlue:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexColor">Online doc</a>
End Rem
Function VertexColor( surf:TSurface,vid:Int,r:Float,g:Float,b:Float,a:Float=1 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexCoords">Online doc</a>
End Rem
Function VertexCoords( surf:TSurface,vid:Int,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexGreen">Online doc</a>
End Rem
Function VertexGreen:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNormal">Online doc</a>
End Rem
Function VertexNormal( surf:TSurface,vid:Int,nx:Float,ny:Float,nz:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNX">Online doc</a>
End Rem
Function VertexNX:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNY">Online doc</a>
End Rem
Function VertexNY:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNZ">Online doc</a>
End Rem
Function VertexNZ:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexRed">Online doc</a>
End Rem
Function VertexRed:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexTexCoords">Online doc</a>
End Rem
Function VertexTexCoords( surf:TSurface,vid:Int,u:Float,v:Float,w:Float=0,coord_set:Int=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexU">Online doc</a>
End Rem
Function VertexU:Float( surf:TSurface,vid:Int,coord_set:Int=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexV">Online doc</a>
End Rem
Function VertexV:Float( surf:TSurface,vid:Int,coord_set:Int=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexW">Online doc</a>
End Rem
Function VertexW:Float( surf:TSurface,vid:Int,coord_set:Int=0 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexX">Online doc</a>
End Rem
Function VertexX:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexY">Online doc</a>
End Rem
Function VertexY:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexZ">Online doc</a>
End Rem
Function VertexZ:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Wireframe">Online doc</a>
End Rem
Function Wireframe( enable:Int )
End Function

' *** Blitz3D functions, A-Z (in Openb3d)

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddAnimSeq">Online doc</a>
End Rem
Function AddAnimSeq:Int( ent:TEntity,length:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AlignToVector">Online doc</a>
End Rem
Function AlignToVector( entity:TEntity,x:Float,y:Float,z:Float,axis:Int,rate:Int=1 )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreatePlane">Online doc</a>
End Rem
Function CreatePlane:TMesh( divisions:Int=1,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateTerrain">Online doc</a>
End Rem
Function CreateTerrain:TTerrain( size:Int,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimSeq">Online doc</a>
End Rem
Function LoadAnimSeq:Int( ent:TEntity,file:String )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadTerrain">Online doc</a>
End Rem
Function LoadTerrain:TTerrain( file:String,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshesIntersect">Online doc</a>
End Rem
Function MeshesIntersect:Int( mesh1:TMesh,mesh2:TMesh )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ModifyTerrain">Online doc</a>
End Rem
Function ModifyTerrain( terr:TTerrain,x:Int,z:Int,new_height:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetAnimKey">Online doc</a>
End Rem
Function SetAnimKey( ent:TEntity,frame:Float,pos_key:Int=True,rot_key:Int=True,scale_key:Int=True )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainHeight">Online doc</a>
End Rem
Function TerrainHeight:Float( terr:TTerrain,x:Int,z:Int )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainX">Online doc</a>
End Rem
Function TerrainX:Float( terr:TTerrain,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainY">Online doc</a>
End Rem
Function TerrainY:Float( terr:TTerrain,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainZ">Online doc</a>
End Rem
Function TerrainZ:Float( terr:TTerrain,x:Float,y:Float,z:Float )
End Function
