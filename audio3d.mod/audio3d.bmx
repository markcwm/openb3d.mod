' audio3d.bmx

SuperStrict

Rem
bbdoc: 3D sound with Brl.Audio
about: You must stop all sounds associated with an entity before freeing it.
Call #EntityStop3DSound before freeing an entity if there is a chance it could be playing a sound. 
Failure to stop sounds associated with a non-existent entity can cause your program to crash.

If you set any SoundPoint "bump" field to UPDATE_DISABLED then it will no longer be updated and can be
directly modified. For example, setting VolumeBump = UPDATE_DISABLED will stop Volume field from updating.
End Rem
Module Openb3dmax.Audio3d

ModuleInfo "Version: 1.3"
ModuleInfo "License: zlib (You are free to use this code as you please)"
ModuleInfo "Copyright: 2007 Logan Chittenden"

ModuleInfo "History: 1.3 Release (by markcwm)"
ModuleInfo "History: Init3DSound HearingPoint fix, updated documentation"
ModuleInfo "History: 1.2 Release"
ModuleInfo "History: Added Stop3DSound, EntityStop3DSound, Pause3DSound, EntityPause3DSound,"
ModuleInfo "History: Resume3DSound, EntityResume3DSound, fixed some memory bugs, removed redundant lines,"
ModuleInfo "History: minor speed optimizations, internal restructuring, updated documentation"
ModuleInfo "History: 1.1 Release"
ModuleInfo "History: Added DopplerFrameSkip, Que3DSound, UPDATE_DISABLED option, List3DSounds,"
ModuleInfo "History: SoundPoint playing, fixed unnecessarily confusing dopper effect"
ModuleInfo "History: 1.0 Initial Release"

Import Openb3dmax.Openb3dmax
Import Brl.OpenAlAudio
?Linux
Import "-ldl"
?Not Win32
Import Brl.FreeAudioAudio
?Win32
Import Brl.DirectSoundAudio
?
Import Brl.WavLoader
Import Brl.OggLoader

'### Constants
Const UPDATE_DISABLED:Float = -2
Const DOPPLER_DISABLED:Float = 0

