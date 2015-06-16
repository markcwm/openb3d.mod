' maxgui.bmx
' from minib3d examples (Based on code by Birdie and Peter Scheutz)

Strict

Framework angros.b3dglgraphics
Import Brl.Timer
Import Brl.EventQueue

?Linux
Import bah.gtkmaxgui
?Not Linux
Import maxgui.drivers
?

Local scene:TScene=New TScene

While True

	scene.EventLoop()
	
Wend


Type TScene

	Global resized%=False
	
	Field win:TGadget
	Field can:TGadget
	
	Field cam:TCamera
	Field light:TLight
	Field tex:TTexture
	Field cube:TMesh
	Field sphere:TMesh
	Field cylinder:TMesh
	Field cone:TMesh
	
	Field cx#=0, cy#=0, cz#=0
	Field pitch#=0, yaw#=0, roll#=0
	
	Field old_ms%, renders%, fps%
	Field up_key%, down_key%, left_key%, right_key%
	Field left_mouse%, mouse_x%, mouse_y%
	
	Method New()
	
		SetGraphicsDriver GLMax2DDriver() ' needed in Windows
		
		win=CreateWindow("MiniB3D in a GUI window",10,10,512,512)
		
		can=CreateCanvas(0,0,ClientWidth(win),ClientHeight(win),win,0)
		SetGadgetLayout can,1,1,1,1
		
		SetGraphics CanvasGraphics(can)
		Graphics3D ClientWidth(win),ClientHeight(win),0,2,60,-1,True ' true if using a canvas
		
		AddHook EmitEventHook,ResizeHook
		
		InitScene()
		
	End Method
	
	Method InitScene()
	
		cam=CreateCamera()
		PositionEntity cam,0,0,-10
		
		light=CreateLight(1)
		
		tex=LoadTexture("media/test.png")
		
		cube=CreateCube()
		sphere=CreateSphere()
		cylinder=CreateCylinder()
		cone=CreateCone() 
		
		PositionEntity cube,-6,0,0
		PositionEntity sphere,-2,0,0
		PositionEntity cylinder,2,0,0
		PositionEntity cone,6,0,0
		
		EntityTexture cube,tex
		EntityTexture sphere,tex
		EntityTexture cylinder,tex
		EntityTexture cone,tex
		
		old_ms%=MilliSecs()
		
		CreateTimer(60)
		
	End Method
	
	Method EventLoop()
	
		WaitEvent()
		
		Select EventID()
		
			Case EVENT_MOUSEDOWN
			
				If EventData()=MOUSE_LEFT Then left_mouse=1	
							
			Case EVENT_MOUSEUP
			
				If EventData()=MOUSE_LEFT Then left_mouse=0
							
			Case EVENT_MOUSEMOVE
			
				mouse_x=EventX()
				mouse_y=EventY()
				
			Case EVENT_KEYDOWN
			
				Select EventData()
					Case KEY_ESCAPE
						End
					Case KEY_UP
						up_key=True
					Case KEY_DOWN
						down_key=True
					Case KEY_LEFT
						left_key=True
					Case KEY_RIGHT
						right_key=True	
				EndSelect
				
			Case EVENT_KEYUP
			
				Select EventData()
					Case KEY_UP
						up_key=False
					Case KEY_DOWN
						down_key=False
					Case KEY_LEFT
						left_key=False
					Case KEY_RIGHT
						right_key=False	
				EndSelect
				
			Case EVENT_WINDOWCLOSE
			
				End
				
			Case EVENT_WINDOWSIZE
			
				DebugLog "EVENT_WINDOWSIZE"
				
			Case EVENT_WINDOWACTIVATE
			
				DebugLog "EVENT_WINDOWACTIVATE"
				
			Case EVENT_TIMERTICK
			
				UpdateScene()
				
			Case EVENT_GADGETPAINT
			
				If EventSource()=can Then DrawScene()
				
		EndSelect
		
	End Method
	
	Function ResizeHook:Object(iId:Int,tData:Object,tContext:Object)
	
		Local Event:TEvent=TEvent(tData)
		
		If Event=Null Return Null
		Select Event.ID
		
			Case EVENT_WINDOWSIZE
			
				resized=True
				BeginMax2D() ' pop old values
				
			Case EVENT_WINDOWACTIVATE ' when created, restored or moved
			
				resized=True
				BeginMax2D() ' needed in Linux, due to no initial EVENT_WINDOWSIZE
			
		EndSelect
		
		Return tData
		
	End Function
	
	Method ResizeViewport()
	
		If resized=True
			SetViewport 0,0,ClientWidth(win),ClientHeight(win)
			EndMax2D() ' push new values
			
			CameraViewport cam,0,0,ClientWidth(win),ClientHeight(win)
			GraphicsResize ClientWidth(win),ClientHeight(win) ' values used in texture rendering
			resized=False
		EndIf
		
	End Method
	
	Method UpdateScene()
	
		If up_key Then cz#=cz#+1.0
		If left_key Then cx#=cx#-1.0
		If right_key Then cx#=cx#+1.0
		If down_key Then cz#=cz#-1.0
		
		MoveEntity cam,cx#*0.5,cy#*0.5,cz#*0.5
		RotateEntity cam,pitch#,yaw#,roll#
		
		cx#=0
		cy#=0
		cz#=0
		
		TurnEntity cube,0,1,0
		
		RedrawGadget can
		
	End Method
	
	Method DrawScene()
	
		SetGraphics CanvasGraphics(can)
		ResizeViewport()
		
		RenderWorld
		
		Text 20,0,"Text"
		Text 20,20,"left_mouse:"+left_mouse
		Text 20,40,"mouse_x:"+mouse_x
		Text 20,60,"mouse_y:"+mouse_y
		
		BeginMax2D()
		UpdateMax2D()
		EndMax2D()
		
		Flip
		
	End Method
	
	Method UpdateMax2D()
	
		DrawText "DrawText",ClientWidth(win)-100,0
		
	End Method
	
End Type
