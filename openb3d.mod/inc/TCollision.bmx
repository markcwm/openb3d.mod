Type TCollisionPair

	Global list:TList=New TList
	Global ent_lists:TList[MAX_TYPES]

	Field src_type:Int
	Field des_type:Int
	Field col_method:Int=0
	Field response:Int=0
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TCollisionPair"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TCollisionPair"
		EndIf
	
	End Method

End Type

Type TCollisionImpact

	Method New()
	
		If LOG_NEW
			DebugLog "New TCollisionImpact"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TCollisionImpact"
		EndIf
	
	End Method

	Field x#,y#,z#
	Field nx#,ny#,nz#
	Field time#
	Field ent:TEntity
	Field surf:TSurface
	Field tri:Int

End Type

Const MAX_TYPES:Int=100

'collision methods
Const COLLISION_METHOD_SPHERE:Int=1
Const COLLISION_METHOD_POLYGON:Int=2
Const COLLISION_METHOD_BOX:Int=3

'collision actions
Const COLLISION_RESPONSE_NONE:Int=0
Const COLLISION_RESPONSE_STOP:Int=1
Const COLLISION_RESPONSE_SLIDE:Int=2
Const COLLISION_RESPONSE_SLIDEXZ:Int=3

Function UpdateCollisions()

	

End Function

' perform quick check to see whether it is possible that ent and ent 2 are intersecting
Function QuickCheck:Int(ent:TEntity,ent2:TEntity)

	

End Function
