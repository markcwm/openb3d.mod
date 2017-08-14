' texturefilter.bmx

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight(),0,2

Local camera:TCamera=CreateCamera()

Local light:TLight=CreateLight()

ClearTextureFilters
TextureFilter "crate",1

Local cube:TMesh=CreateCube()
PositionEntity cube,-1.5,0,3

Local cube2:TMesh=LoadMesh("../media/wcrate.3ds")
ScaleEntity cube2,0.05,0.05,0.05
RotateEntity cube2,0,180,0
PositionEntity cube2,1.5,0,4

Local cone:TMesh=CreateCone()
PositionEntity cone,0,0,10
ScaleEntity cone,4,4,4

Local plane:TMesh=CreateCube()
ScaleEntity plane,10,0.1,10
MoveEntity plane,0,-1.5,0

Local shader:TShader=LoadShader("","../glsl/default.vert.glsl","../glsl/default.frag.glsl")
Local tex1:TTexture=LoadTexture("../media/crate.bmp")
Local shader_tex:TTexture=ShaderTexture(shader,tex1,"texture0",0)
ShadeEntity(cube,shader)

Local shader2:TShader=LoadShader("","../glsl/default.vert.glsl","../glsl/default.frag.glsl")
Local tex2:TTexture=LoadTexture("../media/wcrate.jpg")
Local shader2_tex:TTexture=ShaderTexture(shader2,tex2,"texture0",0)
ShadeEntity(cube2,shader2)

Local tflag%=0


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
		
	' texture filter is nearest (sharp) or linear/mipmap (smooth)
	If KeyHit(KEY_T)
		tflag=Not tflag
		If tflag
			TextureFlags shader_tex,1
			TextureFlags shader2_tex,1
		Else
			TextureFlags shader_tex,1+8
			TextureFlags shader2_tex,1+8
		EndIf
	EndIf
	
	RenderWorld
	
	Text 0,20,"Left/Right: turn cubes"
	
	Flip

Wend
End
