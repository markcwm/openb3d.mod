' Copyright (c) 2014 Mark Mcvittie, Bruce A Henderson
'
' This software is provided 'as-is', without any express or implied
' warranty. In no event will the authors be held liable for any damages
' arising from the use of this software.
'
' Permission is granted to anyone to use this software for any purpose,
' including commercial applications, and to alter it and redistribute it
' freely, subject to the following restrictions:
'
'    1. The origin of this software must not be misrepresented; you must not
'    claim that you wrote the original software. If you use this software
'    in a product, an acknowledgment in the product documentation would be
'    appreciated but is not required.
'
'    2. Altered source versions must be plainly marked as such, and must not be
'    misrepresented as being the original software.
'
'    3. This notice may not be removed or altered from any source
'    distribution.
'
SuperStrict

Rem
bbdoc: 3D Sound
about: You must stop all sounds associated with an entity before freeing it.
Call EntityStop3DSound() before freeing an entity if there is a chance it could be playing a sound. 
Failure to stop sounds associated with a non-existent entity can cause your program to crash.
End Rem
Module Openb3d.B3dsound

ModuleInfo "Version: 1.2"
ModuleInfo "Author: Logan Chittenden"
ModuleInfo "License: You are free to use this code as you please."

ModuleInfo "History: 1.2 Added Stop3DSound() : EntityStop3DSound() : Pause3DSound() : EntityPause3DSound() :"
ModuleInfo " Resume3DSound() : EntityResume3DSound() : Fixed some misc memory bugs. Removed redundent lines."
ModuleInfo " Minor Speed Optimizations. Minor internal restructuring. Updated documentation."
ModuleInfo "History: 1.1 Added DopplerFrameSkip() : Que3DSound() : UPDATE_DISABLED option :"
ModuleInfo " SoundPoint.Playing : List3DSounds() : Fixed un-necessarily confusing dopper effect stuff."
ModuleInfo "History: 1.0 Initial Release"

Import Openb3d.Openb3d
Import Brl.Audio

'### Constants
Const UPDATE_DISABLED:Float = -2
Const DOPPLER_DISABLED:Float = 0

