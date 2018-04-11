' advanced_3d_sound.bmx

SuperStrict

Framework Openb3d.B3dglgraphics
Import Openb3d.B3dsound

?Not Win32
Import Brl.FreeAudioAudio
?Win32
Import Brl.DirectSoundAudio
?
Import Brl.WavLoader
Import Brl.OggLoader

Graphics3D DesktopWidth(),DesktopHeight(),0,2

Global Camera:TCamera = CreateCamera()
PositionEntity(Camera, 0, 0, -20)

Global Light:TLight = CreateLight(1)
RotateEntity(Light, 90, 0, 0)

Global SampleSound:TSound = LoadSound("../media/sample.wav") ' load a regular sound
Global SampleSoundLoop:TSound = LoadSound("../media/sampleLoop.wav", SOUND_LOOP) ' load a looping sound

Global TheBox:TMesh = CreateCube()
PositionEntity(TheBox, 10, 0 ,0)
Local BoxTex:TTexture = LoadTexture("../media/crate.bmp")
EntityTexture TheBox,BoxTex

Global TheSphere:TMesh = CreateSphere(16)
PositionEntity(TheSphere, -10, 0 ,0)
Local SphereTex:TTexture = LoadTexture("../media/Ball.bmp")
EntityTexture TheSphere,SphereTex

' Initialize 3D sound system. Sets camera as the listen point with sound heard up to 200 units away.
' The doppler exaggerate of 25 makes it sound like everything is moving 25 times faster than it is.
Init3DSound(Camera, 200, 25)

' The box will be continually playing a looping sound. We put the sound point it creates into a variable
' so we can play it later. We also are queing this sound so it will not start until the sound is
' unpaused by pressing the E key.
Global LoopingSoundPoint:SoundPoint = Que3DSound(SampleSoundLoop, TheBox)


While Not KeyHit(KEY_ESCAPE)

	' Move camera
	MoveEntity Camera,0,0,KeyDown(KEY_UP)-KeyDown(KEY_DOWN)
	TurnEntity Camera,0,KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	' Make TheSphere play the loaded SampleSound
	If KeyHit(KEY_SPACE)
		Start3DSound(SampleSound, TheSphere)
	EndIf
	
	' Pause
	If KeyHit(KEY_E)
		If LoopingSoundPoint.Paused Then ' if the looping sound is paused, unpause it
			LoopingSoundPoint.Paused = False
		Else
			LoopingSoundPoint.Paused = True ' pause it
		EndIf
	EndIf
	
	' Loudness
	If KeyHit(KEY_L)
		If LoopingSoundPoint.Loudness = 1 ' if the looping sound is at full loudness, set it to half
			LoopingSoundPoint.Loudness = 0.5
		Else
			LoopingSoundPoint.Loudness = 1 ' full loudness
		EndIf
	EndIf
	
	' Pan
	' Useful if the sound is coming from roughly the same point as the listening object, to prevent it
	' getting stuck in 1 speaker. This same method can be used for play rate, depth and volume as well.
	If KeyHit(KEY_P)
		If LoopingSoundPoint.PanBump = 0 ' if the looping sound is not modifying it's panning
			LoopingSoundPoint.PanBump = UPDATE_DISABLED ' disable updating of panning
			
			' center panning, if we didn't do this panning would stay at it's last value as we
			' have disabled it from updating
			LoopingSoundPoint.Pan = 0
		Else
			LoopingSoundPoint.PanBump = 0 ' panning modifier to 0, disabling panning modification
		EndIf
	EndIf
	
	' Rate
	' Useful if you want to modify a sound (normally done with SetChannelRate, etc.) but you still want
	' it to be manipulated by the 3D sound system ie. engine pitch goes up when you step on the gas, but
	' you still want the doppler effect, which requires the 3d sound system to modify the play rate.
	' This same method can be used for panning, depth and volume as well.
	If KeyHit(KEY_R)
		If LoopingSoundPoint.RateBump = 0 ' if the looping sound is not modifying it's play rate
			LoopingSoundPoint.RateBump = 1 ' bumps the play rate up by 1 after it's 3D rate is calculated
		Else
			LoopingSoundPoint.RateBump = 0 ' panning modifier to 0, disabling rate modification
		EndIf
		
	EndIf
	
	' Reset camera to its starting positon
	' This allows you to move the listen point a great distance without that move being calculated
	' as a large burst of speed by the doppler effect.
	If KeyHit(KEY_X)
		PositionEntity(camera, 0, 0, -20)
		RotateEntity(camera, 0, 0, 0)
		
		DopplerFrameSkip() ' disable doppler effect for 1 frame
	EndIf
	
	' This is not as fast as just calling EntityStop3DSound but it is a good example of List3DSounds
	' as well as stopping an individual sound. You could use this to do any other modifications to
	' sounds as a group, such as change their loudness.	
	If KeyHit(KEY_S)
		Local tempSoundPoint:SoundPoint ' temporary place to access a sound point
		
		' List3DSounds returns a TList of all the SoundPoints currently attached to an entity.
		For tempSoundPoint = EachIn List3DSounds(TheSphere)
		
			' calling Stop3DSound will stop the sound immediately and clear it's resources on the next
			' update, a sound point may also be stopped by calling its Stop method.
			Stop3DSound(tempSoundPoint)
		Next
		
		' Also note: if an entity is freed all sounds attached to that entity will stop. If you want
		' a sound to continue from a point even after freeing the entity, attach a pivot to the entity
		' and attach the sound to the pivot. When you free the entity the pivot will retain the sound.
		' You can then remove the pivot when there are no more sounds attached to it.
	EndIf
	
	' Stop all sounds attached to TheSphere
	If KeyHit(KEY_D)
		EntityStop3DSound(TheSphere)
	EndIf
	
	UpdateWorld
	
	' Update the positional information and sound channels for all playing 3D sounds
	Update3DSounds()
	
	RenderWorld
	
	Text 0,20,"Arrow keys: move and turn"
	Text 0,40, "Space: play sound from Sphere, currently playing: "+CountList(List3DSounds(TheSphere))+" sounds"
	Text 0,60, "E: toggle pause value of looping sound from Box, currently: "+LoopingSoundPoint.Paused
	Text 0,80, "L: toggle loudness of looping sound from Box, currently: "+LoopingSoundPoint.Loudness
	Text 0,100, "P: toggle panning effect of looping sound from Box, current panning is: "+LoopingSoundPoint.Pan
	Text 0,120, "R: toggle bump to the play rate of looping sound from Box .."
	Text 0,140, ".. currently bump is: "+LoopingSoundPoint.RateBump+" and actual rate is "+LoopingSoundPoint.Rate
	Text 0,160, "X: reset camera to starting point"
	Text 0,180, "S: stop each sound coming from Sphere in a loop"
	Text 0,200, "D: stop all sounds coming from Sphere"
	
	Flip
	GCCollect
Wend
End
