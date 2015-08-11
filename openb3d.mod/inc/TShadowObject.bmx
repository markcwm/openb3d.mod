
' TShadowTriangle

' TEdge

Rem
bbdoc: Shadow-object
End Rem
Type TShadowObject

	Global shad_map:TMap=New TMap
	Field instance:Byte Ptr
	
	Function CreateObject:TShadowObject( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TShadowObject=New TShadowObject
		shad_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		shad_map.Remove( String(Long(inst)) )
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TShadowObject ) ' ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	' Openb3d
	
	Function CreateShadow:TShadowObject( parent:TMesh,Static:Int=False )
	
		Local inst:Byte Ptr=CreateShadow_( TMesh.GetInstance(parent),Static )
		Return CreateObject(inst)
		
	End Function
	
	Method FreeShadow()
	
		FreeObject( GetInstance(Self) )
		FreeShadow_( GetInstance(Self) )
		
	End Method
	
End Type
