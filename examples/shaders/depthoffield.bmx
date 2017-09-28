' depthoffield.bmx
' postprocess effect - render framebuffer and depthbuffer to shader textures for depth of field

Strict

Framework Openb3d.B3dglgraphics
Import Brl.Random

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
PositionEntity light,5,5,5

Local sphere:TMesh
Local s_tex1:TTexture=LoadTexture("../media/tmp27.jpg",1+8)
Local s_tex2:TTexture=LoadTexture("../media/water.bmp",1+8)
Local s_tex3:TTexture=LoadTexture("../media/Moss.bmp",1+8)
For Local r:Int=0 To 6
	For Local t:Int=-2 To 2
		sphere=CreateSphere()
		PositionEntity sphere,(t*4),1,(t*4)+((r-2)*8)
		If r Mod 3=1 EntityTexture sphere,s_tex1
		If r Mod 3=2 EntityTexture sphere,s_tex2
		If r Mod 3=0 EntityTexture sphere,s_tex3
	Next
Next

Local cube:TMesh=LoadMesh("../media/wcrate1.3ds")
ScaleMesh cube,0.15,0.15,0.15
PositionEntity cube,0,8,40
Local cube_tex:TTexture=LoadTexture("../media/crate.bmp",1+8)
EntityTexture cube,cube_tex

Global colortex:TTexture=CreateTexture(width,height,1+256)
Global depthtex:TTexture=CreateTexture(width,height,1+256)
ScaleTexture colortex,1.0,-1.0
ScaleTexture depthtex,1.0,-1.0

' in GL 2.0 render textures need attached before other textures (EntityTexture)
CameraToTex colortex,camera
DepthBufferToTex depthtex,camera
TGlobal.CheckFramebufferStatus(GL_FRAMEBUFFER_EXT) ' check for framebuffer errors

' screen sprite - by BlitzSupport
Global screensprite:TSprite=CreateSprite()
ScaleSprite screensprite,1.0,Float( GraphicsHeight() ) / GraphicsWidth() ' 0.75
EntityOrder screensprite,-1
EntityParent screensprite,camera
MoveEntity screensprite,0,0,1.0 ' set z to 1.0

Global screensprite2:TSprite=CreateSprite()
ScaleSprite screensprite2,1.0,Float( GraphicsHeight() ) / GraphicsWidth() ' 0.75
EntityOrder screensprite2,-1
EntityParent screensprite2,camera
MoveEntity screensprite2,0,0,1.0 ' set z to 1.0
EntityTexture screensprite2,depthtex

PositionEntity camera,0,3,0 ' move camera now sprite is parented to it
MoveEntity camera,0,0,-25

Local ground:TMesh=CreatePlane(128)
Local ground_tex:TTexture=LoadTexture("../media/Envwall.bmp")
EntityTexture ground,ground_tex

' Note that the depth/z buffer is non-linear/proportional in eye/view space but linear in screen space
' you can linearize it to visualize it but this will produce incorrect results if used instead of depth
Local shader:TShader=LoadShader("","../glsl/depthoffield.vert.glsl","../glsl/depthoffield.frag.glsl")
ShaderTexture(shader,colortex,"colortex",0) ' 0 is render texture
ShaderTexture(shader,depthtex,"depthtex",1) ' 1 is depth texture
ShadeEntity(screensprite,shader)

Global postprocess%=1
Local blursize#=0.0020
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
	
	PositionEntity postfx_cam,EntityX(camera),EntityY(camera),EntityZ(camera)
	RotateEntity postfx_cam,EntityPitch(camera),EntityYaw(camera),EntityRoll(camera)
	
	TurnEntity cube,0.1,0.2,0.3
	'TurnEntity pivot,0,1,0
	
	UpdateWorld
	UpdateDepthPass()
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,20,"FPS: "+fps
	Text 0,40,"Space: postprocess = "+postprocess+", +/-: blursize = "+blursize
	
	Flip

Wend
End


Function UpdateDepthPass()

	If postprocess=0
		HideEntity postfx_cam
		ShowEntity camera
		HideEntity screensprite2
		HideEntity screensprite
		
		RenderWorld
	ElseIf postprocess=1 ' 2 pass depth
		HideEntity camera
		ShowEntity postfx_cam
		HideEntity screensprite2
		HideEntity screensprite
		
		CameraToTex colortex,postfx_cam
		
		HideEntity postfx_cam
		ShowEntity camera
		
		DepthBufferToTex depthtex,camera
		
		ShowEntity screensprite
		
		RenderWorld
	ElseIf postprocess=2 ' depth
		HideEntity camera
		ShowEntity postfx_cam
		HideEntity screensprite2
		HideEntity screensprite
				
		DepthBufferToTex depthtex,postfx_cam
		
		ShowEntity screensprite2
		HideEntity postfx_cam
		ShowEntity camera
		
		RenderWorld
	EndIf

End Function
