
SuperStrict

' FindChild.bmx
' by BlitzSupport

Import openb3d.b3dglgraphics

Graphics3D 1024, 768, 0, 60

Local cam:TCamera = CreateCamera ()
Local cube:TMesh = CreateCube ()

Local cube2:TMesh = CreateCube (cube)
Local cube3:TMesh = CreateCube (cube)

NameEntity cam, "MyCamera"

NameEntity cube, "MyCube"
NameEntity cube2, "MyCube Two"
NameEntity cube3, "MyCube Three"

Print CountChildren (cube)

Print "Entity name: " + EntityName (cam)
Print "Entity class: " + EntityClass (cam)

Print "Entity name: " + EntityName (cube)
Print "Entity class: " + EntityClass (cube)

Local test:TEntity

test = FindChild (cube, "MyCube Two")
If Not test Then Print "No child found"
Print EntityName (test)

test = FindChild (cube, "MyCube Three")
If Not test Then Print "No child found"
Print EntityName (test)
