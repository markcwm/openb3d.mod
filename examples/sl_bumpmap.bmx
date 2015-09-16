' sl_bumpmap.bmx
' bumpmapping

Strict

Framework Openb3d.B3dglgraphics

Graphics3D 800,600,0,2


Local cpivot:TPivot=CreatePivot()
Local camera:TCamera=CreateCamera(cpivot)
PositionEntity cpivot,-1,1,-1
CameraRange camera,0.1,1000

Local lpivot:TPivot=CreatePivot()
Local light:TLight=CreateLight(2,lpivot)
PositionEntity light,0,1.2,0
RotateEntity light,90,0,0

Local lpivot2:TPivot=CreatePivot()
Local light2:TLight=CreateLight(2,lpivot2)
PositionEntity light2,0,1.2,2
LightColor light2,200,100,100

' sky
Local sky:TMesh=CreateSphere(32)
Local tex:TTexture=LoadTexture("media/sky.bmp")
ScaleTexture tex,0.5,0.5
EntityTexture sky,tex
ScaleEntity sky,500,500,500
EntityFX sky,1
FlipMesh sky

' room
Local ground:TMesh=CreateCubeUV(8.0,8.0)
ScaleMesh ground,8,0.05,8

Local wall1:TMesh=CreateCubeUV(4.0,1.0)
ScaleMesh wall1,0.05,1,4
PositionEntity wall1,4,1,0
Local wall2:TMesh=CreateCubeUV(4.0,1.0)
ScaleMesh wall2,0.05,1,4
PositionEntity wall2,-4,1,0
Local wall3:TMesh=CreateCubeUV(4.0,1.0)
ScaleMesh wall3,4,1,0.05
PositionEntity wall3,0,1,4

Local sphere:TMesh=CreateSphere()
ScaleEntity sphere,0.5,0.5,0.5
PositionEntity sphere,0,0.5,-2

Local ceiling:TMesh=CreateCubeUV(4.0,4.0)
ScaleMesh ceiling,4,0.05,4
PositionEntity ceiling,0,2,0

Local column:TMesh=CreateCylinder(16)
PositionEntity column,3,1,3
ScaleEntity column,0.5,1,0.5
Local column2:TMesh=CreateCylinder(16)
PositionEntity column2,-3,1,3
ScaleEntity column2,0.5,1,0.5
Local column3:TMesh=CreateCylinder(16)
PositionEntity column3,3,1,-3
ScaleEntity column3,0.5,1,0.5
Local column4:TMesh=CreateCylinder(16)
PositionEntity column4,-3,1,-3
ScaleEntity column4,0.5,1,0.5

Local es#=0.1
EntityShininess(ground,es) ; EntityShininess(ceiling,es)
EntityShininess(wall1,es) ; EntityShininess(wall2,es)
EntityShininess(wall3,es) ; EntityShininess(sphere,es)
EntityShininess(column,es) ; EntityShininess(column2,es)
EntityShininess(column3,es) ; EntityShininess(column4,es)

Local colortex:TTexture=LoadTexture("media/07_DIFFUSE.jpg")
Local normaltex:TTexture=LoadTexture("media/07_NORMAL.jpg")
Local spectex:TTexture=LoadTexture("media/07_DISP.jpg")

' bumpmap 1 - one light, directional or point
Local shader:TShader=LoadShader("","shaders/bumpmap.vert.glsl","shaders/bumpmap.frag.glsl")
ShaderTexture(shader,colortex,"colorMap",0)
ShaderTexture(shader,normaltex,"normalMap",1)

SetFloat3(shader,"vTangent",0.1,0.1,0.1)
SetFloat(shader,"invRadius",0.01)

' bumpmap 2 - no directional, multiple point lights
Local shader2:TShader=LoadShader("","shaders/bumpmap2.vert.glsl","shaders/bumpmap2.frag.glsl")
ShaderTexture(shader2,colortex,"colorMap",0)
ShaderTexture(shader2,normaltex,"normalMap",1)

SetFloat4(shader2,"tangent",0.1,0.1,0.1,0.1)
SetFloat3(shader2,"emission",0.0015,0.0015,0.0015)
SetFloat(shader2,"attspec",0.01)

' bumpmap 3 - multiple lights, directional or point
Local shader3:TShader=LoadShader("","shaders/bumpmap3.vert.glsl","shaders/bumpmap3.frag.glsl")
ShaderTexture(shader3,colortex,"colorMap",0)
ShaderTexture(shader3,normaltex,"normalMap",1)
ShaderTexture(shader3,spectex,"specularMap",2)

For Local iradius%=0 To TLight.no_lights[0]-1
	SetFloat(shader3,"lightradius["+iradius+"].Float",0.2)
