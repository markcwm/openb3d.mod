' functions.bmx

' *** Todo

'Rem
'bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/BackBuffer.htm">Online doc</a>
'End Rem
'Function BackBuffer:TBuffer()
	'Return TBuffer.BackBuffer()
'End Function

'Rem
'bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/FrontBuffer.htm">Online doc</a>
'End Rem
'Function FrontBuffer:TBuffer()
	'Return TBuffer.FrontBuffer()
'End Function

'Rem
'bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ImageBuffer.htm">Online doc</a>
'End Rem
'Function ImageBuffer:TBuffer( image:TImage,frame%=0 )
	'Return TBuffer.ImageBuffer( image,frame )
'End Function

'Rem
'bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TextureBuffer.htm">Online doc</a>
'End Rem
'Function TextureBuffer:TBuffer( tex:TTexture,frame%=0 )
	'Return TBuffer.TextureBuffer( tex,frame )
'End Function

'Rem
'bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/SetBuffer.htm">Online doc</a>
'End Rem
'Function SetBuffer( buffer:TBuffer )
	'TBuffer.SetBuffer( buffer )
'End Function

'Rem
'bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CopyRect.htm">Online doc</a>
'End Rem
'Function CopyRect( src_x%,src_y%,src_width%,src_height%,dest_x%=0,dest_y%=0,src_buffer%=0,dest_buffer%=0 )
	'TBuffer.CopyRect( src_x,src_y,src_width,src_height,dest_x,dest_y,src_buffer,dest_buffer )
'End Function