'### Types
Rem
bbdoc: SoundPoint Type
about: A SoundPoint is a point that plays a sound in 3D space
End Rem
Type SoundPoint
	Field RelativeSoundPoint:TPivot
	Field ListenAngularDifference:TPivot
	Field Distance:Float
	Field Angle:Float
	
	Rem
	bbdoc: The channel the sound is playing in
	End Rem
	Field SoundChannel:TChannel
	
	Rem
	bbdoc: The Entity that is emiting the sound
	End Rem
	Field EmiterObject:TEntity
	
	Rem
	bbdoc: The "loudness" of the sound
	End Rem
	Field Loudness:Float
	
	Rem
	bbdoc: The base volume of the sound
	End Rem
	Field MasterVolume:Float
	
	Rem
	bbdoc: The pan point of the sound
	End Rem
	Field Pan:Float
	
	Rem
	bbdoc: The pan bump
	about: When calculating the sound channels pan this number will be added to the new pan.<br>
	If you set any bump vairable to UPDATE_DISABLED then that primary variable will no longer be updated
	and can be directly modified. For example, setting VolumeBump = UPDATE_DISABLED will stop the Volume
	variable from updating so you can change it Directly.
	End Rem
	Field PanBump:Float
	
	Rem
	bbdoc: The depth point of the sound
	End Rem
	Field Depth:Float
	
	Rem
	bbdoc: The depth bump
	about: When calculating the sound channels depth this number will be added to the new pan.<br>
	If you set any bump vairable to UPDATE_DISABLED then that primary variable will no longer be updated
	and can be directly modified. For example, setting VolumeBump = UPDATE_DISABLED will stop the Volume
	variable from updating so you can change it Directly.
	End Rem
	Field DepthBump:Float
	
	Rem
	bbdoc: The play rate of the sound
	End Rem
	Field Rate:Float = 1
	
	Rem
	bbdoc: The play rate bump
	about: When calculating the sound channels play rate this number will be added to the new rate.<br>
	If you set any bump vairable to UPDATE_DISABLED then that primary variable will no longer be updated
	and can be directly modified. For example, setting VolumeBump = UPDATE_DISABLED will stop the Volume
	variable from updating so you can change it Directly.
	End Rem
	Field RateBump:Float
	
	Rem
	bbdoc: The volume of the sound
	End Rem
	Field Volume:Float
	
	Rem
	bbdoc: The volume bump
	about: When calculating the sound channels volume this number will be added to the new volume.<br>
	If you set any bump vairable to UPDATE_DISABLED then that primary variable will no longer be updated
	and can be directly modified. For example, setting VolumeBump = UPDATE_DISABLED will stop the Volume
	variable from updating so you can change it Directly.
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
	about: To create a sound use Start3DSound to allow for future changes to the system
	End Rem
	Function Create:SoundPoint(TheSound:TSound, NoisyEntity:TEntity, EntityLoudness:Float=1, Volume:Float=1, Qued:Byte = False)
		Local theTemp:SoundPoint = New SoundPoint
		
		theTemp.RelativeSoundPoint = CreatePivot(HearingPoint.ListenPoint) ' parented to the listen point so we can get angles and distance relative to that
		theTemp.ListenAngularDifference = CreatePivot(HearingPoint.ListenPoint) ' used to calculate angle off of the listen point towards the sound

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
	
	' Updated the possitional information for a sound
	Method UpdatePosition()
		Local LastDistance:Float
			
		If EmiterObject <> Null Then
			' Update the point the sound is coming from to that of the emiting object's global position
			PositionEntity(RelativeSoundPoint, EntityX(EmiterObject, True), EntityY(EmiterObject, True), EntityZ(EmiterObject, True), True)
			' Get and correct the angle off of the listen point towards where the sound is comming from
			PointEntity(ListenAngularDifference, RelativeSoundPoint) ' update the angle
			Angle = EntityYaw(ListenAngularDifference) ' angle will always be in range of -180 to +180
			' Get the distance from the listen point to the sound point
			LastDistance = Distance ' store the last distance incase we need to do doppler
			Distance = EntityDistance(ListenAngularDifference, RelativeSoundPoint)
			
			' Volume is based on distance from the listen point to the relative sound point, modified by
			' the master volume of the sound (how loud it is)
			If VolumeBump <> UPDATE_DISABLED Then
				Volume = MasterVolume-(Distance/(HearingPoint.SoundFalloffEnd*Loudness))
				Volume:+VolumeBump
				If Volume > 1 Then
					Volume = 1
				ElseIf Volume < 0 Then
					Volume = 0
				End If
			End If
			
			' Pan is based on yaw angle off of the listen point towards the sound source
			If PanBump <> UPDATE_DISABLED Then
				Pan = (-Angle)/90
				Pan:+PanBump
				If Pan > 1 Then ' past 90 deg
					Pan = 1-(Pan-1)
				ElseIf Pan < -1 Then ' past -90 deg
					Pan = -1-(Pan+1)
				End If
			End If
			
			' Depth is based on how far along Z axis (ahead or behind)
			' the point is in Local coords (which are relative To the listenpoint's postion and angle)
			If DepthBump <> UPDATE_DISABLED Then
				Depth = EntityZ(RelativeSoundPoint)/HearingPoint.SoundFalloffEnd
				Depth:+DepthBump
				If Depth > 1 Then ' over maximum
					Depth = 1
				ElseIf Depth < -1 Then
					Depth = -1
				End If
			End If

			' If the doppler effect is enabled by having a dopplerscale
			If RateBump <> UPDATE_DISABLED Then
				If HearingPoint.DopplerScale > DOPPLER_DISABLED Then
					Rate = (343.7+((LastDistance - Distance)*HearingPoint.DopplerScale))/343.7
				Else ' not using standard or Exaggerated doppler, set the rate to 1
					Rate = 1
				End If
				Rate:+RateBump
			End If
		Else
			Stop()
		End If
	End Method
	
	' Sets the positional information and plays the sound if it is to be playing
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
	bbdoc: Updates the sound channel and it's positional information, as well as clearing the channel if the sound is done playing
	about: To update all sounds at once use Update3DSounds()
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
	about: This will stop a sound point while playing and free it's resources
	End Rem
	Method Stop()
		If SoundChannel Then
			StopChannel(SoundChannel)
		End If
		ListRemove(SoundPointsList, Self)
	End Method
	
	'### Free entitys when memory is being cleared so we don't leave residuals in the 3d scene
	Method Delete()
		StopChannel(SoundChannel)
		FreeEntity(RelativeSoundPoint)
		FreeEntity(ListenAngularDifference)
	End Method
