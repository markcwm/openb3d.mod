Rem
bbdoc: Texture
End Rem
Type TTexture

	Global tex_list:TList=CreateList()

	Field file$,flags:Int,blend:Int=2,coords:Int,u_scale#=1.0,v_scale#=1.0,u_pos#,v_pos#,angle#
	Field file_abs$,width:Int,height:Int ' returned by Name/Width/Height commands
	Field pixmap:TPixmap
	Field gltex:Int[1]
	Field cube_pixmap:TPixmap[7]
	Field no_frames:Int=1
	Field no_mipmaps:Int
	Field cube_face:Int=0,cube_mode:Int=1
	
	Global tex_map:TMap=New TMap
	Field instance:Byte Ptr
	
	' Create and map object from C++ instance
	Function NewObject:TTexture( inst:Byte Ptr )
	
		Local obj:TTexture=New TTexture
		tex_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	' Delete object from C++ instance
	Function DeleteObject( inst:Byte Ptr )
	
		tex_map.Remove( String(Long(inst)) )
		
	End Function
	
	' Get object from C++ instance
	Function GetObject:TTexture( inst:Byte Ptr )
	
		Return TTexture( tex_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	' Get C++ instance from object (used for passing object to C++ function)
	Function GetInstance:Byte Ptr( obj:TTexture )
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method DepthBufferToTex( frame:Int=0 )
	
		DepthBufferToTex_( GetInstance(Self),frame )
		
	End Method
	
	Method BufferToTex( buffer:Byte Ptr,frame:Int=0 )
	
		BufferToTex_( GetInstance(Self),buffer,frame )
		
	End Method
	
	Method CameraToTex( cam:TCamera,frame:Int=0 )
	
		CameraToTex_( GetInstance(Self),TCamera.GetInstance(cam),frame )
		
	End Method
	
	Method TexToBuffer( buffer:Byte Ptr,frame:Int=0 )
	
		TexToBuffer_( GetInstance(Self),buffer,frame )
		
	End Method
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TTexture"
		EndIf
	
	End Method
	
	Method Delete()
	
		If LOG_DEL
			DebugLog "Del TTexture"
		EndIf
	
	End Method
	
	Method FreeTexture() 'SMALLFIXES New function from http://www.blitzbasic.com/Community/posts.php?topic=88263#1002039
	
		DeleteObject( GetInstance(Self) )
		FreeTexture_( GetInstance(Self) )
		
	End Method
	
	Function CreateTexture:TTexture( width:Int,height:Int,flags:Int=9,frames:Int=1 )
	
		Local instance:Byte Ptr=CreateTexture_( width,height,flags,frames )
		Return NewObject(instance)
		
	End Function
	
	Function LoadTexture:TTexture( file:String,flags:Int=1 )
	
		Local cString:Byte Ptr=file.ToCString()
		Local instance:Byte Ptr=LoadTexture_( cString,flags )
		Local tex:TTexture=NewObject(instance)
		MemFree cString
		Return tex
		
	End Function
	
	Function LoadAnimTexture:TTexture( file:String,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int )
	
		Local cString:Byte Ptr=file.ToCString()
		Local instance:Byte Ptr=LoadAnimTexture_( cString,flags,frame_width,frame_height,first_frame,frame_count )
		Local tex:TTexture=NewObject(instance)
		MemFree cString
		Return tex
		
	End Function
	
	Function CreateCubeMapTexture:TTexture(width:Int,height:Int,flags:Int,tex:TTexture=Null)
		
		
		
	End Function

	Function LoadCubeMapTexture:TTexture(file$,flags:Int=1,tex:TTexture=Null)
		
		

	End Function
	
	Method TextureBlend( blend:Int )
	
		TextureBlend_( GetInstance(Self),blend )
		
	End Method
	
	Method TextureCoords( coords:Int )
	
		TextureCoords_( GetInstance(Self),coords )
		
	End Method
	
	Method ScaleTexture( u_scale:Float,v_scale:Float )
	
		ScaleTexture_( GetInstance(Self),u_scale,v_scale )
		
	End Method
	
	Method PositionTexture( u_pos:Float,v_pos:Float )
	
		PositionTexture_( GetInstance(Self),u_pos,v_pos )
		
	End Method
	
	Method RotateTexture( ang:Float )
	
		RotateTexture_( GetInstance(Self),ang )
		
	End Method
	
	Method TextureWidth:Int()
	
		Return TextureWidth_( GetInstance(Self) )
		
	End Method
	
	Method TextureHeight:Int()
	
		Return TextureHeight_( GetInstance(Self) )
		
	End Method
	
	Method TextureName:String()
	
		Return String.FromCString( TextureName_( GetInstance(Self) ) )
		
	End Method
	
	Rem
	' moved to TBrush.bmx
	Function GetBrushTexture:TTexture( brush:TBrush,index:Int=0 )
	
		
		
	End Function
	EndRem
	
	Function ClearTextureFilters()
	
		ClearTextureFilters_()
		
	End Function
	
	Function TextureFilter( match_text:String,flags:Int )
	
		Local cString:Byte Ptr=match_text.ToCString()
		TextureFilter_( cString,flags )
		MemFree cString
		
	End Function
	
	Method SetCubeFace( face:Int )
	
		SetCubeFace_( GetInstance(Self),face )
		
	End Method
	
	Method SetCubeMode( Mode:Int )
	
		SetCubeMode_( GetInstance(Self),Mode )
		
	End Method
	
	Method BackBufferToTex( frame:Int=0 )
	
		BackBufferToTex_( GetInstance(Self),frame )
		
	End Method
		
	Method CountMipmaps:Int()
	
		'Return no_mipmaps
		
	End Method
	
	Method MipmapWidth:Int(mipmap_no:Int)
	
		
		
	End Method
	
	Method MipmapHeight:Int(mipmap_no:Int)
	
		
		
	End Method
	
	
	Function FileFind%(file$ Var) 'SMALLFIXES, replaced function to alow Incbin and Zipstream (from http://blitzmax.com/Community/posts.php?topic=88901#1009408 ) 
	
		
		
	End Function
	
	Rem
	' Internal - not recommended for general use	
	Function FileFind:Int(file$ Var)
	
		
		
	End Function
	EndRem
	
	Function FileAbs$(file$)
	
		
	
	End Function
		
	Method TexInList:TTexture()

		
	
	End Method
	
	Method FilterFlags()
	
		
	
	End Method
		
	Function AdjustPixmap:TPixmap(pixmap:TPixmap)
	
		
		
	End Function
	
	Function Pow2Size:Int( n:Int )
	
		
		
	End Function

	' applys alpha to a pixmap based on average of colour values
	Function ApplyAlpha:TPixmap( pixmap:TPixmap ) NoDebug
	
		
		
	End Function

End Type

Type TTextureFilter

	Global filter_list:TList=CreateList()

	Field Text$
	Field flags:Int
	
End Type
