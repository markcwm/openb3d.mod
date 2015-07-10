Rem
bbdoc: Brush
End Rem
Type TBrush

	Field no_texs:Int
	Field name$
	Field red#=1.0,green#=1.0,blue#=1.0,alpha#=1.0
	Field shine#
	Field blend:Int,fx:Int
	Field tex_frame:Int
	Field tex:TTexture[8]
	
	Global brush_map:TMap=New TMap
	Field instance:Byte Ptr
	
	' Create and map object from C++ instance
	Function NewObject:TBrush( inst:Byte Ptr )
	
		Local obj:TBrush=New TBrush
		brush_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	' Delete object from C++ instance
	Function DeleteObject( inst:Byte Ptr )
	
		brush_map.Remove( String(Long(inst)) )
		
	End Function
	
	' Get object from C++ instance
	Function GetObject:TBrush( inst:Byte Ptr )
	
		Return TBrush( brush_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	' Get C++ instance from object (used for passing object to C++ function)
	Function GetInstance:Byte Ptr( obj:TBrush )
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	' moved from TTexture.bmx
	Method GetBrushTexture:TTexture( index:Int=0 )
	
		Local instance:Byte Ptr=GetBrushTexture_( GetInstance(Self),index )
		Local tex:TTexture=TTexture.GetObject(instance)
		If tex=Null And instance<>Null Then tex=TTexture.NewObject(instance)
		Return tex
		
	End Method
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TBrush"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TBrush"
		EndIf
	
	End Method
	
	Method Copy:TBrush()
		
		

	End Method
	
	Method FreeBrush()
	
		DeleteObject( GetInstance(Self) )
		FreeBrush_( GetInstance(Self) )
		
	End Method
		
	Function CreateBrush:TBrush( r:Float=255,g:Float=255,b:Float=255 )
	
		Local instance:Byte Ptr=CreateBrush_( r,g,b )
		Return NewObject(instance)
		
	End Function
	
	Function LoadBrush:TBrush( file:String,flags:Int=1,u_scale:Float=1,v_scale:Float=1 )
	
		Local cString:Byte Ptr=file.ToCString()
		Local instance:Byte Ptr=LoadBrush_( cString,flags,u_scale,v_scale )
		Local brush:TBrush=NewObject(instance)
		MemFree cString
		Return brush
		
	End Function
	
	Method BrushColor( r:Float,g:Float,b:Float )
	
		BrushColor_( GetInstance(Self),r,g,b )
		
	End Method
	
	Method BrushAlpha( a:Float )
	
		BrushAlpha_( GetInstance(Self),a )
		
	End Method
	
	Method BrushShininess( s:Float )
	
		BrushShininess_( GetInstance(Self),s )
		
	End Method
	
	Method BrushTexture( tex:TTexture,frame:Int=0,index:Int=0 )
	
		BrushTexture_( GetInstance(Self),TTexture.GetInstance(tex),frame,index )
		
	End Method
	
	Method BrushBlend( blend:Int )
	
		BrushBlend_( GetInstance(Self),blend )
		
	End Method
	
	Method BrushFX( fx:Int )
	
		BrushFX_( GetInstance(Self),fx )
		
	End Method
	
	Rem
	' moved to TEntity.bmx
	Function GetEntityBrush:TBrush( ent:TEntity )
	
		
		
	End Function
	EndRem
	
	Function GetSurfaceBrush:TBrush( surf:TSurface )
	
		Local instance:Byte Ptr=GetSurfaceBrush_( TSurface.GetInstance(surf) )
		Local brush:TBrush=GetObject(instance)
		If brush=Null And instance<>Null Then brush=NewObject(instance)
		Return brush
		
	End Function
	
	Function CompareBrushes:Int(brush1:TBrush,brush2:TBrush)
	
		
	
	End Function
	
End Type