'### Types
Rem
bbdoc: SoundPoint
about: A point that plays a sound in 3D space
End Rem
Type SoundPoint
	Field RelativeSoundPoint:TPivot
	Field ListenAngularDifference:TPivot
	Field Distance:Float
	Field Angle:Float
	
	Rem
	bbdoc: Channel the sound is playing in
	End Rem
	Field SoundChannel:TChannel
	
	Rem
	bbdoc: Entity emitting the sound
	End Rem
	Field EmiterObject:TEntity
	
	Rem
	bbdoc: Loudness factor of the sound
	End Rem
	Field Loudness:Float
	
	Rem
	bbdoc: Base volume of the sound
	End Rem
	Field MasterVolume:Float
	
	Rem
	bbdoc: Pan point of the sound
	End Rem
	Field Pan:Float
	
	Rem
	bbdoc: Pan bump
	about: When calculating the sound channels pan, this number will be added to the new pan.
	End Rem
	Field PanBump:Float
	
	Rem
	bbdoc: Depth point of the sound
	End Rem
	Field Depth:Float
	
	Rem
	bbdoc: Depth bump
	about: When calculating the sound channels depth this number will be added to the new pan.
	End Rem
	Field DepthBump:Float
	
	Rem
	bbdoc: Play rate of the sound
	End Rem
	Field Rate:Float = 1
	
	Rem
	bbdoc: Play rate bump
	about: When calculating the sound channels play rate this number will be added to the new rate.
	End Rem
	Field RateBump:Float
	
	Rem
	bbdoc: Volume of the sound
	End Rem
	Field Volume:Float
	
	Rem
	bbdoc: Volume bump
	about: When calculating the sound channels volume this number will be added to the new volume.
	End Rem
	Field VolumeBump:Float
	
	Rem
	bbdoc: Pause status
	about: If a song is paused it will still be updated and held, but will not play.
	To pause a sound, change it's paused value to true and update the sound.
	End Rem
	Field Paused:Byte = False
	
	Rem
	bbdoc: Creates a new sound point
	about: To create a sound use #Start3DSound, this allows for future changes to the system
	End Rem
	Function Create:SoundPoint(TheSound:TSound, NoisyEntity:TEntity, EntityLoudness:Float=1, Volume:Float=1, Qued:Byte = False)
		Local theTemp:SoundPoint = New SoundPoint
		
		' parented to the listen point so we can get angles and distance relative to that
		theTemp.RelativeSoundPoint = CreatePivot(HearingPoint.ListenPoint)
		
		' used to calculate angle off of the listen point towards the sound
		theTemp.ListenAngularDifference = CreatePivot(HearingPoint.ListenPoint)

		theTemp.EmiterObject = NoisyEntity
		theTemp.SoundChannel = AllocChannel()
		theTemp.MasterVolume = Volume
		theTemp.Loudness = EntityLoudness
		CueSound(TheSound, theTemp.SoundChannel)
		
		theTemp.Paused = Qued
		
		theTemp.Update()
		
		ListAddLast(SoundPointsList, theTemp)
		
		Return(theTemp)
	End Function
	
	' update the positional information for a sound
	Method UpdatePosition()
		Local LastDistance:Float
			
		If EmiterObject <> Null Then
		
			' update the point the sound is coming from to that of the emitting object's global position
			PositionEntity(RelativeSoundPoint, EntityX(EmiterObject, True), EntityY(EmiterObject, True), EntityZ(EmiterObject, True), True)
			
			' get and correct the angle off of the listen point towards where the sound is coming from
			PointEntity(ListenAngularDifference, RelativeSoundPoint) ' update the angle
			Angle = EntityYaw(ListenAngularDifference) ' angle will always be in range of -180 to +180
			
			' get the distance from the listen point to the sound point
			LastDistance = Distance ' store the last distance in case we need to do doppler
			Distance = EntityDistance(ListenAngularDifference, RelativeSoundPoint)
			
			' volume is based on distance from the listen point to the relative sound point,
			' modified by the master volume of the sound (how loud it is)
			If VolumeBump <> UPDATE_DISABLED Then
				Volume = MasterVolume-(Distance/(HearingPoint.SoundFalloffEnd*Loudness))
				Volume:+VolumeBump
				If Volume > 1 Then
					Volume = 1
				ElseIf Volume < 0 Then
					Volume = 0
				End If
			End If
			
			' pan is based on yaw angle off of the listen point towards the sound source
			If PanBump <> UPDATE_DISABLED Then
				Pan = (-Angle)/90
				Pan:+PanBump
				If Pan > 1 Then ' past 90 deg
					Pan = 1-(Pan-1)
				ElseIf Pan < -1 Then ' past -90 deg
					Pan = -1-(Pan+1)
				End If
			End If
			
			' depth is based on how far along Z axis (ahead or behind)
			' the point is in local coords (which are relative to the listen point's position and angle)
			If DepthBump <> UPDATE_DISABLED Then
				Depth = EntityZ(RelativeSoundPoint)/HearingPoint.SoundFalloffEnd
				Depth:+DepthBump
				If Depth > 1 Then ' over maximum
					Depth = 1
				ElseIf Depth < -1 Then
					Depth = -1
				End If
			End If

			' if the doppler effect is enabled by having a dopplerscale
			If RateBump <> UPDATE_DISABLED Then
				If HearingPoint.DopplerScale > DOPPLER_DISABLED Then
					Rate = (343.7+((LastDistance - Distance)*HearingPoint.DopplerScale))/343.7
				Else ' not using standard or exaggerated doppler, set the rate to 1
					Rate = 1
				End If
				Rate:+RateBump
			End If
		Else
			Stop()
		End If
	End Method
	
	' sets the positional information and plays the sound if it is to be playing
	Method SetAndPlay()
		PauseChannel(SoundChannel) ' the pause and resume reduce crackling
		SetChannelVolume(SoundChannel, Volume)
		If Volume > 0 Then ' if it is silent we don't need to bother with the other updates
			SetChannelPan(SoundChannel, Pan)
			SetChannelRate(SoundChannel, Rate)
			SetChannelDepth(SoundChannel, Depth)
		End If
		If Not Paused Then ' if it's paused don't resume
			ResumeChannel(SoundChannel)
		End If
	End Method
	
	Rem
	bbdoc: Updates the sound channel and positional information and clears the channel if the sound is done playing
	about: To update all sounds at once use #Update3DSounds.
	End Rem
	Method Update()
		If SoundChannel Then
			UpdatePosition()
			SetAndPlay()
			If Not ChannelPlaying(SoundChannel) And Not Paused Then
				Stop()
			
			End If
		Else
			Stop()
		End If
	End Method
	
	Rem
	bbdoc: Stops a sound and removes it from the sound system
	about: This will stop a sound point while playing and free it's resources.
	End Rem
	Method Stop()
		If SoundChannel Then
			StopChannel(SoundChannel)
		End If
		ListRemove(SoundPointsList, Self)
	End Method
	
	'# Free entitys when memory is being cleared so we don't leave residuals in the 3d scene
	Method Delete()
		StopChannel(SoundChannel)
		FreeEntity(RelativeSoundPoint)
		FreeEntity(ListenAngularDifference)
	End Method
