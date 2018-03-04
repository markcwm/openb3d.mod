' greyscale2.bmx
' using advanced shader functions with shader files

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight(),0,2

Local camera:TCamera=CreateCamera()
CameraClsColor camera,0,125,250

Local light:TLight=CreateLight()

Local cube:TMesh=CreateCube()
PositionEntity cube,-1.5,0,4

Local cube2:TMesh=CreateCube()
PositionEntity cube2,1.5,0,4

Local cone:TMesh=CreateCone()
PositionEntity cone,0,0,10
ScaleEntity cone,4,4,4

Local plane:TMesh=CreateCube()
ScaleEntity plane,10,0.1,10
MoveEntity plane,0,-1.5,0

Local shader:TShader=CreateShaderMaterial("")
Local fragshader:TShaderObject=CreateFragShader(shader,"../glsl/greyscale.frag.glsl")
Local vertshader:TShaderObject=CreateVertShader(shader,"../glsl/default.vert.glsl")
AttachFragShader(shader,fragshader)
AttachVertShader(shader,vertshader)

ShaderTexture(shader,LoadTexture("../media/colorkey.jpg"),"texture0",0)
ShadeEntity(cube,shader)
EntityFX(cube,32)

Local shader2:TShader=CreateShaderMaterial("")
Local fragshader2:TShaderObject=CreateFragShader(shader2,"../glsl/default.frag.glsl")
Local vertshader2:TShaderObject=CreateVertShader(shader2,"../glsl/default.vert.glsl")
AttachFragShader(shader2,fragshader2)
AttachVertShader(shader2,vertshader2)

ShaderTexture(shader2,LoadTexture("../media/colorkey.jpg"),"texture0",0)
ShadeEntity(cube2,shader2)
EntityFX(cube2,32)

Local del%=0


While Not KeyDown(KEY_ESCAPE)

	' turn cubes
	If KeyDown(KEY_LEFT)
		TurnEntity cube,0,-0.5,0.1
		TurnEntity cube2,0,0.5,-0.1
	EndIf
	If KeyDown(KEY_RIGHT)
		TurnEntity cube,0,0.5,-0.1
		TurnEntity cube2,0,-0.5,0.1
	EndIf
	
	' delete shader object
	If KeyHit(KEY_D)
		del=Not del
		If del
			DeleteVertShader(vertshader)
			DeleteFragShader(fragshader)
			fragshader=CreateFragShader(shader,"../glsl/greyscale.frag.glsl")
			vertshader=CreateVertShader(shader,"../glsl/default.vert.glsl")
			AttachFragShader(shader,fragshader2)
			AttachVertShader(shader,vertshader2)
		Else
			DeleteVertShader(vertshader2)
			DeleteFragShader(fragshader2)
			fragshader2=CreateFragShader(shader,"../glsl/default.frag.glsl")
			vertshader2=CreateVertShader(shader,"../glsl/default.vert.glsl")
			AttachFragShader(shader,fragshader)
			AttachVertShader(shader,vertshader)
		EndIf
	EndIf
	
	RenderWorld
	
	Text 0,20,"Left/Right: turn cubes"+", D: delete shader object = "+del
	
	Flip

Wend
End
