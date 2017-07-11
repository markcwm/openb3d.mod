' example_02.bmx
' bouncing ball example with force and torque callback.

SuperStrict

Framework Openb3d.B3dglgraphics
Import Openb3dLibs.NewtonDynamics
Import Brl.Standardio

TApp.Main()

Type TApp

	Function Init()
		Graphics3D DesktopWidth(),DesktopHeight(),0,2
		
		Local cam:TCamera = CreateCamera()
		PositionEntity cam,0,5,-20
		
		Local light:TLight = CreateLight()
	End Function
	
	Function Main()
		Init()
		
		Local entity:TMesh = CreateSphere()
		Local plane:TMesh = CreatePlane()
		Local matrix:TNMatrix = New TNMatrix
		
		' Create a newton world
		Local world:TNWorld = TNWorld.Create()
		
		' Create a static body to serve as the floor.
		Local background:TNBody = CreateBackgroundBody(world)
		Local freeFallBall:TNBody = CreateFreeFallBall(world)
		
		' For deterministic behavior call this method each time you change the world
		world.InvalidateCache()
				
		Rem
		' run the simulation loop
		For Local inc:Int = 0 Until 300
			world.Update(1.0/60.0)
			
			freeFallBall.GetMatrix(matrix)
			Print "height: "+matrix.positY
		Next
		EndRem
		
		While Not KeyHit(KEY_ESCAPE)
			world.Update(1.0/60.0)
			freeFallBall.GetMatrix(matrix)
			
			' update the position of the entity
			PositionEntity entity,matrix.positX,matrix.positY,matrix.positZ
			
			RenderWorld
			
			Text 0,20,"x="+matrix.positX+" y="+matrix.positY+" z="+matrix.positZ
			Text 0,40,"Memory: "+GCMemAlloced()
			
			Flip
			GCCollect
		Wend
		
		' destroy the newton world
		world.Destroy()
		
		End
	End Function
	
	Function CreateBackgroundBody:TNBody(world:TNWorld)
		Local points:Float[] = [ ..
			-100.0, 0.0, 100.0, ..
			100.0, 0.0, 100.0, .. 
			100.0, 0.0, -100.0, ..
			-100.0, 0.0, -100.0 ]
		
		' create a collision tree
		Local tree:TNTreeCollision = world.CreateTreeCollision(0)
		
		' start building the collision mesh
		tree.BeginBuild()
		
		' add the face one at a time
		tree.AddFace(4, points, 12, 0)
		
		' finish building the collision
		tree.EndBuild(1)
		
		' Create a body with a collision and locate at the identity matrix position 
		Local matrix:TNMatrix = TNMatrix.GetIdentityMatrix()
		Local body:TNBody = world.CreateDynamicBody(tree, matrix)
		
		' do not forget to destroy the collision after you no longer need it
		tree.Destroy()
		
		Return body
	End Function
	
	Function CreateFreeFallBall:TNBody(world:TNWorld)
		' create a collision sphere
		Local sphere:TNCollision = world.CreateSphere(1.0, 0, Null)
		
		' Create a dynamic body with a sphere shape, and 
		Local matrix:TNMatrix = TNMatrix.GetIdentityMatrix()
		matrix.positY = 20.0
		
		' set the force callback for applying the force and torque
		Local ball:TFreeFallBall = New TFreeFallBall
		world.CreateDynamicBody(sphere, matrix, ball)
		
		' standard callback method, comment the 2 lines above to test
		'Local ball:TNBody = world.CreateDynamicBody(sphere, matrix, Null)
		'ball.SetForceAndTorqueCallback(ApplyGravity)
		
		' set the mass for this body
		Local mass:Float = 1.0
		ball.SetMassProperties(mass, sphere)
		
		' set the linear damping to zero
		ball.SetLinearDamping(0.0)
		
		' do not forget to destroy the collision after you no longer need it
		sphere.Destroy()
		
		Return ball
	End Function
	
	Function ApplyGravity(body:TNBody, timestep:Float, threadIndex:Int)
		' apply gravity force to the body
		Local mass:Float
		Local Ixx:Float
		Local Iyy:Float
		Local Izz:Float
		
		body.GetMassMatrix(mass, Ixx, Iyy, Izz)
		body.SetForce(0, -9.8 * mass, 0.0, 0.0)
	End Function
	
End Type

Type TFreeFallBall Extends TNBody

	' allows you to override callback behaviour
	Method OnForceAndTorque(timestamp:Float, threadIndex:Int)
		' apply gravity force to the body
		Local mass:Float
		Local Ixx:Float
		Local Iyy:Float
		Local Izz:Float
		
		GetMassMatrix(mass, Ixx, Iyy, Izz)
		SetForce(0, -9.8 * mass, 0.0, 0.0)
	End Method

End Type
