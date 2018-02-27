' textbox.bmx

SuperStrict

Framework Openb3d.B3dglgraphics

Import Brl.FreeTypeFont

Import Ifsogui.GUI
Import Ifsogui.Panel
Import Ifsogui.Window
Import Ifsogui.Label
Import Ifsogui.Listbox
Import Ifsogui.Checkbox
Import Ifsogui.Button
Import Ifsogui.Mclistbox

Local sample:TSample=New TSample

sample.Init3D()
sample.InitGUI()

While Not KeyDown(KEY_ESCAPE)

	sample.Update3D()
	
	BeginMax2D()
	sample.UpdateGUI()
	EndMax2D()
	
	Flip 0
	Cls
	
Wend
End


Type TSample

	Field camera:TCamera
	Field light:TLight
	Field cube:TMesh, tex:TTexture
	Field cone:TMesh, tex2:TTexture
	
	Field iFPSCounter:Int, iFPSTime:Int, iFPS:Int ' FPS Counter
	Field efx%=1
	
	Method Init3D()
	
		Graphics3D DesktopWidth(),DesktopHeight(),0,2
		
		camera=CreateCamera()
		CameraClsColor camera,80,160,240
		
		light=CreateLight()
		
		cube=CreateCube()
		PositionEntity cube,1.5,0,4
		tex=LoadTexture("../media/alpha_map.png")
		EntityTexture(cube,tex)
		EntityFX(cube,32)
		
		cone=CreateCone()
		PositionEntity cone,0,0,10
		ScaleEntity cone,4,4,4
		tex2=LoadTexture("../media/sand.bmp")
		EntityTexture(cone,tex2)
		
	End Method
	
	Method InitGUI()
	
		GUI.SetResolution(DesktopWidth(), DesktopHeight())
		GUI.LoadTheme("Skin2")
		GUI.SetDefaultFont(LoadImageFont("Skin2/fonts/arial.ttf", 12))
		GUI.SetDrawMouse(True)
		
		'Status Window
		Local window:ifsoGUI_Window = ifsoGUI_Window.Create(650, 480, 140, 110, "StatusPanel")
		window.SetDragable(True)
		window.SetCaption("Status Window")
		GUI.AddGadget(window)
		window.AddChild(ifsoGUI_Label.Create(5, 5, 100, 20, "FPSLabel"))
		
		'Control Window
		window = ifsoGUI_Window.Create(20, 20, 400, 400, "win")
		window.SetDragable(True)
		window.SetDragTop(True)
		window.SetResizable(True)
		window.SetCaption("Sample Controls Window")
		window.AddChild(ifsoGUI_Button.Create(5, 5, 50, 25, "button", "Button"))
		window.AddChild(ifsoGUI_TextBox.Create(5, 35, 200, 25, "textbox", "Sample textbox"))
		GUI.AddGadget(window)
		
		SetClsColor(200, 200, 200)
		
	End Method
	
	Method Update3D()
	
		' turn cube
		If KeyDown(KEY_LEFT)
			TurnEntity cube,0,-0.5,0.1
		EndIf
		If KeyDown(KEY_RIGHT)
			TurnEntity cube,0,0.5,-0.1
		EndIf
		If KeyHit(KEY_B)
			efx=Not efx
			If efx Then EntityFX(cube,32) Else EntityFX(cube,0)
		EndIf
		
		RenderWorld
		
		Text DesktopWidth()-380,20,"Left/Right: turn cube"+", B: alpha blending = "+efx
		
	End Method
	
	Method UpdateGUI()
	
		CheckEvents()
		iFPSCounter:+1
		If MilliSecs() - iFPSTime > 1000
			iFPS = iFPSCounter
			iFPSTime = MilliSecs()
			iFPSCounter = 0
			ifsoGUI_Label(GUI.GetGadget("FPSLabel")).SetLabel("FPS: " + iFPS)
		End If
		GUI.Refresh()
		
	End Method
	
	Function CheckEvents()
	
		Local e:ifsoGUI_Event
		Repeat
			e = GUI.GetEvent()
			If Not e Exit
			If e.id = ifsoGUI_EVENT_CHANGE Or e.id = ifsoGUI_EVENT_CLICK
				DebugLog "NAME: " + e.gadget.Name + " EVENT: " + e.EventString(e.id) + " DATA: " + e.data
			End If
		Forever
		
	End Function

End Type
