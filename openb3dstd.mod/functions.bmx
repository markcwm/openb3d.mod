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
bbdoc: Adds the source mesh to the destination mesh
about: 
@Parameters: 

source_mesh - source mesh handle

dest_mesh - destination mesh handle

@Description: 

Adds the source mesh to the destination mesh.

AddMesh works best with  meshes that have previously only had mesh commands used with them. 

So if you want to manipulate a mesh before adding it to another mesh, make  sure you use ScaleMesh, PositionMesh, PaintMesh etc rather than ScaleEntity,  PositionEntity, EntityTexture etc before using AddMesh. 

However, something to be aware of when using commands such as RotateMesh  is that all mesh commands work from a global origin of 0,0,0. Therefore it is  generally a good idea to scale and rotate a mesh before positioning it, otherwise  your mesh could end up in unexpected positions. Also, when using AddMesh, the  origin of the new all-in-one mesh will be set at 0,0,0. 

After using AddMesh, the original source_mesh will still exist, therefore  use FreeEntity to delete it if you wish to do so.

End Rem
Function AddMesh( mesh1:TMesh,mesh2:TMesh )
End Function

Rem
bbdoc: Adds a triangle to a surface and returns the triangle's index number
about: 
@Parameters: 

surface - surface handle

v0 - index number of first vertex of triangle

v1 - index number of second vertex of triangle

v2 - index number of third vertex of triangle

@Description: 

Adds a triangle to a surface and returns the triangle's index number, starting  from 0.

The v0, v1 and v2 parameters are the index numbers of the vertices  created using AddVertex. 

Depending on how the vertices are arranged, then the triangle will only be  visible from a certain side. Imagine that a triangle's vertex points are like  dot-to-dot pattern, each numbered v0, v1, v2. If these dots, starting from v0,  through to V2, form a clockwise pattern relative to the viewer, then the triangle  will be visible. If these dots form an anti-clockwise pattern relative to the  viewer, then the triangle will not be visible. 

The reason for having one-sided triangles is that it reduces the amount of  triangles that need to be rendered when one side faces the side of an object  which won't be seen (such as the inside of a snooker ball). However, if you  wish for a triangle to be two-sided, then you can either create two triangles,  using the same set of vertex numbers for both but assigning them in opposite  orders, or you can use CopyEntity and FlipMesh together.

End Rem
Function AddTriangle:Int( surf:TSurface,v0:Int,v1:Int,v2:Int )
End Function

Rem
bbdoc: Adds a vertex to the specified surface and returns the vertices' index number
about: 
@Parameters: 

surface - surface handle

x# - x coordinate of vertex

y# - y coordinate of vertex

z# - z coordinate of vertex

u# (optional) - u texture coordinate of vertex

v# (optional) - v texture coordinate of vertex

w# (optional) - w texture coordinate of vertex - not used, included for future expansion

@Description: 

Adds a vertex to the specified surface and returns the vertices' index number,  starting from 0.

x,y,z are the geometric coordinates of the vertex, and u,v,w are texture mapping coordinates.

A vertex is a point in 3D space which is used to connect edges of a triangle together. Without any vertices, you can't have any triangles. At least three  vertices are needed to create one triangle; one for each corner. 

The optional u, v and w parameters allow you to specify texture coordinates for a vertex, which will determine how any triangle created using those vertices will be texture mapped. The u, v and w parameters specified will take effect on both texture coordinate sets (0 and 1). This works on the following basis: 

The top left of an image has the uv coordinates 0,0. 
The top right has coordinates 1,0
The bottom right is 1,1.
The bottom left 0,1. 

Thus, uv coordinates for a vertex correspond to a point in the image. For example, coordinates 0.9,0.1 would be near the upper right corner of the image. 

So now imagine you have a normal equilateral triangle. By assigning the bottom left vertex a uv coordinate of 0,0, the bottom right a coordinate of 1,0 and the top centre 0.5,1, this will texture map the triangle with an image that fits it.

When adding a vertex its default color is 255,255,255,255.

End Rem
Function AddVertex:Int( surf:TSurface,x:Float,y:Float,z:Float,u:Float=0,v:Float=0,w:Float=0 )
End Function

Rem
bbdoc: Sets the ambient lighting colour
about: 
@Parameters: 

red# - red ambient light value

green# - green ambient light value

blue# - blue ambient light value


The green, red and blue values should be  in the range 0-255. The default ambient light colour is 127,127,127.

@Description: 

Sets the ambient lighting colour.

Ambient light is a light source that affects all points on a 3D object equally.  So with ambient light only, all 3D objects will appear flat, as there will be  no shading.

Ambient light is useful for providing a certain level of light, before adding  other lights to provide a realistic lighting effect.

An ambient light level of 0,0,0 will result in no ambient light being displayed.

See also: <a href=#CreateLight>CreateLight</a>.

End Rem
Function AmbientLight( r:Float,g:Float,b:Float )
End Function

Rem
bbdoc: Animates an entity
about: 
@Parameters: 

entity - entity handle


mode (optional) - mode of animation.

0: stop animation

1: loop animation (default)

2: ping-pong animation

3: one-shot animation


speed# (optional) - speed of animation. Defaults to 1.

sequence (optional) - specifies which sequence of animation frames to play.  Defaults to 0.

transition# (optional) - used to tween between an entities current position  rotation and the first frame of animation. Defaults to 0.

@Description: 

Animates an entity.

More info about the optional parameters: 

speed# - a negative speed will play the animation backwards. 

sequence - Initially, an entity loaded with LoadAnimMesh  will have a single animation sequence. More sequences can be added using either LoadAnimSeq or AddAnimSeq.  Animation sequences are numbered 0,1,2...etc. 

transition# - A value of 0 will cause an instant 'leap' to the first frame,  while values greater than 0 will cause a smooth transition. 

End Rem
Function Animate( ent:TEntity,Mode:Int=1,speed:Float=1,seq:Int=0,trans:Int=0 )
End Function

Rem
bbdoc: Returns true if the specified entity is currently animating
about: 
@Parameters: 

entity - entity handle

@Description: 

Returns true if the specified entity is currently animating.

End Rem
Function Animating:Int( ent:TEntity )
End Function

Rem
bbdoc: Returns the length of the specified entity's current animation sequence
about: 
@Parameters: 

entity - entity handle

@Description: 

Returns the length of the specified entity's current animation sequence.

End Rem
Function AnimLength:Int( ent:TEntity )
End Function

Rem
bbdoc: Returns the specified entity's current animation sequence
about: 
@Parameters: 

entity - entity handle

@Description: 

Returns the specified entity's current animation sequence.

End Rem
Function AnimSeq:Int( ent:TEntity )
End Function

Rem
bbdoc: Returns the current animation time of an entity
about: 
@Parameters: 

entity - entity handle

@Description: 

Returns the current animation time of an entity.

End Rem
Function AnimTime:Float( ent:TEntity )
End Function

Rem
bbdoc: Enables or disables fullscreen antialiasing
about: 
@Parameters: 

enable - True to enable fullscreen antialiasing, False to disable.


The default AntiAlias mode is False.

@Description: 

Enables or disables fullscreen antialiasing.

Fullscreen antialiasing is a technique used to smooth out the entire screen,  so that jagged lines are made less noticeable.

Some 3D cards have built-in support for fullscreen antialiasing, which should  allow you to enable the effect without much slowdown. However, for cards without  built-in support for fullscreen antialiasing, enabling the effect may cause  severe slowdown.

End Rem
Function AntiAlias( samples:Int )
End Function

Rem
bbdoc: Sets the alpha level of a brush
about: 
@Parameters: 

brush - brush handle

alpha# - alpha level of brush

@Description: 

Sets the alpha level of a brush.

The alpha# value should be in the range  0-1. The default brush alpha setting is 1. 

The alpha level is how transparent an entity is. A value of 1 will mean the  entity is non-transparent, i.e. opaque. A value of 0 will mean the entity is  completely transparent, i.e. invisible. Values between 0 and 1 will cause varying  amount of transparency accordingly, useful for imitating the look of objects  such as glass and ice. 

An BrushAlpha value of 0 is especially useful as Blitz3D will not render  entities with such a value, but will still involve the entities in collision  tests. This is unlike HideEntity, which doesn't  involve entities in collisions.

End Rem
Function BrushAlpha( brush:TBrush,a:Float )
End Function

Rem
bbdoc: Sets the blending mode for a brush
about: 
@Parameters: 

brush - brush handle

blend -

1: alpha (default)

2: multiply

3: add

@Description: 

Sets the blending mode for a brush.

End Rem
Function BrushBlend( brush:TBrush,blend:Int )
End Function

Rem
bbdoc: Sets the colour of a brush
about: 
@Parameters: 

brush - brush handle

red# - red value of brush

green# - green value of brush

blue# - blue value of brush

@Description: 

Sets the colour of a brush.

The green, red and blue values should be in  the range 0-255. The default brush color is  255,255,255.

Please note that if EntityFX or  BrushFX flag 2 is being used, brush colour will have no effect and vertex  colours will be used instead.

End Rem
Function BrushColor( brush:TBrush,r:Float,g:Float,b:Float )
End Function

Rem
bbdoc: Sets miscellaneous effects for a brush
about: 
@Parameters: 

brush - brush handle


fx -

0: nothing (default)

1: full-bright

2: use vertex colors instead of brush color

4: flatshaded

8: disable fog

16: disable backface culling

@Description: 

Sets miscellaneous effects for a brush.

Flags can be added to combine  two or more effects. For example, specifying a flag of 3 (1+2) will result in  a full-bright and vertex-coloured brush.

End Rem
Function BrushFX( brush:TBrush,fx:Int )
End Function

Rem
bbdoc: Sets the specular shininess of a brush
about: 
@Parameters: 

brush - brush handle

shininess# - shininess of brush

@Description: 

Sets the specular shininess of a brush.

The shininess# value should be  in the range 0-1. The default shininess setting is 0. 

Shininess is how much brighter certain areas of an object will appear to  be when a light is shone directly at them. 

Setting a shininess value of 1 for a medium to high poly sphere, combined  with the creation of a light shining in the direction of it, will give it the  appearance of a shiny snooker ball.

End Rem
Function BrushShininess( brush:TBrush,s:Float )
End Function

Rem
bbdoc: Assigns a texture to a brush
about: 
@Parameters: 

brush - brush handle

texture - texture handle

frame (optional) - texture frame. Defaults to 0.

index (optional) - texture index. Defaults to 0.

@Description: 

Assigns a texture to a brush.

The optional frame parameter specifies which  animation frame, if any exist, should be assigned to the brush. 

The optional index parameter specifies texture layer that the texture should  be assigned to. Brushes have up to four texture layers, 0-3 inclusive.

End Rem
Function BrushTexture( brush:TBrush,tex:TTexture,frame:Int=0,index:Int=0 )
End Function

Rem
bbdoc: Sets camera background color
about: 
@Parameters: 

camera - camera handle

red# - red value of camera background color

green# - green value of camera background color

blue# - blue value of camera background color

@Description: 

Sets camera background color. Defaults to 0,0,0.

End Rem
Function CameraClsColor( cam:TCamera,r:Float,g:Float,b:Float )
End Function

Rem
bbdoc: Sets camera clear mode
about: 
@Parameters: 

camera - camera handle

cls_color - true to clear the color buffer, false not to

cls_zbuffer - true to clear the z-buffer, false not to

@Description: 

Sets camera clear mode.

End Rem
Function CameraClsMode( cam:TCamera,cls_depth:Int,cls_zbuffer:Int )
End Function

Rem
bbdoc: Sets camera fog color
about: 
@Parameters: 

camera - camera handle

red# - red value of value

green# - green value of fog

blue# - blue value of fog

@Description: 

Sets camera fog color.

End Rem
Function CameraFogColor( cam:TCamera,r:Float,g:Float,b:Float )
End Function

Rem
bbdoc: Sets the camera fog mode
about: 
@Parameters: 

camera - camera handle


mode -

0: no fog (default)

1: linear fog

@Description: 

Sets the camera fog mode.

This will enable/disable fogging, a technique  used to gradually fade out graphics the further they are away from the camera.  This can be used to avoid 'pop-up', the moment at which 3D objects suddenly  appear on the horizon. 

The default fog colour is black and the default fog range is 1-1000, although  these can be changed by using CameraFogColor  and CameraFogRange respectively. 

Each camera can have its own fog mode, for multiple on-screen fog effects.

End Rem
Function CameraFogMode( cam:TCamera,Mode:Int )
End Function

Rem
bbdoc: Sets camera fog range
about: 
@Parameters: 

camera - camera handle

near# - distance in front of camera that fog starts

far# - distance in front of camera that fog ends

@Description: 

Sets camera fog range.

The near parameter specifies at what distance  in front of the camera that the fogging effect will start; all 3D object  before this point will not be faded. 

The far parameter specifies at what distance in front of the camera that  the fogging effect will end; all 3D objects beyond this point will be  completely faded out.

End Rem
Function CameraFogRange( cam:TCamera,nnear:Float,nfar:Float )
End Function

Rem
bbdoc: Picks the entity positioned at the specified viewport coordinates
about: 
@Parameters: 

camera - camera handle

viewport_x# - 2D viewport coordinate

viewport_z# - 2D viewport coordinate

@Description: 

Picks the entity positioned at the specified viewport coordinates.

Returns  the entity picked, or 0 if none there. 

An entity must have its EntityPickMode set  to a non-0 value value to be 'pickable'.

See also: <a href=#EntityPick>EntityPick</a>, <a href=#LinePick>LinePick</a>, <a href=#CameraPick>CameraPick</a>, <a href=#EntityPickMode>EntityPickMode</a>.

End Rem
Function CameraPick:TEntity( cam:TCamera,x:Float,y:Float )
End Function

Rem
bbdoc: Projects the world coordinates x
about: 
@Parameters: 

camera - camera handle

x# - world coordinate x

y# - world coordinate y

z# - world coordinate z

@Description: 

Projects the world coordinates x,y,z on to the 2D screen.

