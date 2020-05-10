' newtonsphere.bmx

'SuperStrict
'Import newton.dynamics
'Import openb3dmax.b3dglgraphics
'Import "newtonbody.bmx"

Type TNewtonSphere Extends TNewtonBody

	Private
	
		Method New()
			RuntimeError("No TNWorld passed to TNewtonSphere.New!")
		End Method
		
		Method New(world:TNWorld, _mesh:TMesh, _mass:Float = 1.0)
		
			mesh = _mesh
			mass = _mass
			
			Local collider:TNCollision
			Local matrix:TNMatrix
			
			collider = world.CreateSphere(MeshWidth(mesh) * 0.5, 0, Null)
			matrix = New TNMatrix
			
			AlignNewtonMatrix matrix
			
			world.CreateDynamicBody collider, matrix, Self
			SetMassProperties mass, collider
			
			collider.Destroy
			
		End Method
		
	Public
	
		Function CreateNewtonMesh:TNewtonSphere(world:TNWorld, mesh:TMesh, mass:Float, shadow:Int)
			
			Local sphere:TNewtonSphere = New TNewtonSphere(world, mesh, mass)
			
			sphere.ToggleShadow shadow
			
			Return sphere
			
		End Function
		
End Type
