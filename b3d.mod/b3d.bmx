' Copyright (c) 2015, Bruce A Henderson
' All rights reserved.
' 
' Redistribution and use in source and binary forms, with or without
' modification, are permitted provided that the following conditions are met:
' 
' * Redistributions of source code must retain the above copyright notice, this
'   list of conditions and the following disclaimer.
' 
' * Redistributions in binary form must reproduce the above copyright notice,
'   this list of conditions and the following disclaimer in the documentation
'   and/or other materials provided with the distribution.
' 
' THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
' IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
' DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
' FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
' DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
' SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
' CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
' OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
' OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
'
SuperStrict

Rem
bbdoc: 
End Rem
Module Openb3d.B3d

ModuleInfo "Version: 1.00"
ModuleInfo "License: BSD"
ModuleInfo "Copyright: 2015 Bruce A Henderson. All rights reserved"

ModuleInfo "History: 1.00"
ModuleInfo "History: Initial Release."


Private

Global mesh_loaders:TMeshLoader

Public

Rem
bbdoc: Returns a mesh loader capable of loading @extension.
End Rem
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
		_succ=mesh_loaders
		mesh_loaders=Self
	End Method
	
	Method CanLoadMesh:Int(extension:String) Abstract

	Rem
	bbdoc: Call mesh loader implementation.
	about: @obj could be filename (string) or perhaps TStream, if implementation supports it.
	End Rem
	Method LoadMesh:Object(obj:Object, parent:Object = Null) Abstract

	Rem
	bbdoc: Call animated mesh loader implementation
	about: @obj could be filename (string) or perhaps TStream, if implementation supports it.
	End Rem
	Method LoadAnimMesh:Object(obj:Object, parent:Object = Null) Abstract
	
End Type
