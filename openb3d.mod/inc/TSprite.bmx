Rem
bbdoc: Sprite mesh entity
End Rem
Type TSprite Extends TMesh

	Field angle#
	Field scale_x#=1.0,scale_y#=1.0
	Field handle_x#,handle_y# 
	Field view_mode:Int=1
	
	' Create and map object from C++ instance
	Function NewObject:TSprite( inst:Byte Ptr )
	
		Local obj:TSprite=New TSprite
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	Method ParticleColor( r:Float,g:Float,b:Float,a:Float=0 )
	
		ParticleColor_( GetInstance(Self),r,g,b,a )
		
	End Method
	
	Method ParticleVector( x:Float,y:Float,z:Float )
	
		ParticleVector_( GetInstance(Self),x,y,z )
		
	End Method
	
	Method ParticleTrail( length:Int )
	
		ParticleTrail_( GetInstance(Self),length )
		
	End Method
	
	Method SpriteRenderMode( Mode:Int )
	
		SpriteRenderMode_( GetInstance(Self),Mode )
		
	End Method
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TSprite"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TSprite"
		EndIf
	
	End Method
	
	Method CopyEntity:TSprite( parent:TEntity=Null )
	
		Local instance:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return NewObject(instance)
		
	End Method
	
	Function CreateSprite:TSprite( parent:TEntity=Null )
	
		Local instance:Byte Ptr=CreateSprite_( GetInstance(parent) )
		Return NewObject(instance)
		
	End Function
	
	Function LoadSprite:TSprite( tex_file:String,tex_flag:Int=1,parent:TEntity=Null )
	
		Local cString:Byte Ptr=tex_file.ToCString()
		Local instance:Byte Ptr=LoadSprite_( cString,tex_flag,GetInstance(parent) )
		Local sprite:TSprite=NewObject(instance)
		MemFree cString
		Return sprite
		
	End Function
	
	Method RotateSprite( ang:Float )
	
		RotateSprite_( GetInstance(Self),ang )
		
	End Method
	
	Method ScaleSprite( s_x:Float,s_y:Float )
	
		ScaleSprite_( GetInstance(Self),s_x,s_y )
		
	End Method
	
	Method HandleSprite( h_x:Float,h_y:Float )
	
		HandleSprite_( GetInstance(Self),h_x,h_y )
		
	End Method
	
	Method SpriteViewMode( Mode:Int )
	
		SpriteViewMode_( GetInstance(Self),Mode )
		
	End Method
	
End Type

