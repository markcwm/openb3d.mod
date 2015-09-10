
Rem
Const ACT_COMPLETED:Int=		0
Const ACT_MOVEBY:Int=			1
Const ACT_TURNBY:Int=			2
Const ACT_VECTOR:Int=			3
Const ACT_MOVETO:Int=			4
Const ACT_TURNTO:Int=			5
Const ACT_SCALETO:Int=			6
Const ACT_FADETO:Int=			7
Const ACT_TINTTO:Int=			8
Const ACT_TRACK_BY_POINT:Int=	9
Const ACT_TRACK_BY_DISTANCE:Int=10
Const ACT_NEWTONIAN:Int=		11
EndRem

Rem
bbdoc: Action
End Rem
Type TAction
	
	Global action_map:TMap=New TMap
	Field instance:Byte Ptr
	
	Function CreateObject:TAction( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TAction=New TAction
		obj.instance=inst
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		action_map.Remove( String(Long(inst)) )
		
	End Function
	
	Function GetObject:TAction( inst:Byte Ptr )
	
		Return TAction( action_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TAction ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	' Openb3d
	
	Method AppendAction( act2:TAction )
	
		AppendAction_( GetInstance(Self),GetInstance(act2) )
		
	End Method
	
End Type
