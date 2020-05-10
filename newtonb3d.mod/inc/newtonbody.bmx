' newtonbody.bmx

'SuperStrict
'Import newton.dynamics
'Import openb3dmax.b3dglgraphics

' Derived by ground, cube, sphere
Type TNewtonBody Extends TNBody

	Field mesh:TMesh
	Field mass:Float
	Field shadow:TShadowObject
	
	Method OnTransform(matrix:Float Ptr, threadIndex:Int)
		AlignEntity matrix
	End Method
	
	Method OnForceAndTorque(timestamp:Float, threadIndex:Int)
	
		Local _mass:Float
	 	Local Ixx:Float, Iyy:Float, Izz:Float
		
		GetMassMatrix _mass, Ixx, Iyy, Izz
		
		' Gravity only...
		SetForce 0.0 * _mass, -0.987 * _mass, 0.0 * _mass, 1.0
		
	EndMethod
	
	Method ToggleShadow(toggle:Int)
	
		If toggle
			shadow = CreateShadow(mesh)
		Else
			If shadow
				FreeShadow shadow
				shadow = Null
			EndIf
		EndIf
		
	End Method
	
	Method Remove()
	
		ToggleShadow 0
		
		If mesh
			FreeEntity mesh
			mesh = Null
		EndIf
		
		Self.Destroy
		
	End Method
	
	' Fill in Newton TNMatrix from OpenB3D's TEntity.mat[:TMatrix].grid
	Method AlignNewtonMatrix:Int(matrix:TNMatrix)
	
		MemCopy Byte Ptr(matrix), mesh.mat.grid, 64
		
	End Method
	
	' Fill in OpenB3D's TEntity.mat[:TMatrix].grid from Newton TNMatrix
	Method AlignEntity:Int(matrix:Float Ptr)
	
		MemCopy mesh.mat.grid, matrix, 64
		
	End Method
	
End Type