End Type


'# A HearingPointType is a point to where the sound travels i.e. the center of a head
Type ListeningPoint
	Field ListenPoint:TEntity	' the microphone, should be attached to the camera
	Field SoundFalloffEnd:Float	' sounds are silent past this point
	Field DopplerScale:Float	' how far you have to move to double or half the sound rate. 0 disables doppler effect
End Type

Private

'# Variables

Global HearingPoint:ListeningPoint = New ListeningPoint ' the point where the sound is heard
Global SoundPointsList:TList ' all currently active 3d sounds

Public

'# Functions

Rem 
bbdoc: Set up the 3D sound system
about: Call this before any other 3D sound calls. The sound system can be re-initialized later
without loosing the sounds currently playing.

@ListeningEntity is the entity you will hear sound through. @MaxRange is the maximum distance a sound
will be before it is silent. @ExaggerateDopplerScale (optional) is the amount to exaggerate the doppler
effect by. Setting it to DOPPLER_DISABLED or leaving it blank will disable the doppler effect.
A value of 1 will use an accurate doppler effect (1 unit = 1 meter). An appropriate value will be
dependent on the speed of objects in your program.
End Rem
Function Init3DSound:TEntity(ListeningEntity:TEntity, MaxRange:Float=30, ExaggerateDopplerScale:Float=DOPPLER_DISABLED)
	Local tempSoundPoint:SoundPoint
	Local OldListeningEntity:TEntity

	If HearingPoint Then
		OldListeningEntity = HearingPoint.ListenPoint
	Else
		HearingPoint = New ListeningPoint 'HearingPoint
	End If
	HearingPoint.ListenPoint = ListeningEntity
	HearingPoint.SoundFalloffEnd = MaxRange
	HearingPoint.DopplerScale = ExaggerateDopplerScale
	
	If SoundPointsList And OldListeningEntity <> HearingPoint.ListenPoint Then
	
		' update all sound points to listen from the new point
		For tempSoundPoint = EachIn SoundPointsList
		
			' re-attach relative point
			EntityParent(tempSoundPoint.RelativeSoundPoint, HearingPoint.ListenPoint)
			
			' re-attach angle diff point
			EntityParent(tempSoundPoint.ListenAngularDifference, HearingPoint.ListenPoint)
			
			' re-center the angle diff point
			PositionEntity(tempSoundPoint.ListenAngularDifference, 0, 0, 0)
			tempSoundPoint.Distance = 0 ' fix distance so we don't get any doppler freak out
		Next
	Else
		SoundPointsList = CreateList()
	End If
	Return HearingPoint.ListenPoint
