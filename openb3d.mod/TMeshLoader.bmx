' factory mesh loader by Bruce A Henderson

Private

Global mesh_loaders:TMeshLoader

Public

'Rem
'bbdoc: Returns a mesh loader capable of loading @extension.
'End Rem
Function GetMeshLoader:TMeshLoader(extension:String)

	Local loader:TMeshLoader = mesh_loaders
	
	While loader
		If loader.CanLoadMesh(extension) Then
			Return loader
		End If
		loader = loader._succ
	Wend

End Function


Type TMeshLoader
	Field _succ:TMeshLoader
	
	Method New()
		_succ = mesh_loaders
		mesh_loaders = Self
	End Method
	
	Method CanLoadMesh:Int(extension:String) Abstract

	'Rem
	'bbdoc: Call mesh loader implementation.
	'about: @obj could be filename (string) or perhaps TStream, if implementation supports it.
	'End Rem
	Method LoadMesh:Object(obj:Object, parent:Object = Null) Abstract

	'Rem
	'bbdoc: Call animated mesh loader implementation
	'about: @obj could be filename (string) or perhaps TStream, if implementation supports it.
	'End Rem
	Method LoadAnimMesh:Object(obj:Object, parent:Object = Null) Abstract
	
End Type
