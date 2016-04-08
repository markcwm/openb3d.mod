' maxgui.bmx

Strict

Framework Openb3d.B3dglgraphics
Import Brl.Timer
Import Brl.EventQueue

?Linux
Import Bah.Gtkmaxgui
?Not Linux
Import Maxgui.Drivers
?

Local flags%=GRAPHICS_BACKBUFFER|GRAPHICS_ALPHABUFFER|GRAPHICS_DEPTHBUFFER|GRAPHICS_STENCILBUFFER|GRAPHICS_ACCUMBUFFER
SetGraphicsDriver GLMax2DDriver(),flags ' before SetGraphics

Local win:TGadget=CreateWindow("MiniB3D in a GUI window",10,10,512,512)

Local can:TGadget=CreateCanvas(0,0,ClientWidth(win),ClientHeight(win),win,0)
SetGadgetLayout can,1,1,1,1
ActivateGadget can ' set focus
EnablePolledInput can ' to activate mouse and keys

SetGraphics CanvasGraphics(can)
Graphics3D ClientWidth(win),ClientHeight(win),0,2,60,-1,True ' true if using canvas


Local cam:TCamera=CreateCamera()
PositionEntity cam,0,0,-10

Local light:TLight=CreateLight(1)

Local tex:TTexture=LoadTexture("../media/test.png")

Local cube:TMesh=CreateCube()
Local sphere:TMesh=CreateSphere()
Local cylinder:TMesh=CreateCylinder()
Local cone:TMesh=CreateCone() 

PositionEntity cube,-6,0,0
PositionEntity sphere,-2,0,0
PositionEntity cylinder,2,0,0
PositionEntity cone,6,0,0

EntityTexture cube,tex
EntityTexture sphere,tex
EntityTexture cylinder,tex
EntityTexture cone,tex

Local renders%, fps%, old_ms%=MilliSecs() ' used by fps code
Local left_mouse%, mouse_x%, mouse_y%

CreateTimer(60)


While Not KeyDown(KEY_ESCAPE)

	WaitEvent()
	
	Select EventID()
			
		Case EVENT_WINDOWCLOSE
			End
			
		Case EVENT_WINDOWSIZE
			
		Case EVENT_WINDOWACTIVATE ' note: in Linux there is no initial EVENT_WINDOWSIZE
			
		Case EVENT_TIMERTICK
			RedrawGadget can
			
		Case EVENT_GADGETPAINT
			UpdateCanvas(can,cam) ' update viewport
			
			left_mouse=0
			If MouseDown(1) Then left_mouse=1
			
			mouse_x=MouseX()
			mouse_y=MouseY()
			
			MoveEntity cam,KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0,KeyDown(KEY_DOWN)-KeyDown(KEY_UP)
			TurnEntity cam,KeyDown(KEY_S)-KeyDown(KEY_W),KeyDown(KEY_A)-KeyDown(KEY_D),0
			
			TurnEntity cube,0,1,0
		
			RenderWorld
			
			' calculate fps
			renders=renders+1
			If MilliSecs()-old_ms>=1000
				old_ms=MilliSecs()
				fps=renders
				renders=0
			EndIf
			
			Text 20,0,"FPS: "+fps
			Text 20,20,"left_mouse:"+left_mouse
			Text 20,40,"mouse_x:"+mouse_x
			Text 20,60,"mouse_y:"+mouse_y
			
			BeginMax2D()
			DrawText "Testing Max2d",ClientWidth(win)-120,0
			EndMax2D()
			
			Flip
			
	EndSelect
	
Wend

' Simplifies using max2d with a resizable canvas - by Hezkore
Function UpdateCanvas(can:TGadget, cam:TCamera)
	SetGraphics(CanvasGraphics(can))
	If TGlobal.width[0] <> ClientWidth(can) Or TGlobal.height[0] <> ClientHeight(can)
		BeginMax2D()
		SetViewport(0, 0, ClientWidth(can), ClientHeight(can))
		EndMax2D()
		
		CameraViewport(cam, 0, 0, ClientWidth(can), ClientHeight(can))
		TGlobal.width[0] = ClientWidth(can) ' values used in texture rendering
		TGlobal.height[0] = ClientHeight(can)
	EndIf
EndFunction