End Rem
Function CameraProject( cam:TCamera,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: Sets the camera projection mode
about: 
@Parameters: 

camera - camera handle

mode - projection mode:

0: no projection - disables camera (faster than HideEntity)

1: perspective projection (default)

2: orthographic projection

@Description: 

Sets the camera projection mode.

The projection mode is the the technique  used by Blitz to display 3D graphics on the screen. Using projection mode 0,  nothing is displayed on the screen, and this is the fastest method of hiding  a camera. Using camera projection mode 1, the graphics are displayed in their  'correct' form - and this is the default mode for a camera. Camera projection  mode 2 is a special type of projection, used for displaying 3D graphics on screen,  but in a 2D form - that is, no sense of perspective will be given to the graphics.  Two identical objects at varying distances from the camera will both appear  to be the same size. Orthographic projection is useful for 3D editors, where  a sense of perspective is unimportant, and also certain games. 

Use 'CameraZoom' to control the scale of graphics rendered with orthographic  projection. As a general rule, using orthographic projection with the default  camera zoom setting of 1 will result in graphics that are too 'zoomed-in' -  changing the camera zoom to 0.1 should fix this. 

One thing to note with using camera project mode 2, is that terrains will  not be displayed correctly - this is because the level of detail algorithm used  by terrains relies on perspective in order to work properly. 

End Rem
Function CameraProjMode( cam:TCamera,Mode:Int )
End Function

Rem
bbdoc: Sets camera range
about: 
@Parameters: 

camera - camera handle

near - distance in front of camera that 3D objects start being drawn

far - distance in front of camera that 3D object stop being drawn

@Description: 

Sets camera range.

Try and keep the ratio of far/near as small as possible  for optimal z-buffer performance. Defaults to 1,1000. 

End Rem
Function CameraRange( cam:TCamera,nnear:Float,nfar:Float )
End Function

Rem
bbdoc: Sets the camera viewport position and size
about: 
@Parameters: 

camera - camera handle

x - x coordinate of top left hand corner of viewport

y - y coordinate of top left hand corner of viewport

width - width of viewport

height - height of viewport

@Description: 

Sets the camera viewport position and size.

The camera viewport is the  area of the 2D screen that the 3D graphics as viewed by the camera are  displayed in. 

Setting the camera viewport allows you to achieve spilt-screen and  rear-view mirror effects.

End Rem
Function CameraViewport( cam:TCamera,x:Int,y:Int,width:Int,height:Int )
End Function

Rem
bbdoc: Sets zoom factor for a camera
about: 
@Parameters: 

camera - camera handle

zoom# - zoom factor of camera

@Description: 

Sets zoom factor for a camera. Defaults to 1.

End Rem
Function CameraZoom( cam:TCamera,zoom:Float )
End Function

Rem
bbdoc: Clears the collision information list
about: 
@Parameters: 

None.

@Description: 

Clears the collision information list.

Whenever you use the Collisions command to enable collisions between  two different entity types, information is added to the collision list. This  command clears that list, so that no collisions will be detected until the Collisions  command is used again. 

The command will not clear entity collision information. For example, entity  radius, type etc. 

End Rem
Function ClearCollisions()
End Function

Rem
bbdoc: Removes all vertices and/or triangles from a surface
about: 
@Parameters: 

surface - surface handle

clear_verts (optional) - true to remove all vertices from the specified surface,  false not to. Defaults to true.

clear_triangles (optional) - true to remove all triangles from the specified  surface, false not to. Defaults to true.

@Description: 

Removes all vertices and/or triangles from a surface.

This is useful for  clearing sections of mesh. The results will be instantly visible. 

After clearing a surface, you may wish to add vertices and triangles to it  again but with a slightly different polygon count for dynamic level of detail  (LOD). 

End Rem
Function ClearSurface( surf:TSurface,clear_verts:Int=True,clear_tris:Int=True )
End Function

Rem
bbdoc: Clears the current texture filter list
about: 
@Parameters: 

None.

@Description: 

Clears the current texture filter list.

End Rem
Function ClearTextureFilters()
End Function

Rem
bbdoc: Clears all entities
about: 
@Parameters: 

entities (optional) - True to clear all entities, False not to. Defaults  to true.

brushes (optional) - True to clear all brushes, False not to. Defaults to true.

textures (optional) - True to clear all textures, False not to. Defaults to  true.

@Description: 

Clears all entities, brushes and/or textures from the screen and from memory.

As soon as you clear something, you will not be able to use it again until you  reload it. Trying to do so will cause a runtime error. 

This command is useful for when a level has finished and you wish to load  a different level with new entities, brushes and textures. 

End Rem
Function ClearWorld( entities:Int=True,brushes:Int=True,textures:Int=True )
End Function

Rem
bbdoc: Returns the other entity involved in a particular collision
about: 
@Parameters: 

entity - entity handle

index - index of collision

@Description: 

Returns the other entity involved in a particular collision. Index should  be in the range 1...CountCollisions( entity  ), inclusive.

See also: <a href=#CollisionX>CollisionX</a>, <a href=#CollisionY>CollisionY</a>, <a href=#CollisionZ>CollisionZ</a>, <a href=#CollisionNX>CollisionNX</a>, <a href=#CollisionNY>CollisionNY</a>, <a href=#CollisionNZ>CollisionNZ</a>, <a href=#CountCollisions>CountCollisions</a>, <a href=#EntityCollided>EntityCollided</a>, <a href=#CollisionTime>CollisionTime</a>, <a href=#CollisionEntity>CollisionEntity</a>, <a href=#CollisionSurface>CollisionSurface</a>, <a href=#CollisionTriangle>CollisionTriangle</a>.

End Rem
Function CollisionEntity:TEntity( ent:TEntity,index:Int )
End Function

Rem
bbdoc: Returns the x component of the normal of a particular collision
about: 
@Parameters: 

entity - entity handle

index - index of collision

@Description: 

Returns the x component of the normal of a particular collision.

Index  should be in the range 1...CountCollisions(  entity ) inclusive.

See also: <a href=#CollisionX>CollisionX</a>, <a href=#CollisionY>CollisionY</a>, <a href=#CollisionZ>CollisionZ</a>, <a href=#CollisionNX>CollisionNX</a>, <a href=#CollisionNY>CollisionNY</a>, <a href=#CollisionNZ>CollisionNZ</a>, <a href=#CountCollisions>CountCollisions</a>, <a href=#EntityCollided>EntityCollided</a>, <a href=#CollisionTime>CollisionTime</a>, <a href=#CollisionEntity>CollisionEntity</a>, <a href=#CollisionSurface>CollisionSurface</a>, <a href=#CollisionTriangle>CollisionTriangle</a>.

End Rem
Function CollisionNX:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: Returns the y component of the normal of a particular collision
about: 
@Parameters: 

entity - entity handle

index - index of collision

@Description: 

Returns the y component of the normal of a particular collision.

Index  should be in the range 1...CountCollisions(  entity ) inclusive.

See also: <a href=#CollisionX>CollisionX</a>, <a href=#CollisionY>CollisionY</a>, <a href=#CollisionZ>CollisionZ</a>, <a href=#CollisionNX>CollisionNX</a>, <a href=#CollisionNY>CollisionNY</a>, <a href=#CollisionNZ>CollisionNZ</a>, <a href=#CountCollisions>CountCollisions</a>, <a href=#EntityCollided>EntityCollided</a>, <a href=#CollisionTime>CollisionTime</a>, <a href=#CollisionEntity>CollisionEntity</a>, <a href=#CollisionSurface>CollisionSurface</a>, <a href=#CollisionTriangle>CollisionTriangle</a>.

End Rem
Function CollisionNY:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: Returns the z component of the normal of a particular collision
about: 
@Parameters: 

entity - entity handle

index - index of collision

@Description: 

Returns the z component of the normal of a particular collision.

Index  should be in the range 1...CountCollisions(  entity ) inclusive.

See also: <a href=#CollisionX>CollisionX</a>, <a href=#CollisionY>CollisionY</a>, <a href=#CollisionZ>CollisionZ</a>, <a href=#CollisionNX>CollisionNX</a>, <a href=#CollisionNY>CollisionNY</a>, <a href=#CollisionNZ>CollisionNZ</a>, <a href=#CountCollisions>CountCollisions</a>, <a href=#EntityCollided>EntityCollided</a>, <a href=#CollisionTime>CollisionTime</a>, <a href=#CollisionEntity>CollisionEntity</a>, <a href=#CollisionSurface>CollisionSurface</a>, <a href=#CollisionTriangle>CollisionTriangle</a>.

End Rem
Function CollisionNZ:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: Enables collisions between two different entity types
about: 
@Parameters: 

src_type - entity type to be checked for collisions.

dest_type - entity type to be collided with.



method - collision detection method.

1: ellipsoid-to-ellipsoid collisions

2: ellipsoid-to-polygon collisions

3: ellipsoid-to-box collisions



response - what the source entity does when a collision occurs.

1: stop

2: slide1 - full sliding collision

3: slide2 - prevent entities from sliding down slopes

@Description: 

Enables collisions between two different entity types.

Entity types are just numbers you assign to an entity using EntityType. Blitz then uses the entity types to check for collisions between all the entities that have those entity types. 

Blitz has many ways of checking for collisions, as denoted by the method parameter. However, collision checking is always ellipsoid to something. In order for Blitz to know what size a source entity is, you must first assign an entity radius to all source entities using EntityRadius. 

In the case of collision detection method 1 being selected (ellipsoid-to-ellipsoid), then the destination entities concerned will need to have an EntityRadius assigned to them too. In the case of method 3 being selected (ellipsoid-to-box), then the destination entities  will need to have an EntityBox assigned to them. Method 2 (ellipsoid-to-polygon) requires nothing to be assigned to the destination entities. 

Not only does Blitz check for collisions, but it acts upon them when it detects them too, as denoted by the response parameter. You have three options in this situation. You can either choose to make the source entity stop, slide or only slide upwards. 

All collision checking occurs, and collision responses are acted out, when UpdateWorld is called.

Finally, every time the Collision command is used, collision information is added to the collision information list. This can be cleared at any time using the ClearCollisions command.

See also: <a href=#EntityBox>EntityBox</a>, <a href=#EntityRadius>EntityRadius</a>, <a href=#Collisions>Collisions</a>, <a href=#EntityType>EntityType</a>, <a href=#ResetEntity>ResetEntity</a>.

End Rem
Function Collisions( src_no:Int,dest_no:Int,method_no:Int,response_no:Int=0 )
End Function

Rem
bbdoc: Returns the handle of the surface belonging to the specified entity that was closest to the point of a particular collision
about: 
@Parameters: 

entity - entity handle

index - index of collision

@Description: 

Returns the handle of the surface belonging to the specified entity that was closest to the point of a particular collision.

Index should be in  the range 1...CountCollisions( entity ), inclusive.

See also: <a href=#CollisionX>CollisionX</a>, <a href=#CollisionY>CollisionY</a>, <a href=#CollisionZ>CollisionZ</a>, <a href=#CollisionNX>CollisionNX</a>, <a href=#CollisionNY>CollisionNY</a>, <a href=#CollisionNZ>CollisionNZ</a>, <a href=#CountCollisions>CountCollisions</a>, <a href=#EntityCollided>EntityCollided</a>, <a href=#CollisionTime>CollisionTime</a>, <a href=#CollisionEntity>CollisionEntity</a>, <a href=#CollisionSurface>CollisionSurface</a>, <a href=#CollisionTriangle>CollisionTriangle</a>.

End Rem
Function CollisionSurface:TSurface( ent:TEntity,index:Int )
End Function

Rem
bbdoc: Returns the time taken to calculate a particular collision
about: 
@Parameters: 

entity - entity handle

index - index of collision

@Description: 

Returns the time taken to calculate a particular collision.

Index should be in the range 1...CountCollisions(  entity ) inclusive.

See also: <a href=#CollisionX>CollisionX</a>, <a href=#CollisionY>CollisionY</a>, <a href=#CollisionZ>CollisionZ</a>, <a href=#CollisionNX>CollisionNX</a>, <a href=#CollisionNY>CollisionNY</a>, <a href=#CollisionNZ>CollisionNZ</a>, <a href=#CountCollisions>CountCollisions</a>, <a href=#EntityCollided>EntityCollided</a>, <a href=#CollisionTime>CollisionTime</a>, <a href=#CollisionEntity>CollisionEntity</a>, <a href=#CollisionSurface>CollisionSurface</a>, <a href=#CollisionTriangle>CollisionTriangle</a>.

End Rem
Function CollisionTime:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: Returns the index number of the triangle belonging to the specified entity  that was closest to the point of a particular collision
about: 
@Parameters: 

entity - entity handle

index - index of collision

@Description: 

Returns the index number of the triangle belonging to the specified entity  that was closest to the point of a particular collision.

Index should be in the range 1...CountCollisions(  entity ), inclusive.

See also: <a href=#CollisionX>CollisionX</a>, <a href=#CollisionY>CollisionY</a>, <a href=#CollisionZ>CollisionZ</a>, <a href=#CollisionNX>CollisionNX</a>, <a href=#CollisionNY>CollisionNY</a>, <a href=#CollisionNZ>CollisionNZ</a>, <a href=#CountCollisions>CountCollisions</a>, <a href=#EntityCollided>EntityCollided</a>, <a href=#CollisionTime>CollisionTime</a>, <a href=#CollisionEntity>CollisionEntity</a>, <a href=#CollisionSurface>CollisionSurface</a>, <a href=#CollisionTriangle>CollisionTriangle</a>.

End Rem
Function CollisionTriangle:Int( ent:TEntity,index:Int )
End Function

Rem
bbdoc: Returns the world x coordinate of a particular collision
about: 
@Parameters: 

entity - entity handle

index - index of collision

@Description: 

Returns the world x coordinate of a particular collision.

Index should  be in the range 1...CountCollisions( entity  ) inclusive.

See also: <a href=#CollisionX>CollisionX</a>, <a href=#CollisionY>CollisionY</a>, <a href=#CollisionZ>CollisionZ</a>, <a href=#CollisionNX>CollisionNX</a>, <a href=#CollisionNY>CollisionNY</a>, <a href=#CollisionNZ>CollisionNZ</a>, <a href=#CountCollisions>CountCollisions</a>, <a href=#EntityCollided>EntityCollided</a>, <a href=#CollisionTime>CollisionTime</a>, <a href=#CollisionEntity>CollisionEntity</a>, <a href=#CollisionSurface>CollisionSurface</a>, <a href=#CollisionTriangle>CollisionTriangle</a>.

End Rem
Function CollisionX:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: Returns the world y coordinate of a particular collision
about: 
@Parameters: 

entity - entity handle

index - index of collision

@Description: 

Returns the world y coordinate of a particular collision.

Index should  be in the range 1...CountCollisions( entity  ) inclusive.

See also: <a href=#CollisionX>CollisionX</a>, <a href=#CollisionY>CollisionY</a>, <a href=#CollisionZ>CollisionZ</a>, <a href=#CollisionNX>CollisionNX</a>, <a href=#CollisionNY>CollisionNY</a>, <a href=#CollisionNZ>CollisionNZ</a>, <a href=#CountCollisions>CountCollisions</a>, <a href=#EntityCollided>EntityCollided</a>, <a href=#CollisionTime>CollisionTime</a>, <a href=#CollisionEntity>CollisionEntity</a>, <a href=#CollisionSurface>CollisionSurface</a>, <a href=#CollisionTriangle>CollisionTriangle</a>.

End Rem
Function CollisionY:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: Returns the world z coordinate of a particular collision
about: 
@Parameters: 

entity - entity handle

index - index of collision

@Description: 

Returns the world z coordinate of a particular collision.

Index should  be in the range 1...CountCollisions( entity  ) inclusive.

See also: <a href=#CollisionX>CollisionX</a>, <a href=#CollisionY>CollisionY</a>, <a href=#CollisionZ>CollisionZ</a>, <a href=#CollisionNX>CollisionNX</a>, <a href=#CollisionNY>CollisionNY</a>, <a href=#CollisionNZ>CollisionNZ</a>, <a href=#CountCollisions>CountCollisions</a>, <a href=#EntityCollided>EntityCollided</a>, <a href=#CollisionTime>CollisionTime</a>, <a href=#CollisionEntity>CollisionEntity</a>, <a href=#CollisionSurface>CollisionSurface</a>, <a href=#CollisionTriangle>CollisionTriangle</a>.

End Rem
Function CollisionZ:Float( ent:TEntity,index:Int )
End Function

Rem
bbdoc: Creates a copy of an entity and returns the handle of the newly created copy
about: 
@Parameters: 

entity - Entity Handle

parent (optional) - Entity that will act as Parent to the copy.

@Description: 

Creates a copy of an entity and returns the handle of the newly created copy. This is a new entity instance of an existing entity's mesh! Anything you do to the original Mesh (such as RotateMesh) will effect all the copies. Other properties (such as EntityColor, Position etc.) since they are 'Entity' properties, will be individual to the copy.

If a parent entity is specified, the copied entity will be created at the parent entity's position. Otherwise, it will be created at 0,0,0.

End Rem
Function CopyEntity:TEntity( ent:TEntity,parent:TEntity=Null )
End Function

Rem
bbdoc: Creates a copy of a mesh and returns the newly-created mesh's handle
about: 
@Parameters: 

mesh - handle of mesh to be copied

parent (optional) - handle of entity to be made parent of mesh

@Description: 

Creates a copy of a mesh and returns the newly-created mesh's handle.

The difference between CopyMesh and CopyEntity  is that CopyMesh performs a 'deep' copy of a mesh. 

CopyMesh is identical to performing new_mesh=CreateMesh() : AddMesh mesh,new_mesh

End Rem
Function CopyMesh:TMesh( mesh:TMesh,parent:TEntity=Null )
End Function

Rem
bbdoc: Returns the number of children of an entity
about: 
@Parameters: 

entity - entity handle

@Description: 

Returns the number of children of an entity.

End Rem
Function CountChildren:Int( ent:TEntity )
End Function

Rem
bbdoc: Returns how many collisions an entity was involved in during the last UpdateWorld
about: 
@Parameters: 

entity - entity handle

@Description: 

Returns how many collisions an entity was involved in during the last UpdateWorld.

See also: <a href=#CollisionX>CollisionX</a>, <a href=#CollisionY>CollisionY</a>, <a href=#CollisionZ>CollisionZ</a>, <a href=#CollisionNX>CollisionNX</a>, <a href=#CollisionNY>CollisionNY</a>, <a href=#CollisionNZ>CollisionNZ</a>, <a href=#CountCollisions>CountCollisions</a>, <a href=#EntityCollided>EntityCollided</a>, <a href=#CollisionTime>CollisionTime</a>, <a href=#CollisionEntity>CollisionEntity</a>, <a href=#CollisionSurface>CollisionSurface</a>, <a href=#CollisionTriangle>CollisionTriangle</a>.

End Rem
Function CountCollisions:Int( ent:TEntity )
End Function

Rem
bbdoc: Returns the number of surfaces in a mesh
about: 
@Parameters: 

mesh - mesh handle

@Description: 

Returns the number of surfaces in a mesh.

Surfaces are sections of mesh.  A mesh may contain only one section, or very many. 

See also: <a href=#GetSurface>GetSurface</a>.

End Rem
Function CountSurfaces:Int( mesh:TMesh )
End Function

Rem
bbdoc: Returns the number of triangles in a surface
about: 
@Parameters: 

surface - surface handle

@Description: 

Returns the number of triangles in a surface.

End Rem
Function CountTriangles:Int( surf:TSurface )
End Function

Rem
bbdoc: Returns the number of vertices in a surface
about: 
@Parameters: 

surface - surface handle

@Description: 

Returns the number of vertices in a surface.

End Rem
Function CountVertices:Int( surf:TSurface )
End Function

Rem
bbdoc: Creates a brush and returns a brush handle
about: 
@Parameters: 

red# (optional) - brush red value

green# (optional) - brush green value

blue# (optional) - brush blue value

@Description: 

Creates a brush and returns a brush handle.

The optional green, red and  blue values allow you to set the colour of the brush. Values should be in the  range 0-255. If omitted the values default to 255.

A brush is a collection of properties such as Colour, Alpha, Shininess, Texture  etc that are all stored as part of the brush. Then, all these properties can  be applied to an entity, mesh or surface at once just by using PaintEntity, PaintMesh  or PaintSurface. 

When creating your own mesh, if you wish for certain surfaces to look differently  from one another, then you will need to use brushes to paint individual surfaces.  Using commands such as EntityColor, EntityAlpha will apply the effect to all  surfaces at once, which may not be what you wish to achieve. 

See also: <a href=#LoadBrush>LoadBrush</a>.

End Rem
Function CreateBrush:TBrush( r:Float=255,g:Float=255,b:Float=255 )
End Function

Rem
bbdoc: Creates a camera entity and returns its handle
about: 
@Parameters: 

parent (optional) - parent entity of camera

@Description: 

Creates a camera entity and returns its handle.

Without  at least one camera, you won't be able to see anything in your 3D world. With more than one camera, you will be to achieve effect such as  split-screen modes and rear-view mirrors. 

A camera can only render to the backbuffer. If you wish to display 3D  graphics on an image or a texture then copy the contents of the backbuffer  to the appropriate buffer. 

The optional parent parameter allow you to specify a parent entity for  the camera so that when the parent is moved the child camera will move with  it. However, this relationship is one way; applying movement commands to the  child will not affect the parent. 

Specifying a parent entity will still result in the camera being created  at position 0,0,0 rather than at the parent entity's position.

End Rem
Function CreateCamera:TCamera( parent:TEntity=Null )
End Function

Rem
bbdoc: Creates a cone mesh/entity and returns its handle
about: 
@Parameters: 

segments (optional) - cone detail. Defaults to 8.

solid (optional) - true for a cone with a base, false for a cone without a base.  Defaults to true.

parent (optional) - parent entity of cone

@Description: 

Creates a cone mesh/entity and returns its handle.

The cone will be centred  at 0,0,0 and the base of the cone will have a radius of 1. 

The segments value must be in the range 3-100 inclusive, although this is  only checked in debug mode. A common mistake is to leave debug mode off and  specify the parent parameter (usually an eight digit memory address) in the  place of the segments value. As the amount of polygons used to create a cone  is exponentially proportional to the segments value, this will result in Blitz  trying to create a cone with unimaginable amounts of polygons! Depending on  how unlucky you are, your computer will then crash. 

Example segments values (solid=true):
4: 6 polygons - a pyramid
8: 14 polygons - bare minimum amount of polygons for a cone
16: 30 polygons - smooth cone at medium-high distances
32: 62 polygons - smooth cone at close distances 

The optional parent parameter allow you to specify a parent entity for the  cone so that when the parent is moved the child cone will move with it. However,  this relationship is one way; applying movement commands to the child will not  affect the parent. 

Specifying a parent entity will still result in the cone being created at  position 0,0,0 rather than at the parent entity's position. 

See also: <a href=#CreateCube>CreateCube</a>, <a href=#CreateSphere>CreateSphere</a>, <a href=#CreateCylinder>CreateCylinder</a>.

End Rem
Function CreateCone:TMesh( segments:Int=8,solid:Int=True,parent:TEntity=Null )
End Function

Rem
bbdoc: Creates a cylinder mesh/entity and returns its handle
about: 
@Parameters: 

segments (optional) - cylinder detail. Defaults to 8.

solid (optional) - true for a cylinder, false for a tube. Defaults to true.

parent (optional) - parent entity of cylinder

@Description: 

Creates a cylinder mesh/entity and returns its handle.

The cylinder will  be centred at 0,0,0 and will have a radius of 1. 

The segments value must be in the range 3-100 inclusive, although this is  only checked in debug mode. A common mistake is to leave debug mode off and  specify the parent parameter (usually an eight digit memory address) in the  place of the segments value. As the amount of polygons used to create a cylinder  is exponentially proportional to the segments value, this will result in Blitz  trying to create a cylinder with unimaginable amounts of polygons! Depending  on how unlucky you are, your computer may then crash. 

Example segments values (solid=true):
3: 8 polygons - a prism
8: 28 polygons - bare minimum amount of polygons for a cylinder
16: 60 polygons - smooth cylinder at medium-high distances
32: 124 polygons - smooth cylinder at close distances 

The optional parent parameter allow you to specify a parent entity for the  cylinder so that when the parent is moved the child cylinder will move with  it. However, this relationship is one way; applying movement commands to the  child will not affect the parent. 

Specifying a parent entity will still result in the cylinder being created  at position 0,0,0 rather than at the parent entity's position. 

See also: <a href=#CreateCube>CreateCube</a>, <a href=#CreateSphere>CreateSphere</a>, <a href=#CreateCone>CreateCone</a>.

End Rem
Function CreateCylinder:TMesh( segments:Int=8,solid:Int=True,parent:TEntity=Null )
End Function

Rem
bbdoc: Creates a cube mesh/entity and returns its handle
about: 
@Parameters: 

[parent] (optional) - This allows you to set the parent entity of Cube.

@Description: 

Creates a cube mesh/entity and returns its handle.

The cube will extend from  -1,-1,-1 to +1,+1,+1.  

The optional parent parameter allow you to specify a parent entity for  the cube so that when the parent is moved the child cube will move with it.  However, this relationship is one way; applying movement commands to the  child will not affect the parent. 

Specifying a parent entity will still result in the cube being created at  position 0,0,0 rather than at the parent entity's position. 

Creation of cubes, cylinders and cones are a great way of getting scenes set up quickly, as they can act as placeholders for more complex pre-modeled meshes later on in program development. 

See also: <a href=#CreateSphere>CreateSphere</a>, <a href=#CreateCylinder>CreateCylinder</a>, <a href=#CreateCone>CreateCone</a>.

End Rem
Function CreateCube:TMesh( parent:TEntity=Null )
End Function

Rem
bbdoc: Create a 'blank' mesh entity and returns its handle
about: 
@Parameters: 

parent (optional) - This optional parameter allows you to specify another entity which will act as the parent to this mesh.

@Description: 

Create a 'blank' mesh entity and returns its handle.

When a mesh is first created it has no surfaces, vertices or triangles associated with it.

To add geometry to this mesh, you will need to:

CreateSurface() ; To make a surface
AddVertex ; You will need to add at least 3 to make a Triangle
AddTriangle ; This will add a triangle by connecting the Vertices (points) you added to the mesh.

End Rem
Function CreateMesh:TMesh( parent:TEntity=Null )
End Function

Rem
bbdoc: Creates a light
about: 
@Parameters: 

type (optional) - type of light

1: directional (default)

2: point

3: spot


parent (optional) - parent entity of light

@Description: 

Creates a light.

Lights work by affecting the colour of all vertices within  the light's range. You need at to create at least one light if you wish to use 3D graphics otherwise everything will appear flat.

The optional type parameter allows you to specify the type of light you wish to create. A value of 1 creates a directional light. This works similar to a  sun shining on a house. All walls facing a certain direction are lit the same.  How much they are lit by depends on the angle of the light reaching them.  Directional lights have infinite 'position' and infinite range.

A value of 2 creates a point (or omni) light. This works a little bit like a light bulb  in a house, starting from a central point and gradually fading outwards.

A value of 3 creates a spot light. This is a cone of light. This works similar  to shining a torch in a house. It starts with an inner angle of light, and then  extends towards an outer angle of light.  You can adjust the angles of a 'spot' light with the LightConeAngles command.

The optional parent parameter allow you to specify a parent entity for the  light so that when the parent is moved the child light will move with it. However,  this relationship is one way; applying movement commands to the child will not affect the parent. 

Specifying a parent entity will still result in the light being created at  position 0,0,0 rather than at the parent entity's position.


Other notes:
There is a DirectX limit on the number of lights available per scene - this is either 8 or 16 depending on your video card, but you should always assume 8.

Also, you should remember that each light added effects the rendering speed.

Lights do not cast shadows, like they do in real life.

Most games get around these issues by the use of a pre-calculated 'baked' lightmap texture for the static geometry in the scene.

Other lighting techniques include: adjusting vertex colors, dynamic shadows, and/or dynamic lights (ie. moving the lights around in the scene as they are needed).

See also: <a href=#LightRange>LightRange</a>, <a href=#LightColor>LightColor</a>, <a href=#LightConeAngles>LightConeAngles</a>, <a href=#AmbientLight>AmbientLight</a>.

End Rem
Function CreateLight:TLight( light_type:Int=1,parent:TEntity=Null )
End Function

Rem
bbdoc: Creates a pivot entity
about: 
@Parameters: 

parent (optional) - parent entity of pivot

@Description: 

Creates a pivot entity.

A pivot entity is an invisible  point in 3D space that's main use is to act as a parent entity to other entities.  The pivot can then be used to control lots of entities at once, or act as new  centre of rotation for other entities. 

To enforce this relationship; use EntityParent  or make use of the optional parent entity parameter available with all entity  load/creation commands. 

Indeed, this parameter is also available with the CreatePivot command if  you wish for the pivot to have a parent entity itself. 

End Rem
Function CreatePivot:TPivot( parent:TEntity=Null )
End Function

Rem
bbdoc: Creates a sphere mesh/entity and returns its handle
about: 
@Parameters: 

segments (optional) - sphere detail. Defaults to 8.

parent (optional) - parent entity of sphere

@Description: 

Creates a sphere mesh/entity and returns its handle.

The sphere will  be centred  at 0,0,0 and will have a radius of 1. 

The segments value must be in the range 2-100 inclusive, although this is  only checked in debug mode. A common mistake  is to leave debug mode off and specify the parent parameter  (usually an eight digit memory address) in the place of the segments value.  As the amount of polygons used to create a sphere is exponentially  proportional to the segments value, this will result in Blitz trying to create a sphere  with unimaginable amounts of polygons! Depending on how unlucky you are,  your computer will then crash.

Example segments values:
8: 224 polygons - bare minimum amount of polygons for a sphere
16: 960 polygons - smooth looking sphere at medium-high distances
32: 3968 polygons - smooth sphere at close distances

The  optional parent parameter allow you to specify a parent entity for the  sphere so that when the parent is moved the child sphere will move with it.  However, this relationship is one way; applying movement commands to the  child will not affect the parent. 

Specifying a parent entity will still result in the sphere being created  at position 0,0,0 rather than at the parent entity's position. 

See also: <a href=#CreateCube>CreateCube</a>, <a href=#CreateCylinder>CreateCylinder</a>, <a href=#CreateCone>CreateCone</a>.

End Rem
Function CreateSphere:TMesh( segments:Int=8,parent:TEntity=Null )
End Function

Rem
bbdoc: Creates a sprite entity and returns its handle
about: 
@Parameters: 

parent (optional) - parent entity of sprite

@Description: 

Creates a sprite entity and returns its handle.  Sprites are simple flat (usually textured) rectangles made from two triangles.  Unlike other entity objects they don't actually have a mesh that can be manipulated.

The sprite will be positioned  at 0,0,0 and extend from 1,-1 to +1,+1. 

Sprites have two real strengths. The first is that they consist of only two  polygons; meaning you can use many of them at once. This makes them ideal for  particle effects and 2D-using-3D games where you want lots of sprites on-screen  at once. 

Secondly, sprites can be assigned a view mode using SpriteViewMode. By default this view mode is  set to 1, which means the sprite will always face the camera. So no matter what  the orientation of the camera is relative to the sprite, you will never actually  notice that they are flat; by giving them a spherical texture, you can make  them appear to look no different than a normal sphere.  

The optional parent parameter allow you to specify a parent entity for the  sprite so that when the parent is moved the child sprite will move with it.  However, this relationship is one way; applying movement commands to the child  will not affect the parent. 

Specifying a parent entity will still result in the sprite being created  at position 0,0,0 rather than at the parent entity's position.

Note:  Sprites have their own commands for rotation and scaling.

See also: <a href=#LoadSprite>LoadSprite</a>, <a href=#RotateSprite>RotateSprite</a>, <a href=#ScaleSprite>ScaleSprite</a>, <a href=#HandleSprite>HandleSprite</a>, <a href=#SpriteViewMode>SpriteViewMode</a>, <a href=#PositionEntity>PositionEntity</a>, <a href=#MoveEntity>MoveEntity</a>, <a href=#TranslateEntity>TranslateEntity</a>, <a href=#EntityAlpha>EntityAlpha</a>, <a href=#FreeEntity>FreeEntity</a>.

End Rem
Function CreateSprite:TSprite( parent:TEntity=Null )
End Function

Rem
bbdoc: Creates a surface attached to a mesh and returns the surface's handle
about: 
@Parameters: 

mesh - mesh handle

brush (optional) - brush handle

@Description: 

Creates a surface attached to a mesh and returns the surface's handle.

Surfaces are sections of mesh which are then used to attach triangles to. You  must have at least one surface per mesh in order to create a visible mesh, however  you can use as many as you like. Splitting a mesh up into lots of sections allows  you to affect those sections individually, which can be a lot more useful than  if all the surfaces are combined into just one.

End Rem
Function CreateSurface:TSurface( mesh:TMesh,brush:TBrush=Null )
End Function

Rem
bbdoc: Creates a texture and returns its handle
about: 
@Parameters: 

width - width of texture

height - height of texture


flags (optional) - texture flag:

1: Color (default)

2: Alpha

4: Masked

8: Mipmapped

16: Clamp U

32: Clamp V

64: Spherical environment map

128: Cubic environment map

256: Store texture in vram

512: Force the use of high color textures


frames (optional) - no of frames texture will have. Defaults to 1.

@Description: 

Creates a texture and returns its handle.

Width and height are the size  of the texture. Note that the actual texture size may be different from the  width and height requested, as different types of 3D hardware support different  sizes of texture. 

The optional flags parameter allows you to apply certain effects to the texture.  Flags can be added to combine two or more effects, e.g. 3 (1+2) = texture with  color and alpha maps. 

Here some more detailed descriptions of the flags:

1: Color - colour map, what you see is what you get.

2: Alpha - alpha map. If an image contains an alpha map, this will be used to  make certain areas of the texture transparent. Otherwise, the colour map will  be used as an alpha map. With alpha maps, the dark areas always equal high-transparency,  light areas equal low-transparency.

4: Masked - all areas of a texture coloured 0,0,0 will not be drawn to the screen.

8: Mipmapped - low detail versions of the texture will be used at high distance.  Results in a smooth, blurred look.

16: Clamp u - Any part of a texture that lies outsides the U coordinates of 0-1 will not be drawn. Prevents texture-wrapping.

32: Clamp v - Any part of a texture that lies outsides the v coordinates of 0-1 will not be drawn. Prevents texture-wrapping.

64: Spherical environment map - a form of environment mapping. This works by taking a single image, and then applying it to a 3D mesh in such a way that the image appears to be reflected. When used with a texture that contains light sources, it can give some meshes such as a teapot a shiny appearance.

128: Cubic environment map - a form of environment mapping. Cube mapping is similar to spherical mapping, except it uses six images each representing a particular 'face' of an imaginary cube, to give the appearance of an image that perfectly reflects its surroundings.

When creating cubic environment maps with the CreateTexture command, cubemap textures *must* be square 'power of 2' sizes. See the <a href=#SetCubeFace>SetCubeFace</a> command for information on how to then draw to the cubemap.

When loading cubic environments maps into Blitz using LoadTexture, all six images relating to the six faces of the cube must be contained within the one texture, and be laid out in a horizontal strip in the following order - left, forward, right, backward, up, down. The images comprising the cubemap must all be power of two sizes.

Please note that not some older graphics cards do not support cubic mapping. In order to find out if a user's graphics card can support it, use <a href=#GfxDriverCaps3D>GfxDriverCaps3D</a> .

256: Store texture in vram. In some circumstances, this makes for much faster dynamic textures - ie. when using CopyRect between two textures. When drawing to cube maps in real-time, it is preferable to use this flag.

512: Force the use of high color textures in low bit depth graphics modes. This is useful for when you are in 16-bit color mode, and wish to create/load textures with the alpha flag - it should give better results. 

Once you have created a texture, use SetBuffer TextureBuffer to draw to it. However, to display 2D graphics on a texture, it is usually quicker to draw to an image and then copy it to the texturebuffer, and to display 3D graphics on a texture, your only option is to copy from the backbuffer to the texturebuffer.

See also: <a href=#LoadTexture>LoadTexture</a>, <a href=#LoadAnimTexture>LoadAnimTexture</a>.

End Rem
Function CreateTexture:TTexture( width:Int,height:Int,flags:Int=9,frames:Int=1 )
End Function

Rem
bbdoc: Returns the pitch angle
about: 
@Parameters: 

src_entity - source entity handle

dest_entity - destination entity handle

@Description: 

Returns the pitch angle, that src_entity should be rotated by in order to face dest_entity.

This command can be used to be point one entity at another, rotating on the x axis only.

See also: <a href=#DeltaYaw>DeltaYaw</a>.

End Rem
Function DeltaPitch:Float( ent1:TEntity,ent2:TEntity )
End Function

Rem
bbdoc: Returns the yaw angle
about: 
@Parameters: 

src_entity - source entity handle

dest_entity - destination entity handle

@Description: 

Returns the yaw angle, that src_entity should be rotated by in order to face dest_entity.

This command can be used to be point one entity at another, rotating on the y axis only.

See also: <a href=#DeltaPitch>DeltaPitch</a>.

End Rem
Function DeltaYaw:Float( ent1:TEntity,ent2:TEntity )
End Function

Rem
bbdoc: Sets the entity alpha level of an entity
about: 
@Parameters: 

Entity - entity handle

Alpha# - alpha level of entity

@Description: 

Sets the entity alpha level of an entity.

The alpha# value should be in a floating point value in the range 0-1. The default entity alpha setting is 1. 

The alpha level is how transparent an entity is. A value of 1 will mean the entity is opaque. A value of 0 will mean the entity is completely transparent, i.e. invisible. Values between 0 and 1 will cause varying amount of transparency. This is useful for imitating the look of objects such as glass and other translucent materials. 

An EntityAlpha value of 0 is especially useful as Blitz3D will not render entities with such a value, but will still involve the entities in collision tests. This is unlike HideEntity, which doesn't involve entities in collisions.

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
bbdoc: Sets the blending mode of an entity
about: 
@Parameters: 

Entity - Entity handle


Blend - Blend mode of the entity.

1: Alpha (default)

2: Multiply

3: Add

@Description: 

Sets the blending mode of an entity. This blending mode determines the way in which the new RGBA of the pixel being rendered is combined with the RGB of the background.

To calculate the new RGBA of the pixel being rendered, the texture RGBA for the pixel (see <a href=#TextureBlend>TextureBlend</a> for more information on how the texture RGBA is calculated) is taken, its alpha component multiplied by the entities/brushes (where applicable) alpha value and its color compentent multiplied by the entities/brushes colour. This is the RGBA which will then be blended into the background pixel, and how this is done depends on the EntityBlend value.

Alpha:
This blends the pixels according to the Alpha value. This is rougly done to the formula:

Rr = ( An * Rn ) + ( ( 1.0 - An ) * Ro )
Gr = ( An * Gn ) + ( ( 1.0 - An ) * Go )
Br = ( An * Bn ) + ( ( 1.0 - An ) * Bo )

Where R = Red, G = Green, B = Blue, n = new pixel colour values, r = resultant colour values, o = old pixel colour values.

Alpha blending is the default blending mode and is used with most world objects.

Multiply:
This blend mode will darken the underlying pixels. If you think of each RGB value as being on a scale from 0% to 100%, where 0 = 0% and 255 = 100%, the multiply blend mode will multiply the red, green and blue values individually together in order to get the new RGB value, roughly according to:

Rr = ( ( Rn / 255.0 ) * ( Ro / 255.0 ) ) * 255.0
Gr = ( ( Gn / 255.0 ) * ( Go / 255.0 ) ) * 255.0
Br = ( ( Bn / 255.0 ) * ( Bo / 255.0 ) ) * 255.0

The alpha value has no effect with multiplicative blending. Blending a RGB value of 255, 255, 255 will make no difference, while an RGB value of 128, 128, 128 will darken the pixels by a factor of 2 and an RGB value of 0, 0, 0 will completely blacken out the resultant pixels. An RGB value of 0, 255, 255 will remove the red component of the underlying pixel while leaving the other color values 
untouched.

Multiply blending is most often used for lightmaps, shadows or anything else that needs to 'darken' the resultant pixels.

Add: 
Additive blending will add the new color values to the old, roughly according to:

Rr = ( Rn * An ) + Ro
Gr = ( Gn * An ) + Go
Br = ( Bn * An ) + Bo

The resultant RGB values are clipped out at 255, meaning that multiple additive effects can quickly cause visible banding from smooth gradients.

Additive blending is extremely useful for effects such as laser shots and fire.

See also: <a href=#TextureBlend>TextureBlend</a>, <a href=#EntityAlpha>EntityAlpha</a>.

End Rem
Function EntityBlend( ent:TEntity,blend:Int )
End Function

Rem
bbdoc: Sets the dimensions of an entity's collision box
about: 
@Parameters: 

entity - entity handle#

x# - x position of entity's collision box

y# - y position of entity's collision box

z# - z position of entity's collision box

width# - width of entity's collision box

height# - height of entity's collision box

depth# - depth of entity's collision box

@Description: 

Sets the dimensions of an entity's collision box.

See also: <a href=#EntityRadius>EntityRadius</a>, <a href=#Collisions>Collisions</a>, <a href=#EntityType>EntityType</a>.

End Rem
Function EntityBox( ent:TEntity,x:Float,y:Float,z:Float,w:Float,h:Float,d:Float )
End Function

Rem
bbdoc: Returns a string containing the class of the specified entity
about: 
@Parameters: 

entity - a valid entity handle

@Description: 

Returns a string containing the class of the specified entity.

Possible return values are:

Pivot
Light
Camera
Mirror
Listener
Sprite
Terrain
Plane
Mesh
MD2
BSP

Note that the command will fail if a valid entity handle is not supplied, and will not just return an empty string.

End Rem
Function EntityClass:String( ent:TEntity )
End Function

Rem
bbdoc: Returns the handle of the entity of the specified type that collided with  the specified entity
about: 
@Parameters: 

entity - entity handle

type - type of entity

@Description: 

Returns the handle of the entity of the specified type that collided with  the specified entity.

See also: <a href=#CollisionX>CollisionX</a>, <a href=#CollisionY>CollisionY</a>, <a href=#CollisionZ>CollisionZ</a>, <a href=#CollisionNX>CollisionNX</a>, <a href=#CollisionNY>CollisionNY</a>, <a href=#CollisionNZ>CollisionNZ</a>, <a href=#CountCollisions>CountCollisions</a>, <a href=#EntityCollided>EntityCollided</a>, <a href=#CollisionTime>CollisionTime</a>, <a href=#CollisionEntity>CollisionEntity</a>, <a href=#CollisionSurface>CollisionSurface</a>, <a href=#CollisionTriangle>CollisionTriangle</a>.

End Rem
Function EntityCollided:TEntity( ent:TEntity,type_no:Int )
End Function

Rem
bbdoc: Sets the color of an entity
about: 
@Parameters: 

entity - entity handle

Red# - red value of entity

Green# - green value of entity

Blue# - blue value of entity

@Description: 

Sets the color of an entity.

The Red, Green and Blue values should be in the range 0-255 with 0 being darkest and 255 brightest. The default entity color is 255,255,255 (White).

End Rem
Function EntityColor( ent:TEntity,red:Float,green:Float,blue:Float,recursive:Int )
End Function

Rem
bbdoc: Returns the distance between src_entity and dest_entity
about: 
@Parameters: 

src_entity - source entity handle

dest_entity - destination entity handle

@Description: 

Returns the distance between src_entity and dest_entity.

End Rem
Function EntityDistance:Float( ent1:TEntity,ent2:TEntity )
End Function

Rem
bbdoc: Sets miscellaneous effects for an entity
about: 
@Parameters: 

entity - entity handle


fx -

0: nothing (default)

1: full-bright

2: use vertex colors instead of brush color

4: flatshaded

8: disable fog

16: disable backface culling

32: force alpha-blending

@Description: 

Sets miscellaneous effects for an entity.

Flags can be added to combine  two or more effects. For example, specifying a flag of 3 (1+2) will result in  a full-bright and vertex-coloured brush.

Flag 32, to force alpha-blending, must be used in order to enable vertex alpha (see VertexColor).

See also: <a href=#VertexColor>VertexColor</a>.

End Rem
Function EntityFX( ent:TEntity,fx:Int )
End Function

Rem
bbdoc: Returns true if the specified entity is visible to the specified camera
about: 
@Parameters: 

entity - entity handle

camera - camera handle

@Description: 

Returns true if the specified entity is visible to the specified camera.

If the entity is a mesh, its bounding box will be checked for visibility. 

For all other types of entities, only their centre position will be checked. 

End Rem
Function EntityInView:Int( ent:TEntity,cam:TCamera )
End Function

Rem
bbdoc: Returns the name of an entity
about: 
@Parameters: 

entity - entity handle

@Description: 

Returns the name of an entity. An entity's name may be set in a modelling  program, or manually set using NameEntity.

See also: <a href=#NameEntity>NameEntity</a>.

End Rem
Function EntityName:String( ent:TEntity )
End Function

Rem
bbdoc: Sets the drawing order for an entity
about: 
@Parameters: 

entity - entity handle

order - order that entity will be drawn in

@Description: 

Sets the drawing order for an entity.

An order value of 0 will mean the  entity is drawn normally. A value greater than 0 will mean that entity is drawn  first, behind everything else. A value less than 0 will mean the entity is drawn  last, in front of everything else. 

Setting an entity's order to non-0 also disables z-buffering for the entity,  so should be only used for simple, convex entities like skyboxes, sprites etc. 

EntityOrder affects the specified entity but none of its child entities,  if any exist. 

End Rem
Function EntityOrder( ent:TEntity,order:Int )
End Function

Rem
bbdoc: Attaches an entity to a parent
about: 
@Parameters: 

entity - entity handle

parent - parent entity handle

global (optional) - true for the child entity to retain its global position  and orientation. Defaults to true.

@Description: 

Attaches an entity to a parent.

Parent may be 0, in which case the entity  will have no parent. 

End Rem
Function EntityParent( ent:TEntity,parent_ent:TEntity,glob:Int=True )
End Function

Rem
bbdoc: Returns the nearest entity 'ahead' of the specified entity
about: 
@Parameters: 

entity - entity handle

range# - range of pick area around entity

@Description: 

Returns the nearest entity 'ahead' of the specified entity. An entity must  have a non-zero EntityPickMode to be pickable.

See also: <a href=#EntityPick>EntityPick</a>, <a href=#LinePick>LinePick</a>, <a href=#CameraPick>CameraPick</a>, <a href=#EntityPickMode>EntityPickMode</a>.

End Rem
Function EntityPick:TEntity( ent:TEntity,Range:Float )
End Function

Rem
bbdoc: Sets the pick mode for an entity
about: 
@Parameters: 

entity - entity handle


pick_geometry - type of geometry used for picking:

0: Unpickable (default)

1: Sphere (EntityRadius is used)

2: Polygon

3: Box (EntityBox is used)


obscurer (optional) - True to determine that the entity 'obscures' other entities  during an EntityVisible call. Defaults to True.

@Description: 

Sets the pick mode for an entity.

The optional obscurer parameter is used  with EntityVisible to determine just what can  get in the way of the line-of-sight between 2 entities. This allows some entities  to be pickable using the other pick commands, but to be ignored (i.e. 'transparent')  when using EntityVisible. So, its very much EntityVisible specific.

Please note that only Sphere and Box picking will work with Blitz3D sprites. For polygon picking, you will need a valid mesh.

See also: <a href=#EntityPick>EntityPick</a>, <a href=#LinePick>LinePick</a>, <a href=#CameraPick>CameraPick</a>, <a href=#EntityPickMode>EntityPickMode</a>.

End Rem
Function EntityPickMode( ent:TEntity,pick_mode:Int,obscurer:Int=True )
End Function

Rem
bbdoc: Returns the pitch angle of an entity
about: 
@Parameters: 

entity - name of entity that will have pitch angle returned

global (optional) - true if the pitch angle returned should be relative to 0 rather than a parent entity's pitch angle. False by default.

@Description: 

Returns the pitch angle of an entity.

The pitch angle is also the x angle of an entity.

End Rem
Function EntityPitch:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: Sets the radius of an entity's collision ellipsoid
about: 
@Parameters: 

entity - entity handle

x_radius# - x radius of entity's collision ellipsoid

y_radius# (optional) - y radius of entity's collision ellipsoid. If omitted the x_radius# will be used for the y_radius#.

@Description: 

Sets the radius of an entity's collision ellipsoid.

An entity radius should be set for all entities involved in ellipsoidal collisions, which is all source entities (as collisions are always ellipsoid-to-something), and  whatever destination entities are involved in ellipsoid-to-ellipsoid collisions (collision method No.1).

See also: <a href=#EntityBox>EntityBox</a>, <a href=#Collisions>Collisions</a>, <a href=#EntityType>EntityType</a>.

End Rem
Function EntityRadius( ent:TEntity,radius_x:Float,radius_y:Float=0 )
End Function

Rem
bbdoc: Returns the roll angle of an entity
about: 
@Parameters: 

entity - name of entity that will have roll angle returned

global (optional) - true if the roll angle returned should be relative to 0 rather than a parent entity's  roll angle. False by default.

@Description: 

Returns the roll angle of an entity.

The roll angle is also the z angle of an entity.

End Rem
Function EntityRoll:Float( ent:TEntity,glob:Int=True )
End Function

Rem
bbdoc: Sets the specular shininess of an entity
about: 
@Parameters: 

Entity - entity handle

Shininess# - shininess of entity

@Description: 

Sets the specular shininess of an entity.

The shininess# value should be a floting point number in the range 0-1. The default shininess setting is 0. 

Shininess is how much brighter certain areas of an object will appear to be when a light is shone directly at them. 

Setting a shininess value of 1 for a medium to high poly sphere, combined  with the creation of a light shining in the direction of it, will give it the  appearance of a shiny snooker ball.

End Rem
Function EntityShininess( ent:TEntity,shine:Float )
End Function

Rem
bbdoc: Applies a texture to an entity
about: 
@Parameters: 

entity - entity handle

texture - texture handle

frame (optional) - frame of texture. Defaults to 0.

index (optional) - index number of texture. Should be in the range to 0-7. Defaults  to 0.

@Description: 

Applies a texture to an entity.

The optional frame parameter specifies  which texture animation frame should be used as the texture. 

The optional index parameter specifies which index number should be assigned  to the texture. Index numbers are used for the purpose of multitexturing. See TextureBlend. 

A little note about multitexturing and slowdown. Graphics cards support a  maximum amount of textures per object, which can be used with very little, if  any, slowdown. For most cards this is two, but for a GeForce3 it is four. However,  once you use more than this amount, Blitz will emulate the effect itself by  duplicating objects and textures. Obviously, this may then cause slowdown. 

End Rem
Function EntityTexture( ent:TEntity,tex:TTexture,frame:Int=0,index:Int=0 )
End Function

Rem
bbdoc: Sets the collision type for an entity
about: 
@Parameters: 

entity - entity handle

collision_type - collision type of entity. Must be in the range 0-999.

recursive (optional) - true to apply collision type to entity's children. Defaults  to false.

@Description: 

Sets the collision type for an entity.

A collision_type value of 0 indicates that no collision checking will occur with that entity. A collision value of 1-999 will mean collision checking will occur.

See also: <a href=#Collisions>Collisions</a>, <a href=#GetEntityType>GetEntityType</a>, <a href=#EntityBox>EntityBox</a>, <a href=#EntityRadius>EntityRadius</a>.

End Rem
Function EntityType( ent:TEntity,type_no:Int,recursive:Int=False )
End Function

Rem
bbdoc: Returns true if src_entity and dest_entity can 'see' each other
about: 
@Parameters: 

src_entity - source entity handle

dest_entity - destination entity handle

@Description: 

Returns true if src_entity and dest_entity can 'see' each other.

End Rem
Function EntityVisible:Int( src_ent:TEntity,dest_ent:TEntity )
End Function

Rem
bbdoc: The X-coordinate of the entity
about: 
@Parameters: 

entity = handle of Loaded or Created Entity

global = True for Global coordinates,  False for Local. Optional, defaults to False.

@Description: 

The X-coordinate of the entity.
If the global flag is set to False then the parent's local coordinate system is used.

NOTE: If the entity has no parent then local and global coordinates are the same.
In this case you can think of the 3d world as the parent.

Global coordinates refer to the 3d world. Blitz 3D uses a left-handed system:

X+ is to the right
Y+ is up
Z+ is forward ( into the screen )

Every entity also has its own Local coordinate system.

The global system never changes. 
But the local system is carried along as an entity moves and turns.

This same concept is used in the entity movement commands:

MoveEntity entity, 0,0,1

No matter what the orientation this moves one unit forward.

End Rem
Function EntityX:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: The Y-coordinate of the entity
about: 
@Parameters: 

entity = handle of Loaded or Created Entity

global = True for Global coordinates,  False for Local. Optional, defaults to False.

@Description: 

The Y-coordinate of the entity.
If the global flag is set to False then the parent's local coordinate system is used.

See EntityX() for an overview of Local and Global coordinates.

End Rem
Function EntityY:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: Returns the yaw angle of an entity
about: 
@Parameters: 

entity - name of entity that will have yaw angle returned

global (optional) - true if the yaw angle returned should be relative to 0 rather than a parent entity's  yaw angle. False by default.

@Description: 

Returns the yaw angle of an entity.

The yaw angle is also the y angle of an entity.

End Rem
Function EntityYaw:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: The Z-coordinate of the entity
about: 
@Parameters: 

entity = handle of Loaded or Created Entity

global = True for Global coordinates,  False for Local. Optional, defaults to False.

@Description: 

The Z-coordinate of the entity.
If the global flag is set to False then the parent's local coordinate system is used.

See EntityX() for an overview of Local and Global coordinates.

End Rem
Function EntityZ:Float( ent:TEntity,glob:Int=False )
End Function

Rem
bbdoc: This command allows you to convert an animation with an MD2-style series  of anim sequences into a pure Blitz anim sequence
about: 
@Parameters: 

entity - entity handle

first_frame - first frame of anim sequence to extract

last_frame - last frame of anim sequence to extract

anim_seq (optional) - anim sequence to extract from. This is usually 0, and  as such defaults to 0.

@Description: 

This command allows you to convert an animation with an MD2-style series  of anim sequences into a pure Blitz anim sequence, and play it back as such  using Animate.

End Rem
Function ExtractAnimSeq:Int( ent:TEntity,first_frame:Int,last_frame:Int,seq:Int=0 )
End Function

Rem
bbdoc: Returns the first child of the specified entity with name matching child_name$
about: 
@Parameters: 

entity - entity handle

child_name$ - child name to find within entity

@Description: 

Returns the first child of the specified entity with name matching child_name$.

End Rem
Function FindChild:TEntity( ent:TEntity,child_name:String )
End Function

Rem
bbdoc: Attempts to find a surface attached to the specified mesh and created with  the specified brush
about: 
@Parameters: 

mesh - mesh handle

brush - brush handle

@Description: 

Attempts to find a surface attached to the specified mesh and created with  the specified brush. Returns the surface handle if found or 0 if not.

See  also: CountSurfaces, GetSurface. 

End Rem
Function FindSurface:TSurface( mesh:TMesh,brush:TBrush )
End Function

Rem
bbdoc: Scales and translates all vertices of a mesh so that the mesh occupies the specified box
about: 
@Parameters: 

mesh - mesh handle

x# - x position of mesh

y# - y position of mesh

z# - z position of mesh

width# - width of mesh 

height# - height of mesh

depth# - depth of mesh

uniform (optional) - if true, the mesh will be scaled by the same amounts in x, y and z, so will not be distorted. Defaults to false.

@Description: 

Scales and translates all vertices of a mesh so that the mesh occupies the specified box.

Do not use a width#, height# or depth# value of 0, otherwise all mesh data will be destroyed and your mesh will not be displayed. Use a value of 0.001 instead for a flat mesh along one axis.

See also: <a href=#ScaleMesh>ScaleMesh</a>, <a href=#ScaleEntity>ScaleEntity</a>.

End Rem
Function FitMesh( mesh:TMesh,x:Float,y:Float,z:Float,width:Float,height:Float,depth:Float,uniform:Int=False )
End Function

Rem
bbdoc: Flips all the triangles in a mesh
about: 
@Parameters: 

mesh - mesh handle

@Description: 

Flips all the triangles in a mesh.

This is useful for a couple of reasons.  Firstly though, it is important to understand a little bit of the theory behind  3D graphics. A 3D triangle is represented by three points; only when these points  are presented to the viewer in a clockwise-fashion is the triangle visible.  So really, triangles only have one side. 

Normally, for example in the case of a sphere, a model's triangles face the  inside of the model, so it doesn't matter that you can't see them. However,  what about if you wanted to use the sphere as a huge sky for your world, i.e.  so you only needed to see the inside? In this case you would just use FlipMesh.

Another use for FlipMesh is to make objects two-sided, so you can see them from  the inside and outside if you can't already. In this case, you can copy the  original mesh using CopyEntity, specifying the  original mesh as the parent, and flip it using FlipMesh. You will now have two  meshes occupying the same space - this will make it double-sided, but beware,  it will also double the polygon count! 

The above technique is worth trying when an external modelling program has  exported a model in such a way that some of the triangles appear to be missing.

End Rem
Function FlipMesh( mesh:TMesh )
End Function

Rem
bbdoc: Frees up a brush
about: 
@Parameters: 

brush - brush handle

@Description: 

Frees up a brush.

End Rem
Function FreeBrush( brush:TBrush )
End Function

Rem
bbdoc: FreeEntity will free up the internal resources associated  with a particular entity and remove it from the scene
about: 
@Parameters: 

EntityHandle - Handle returned by an Entity creating function such as CreateCube(), CreateLight(), LoadMesh() etc.

@Description: 

FreeEntity will free up the internal resources associated  with a particular entity and remove it from the scene.

This command will also free all children entities parented to the entity.

Note that the variable holding the handle (and any variables referencing children handles) are not reset as it is up to the Blitz programmer to zero or ignore their contents following a call to FreeEntity().

End Rem
Function FreeEntity( ent:TEntity )
End Function

Rem
bbdoc: Frees up a texture from memory
about: 
@Parameters: 

texture - texture handle

@Description: 

Frees up a texture from memory.

Freeing a texture means you will not be  able to use it again; however, entities already textured with it will not lose  the texture.

End Rem
Function FreeTexture( tex:TTexture )
End Function

Rem
bbdoc: Returns the texture that is applied to the specified brush
about: 
@Parameters: 

brush - brush handle

index (optional) - index of texture applied to brush, from 0-7. Defaults to 0.

@Description: 

Returns the texture that is applied to the specified brush.

The optional index parameter allows you to specify which particular texture you'd like returning, if there are more than one textures applied to a brush.

You should release the texture returned by GetBrushTexture after use to prevent leaks! Use <a href=#FreeTexture>FreeTexture</a> to do this.

To find out the name of the texture, use <a href=#TextureName>TextureName</a>

See also: <a href=#TextureName>TextureName</a>, <a href=#FreeTexture>FreeTexture</a>, <a href=#GetEntityBrush>GetEntityBrush</a>, <a href=#GetSurfaceBrush>GetSurfaceBrush</a>.

End Rem
Function GetBrushTexture:TTexture( brush:TBrush,index:Int=0 )
End Function

Rem
bbdoc: Returns a child of an entity
about: 
@Parameters: 

entity - entity handle

index - index of child entity. Should be in the range 1...CountChildren(  entity ) inclusive.

@Description: 

Returns a child of an entity.

End Rem
Function GetChild:TEntity( ent:TEntity,child_no:Int )
End Function

Rem
bbdoc: Returns a brush with the same properties as is applied to the specified entity
about: 
@Parameters: 

entity - entity handle

@Description: 

Returns a brush with the same properties as is applied to the specified entity.

If this command does not appear to be returning a valid brush, try using <a href=#GetSurfaceBrush>GetSurfaceBrush</a> instead with the first surface available.

Remember, GetEntityBrush actually creates a new brush so don't forget to free it afterwards using FreeBrush to prevent memory leaks.

Once you have got the brush handle from an entity, you can use GetBrushTexture and TextureName to get the details of what texture(s) are applied to the brush.

See also: <a href=#GetSurfaceBrush>GetSurfaceBrush</a>, <a href=#FreeBrush>FreeBrush</a>, <a href=#GetBrushTexture>GetBrushTexture</a>, <a href=#TextureName>TextureName</a>.

End Rem
Function GetEntityBrush:TBrush( ent:TEntity )
End Function

Rem
bbdoc: Returns the collision type of an entity as set by the EntityType command
about: 
@Parameters: 

entity - entity handle

@Description: 

Returns the collision type of an entity as set by the EntityType command.

See also: <a href=#EntityType>EntityType</a>, <a href=#EntityBox>EntityBox</a>, <a href=#EntityRadius>EntityRadius</a>, <a href=#Collisions>Collisions</a>, <a href=#ResetEntity>ResetEntity</a>.

End Rem
Function GetEntityType:Int( ent:TEntity )
End Function

Rem
bbdoc: Returns the value of an element from within an entity's transformation matrix
about: 
@Parameters: 

entity - entity handle

row - matrix row index

column - matrix column index

@Description: 

Returns the value of an element from within an entity's transformation matrix.

The transformation matrix is what is used by Blitz internally to position, scale and rotate entities.

GetMatElement is intended for use by advanced users only.

End Rem
Function GetMatElement:Float( ent:TEntity,row:Int,col:Int )
End Function

Rem
bbdoc: Returns an entity's parent
about: 
@Parameters: 

entity - entity handle

@Description: 

Returns an entity's parent.

End Rem
Function GetParent:TEntity( ent:TEntity )
End Function

Rem
bbdoc: Returns the handle of the surface attached to the specified mesh and with  the specified index number
about: 
@Parameters: 

mesh - mesh handle

index - index of surface

@Description: 

Returns the handle of the surface attached to the specified mesh and with  the specified index number.

Index should be in the range 1...CountSurfaces(  mesh ), inclusive. 

You need to 'get a surface', i.e. get its handle, in order to be able to  then use that particular surface with other commands.

See also: <a href=#CountSurfaces>CountSurfaces</a>, <a href=#FindSurface>FindSurface</a>.

End Rem
Function GetSurface:TSurface( mesh:TMesh,surf_no:Int )
End Function

Rem
bbdoc: Returns a brush with the same properties as is applied to the specified mesh surface
about: 
@Parameters: 

surface - surface handle

@Description: 

Returns a brush with the same properties as is applied to the specified mesh surface.

If this command does not appear to be returning a valid brush, try using <a href=#GetEntityBrush>GetEntityBrush</a> instead.

Remember, GetSurfaceBrush actually creates a new brush so don't forget to free it afterwards using <a href=#FreeBrush>FreeBrush</a> to prevent memory leaks.

Once you have got the brush handle from a surface, you can use <a href=#GetBrushTexture>GetBrushTexture</a> and <a href=#TextureName>TextureName</a> to get the details of what texture(s) are applied to the brush.

See also: <a href=#GetEntityBrush>GetEntityBrush</a>, <a href=#FreeBrush>FreeBrush</a>, <a href=#GetSurface>GetSurface</a>, <a href=#GetBrushTexture>GetBrushTexture</a>, <a href=#TextureName>TextureName</a>.

End Rem
Function GetSurfaceBrush:TBrush( surf:TSurface )
End Function

' Graphics3D is in B3dglgraphics.mod

Rem
bbdoc: Sets a sprite handle
about: 
@Parameters: 

sprite - sprite handle. Not to be confused with HandleSprite - ie. the handle  used to position the sprite, rather than the sprite's actual handle

@Description: 

Sets a sprite handle. Defaults to 0,0.

A sprite extends from -1,-1 to +1,+1.

See also: <a href=#LoadSprite>LoadSprite</a>, <a href=#CreateSprite>CreateSprite</a>.

End Rem
Function HandleSprite( sprite:TSprite,h_x:Float,h_y:Float )
End Function

Rem
bbdoc: Hides an entity
about: 
@Parameters: 

entity - entity handle

@Description: 

Hides an entity, so that it is no longer visible, and is no longer involved  in collisions.

The main purpose of hide entity is to allow you to create entities  at the beginning of a program, hide them, then copy them and show as necessary  in the main game. This is more efficient than creating entities mid-game. 

If you wish to hide an entity so that it is no longer visible but still involved  in collisions, then use EntityAlpha 0 instead.  This will make an entity completely transparent. 

HideEntity affects the specified entity and all of its child entities, if  any exist. 

End Rem
Function HideEntity( ent:TEntity )
End Function

Rem
bbdoc: Sets the color of a light
about: 
@Parameters: 

light - light handle

red# - red value of light

green# - green value of light

blue# - blue value of light

@Description: 

Sets the color of a light.

An r,g,b value of 255,255,255 will brighten  anything the light shines on.

An r,g,b value of 0,0,0 will have no affect on anything it shines on.

An r,g,b value of -255,-255,-255 will darken anything it shines on. This is  known as 'negative lighting', and is useful for shadow effects.

See also: <a href=#CreateLight>CreateLight</a>, <a href=#LightRange>LightRange</a>, <a href=#LightConeAngles>LightConeAngles</a>.

End Rem
Function LightColor( light:TLight,red:Float,green:Float,blue:Float )
End Function

Rem
bbdoc: Sets the 'cone' angle for a 'spot' light
about: 
@Parameters: 

light - light handle

inner_angle# - inner angle of cone

outer_angle# - outer angle of cone

@Description: 

Sets the 'cone' angle for a 'spot' light.

The default light cone angles setting  is 0,90.

See also: <a href=#CreateLight>CreateLight</a>, <a href=#LightRange>LightRange</a>, <a href=#LightColor>LightColor</a>.

End Rem
Function LightConeAngles( light:TLight,inner_ang:Float,outer_ang:Float )
End Function

Rem
bbdoc: Sets the range of a light
about: 
@Parameters: 

light - light handle

range# - range of light (default: 1000.0)

@Description: 

Sets the range of a light.

The range of a light is how far it reaches.  Everything outside the range of the light will not be affected by it.

The value is very approximate, and should be experimented with for best results.

See also: <a href=#CreateLight>CreateLight</a>, <a href=#LightColor>LightColor</a>, <a href=#LightConeAngles>LightConeAngles</a>.

End Rem
Function LightRange( light:TLight,Range:Float )
End Function

Rem
bbdoc: Returns the first entity between x
about: 
@Parameters: 

x# - x coordinate of start of line pick

y# - y coordinate of start of line pick

z# - z coordinate of start of line pick

dx# - distance x of line pick

dy# - distance y of line pick

dz# - distance z of line pick

radius (optional) - radius of line pick

@Description: 

Returns the first entity between x,y,z to x+dx,y+dy,z+dz.

See also: <a href=#EntityPick>EntityPick</a>, <a href=#LinePick>LinePick</a>, <a href=#CameraPick>CameraPick</a>, <a href=#EntityPickMode>EntityPickMode</a>.

End Rem
Function LinePick:TEntity( x:Float,y:Float,z:Float,dx:Float,dy:Float,dz:Float,radius:Float=0 )
End Function

Rem
bbdoc: LoadAnimMesh
about: 
@Parameters: 

Filename$ - Name of the file containing the model to load. 

Parent (optional) - Specify an entity to act as a Parent to the loaded mesh.

@Description: 

LoadAnimMesh, similar to LoadMesh, Loads a mesh from an .X, .3DS or .B3D file and returns a mesh handle.

The difference between LoadMesh and LoadAnimMesh is that any hierarchy and animation information present in the file is retained. You can then either activate the animation by using the Animate command or find child entities within the hierarchy by using the FindChild(), GetChild() functions.

The optional parent parameter allows you to specify a parent entity for the mesh so that when the parent is moved the child mesh will move with it. However, this relationship is one way;  applying movement commands to the child will not affect the parent. 

Specifying a parent entity will still result in the mesh being created at position 0,0,0 rather than at the parent entity's position.

End Rem
Function LoadAnimMesh:TMesh( file:String,parent:TEntity=Null )
End Function

Rem
bbdoc: Loads an animated texture from an image file and returns the texture's handle
about: 
@Parameters: 

file$ - name of image file with animation frames laid out in left-right,  top-to-bottom order


flags (optional) - texture flag:

1: Color (default)

2: Alpha

4: Masked

8: Mipmapped

16: Clamp U

32: Clamp V

64: Spherical reflection map

128: Cubic environment map

256: Store texture in vram

512: Force the use of high color textures


frame_width - width of each animation frame

frame_height - height of each animation frame

first_frame - the first frame to be used as an animation frame

frame_count - the amount of frames to be used

@Description: 

Loads an animated texture from an image file and returns the texture's handle.

The flags parameter allows you to apply certain effects to the texture. Flags  can be added to combine two or more effects, e.g. 3 (1+2) = texture with colour  and alpha maps. 

See <a href=#CreateTexture>CreateTexture</a> for more detailed descriptions of the texture flags. 

The frame_width, frame_height, first_frame and frame_count parameters determine how Blitz will separate the image file into individual animation frames.

See also: <a href=#CreateTexture>CreateTexture</a>, <a href=#LoadTexture>LoadTexture</a>.

End Rem
Function LoadAnimTexture:TTexture( file:String,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int,tex:TTexture=Null )
End Function

Rem
bbdoc: Creates a brush
about: 
@Parameters: 

texture_file$ - filename of texture

flags - brush flags


flags (optional) - flags can be added to combine effects:

1: Color

2: Alpha

4: Masked

8: Mipmapped

16: Clamp U

32: Clamp V

64: Spherical reflection map


u_scale - brush u_scale

v_scale - brush v_scale

@Description: 

Creates a brush, loads and assigns a texture to it, and returns a brush handle.

End Rem
Function LoadBrush:TBrush( file:String,flags:Int=9,u_scale:Float=1,v_scale:Float=1 )
End Function

Rem
bbdoc: LoadMesh
about: 
@Parameters: 

Filename$ - Name of the file containing the model to load.

Parent (optional) - Specify an entity to act as a Parent to the loaded mesh.

@Description: 

LoadMesh, as the name suggests, Loads a mesh from an .X, .3DS or .B3D file (Usually created in advance by one of a number of 3D model creation packages) and returns the mesh handle.

Any hierarchy and animation information in the file will be ignored. Use LoadAnimMesh to maintain hierarchy and  animation information.

The optional parent parameter allows you to specify a parent entity for the mesh so that when the parent is moved the child mesh will move with it. However, this relationship is one way;  applying movement commands to the child will not affect the parent. 

Specifying a parent entity will still result in the mesh being created at position 0,0,0 rather than at the parent entity's position. 

See also: <a href=#LoadAnimMesh>LoadAnimMesh</a>.

End Rem
Function LoadMesh:TMesh( file:String,parent:TEntity=Null )
End Function

Rem
bbdoc: Load a texture from an image file and returns the texture's handle
about: 
@Parameters: 

file$ - filename of image file to be used as texture



flags (optional) - texture flag:

1: Color (default)

2: Alpha

4: Masked

8: Mipmapped

16: Clamp U

32: Clamp V

64: Spherical environment map

128: Cubic environment map

256: Store texture in vram

512: Force the use of high color textures

@Description: 

Load a texture from an image file and returns the texture's handle.  Supported file formats include: BMP, PNG, TGA and JPG.  Only PNG and TGA support alpha.


The optional flags parameter allows you to apply certain effects to the texture. Flags can be added to combine two or more effects, e.g. 3 (1+2) = texture with colour and alpha maps.


See <a href=#CreateTexture>CreateTexture</a> for more detailed descriptions of the texture flags.


Something to consider when applying texture flags to loaded textures is that the texture may have already had certain flags applied to it via the <a href=#TextureFilter>TextureFilter</a> command. The default for the <a href=#TextureFilter>TextureFilter</a> command is 9 (1+8), which is a coloured, mipmapped texture. This cannot be overridden via the flags parameter of the LoadTexture command - if you wish for the filters to be removed you will need to use the <a href=#ClearTextureFilters>ClearTextureFilters</a> command, which must be done after setting the graphics mode (setting the graphics mode restores the default texture filters).

See also: <a href=#CreateTexture>CreateTexture</a>, <a href=#LoadAnimTexture>LoadAnimTexture</a>.

End Rem
Function LoadTexture:TTexture( file:String,flags:Int=9,tex:TTexture=Null )
End Function

Rem
bbdoc: Creates a sprite entity
about: 
@Parameters: 

text_file$ - filename of image file to be used as sprite


tex_flag (optional) - texture flag:

1: Color

2: Alpha

4: Masked

8: Mipmapped

16: Clamp U

32: Clamp V

64: Spherical reflection map


parent - parent of entity

@Description: 

Creates a sprite entity, and assigns a texture to it.

See also: <a href=#LoadSprite>LoadSprite</a>, <a href=#RotateSprite>RotateSprite</a>, <a href=#ScaleSprite>ScaleSprite</a>, <a href=#HandleSprite>HandleSprite</a>, <a href=#SpriteViewMode>SpriteViewMode</a>, <a href=#PositionEntity>PositionEntity</a>, <a href=#MoveEntity>MoveEntity</a>, <a href=#TranslateEntity>TranslateEntity</a>, <a href=#EntityAlpha>EntityAlpha</a>, <a href=#FreeEntity>FreeEntity</a>.

End Rem
Function LoadSprite:TSprite( tex_file:String,tex_flag:Int=1,parent:TEntity=Null )
End Function

Rem
bbdoc: Returns the depth of a mesh
about: 
@Parameters: 

mesh - mesh handle

@Description: 

Returns the depth of a mesh. This is calculated by the actual vertex positions and so the scale of the entity (set by ScaleEntity) will not have an effect on the resultant depth. Mesh operations, on the other hand, will effect the result.

See also: <a href=#MeshWidth>MeshWidth</a>, <a href=#MeshHeight>MeshHeight</a>.

End Rem
Function MeshDepth:Float( mesh:TMesh )
End Function

Rem
bbdoc: Returns the height of a mesh
about: 
@Parameters: 

mesh - mesh handle

@Description: 

Returns the height of a mesh. This is calculated by the actual vertex positions and so the scale of the entity (set by ScaleEntity) will not have an effect on the resultant height. Mesh operations, on the other hand, will effect the result.

See also: <a href=#MeshWidth>MeshWidth</a>, <a href=#MeshDepth>MeshDepth</a>.

End Rem
Function MeshHeight:Float( mesh:TMesh )
End Function

Rem
bbdoc: Returns the width of a mesh
about: 
@Parameters: 

mesh - mesh handle

@Description: 

Returns the width of a mesh. This is calculated by the actual vertex positions and so the scale of the entity (set by ScaleEntity) will not have an effect on the resultant width. Mesh operations, on the other hand, will effect the result.

See also: <a href=#MeshHeight>MeshHeight</a>, <a href=#MeshDepth>MeshDepth</a>.

End Rem
Function MeshWidth:Float( mesh:TMesh )
End Function

Rem
bbdoc: Moves an entity relative to its current position and orientation
about: 
@Parameters: 

entity - name of entity to be moved

x# - x amount that entity will be moved by

y# - y amount that entity will be moved by

z# - z amount that entity will be moved by

@Description: 

Moves an entity relative to its current position and orientation.

What this means is that an entity will move in whatever direction it is facing. So for example if you have an game character is upright when first loaded into Blitz3D and it remains upright (i.e. turns left or right only), then moving it by a z amount will always see it move forward or backward, moving it by a y amount will always see it move up or down, and moving it by an x amount will always see it strafe.

See also: <a href=#TranslateEntity>TranslateEntity</a>, <a href=#PositionEntity>PositionEntity</a>, <a href=#PositionMesh>PositionMesh</a>.

End Rem
Function MoveEntity( ent:TEntity,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: Sets an entity's name
about: 
@Parameters: 

entity - entity handle

name$ - name of entity

@Description: 

Sets an entity's name.

See also: <a href=#EntityName>EntityName</a>.

End Rem
Function NameEntity( ent:TEntity,name:String )
End Function

Rem
bbdoc: Paints a entity with a brush
about: 
@Parameters: 

entity - entity handle

brush - brush handle

@Description: 

Paints a entity with a brush.

The reason for using PaintEntity to apply  specific properties to a entity using a brush rather than just using EntityTexture,  EntityColor, EntityShininess etc, is that you can pre-define one brush, and  then paint entities over and over again using just the one command rather than  lots of separate ones. 

End Rem
Function PaintEntity( ent:TEntity,brush:TBrush )
End Function

Rem
bbdoc: Paints a mesh with a brush
about: 
@Parameters: 

mesh - mesh handle

brush - brush handle

@Description: 

Paints a mesh with a brush.

This has the effect of instantly altering  the visible appearance of the mesh, assuming the brush's properties are different  to what was was applied to the surface before. 

The reason for using PaintMesh to apply specific properties to a mesh using  a brush rather than just using EntityTexture, EntityColor, EntityShininess etc,  is that you can pre-define one brush, and then paint meshes over and over again  using just the one command rather than lots of separate ones. 

See also: <a href=#PaintEntity>PaintEntity</a>, <a href=#PaintSurface>PaintSurface</a>.

End Rem
Function PaintMesh( mesh:TMesh,brush:TBrush )
End Function

Rem
bbdoc: Paints a surface with a brush
about: 
@Parameters: 

surface - surface handle

brush - brush handle

@Description: 

Paints a surface with a brush.

This has the effect of instantly altering  the visible appearance of that particular surface, i.e. section of mesh, assuming  the brush's properties are different to what was applied to the surface before. 

See also: <a href=#PaintEntity>PaintEntity</a>, <a href=#PaintMesh>PaintMesh</a>.

End Rem
Function PaintSurface( surf:TSurface,brush:TBrush )
End Function

Rem
bbdoc: Returns the entity 'picked' by the most recently executed Pick command
about: 
@Parameters: 

None.

@Description: 

Returns the entity 'picked' by the most recently executed Pick command.  This might have been CameraPick, EntityPick or LinePick.

Returns 0 if no entity was picked.

End Rem
Function PickedEntity:TEntity()
End Function

Rem
bbdoc: Returns the x component of the normal of the most recently executed Pick  command
about: 
@Parameters: 

None.

@Description: 

Returns the x component of the normal of the most recently executed Pick  command. This might have been CameraPick, EntityPick or LinePick.

End Rem
Function PickedNX:Float()
End Function

Rem
bbdoc: Returns the y component of the normal of the most recently executed Pick  command
about: 
@Parameters: 

None.

@Description: 

Returns the y component of the normal of the most recently executed Pick  command. This might have been CameraPick, EntityPick or LinePick.

End Rem
Function PickedNY:Float()
End Function

Rem
bbdoc: Returns the z component of the normal of the most recently executed Pick  command
about: 
@Parameters: 

None.

@Description: 

Returns the z component of the normal of the most recently executed Pick  command. This might have been CameraPick, EntityPick or LinePick.

End Rem
Function PickedNZ:Float()
End Function

Rem
bbdoc: Returns the handle of the surface that was 'picked' by the most recently  executed Pick command
about: 
@Parameters: 

None.

@Description: 

Returns the handle of the surface that was 'picked' by the most recently  executed Pick command. This might have been CameraPick, EntityPick or LinePick.

End Rem
Function PickedSurface:TSurface()
End Function

Rem
bbdoc: Returns the time taken to calculate the most recently executed Pick command
about: 
@Parameters: 

None.

@Description: 

Returns the time taken to calculate the most recently executed Pick command.  This might have been CameraPick, EntityPick or LinePick.

End Rem
Function PickedTime:Float()
End Function

Rem
bbdoc: Returns the index number of the triangle that was 'picked' by the most recently  executed Pick command
about: 
@Parameters: 

None.

@Description: 

Returns the index number of the triangle that was 'picked' by the most recently  executed Pick command. This might have been CameraPick, EntityPick or LinePick.

End Rem
Function PickedTriangle:Int()
End Function

Rem
bbdoc: Returns the world x coordinate of the most recently executed Pick command
about: 
@Parameters: 

None.

@Description: 

Returns the world x coordinate of the most recently executed Pick command.  This might have been CameraPick, EntityPick or LinePick.

The coordinate represents the exact point of where something was picked. 

See also: <a href=#PickedY>PickedY</a>, <a href=#PickedZ>PickedZ</a>.

End Rem
Function PickedX:Float()
End Function

Rem
bbdoc: Returns the world y coordinate of the most recently executed Pick command
about: 
@Parameters: 

None.

@Description: 

Returns the world y coordinate of the most recently executed Pick command.  This might have been CameraPick, EntityPick or LinePick.

The coordinate represents the exact point of where something was picked. 

See also: <a href=#PickedX>PickedX</a>, <a href=#PickedZ>PickedZ</a>.

End Rem
Function PickedY:Float()
End Function

Rem
bbdoc: Returns the world z coordinate of the most recently executed Pick command
about: 
@Parameters: 

None.

@Description: 

Returns the world z coordinate of the most recently executed Pick command.  This might have been CameraPick, EntityPick or LinePick.

The coordinate represents the exact point of where something was picked. 

See also: <a href=#PickedX>PickedX</a>, <a href=#PickedY>PickedY</a>.

End Rem
Function PickedZ:Float()
End Function

Rem
bbdoc: Points one entity at another
about: 
@Parameters: 

entity - entity handle

target - target entity handle

roll# (optional) - roll angle of entity

@Description: 

Points one entity at another.

The optional roll parameter allows you to  specify a roll angle as pointing an entity only sets pitch and yaw angles. 

If you wish for an entity to point at a certain position rather than another  entity, simply create a pivot entity at your desired position, point the entity  at this and then free the pivot. 

End Rem
Function PointEntity( ent:TEntity,target_ent:TEntity,roll:Float=0 )
End Function

Rem
bbdoc: Positions an entity at an absolute position in 3D space
about: 
@Parameters: 

entity - name of entity to be positioned

x# - x co-ordinate that entity will be positioned at

y# - y co-ordinate that entity will be positioned at

z# - z co-ordinate that entity will be positioned at

global (optional) - true if the position should be relative to 0,0,0 rather than a parent entity's position. False by default.

@Description: 

Positions an entity at an absolute position in 3D space.

Entities are positioned using an x,y,z coordinate system. x, y and z each have their own axis, and each axis has its own set of values. By specifying a value for each axis, you can position an entity anywhere in 3D space. 0,0,0 is the centre of 3D space, and if the camera is pointing in the default positive z direction, then positioning an entity with a z value of above 0 will make it appear in front of the camera, whereas a negative z value would see it disappear behind the camera. Changing the x value would see it moving sideways, and changing the y value would see it moving up/down.

Of course, the direction in which entities appear to move is relative to the position and orientation of the camera.

See also: <a href=#MoveEntity>MoveEntity</a>, <a href=#TranslateEntity>TranslateEntity</a>, <a href=#PositionMesh>PositionMesh</a>.

End Rem
Function PositionEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: Moves all vertices of a mesh
about: 
@Parameters: 

mesh - mesh handle

x# - x position of mesh

y# - y position of mesh

z# - z position of mesh

@Description: 

Moves all vertices of a mesh.

See also: <a href=#PositionEntity>PositionEntity</a>, <a href=#MoveEntity>MoveEntity</a>, <a href=#TranslateEntity>TranslateEntity</a>.

End Rem
Function PositionMesh( mesh:TMesh,px:Float,py:Float,pz:Float )
End Function

Rem
bbdoc: Positions a texture at an absolute position
about: 
@Parameters: 

texture - texture handle

u_position# - u position of texture

v_position# - v position of texture

@Description: 

Positions a texture at an absolute position.

This will have an  immediate effect on all instances of the texture being used. 

Positioning a texture is useful for performing scrolling texture effects,  such as for water etc.

End Rem
Function PositionTexture( tex:TTexture,u_pos:Float,v_pos:Float )
End Function

Rem
bbdoc: Returns the viewport x coordinate of the most recently executed CameraProject
about: 
@Parameters: 

None.

@Description: 

Returns the viewport x coordinate of the most recently executed CameraProject.

End Rem
Function ProjectedX:Float()
End Function

Rem
bbdoc: Returns the viewport y coordinate of the most recently executed CameraProject
about: 
@Parameters: 

None.

@Description: 

Returns the viewport y coordinate of the most recently executed CameraProject.

End Rem
Function ProjectedY:Float()
End Function

Rem
bbdoc: Returns the viewport z coordinate of the most recently executed CameraProject
about: 
@Parameters: 

None.

@Description: 

Returns the viewport z coordinate of the most recently executed CameraProject.

End Rem
Function ProjectedZ:Float()
End Function

Rem
bbdoc: Renders the current scene to the BackBuffer onto the rectangle defined by each cameras CameraViewport( )
about: 
@Parameters: 

tween# (optional) - defaults to 1.

@Description: 

Renders the current scene to the BackBuffer onto the rectangle defined by each cameras CameraViewport( ). Every camera not hidden by HideEntity( ) or with a CameraProjMode( ) of 0 is rendered. Rendering to other buffers is currently not supported by Blitz3D.

The optional tween parameter should only be specified when RenderWorld is used in conjunction with CaptureWorld. CaptureWorld is used to store the 'old' position, rotation and scale, alpha and colour of each entity in the game world, and a tween value of 

The use of tweening allows you to render more than one frame per game logic update, while still keeping the display smooth. This allows you to cut down on the CPU time that would be required to update your game logic every render. Note, however, that the bottleneck in almost all 3D applications is the graphics card and the CPU time involved in updating game logic is often very little. A good alternative to render tweening is the use of a delta time, that is, moving your entities each frame depending on the time it took for the program to process and render that frame.

Render tweening is quite an advanced technique, and it is not necessary to  use it, so don't worry if you don't quite understand it. See the castle demo  included in the mak (nickname of Mark Sibly, author of Blitz3D) directory of  the Blitz3D samples section for a demonstration of render tweening.

See also: <a href=#CaptureWorld>CaptureWorld</a>, <a href=#CameraViewport>CameraViewport</a>, <a href=#CameraProjMode>CameraProjMode</a>.

End Rem
Function RenderWorld()
End Function

Rem
bbdoc: Resets the collision state of an entity
about: 
@Parameters: 

entity - entity handle

@Description: 

Resets the collision state of an entity.

See also: <a href=#EntityBox>EntityBox</a>, <a href=#EntityRadius>EntityRadius</a>, <a href=#Collisions>Collisions</a>, <a href=#EntityType>EntityType</a>, <a href=#GetEntityType>GetEntityType</a>.

End Rem
Function ResetEntity( ent:TEntity )
End Function

Rem
bbdoc: Rotates an entity so that it is at an absolute orientation
about: 
@Parameters: 

entity - name of the entity to be rotated

pitch# - angle in degrees of pitch rotation

yaw# - angle in degrees of yaw rotation

roll# - angle in degrees of roll rotation

global (optional) - true if the angle rotated should be relative to 0,0,0 rather than a parent entity's orientation. False by default.

@Description: 

Rotates an entity so that it is at an absolute orientation.

Pitch is the same as the x angle of an entity, and is equivalent to tilting forward/backwards.

Yaw is the same as the y angle of an entity, and is equivalent to turning left/right.

Roll is the same as the z angle of an entity, and is equivalent to tilting left/right.

See also: <a href=#TurnEntity>TurnEntity</a>, <a href=#RotateMesh>RotateMesh</a>.

End Rem
Function RotateEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: Rotates all vertices of a mesh by the specified rotation
about: 
@Parameters: 

mesh - mesh handle

pitch# - pitch of mesh

yaw# - yaw of mesh

roll# - roll of mesh

@Description: 

Rotates all vertices of a mesh by the specified rotation.

See also: <a href=#RotateEntity>RotateEntity</a>, <a href=#TurnEntity>TurnEntity</a>.

End Rem
Function RotateMesh( mesh:TMesh,pitch:Float,yaw:Float,roll:Float )
End Function

Rem
bbdoc: Rotates a sprite
about: 
@Parameters: 

sprite - sprite handle

angle# - absolute angle of sprite rotation

@Description: 

Rotates a sprite.

See also: <a href=#CreateSprite>CreateSprite</a>, <a href=#LoadSprite>LoadSprite</a>.

End Rem
Function RotateSprite( sprite:TSprite,ang:Float )
End Function

Rem
bbdoc: Rotates a texture
about: 
@Parameters: 

texture - texture handle

angle# - absolute angle of texture rotation

@Description: 

Rotates a texture.

This will have an immediate effect on all instances  of the texture being used. 

Rotating a texture is useful for performing swirling texture effects,  such as for smoke etc.

End Rem
Function RotateTexture( tex:TTexture,ang:Float )
End Function

Rem
bbdoc: Scales an entity so that it is of an absolute size
about: 
@Parameters: 

entity - name of the entity to be scaled

x_scale# - x size of entity

y_scale# - y size of entity

z_scale# - z size of entity

global (optional) -

@Description: 

Scales an entity so that it is of an absolute size.

Scale values of 1,1,1 are the default size when creating/loading entities.

Scale values of 2,2,2 will double the size of an entity.

Scale values of 0,0,0 will make an entity disappear.

Scale values of less than 0,0,0 will invert an entity and make it bigger.

See also: <a href=#ScaleMesh>ScaleMesh</a>, <a href=#FitMesh>FitMesh</a>.

End Rem
Function ScaleEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: Scales all vertices of a mesh by the specified scaling factors
about: 
@Parameters: 

mesh - mesh handle

x_scale# - x scale of mesh

y_scale# - y scale of mesh

z_scale# - z scale of mesh

@Description: 

Scales all vertices of a mesh by the specified scaling factors.

See also: <a href=#FitMesh>FitMesh</a>, <a href=#ScaleEntity>ScaleEntity</a>.

End Rem
Function ScaleMesh( mesh:TMesh,sx:Float,sy:Float,sz:Float )
End Function

Rem
bbdoc: Scales a sprite
about: 
@Parameters: 

sprite - sprite handle

x_scale# - x scale of sprite

y scale# - y scale of sprite

@Description: 

Scales a sprite.

See also: <a href=#LoadSprite>LoadSprite</a>, <a href=#CreateSprite>CreateSprite</a>.

End Rem
Function ScaleSprite( sprite:TSprite,s_x:Float,s_y:Float )
End Function

Rem
bbdoc: Scales a texture by an absolute amount
about: 
@Parameters: 

texture - name of texture

u_scale# - u scale

v_scale# - v scale

@Description: 

Scales a texture by an absolute amount.

This will have an immediate  effect on all instances of the texture being used.

End Rem
Function ScaleTexture( tex:TTexture,u_scale:Float,v_scale:Float )
End Function

Rem
bbdoc: SetAnimTime allows you to manually animate entities
about: 
@Parameters: 

entity - a valid entity handle.

time# - a floating point time value.

anim_seq - an optional animation sequence number.

@Description: 

SetAnimTime allows you to manually animate entities.

End Rem
Function SetAnimTime( ent:TEntity,time:Float,seq:Int=0 )
End Function

Rem
bbdoc: Selects a cube face for direct rendering to a texture
about: 
@Parameters: 

texture - texture

face - face of cube to select. This should be one of the following values:

0: left (negative X) face

1: forward (positive Z) face - this is the default.

2: right (positive X) face

3: backward (negative Z) face

4: up (positive Y) face

5: down (negative Y) face

@Description: 

Selects a cube face for direct rendering to a texture.

This command should only be used when you wish to draw directly to a cubemap texture in real-time. Otherwise, just loading a pre-rendered cubemap with a flag of 128 will suffice.

To understand how this command works exactly it is important to recognise that Blitz treats cubemap textures slightly differently to how it treats other textures. Here's how it works...

A cubemap texture in Blitz actually consists of six images, each of which must be square 'power' of two size - e.g. 32, 64, 128 etc. Each corresponds to a particular cube face. These images are stored internally by Blitz, and the texture handle that is returned by LoadTexture/CreateTexture when specifying the cubemap flag, only provides access to one of these six images at once (by default the first one, or '0' face).

This is why, when loading a cubemap texture into Blitz using LoadTexture, all the six cubemap images must be laid out in a specific order (0-5, as described above), in a horizontal strip. Then Blitz takes this texture and internally converts it into six separate images.

So seeing as the texture handle returned by <a href=#CreateTexture>CreateTexture</a> / <a href=#LoadTexture>LoadTexture</a> only provides access to one of these images at once (no. 1 by default), how do we get access to the other five images? This is where SetCubeFace comes in. It will tell Blitz that whenever you next draw to a cubemap texture, to draw to the particular image representing the face you have specified with the face parameter.

Now you have the ability to draw to a cubemap in real-time.

To give you some idea of how this works in code, here's a function that updates a cubemap in real-time. It works by rendering six different views and copying them to the cubemap texture buffer, using SetCubeFace to specify which particular cubemap image should be drawn to.

; Start of code

Function UpdateCubeMap( tex,camera )

tex_sz=TextureWidth(tex)

; do left view
SetCubeFace tex,0
RotateEntity camera,0,90,0
RenderWorld

; copy contents of backbuffer to cubemap
CopyRect 0,0,tex_sz,tex_sz,0,0,BackBuffer(),TextureBuffer(tex)

; do forward view
SetCubeFace tex,1
RotateEntity camera,0,0,0
RenderWorld
CopyRect 0,0,tex_sz,tex_sz,0,0,BackBuffer(),TextureBuffer(tex)

; do right view	
SetCubeFace tex,2
RotateEntity camera,0,-90,0
RenderWorld
CopyRect 0,0,tex_sz,tex_sz,0,0,BackBuffer(),TextureBuffer(tex)

; do backward view
SetCubeFace tex,3
RotateEntity camera,0,180,0
RenderWorld
CopyRect 0,0,tex_sz,tex_sz,0,0,BackBuffer(),TextureBuffer(tex)

; do up view
SetCubeFace tex,4
RotateEntity camera,-90,0,0
RenderWorld
CopyRect 0,0,tex_sz,tex_sz,0,0,BackBuffer(),TextureBuffer(tex)

; do down view
SetCubeFace tex,5
RotateEntity camera,90,0,0
RenderWorld
CopyRect 0,0,tex_sz,tex_sz,0,0,BackBuffer(),TextureBuffer(tex)

EndFunction

; End of code

All rendering to a texture buffer affects the currently selected face. Do not change the selected cube face while a buffer is locked.

Finally, you may wish to combine the vram 256 flag with the cubic mapping flag when drawing to cubemap textures for faster access.

See also: <a href=#CreateTexture>CreateTexture</a>, <a href=#LoadTexture>LoadTexture</a>, <a href=#SetCubeMode>SetCubeMode</a>.

End Rem
Function SetCubeFace( tex:TTexture,face:Int )
End Function

Rem
bbdoc: Set the rendering mode of a cubemap texture
about: 
@Parameters: 

texture - a valid texture handle



mode - the rendering mode of the cubemap texture:

1: Specular (default) 

2: Diffuse

3: Refraction

@Description: 

Set the rendering mode of a cubemap texture.

The available rendering modes are as follows:

1: Specular (default). Use this to give your cubemapped objects a shiny effect.

2: Diffuse. Use this to give your cubemapped objects a non-shiny, realistic lighting effect.

3: Refraction. Good for 'cloak'-style effects.

See also: <a href=#CreateTexture>CreateTexture</a>, <a href=#LoadTexture>LoadTexture</a>, <a href=#SetCubeFace>SetCubeFace</a>.

End Rem
Function SetCubeMode( tex:TTexture,Mode:Int )
End Function

Rem
bbdoc: Shows an entity
about: 
@Parameters: 

entity - entity handle

@Description: 

Shows an entity. Very much the opposite of HideEntity.

Once an entity has been hidden using HideEntity,  use show entity to make it visible and involved in collisions again.  Note that ShowEntity has no effect if the enitities parent object is hidden.

Entities are shown by default after creating/loading them, so you should  only need to use ShowEntity after using HideEntity. 

ShowEntity affects the specified entity only - child entities are not affected.

End Rem
Function ShowEntity( ent:TEntity )
End Function

Rem
bbdoc: Sets the view mode of a sprite
about: 
@Parameters: 

sprite - sprite handle


view_mode - view_mode of sprite

1: fixed (sprite always faces camera - default)

2: free (sprite is independent of camera)

3: upright1 (sprite always faces camera, but rolls with camera as well, unlike  mode no.1)

4: upright2 (sprite always remains upright. Gives a 'billboard' effect. Good  for trees, spectators etc.)

@Description: 

Sets the view mode of a sprite.

The view mode determines how a sprite  alters its orientation in respect to the camera. This allows the sprite to in  some instances give the impression that it is more than two dimensional. 

In technical terms, the four sprite modes perform the following changes: 

1: Sprite changes its pitch and yaw values to face camera, but doesn't roll.
2: Sprite does not change either its pitch, yaw or roll values.
3: Sprite changes its yaw and pitch to face camera, and changes its roll value  to match cameras.
4: Sprite changes its yaw value to face camera, but not its pitch value, and  changes its roll value to match cameras. 

Note that if you use sprite view mode 2, then because it is independent from  the camera, you will only be able to see it from one side unless you use EntityFx  flag 16 with it to disable backface culling.

See also: <a href=#CreateSprite>CreateSprite</a>, <a href=# LoadSprite> LoadSprite</a>.

End Rem
Function SpriteViewMode( sprite:TSprite,Mode:Int )
End Function

Rem
bbdoc: Sets the blending mode for a texture
about: 
@Parameters: 

Texture - Texture handle.

Blend - Blend mode of texture.



0: Do not blend

1: No blend, or Alpha (alpha when texture loaded with alpha flag - not recommended  for multitexturing - see below)

2: Multiply (default)

3: Add

4: Dot3

5: Multiply 2

@Description: 

Sets the blending mode for a texture.

The texture blend mode determines how the texture will blend with the texture or polygon which is 'below' it. Texture 0 will blend with the polygons of the entity it is applied to. Texture 1 will blend with texture 0. Texture 2 will blend with texture 1. And so on.

Texture blending in Blitz effectively takes the highest order texture (the one with the highest index) and it blends with the texture below it, then that result to the texture directly below again, and so on until texture 0 which is blended with the polygons of the entity it is applied to and thus the world, depending on the <a href=#EntityBlend>EntityBlend</a> of the object.

Each of the blend modes are identical to their <a href=#EntityBlend>EntityBlend</a> counterparts.

In the case of multitexturing (more than one texture applied to an entity), it is not recommended you blend textures that have been loaded with the alpha flag, as this can cause unpredictable results on a variety of different graphics cards. 

Use <a href=#EntityTexture>EntityTexture</a> to set the index number of a texture.

See also: <a href=#EntityBlend>EntityBlend</a>, <a href=#EntityTexture>EntityTexture</a>.

End Rem
Function TextureBlend( tex:TTexture,blend:Int )
End Function

Rem
bbdoc: Sets the texture coordinate mode for a texture
about: 
@Parameters: 

texture - name of texture

coords -

0: UV coordinates are from first UV set in vertices (default)

1: UV coordinates are from second UV set in vertices

@Description: 

Sets the texture coordinate mode for a texture.

This determines where  the UV values used to look up a texture come from.

End Rem
Function TextureCoords( tex:TTexture,coords:Int )
End Function

Rem
bbdoc: Returns the height of a texture
about: 
@Parameters: 

texture - texture handle

@Description: 

Returns the height of a texture.

End Rem
Function TextureHeight:Int( tex:TTexture )
End Function

Rem
bbdoc: Adds a texture filter
about: 
@Parameters: 

match_text$ - text that, if found in texture filename, will activate certain  filters


flags - filter texture flags: 

1: Color

2: Alpha 

4: Masked 

8: Mipmapped 

16: Clamp U 

32: Clamp V 

64: Spherical reflection map 

128: 

256: Store texture in vram 

512: Force the use of high color textures

@Description: 

Adds a texture filter. Any textures loaded that contain the text specified  by match_text$ will have the provided flags added.

This is mostly of use when loading a mesh. 

By default, the following texture filter is used: 

TextureFilter "",1+8 

This means that all loaded textures will have color and be mipmapped by default.

End Rem
Function TextureFilter( match_text:String,flags:Int )
End Function

Rem
bbdoc: Returns a texture's absolute filename
about: 
@Parameters: 

texture - a valid texture handle

@Description: 

Returns a texture's absolute filename.

To find out just the name of the texture, you will need to parse the string returned by TextureName. One such function to do this is:

; start of code
Function StripPath$(file$)

If Len(file$)>0

For i=Len(file$) To 1 Step -1

mi$=Mid$(file$,i,1)
If mi$="\" Or mi$="/" Then Return name$ Else name$=mi$+name$

Next

EndIf

Return name$

End Function
; end of code

See also: <a href=#GetBrushTexture>GetBrushTexture</a>.

End Rem
Function TextureName:String( tex:TTexture )
End Function

Rem
bbdoc: Returns the width of a texture
about: 
@Parameters: 

texture - texture handle

@Description: 

Returns the width of a texture.

End Rem
Function TextureWidth:Int( tex:TTexture )
End Function

Rem
bbdoc: Returns the X component of the last TFormPoint
about: 
@Parameters: 

None.

@Description: 

Returns the X component of the last TFormPoint, TFormVector or TFormNormal  operation.

See those commands for examples.

End Rem
Function TFormedX:Float()
End Function

Rem
bbdoc: Returns the Y component of the last TFormPoint
about: 
@Parameters: 

None.

@Description: 

Returns the Y component of the last TFormPoint, TFormVector or TFormNormal  operation.

See those commands for examples.

End Rem
Function TFormedY:Float()
End Function

Rem
bbdoc: Returns the Z component of the last TFormPoint
about: 
@Parameters: 

None.

@Description: 

Returns the Z component of the last TFormPoint,  TFormVector or TFormNormal operation. 

See those commands for examples.

End Rem
Function TFormedZ:Float()
End Function

Rem
bbdoc: Transforms between coordinate systems
about: 
@Parameters: 

x#, y#, z# = components of a vector in 3d space


source_entity = handle of source entity, or 0 for 3d world

dest_entity = handle of destination entity, or 0 for 3d world

@Description: 

Transforms between coordinate systems. After using TFormNormal the new
components can be read with TFormedX(), TFormedY() and TFormedZ().

This is exactly the same as TFormVector but with one added feature.
After the transformation the new vector is 'normalized', meaning it
is scaled to have length 1.

For example, suppose the result of TFormVector is (1,2,2).
This vector has length Sqr( 1*1 + 2*2 + 2*2 ) = Sqr( 9 ) = 3.

This means TFormNormal would produce ( 1/3, 2/3, 2/3 ).

End Rem
Function TFormNormal( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
End Function

Rem
bbdoc: Transforms between coordinate systems
about: 
@Parameters: 

x#, y#, z# = coordinates of a point in 3d space


source_entity = handle of source entity, or 0 for 3d world

dest_entity = handle of destination entity, or 0 for 3d world

@Description: 

Transforms between coordinate systems. After using TFormPoint the new
coordinates can be read with TFormedX(), TFormedY() and TFormedZ(). 


See EntityX() for details about local coordinates. 

Consider a sphere built with CreateSphere(). The 'north pole' is at (0,1,0).
At first, local and global coordinates are the same. As the sphere is moved, 
turned and scaled the global coordinates of the point change.

But it is always at (0,1,0) in the sphere's local space.

End Rem
Function TFormPoint( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
End Function

Rem
bbdoc: Transforms between coordinate systems
about: 
@Parameters: 

x#, y#, z# = components of a vector in 3d space


source_entity = handle of source entity, or 0 for 3d world

dest_entity = handle of destination entity, or 0 for 3d world

@Description: 

Transforms between coordinate systems. After using TFormVector the new
components can be read with TFormedX(), TFormedY() and TFormedZ(). 


See EntityX() for details about local coordinates.


Similar to TFormPoint, but operates on a vector. A vector can be thought of
as 'displacement relative to current location'.

For example, vector (1,2,3) means one step to the right, two steps up 
and three steps forward. 

This is analogous to PositionEntity and MoveEntity:

PositionEntity entity, x,y,z   ; put entity at point (x,y,z)

MoveEntity entity, x,y,z       ; add vector (x,y,z) to current position

End Rem
Function TFormVector( x:Float,y:Float,z:Float,src_ent:TEntity,dest_ent:TEntity )
End Function

Rem
bbdoc: Translates an entity relative to its current position and not its  orientation
about: 
@Parameters: 

entity - name of entity to be translated

x# - x amount that entity will be translated by

y# - y amount that entity will be translated by

z# - z amount that entity will be translated by

global (optional) -

@Description: 

Translates an entity relative to its current position and not its  orientation.

What this means is that an entity will move in a certain direction despite where it may be facing. Imagine that you have a game character that you want to make jump in the air at the same time as doing a triple somersault. Translating the character by a positive y amount will mean the character will always travel directly up in their air, regardless of where it may be facing due to the somersault action.

See also: <a href=#MoveEntity>MoveEntity</a>, <a href=#PositionEntity>PositionEntity</a>, <a href=#PositionMesh>PositionMesh</a>.

End Rem
Function TranslateEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: Returns the vertex of a triangle corner
about: 
@Parameters: 

surface - surface handle

triangle_index - triangle index

corner - corner of triangle. Should be 0, 1 or 2.

@Description: 

Returns the vertex of a triangle corner.

End Rem
Function TriangleVertex:Int( surf:TSurface,tri_no:Int,corner:Int )
End Function

Rem
bbdoc: Turns an entity relative to its current orientation
about: 
@Parameters: 

entity - name of entity to be rotated

pitch# - angle in degrees that entity will be pitched

yaw# - angle in degrees that entity will be yawed

roll# - angle in degrees that entity will be rolled

global (optional) -

@Description: 

Turns an entity relative to its current orientation.

Pitch is the same as the x angle of an entity, and is equivalent to tilting forward/backwards.

Yaw is the same as the y angle of an entity, and is equivalent to turning left/right.

Roll is the same as the z angle of an entity, and is equivalent to tilting left/right.

See also: <a href=#RotateEntity>RotateEntity</a>, <a href=#RotateMesh>RotateMesh</a>.

End Rem
Function TurnEntity( ent:TEntity,x:Float,y:Float,z:Float,glob:Int=False )
End Function

Rem
bbdoc: Recalculates all normals in a mesh
about: 
@Parameters: 

mesh - mesh handle

@Description: 

Recalculates all normals in a mesh. This is necessary for correct lighting  if you have not set surface normals using 'VertexNormals' commands.

End Rem
Function UpdateNormals( mesh:TMesh )
End Function

Rem
bbdoc: Animates all entities in the world
about: 
@Parameters: 

anim_speed# (optional) - a master control for animation speed. Defaults  to 1.

@Description: 

Animates all entities in the world, and performs collision checking.

The  optional anim_speed# parameter allows you affect the animation speed of all  entities at once. A value of 1 will animate entities at their usual animation  speed, a value of 2 will animate entities at double their animation speed, and  so on.  

For best results use this command once per main loop, just before calling RenderWorld. 

End Rem
Function UpdateWorld( anim_speed:Float=1 )
End Function

Rem
bbdoc: Returns the pitch value of a vector
about: 
@Parameters: 

x# - x vector length

y# - y vector length

z# - z vector length

@Description: 

Returns the pitch value of a vector.

Using this command will return the same result as using <a href=#EntityPitch>EntityPitch</a> to get the pitch value of an entity that is pointing in the vector's direction.

See also: <a href=#VectorYaw>VectorYaw</a>, <a href=#EntityPitch>EntityPitch</a>.

End Rem
Function VectorPitch:Float( vx:Float,vy:Float,vz:Float )
End Function

Rem
bbdoc: Returns the yaw value of a vector
about: 
@Parameters: 

x# - x vector length

y# - y vector length

z# - z vector length

@Description: 

Returns the yaw value of a vector.

Using this command will return the same result as using <a href=#EntityYaw>EntityYaw</a> to get the yaw value of an entity that is pointing in the vector's direction.

See also: <a href=#VectorPitch>VectorPitch</a>, <a href=#EntityYaw>EntityYaw</a>.

End Rem
Function VectorYaw:Float( vx:Float,vy:Float,vz:Float )
End Function

Rem
bbdoc: Returns the alpha component of a vertices color
about: 
@Parameters: 

surface - surface handle 

index - index of vertex

@Description: 

Returns the alpha component of a vertices color, set using <a href=#VertexColor>VertexColor</a>

See also: <a href=#VertexRed>VertexRed</a>, <a href=#VertexGreen>VertexGreen</a>, <a href=#VertexBlue>VertexBlue</a>, <a href=#VertexColor>VertexColor</a>.

End Rem
Function VertexAlpha:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: Returns the blue component of a vertices color
about: 
@Parameters: 

surface - surface handle

index - index of vertex

@Description: 

Returns the blue component of a vertices color.

End Rem
Function VertexBlue:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: Sets the color of an existing vertex
about: 
@Parameters: 

surface - surface handle

index - index of vertex

red# - red value of vertex

green# - green value of vertex

blue# - blue value of vertex

alpha# - optional alpha transparency of vertex (0.0 to 1.0 - default: 1.0)

@Description: 

Sets the color of an existing vertex.

NB. If you want to set the alpha individually for vertices using the alpha# parameter then you need to use EntityFX 32 (to force alpha-blending) on the entity.

See also: <a href=#EntityFX>EntityFX</a>.

End Rem
Function VertexColor( surf:TSurface,vid:Int,r:Float,g:Float,b:Float,a:Float=1 )
End Function

Rem
bbdoc: Sets the geometric coordinates of an existing vertex
about: 
@Parameters: 

surface - surface handle

index - index of vertex

x# - x position of vertex

y# - y position of vertex

z# - z position of vertex

@Description: 

Sets the geometric coordinates of an existing vertex.

This is the command  used to perform what is commonly referred to as 'dynamic mesh deformation'.  It will reposition a vertex so that all the triangle edges connected to it,  will move also. This will give the effect of parts of the mesh suddenly deforming. 

End Rem
Function VertexCoords( surf:TSurface,vid:Int,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: Returns the green component of a vertices color
about: 
@Parameters: 

surface - surface handle

index - index of vertex

@Description: 

Returns the green component of a vertices color.

End Rem
Function VertexGreen:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: Sets the normal of an existing vertex
about: 
@Parameters: 

surface - surface handle

index - index of vertex

nx# - normal x of vertex

ny# - normal y of vertex

nz# - normal z of vertex

@Description: 

Sets the normal of an existing vertex.

End Rem
Function VertexNormal( surf:TSurface,vid:Int,nx:Float,ny:Float,nz:Float )
End Function

Rem
bbdoc: Returns the x component of a vertices normal
about: 
@Parameters: 

surface - surface handle

index - index of vertex

@Description: 

Returns the x component of a vertices normal.

End Rem
Function VertexNX:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: Returns the y component of a vertices normal
about: 
@Parameters: 

surface - surface handle

index - index of vertex

@Description: 

Returns the y component of a vertices normal.

End Rem
Function VertexNY:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: Returns the z component of a vertices normal
about: 
@Parameters: 

surface - surface handle

index - index of vertex

@Description: 

Returns the z component of a vertices normal.

End Rem
Function VertexNZ:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: Returns the red component of a vertices color
about: 
@Parameters: 

surface - surface handle

index - index of vertex

@Description: 

Returns the red component of a vertices color.

End Rem
Function VertexRed:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: Sets the texture coordinates of an existing vertex
about: 
@Parameters: 

surface - surface handle

index - index of vertex

u# - u# coordinate of vertex

v# - v# coordinate of vertex

w# (optional) - w# coordinate of vertex

coord_set (optional) - co_oord set. Should be set to 0 or 1.

@Description: 

Sets the texture coordinates of an existing vertex.

End Rem
Function VertexTexCoords( surf:TSurface,vid:Int,u:Float,v:Float,w:Float=0,coord_set:Int=0 )
End Function

Rem
bbdoc: Returns the texture u coordinate of a vertex
about: 
@Parameters: 

surface - surface handle

index - index of vertex

coord_set (optional) - UV mapping coordinate set. Should be set to 0 or 1.

@Description: 

Returns the texture u coordinate of a vertex.

See also: <a href=#VertexV>VertexV</a>,

End Rem
Function VertexU:Float( surf:TSurface,vid:Int,coord_set:Int=0 )
End Function

Rem
bbdoc: Returns the texture v coordinate of a vertex
about: 
@Parameters: 

surface - surface handle

index - index of vertex

coord_set (optional) - UV mapping coordinate set. Should be set to 0 or 1.

@Description: 

Returns the texture v coordinate of a vertex.

See also: <a href=#VertexU>VertexU</a>,

End Rem
Function VertexV:Float( surf:TSurface,vid:Int,coord_set:Int=0 )
End Function

Rem
bbdoc: Returns the texture w coordinate of a vertex
about: 
@Parameters: 

surface - surface handle

index - index of vertex

@Description: 

Returns the texture w coordinate of a vertex.

End Rem
Function VertexW:Float( surf:TSurface,vid:Int,coord_set:Int=0 )
End Function

Rem
bbdoc: Returns the x coordinate of a vertex
about: 
@Parameters: 

surface - surface handle

index - index of vertex

@Description: 

Returns the x coordinate of a vertex.

End Rem
Function VertexX:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: Returns the y coordinate of a vertex
about: 
@Parameters: 

surface - surface handle

index - index of vertex

@Description: 

Returns the y coordinate of a vertex.

End Rem
Function VertexY:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: Returns the z coordinate of a vertex
about: 
@Parameters: 

surface - surface handle

index - index of vertex

@Description: 

Returns the z coordinate of a vertex.

End Rem
Function VertexZ:Float( surf:TSurface,vid:Int )
End Function

Rem
bbdoc: Enables or disables wireframe rendering
about: 
@Parameters: 

enable - True to enable wireframe rendering, False to disable.


The default  Wireframe mode is False. 

@Description: 

Enables or disables wireframe rendering.

This will show the outline of  each polygon on the screen, with no shaded-in areas.

Wireframe mode should only be used for debugging purposes, as driver support  is patchy. For the same reason, no support is offered for the wireframe rendering  of individual polygon entities. 

End Rem
Function Wireframe( enable:Int )
End Function

' *** Blitz3D functions, A-Z (in Openb3d)

Rem
bbdoc: Creates an animation sequence for an entity
about: 
@Parameters: 

entity - entity handle

length -

@Description: 

Creates an animation sequence for an entity. This must be done before any  animation keys set by SetAnimKey can be used in  an actual animation however this is optional. You may use it to "bake" the frames you have added previously using SetAnimKey.

Returns the animation sequence number added.

End Rem
Function AddAnimSeq:Int( ent:TEntity,length:Int )
End Function

Rem
bbdoc: Aligns an entity axis to a vector
about: 
@Parameters: 

entity - entity handle

vector_x# - vector x

vector_y# - vector y

vector_z# - vector z


axis - axis of entity that will be aligned to vector

1: x-axis

2: y-axis

3: z-axis


rate# (optional) - rate at which entity is aligned from current  orientation to vector orientation. Should be in the range 0 to 1, 0 for smooth  transition and 1 for 'snap' transition. Defaults to 1. 

@Description: 

Aligns an entity axis to a vector.

End Rem
Function AlignToVector( entity:TEntity,x:Float,y:Float,z:Float,axis:Int,rate:Int=1 )
End Function

Rem
bbdoc: Creates a plane entity and returns its handle
about: 
@Parameters: 

sub_divs (optional) - sub divisions of plane. Should be in the range 1-16.  The default value is 1.

parent (optional) - parent entity of plane

@Description: 

Creates a plane entity and returns its handle.

A plane entity is basically  a flat, infinite 'ground'. It is useful for outdoor games where you never want  the player to see/reach the edge of the game world. 

The optional sub_divs parameter determines how many sub divisions of polygons  the plane will have. Although a plane is flat and so adding extra polygons will  not make it smoother, adding more polygons will allow more vertices to be lit  for more detailed lighting effects. 

The optional parent parameter allows you to specify a parent  entity for the plane so that when the parent is moved the child plane will move  with it. However, this relationship is one way; applying movement commands to  the child will not affect the parent. 

Specifying a parent entity will still result in the plane being created at  position 0,0,0 rather than at the parent entity's position. 

See also: <a href=#CreateMirror>CreateMirror</a>.

End Rem
Function CreatePlane:TMesh( divisions:Int=1,parent:TEntity=Null )
End Function

Rem
bbdoc: Creates a terrain entity and returns its handle
about: 
@Parameters: 

grid_size - no of grid squares along each side of terrain, and must be a  power of 2 value, e.g. 32, 64, 128, 256, 512, 1024.

parent (optional) - parent entity of terrain

@Description: 

Creates a terrain entity and returns its handle.

The terrain  extends from 0,0,0 to grid_size,1,grid_size. 

A terrain is a special type of polygon object that uses real-time level of  detail (LOD) to display landscapes which should theoretically consist of over  a million polygons with only a few thousand. The way it does this is by constantly  rearranging a certain amount of polygons to display high levels of detail close  to the viewer and low levels further away. 

This constant rearrangement of polygons is occasionally noticeable however,  and is a well-known side-effect of all LOD landscapes. This 'pop-in' effect  can be reduced in lots of ways though, as the other terrain help files will  go on to explain. 

The optional parent parameter allows you to specify a parent entity for the  terrain so that when the parent is moved the child terrain will move with it.  However, this relationship is one way; applying movement commands to the child  will not affect the parent. 

Specifying a parent entity will still result in the terrain being created  at position 0,0,0 rather than at the parent entity's position.  

See also: <a href=#LoadTerrain>LoadTerrain</a>.

End Rem
Function CreateTerrain:TTerrain( size:Int,parent:TEntity=Null )
End Function

Rem
bbdoc: Appends an animation sequence from a file to an entity
about: 
@Parameters: 

entity - entity handle

filename$ - filename of animated 3D object

@Description: 

Appends an animation sequence from a file to an entity.

Returns the animation  sequence number added. 

End Rem
Function LoadAnimSeq:Int( ent:TEntity,file:String )
End Function

Rem
bbdoc: Loads a terrain from an image file and returns the terrain's handle
about: 
@Parameters: 

file$ - filename of image file to be used as height map

parent (optional) - parent entity of terrain

@Description: 

Loads a terrain from an image file and returns the terrain's handle.

The  image's red channel is used to determine heights. Terrain is initially the same  width and depth as the image, and 1 unit high. 

Tips on generating nice terrain:

* Smooth or blur the height map
* Reduce the y scale of the terrain
* Increase the x/z scale of the terrain
* Reduce the camera range 

When texturing an entity, a texture with a scale of 1,1,1 (default) will  be the same size as one of the terrain's grid squares. A texture that is scaled  to the same size as the size of the bitmap used to load it or the no. of grid  square used to create it, will be the same size as the terrain. 

The optional parent parameter allows you to specify a parent  entity for the terrain so that when the parent is moved the child terrain will  move with it. However, this relationship is one way; applying movement commands  to the child will not affect the parent.  

Specifying a parent entity will still result in the terrain being created  at position 0,0,0 rather than at the parent entity's position.  

A heightmaps dimensions (width and height) must be the same and must be a power of 2, e.g. 32, 64, 128, 256, 512, 1024. 

See also: <a href=#CreateTerrain>CreateTerrain</a>.

End Rem
Function LoadTerrain:TTerrain( file:String,parent:TEntity=Null )
End Function

Rem
bbdoc: Returns true if the specified meshes are currently intersecting
about: 
@Parameters: 

mesh_a - mesh_a handle

mesh_b - mesh_b handle

@Description: 

Returns true if the specified meshes are currently intersecting.

This  is a fairly slow routine - use with discretion...

This command is  currently the only  polygon->polygon collision checking routine available in Blitz3D.

End Rem
Function MeshesIntersect:Int( mesh1:TMesh,mesh2:TMesh )
End Function

Rem
bbdoc: Sets the height of a point on a terrain
about: 
@Parameters: 

terrain - terrain handle

grid_x - grid x coordinate of terrain

grid_y - grid y coordinate of terrain

height# - height of point on terrain. Should be in the range 0-1.

realtime (optional) - True to modify terrain immediately. False to modify terrain  when RenderWorld in next called. Defaults to False.

@Description: 

Sets the height of a point on a terrain.

End Rem
Function ModifyTerrain( terr:TTerrain,x:Int,z:Int,new_height:Float )
End Function

Rem
bbdoc: Sets an animation key for the specified entity at the specified frame
about: 
@Parameters: 

entity - entity handle

frame - frame of animation to be used as anim key

pos_key (optional) - true to include entity position information when setting  key. Defaults to true.

rot_key (optional) - true to include entity rotation information when setting  key. Defaults to true.

scale_key (optional) - true to include entity scale information when setting  key. Defaults to true.

@Description: 

Sets an animation key for the specified entity at the specified frame.  The entity must have a valid animation sequence to work with.

This is most useful when you've got a character, or a complete set of complicated moves to perform, and you want to perform them en-masse.

End Rem
Function SetAnimKey( ent:TEntity,frame:Float,pos_key:Int=True,rot_key:Int=True,scale_key:Int=True )
End Function

Rem
bbdoc: Returns the height of the terrain at terrain grid coordinates x
about: 
@Parameters: 

terrain - terrain handle

grid_x - grid x coordinate of terrain

grid_z - grid z coordinate of terrain

@Description: 

Returns the height of the terrain at terrain grid coordinates x,z. The value  returned is in the range 0 to 1.

See also: <a href=#TerrainY>TerrainY</a>.

End Rem
Function TerrainHeight:Float( terr:TTerrain,x:Int,z:Int )
End Function

Rem
bbdoc: Returns the interpolated x coordinate on a terrain
about: 
@Parameters: 

terrain - terrain handle

x# - world x coordinate

y# - world y coordinate

z# - world z coordinate

@Description: 

Returns the interpolated x coordinate on a terrain.

See also: <a href=#TerrainY>TerrainY</a>, <a href=#TerrainZ>TerrainZ</a>.

End Rem
Function TerrainX:Float( terr:TTerrain,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: Returns the interpolated y coordinate on a terrain
about: 
@Parameters: 

terrain - terrain handle

x# - world x coordinate

y# - world y coordinate

z# - world z coordinate

@Description: 

Returns the interpolated y coordinate on a terrain.

Gets the ground's  height, basically. 

See also: <a href=#TerrainX>TerrainX</a>, <a href=#TerrainZ>TerrainZ</a>, <a href=#TerrainHeight>TerrainHeight</a>.

End Rem
Function TerrainY:Float( terr:TTerrain,x:Float,y:Float,z:Float )
End Function

Rem
bbdoc: Returns the interpolated z coordinate on a terrain
about: 
@Parameters: 

terrain - terrain handle

x# - world x coordinate

y# - world y coordinate

z# - world z coordinate

@Description: 

Returns the interpolated z coordinate on a terrain.

See also: <a href=#TerrainX>TerrainX</a>, <a href=#TerrainY>TerrainY</a>.

End Rem
Function TerrainZ:Float( terr:TTerrain,x:Float,y:Float,z:Float )
End Function