Next
SetFloat(shader3,"texturescale",1.0)
SetFloat4(shader3,"vambient",0.15,0.15,0.15,0.15)

ShadeEntity(ground,shader) ; ShadeEntity(ceiling,shader)
ShadeEntity(wall1,shader) ; ShadeEntity(wall2,shader)
ShadeEntity(wall3,shader) ; ShadeEntity(sphere,shader)
ShadeEntity(column,shader) ; ShadeEntity(column2,shader)
ShadeEntity(column3,shader) ; ShadeEntity(column4,shader)

Local clr#, cfb#, cud#
Local lightmode%=1
Local bumpmode%=0
Local max2dmode%=0
Local debuglight%=0

' fps code
Local old_ms%=MilliSecs()
Local renders%, fps%

' init mouselook
Local elapsed%
Local time%=MilliSecs()
HideMouse
MoveMouse 0,0

' init light parameters - for default values comment out RenderWorld
RenderWorld
TLight.GetLightValues()
TLight.specular[1,0]=200/255.0 ; TLight.specular[1,1]=100/255.0 ; TLight.specular[1,2]=100/255.0


While Not KeyDown(KEY_ESCAPE)

	' move camera
	clr=0 ; cfb=0 ; cud=0
	If KeyDown(KEY_W) Then cfb:+0.1
	If KeyDown(KEY_S) Then cfb:-0.1
	If KeyDown(KEY_A) Then clr:-0.1
	If KeyDown(KEY_D) Then clr:+0.1
	If KeyDown(KEY_Q) Then cud:+0.1
	If KeyDown(KEY_E) Then cud:-0.1
	MoveEntity cpivot,clr,cud,cfb
	
	' bumpmap mode
	If KeyHit(KEY_B)
		bumpmode:+1 ; If bumpmode=3 Then bumpmode=0
		If bumpmode=0			
			ShadeEntity(ground,shader) ; ShadeEntity(ceiling,shader)
			ShadeEntity(wall1,shader) ; ShadeEntity(wall2,shader)
			ShadeEntity(wall3,shader) ; ShadeEntity(sphere,shader)
			ShadeEntity(column,shader) ; ShadeEntity(column2,shader)
			ShadeEntity(column3,shader) ; ShadeEntity(column4,shader)
		ElseIf bumpmode=1
			ShadeEntity(ground,shader2) ; ShadeEntity(ceiling,shader2)
			ShadeEntity(wall1,shader2) ; ShadeEntity(wall2,shader2)
			ShadeEntity(wall3,shader2) ; ShadeEntity(sphere,shader2)
			ShadeEntity(column,shader2) ; ShadeEntity(column2,shader2)
			ShadeEntity(column3,shader2) ; ShadeEntity(column4,shader2)
		ElseIf bumpmode=2
			ShadeEntity(ground,shader3) ; ShadeEntity(ceiling,shader3)
			ShadeEntity(wall1,shader3) ; ShadeEntity(wall2,shader3)
			ShadeEntity(wall3,shader3) ; ShadeEntity(sphere,shader3)
			ShadeEntity(column,shader3) ; ShadeEntity(column2,shader3)
			ShadeEntity(column3,shader3) ; ShadeEntity(column4,shader3)
		EndIf
	EndIf
	
	' light mode
	If KeyHit(KEY_L) Then lightmode:+1 ; If lightmode=3 Then lightmode=0
	If lightmode=0 ' static
		RotateEntity light,0,0,0
		PositionEntity light,0,1.2,0 ; PositionEntity lpivot,0,0,0
	EndIf
	If lightmode=1 ' pivoting
		PositionEntity light,0,1.2,3 ; TurnEntity lpivot,0,3,0
		PositionEntity light2,0,1.2,3 ; TurnEntity lpivot2,0,-3,0
	EndIf
	If lightmode=2 ' from camera
		PositionEntity light,0,1.2,0 ; RotateEntity lpivot,0,0,0
		RotateEntity light,EntityPitch(camera),EntityYaw(camera),0
		PositionEntity light,EntityX(cpivot),EntityY(cpivot),EntityZ(cpivot)
	EndIf
	
	' max2d mode
	If KeyHit(KEY_M) Then max2dmode=Not max2dmode
	
	' debug light parameters
	If KeyHit(KEY_P) Then debuglight=Not debuglight
	
	MouseLook(cpivot,camera,time,elapsed)
	
	TurnEntity(sphere,0,0.5,-0.1)
	
	RenderWorld
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps
	Text 0,20,"WSAD: move camera, B: bumpmap mode = "+bumpmode+", L: light mode = "+lightmode
	Text 0,40,"M: Max2d mode, P: debug light parameters"
	
	If debuglight
		DebugLightValues( 80,1 ) ' ypos,light_no
	EndIf
	
	If max2dmode
		BeginMax2D()
		DrawText "Testing Max2d",0,60
		EndMax2D()
	EndIf
	
	' fix for gl_LightSourceParameters not being restored after Max2d
	TLight.SetLightValues()
	
	Flip
	
