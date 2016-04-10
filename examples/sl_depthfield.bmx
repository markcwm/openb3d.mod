' sl_depthfield.bmx
' render framebuffer and depthbuffer to textures attached to shader - depth of field

Strict

Framework Openb3d.B3dglgraphics
Import Brl.Random

Local width%=800,height%=600
Graphics3D width,height


SeedRnd MilliSecs()
ClearTextureFilters

Local camera:TCamera=CreateCamera()
CameraRange camera,0.5,1000.0 ' near must be closer than screen sprite to prevent clipping
CameraClsColor camera,150,200,250
CameraViewport camera,0,0,width,height

Local light:TLight=CreateLight()
PositionEntity light,5,5,5

Local pivot:TPivot=CreatePivot()
PositionEntity pivot,0,2,0
Local t_sphere:TMesh=CreateSphere( 8 )
EntityShininess t_sphere,0.2
For Local t%=0 To 359 Step 36
	Local sphere:TEntity=CopyEntity(t_sphere,pivot)
	EntityColor sphere,Rnd(256),Rnd(256),Rnd(256)
	TurnEntity sphere,0,t,0
	MoveEntity sphere,0,0,15
Next
FreeEntity t_sphere

Local cube:TMesh=CreateCube()
PositionEntity cube,0,7,0
'ScaleEntity cube,3,3,3
EntityColor cube,Rnd(256),Rnd(256),Rnd(256)

Local t_cylinder:TMesh=CreateCylinder()
ScaleEntity t_cylinder,0.5,6,0.5
MoveEntity t_cylinder,5,0,-25
For Local t%=0 To 10
	MoveEntity t_cylinder,2,0,9
	Local cylinder:TEntity=CopyEntity(t_cylinder)
	EntityColor cylinder,Rnd(256),Rnd(256),Rnd(256)
Next
FreeEntity t_cylinder

Local colortex:TTexture=CreateTexture(width,height,1+256)
Local depthtex:TTexture=CreateTexture(width,height,1+256)
ScaleTexture colortex,1.0,-1.0
ScaleTexture depthtex,1.0,-1.0

' in GL 2.0 render textures need attached before other textures (EntityTexture)
CameraToTex colortex,camera
DepthBufferToTex depthtex,camera
Local status:Int=glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT) ' check for framebuffer errors
Select status
	Case GL_FRAMEBUFFER_COMPLETE_EXT
		DebugLog "FBO created"
	Case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT_EXT
	  	DebugLog "Incomplete attachment"
	Case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT_EXT
	  	DebugLog "Missing attachment"
	Case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS_EXT
	  	DebugLog "Incomplete dimensions"
	Case GL_FRAMEBUFFER_INCOMPLETE_FORMATS_EXT
	  	DebugLog "Incomplete formats"
	Case GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER_EXT
	 	DebugLog "Incomplete draw buffer"
	Case GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER_EXT
	  	DebugLog "Incomplete read buffer"
	Case GL_FRAMEBUFFER_UNSUPPORTED_EXT
		DebugLog "Type is not Supported"
	Default
		DebugLog "FBO unsuccessful: "+status
EndSelect

' screen sprite - by BlitzSupport
Local screensprite:TSprite=CreateSprite()
ScaleSprite screensprite,1.0,Float( GraphicsHeight() ) / GraphicsWidth() ' 0.75
EntityOrder screensprite,-1
EntityParent screensprite,camera
MoveEntity screensprite,0,0,1.0 ' set z to 1.0

Local screensprite2:TSprite=CreateSprite()
ScaleSprite screensprite2,1.0,Float( GraphicsHeight() ) / GraphicsWidth() ' 0.75
EntityOrder screensprite2,-1
EntityParent screensprite2,camera
MoveEntity screensprite2,0,0,1.0 ' set z to 1.0
EntityTexture screensprite2,depthtex

PositionEntity camera,0,7,0 ' move camera now sprite is parented to it
MoveEntity camera,0,0,-25

Local ground:TMesh=CreatePlane(128)
Local ground_tex:TTexture=LoadTexture("media/Envwall.bmp")
EntityTexture ground,ground_tex

Local shader:TShader=LoadShader("","shaders/depthfield.vert.glsl","shaders/depthfield.frag.glsl")
ShaderTexture(shader,colortex,"colortex",0) ' Our render texture
ShaderTexture(shader,depthtex,"depthtex",1) ' Our distortion map texture
ShadeEntity(screensprite,shader)

Local postprocess%=1
Local blursize#=0.0014
UseFloat(shader,"blursize",blursize)

' fps code
Local old_ms%=MilliSecs()
Local renders%, fps%

While Not KeyDown(KEY_ESCAPE)
	
	If KeyHit(KEY_SPACE) Then postprocess:+1 ; If postprocess>2 Then postprocess=0
	If KeyDown(KEY_EQUALS) And blursize<0.004 Then blursize:+0.0001
	If KeyDown(KEY_MINUS) And blursize>0.0004 Then blursize:-0.0001
	
	' control camera
	MoveEntity camera,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity camera,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	TurnEntity cube,0.1,0.2,0.3
	TurnEntity pivot,0,1,0
	
	HideEntity screensprite
	HideEntity screensprite2
	UpdateWorld
	RenderWorld
	
	If postprocess=1
		CameraToTex colortex,camera
		DepthBufferToTex depthtex,camera
		
		ShowEntity screensprite
		RenderWorld
	ElseIf postprocess=2
		DepthBufferToTex depthtex,camera
		
		ShowEntity screensprite2
		RenderWorld
	EndIf
	
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps
	Text 0,20,"postprocess: "+postprocess+", blursize: "+blursize
	
	Flip

Wend
End