End Function

Rem
bbdoc: Like Init3DSound
End Rem
Function CreateListener:TEntity(ListeningEntity:TEntity, MaxRange:Float=30, ExaggerateDopplerScale:Float=DOPPLER_DISABLED)
	Return Init3DSound(ListeningEntity, MaxRange, ExaggerateDopplerScale)
End Function

Rem
bbdoc: Updates all the 3D sound channels
about: Should be called (optimally) once per loop, preferably after positions and collisions have
been handled.
End Rem
Function Update3DSounds()
	Local tempSoundPoint:SoundPoint
	
	For tempSoundPoint = EachIn SoundPointsList
		tempSoundPoint.Update()
	Next
End Function

Rem
bbdoc: Stops doppler effect for all objects for 1 update
about: If you need to move your listen point in a way that you do not want to affect the doppler
effect then call this before your next call to #Update3DSounds. For example, if you have a camera
looking at an object from a distance and then "change view" by moving the camera close and
behind the object. This would normally be a very fast move and cause a large doppler effect.
End Rem
Function DopplerFrameSkip()
	Local tempSoundPoint:SoundPoint
	
	For tempSoundPoint = EachIn SoundPointsList
		tempSoundPoint.Distance = 0
	Next
End Function

Rem
bbdoc: Load a 3d sound
returns: A sound object
about:
@url can be either a string, a stream or a #TAudioSample object.
The returned sound can be played using #PlaySound or #CueSound.

The @flags parameter can be any combination of:

[ @{Flag value} | @Effect
* SOUND_LOOP | The sound should loop when played back.
* SOUND_HARDWARE | The sound should be placed in onboard soundcard memory if possible.
]

To combine flags, use the binary 'or' operator: '|'.
End Rem
Function Load3DSound:TSound( url:Object,flags:Int=0 )
	Return LoadSound( url,flags )
End Function

Rem
bbdoc: Attaches a sound to an entity and starts it playing
returns: SoundPoint so you can control it further. You can ignore the return value as it is held in
the sound system.
about: @TheSound is the sound you wish to play. @NoisyEntity is the entity that is making the sound.
@Loudness (optional) determines how loud a sound is. Louder sounds will carry further. Distance is
proportional to the MaxRange set during #Init3DSound. A value of 1 will carry to the MaxRange.
@Volume (optional) sets a master volume for the sound.
End Rem
Function Start3DSound:SoundPoint(TheSound:TSound, NoisyEntity:TEntity, Loudness:Float=1, Volume:Float=1)
	Local tempSoundPoint:SoundPoint
	
	tempSoundPoint = SoundPoint.Create(TheSound, NoisyEntity, Loudness, Volume)
	
	Return(tempSoundPoint)
End Function

Rem
bbdoc: Like Start3DSound
End Rem
Function EmitSound:SoundPoint(TheSound:TSound, NoisyEntity:TEntity, Loudness:Float=1, Volume:Float=1)
	Return Start3DSound(TheSound, NoisyEntity, Loudness, Volume)
End Function

Rem
bbdoc: Attaches a sound to an entity but does not start it playing
returns: SoundPoint so you can control the sound further. You can ignore the value as it is held in
the sound system.
about: @TheSound is the sound you wish to play. @NoisyEntity is the entity that is making the sound.
@Loudness (optional) determines how loud a sound is. Louder sounds will carry further. Distance is
proportional to the MaxRange set during #Init3DSound. A value of 1 will carry to the MaxRange.
@Volume (optional) sets a master volume for the sound.
End Rem
Function Que3DSound:SoundPoint(TheSound:TSound, NoisyEntity:TEntity, Loudness:Float=1, Volume:Float=1)
	Local tempSoundPoint:SoundPoint
	
	tempSoundPoint = SoundPoint.Create(TheSound, NoisyEntity, Loudness, Volume, True)
	
	Return(tempSoundPoint)
