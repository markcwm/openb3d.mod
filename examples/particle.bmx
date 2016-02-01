' particle.bmx

Strict

Framework Openb3d.B3dglgraphics
Import Brl.Random

Graphics3D 800,600


ClearTextureFilters

Local camera:TCamera=CreateCamera()
CameraClsColor camera,100,150,200

Local light:TLight=CreateLight()
TurnEntity light,45,45,0

Local pivot:TPivot=CreatePivot()
PositionEntity pivot,0,2,0

Local t_sphere:TMesh=CreateSphere(8)
EntityShininess t_sphere,0.2

Local lastsphere:TEntity
For Local t%=0 To 359 Step 60
	Local sphere:TEntity=CopyEntity(t_sphere,pivot)
	EntityColor sphere,Rnd(255),Rnd(255),Rnd(255)
	TurnEntity sphere,0,t,0
	MoveEntity sphere,0,2,10
	lastsphere=sphere
Next
FreeEntity t_sphere

'Local ground:TMesh=CreatePlane(128)
Local ground:TMesh=CreateCube()
ScaleEntity ground,1000,1,1000
Local ground_tex:TTexture=LoadTexture("media/sand.bmp")
ScaleTexture ground_tex,0.01,0.01 ' scale uvs
EntityTexture ground,ground_tex

Local cone:TMesh=CreateCone()
PositionEntity cone,0,3,0

Local sprite:TSprite=CreateSprite()
EntityColor sprite,250,250,150
'ScaleSprite sprite,1.5,1.5
EntityAlpha sprite,0.2
Local noisetex:TTexture=LoadTexture("media/smoke.png",1+2)
'Local noisetex:TTexture=CreateTexture(1,1)
EntityTexture sprite,noisetex

'SpriteRenderMode sprite,3
'ParticleTrail sprite,20
'ParticleColor sprite,1.0,0,0,0.0

Local p:TParticleEmitter=CreateParticleEmitter(sprite)
MoveEntity p,0,5,0
TurnEntity p,-90,0,0

EmitterRate p,1.0
EmitterParticleLife p,100
EmitterVariance p,0.07
EmitterParticleSpeed p,0.1
EmitterVector p,0.003,0.001,0

Local p2:TParticleEmitter=TParticleEmitter( p.CopyEntity() )
TurnEntity p2,-90,0,0 ' rotate up

PositionEntity sprite,-25,6,25
PositionEntity camera,0,7,0
MoveEntity camera,0,0,-20


While Not KeyHit(KEY_ESCAPE)
	
	' control camera
	MoveEntity camera,KeyDown(KEY_D)-KeyDown(KEY_A),0,KeyDown(KEY_W)-KeyDown(KEY_S)
	TurnEntity camera,KeyDown(KEY_DOWN)-KeyDown(KEY_UP),KeyDown(KEY_LEFT)-KeyDown(KEY_RIGHT),0
	
	If KeyDown(KEY_N) Then TurnEntity p,0,1,0
	If KeyDown(KEY_M) Then TurnEntity p,0,-1,0
	
	TurnEntity pivot,0,1,0
	
	PositionEntity p2,EntityX(lastsphere,1),5,EntityZ(lastsphere,1)
	
	UpdateWorld ' update particles
	RenderWorld
	
	Text 0,0,"WSAD/Arrows: move camera, NM: rotate emitter"
	
	Flip
Wend
