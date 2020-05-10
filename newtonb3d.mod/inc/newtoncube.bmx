' newtoncube.bmx

'SuperStrict
'Import newton.dynamics
'Import openb3dmax.b3dglgraphics
'Import "newtonbody.bmx"

Type TNewtonCube Extends TNewtonBody

	Private
	
		Method New()
			RuntimeError("No TNWorld passed to TNewtonCube.New!")
		End Method
		
		Method New(world:TNWorld, _mesh:TMesh, _mass:Float = 1.0)
		
			mesh = _mesh
			mass = _mass
			
			Local collider:TNCollision
			Local matrix:TNMatrix
			
			collider = world.CreateBox(MeshWidth(mesh), MeshHeight(mesh), MeshDepth(mesh), 0, Null, Null)
			matrix = New TNMatrix
			
			AlignNewtonMatrix matrix
			
			world.CreateDynamicBody collider, matrix, Self
			SetMassProperties mass, collider
			
			collider.Destroy
			
		End Method
		
	Public
	
		Function CreateNewtonMesh:TNewtonCube(world:TNWorld, mesh:TMesh, mass:Float, shadow:Int)
		
			Local cube:TNewtonCube = New TNewtonCube(world, mesh, mass)
			
			cube.ToggleShadow shadow
			
			Return cube
			
		End Function
		
End Type
