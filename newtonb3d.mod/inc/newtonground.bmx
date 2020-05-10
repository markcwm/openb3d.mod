' newtonground.bmx

'SuperStrict
'Import newton.dynamics
'Import openb3dmax.b3dglgraphics
'Import "newtonbody.bmx"

Type TNewtonGround Extends TNewtonBody

	Private
	
		Method New()
			RuntimeError("No TNWorld passed to TNewtonCube.New!")
		End Method
		
		Method New(world:TNWorld, width:Float = 1.0, height:Float = 1.0, depth:Float = 1.0)
		
			mass = 0.0
			
			mesh = CreateCube()
			
			ScaleMesh mesh, width * 0.5, height * 0.5, depth * 0.5
			
			MoveEntity mesh, 0.0, -10.0, 0.0
			
			Local collider:TNCollision
			Local matrix:TNMatrix
			
			collider = world.CreateBox(width, height, depth, 0, Null, Null)
			matrix = New TNMatrix
			
			AlignNewtonMatrix matrix
			
			world.CreateDynamicBody collider, matrix, Self
			SetMassProperties mass, collider
			
			collider.Destroy
			
		End Method
		
	Public
	
		Function CreateNewtonGround:TNewtonGround(world:TNWorld, width:Float = 1.0, height:Float = 1.0, depth:Float = 1.0)
		
			Return New TNewtonGround(world, width, height, depth)
			
		End Function
		
End Type
