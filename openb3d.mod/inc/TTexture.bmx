
Rem
bbdoc: Texture
End Rem
Type TTexture

	Field texture:Int Ptr ' unsigned int GL name
	
	Global tex_list:TList=CreateList() ' Texture list
	
	Field file:Byte Ptr ' string returned by TextureName - ""
	Field frames:Int Ptr ' unsigned int*
	
	Field flags:Int Ptr,blend:Int Ptr,coords:Int Ptr ' 0/2/0
	Field u_scale:Float Ptr,v_scale:Float Ptr ' 1.0/1.0
	Field u_pos:Float Ptr,v_pos:Float Ptr,angle:Float Ptr ' 0.0/0.0/0.0
	Field file_abs:Byte Ptr ' string - ""
	Field width:Int Ptr,height:Int Ptr ' returned by TextureWidth/TextureHeight - 0/0
	Field no_frames:Int Ptr ' 1
	Field framebuffer:Int Ptr ' openb3d: unsigned int* - 0
	Field cube_face:Int Ptr,cube_mode:Int Ptr ' 0/1
	
	' minib3d
	'Field pixmap:TPixmap
	'Field gltex:Int[1]
	'Field cube_pixmap:TPixmap[7]
	'Field no_mipmaps:Int
	
	' wrapper
	Global tex_map:TMap=New TMap
	Field instance:Byte Ptr
	
	Function CreateObject:TTexture( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TTexture=New TTexture
		tex_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		tex_map.Remove( String(Long(inst)) )
		
	End Function
	
	Function GetObject:TTexture( inst:Byte Ptr )
	
		Return TTexture( tex_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TTexture ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		' int
		flags=TextureInt_( GetInstance(Self),TEXTURE_flags )
		blend=TextureInt_( GetInstance(Self),TEXTURE_blend )
		coords=TextureInt_( GetInstance(Self),TEXTURE_coords )
		width=TextureInt_( GetInstance(Self),TEXTURE_width )
		height=TextureInt_( GetInstance(Self),TEXTURE_height )
		no_frames=TextureInt_( GetInstance(Self),TEXTURE_no_frames )
		cube_face=TextureInt_( GetInstance(Self),TEXTURE_cube_face )
		cube_mode=TextureInt_( GetInstance(Self),TEXTURE_cube_mode )
		
		' uint
		texture=TextureUInt_( GetInstance(Self),TEXTURE_texture )
		frames=TextureUInt_( GetInstance(Self),TEXTURE_frames )
		framebuffer=TextureUInt_( GetInstance(Self),TEXTURE_framebuffer )
		
		' float
		u_scale=TextureFloat_( GetInstance(Self),TEXTURE_u_scale )
		v_scale=TextureFloat_( GetInstance(Self),TEXTURE_v_scale )
		u_pos=TextureFloat_( GetInstance(Self),TEXTURE_u_pos )
		v_pos=TextureFloat_( GetInstance(Self),TEXTURE_v_pos )
		angle=TextureFloat_( GetInstance(Self),TEXTURE_angle )
		
		' string
		file=TextureString_( GetInstance(Self),TEXTURE_file )
		file_abs=TextureString_( GetInstance(Self),TEXTURE_file_abs )
		
	End Method
	
	Function CopyList_( list:TList ) ' Global list
	
		Local inst:Byte Ptr
		ClearList list
		
		Select list
			Case tex_list
				For Local id:Int=0 To StaticListSize_( TEXTURE_class,TEXTURE_tex_list )-1
					inst=StaticIterListTexture_( TEXTURE_class,TEXTURE_tex_list )
					Local obj:TTexture=GetObject(inst)
					If obj=Null And inst<>Null Then obj=CreateObject(inst)
					ListAddLast list,obj
				Next
		End Select
		
	End Function
	
	' Openb3d
	
	Method BufferToTex( buffer:Byte Ptr,frame:Int=0 )
	
		BufferToTex_( GetInstance(Self),buffer,frame )
		
	End Method
	
	Method TexToBuffer( buffer:Byte Ptr,frame:Int=0 )
	
		TexToBuffer_( GetInstance(Self),buffer,frame )
		
	End Method
	
	Method CameraToTex( cam:TCamera,frame:Int=0 )
	
		CameraToTex_( GetInstance(Self),TCamera.GetInstance(cam),frame )
		
	End Method
	
	Method DepthBufferToTex( cam:TCamera=Null )
	
		DepthBufferToTex_( GetInstance(Self),TCamera.GetInstance(cam) )
		
	End Method
	
	' Minib3d
	
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
	
	Method FreeTexture() 'SMALLFIXES New function from www.blitzbasic.com/Community/posts.php?topic=88263#1002039
	
		FreeObject( GetInstance(Self) )
		FreeTexture_( GetInstance(Self) )
		
	End Method
	
	Function CreateTexture:TTexture( width:Int,height:Int,flags:Int=9,frames:Int=1 )
	
		Local inst:Byte Ptr=CreateTexture_( width,height,flags,frames )
		Return CreateObject(inst)
		
	End Function
	
	Function LoadTexture:TTexture( file:String,flags:Int=1 )
	
		Local cString:Byte Ptr=file.ToCString()
		Local inst:Byte Ptr=LoadTexture_( cString,flags )
		Local tex:TTexture=CreateObject(inst)
		MemFree cString
		Return tex
		
	End Function
	
	Function LoadAnimTexture:TTexture( file:String,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int )
	
		Local cString:Byte Ptr=file.ToCString()
		Local inst:Byte Ptr=LoadAnimTexture_( cString,flags,frame_width,frame_height,first_frame,frame_count )
		Local tex:TTexture=CreateObject(inst)
		MemFree cString
		Return tex
		
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
	
	Function GetBrushTexture:TTexture( brush:TBrush,index:Int=0 ) ' same as method in TBrush
	
		Local inst:Byte Ptr=GetBrushTexture_( TBrush.GetInstance(brush),index )
		Local tex:TTexture=GetObject(inst)
		If tex=Null And inst<>Null Then tex=CreateObject(inst)
		Return tex
		
	End Function
	
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
	
	' Internal - not recommended for general use	
	
	' check if tex already exists in tex_list and if so return it
	Method TexInList:TTexture()
	
		Local inst:Byte Ptr=TexInList_( GetInstance(Self) )
		Local tex:TTexture=GetObject(inst)
		If tex=Null And inst<>Null Then tex=CreateObject(inst)
		Return tex
		
	End Method
	
	' combine specifieds flag with texture filter flags
	Method FilterFlags()
	
		FilterFlags_( GetInstance(Self) )
		
	End Method
	
	' Minib3d
	
	' return if file exists
	' SMALLFIXES, replaced FileFind function to alow Incbin and Zipstream
	' from http://blitzmax.com/Community/posts.php?topic=88901#1009408
	Function FileFind:Int( file:String Var )
	
		Local TS:TStream = OpenFile(file$,True,False)
		If Not TS Then
			Repeat
				file$=Right$(file$,(Len(file$)-Instr(file$,"\",1)))
			Until Instr(file$,"\",1)=0
			Repeat
				file$=Right$(file$,(Len(file$)-Instr(file$,"/",1)))
			Until Instr(file$,"/",1)=0
			TS = OpenStream(file$,True,False)
			If Not TS Then
				DebugLog "ERROR: Cannot find texture: "+file$
				Return False
			Else
				CloseStream(TS)
				TS=Null
			EndIf
		Else
			CloseStream TS
			TS=Null	
		EndIf
		Return True
		
	End Function
	
	' returns absolute path of file
	Function FileAbs:String( file:String )
	
		Local file_abs$
		
		If Instr(file$,":")=False
			file_abs$=CurrentDir$()+"/"+file$
		Else
			file_abs$=file$
		EndIf
		file_abs$=Replace$(file_abs$,"\","/")
		
		Return file_abs$
		
	End Function
	
	' resize pixmap to pow2 size
	Function AdjustPixmap:TPixmap( pixmap:TPixmap )
	
		' adjust width and height size to next biggest power of 2 size
		Local width:Int=Pow2Size(pixmap.width)
		Local height:Int=Pow2Size(pixmap.height)
		
		' ***note*** commented out as it fails on some cards
		Rem
		' check that width and height size are valid (not too big)
		Repeat
			Local t
			glTexImage2D GL_PROXY_TEXTURE_2D,0,4,width,height,0,GL_RGBA,GL_UNSIGNED_BYTE,Null
			glGetTexLevelParameteriv GL_PROXY_TEXTURE_2D,0,GL_TEXTURE_WIDTH,Varptr t
			If t Exit
			If width=1 And height=1 RuntimeError "Unable to calculate tex size"
			If width>1 width:/2
			If height>1 height:/2
		Forever
		End Rem
		
		' if width or height have changed then resize pixmap
		If width<>pixmap.width Or height<>pixmap.height
			pixmap=ResizePixmap(pixmap,width,height)
		EndIf
		
		' return pixmap
		Return pixmap
		
	End Function
	
	' return texture size as pow2
	Function Pow2Size:Int( n:Int )
	
		Local t:Int=1
		While t<n
			t:*2
		Wend
		Return t
		
	End Function
	
	' applys alpha to a pixmap based on average of colour values
	Function ApplyAlpha:TPixmap( pixmap:TPixmap ) NoDebug
	
		Local tmp:TPixmap=pixmap
		If tmp.format<>PF_RGBA8888 tmp=tmp.Convert( PF_RGBA8888 )
		
		Local out:TPixmap=CreatePixmap( tmp.width,tmp.height,PF_RGBA8888 )
		
		For Local y:Int=0 Until pixmap.height
			Local t:Byte Ptr=tmp.PixelPtr( 0,y )
			Local o:Byte Ptr=out.PixelPtr( 0,y )
			For Local x:Int=0 Until pixmap.width
			
				o[0]=t[0]
				o[1]=t[1]
				o[2]=t[2]
				o[3]=(o[0]+o[1]+o[2])/3.0
				
				t:+4
				o:+4
			Next
		Next
		Return out
		
	End Function
	
	Rem
	Function CreateCubeMapTexture:TTexture(width:Int,height:Int,flags:Int,tex:TTexture=Null)
		
		
		
	End Function

	Function LoadCubeMapTexture:TTexture(file:String,flags:Int=1,tex:TTexture=Null)
		
		

	End Function
	EndRem
	
	Rem
	Method CountMipmaps:Int()
	
		
		
	End Method
	
	Method MipmapWidth:Int(mipmap_no:Int)
	
		
		
	End Method
	
	Method MipmapHeight:Int(mipmap_no:Int)
	
		
		
	End Method
	EndRem
	
End Type

Type TTextureFilter

	Global filter_list:TList=CreateList()

	Field Text$
	Field flags:Int
	
End Type
