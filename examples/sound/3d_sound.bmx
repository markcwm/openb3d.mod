' 3d_sound.bmx

SuperStrict

Framework Openb3d.B3dglgraphics
Import Openb3d.B3dsound
?Linux
Import Brl.FreeAudioAudio
?Win32
Import Brl.DirectSoundAudio
?
Import Brl.WavLoader
Import Brl.OggLoader

Graphics3D 800,600,0,2


Global Camera:TCamera = CreateCamera()
PositionEntity(camera, 0, 0, -20)

Global Light:TLight = CreateLight(1)
RotateEntity(Light, 90, 0, 0)

Global SampleSound:TSound = LoadSound("../media/sample.wav")
' Normal sound flags still apply, see Audio docs for more info

Global TheBox:TMesh = CreateCube()
' This can be any kind of 3d Object For the purposes of emiting sound (pivot, entity, mesh, camera, light, etc.)

Init3DSound(Camera, 300)
' Initializes the 3D sound system. Sets the Camera as the listen point with sound heard up to 300 units away.

' To enable doppler effect, add the dopple exaggerate value after the the maximum distance value.
' Example: Init3DSound(Camera, 300, 25)
' Doppler effect is relative to movement speed so if your game moves faster than 1 unit per cycle
' then a lower Doppler exaggerate value will be needed. A higher value will make the doppler effect more
' pronounced. Experiment to find the best results in your movement system.

While Not KeyHit(KEY_Escape)

	' move camera
	MoveEntity camera,0,0,KeyDown(KEY_UP)-KeyDown(KEY_DOWN)
	TurnEntity camera,0,KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	' make TheBox play the loaded SampleSound
	If KeyHit(KEY_Space)
		Start3DSound(SampleSound, TheBox)
	EndIf
	
	UpdateWorld
	
	Update3DSounds() ' Updates the positional information and sound channels for all playing 3D Sounds
	
	RenderWorld
		
	Text 0,0,"Arrow Keys Move and Turn"
	Text 0,15,"Space plays sound from box"
	Text 0,30,"Escape to Exit"
	
	Flip()
		
Wend
