' functions.bmx

'SuperStrict
'Import newton.dynamics
'Import openb3dmax.b3dglgraphics

Rem
bbdoc: Creates a Newton cube, attach a mesh, set the mass, true to create a stencil shadow
EndRem
Function CreateNewtonCubeMesh:TNewtonCube(world:TNWorld, mesh:TMesh, mass:Float, shadow:Int)
	Return TNewtonCube.CreateNewtonMesh(world, mesh, mass, shadow)
End Function

Rem
bbdoc: Creates a flat Newton ground from cube, set the width, height and depth
EndRem
Function CreateNewtonGround:TNewtonGround(world:TNWorld, width:Float = 1.0, height:Float = 1.0, depth:Float = 1.0)
	Return TNewtonGround.CreateNewtonGround(world, width, height, depth)
End Function

Rem
bbdoc: Creates a Newton sphere, attach a mesh, set the mass, true to create a stencil shadow
EndRem
Function CreateNewtonSphereMesh:TNewtonSphere(world:TNWorld, mesh:TMesh, mass:Float, shadow:Int)
	Return TNewtonSphere.CreateNewtonMesh(world, mesh, mass, shadow)
End Function

Rem
bbdoc: Creates a Newton world object, set autofail (optional) to False to manually handle Null return
EndRem
Function CreateNewtonWorld:TNWorld(autofail:Int = True)

	Local world:TNWorld = TNWorld.Create()
	
	If autofail And world = Null
		RuntimeError "CreateNewtonWorld: failed to create Newton world!"
		End
	EndIf
	
	Return world
	
End Function

Rem
bbdoc: Updates the Newton world, set update_rate (optional) to affect the engine timestep
EndRem
Function UpdateNewtonWorld(world:TNWorld, update_rate:Float=1.0)
	world.Update 1.0/update_rate
End Function

Rem
bbdoc: Resets all the internal states of the Newton world
EndRem
Function ResetNewtonWorld(world:TNWorld)
	world.InvalidateCache
End Function
