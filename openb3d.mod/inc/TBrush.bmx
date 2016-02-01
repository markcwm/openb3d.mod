
Rem
bbdoc: Brush
End Rem
Type TBrush

	Field no_texs:Int Ptr ' 0
	Field name:Byte Ptr ' string - ""
	Field red:Float Ptr,green:Float Ptr,blue:Float Ptr,alpha:Float Ptr ' 1.0/1.0/1.0/1.0
	Field shine:Float Ptr ' 0.0
	Field blend:Int Ptr,fx:Int Ptr ' 0/0
	Field cache_frame:Int Ptr ' openb3d: unsigned int array [8]
	Field tex:TTexture[8] ' returned by GetBrushTexture - NULL
	
	' minib3d
	'Field tex_frame:Int ' 0
	
	' wrapper
	Global brush_map:TMap=New TMap
	Field instance:Byte Ptr
	
	Field exists:Int=0 ' FreeBrush
	
	Function CreateObject:TBrush( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TBrush=New TBrush
		brush_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		brush_map.Remove( String(Long(inst)) )
		
	End Function
	
	Function GetObject:TBrush( inst:Byte Ptr )
	
		Return TBrush( brush_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TBrush ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		' int
		no_texs=BrushInt_( GetInstance(Self),BRUSH_no_texs )
		blend=BrushInt_( GetInstance(Self),BRUSH_blend )
		fx=BrushInt_( GetInstance(Self),BRUSH_fx )
		
		' uint
		cache_frame=BrushUInt_( GetInstance(Self),BRUSH_cache_frame )
		
		' float
		red=BrushFloat_( GetInstance(Self),BRUSH_red )
		green=BrushFloat_( GetInstance(Self),BRUSH_green )
		blue=BrushFloat_( GetInstance(Self),BRUSH_blue )
		alpha=BrushFloat_( GetInstance(Self),BRUSH_alpha )
		shine=BrushFloat_( GetInstance(Self),BRUSH_shine )
		
		' string
		name=BrushString_( GetInstance(Self),BRUSH_name )	
		
		' texture
		For Local id:Int=0 To 7
			Local inst:Byte Ptr=BrushTextureArray_( GetInstance(Self),BRUSH_tex,id )
			tex[id]=TTexture.GetObject(inst)
			If tex[id]=Null And inst<>Null Then tex[id]=TTexture.CreateObject(inst)
		Next
		
		exists=1
		
	End Method
	
	' Openb3d
	
	Method GetBrushTexture:TTexture( index:Int=0 ) ' same as function in TTexture
	
		Local inst:Byte Ptr=GetBrushTexture_( GetInstance(Self),index )
		Return TTexture.GetObject(inst) ' no CreateObject
		
	End Method
	
	' Minib3d
	
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
	
	Method FreeBrush()
	
		If exists
			FreeObject( GetInstance(Self) )
			FreeBrush_( GetInstance(Self) )
			exists=0
		EndIf
		
	End Method
	
	Function CreateBrush:TBrush( r:Float=255,g:Float=255,b:Float=255 )
	
		Local inst:Byte Ptr=CreateBrush_( r,g,b )
		Return CreateObject(inst)
		
	End Function
	
	Function LoadBrush:TBrush( file:String,flags:Int=1,u_scale:Float=1,v_scale:Float=1 )
	
		Local cString:Byte Ptr=file.ToCString()
		Local inst:Byte Ptr=LoadBrush_( cString,flags,u_scale,v_scale )
		Local brush:TBrush=CreateObject(inst)
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
	
	Function GetEntityBrush:TBrush( ent:TEntity ) ' same as method in TEntity
	
		Local inst:Byte Ptr=GetEntityBrush_( TEntity.GetInstance(ent) )
		Local brush:TBrush=GetObject(inst)
		If brush=Null And inst<>Null Then brush=CreateObject(inst)
		Return brush
		
	End Function
	
	Function GetSurfaceBrush:TBrush( surf:TSurface ) ' same as method in TSurface
	
		Local inst:Byte Ptr=GetSurfaceBrush_( TSurface.GetInstance(surf) )
		Local brush:TBrush=GetObject(inst)
		If brush=Null And inst<>Null Then brush=CreateObject(inst)
		Return brush
		
	End Function
	
	' Internal
	
	Method Copy:TBrush()
		
		Local inst:Byte Ptr=BrushCopy_( GetInstance(Self) )
		Return CreateObject(inst)
		
	End Method
	
	' returns true if specified brush1 has same properties as brush2 - called by AddMesh
	Function CompareBrushes:Int( brush1:TBrush,brush2:TBrush )
	
		Return CompareBrushes_( GetInstance(brush1),GetInstance(brush2) )
		
	End Function
	
End Type