End Type


'# A HearingPointType is a point to where the sound travels. i.e. the center of a head
Type ListeningPoint
	Field ListenPoint:TEntity	' the microphone, should be attached to the camera
	Field SoundFalloffEnd:Float	' Sounds are silent past this point
	Field DopplerScale:Float		' How far you have to move to double or half the sound rate. 0 to dissable doppler effect
End Type



'### Variables
Private '## Following is private

Global HearingPoint:ListeningPoint = New ListeningPoint ' the point where sound is heard
Global SoundPointsList:TList ' all currently active 3d sounds

'### Functions
Public
Rem 
bbdoc: Setup the 3D sound system
about:
Call this before any other 3D sound calls<br>
The sound system can be re-initialized later without loosing the sounds currently playing.<br>
<br>
<b>ListeningEntity</b> is the entity you will hear sound through.<br>
<b>MaxRange</b> is the maximum distance a sound will be before it is silent<br>
<b>ExaggerateDopplerScale</b> <i>optional</i> is the amound to exagerate the doppler effect bye.
Setting it to DOPPLER_DISABLED, or leaving it blank will dissable the doppler effect.
A value of 1 will use accurate doppler effect (1 unit = 1 meter).
An appropriate value will be dependent on the speeds of objects in your program.
End Rem
Function Init3DSound(ListeningEntity:TEntity, MaxRange:Float, ExaggerateDopplerScale:Float=DOPPLER_DISABLED)
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
		For tempSoundPoint = EachIn SoundPointsList ' update all sound points to listen from the new point
			EntityParent(tempSoundPoint.RelativeSoundPoint, HearingPoint.ListenPoint) ' re-attach relative point
			EntityParent(tempSoundPoint.ListenAngularDifference, HearingPoint.ListenPoint) ' re-attach angle diff point
			PositionEntity(tempSoundPoint.ListenAngularDifference, 0, 0, 0) ' re-center the angle diff point
			tempSoundPoint.Distance = 0 ' fix distance so we don't get any doppler freak out
		Next
	Else
		SoundPointsList = CreateList()
	End If
End Function


Rem
bbdoc: Updates all the 3D sound channels
about: Should be called (optimaly) once per loop, preferably after positions and collisions have been handled.
End Rem
Function Update3DSounds()
	Local tempSoundPoint:SoundPoint
	
	For tempSoundPoint = EachIn SoundPointsList
		tempSoundPoint.Update()
	Next
End Function


Rem
bbdoc: Stops doppler effect for all objects for 1 update
about: If you need to move your listen point in a way that you do not want to have effect the doppler
effect then call this before your next call to Update3DSounds. An example would be if you have a camera
looking at an object from a distance and then "change view" in your game by moving the camera close and
behind the object. This would normaly be a very fast move and cause a large doppler effect.
Call DopplerFrameSkip() somewhere durring the camera re-position, before the next call to Update3DSounds().
End Rem
Function DopplerFrameSkip()
	Local tempSoundPoint:SoundPoint
	
	For tempSoundPoint = EachIn SoundPointsList
		tempSoundPoint.Distance = 0
	Next
End Function