Wend
End


' debug with Text ypos, i = light_no
Function DebugLightValues( ypos%,i%=0 )

	Text 0,ypos,"ambient="+TLight.ambient[i,0]+" "+TLight.ambient[i,1]+" "+TLight.ambient[i,2]+" "+TLight.ambient[i,3]
	Text 0,ypos+20,"diffuse="+TLight.diffuse[i,0]+" "+TLight.diffuse[i,1]+" "+TLight.diffuse[i,2]+" "+TLight.diffuse[i,3]
	Text 0,ypos+40,"specular="+TLight.specular[i,0]+" "+TLight.specular[i,1]+" "+TLight.specular[i,2]+" "+TLight.specular[i,3]
	Text 0,ypos+60,"position="+TLight.position[i,0]+" "+TLight.position[i,1]+" "+TLight.position[i,2]+" "+TLight.position[i,3]
	Text 0,ypos+80,"spotDirection="+TLight.spotDirection[i,0]+" "+TLight.spotDirection[i,1]+" "+TLight.spotDirection[i,2]
	Text 0,ypos+100,"spotExponent="+TLight.spotExponent[i,0]+" spotCutoff="+TLight.spotCutoff[i,0]
	Text 0,ypos+120,"constantAtt="+TLight.constantAtt[i,0]+" linearAtt="+TLight.linearAtt[i,0]+" quadraticAtt="+TLight.quadraticAtt[i,0]
	
End Function

' camera mouselook (from firepaint3d.bb)
Function MouseLook( pivot:TPivot,camera:TCamera,time%,elapsed% )

	Repeat
		elapsed=MilliSecs()-time
	Until elapsed>0
	
	time=time+elapsed
	Local dt#=elapsed*60.0/1000.0
	
	Local x_speed#,y_speed#
	
	x_speed=((MouseX()-320)-x_speed)/4+x_speed
	y_speed=((MouseY()-240)-y_speed)/4+y_speed
	MoveMouse 320,240

	TurnEntity pivot,0,-x_speed,0	'turn player Left/Right
	TurnEntity camera,y_speed,0,0	'tilt camera
	
End Function

