' Collisions.bmx

Strict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight(),0,2

' Set collision type values
Local type_ground%=1
Local type_character%=2
Local type_scenery%=3

Local camera:TCamera=CreateCamera()
RotateEntity camera,45,0,0
PositionEntity camera,0,15,-10

Local light:TLight=CreateLight()
RotateEntity light,45,0,0

' create cube 'ground'
Local cube:TMesh=CreateCube()
ScaleEntity cube,10,10,10
EntityColor cube,0,127,0
EntityType cube,type_ground
PositionEntity cube,0,-5,0

' create sphere 'character'
Local sphere:TMesh=CreateSphere( 32 )
EntityColor sphere,127,0,0
EntityRadius sphere,1
EntityType sphere,type_character
PositionEntity sphere,0,7,0

Local sphere2:TMesh=CreateSphere( 32 )
EntityColor sphere2,127,127,0
ScaleEntity sphere2,0.5,0.5,0.5
PositionEntity sphere2,0,10,0

' enable collisions between type_character and type_ground
Collisions type_character,type_ground,2,2

' create cylinder 'scenery'
Local cylinder:TMesh=CreateCylinder( 32 )
ScaleEntity cylinder,2,2,2
EntityColor cylinder,0,0,255
EntityRadius cylinder,2
EntityBox cylinder,-2,-2,-2,4,4,4
EntityType cylinder,type_scenery
PositionEntity cylinder,-4,7,-4

' create cone 'scenery'
Local cone:TMesh=CreateCone( 32 )
ScaleEntity cone,2,2,2
EntityColor cone,0,0,255
EntityRadius cone,2
EntityBox cone,-2,-2,-2,4,4,4
EntityType cone,type_scenery
PositionEntity cone,4,7,-4

' create prism 'scenery'
Local prism:TMesh=CreateCylinder( 3 )
ScaleEntity prism,2,2,2
EntityColor prism,0,0,255
EntityRadius prism,2
EntityBox prism,-2,-2,-2,4,4,4
EntityType prism,type_scenery
PositionEntity prism,-4,7,4
RotateEntity prism,0,180,0

' create pyramid 'scenery'
Local pyramid:TMesh=CreateCone( 4 )
ScaleEntity pyramid,2,2,2
EntityColor pyramid,0,0,255
EntityRadius pyramid,2
EntityBox pyramid,-2,-2,-2,4,4,4
EntityType pyramid,type_scenery
RotateEntity pyramid,0,45,0
PositionEntity pyramid,4,7,4

' set collision method and response values
Local colmethod%=2
Local response%=2
Local col_id%
Local method_info$="ellipsoid-to-polygon"
Local response_info$="slide1"
Local col_ent:TEntity

While Not KeyDown( KEY_ESCAPE )
	Local x#=0
	Local y#=0
	Local z#=0
	
	If KeyDown( KEY_LEFT )=True Then x#=-0.1
	If KeyDown( KEY_RIGHT )=True Then x#=0.1
	If KeyDown( KEY_DOWN )=True Then z#=-0.1
	If KeyDown( KEY_UP )=True Then z#=0.1
	
	MoveEntity sphere,x#,y#,z#
	MoveEntity sphere,0,-0.02,0 ' gravity
	
	' change collision method
	If KeyHit( KEY_M )=True
		colmethod=colmethod+1
		If colmethod=4 Then colmethod=1
		If colmethod=1 Then method_info$="ellipsoid-to-sphere"
		If colmethod=2 Then method_info$="ellipsoid-to-polygon"
		If colmethod=3 Then method_info$="ellipsoid-to-box"
	EndIf
	
	' change collision response
	If KeyHit( KEY_R )=True
		response=response+1
		If response=4 Then response=1
		If response=1 Then response_info$="stop"
		If response=2 Then response_info$="slide1"
		If response=3 Then response_info$="slide2"
	EndIf
	
	' drop character if it gets stuck
	If KeyHit( KEY_D )=True
		PositionEntity sphere,0,8,0
	EndIf
	
	' enable collisions between type_character and type_scenery
	Collisions type_character,type_scenery,colmethod,response
	
	' perform collision checking
	UpdateWorld
	
	For col_id=1 To CountCollisions(sphere)
		PositionEntity sphere2,EntityX(CollisionEntity(sphere,col_id)),10,EntityZ(CollisionEntity(sphere,col_id))
		Exit ' get first entity in collision list
	Next
	If CountCollisions(sphere)>0 Then col_ent=CollisionEntity(sphere,1) Else col_ent=Null
	
	RenderWorld
	
	Text 0,20,"Use cursor keys to move sphere, D to drop"
	Text 0,40,"Press M to change collision method (currently: "+method_info$+")"
	Text 0,60,"Press R to change collision response (currently: "+response_info$+")"
	Text 0,80,"Collisions type_character,type_scenery,"+colmethod+","+response
	Text 0,100,"CountCollisions="+CountCollisions(sphere)+", CollisionEntity="+Byte Ptr(col_ent)+", ground ent="+Byte Ptr(cube)
	Text 0,120,"cylinder="+Byte Ptr(cylinder)+", cone="+Byte Ptr(cone)+", prism="+Byte Ptr(prism)+", pyramid="+Byte Ptr(pyramid)
	
	Flip
Wend
End
