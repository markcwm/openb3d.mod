' pixelate.bmx
' postprocess effect - render framebuffer to texture for pixeled/voxel style

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

Local size:Int=256, vsize:Float=30, maxheight:Float=10
Local terrain:TTerrain=LoadTerrain("../media/heightmap_256.BMP") ' path case-sensitive on Linux
ScaleEntity terrain,1,(1*maxheight)/vsize,1 ' set height
terrain.UpdateNormals() ' correct lighting

terrain.UpdateNormals()
PositionEntity terrain,-size/2,-10,size/2

' Texture terrain
Local grass_tex:TTexture=LoadTexture( "../media/terrain-1.jpg" )
EntityTexture terrain,grass_tex
ScaleTexture grass_tex,10,10

Local pivot:TPivot=CreatePivot()
PositionEntity pivot,0,0,0
Local anim_time:Float
Local anim_ent:TMesh=LoadAnimMesh("../media/zombie.b3d",pivot)
PositionEntity anim_ent,0,0,12
TurnEntity anim_ent,0,-90,0

Local cube:TMesh=LoadMesh("../media/wcrate1.3ds")
ScaleMesh cube,0.15,0.15,0.15
PositionEntity cube,0,3,0
Local cube_tex:TTexture=LoadTexture("../media/crate.bmp",1)
EntityTexture cube,cube_tex
TurnEntity cube,0,45,0

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

Local shader:TShader=LoadShader("","../glsl/default.vert.glsl", "../glsl/pixelate.frag.glsl")
ShaderTexture(shader,colortex,"sceneTex",0) ' Our render texture
SetFloat(shader,"rt_w", width)
SetFloat(shader,"rt_h", height)
SetFloat(shader,"pixel_w", 3.0)
SetFloat(shader,"pixel_h", 3.0)
ShadeEntity(screensprite, shader)

Global postprocess%=1
Local time#=0, framerate#=60.0, animspeed#=10
Local timer:TTimer=CreateTimer(framerate)
UseFloat(shader,"time",time) ' Time used to scroll the distortion map

' fps code
Local old_ms%=MilliSecs()
Local renders%, fps%


While Not KeyHit(KEY_ESCAPE)
	
	time=Float((TimerTicks(timer) / framerate) * animspeed)
	
	If KeyDown(KEY_MINUS) Then anim_time#=anim_time#-0.1
	If KeyDown(KEY_EQUALS) Then anim_time#=anim_time#+0.1
	
	anim_time:+0.5
	If anim_time>20 Then anim_time=2
	SetAnimTime(anim_ent,anim_time)
	TurnEntity pivot,0,1,0
	
	If KeyHit(KEY_SPACE) Then postprocess=Not postprocess
	
	' control camera
	If KeyDown( KEY_RIGHT )=True Then TurnEntity camera,0,-1,0
	If KeyDown( KEY_LEFT )=True Then TurnEntity camera,0,1,0
	If KeyDown( KEY_DOWN )=True Then MoveEntity camera,0,0,-0.25
	If KeyDown( KEY_UP )=True Then MoveEntity camera,0,0,0.25
	
	PositionEntity postfx_cam,EntityX(camera),EntityY(camera),EntityZ(camera)
	RotateEntity postfx_cam,EntityPitch(camera),EntityYaw(camera),EntityRoll(camera)
		
	UpdateWorld
	Update1Pass()
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,20,"FPS: "+fps
	Text 0,40,"Space: postprocess = "+postprocess
	Text 0,60,"anim_time="+anim_time
	
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
