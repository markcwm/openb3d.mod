' usematrix.bmx
' using the camera matrix

Strict

Framework Openb3d.B3dglgraphics

Graphics3D 800,600,0,2


Local camera:TCamera=CreateCamera()
CameraClsColor camera,70,180,235

Local light:TLight=CreateLight()

Local teapot:TMesh=LoadMesh("media/teapot.b3d")

Local shader:TShader=LoadShader("","shaders/usematrix.vert.glsl","shaders/usematrix.frag.glsl")
ShadeEntity(teapot,shader)

Local camz#, tz#=5.5


While Not KeyDown(KEY_ESCAPE)
	
	' use camera matrix
	If KeyHit(KEY_M) Then UseMatrix(shader,"_Object2World",0) ' 0=model matrix
	
	' move teapot
	If KeyDown(KEY_UP) Then tz:+.1
	If KeyDown(KEY_DOWN) Then tz:-.1
	
	' move camera
	If KeyDown(KEY_W) Then camz:+.1
	If KeyDown(KEY_S) Then camz:-.1
	
	TurnEntity teapot,0,0.5,-0.1
	
	PositionEntity teapot,0,0,tz
	PositionEntity camera,0,0,camz
	
	RenderWorld
	
	Text 0,0,"If less than 5m from camera teapot should be color green otherwise grey"
	Text 0,20,"M: use camera matrix, Up/Down: move teapot, W/S: move camera"
	Text 0,40,"Distance: "+Abs(EntityZ(teapot)-EntityZ(camera))
	
	Flip

Wend
End