End Function

Rem
bbdoc: Finds sounds associated with an entity
returns: TList of SoundPoints attached to the entity.
about: Finds and returns all sound points attached to the given entity.
End Rem
Function List3DSounds:TList(NoisyEntity:TEntity)
	Local returnSoundPointList:TList = CreateList()
	Local tempSoundPoint:SoundPoint
	
	For tempSoundPoint = EachIn SoundPointsList
		If tempSoundPoint.EmiterObject = NoisyEntity Then
			ListAddLast(returnSoundPointList, tempSoundPoint)
		End If
	Next
	
	Return(returnSoundPointList)
End Function

Rem
bbdoc: Stops a single 3D sound
about: Wrapper for SoundPoint.Stop for more logical programming.
End Rem
Function Stop3DSound(TheSoundPoint:SoundPoint)
	TheSoundPoint.Stop()
End Function

Rem
bbdoc: Pauses a 3D sound
about: Wrapper for SoundPoint.Pause = True for more logical programming.
End Rem
Function Pause3DSound(TheSoundPoint:SoundPoint)
	TheSoundPoint.Paused = True
End Function


Rem
bbdoc: Resumes a paused 3D sound
about: Wrapper for SoundPoint.Pause = False for more logical programming.
End Rem
Function Resume3DSound(TheSoundPoint:SoundPoint)
	TheSoundPoint.Paused = False
End Function

Rem
bbdoc: Set loudness for a 3D sound
End Rem
Function SetLoudness3DSound(TheSoundPoint:SoundPoint, Loudness:Float)
	TheSoundPoint.Loudness = Loudness
End Function

Rem
bbdoc: Set pan bump for a 3D sound
End Rem
Function SetPanBump3DSound(TheSoundPoint:SoundPoint, PanBump:Float)
	TheSoundPoint.PanBump = PanBump
End Function

Rem
bbdoc: Set pan point for a 3D sound
End Rem
Function SetPan3DSound(TheSoundPoint:SoundPoint, Pan:Float)
	TheSoundPoint.Pan = Pan
End Function

Rem
bbdoc: Set rate bump for a 3D sound
End Rem
Function SetRateBump3DSound(TheSoundPoint:SoundPoint, RateBump:Float)
	TheSoundPoint.RateBump = RateBump
End Function

Rem
bbdoc: Stops all entity sounds
about: Stops all sounds attached to an entity through the internal 3D SoundPoint list.
You must stop all sounds associated with an entity before freeing it. Call #EntityStop3DSound
before freeing an entity if there is a chance it could be playing a sound.
End Rem
Function EntityStop3DSound(NoisyEntity:TEntity)
	Local tempSoundPoint:SoundPoint ' temporary place to access a sound point
		
	For tempSoundPoint = EachIn SoundPointsList
		If tempSoundPoint.EmiterObject = NoisyEntity Then
			tempSoundPoint.Stop()
		End If
	Next
End Function

Rem
bbdoc: Pauses all entity sounds
about: Pauses all sounds attached to an entity through the internal 3D SoundPoint list.
End Rem
Function EntityPause3DSound(NoisyEntity:TEntity)
	Local tempSoundPoint:SoundPoint ' temporary place to access a sound point
		
	For tempSoundPoint = EachIn SoundPointsList
		If tempSoundPoint.EmiterObject = NoisyEntity Then
			tempSoundPoint.Paused = True
		End If
	Next
End Function

Rem
bbdoc: Resumes all paused entity sounds
about: Resumes all paused sounds attached to an entity through the internal 3D sound point list.
End Rem
Function EntityResume3DSound(NoisyEntity:TEntity)
	Local tempSoundPoint:SoundPoint ' temporary place to access a sound point
		
	For tempSoundPoint = EachIn SoundPointsList
		If tempSoundPoint.EmiterObject = NoisyEntity Then
			tempSoundPoint.Paused = False
		End If
	Next
End Function
