
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
		?bmxng
		ent_map.Insert( inst,obj )
		?Not bmxng
		ent_map.Insert( String(Int(inst)),obj )
		?
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
	
	Method DebugFields( debug_subobjects:Int=0,debug_base_types:Int=0 )
	
		Local pad:String
		Local loop:Int=debug_subobjects
		If debug_base_types>debug_subobjects Then loop=debug_base_types
		For Local i%=1 Until loop
			pad:+"  "
		Next
		If debug_subobjects Then debug_subobjects:+1
		If debug_base_types Then debug_base_types:+1
		DebugLog pad+" Sprite instance: "+StringPtr(GetInstance(Self))
		
		' int
		If view_mode<>Null Then DebugLog(pad+" view_mode: "+view_mode[0]) Else DebugLog(pad+" view_mode: Null")
		If render_mode<>Null Then DebugLog(pad+" render_mode: "+render_mode[0]) Else DebugLog(pad+" render_mode: Null")
		
		' float
		If angle<>Null Then DebugLog(pad+" angle: "+angle[0]) Else DebugLog(pad+" angle: Null")
		If scale_x<>Null Then DebugLog(pad+" scale_x: "+scale_x[0]) Else DebugLog(pad+" scale_x: Null")
		If scale_y<>Null Then DebugLog(pad+" scale_y: "+scale_y[0]) Else DebugLog(pad+" scale_y: Null")
		If handle_x<>Null Then DebugLog(pad+" handle_x: "+handle_x[0]) Else DebugLog(pad+" handle_x: Null")
		If handle_y<>Null Then DebugLog(pad+" handle_y: "+handle_y[0]) Else DebugLog(pad+" handle_y: Null")
		
		DebugLog ""
		
		If debug_base_types Then Super.DebugFields( debug_subobjects,debug_base_types )
		
	End Method
	
	Function NewSprite:TSprite()
	
		Local inst:Byte Ptr=NewSprite_()
		Return CreateObject(inst)
		
	End Function
	
	' Openb3d
	
	Method SpriteRenderMode( Mode:Int )
	
		SpriteRenderMode_( GetInstance(Self),Mode )
		
	End Method
	
	' Minib3d
	
	Method New()
		
		If TGlobal3D.Log_New
			DebugLog " New TSprite"
		EndIf
		
	End Method
	
	Method Delete()
	
		If TGlobal3D.Log_Del
			DebugLog " Del TSprite"
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
