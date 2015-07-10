Type TAnimation

	Function AnimateMesh(ent1:TEntity,framef:Float,start_frame:Int,end_frame:Int)
		
		
			
	End Function
	
	' AnimateMesh2, used to animate transitions between animations, very similar to AnimateMesh except it
	' interpolates between current animation pose (via saved keyframe) and first keyframe of new animation.
	' framef:Float interpolates between 0 and 1
	
	Function AnimateMesh2(ent1:TEntity,framef:Float,start_frame:Int,end_frame:Int)
		
		
			
	End Function
	
	Function VertexDeform(ent:TMesh)

		
		
	End Function
	
	' this function will normalise weights if their sum doesn't equal 1.0 (unused)
	Function NormaliseWeights(mesh:TMesh)
	
		
		
	End Function

End Type

Type TAnimationKeys

	Field frames:Int
	Field flags:Int[1]
	Field px:Float[1]
	Field py:Float[1]
	Field pz:Float[1]
	Field sx:Float[1]
	Field sy:Float[1]
	Field sz:Float[1]
	Field qw:Float[1]
	Field qx:Float[1]
	Field qy:Float[1]
	Field qz:Float[1]
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TAnimationKeys"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TAnimationKeys"
		EndIf
	
	End Method
	
	Method Copy:TAnimationKeys()
	
		
	
	End Method
	
End Type
