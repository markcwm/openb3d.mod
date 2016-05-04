
Rem
bbdoc: Sprite mesh entity
End Rem
Type TSprite Extends TMesh

	Field angle:Float Ptr ' 0.0
	Field scale_x:Float Ptr,scale_y:Float Ptr ' 1.0/1.0
	Field handle_x:Float Ptr,handle_y:Float Ptr ' 0.0/0.0
	Field view_mode:Int Ptr ' 1
	Field render_mode:Int Ptr ' openb3d - 1
	
	Function CreateObject:TSprite( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TSprite=New TSprite
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		Super.InitFields()
		
		' int
		view_mode=SpriteInt_( GetInstance(Self),SPRITE_view_mode )
		render_mode=SpriteInt_( GetInstance(Self),SPRITE_render_mode )
		
		' float
		angle=SpriteFloat_( GetInstance(Self),SPRITE_angle )
		scale_x=SpriteFloat_( GetInstance(Self),SPRITE_scale_x )
		scale_y=SpriteFloat_( GetInstance(Self),SPRITE_scale_y )
		handle_x=SpriteFloat_( GetInstance(Self),SPRITE_handle_x )
		handle_y=SpriteFloat_( GetInstance(Self),SPRITE_handle_y )
		
	End Method
	
	' Openb3d
	
	Method SpriteRenderMode( Mode:Int )
	
		SpriteRenderMode_( GetInstance(Self),Mode )
		
	End Method
	
	' Minib3d
	
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
	
	Function CreateSprite:TSprite( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateSprite_( GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Function LoadSprite:TSprite( tex_file:String,tex_flag:Int=1,parent:TEntity=Null )
	
		Local cString:Byte Ptr=tex_file.ToCString()
		Local inst:Byte Ptr=LoadSprite_( cString,tex_flag,GetInstance(parent) )
		Local sprite:TSprite=CreateObject(inst)
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
	
	' Internal
	
	Method CopyEntity:TSprite( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Local sprite:TSprite=CreateObject(inst)
		If pick_mode[0] Then TPick.AddList_(TPick.ent_list)
		Return sprite
		
	End Method
	
	' set vertex texture coords for sprite - uv values are calculated from parameters
	Method SpriteTexCoords( cell_x:Int,cell_y:Int,cell_w:Int,cell_h:Int,tex_w:Int,tex_h:Int,uv_set:Int=0 )
	
		SpriteTexCoords_( GetInstance(Self),cell_x,cell_y,cell_w,cell_h,tex_w,tex_h,uv_set )
		
	End Method
	
	' set vertex color for sprite
	Method SpriteVertexColor( v:Int,r:Float,g:Float,b:Float )
	
		SpriteVertexColor_( GetInstance(Self),v,r,g,b )
		
	End Method
	
End Type
