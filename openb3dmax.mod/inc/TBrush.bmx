
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
	?bmxng
	Global brush_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global brush_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	
	Field exists:Int=0 ' FreeBrush
	
	Function CreateObject:TBrush( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TBrush=New TBrush
		?bmxng
		brush_map.Insert( inst,obj )
		?Not bmxng
		brush_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		brush_map.Remove( inst )
		?Not bmxng
		brush_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TBrush( inst:Byte Ptr )
	
		?bmxng
		Return TBrush( brush_map.ValueForKey( inst ) )
		?Not bmxng
		Return TBrush( brush_map.ValueForKey( String(Int(inst)) ) )
		?
		
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
			'If tex[id]<>Null Then DebugLog " get tex="+id+" tex.file="+tex[id].GetString(tex[id].file)
		Next
		
		exists=1
		
	End Method
	
	Method DebugObject()
	
		DebugLog " Brush instance: "+StringPtr(GetInstance(Self))
		
		' int
		If no_texs<>Null Then DebugLog(" no_texs: "+no_texs[0]) Else DebugLog(" no_texs: 0")
		If blend<>Null Then DebugLog(" blend: "+blend[0]) Else DebugLog(" blend: 0")
		If fx<>Null Then DebugLog(" fx: "+fx[0]) Else DebugLog(" fx: 0")
		
		' uint
		DebugLog " cache_frame: "+StringPtr(cache_frame)
		For Local id:Int=0 To 7
			DebugLog(" cache_frame["+id+"] = "+cache_frame[id])
		Next
		
		' float
		If red<>Null Then DebugLog(" red: "+red[0]) Else DebugLog(" red: 0")
		If green<>Null Then DebugLog(" green: "+green[0]) Else DebugLog(" green: 0")
		If blue<>Null Then DebugLog(" blue: "+blue[0]) Else DebugLog(" blue: 0")
		If alpha<>Null Then DebugLog(" alpha: "+alpha[0]) Else DebugLog(" alpha: 0")
		If shine<>Null Then DebugLog(" shine: "+shine[0]) Else DebugLog(" shine: 0")
		
		' string
		If name<>Null Then DebugLog(" name: "+GetString(name)) Else DebugLog(" name: 0")
		
		' texture
		For Local id:Int=0 To 7
			If tex[id]<>Null Then DebugLog(" tex["+id+"]: "+StringPtr(TTexture.GetInstance(tex[id])))
		Next
		
		DebugLog ""
		
	End Method
	
	' Extra
	
	' Frees all brush textures, FreeBrush does not free textures
	Method FreeBrushTextures()
	
		For Local id:Int=0 To 7
			If tex[id]<>Null Then tex[id].FreeTexture()
		Next
		
	End Method
	
	' Gets a Blitz string from a C string
	Method GetString:String( str:Byte Ptr )
	
		Select str
			Case name
				Return String.FromCString( BrushString_( GetInstance(Self),BRUSH_name ) )
		End Select
		
	End Method
	
	' Sets a C string from a Blitz string
	Method SetString( strPtr:Byte Ptr, strValue:String )
	
		Select strPtr
			Case name
				Local cString:Byte Ptr=strValue.ToCString()
				SetBrushString_( GetInstance(Self),BRUSH_name,cString )
				MemFree cString
				name=BrushString_( GetInstance(Self),BRUSH_name )	
		End Select
		
	End Method
	
	' GL equivalent, experimental
	Method BrushGLColor( r:Float,g:Float,b:Float,a:Float=1.0 )
	
		BrushGLColor_( GetInstance(Self),r,g,b,a )
		
	End Method
	
	' GL equivalent, experimental
	Method BrushGLBlendFunc( sfactor:Int,dfactor:Int )
	
		BrushGLBlendFunc_( GetInstance(Self),sfactor,dfactor )
		
	End Method
	
	' Openb3d
	
	Method GetBrushTexture:TTexture( index:Int=0 ) ' same as function in TTexture
	
		Local inst:Byte Ptr=GetBrushTexture_( GetInstance(Self),index )
		Return TTexture.GetObject(inst) ' no CreateObject
		
	End Method
	
	' Minib3d
	
	Method New()
	
		If TGlobal.Log_New
			DebugLog " New TBrush"
		EndIf
	
	End Method
	
	Method Delete()
	
		If TGlobal.Log_Del
			DebugLog " Del TBrush"
		EndIf
		
	End Method
	
	' Frees a brush but not it's textures in case they are shared
	Method FreeBrush()
	
		If exists
			FreeBrush_( GetInstance(Self) )
			FreeObject( GetInstance(Self) )
			exists=0
		EndIf
		
	End Method
	
	Function CreateBrush:TBrush( r:Float=255,g:Float=255,b:Float=255 )
	
		Local inst:Byte Ptr=CreateBrush_( r,g,b )
		Return CreateObject(inst)
		
	End Function
	
	Function LoadBrush:TBrush( file:String,flags:Int=9,u_scale:Float=1,v_scale:Float=1 )
	
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
	
	Method BrushTexture( texture:TTexture,frame:Int=0,index:Int=0 )
	
		BrushTexture_( GetInstance(Self),TTexture.GetInstance(texture),frame,index )
		
		tex[index]=texture
		
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
