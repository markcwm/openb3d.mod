' particle_smoke.bmx
' using callback function to add alpha, scaling and randomness to particles

Strict

Framework Openb3d.B3dglgraphics
Import Brl.Random

Graphics3D 800, 600, 0, 2
ClearTextureFilters
SeedRnd MilliSecs()

Local Cam:TCamera = CreateCamera()
CameraClsColor Cam,80,160,240
PositionEntity cam,0.1,3,-5

Local light:TLight=CreateLight()

Local sphere:TMesh=CreateSphere()
PositionEntity sphere,1.5,0,10
EntityColor sphere,127,127,12

Local sphere2:TMesh=CreateSphere()
PositionEntity sphere2,-0.5,2,1
EntityColor sphere2,12,127,127
EntityAlpha(sphere2,0.7)
EntityFX(sphere2,32)

TParticleFunc.Scale(3.0,3.0,0.5,1.5) ' set scale x/y and min/max
TParticleFunc.Life(40,60) ' set life min/max

Local sprite:TSprite=CreateSprite()
EntityColor sprite,250,250,150
ScaleSprite sprite,TParticleFunc.scalex,TParticleFunc.scaley
Local noisetex:TTexture=LoadTextureAlpha("../media/Smoke.png",1+2,$0000FF00)
EntityTexture sprite,noisetex
HideEntity sprite

Local pe:TParticleEmitter=CreateParticleEmitter(sprite)
MoveEntity pe,0,5,0
TurnEntity pe,-90,0,0

EmitterRate pe,1.0
EmitterParticleLife pe,TParticleFunc.life_max
EmitterVariance pe,0.07
EmitterParticleSpeed pe,0.1
EmitterParticleFunction( pe,TParticleFunc.Callback ) ' point to callback

Local efx%=1

' fps code
Local old_ms%=MilliSecs()
Local renders%, fps%

While Not KeyHit(KEY_ESCAPE)

	PositionEntity pe, Sin(MilliSecs() * 0.2) * 4, 0.1, 5 ' move emitter
	
	' control camera
	MoveEntity cam,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity cam,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	' alpha blending
	If KeyHit(KEY_B)
		efx=Not efx
		If efx
			EntityAlpha(sphere2,0.7) ; EntityFX(sphere2,32)
		Else
			EntityAlpha(sphere2,1) ; EntityFX(sphere2,0)
		EndIf
	EndIf
	
	UpdateWorld ' update particles
	RenderWorld
	
	' calculate fps
	renders=renders+1
	If MilliSecs()-old_ms>=1000
		old_ms=MilliSecs()
		fps=renders
		renders=0
	EndIf
	
	Text 0,0,"FPS: "+fps+", Memory: "+GCMemAlloced()
	
	Flip
	GCCollect
	
Wend

TParticleFunc.Free(pe) ' free particles
GCCollect
DebugLog "Memory at end: "+GCMemAlloced()

End

Type TParticleData
	Global map:TMap=CreateMap()
	Field ent:Byte Ptr, life%
	Field spr:TSprite
	Field life_minmax%
	Field scale_minmax#
End Type

Type TParticleFunc

	Global nparticles%
	Global life_min%, life_max%
	Global scalex#, scaley#, scale_min#, scale_max#
	
	Function Life( lmin#,lmax# )
		life_min=lmin
		life_max=lmax
	End Function
	
	Function Scale( sx#,sy#,smin#,smax# )
		scalex=sx
		scaley=sy
		scale_min=smin
		scale_max=smax
	End Function
	
	Function Free( pe:TParticleEmitter )
		ClearMap TParticleData.map
		FreeEntity pe
	End Function
	
	' store ent in map (for quick lookup) along with type for per instance data
	Function UpdateMap:TParticleData( ent:Byte Ptr,life:Int )
	
		Local inlist%=0, pd:TParticleData
		pd=TParticleData( MapValueForKey(TParticleData.map,String(Long(ent))) )
		If pd<>Null
			If ent=TSprite.GetInstance(pd.spr) Then inlist=True
		EndIf
		If inlist=False ' init particle data, this is where to add randomness
			pd=New TParticleData
			pd.spr=TSprite.CreateObject(ent)
			pd.life_minmax=Rand(life_min,life_max)
			pd.scale_minmax=Rnd(scale_min,scale_max)
			MapInsert(TParticleData.map,String(Long(ent)),pd)
			nparticles:+1
			'DebugLog "nparticles="+nparticles
		EndIf
		If pd<>Null
			pd.ent=ent
			pd.life=life
		EndIf
		Return pd
		
	End Function
	
	Function Callback( ent:Byte Ptr,life:Int ) ' ent is sprite, life left
	
		Local pd:TParticleData=UpdateMap( ent,life )
		UpdateLife(pd)
		UpdateAlpha(pd)
		UpdateScale(pd)
		
	End Function
	
	Function UpdateLife( pd:TParticleData )
		If (life_max-pd.life)>pd.life_minmax Then HideEntity(pd.spr) ' randomize life
	End Function
	
	Function UpdateAlpha( pd:TParticleData )
		Local lifeleft#=Float(pd.life)/pd.life_minmax ' normalized - 0..1
		EntityAlpha( pd.spr,lifeleft ) ' to use wrapper function
		'DebugLog "lifeleft="+lifeleft+" life="+life
	End Function
	
	Function UpdateScale( pd:TParticleData )
		Local lifegone#=Float(pd.life_minmax-pd.life)/pd.life_minmax ' normalized - 1..0
		Local sx#=(scalex+lifegone)*pd.scale_minmax
		Local sy#=(scaley+lifegone)*pd.scale_minmax
		ScaleSprite_( pd.ent,sx,sy ) ' to use library function
		'DebugLog "lifegone="+lifegone+" sizex="+sizex+" life="+life
	End Function
	
End Type
