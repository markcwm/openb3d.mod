' example_01.bmx
' create a spherical body, apply a force, and track its motion over time.

SuperStrict

Framework Openb3d.B3dglgraphics
Import Openb3dLibs.NewtonDynamics
Import Brl.Standardio

TApp.Main()

Type TApp
	' needs to be global if GetMatrix is in the callback
	Global matrix:TNMatrix = New TNMatrix
	
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
		
		' Create the Newton world.
		Local world:TNWorld = TNWorld.Create()
		
		' Add the sphere.
		addSphereToSimulation(world)
		
		' Step the (empty) world 60 times in increments of 1/60 second.
		Local timestep:Float = 1.0 / 60
		
		Rem
		For Local inc:Int=0 Until 60 Step 1
			world.Update(timestep)
			Print "height: "+matrix.positY
		Next
		EndRem
		
		While Not KeyHit(KEY_ESCAPE)
			world.Update(timestep)
			
			' update the position of the entity
			PositionEntity entity,matrix.positX,matrix.positY,matrix.positZ
			
			RenderWorld
			
			Text 0,20,"Timestep="+timestep+" x="+matrix.positX+" y="+matrix.positY+" z="+matrix.positZ
			Text 0,40,"Memory: "+GCMemAlloced()
			
			Flip
			GCCollect
		Wend
		
		' Clean up.
		world.Destroy()
		'world.DestroyAllBodies() ' wrap this?
		
		End
	End Function
	
	Function addSphereToSimulation(world:TNWorld)
		Local foo:TNMatrix = TNMatrix.GetIdentityMatrix()
		
		' Create the sphere, size is radius
		Local collision:TNCollision = world.CreateSphere(1.0, 0, Null)
		
		' Create the rigid body
		Local body:TNBody = world.CreateDynamicBody(collision,foo,Null)
		
		body.SetMassProperties(1.0, collision)
		'body.SetMassMatrix(1.0, 1, 1, 1) ' wrap this?
		
		' Install callback. Newton will call it whenever the object moves.
		body.SetForceAndTorqueCallback(cb_applyForce)
		
		collision.Destroy()
	End Function
	
	Function cb_applyForce(body:TNBody, timestep:Float, threadIndex:Int)
		' Apply a force to the object.
		Local force:Float[] = [0, 1.0, 0, 0]
		body.SetForce(force[0],force[1],force[2],force[3])
		
		' Query the state (4x4 matrix) and extract the body's position.
		body.GetMatrix(matrix)	
	End Function
	
End Type
