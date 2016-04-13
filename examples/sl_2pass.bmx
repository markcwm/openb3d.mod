' sl_2pass.bmx
' postprocess effect - how to render framebuffer twice per render

Strict

Framework Openb3d.B3dglgraphics
Import Brl.Random
Import Brl.Timer

Local width%=800,height%=600
Graphics3D width,height


SeedRnd MilliSecs()
ClearTextureFilters ' remove mipmap flag for postfx texture

Global camera:TCamera=CreateCamera()
CameraRange camera,0.5,1000.0 ' near must be closer than screen sprite to prevent clipping
CameraClsColor camera,150,200,250

Global postfx_cam:TCamera=CreateCamera() ' copy main camera
CameraRange postfx_cam,0.5,1000.0
CameraClsColor postfx_cam,150,200,250
HideEntity postfx_cam

Local light:TLight=CreateLight()
TurnEntity light,45,45,0

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

Local cube:TMesh=LoadMesh("media/wcrate.3ds")
ScaleMesh cube,0.15,0.15,0.15
PositionEntity cube,0,8,0
Local cube_tex:TTexture=LoadTexture("media/crate.bmp",1)
EntityTexture cube,cube_tex

Local cube2:TMesh=CreateCube()
PositionEntity cube2,0,18,0
ScaleEntity cube2,2,2,2
EntityColor cube2,Rnd(256),Rnd(256),Rnd(256)

Local t_cylinder:TMesh=CreateCylinder()
ScaleEntity t_cylinder,0.5,6,0.5
MoveEntity t_cylinder,5,0,-25
For Local t%=0 To 10
	MoveEntity t_cylinder,2,0,9
	Local cylinder:TEntity=CopyEntity(t_cylinder)
	EntityColor cylinder,Rnd(256),Rnd(256),Rnd(256)
Next
FreeEntity t_cylinder

Global colortex:TTexture=CreateTexture(800,600,1+256)
Global colortex2:TTexture=CreateTexture(800,600,1+256)
ScaleTexture colortex,1.0,-1.0
ScaleTexture colortex2,1.0,-1.0

Local noisew%=width/4, noiseh%=height/4
Local noisetex:TTexture=CreateTexture(noisew,noiseh)
Local noisemap:TPixmap=CreatePixmap(noisew,noiseh,PF_RGBA8888)
For Local i%=0 To PixmapWidth(noisemap)-1
	For Local j%=0 To PixmapHeight(noisemap)-1
		Local rgb%=Rand(0,255)+(Rand(0,255) Shl 8)+(Rand(0,255) Shl 16)
		WritePixel noisemap,i,j,rgb|$ff000000
	Next
Next
BufferToTex noisetex,PixmapPixelPtr(noisemap,0,0)

' in GL 2.0 render textures need attached before other textures (EntityTexture)
CameraToTex colortex,camera
CameraToTex colortex2,camera
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
Global screensprite:TSprite=CreateSprite()
EntityOrder screensprite,-1
ScaleSprite screensprite,1.0,Float( GraphicsHeight() ) / GraphicsWidth() ' 0.75
MoveEntity screensprite,0,0,1.0 ' set z to 0.99 - instead of clamping uvs
EntityParent screensprite,camera
HideEntity screensprite

Global screensprite2:TSprite=CreateSprite()
ScaleSprite screensprite2,1.0,Float( GraphicsHeight() ) / GraphicsWidth() ' 0.75
EntityOrder screensprite2,-1
EntityParent screensprite2,camera
MoveEntity screensprite2,0,0,1.0

PositionEntity camera,0,7,0 ' move camera now sprite is parented to it
MoveEntity camera,0,0,-25

Local ground:TMesh=CreatePlane(128)
Local ground_tex:TTexture=LoadTexture("media/Envwall.bmp",1+8)
ScaleTexture ground_tex,2,2
EntityTexture ground,ground_tex

Local shader:TShader=LoadShader("","shaders/shimmer.vert.glsl", "shaders/shimmer.frag.glsl")
ShaderTexture(shader,colortex,"currentTexture",0) ' Our render texture
ShaderTexture(shader,noisetex,"distortionMapTexture",1) ' Our distortion map texture
SetFloat(shader,"distortionFactor",0.005) ' Factor used to control severity of the effect
SetFloat(shader,"riseFactor",0.002) ' Factor used to control how fast air rises
ShadeEntity(screensprite, shader)

Local shader2:TShader=LoadShader("","shaders/default.vert.glsl", "shaders/greyscale.frag.glsl")
ShaderTexture(shader2,colortex2,"texture0",0) ' render texture
ShadeEntity(screensprite2, shader2)

Global postprocess%=1
Local time#=0, framerate#=60.0, animspeed#=10
Local timer:TTimer=CreateTimer(framerate)
UseFloat(shader,"time",time) ' Time used to scroll the distortion map

' fps code
Local old_ms%=MilliSecs()
Local renders%, fps%

While Not KeyHit(KEY_ESCAPE)
	
	time=Float((TimerTicks(timer) / framerate) * animspeed)
	
	If KeyHit(KEY_SPACE) Then postprocess:+1 ; If postprocess>3 Then postprocess=0
	
	' control camera
	MoveEntity camera,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity camera,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	PositionEntity postfx_cam,EntityX(camera),EntityY(camera),EntityZ(camera)
	RotateEntity postfx_cam,EntityPitch(camera),EntityYaw(camera),EntityRoll(camera)
	
	TurnEntity cube,0.1,0.2,0.3
	TurnEntity cube2,0.1,0.2,0.3
	TurnEntity pivot,0,1,0
	
	UpdateWorld
	Update2Pass()
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps
	Text 0,20,"Space: postprocess = "+postprocess
	
	Flip
Wend


Function Update2Pass()

	If postprocess=0
		HideEntity postfx_cam
		ShowEntity camera
		HideEntity screensprite2
		HideEntity screensprite
		
		RenderWorld
	ElseIf postprocess=1 ' 2 pass
		ShowEntity postfx_cam
		HideEntity camera
		HideEntity screensprite2
		HideEntity screensprite
		
		CameraToTex colortex,postfx_cam
		
		ShowEntity screensprite
		HideEntity postfx_cam
		ShowEntity camera ' note: 2nd pass needs main camera
		
		CameraToTex colortex2,camera
		
		HideEntity screensprite
		ShowEntity screensprite2
		
		RenderWorld
	ElseIf postprocess=2 ' shader1
		HideEntity camera
		ShowEntity postfx_cam
		HideEntity screensprite2
		HideEntity screensprite
				
		CameraToTex colortex,postfx_cam
		
		ShowEntity screensprite
		HideEntity postfx_cam
		ShowEntity camera
		
		RenderWorld
	ElseIf postprocess=3 ' shader2
		HideEntity camera
		ShowEntity postfx_cam
		HideEntity screensprite2
		HideEntity screensprite
				
		CameraToTex colortex2,postfx_cam
		
		ShowEntity screensprite2
		HideEntity postfx_cam
		ShowEntity camera
		
		RenderWorld
	EndIf
	
End Function
