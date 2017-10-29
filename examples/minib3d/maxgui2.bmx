' maxgui2.bmx
' using multiple canvas

Strict

Framework Openb3d.B3dglgraphics

?linux
Import Bah.Gtkmaxgui
?Not linux
Import Maxgui.Drivers
?Not bmxng
Import Brl.Timer
?bmxng
Import Brl.TimerDefault
?
Import Brl.EventQueue
Import Brl.FreetypeFont

' GUI
Local flags%=GRAPHICS_BACKBUFFER|GRAPHICS_ALPHABUFFER|GRAPHICS_DEPTHBUFFER|GRAPHICS_STENCILBUFFER|GRAPHICS_ACCUMBUFFER
SetGraphicsDriver GLMax2DDriver(),flags ' call before SetGraphics
GLShareContexts() ' multiple contexts

Global win:TGadget=CreateWindow("MaxGUI window - position",10,10,512,512)
Global win2:TGadget=CreateWindow("MaxGUI window - rotate",512+60,20,512,512)
Global can:TGadget=CreateCanvas(0,0,ClientWidth(win),ClientHeight(win),win,0)
Global can2:TGadget=CreateCanvas(0,0,ClientWidth(win2),ClientHeight(win2),win2,0)

SetGadgetLayout can,1,1,1,1
SetGadgetLayout can2,1,1,1,1

' Events and 2D
Global left_mouse%, mouse_x%, mouse_y%, click_canvas%, last_x%, last_y%, win_id%=0
Global showtext%=1, currcan:TGadget=can2, drawbothcan%=1
Global key:Int[256]

ActivateGadget can2 ' set focus
EnablePolledInput can2 ' mousex/y

AddHook EmitEventHook, LoopHook

CreateTimer(60)

Global Font:TImageFont = LoadImageFont("../media/arial.ttf", 24)

' 3D
SetGraphics CanvasGraphics(can2)
Graphics3D ClientWidth(win2),ClientHeight(win2),0,2,60,-1,True ' true if using canvas

Global pivot:TPivot=CreatePivot()
Global cam:TCamera=CreateCamera(pivot)
Global camxr#=0, camyr#=0, camxp#=0, camyp#=0, camzp#=-12
Global camxr2#=0, camyr2#=-90, camxp2#=0, camzp2#=-12

Global light:TLight=CreateLight(1)

Global cube:TMesh=CreateCube()
Global sphere:TMesh=CreateSphere()
Global cylinder:TMesh=CreateCylinder()
Global cone:TMesh=CreateCone() 

PositionEntity cube,-6,0,0
PositionEntity sphere,-2,0,0
PositionEntity cylinder,2,0,0
PositionEntity cone,6,0,0

Global tex:TTexture=LoadTexture("../media/test.png")
EntityTexture cube,tex
EntityTexture sphere,tex
EntityTexture cylinder,tex
EntityTexture cone,tex


Repeat
	WaitEvent()
Forever
End