' *** Blitz3D functions, A-Z (in Minib3d)

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/AddMesh.htm">Online doc</a>
End Rem
Function AddMesh( mesh1:TMesh,mesh2:TMesh )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/AddTriangle.htm">Online doc</a>
End Rem
Function AddTriangle:Int( surf:TSurface,v0:Int,v1:Int,v2:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/AddVertex.htm">Online doc</a>
End Rem
Function AddVertex:Int( surf:TSurface,x:Float,y:Float,z:Float,u:Float=0,v:Float=0,w:Float=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/AmbientLight.htm">Online doc</a>
End Rem
Function AmbientLight( r:Float,g:Float,b:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/Animate.htm">Online doc</a>
End Rem
Function Animate( ent:TEntity,Mode:Int=1,speed:Float=1,seq:Int=0,trans:Int=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/Animating.htm">Online doc</a>
End Rem
Function Animating:Int( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/AnimLength.htm">Online doc</a>
End Rem
Function AnimLength:Int( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/AnimSeq.htm">Online doc</a>
End Rem
Function AnimSeq:Int( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/AnimTime.htm">Online doc</a>
End Rem
Function AnimTime:Float( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/AntiAlias.htm">Online doc</a>
End Rem
Rem
' removed since it was too slow and used the accum buffer
Function AntiAlias( samples:Int )
End Function
EndRem

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/BrushAlpha.htm">Online doc</a>
End Rem
Function BrushAlpha( brush:TBrush,a:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/BrushBlend.htm">Online doc</a>
End Rem
Function BrushBlend( brush:TBrush,blend:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/BrushColor.htm">Online doc</a>
End Rem
Function BrushColor( brush:TBrush,r:Float,g:Float,b:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/BrushFX.htm">Online doc</a>
End Rem
Function BrushFX( brush:TBrush,fx:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/BrushShininess.htm">Online doc</a>
End Rem
Function BrushShininess( brush:TBrush,s:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/BrushTexture.htm">Online doc</a>
End Rem
Function BrushTexture( brush:TBrush,tex:TTexture,frame:Int=0,index:Int=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CameraClsColor.htm">Online doc</a>
End Rem
Function CameraClsColor( cam:TCamera,r:Float,g:Float,b:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CameraClsMode.htm">Online doc</a>
End Rem
Function CameraClsMode( cam:TCamera,cls_depth:Int,cls_zbuffer:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CameraFogColor.htm">Online doc</a>
End Rem
Function CameraFogColor( cam:TCamera,r:Float,g:Float,b:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CameraFogMode.htm">Online doc</a>
End Rem
Function CameraFogMode( cam:TCamera,Mode:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CameraFogRange.htm">Online doc</a>
End Rem
Function CameraFogRange( cam:TCamera,nnear:Float,nfar:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CameraPick.htm">Online doc</a>
End Rem
Function CameraPick:TEntity( cam:TCamera,x:Float,y:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CameraProject.htm">Online doc</a>
End Rem
Function CameraProject( cam:TCamera,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CameraProjMode.htm">Online doc</a>
End Rem
Function CameraProjMode( cam:TCamera,Mode:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CameraRange.htm">Online doc</a>
End Rem
Function CameraRange( cam:TCamera,nnear:Float,nfar:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CameraViewport.htm">Online doc</a>
End Rem
Function CameraViewport( cam:TCamera,x:Int,y:Int,width:Int,height:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CameraZoom.htm">Online doc</a>
End Rem
Function CameraZoom( cam:TCamera,zoom:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ClearCollisions.htm">Online doc</a>
End Rem
Function ClearCollisions()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ClearSurface.htm">Online doc</a>
End Rem
Function ClearSurface( surf:TSurface,clear_verts:Int=True,clear_tris:Int=True )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ClearTextureFilters.htm">Online doc</a>
End Rem
Function ClearTextureFilters()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ClearWorld.htm">Online doc</a>
End Rem
Function ClearWorld( entities:Int=True,brushes:Int=True,textures:Int=True )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CollisionEntity.htm">Online doc</a>
End Rem
Function CollisionEntity:TEntity( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CollisionNX.htm">Online doc</a>
End Rem
Function CollisionNX:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CollisionNY.htm">Online doc</a>
End Rem
Function CollisionNY:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CollisionNZ.htm">Online doc</a>
End Rem
Function CollisionNZ:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/Collisions.htm">Online doc</a>
End Rem
Function Collisions( src_no:Int,dest_no:Int,method_no:Int,response_no:Int=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CollisionSurface.htm">Online doc</a>
End Rem
Function CollisionSurface:TSurface( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CollisionTime.htm">Online doc</a>
End Rem
Function CollisionTime:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CollisionTriangle.htm">Online doc</a>
End Rem
Function CollisionTriangle:Int( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CollisionX.htm">Online doc</a>
End Rem
Function CollisionX:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CollisionY.htm">Online doc</a>
End Rem
Function CollisionY:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CollisionZ.htm">Online doc</a>
End Rem
Function CollisionZ:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CopyEntity.htm">Online doc</a>
End Rem
Function CopyEntity:TEntity( ent:TEntity,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CopyMesh.htm">Online doc</a>
End Rem
Function CopyMesh:TMesh( mesh:TMesh,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CountChildren.htm">Online doc</a>
End Rem
Function CountChildren:Int( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CountCollisions.htm">Online doc</a>
End Rem
Function CountCollisions:Int( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CountSurfaces.htm">Online doc</a>
End Rem
Function CountSurfaces:Int( mesh:TMesh )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CountTriangles.htm">Online doc</a>
End Rem
Function CountTriangles:Int( surf:TSurface )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CountVertices.htm">Online doc</a>
End Rem
Function CountVertices:Int( surf:TSurface )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreateBrush.htm">Online doc</a>
End Rem
Function CreateBrush:TBrush( r:Float=255,g:Float=255,b:Float=255 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreateCamera.htm">Online doc</a>
End Rem
Function CreateCamera:TCamera( parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreateCone.htm">Online doc</a>
End Rem
Function CreateCone:TMesh( segments:Int=8,solid:Int=True,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreateCylinder.htm">Online doc</a>
End Rem
Function CreateCylinder:TMesh( segments:Int=8,solid:Int=True,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreateCube.htm">Online doc</a>
End Rem
Function CreateCube:TMesh( parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreateMesh.htm">Online doc</a>
End Rem
Function CreateMesh:TMesh( parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreateLight.htm">Online doc</a>
End Rem
Function CreateLight:TLight( light_type:Int=1,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreatePivot.htm">Online doc</a>
End Rem
Function CreatePivot:TPivot( parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreateSphere.htm">Online doc</a>
End Rem
Function CreateSphere:TMesh( segments:Int=8,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreateSprite.htm">Online doc</a>
End Rem
Function CreateSprite:TSprite( parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreateSurface.htm">Online doc</a>
End Rem
Function CreateSurface:TSurface( mesh:TMesh,brush:TBrush=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreateTexture.htm">Online doc</a>
End Rem
Function CreateTexture:TTexture( width:Int,height:Int,flags:Int=9,frames:Int=1 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/DeltaPitch.htm">Online doc</a>
End Rem
Function DeltaPitch:Float( ent1:TEntity,ent2:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/DeltaYaw.htm">Online doc</a>
End Rem
Function DeltaYaw:Float( ent1:TEntity,ent2:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityAlpha.htm">Online doc</a>
End Rem
Function EntityAlpha( ent:TEntity,alpha:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityAutoFade.htm">Online doc</a>
End Rem
Rem
' removed due to having lots of checks per entity - alternative is octrees
Function EntityAutoFade( ent:TEntity,near:Float,far:Float )
End Function
EndRem

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityBlend.htm">Online doc</a>
End Rem
Function EntityBlend( ent:TEntity,blend:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityBox.htm">Online doc</a>
End Rem
Function EntityBox( ent:TEntity,x:Float,y:Float,z:Float,w:Float,h:Float,d:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityClass.htm">Online doc</a>
End Rem
Function EntityClass:String( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityCollided.htm">Online doc</a>
End Rem
Function EntityCollided:TEntity( ent:TEntity,type_no:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityColor.htm">Online doc</a>
End Rem
Function EntityColor( ent:TEntity,red:Float,green:Float,blue:Float,alpha:Float,recursive:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityDistance.htm">Online doc</a>
End Rem
Function EntityDistance:Float( ent1:TEntity,ent2:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityFX.htm">Online doc</a>
End Rem
Function EntityFX( ent:TEntity,fx:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityInView.htm">Online doc</a>
End Rem
Function EntityInView:Int( ent:TEntity,cam:TCamera )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityName.htm">Online doc</a>
End Rem
Function EntityName:String( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityOrder.htm">Online doc</a>
End Rem
Function EntityOrder( ent:TEntity,order:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityParent.htm">Online doc</a>
End Rem
Function EntityParent( ent:TEntity,parent_ent:TEntity,glob:Int=True )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityPick.htm">Online doc</a>
End Rem
Function EntityPick:TEntity( ent:TEntity,Range:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityPickMode.htm">Online doc</a>
End Rem
Function EntityPickMode( ent:TEntity,pick_mode:Int,obscurer:Int=True )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityPitch.htm">Online doc</a>
End Rem
Function EntityPitch:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityRadius.htm">Online doc</a>
End Rem
Function EntityRadius( ent:TEntity,radius_x:Float,radius_y:Float=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityRoll.htm">Online doc</a>
End Rem
Function EntityRoll:Float( ent:TEntity,glob:Int=True )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityShininess.htm">Online doc</a>
End Rem
Function EntityShininess( ent:TEntity,shine:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityTexture.htm">Online doc</a>
End Rem
Function EntityTexture( ent:TEntity,tex:TTexture,frame:Int=0,index:Int=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityType.htm">Online doc</a>.
about: If type_no is negative, collision checking is dynamic, if zero entity is removed.
End Rem
Function EntityType( ent:TEntity,type_no:Int,recursive:Int=False )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityVisible.htm">Online doc</a>
End Rem
Function EntityVisible:Int( src_ent:TEntity,dest_ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityX.htm">Online doc</a>
End Rem
Function EntityX:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityY.htm">Online doc</a>
End Rem
Function EntityY:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityYaw.htm">Online doc</a>
End Rem
Function EntityYaw:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/EntityZ.htm">Online doc</a>
End Rem
Function EntityZ:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ExtractAnimSeq.htm">Online doc</a>
End Rem
Function ExtractAnimSeq:Int( ent:TEntity,first_frame:Int,last_frame:Int,seq:Int=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/FindChild.htm">Online doc</a>
End Rem
Function FindChild:TEntity( ent:TEntity,child_name:String )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/FindSurface.htm">Online doc</a>
End Rem
Function FindSurface:TSurface( mesh:TMesh,brush:TBrush )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/FitMesh.htm">Online doc</a>
End Rem
Function FitMesh( mesh:TMesh,x:Float,y:Float,z:Float,width:Float,height:Float,depth:Float,uniform:Int=False )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/FlipMesh.htm">Online doc</a>
End Rem
Function FlipMesh( mesh:TMesh )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/FreeBrush.htm">Online doc</a>
End Rem
Function FreeBrush( brush:TBrush )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/FreeEntity.htm">Online doc</a>
End Rem
Function FreeEntity( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/FreeTexture.htm">Online doc</a>
End Rem
Function FreeTexture( tex:TTexture )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/GetBrushTexture.htm">Online doc</a>.
about: Unlike Blitz3D, you don't need to free the returned texture as it is not a copy.
End Rem
Function GetBrushTexture:TTexture( brush:TBrush,index:Int=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/GetChild.htm">Online doc</a>
End Rem
Function GetChild:TEntity( ent:TEntity,child_no:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/GetEntityBrush.htm">Online doc</a>
End Rem
Function GetEntityBrush:TBrush( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/GetEntityType.htm">Online doc</a>
End Rem
Function GetEntityType:Int( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/GetMatElement.htm">Online doc</a>
End Rem
Function GetMatElement:Float( ent:TEntity,row:Int,col:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/GetParent.htm">Online doc</a>
End Rem
Function GetParent:TEntity( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/GetSurface.htm">Online doc</a>
End Rem
Function GetSurface:TSurface( mesh:TMesh,surf_no:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/GetSurfaceBrush.htm">Online doc</a>
End Rem
Function GetSurfaceBrush:TBrush( surf:TSurface )
End Function

' Graphics3D is in B3dglgraphics.mod

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/HandleSprite.htm">Online doc</a>
End Rem
Function HandleSprite( sprite:TSprite,h_x:Float,h_y:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/HideEntity.htm">Online doc</a>
End Rem
Function HideEntity( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/LightColor.htm">Online doc</a>
End Rem
Function LightColor( light:TLight,red:Float,green:Float,blue:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/LightConeAngles.htm">Online doc</a>
End Rem
Function LightConeAngles( light:TLight,inner_ang:Float,outer_ang:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/LightRange.htm">Online doc</a>
End Rem
Function LightRange( light:TLight,Range:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/LinePick.htm">Online doc</a>
End Rem
Function LinePick:TEntity( x:Float,y:Float,z:Float,dx:Float,dy:Float,dz:Float,radius:Float=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/LoadAnimMesh.htm">Online doc</a>
End Rem
Function LoadAnimMesh:TMesh( file:String,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/LoadAnimTexture.htm">Online doc</a>
End Rem
Function LoadAnimTexture:TTexture( file:String,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int,tex:TTexture=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/LoadBrush.htm">Online doc</a>
End Rem
Function LoadBrush:TBrush( file:String,flags:Int=9,u_scale:Float=1,v_scale:Float=1 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/LoadMesh.htm">Online doc</a>
End Rem
Function LoadMesh:TMesh( file:String,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/LoadTexture.htm">Online doc</a>
End Rem
Function LoadTexture:TTexture( file:String,flags:Int=9,tex:TTexture=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/LoadSprite.htm">Online doc</a>
End Rem
Function LoadSprite:TSprite( tex_file:String,tex_flag:Int=1,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/MeshDepth.htm">Online doc</a>
End Rem
Function MeshDepth:Float( mesh:TMesh )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/MeshHeight.htm">Online doc</a>
End Rem
Function MeshHeight:Float( mesh:TMesh )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/MeshWidth.htm">Online doc</a>
End Rem
Function MeshWidth:Float( mesh:TMesh )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/MoveEntity.htm">Online doc</a>
End Rem
Function MoveEntity( ent:TEntity,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/NameEntity.htm">Online doc</a>
End Rem
Function NameEntity( ent:TEntity,name:String )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PaintEntity.htm">Online doc</a>
End Rem
Function PaintEntity( ent:TEntity,brush:TBrush )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PaintMesh.htm">Online doc</a>
End Rem
Function PaintMesh( mesh:TMesh,brush:TBrush )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PaintSurface.htm">Online doc</a>
End Rem
Function PaintSurface( surf:TSurface,brush:TBrush )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PickedEntity.htm">Online doc</a>
End Rem
Function PickedEntity:TEntity()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PickedNX.htm">Online doc</a>
End Rem
Function PickedNX:Float()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PickedNY.htm">Online doc</a>
End Rem
Function PickedNY:Float()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PickedNZ.htm">Online doc</a>
End Rem
Function PickedNZ:Float()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PickedSurface.htm">Online doc</a>
End Rem
Function PickedSurface:TSurface()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PickedTime.htm">Online doc</a>
End Rem
Function PickedTime:Float()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PickedTriangle.htm">Online doc</a>
End Rem
Function PickedTriangle:Int()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PickedX.htm">Online doc</a>
End Rem
Function PickedX:Float()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PickedY.htm">Online doc</a>
End Rem
Function PickedY:Float()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PickedZ.htm">Online doc</a>
End Rem
Function PickedZ:Float()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PointEntity.htm">Online doc</a>
End Rem
Function PointEntity( ent:TEntity,target_ent:TEntity,roll:Float=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PositionEntity.htm">Online doc</a>
End Rem
Function PositionEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PositionMesh.htm">Online doc</a>
End Rem
Function PositionMesh( mesh:TMesh,px:Float,py:Float,pz:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/PositionTexture.htm">Online doc</a>
End Rem
Function PositionTexture( tex:TTexture,u_pos:Float,v_pos:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ProjectedX.htm">Online doc</a>
End Rem
Function ProjectedX:Float()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ProjectedY.htm">Online doc</a>
End Rem
Function ProjectedY:Float()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ProjectedZ.htm">Online doc</a>
End Rem
Function ProjectedZ:Float()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/RenderWorld.htm">Online doc</a>
End Rem
Function RenderWorld()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ResetEntity.htm">Online doc</a>
End Rem
Function ResetEntity( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/RotateEntity.htm">Online doc</a>
End Rem
Function RotateEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/RotateMesh.htm">Online doc</a>
End Rem
Function RotateMesh( mesh:TMesh,pitch:Float,yaw:Float,roll:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/RotateSprite.htm">Online doc</a>
End Rem
Function RotateSprite( sprite:TSprite,ang:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/RotateTexture.htm">Online doc</a>
End Rem
Function RotateTexture( tex:TTexture,ang:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ScaleEntity.htm">Online doc</a>
End Rem
Function ScaleEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ScaleMesh.htm">Online doc</a>
End Rem
Function ScaleMesh( mesh:TMesh,sx:Float,sy:Float,sz:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ScaleSprite.htm">Online doc</a>
End Rem
Function ScaleSprite( sprite:TSprite,s_x:Float,s_y:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ScaleTexture.htm">Online doc</a>
End Rem
Function ScaleTexture( tex:TTexture,u_scale:Float,v_scale:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/SetAnimTime.htm">Online doc</a>
End Rem
Function SetAnimTime( ent:TEntity,time:Float,seq:Int=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/SetCubeFace.htm">Online doc</a>
End Rem
Function SetCubeFace( tex:TTexture,face:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/SetCubeMode.htm">Online doc</a>
End Rem
Function SetCubeMode( tex:TTexture,Mode:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ShowEntity.htm">Online doc</a>
End Rem
Function ShowEntity( ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/SpriteViewMode.htm">Online doc</a>
End Rem
Function SpriteViewMode( sprite:TSprite,Mode:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TextureBlend.htm">Online doc</a>
End Rem
Function TextureBlend( tex:TTexture,blend:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TextureCoords.htm">Online doc</a>
End Rem
Function TextureCoords( tex:TTexture,coords:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TextureHeight.htm">Online doc</a>
End Rem
Function TextureHeight:Int( tex:TTexture )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TextureFilter.htm">Online doc</a>
End Rem
Function TextureFilter( match_text:String,flags:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TextureName.htm">Online doc</a>
End Rem
Function TextureName:String( tex:TTexture )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TextureWidth.htm">Online doc</a>
End Rem
Function TextureWidth:Int( tex:TTexture )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TFormedX.htm">Online doc</a>
End Rem
Function TFormedX:Float()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TFormedY.htm">Online doc</a>
End Rem
Function TFormedY:Float()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TFormedZ.htm">Online doc</a>
End Rem
Function TFormedZ:Float()
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TFormNormal.htm">Online doc</a>
End Rem
Function TFormNormal( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TFormPoint.htm">Online doc</a>
End Rem
Function TFormPoint( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TFormVector.htm">Online doc</a>
End Rem
Function TFormVector( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TranslateEntity.htm">Online doc</a>
End Rem
Function TranslateEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TriangleVertex.htm">Online doc</a>
End Rem
Function TriangleVertex:Int( surf:TSurface,tri_no:Int,corner:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TurnEntity.htm">Online doc</a>
End Rem
Function TurnEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/UpdateNormals.htm">Online doc</a>
End Rem
Function UpdateNormals( mesh:TMesh )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/UpdateWorld.htm">Online doc</a>
End Rem
Function UpdateWorld( anim_speed:Float=1 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VectorPitch.htm">Online doc</a>
End Rem
Function VectorPitch:Float( vx:Float,vy:Float,vz:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VectorYaw.htm">Online doc</a>
End Rem
Function VectorYaw:Float( vx:Float,vy:Float,vz:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexAlpha.htm">Online doc</a>
End Rem
Function VertexAlpha:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexBlue.htm">Online doc</a>
End Rem
Function VertexBlue:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexColor.htm">Online doc</a>
End Rem
Function VertexColor( surf:TSurface,vid:Int,r:Float,g:Float,b:Float,a:Float=1 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexCoords.htm">Online doc</a>
End Rem
Function VertexCoords( surf:TSurface,vid:Int,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexGreen.htm">Online doc</a>
End Rem
Function VertexGreen:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexNormal.htm">Online doc</a>
End Rem
Function VertexNormal( surf:TSurface,vid:Int,nx:Float,ny:Float,nz:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexNX.htm">Online doc</a>
End Rem
Function VertexNX:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexNY.htm">Online doc</a>
End Rem
Function VertexNY:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexNZ.htm">Online doc</a>
End Rem
Function VertexNZ:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexRed.htm">Online doc</a>
End Rem
Function VertexRed:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexTexCoords.htm">Online doc</a>
End Rem
Function VertexTexCoords( surf:TSurface,vid:Int,u:Float,v:Float,w:Float=0,coord_set:Int=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexU.htm">Online doc</a>
End Rem
Function VertexU:Float( surf:TSurface,vid:Int,coord_set:Int=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexV.htm">Online doc</a>
End Rem
Function VertexV:Float( surf:TSurface,vid:Int,coord_set:Int=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexW.htm">Online doc</a>
End Rem
Function VertexW:Float( surf:TSurface,vid:Int,coord_set:Int=0 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexX.htm">Online doc</a>
End Rem
Function VertexX:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexY.htm">Online doc</a>
End Rem
Function VertexY:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/VertexZ.htm">Online doc</a>
End Rem
Function VertexZ:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/Wireframe.htm">Online doc</a>
End Rem
Function Wireframe( enable:Int )
End Function

' *** Blitz3D functions, A-Z (in Openb3d)

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/AddAnimSeq.htm">Online doc</a>
End Rem
Function AddAnimSeq:Int( ent:TEntity,length:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/AlignToVector.htm">Online doc</a>
End Rem
Function AlignToVector( entity:TEntity,x:Float,y:Float,z:Float,axis:Int,rate:Int=1 )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreatePlane.htm">Online doc</a>
End Rem
Function CreatePlane:TMesh( divisions:Int=1,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/CreateTerrain.htm">Online doc</a>
End Rem
Function CreateTerrain:TTerrain( size:Int,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/LoadAnimSeq.htm">Online doc</a>
End Rem
Function LoadAnimSeq:Int( ent:TEntity,file:String )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/LoadTerrain.htm">Online doc</a>
End Rem
Function LoadTerrain:TTerrain( file:String,parent:TEntity=Null )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/MeshesIntersect.htm">Online doc</a>
End Rem
Function MeshesIntersect:Int( mesh1:TMesh,mesh2:TMesh )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/ModifyTerrain.htm">Online doc</a>
End Rem
Function ModifyTerrain( terr:TTerrain,x:Int,z:Int,new_height:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/SetAnimKey.htm">Online doc</a>
End Rem
Function SetAnimKey( ent:TEntity,frame:Float,pos_key:Int=True,rot_key:Int=True,scale_key:Int=True )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TerrainHeight.htm">Online doc</a>
End Rem
Function TerrainHeight:Float( terr:TTerrain,x:Int,z:Int )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TerrainX.htm">Online doc</a>
End Rem
Function TerrainX:Float( terr:TTerrain,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TerrainY.htm">Online doc</a>
End Rem
Function TerrainY:Float( terr:TTerrain,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: <a href="https://kippykip.com/b3ddocs/commands/3d_commands/TerrainZ.htm">Online doc</a>
End Rem
Function TerrainZ:Float( terr:TTerrain,x:Float,y:Float,z:Float )
End Function
