' bloom.bmx
' postprocess effect - render framebuffer to texture for bloom (fake HDR) effect

Strict

Framework Openb3d.B3dglgraphics

Import Brl.Random
?Not bmxng
Import Brl.Timer
?bmxng
Import Brl.TimerDefault
?

Local width%=DesktopWidth(),height%=DesktopHeight()

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
	EntityColor sphere,Float(Rnd(256)),Float(Rnd(256)),Float(Rnd(256))
	TurnEntity sphere,0,t,0
	MoveEntity sphere,0,0,15
Next
FreeEntity t_sphere

Local cube:TMesh=LoadMesh("../media/wcrate1.3ds")
ScaleMesh cube,0.15,0.15,0.15
PositionEntity cube,0,8,0
Local cube_tex:TTexture=LoadTexture("../media/crate.bmp",1)
EntityTexture cube,cube_tex

Local cube2:TMesh=CreateCube()
PositionEntity cube2,0,18,0
ScaleEntity cube2,2,2,2
EntityColor cube2,Float(Rnd(256)),Float(Rnd(256)),Float(Rnd(256))

Local t_cylinder:TMesh=CreateCylinder()
ScaleEntity t_cylinder,0.5,6,0.5
MoveEntity t_cylinder,5,0,-25
For Local t%=0 To 10
	MoveEntity t_cylinder,2,0,9
	Local cylinder:TEntity=CopyEntity(t_cylinder)
	EntityColor cylinder,Float(Rnd(256)),Float(Rnd(256)),Float(Rnd(256))
Next
FreeEntity t_cylinder

Global colortex:TTexture=CreateTexture(width,height,1+256)
ScaleTexture colortex,1.0,-1.0

' in GL 2.0 render textures need attached before other textures (EntityTexture)
CameraToTex colortex,camera
TGlobal.CheckFramebufferStatus(GL_FRAMEBUFFER_EXT) ' check for framebuffer errors

' screen sprite - by BlitzSupport
Global screensprite:TSprite=CreateSprite()
EntityOrder screensprite,-1
ScaleSprite screensprite,1.0,Float( GraphicsHeight() ) / GraphicsWidth() ' 0.75
MoveEntity screensprite,0,0,0.99 ' set z to 0.99 - instead of clamping uvs
EntityParent screensprite,camera

PositionEntity camera,0,7,0 ' move camera now sprite is parented to it
MoveEntity camera,0,0,-25

Local ground:TMesh=CreatePlane(128)
Local ground_tex:TTexture=LoadTexture("../media/Envwall.bmp",1+8)
ScaleTexture ground_tex,2,2
EntityTexture ground,ground_tex

Local shader:TShader=LoadShader("","../glsl/default.vert.glsl", "../glsl/bloom.frag.glsl")
ShaderTexture(shader,colortex,"texture0",0) ' render texture ' 
ShadeEntity(screensprite, shader)

Global postprocess%=1
Local time#=0, framerate#=60.0, animspeed#=10
Local timer:TTimer=CreateTimer(framerate)
UseFloat(shader,"time",time) ' Time used to scroll the distortion map

Local exposure#=30.0, GlareSize#=0.002, Power#=0.15
UseFloat(shader,"exposure",exposure) ' default 20.0
UseFloat(shader,"GlareSize",GlareSize) ' 0.002 is good
UseFloat(shader,"Power",Power) ' 0.25 is good

' fps code
Local old_ms%=MilliSecs()
Local renders%, fps%


While Not KeyHit(KEY_ESCAPE)
	
	time=Float((TimerTicks(timer) / framerate) * animspeed)
	
	If KeyHit(KEY_SPACE) Then postprocess=Not postprocess
	If KeyDown(KEY_E) Then exposure:+1.0
	If KeyDown(KEY_R) And exposure>2.0 Then exposure:-1.0
	If KeyDown(KEY_G) Then GlareSize:+0.0001
	If KeyDown(KEY_H) And GlareSize>0.0002 Then GlareSize:-0.0001
	If KeyDown(KEY_O) Then Power:+0.01
	If KeyDown(KEY_P) And Power>0.02 Then Power:-0.01
	
	' control camera
	MoveEntity camera,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity camera,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	PositionEntity postfx_cam,EntityX(camera),EntityY(camera),EntityZ(camera)
	RotateEntity postfx_cam,EntityPitch(camera),EntityYaw(camera),EntityRoll(camera)
	
	TurnEntity cube,0.1,0.2,0.3
	TurnEntity cube2,0.1,0.2,0.3
	TurnEntity pivot,0,1,0
	
	UpdateWorld
	Update1Pass()
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	BeginMax2D()
	SetColor 0,0,0
	DrawText "FPS: "+fps,0,20
	DrawText "WSAD & Arrows: move camera, Space: postprocess = "+postprocess,0,40
	DrawText "E/R: Exposure="+exposure+", G/H: GlareSize="+GlareSize+", O/P: Power="+Power,0,60
	EndMax2D()
	
	Flip
Wend
End


Function Update1Pass()

	If postprocess=0
		HideEntity postfx_cam
		ShowEntity camera
		HideEntity screensprite
		
		RenderWorld
	ElseIf postprocess=1
		ShowEntity postfx_cam
		HideEntity camera
		HideEntity screensprite
		
		CameraToTex colortex,postfx_cam
		
		HideEntity postfx_cam
		ShowEntity camera
		ShowEntity screensprite
		
		RenderWorld
	EndIf
	
End Function