Function LoopHook:Object(id:Int, data:Object, context:Object)

	Local Event:TEvent = TEvent(data)
	If Event = Null Then Return Event
	
	Select Event.id
		Case EVENT_WINDOWCLOSE
			FreeGadget win
			FreeGadget win2
			FreeGadget can
			FreeGadget can2
			End
			
		Case EVENT_APPTERMINATE
			End
			
		Case EVENT_WINDOWSIZE
			 ' note: in Linux there is no initial EVENT_WINDOWSIZE
			
		Case EVENT_WINDOWACTIVATE
			click_canvas=1
			
			Select Event.source
				Case win
					currcan=can
					win_id=1
				Case win2
					currcan=can2
					win_id=2
			EndSelect
			
			' make a new hook if initializing polledinput
			RemoveHook EmitEventHook, LoopHook
			DisablePolledInput()
			ActivateGadget currcan
			EnablePolledInput currcan
			AddHook EmitEventHook, LoopHook
			
		Case EVENT_TIMERTICK
			If Not drawbothcan ' draw only current canvas
				RedrawGadget currcan
			Else
				RedrawGadget can
				RedrawGadget can2
			EndIf
			
		Case EVENT_KEYUP
			Select Event.data
				Case KEY_UP
					key[KEY_UP]=0
				Case KEY_DOWN
					key[KEY_DOWN]=0
				Case KEY_LEFT
					key[KEY_LEFT]=0
				Case KEY_RIGHT
					key[KEY_RIGHT]=0
				Case KEY_W
					key[KEY_W]=0
				Case KEY_S
					key[KEY_S]=0
				Case KEY_A
					key[KEY_A]=0
				Case KEY_D
					key[KEY_D]=0
				Case KEY_SPACE
					key[KEY_SPACE]=0
			End Select
			
		Case EVENT_KEYDOWN
			Select Event.data
				Case KEY_UP
					key[KEY_UP]=1
				Case KEY_DOWN
					key[KEY_DOWN]=1
				Case KEY_LEFT
					key[KEY_LEFT]=1
				Case KEY_RIGHT
					key[KEY_RIGHT]=1
				Case KEY_W
					key[KEY_W]=1
				Case KEY_S
					key[KEY_S]=1
				Case KEY_A
					key[KEY_A]=1
				Case KEY_D
					key[KEY_D]=1
				Case KEY_SPACE
					key[KEY_SPACE]=1
			End Select

		Case EVENT_MOUSEUP
			left_mouse=0
			click_canvas=0
			
		Case EVENT_MOUSEDOWN
			Select Event.data
				Case 1
					If click_canvas=0 Then left_mouse=1 ' no movement on selecting canvas
			End Select
			
		Case EVENT_MOUSEMOVE
			last_x=mouse_x
			last_y=mouse_y
			mouse_x=MouseX()
			mouse_y=MouseY()
			
		Case EVENT_GADGETPAINT
			Select Event.source
				Case can
					If currcan=can And left_mouse=1
						camxp:+Float(last_x-mouse_x)/10
						camyp:+Float(mouse_y-last_y)/10
					EndIf
					
					PositionEntity cam,camxp,camyp,camzp
					RotateEntity pivot,camxr,camyr,0
					RenderScene(can,win)
					
				Case can2
					If currcan=can2 And left_mouse=1
						camxr2:+Float(mouse_y-last_y)/2
						camyr2:+Float(last_x-mouse_x)/2
					EndIf
					
					PositionEntity cam,camxp2,3,camzp2
					RotateEntity pivot,camxr2,camyr2,0
					RenderScene(can2,win2)
					
			EndSelect
	EndSelect
	
End Function

Function RenderScene(canvas:TGadget, window:TGadget)

	UpdateCanvas(canvas,cam) ' update viewport
	
	If key[KEY_SPACE]=1 
		key[KEY_SPACE]=0
		showtext=Not showtext
	EndIf
	
	TurnEntity cube,0,1,0
	
	RenderWorld
	
	If showtext
		BeginMax2D()
		SetBlend ALPHABLEND
		SetColor(0, 255, 0)
		SetImageFont Font
		DrawText "Testing Max2d",ClientWidth(window)-200,40
		EndMax2D()
	EndIf
	
	' call after Max2d
	Text 20,20,"Left mouse: rotate/position camera, Space: toggle Max2d"
	Text 20,40,"left_mouse:"+left_mouse
	Text 20,60,"mouse_x:"+mouse_x
	Text 20,80,"mouse_y:"+mouse_y
	
	Flip -1
	
End Function

' Simplifies using Max2d with a resizable canvas - by Hezkore
Function UpdateCanvas(can:TGadget, cam:TCamera)

	SetGraphics(CanvasGraphics(can))
	
	If TGlobal.width[0] <> ClientWidth(can) Or TGlobal.height[0] <> ClientHeight(can)
		BeginMax2D()
		SetGraphics(CanvasGraphics(can))
		SetViewport(0, 0, ClientWidth(can), ClientHeight(can))
		EndMax2D()
		
		CameraViewport(cam, 0, 0, ClientWidth(can), ClientHeight(can))
		TGlobal.width[0] = ClientWidth(can) ' values used in texture rendering
		TGlobal.height[0] = ClientHeight(can)
	EndIf
	
EndFunction
