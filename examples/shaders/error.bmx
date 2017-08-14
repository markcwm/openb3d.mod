' error.bmx
' shader error reports

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight(),0,2

Global Shader:TGLShader=New TGLShader

Shader.InitShaders("../glsl/cubemap.vert.glsl","../glsl/cubemap.frag.glsl")
Shader.InitShaders("../glsl/cubemap2.vert.glsl","../glsl/cubemap2.frag.glsl")
Shader.InitShaders("../glsl/cubemap3.vert.glsl","../glsl/cubemap3.frag.glsl")
Shader.InitShaders("../glsl/cubemap4.vert.glsl","../glsl/cubemap4.frag.glsl")

Local cam:TCamera=CreateCamera()

Local cube:TMesh=CreateCube()
PositionEntity cube,0,0,3


While Not KeyDown(KEY_ESCAPE)		

	RenderWorld
	
	TurnEntity cube,0.0,0.5,-0.1
	
	Flip
	
Wend
End
