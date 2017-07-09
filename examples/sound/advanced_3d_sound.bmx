' advanced_3d_sound.bmx

SuperStrict

Framework Openb3d.B3dglgraphics
Import Openb3dMods.B3dsound
?Not Win32
Import Brl.FreeAudioAudio
?Win32
Import Brl.DirectSoundAudio
?
Import Brl.WavLoader
Import Brl.OggLoader

Graphics3D DesktopWidth(),DesktopHeight(),0,2


Global Camera:TCamera = CreateCamera()
PositionEntity(camera, 0, 0, -20)

Global Light:TLight = CreateLight(1)
RotateEntity(Light, 90, 0, 0)

Global SampleSound:TSound = LoadSound("../media/sample.wav") ' Load a regular sound
Global SampleSoundLoop:TSound = LoadSound("../media/sampleLoop.wav", SOUND_LOOP) ' Load a looping sound

Global TheBox:TMesh = CreateCube()
PositionEntity(TheBox, 20, 0 ,0)

Global TheSphere:TMesh = CreateSphere(16)

Init3DSound(Camera, 200, 25)
' Initializes the 3D sound system. Sets the Camera as the listen point with sound heard up to 200 units away.
' There is a doppler exaggerate of 25 which for the purposes of the doppler effect makes it sound everything is
' moving 25 times faster than it is.

Global LoopingSoundPoint:SoundPoint = Que3DSound(SampleSoundLoop, TheBox)
' the box will be continually playing a looping sound. we put the sound point that creates into a variable
' so we can play it it later. We also are Queing this sound so it will not start till the sound is unpaused by
' pressing the E key.


While Not KeyHit(KEY_ESCAPE)

	' move camera
	MoveEntity camera,0,0,KeyDown(KEY_UP)-KeyDown(KEY_DOWN)
	TurnEntity camera,0,KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	' make TheSphere play the loaded SampleSound
	If KeyHit(KEY_SPACE)
		Start3DSound(SampleSound, TheSphere)
	EndIf
	
	' pause
	If KeyHit(KEY_E)
		If LoopingSoundPoint.Paused Then ' if the looping sound coming from the box is paused, unpause it
			LoopingSoundPoint.Paused = False
		Else
			LoopingSoundPoint.Paused = True ' pause it
		EndIf
	EndIf
	
	' loudness
	If KeyHit(KEY_L)
		If LoopingSoundPoint.Loudness = 1 Then ' if the looping sound is at full loudness
			LoopingSoundPoint.Loudness = 0.5 ' set it to half loudness
		Else
			LoopingSoundPoint.Loudness = 1 ' otherwise set it to full loudness
		EndIf
	EndIf
	
	' pan
	If KeyHit(KEY_P)
		If LoopingSoundPoint.PanBump = 0 Then ' if the looping sound is not modifying it's panning
			LoopingSoundPoint.PanBump = UPDATE_DISABLED ' disable updating of paning
			LoopingSoundPoint.Pan = 0 ' center the panning.
			' if we didn't do this panning would stay at it's last value as we have disabled it from updating
		Else
			LoopingSoundPoint.PanBump = 0 ' set the panning modifier to 0, disabling panning modification
		EndIf
		' useful if the sound is coming from roughly the same point as the listening object, to prevent it
		' getting stuck in 1 speaker. This same method can be used for play rate, depth and volume as well.
	EndIf
	
	' rate
	If KeyHit(KEY_R)
		If LoopingSoundPoint.RateBump = 0 Then ' if the looping sound is not modifying it's play rate
			LoopingSoundPoint.RateBump = 1 ' bumps the play rate up by 1 after it's 3D rate is calculated
		Else
			LoopingSoundPoint.RateBump = 0 ' set the panning modifier to 0, disabling rate modification
		EndIf
		' useful if you want to modify a sound (normaly done with SetChannelRate, etc.) but you still want it
		' to be manipulated by the 3D sound system ie. engine pitch goes up when you step on the gas, but
		' you still want the doppler effect, which requires the 3d sound system to modify the play rate.
		' This same method can be used for panning, depth and volume as well.
	EndIf
	
	' Reset the camera to it's starting positon
	If KeyHit(KEY_X)
		PositionEntity(camera, 0, 0, -20)
		RotateEntity(camera, 0, 0, 0)
		
		DopplerFrameSkip() ' disable doppler effect for 1 frame
		' this allows you to move the listen point a great distance without that move being calcualated
		' as a large burst of speed by the doppler effect.
	EndIf
	
	' This is not as fast as just calling EntityStop3DSound() but it is a good example of List3DSounds()
	' as well as stoping an individual sound. You could use this to do any other modifications to
	' sounds as a group, such as change their loudness.	
	If KeyHit(KEY_S)
		Local tempSoundPoint:SoundPoint ' temporary place to access a sound point
		
		' List3DSounds returns a TList of all the SoundPoints currently attached to an entity.
		For tempSoundPoint = EachIn List3DSounds(TheSphere) 
			Stop3DSound(tempSoundPoint)
			' Calling a SoundPoint's stop method will stop the sound immediately and clear it's resources
			' on the next update, a sound point may also be stopped directly by calling it's stop method.
			' Example: tempSoundPoint.Stop()
		Next
		
		' Also of note, if an entity is removed, all sounds attached to that entity will stop.
		' If you want a sound to continue from a point even if you kill the object that the sound is
		' attached to then create and attach a pivot to the entity, then attach the sound to the pivot.
		' Then if you remove the entity the pivot with the sound will remain.
		' You can then remove the pivot when there are no more sounds attached to it.
	EndIf
	
	' Stop all sounds attached to the entity TheSphere
	If KeyHit(KEY_D)
		EntityStop3DSound(TheSphere)
	EndIf
	
	UpdateWorld
	
	Update3DSounds() ' Updates the positional information and sound channels for all playing 3D Sounds
	
	RenderWorld
	
	Text 0,20,"Arrow keys move and turn"
	Text 0,40, "Space plays sound from Sphere, currently playing: "+CountList(List3DSounds(TheSphere))+" sounds"
	Text 0,60, "E to toggle the pause value of the looping sound, currently: "+LoopingSoundPoint.Paused
	Text 0,80, "L to toggle the loudness of the looping sound between full and half, currently: "+LoopingSoundPoint.Loudness
	Text 0,100, "P to toggle the panning effect of the looping sound, current panning is: "+LoopingSoundPoint.Pan
	Text 0,120, "R to toggle the bump to the play rate of the looping sound .."
	Text 0,140, ".. currently bump is: "+LoopingSoundPoint.RateBump+" and actual rate is "+LoopingSoundPoint.Rate
	Text 0,160, "X to reset the camera to it's starting point"
	Text 0,180, "S to stop all sounds that are coming from the sphere using List3DSounds()"
	Text 0,200, "D to stop all sounds that are coming from the sphere using EntityStop3DSound()"
	
	Flip()
	
Wend
