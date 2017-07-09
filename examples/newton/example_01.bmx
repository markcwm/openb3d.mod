'
' A basic example, with force and torque callback.
'
SuperStrict

Framework Openb3dLibs.NewtonDynamics
Import Brl.Standardio


' Create a newton world
Local world:TNWorld = TNWorld.Create()


' Create a static body To serve as the Floor.
Local background:TNBody = CreateBackgroundBody(world)
Local freeFallBall:TNBody = CreateFreeFallBall(world)

' For deterministic behavior call this method each time you change the world
world.InvalidateCache()

Local matrix:TNMatrix = New TNMatrix
' run the simulation loop
For Local i:Int = 0 Until 300
	world.Update(1.0/60.0)

	freeFallBall.GetMatrix(matrix)
	Print "height: " + matrix.positY
Next

' destroy the newton world
world.Destroy()


Function CreateBackgroundBody:TNBody(world:TNWorld)

	Local points:Float[] = [ ..
		-100.0, 0.0,  100.0, ..
		 100.0, 0.0,  100.0, .. 
		 100.0, 0.0, -100.0, ..
		-100.0, 0.0, -100.0 ]

	' crate a collision tree
	Local tree:TNTreeCollision = world.CreateTreeCollision(0)

	' start building the collision mesh
	tree.BeginBuild()

	' add the face one at a time
	tree.AddFace(4, points, 12, 0)

	' finish building the collision
	tree.EndBuild(1)

	' Create a body with a collision And locate at the identity matrix position 
	Local matrix:TNMatrix = TNMatrix.GetIdentityMatrix()
	Local body:TNBody = world.CreateDynamicBody(tree, matrix)

	' do no forget To destroy the collision after you Not longer need it
	tree.Destroy()
	
	Return body
End Function

Function CreateFreeFallBall:TNBody(world:TNWorld)
	' crate a collision sphere
	Local sphere:TNCollision = world.CreateSphere(1.0, 0, Null)

	' Create a dynamic body with a sphere shape, And 
	Local matrix:TNMatrix = TNMatrix.GetIdentityMatrix()
	matrix.positY = 50.0
	Local body:TNBody = world.CreateDynamicBody(sphere, matrix)

	' set the force callback For applying the force And torque
	body.SetForceAndTorqueCallback(ApplyGravity)

	' set the mass For this body
	Local mass:Float = 1.0
	body.SetMassProperties(mass, sphere)

	' set the linear damping To zero
	body.SetLinearDamping(0.0)

	' do no forget To destroy the collision after you no longer need it
	sphere.Destroy()
	Return body
End Function

Function ApplyGravity(body:TNBody, timestep:Float, threadIndex:Int)
	' apply gravity force To the body
	Local mass:Float
	Local Ixx:Float
	Local Iyy:Float
	Local Izz:Float

	body.GetMassMatrix(mass, Ixx, Iyy, Izz)
	body.SetForce(0.0, -9.8 * mass, 0.0, 0.0)

End Function
