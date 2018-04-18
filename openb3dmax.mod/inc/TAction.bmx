
' act enum
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

Rem
bbdoc: Action
End Rem
Type TAction

	Global action_list:TList=CreateList() ' Action list

	Field act:Int Ptr
	
	Field ent:TEntity
	Field target:TEntity ' Optional, target entity for some actions
	
	Field rate:Float Ptr
	Field a:Float Ptr,b:Float Ptr,c:Float Ptr
	
	' extra
	Field endact:Int Ptr,lifetime:Int Ptr
	
	' wrapper
	?bmxng
	Global action_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global action_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	
	Global action_list_id:Int=0
	Field exists:Int=0 ' FreeAction
	
	Function CreateObject:TAction( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TAction=New TAction
		?bmxng
		action_map.Insert( inst,obj )
		?Not bmxng
		action_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		action_map.Remove( inst )
		?Not bmxng
		action_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TAction( inst:Byte Ptr )
	
		?bmxng
		Return TAction( action_map.ValueForKey( inst ) )
		?Not bmxng
		Return TAction( action_map.ValueForKey( String(Int(inst)) ) )
		?
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TAction ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		' int
		act=ActionInt_( GetInstance(Self),ACTION_act )
		endact=ActionInt_( GetInstance(Self),ACTION_endact )
		lifetime=ActionInt_( GetInstance(Self),ACTION_lifetime )
		
		' float
		rate=ActionFloat_( GetInstance(Self),ACTION_rate )
		a=ActionFloat_( GetInstance(Self),ACTION_a )
		b=ActionFloat_( GetInstance(Self),ACTION_b )
		c=ActionFloat_( GetInstance(Self),ACTION_c )
		
		' entity
		Local inst:Byte Ptr=ActionEntity_( GetInstance(Self),ACTION_ent )
		ent=TEntity.GetObject(inst) ' no CreateObject
		inst=ActionEntity_( GetInstance(Self),ACTION_target )
		target=TEntity.GetObject(inst)
		
		AddList_(action_list)
		exists=1
		
	End Method
	
	Function AddList_( list:TList ) ' Global list
	
		Select list
			Case action_list
				If StaticListSize_( ACTION_class,ACTION_action_list )
					Local inst:Byte Ptr=StaticIterListAction_( ACTION_class,ACTION_action_list,Varptr action_list_id )
					Local obj:TAction=GetObject(inst) ' no CreateObject
					If obj Then ListAddLast( list,obj )
				EndIf
		End Select
		
	End Function
	
	Function CopyList_( list:TList ) ' Global list (unused)
	
		ClearList list
		
		Select list
			Case action_list
				action_list_id=0
				For Local id:Int=0 To StaticListSize_( ACTION_class,ACTION_action_list )-1
					Local inst:Byte Ptr=StaticIterListAction_( ACTION_class,ACTION_action_list,Varptr action_list_id )
					Local obj:TAction=GetObject(inst) ' no CreateObject
					If obj Then ListAddLast( list,obj )
				Next
		End Select
		
	End Function
	
	' Openb3d
	
	Method AppendAction( act2:TAction )
	
		AppendAction_( GetInstance(Self),GetInstance(act2) )
		
	End Method
	
	Method FreeAction()
	
		If exists And act[0]=0
			ListRemove( action_list,Self ) ; action_list_id:-1
			
			FreeAction_( GetInstance(Self) )
			FreeObject( GetInstance(Self) )
			exists=0
		EndIf
		
	End Method
	
	Method EndAction()
	
		EndAction_( GetInstance(Self) )
		
	End Method
	
End Type