' create a textured cube - tcu/tcv: texture scaling (from Minib3d TMesh.bmx)
Function CreateCubeUV:TMesh( tcu#,tcv#,parent_ent:TEntity=Null )

	Local mesh:TMesh=CreateMesh(parent_ent)
	Local surf:TSurface=CreateSurface(mesh)
	
	AddVertex(surf,-1.0,-1.0,-1.0)
	AddVertex(surf,-1.0, 1.0,-1.0)
	AddVertex(surf, 1.0, 1.0,-1.0)
	AddVertex(surf, 1.0,-1.0,-1.0)
	
	AddVertex(surf,-1.0,-1.0, 1.0)
	AddVertex(surf,-1.0, 1.0, 1.0)
	AddVertex(surf, 1.0, 1.0, 1.0)
	AddVertex(surf, 1.0,-1.0, 1.0)
	
	AddVertex(surf,-1.0,-1.0, 1.0)
	AddVertex(surf,-1.0, 1.0, 1.0)
	AddVertex(surf, 1.0, 1.0, 1.0)
	AddVertex(surf, 1.0,-1.0, 1.0)
	
	AddVertex(surf,-1.0,-1.0,-1.0)
	AddVertex(surf,-1.0, 1.0,-1.0)
	AddVertex(surf, 1.0, 1.0,-1.0)
	AddVertex(surf, 1.0,-1.0,-1.0)

	AddVertex(surf,-1.0,-1.0, 1.0)
	AddVertex(surf,-1.0, 1.0, 1.0)
	AddVertex(surf, 1.0, 1.0, 1.0)
	AddVertex(surf, 1.0,-1.0, 1.0)
	
	AddVertex(surf,-1.0,-1.0,-1.0)
	AddVertex(surf,-1.0, 1.0,-1.0)
	AddVertex(surf, 1.0, 1.0,-1.0)
	AddVertex(surf, 1.0,-1.0,-1.0)

	VertexNormal(surf,0,0.0,0.0,-1.0)
	VertexNormal(surf,1,0.0,0.0,-1.0)
	VertexNormal(surf,2,0.0,0.0,-1.0)
	VertexNormal(surf,3,0.0,0.0,-1.0)
	
	VertexNormal(surf,4,0.0,0.0,1.0)
	VertexNormal(surf,5,0.0,0.0,1.0)
	VertexNormal(surf,6,0.0,0.0,1.0)
	VertexNormal(surf,7,0.0,0.0,1.0)
	
	VertexNormal(surf,8,0.0,-1.0,0.0)
	VertexNormal(surf,9,0.0,1.0,0.0)
	VertexNormal(surf,10,0.0,1.0,0.0)
	VertexNormal(surf,11,0.0,-1.0,0.0)
	
	VertexNormal(surf,12,0.0,-1.0,0.0)
	VertexNormal(surf,13,0.0,1.0,0.0)
	VertexNormal(surf,14,0.0,1.0,0.0)
	VertexNormal(surf,15,0.0,-1.0,0.0)
	
	VertexNormal(surf,16,-1.0,0.0,0.0)
	VertexNormal(surf,17,-1.0,0.0,0.0)
	VertexNormal(surf,18,1.0,0.0,0.0)
	VertexNormal(surf,19,1.0,0.0,0.0)
	
	VertexNormal(surf,20,-1.0,0.0,0.0)
	VertexNormal(surf,21,-1.0,0.0,0.0)
	VertexNormal(surf,22,1.0,0.0,0.0)
	VertexNormal(surf,23,1.0,0.0,0.0)

	VertexTexCoords(surf,0,0.0,tcv)
	VertexTexCoords(surf,1,0.0,0.0)
	VertexTexCoords(surf,2,tcu,0.0)
	VertexTexCoords(surf,3,tcu,tcv)
	
	VertexTexCoords(surf,4,tcu,tcv)
	VertexTexCoords(surf,5,tcu,0.0)
	VertexTexCoords(surf,6,0.0,0.0)
	VertexTexCoords(surf,7,0.0,tcv)
	
	VertexTexCoords(surf,8,0.0,tcv)
	VertexTexCoords(surf,9,0.0,0.0)
	VertexTexCoords(surf,10,tcu,0.0)
	VertexTexCoords(surf,11,tcu,tcv)
	
	VertexTexCoords(surf,12,0.0,0.0)
	VertexTexCoords(surf,13,0.0,tcv)
	VertexTexCoords(surf,14,tcu,tcv)
	VertexTexCoords(surf,15,tcu,0.0)
	
	VertexTexCoords(surf,16,0.0,tcv)
	VertexTexCoords(surf,17,0.0,0.0)
	VertexTexCoords(surf,18,tcu,0.0)
	VertexTexCoords(surf,19,tcu,tcv)
	
	VertexTexCoords(surf,20,tcu,tcv)
	VertexTexCoords(surf,21,tcu,0.0)
	VertexTexCoords(surf,22,0.0,0.0)
	VertexTexCoords(surf,23,0.0,tcv)
	
	AddTriangle(surf,0,1,2) ' front
	AddTriangle(surf,0,2,3)
	AddTriangle(surf,6,5,4) ' back
	AddTriangle(surf,7,6,4)
	AddTriangle(surf,6+8,5+8,1+8) ' top
	AddTriangle(surf,2+8,6+8,1+8)
	AddTriangle(surf,0+8,4+8,7+8) ' bottom
	AddTriangle(surf,0+8,7+8,3+8)
	AddTriangle(surf,6+16,2+16,3+16) ' right
	AddTriangle(surf,7+16,6+16,3+16)
	AddTriangle(surf,0+16,1+16,5+16) ' left
	AddTriangle(surf,0+16,5+16,4+16)
	
	Return mesh
	
EndFunction

' create a textured quad - tcu/tcv: texture scaling
Function CreateQuadUV:TMesh( tcu#,tcz#,parent_ent:TEntity=Null )

	Local mesh:TMesh=CreateMesh(parent_ent)
	Local surf:TSurface=CreateSurface(mesh)
	
	Local v0:Int,v1:Int,v2:Int,v3:Int
	
	v0=AddVertex(surf,-1.0, 0.0,-1.0)
	v1=AddVertex(surf,-1.0, 0.0, 1.0)
	v2=AddVertex(surf, 1.0, 0.0,-1.0)
	v3=AddVertex(surf, 1.0, 0.0, 1.0)
	
	AddTriangle(surf,v0,v1,v3)
	AddTriangle(surf,v2,v0,v3)
	
	VertexTexCoords(surf,v0,0.0,0.0)
	VertexTexCoords(surf,v1,tcu,0.0)
	VertexTexCoords(surf,v2,0.0,tcz)
	VertexTexCoords(surf,v3,tcu,tcz)
	
	UpdateNormals(mesh)
	Return mesh
	
EndFunction
