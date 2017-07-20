' GetChild.bmx

SuperStrict

Framework Openb3d.B3dglgraphics

Graphics3D DesktopWidth(),DesktopHeight()

Local cam:TCamera = CreateCamera()
Local cube:TMesh = CreateCube()

Local cube2:TMesh = CreateCube(cube)
Local cube3:TMesh = CreateCube(cube)

NameEntity cam, "MyCamera"
NameEntity cube, "MyCube"
NameEntity cube2, "MyCube Two"
NameEntity cube3, "MyCube Three"


Print "Children: " + CountChildren(cube)

Print "Entity name: " + EntityName(cam)
Print "Entity class: " + EntityClass(cam)
Print "Entity name: " + EntityName(cube)
Print "Entity class: " + EntityClass(cube)

Local test:TEntity

For Local child:Int=1 To CountChildren(cube)
	test=GetChild(cube, child)
	If Not test Then Print "No child found" Else Print "Child name: " + EntityName(test)
Next

End