Rem
bbdoc: Attaches a sound to an entity and starts it playing.
returns: Sound Point so you can control it further. You can ignore the return value as it is held in
the sound system.
about:
<b>TheSound</b> is the sound you wish to play.<br>
<b>NoisyEntity</b> is the entity that is making the sound.<br>
<b>Loudness</b> <i>optional</i> determines how loud a sound is. Louder sounds will cary farther.
Distance is proportional to the MaxRange set durring Init3DSound. A value of 1 will cary to the MaxRange.
<b>Volume</b> <i>optional</i> sets a master volume for the sound
<b><i>Note:</i></b> You must stop all sounds associated with an entity before freeing it.
Call EntityStop3DSound() before freeing an entity if there is a chance it could be playing a sound.
End Rem
Function Start3DSound:SoundPoint(TheSound:TSound, NoisyEntity:TEntity, Loudness:Float=1, Volume:Float=1)
	Local tempSoundPoint:SoundPoint
	
	tempSoundPoint = SoundPoint.Create(TheSound, NoisyEntity, Loudness, Volume)
	
	Return(tempSoundPoint)
End Function


Rem
bbdoc: Attaches a sound to an entity but does NOT start it playing.
returns: Sound Point so you can control the sound further. You can ignore the value as it is held in
the sound system.
about:
<b>TheSound</b> is the sound you wish to play.<br>
<b>NoisyEntity</b> is the entity that is making the sound.<br>
<b>Loudness</b> <i>optional</i> determines how loud a sound is. Louder sounds will cary farther.
Distance is proportional to the MaxRange set durring Init3DSound. A value of 1 will cary to the MaxRange.
<b>Volume</b> <i>optional</i> sets a master volume for the sound<br>
<b><i>Note:</i></b> You must stop all sounds associated with an entity before freeing it.
Call EntityStop3DSound() before freeing an entity if there is a chance it could be playing a sound.
End Rem
Function Que3DSound:SoundPoint(TheSound:TSound, NoisyEntity:TEntity, Loudness:Float=1, Volume:Float=1)
	Local tempSoundPoint:SoundPoint
	
	tempSoundPoint = SoundPoint.Create(TheSound, NoisyEntity, Loudness, Volume, True)
	
	Return(tempSoundPoint)
End Function


Rem
bbdoc: Finds sounds associated with an entity.
returns: TList of Sound Points attached to the entity.
about: Finds and returns all sound points attached to the passed entity.
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
bbdoc: Stops a 3D Sound
about: Wrapper for SoundPoint.Stop() for more logical programing.
End Rem
Function Stop3DSound(TheSoundPoint:SoundPoint)
	TheSoundPoint.Stop()
End Function

Rem
bbdoc: Pauses a 3D Sound
about: Wrapper for SoundPoint.Pause = True for more logical programing.
End Rem
Function Pause3DSound(TheSoundPoint:SoundPoint)
	TheSoundPoint.Paused = True
End Function


Rem
bbdoc: Resumes a pause 3D Sound
about: Wrapper for SoundPoint.Pause = False for more logical programing.
End Rem
Function Resume3DSound(TheSoundPoint:SoundPoint)
	TheSoundPoint.Paused = False
End Function

Rem
bbdoc: Stops all sounds attached to an entity
about: Stops all sounds that are attached to an entity through the internal 3D sound point list.
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
bbdoc: Pauses all sounds attached to an entity
about: Pauses all sounds that are attached to an entity through the internal 3D sound point list.
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
bbdoc: Resumes all paused sounds attached to an entity
about: Resumes all paused sounds that are attached to an entity through the internal 3D sound point list.
End Rem
Function EntityResume3DSound(NoisyEntity:TEntity)
	Local tempSoundPoint:SoundPoint ' temporary place to access a sound point
		
	For tempSoundPoint = EachIn SoundPointsList
		If tempSoundPoint.EmiterObject = NoisyEntity Then
			tempSoundPoint.Paused = False
		End If
	Next
End Function
