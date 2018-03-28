
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
	
	' extra
	Global tex_list_all:TList=CreateList()
	
	' wrapper
	?bmxng
	Global tex_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global tex_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	
	Global tex_list_id:Int=0,tex_list_all_id:Int=0
	Field exists:Int=0 ' FreeTexture
	
	Function CreateObject:TTexture( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TTexture=New TTexture
		?bmxng
		tex_map.Insert( inst,obj )
		?Not bmxng
		tex_map.Insert( String(Long(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		tex_map.Remove( inst )
		?Not bmxng
		tex_map.Remove( String(Long(inst)) )
		?
		
	End Function
	
	Function GetObject:TTexture( inst:Byte Ptr )
	
		?bmxng
		Return TTexture( tex_map.ValueForKey( inst ) )
		?Not bmxng
		Return TTexture( tex_map.ValueForKey( String(Long(inst)) ) )
		?
		
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
		
		AddList_(tex_list)
		AddList_(tex_list_all)
		exists=1
		
	End Method
	
	Function AddList_( list:TList ) ' Global list
	
		Select list
			Case tex_list
				If StaticListSize_( TEXTURE_class,TEXTURE_tex_list )
					Local inst:Byte Ptr=StaticIterListTexture_( TEXTURE_class,TEXTURE_tex_list,Varptr(tex_list_id) )
					Local obj:TTexture=GetObject(inst) ' no CreateObject
					If obj Then ListAddLast( list,obj )
				EndIf
			Case tex_list_all
				If StaticListSize_( TEXTURE_class,TEXTURE_tex_list_all )
					Local inst:Byte Ptr=StaticIterListTexture_( TEXTURE_class,TEXTURE_tex_list,Varptr(tex_list_all_id) )
					Local obj:TTexture=GetObject(inst) ' no CreateObject
					If obj Then ListAddLast( list,obj )
				EndIf
		End Select
		
	End Function
	
	Function CopyList_( list:TList ) ' Global list (unused)
	
		ClearList list
		
		Select list
			Case tex_list
				tex_list_id=0
				For Local id:Int=0 To StaticListSize_( TEXTURE_class,TEXTURE_tex_list )-1
					Local inst:Byte Ptr=StaticIterListTexture_( TEXTURE_class,TEXTURE_tex_list,Varptr(tex_list_id) )
					Local obj:TTexture=GetObject(inst) ' no CreateObject
					If obj Then ListAddLast( list,obj )
				Next
			Case tex_list_all
				tex_list_all_id=0
				For Local id:Int=0 To StaticListSize_( TEXTURE_class,TEXTURE_tex_list_all )-1
					Local inst:Byte Ptr=StaticIterListTexture_( TEXTURE_class,TEXTURE_tex_list_all,Varptr(tex_list_all_id) )
					Local obj:TTexture=GetObject(inst) ' no CreateObject
					If obj Then ListAddLast( list,obj )
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
	
		If GL_VERSION_2_1 ' GL 2.1 and above
			CameraToTex_( GetInstance(Self),TCamera.GetInstance(cam),frame )
		Else ' GL 2.0 and below
			CameraToTexEXT( cam )
		EndIf
		
	End Method
	
	Method DepthBufferToTex( cam:TCamera=Null )
	
		If GL_VERSION_2_1 ' GL 2.1 and above
			DepthBufferToTex_( GetInstance(Self),TCamera.GetInstance(cam) )
		Else ' GL 2.0 and below
			DepthBufferToTexEXT( cam )
		EndIf
		
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
	
	' SMALLFIXES New function from www.blitzbasic.com/Community/posts.php?topic=88263#1002039
	Method FreeTexture()
	
		If exists
			For Local tex:TTexture=EachIn tex_list_all
				If tex=Self Then ListRemove( tex_list_all,Self ) ; tex_list_all_id:-1
			Next
			ListRemove( tex_list,Self ) ; tex_list_id:-1
			FreeTexture_( GetInstance(Self) )
			FreeObject( GetInstance(Self) )
			exists=0
		EndIf
		
	End Method
	
	Function CreateTexture:TTexture( width:Int,height:Int,flags:Int=9,frames:Int=1 )
	
		Local inst:Byte Ptr=CreateTexture_( width,height,flags,frames )
		Return CreateObject(inst)
		
	End Function
	
	Function NewTexture:TTexture()
	
		Local inst:Byte Ptr=NewTexture_()
		Return CreateObject(inst)
		
	End Function
	
	Rem
	Function LoadCubeMapTexture:TTexture(file$,flags%=1,tex:TTexture=Null)
		
		If tex=Null Then tex:TTexture=New TTexture
		
		If FileFind(file$)=False Then Return Null
		
		tex.file$=file$
		tex.file_abs$=FileAbs$(file$)
		
		' set tex.flags before TexInList
		tex.flags=flags
		tex.FilterFlags()
		
		' check to see if texture with same properties exists already, if so return existing texture
		Local old_tex:TTexture
		old_tex=tex.TexInList()
		If old_tex<>Null And old_tex<>tex
			Return old_tex
		Else
			If old_tex<>tex
				ListAddLast(tex_list,tex)
			EndIf
		EndIf

		' load pixmap
		tex.pixmap=LoadPixmap(file$)
		
		' check to see if pixmap contain alpha layer, set alpha_present to true if so (do this before converting)
		Local alpha_present:Int=False
		If tex.pixmap.format=PF_RGBA8888 Or tex.pixmap.format=PF_BGRA8888 Or tex.pixmap.format=PF_A8 Then alpha_present=True

		' convert pixmap to appropriate format
		If tex.pixmap.format<>PF_RGBA8888
			tex.pixmap=tex.pixmap.Convert(PF_RGBA8888)
		EndIf
		
		' if alpha flag is true and pixmap doesn't contain alpha info, apply alpha based on color values
		If tex.flags&2 And alpha_present=False
			tex.pixmap=ApplyAlpha(tex.pixmap)
		EndIf		

		' if mask flag is true, mask pixmap
		If tex.flags&4
			tex.pixmap=MaskPixmap(tex.pixmap,0,0,0)
		EndIf
		
		' ---
						
		tex.no_frames=1'frame_count
		'tex.gltex=tex.gltex[..tex.no_frames]
		
		' ---
		
		' pixmap -> tex
			
		Local name:Int
		glGenTextures 1,Varptr name
		glBindtexture GL_TEXTURE_CUBE_MAP,name
	
		Local pixmap:TPixmap
	
		For Local i:Int=0 To 5
		
			pixmap=tex.pixmap.Window((tex.pixmap.width/6)*i,0,tex.pixmap.width/6,tex.pixmap.height)

			' ---
		
			pixmap=AdjustPixmap(pixmap)
			tex.width=pixmap.width
			tex.height=pixmap.height
			Local width:Int=pixmap.width
			Local height:Int=pixmap.height

			Local mipmap:Int
			'If tex.flags&8 Then mipmap=True ***note*** prevent mipmaps being created for cubemaps - they are not used by TMesh.Update, so we don't need to create them
			Local mip_level:Int=0
			Repeat
				glPixelStorei GL_UNPACK_ROW_LENGTH,pixmap.pitch/BytesPerPixel[pixmap.format]
				Select i
					Case 0 glTexImage2D GL_TEXTURE_CUBE_MAP_NEGATIVE_X,mip_level,GL_RGBA8,width,height,0,GL_RGBA,GL_UNSIGNED_BYTE,pixmap.pixels
					Case 1 glTexImage2D GL_TEXTURE_CUBE_MAP_POSITIVE_Z,mip_level,GL_RGBA8,width,height,0,GL_RGBA,GL_UNSIGNED_BYTE,pixmap.pixels
					Case 2 glTexImage2D GL_TEXTURE_CUBE_MAP_POSITIVE_X,mip_level,GL_RGBA8,width,height,0,GL_RGBA,GL_UNSIGNED_BYTE,pixmap.pixels
					Case 3 glTexImage2D GL_TEXTURE_CUBE_MAP_NEGATIVE_Z,mip_level,GL_RGBA8,width,height,0,GL_RGBA,GL_UNSIGNED_BYTE,pixmap.pixels
					Case 4 glTexImage2D GL_TEXTURE_CUBE_MAP_POSITIVE_Y,mip_level,GL_RGBA8,width,height,0,GL_RGBA,GL_UNSIGNED_BYTE,pixmap.pixels
					Case 5 glTexImage2D GL_TEXTURE_CUBE_MAP_NEGATIVE_Y,mip_level,GL_RGBA8,width,height,0,GL_RGBA,GL_UNSIGNED_BYTE,pixmap.pixels
				End Select
				If Not mipmap Then Exit
				If width=1 And height=1 Exit
				If width>1 width:/2
				If height>1 height:/2

				pixmap=ResizePixmap(pixmap,width,height)
				mip_level:+1
			Forever
			tex.no_mipmaps=mip_level
			
		Next
		
		tex.gltex[0]=name
	
		Return tex

	End Function
	EndRem
	
	Function LoadTexture:TTexture( file:String,flags:Int=9,tex:TTexture=Null )
	
		' Brl.Tgaloader is deprecated in NG, replaced with Brl.Stbimageloader (currently doesn't load tga)
		If file.StartsWith("incbin::")=False And file.StartsWith("zip::")=False
			Return LoadTextureLib( file,flags,tex )
		EndIf
		
		'If (flags & 128) Then LoadCubeMapTexture(file,flags,tex) ' TODO load cubemaps
		Local map:TPixmap=Null, name%
		map=LoadPixmap(file) ' load from streams
		If map=Null Then Return tex
		tex=CreateTexture(PixmapWidth(map),PixmapHeight(map),flags)
		If map.format<>PF_RGBA8888 Then map=map.Convert(PF_RGBA8888)
		
		If (flags & 2) Then map=ApplyAlpha(map)
		If (flags & 4) Then map=ApplyMask(map,10,10,10)
		
		glBindTexture(GL_TEXTURE_2D,tex.texture[0])
		gluBuild2DMipmaps(GL_TEXTURE_2D,GL_RGBA,tex.width[0],tex.height[0],GL_RGBA,GL_UNSIGNED_BYTE,PixmapPixelPtr(map,0,0))
		
		tex.BufferToTex PixmapPixelPtr(map,0,0)
		
		Return tex
	End Function
	
	Function LoadTextureLib:TTexture( file:String,flags:Int=9,tex:TTexture=Null )
	
		Local map:TPixmap=Null, name%
		Local cString:Byte Ptr=file.ToCString()
		Local inst:Byte Ptr=LoadTexture_( cString,flags,GetInstance(tex) )
		If tex=Null Then tex=CreateObject(inst)
		MemFree cString
		
		Rem
		If tex=Null Then Return Null
		If tex.width[0]=0 ' Stbimage failed try pixmap - for progressive jpgs
			'If (flags & 128) Then LoadCubeMapTexture(file,flags,tex) ' TODO load cubemaps
			map=LoadPixmap(file)
			If map=Null Then Return tex
			tex=CreateTexture(PixmapWidth(map),PixmapHeight(map),flags)
			If map.format<>PF_RGBA8888 Then map=map.Convert(PF_RGBA8888)
			
			If (flags & 2) Then ApplyAlpha(map)
			If (flags & 4) Then ApplyMask(map,10,10,10)
			
			glBindTexture(GL_TEXTURE_2D,tex.texture[0])
			gluBuild2DMipmaps(GL_TEXTURE_2D,GL_RGBA,tex.width[0],tex.height[0],GL_RGBA,GL_UNSIGNED_BYTE,PixmapPixelPtr(map,0,0))
			
			tex.BufferToTex PixmapPixelPtr(map,0,0)
		EndIf
		EndRem
		
		Return tex
	End Function
	
	Function LoadAnimTexture:TTexture( file:String,flags:Int,frame_width:Int,frame_height:Int,first_frame:Int,frame_count:Int,tex:TTexture=Null )
	
		Local cString:Byte Ptr=file.ToCString()
		Local inst:Byte Ptr=LoadAnimTexture_( cString,flags,frame_width,frame_height,first_frame,frame_count,GetInstance(tex) )
		If tex=Null Then tex=CreateObject(inst)
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
		Return GetObject(inst) ' no CreateObject
		
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
	
	Method Copy:TTexture()
		
		Local inst:Byte Ptr=TextureCopy_( GetInstance(Self) )
		Return CreateObject(inst)
		
	End Method	
	
	' check if tex already exists in tex_list and if so return it
	Method TexInList:TTexture()
	
		Local list_ref:Byte Ptr=TextureListTexture_( GetInstance(Self),TEXTURE_tex_list )
		Local inst:Byte Ptr=TexInList_( GetInstance(Self),list_ref )
		Return GetObject(inst) ' no CreateObject
		
	End Method
	
	' combine specifieds flag with texture filter flags
	Method FilterFlags()
	
		FilterFlags_( GetInstance(Self) )
		
	End Method
	
	' Minib3d
	
	' return if file exists
	' SMALLFIXES, replaced FileFind function to alow Incbin and Zipstream
	' from www.blitzmax.com/Community/posts.php?topic=88901#1009408
	Function FileFind:Int( file:String Var )
	
		'Local TS:TStream = OpenFile(file$,True,False)
		Local TS:TStream = ReadFile(file$)
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
	Function ApplyAlpha:TPixmap( map:TPixmap Var )
		Local rgba%,red%,grn%,blu%,alp%
		
		For Local iy%=0 To PixmapWidth(map)-1
			For Local ix%=0 To PixmapHeight(map)-1
				rgba=ReadPixel(map,ix,iy)
				red%=rgba & $000000FF
				grn%=(rgba & $0000FF00) Shr 8
				blu%=(rgba & $00FF0000) Shr 16
				alp%=(red + grn + blu) / 3.0
				WritePixel map,ix,iy,(rgba & $00FFFFFF)|(alp Shl 24)
			Next
		Next
	End Function
	
	' like MaskPixmap
	Function ApplyMask:TPixmap( map:TPixmap Var, maskred%, maskgrn%, maskblu% )
		Local rgba%,red%,grn%,blu%
		
		For Local iy%=0 To PixmapWidth(map)-1
			For Local ix%=0 To PixmapHeight(map)-1
				rgba=ReadPixel(map,ix,iy)
				red=rgba & $000000FF
				grn=(rgba & $0000FF00) Shr 8
				blu=(rgba & $00FF0000) Shr 16
				If red < maskred And grn < maskgrn And blu < maskblu
					WritePixel map,ix,iy,(rgba & $00FFFFFF)
				EndIf
			Next
		Next
	End Function
	
	' GL 2.0 support
	Method CameraToTexEXT( cam:TCamera,frame:Int=0 )
	
		TGlobal.camera_in_use=cam
		
		Local target:Int
		If flags[0] & 128
			target=GL_TEXTURE_CUBE_MAP
		Else
			target=GL_TEXTURE_2D
		EndIf
		
		glBindTexture(target, texture[0])
		If framebuffer=Null ' Create texture image
			framebuffer=Int Ptr(MemAlloc(8))
			glGenFramebuffersEXT(1, Varptr framebuffer[0])
			glGenRenderbuffersEXT(1, Varptr framebuffer[1])
			If flags[0] & 128
				For Local i:Int=0 Until 6 ' i<6
					Select i
						Case 0
							glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, GL_RGBA8, width[0], height[0], 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
						Case 1
							glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, GL_RGBA8, width[0], height[0], 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
						Case 2
							glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, GL_RGBA8, width[0], height[0], 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
						Case 3
							glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, GL_RGBA8, width[0], height[0], 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
						Case 4
							glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, GL_RGBA8, width[0], height[0], 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
						Case 5
							glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, GL_RGBA8, width[0], height[0], 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
					EndSelect
				Next
			Else
				glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width[0], height[0], 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
			EndIf
		EndIf
		
		' Attach texture to FBO
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, framebuffer[0])
		If flags[0] & 128
			Select cube_face[0]
				Case 0
					glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_CUBE_MAP_NEGATIVE_X, texture[0], 0)
				Case 1
					glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_CUBE_MAP_POSITIVE_Z, texture[0], 0)
				Case 2
					glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_CUBE_MAP_POSITIVE_X, texture[0], 0)
				Case 3
					glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, texture[0], 0)
				Case 4
					glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, texture[0], 0)
				Case 5
					glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_CUBE_MAP_POSITIVE_Y, texture[0], 0)
			EndSelect
		Else
			glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, texture[0], 0)
		EndIf
		
		' Depth buffer, and stencil if supported
		glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, framebuffer[1])
		If THardwareInfo.DepthStencil=False Then glRenderbufferStorageEXT( GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT, width[0], height[0])
		If THardwareInfo.DepthStencil=True Then glRenderbufferStorageEXT( GL_RENDERBUFFER_EXT, GL_DEPTH24_STENCIL8_EXT, width[0], height[0])
		glFramebufferRenderbufferEXT( GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, framebuffer[1])
		If THardwareInfo.DepthStencil=True Then glFramebufferRenderbufferEXT( GL_FRAMEBUFFER_EXT, GL_STENCIL_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, framebuffer[1])
		
		cam.Render()
		
		If TGlobal.Shadows_enabled[0]=True Then TShadowObject.Update(cam)
		
		'If THardwareInfo.DepthStencil=True Then glFramebufferRenderbufferEXT( GL_FRAMEBUFFER_EXT, GL_STENCIL_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, 0)
		
		' Generate mipmaps for texture, need to bind after Render
		glBindTexture(target,texture[0])
		glGenerateMipmapEXT(target)
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0)
		glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, 0)
		
	End Method
	
	' GL 2.0 support
	Method DepthBufferToTexEXT( cam:TCamera=Null,frame:Int=0 )
	
		' Copy viewport to texture
		glBindTexture(GL_TEXTURE_2D, texture[0])	
		If cam=Null
			glCopyTexImage2D(GL_TEXTURE_2D,0,GL_DEPTH_COMPONENT,0,TGlobal.height[0]-height[0],width[0],height[0],0)
			glTexParameteri(GL_TEXTURE_2D,GL_GENERATE_MIPMAP_SGIS,GL_TRUE)
		Else
			TGlobal.camera_in_use=cam
			
			If framebuffer=Null ' Create texture image
				framebuffer=Int Ptr(MemAlloc(8))
				glGenFramebuffersEXT(1, Varptr framebuffer[0])
				glGenRenderbuffersEXT(1, Varptr framebuffer[1])
				glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width[0], height[0], 0, GL_RGBA, GL_UNSIGNED_BYTE, Null)
			'glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT24, width[0], height[0], 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_BYTE, Null)
			EndIf
			
			' Attach texture to FBO
			glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, framebuffer[0])
			glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, texture[0], 0)
			
			' Depth buffer, and stencil if supported
			glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, framebuffer[1])
			If THardwareInfo.DepthStencil=False Then glRenderbufferStorageEXT( GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT, width[0], height[0])
			If THardwareInfo.DepthStencil=True Then glRenderbufferStorageEXT( GL_RENDERBUFFER_EXT, GL_DEPTH24_STENCIL8_EXT, width[0], height[0])
			glFramebufferRenderbufferEXT( GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, framebuffer[1])
			If THardwareInfo.DepthStencil=True Then glFramebufferRenderbufferEXT( GL_FRAMEBUFFER_EXT, GL_STENCIL_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, framebuffer[1])
			
			cam.Render()
			
			If TGlobal.Shadows_enabled[0]=True Then TShadowObject.Update(cam)
		
			'If THardwareInfo.DepthStencil=True Then glFramebufferRenderbufferEXT( GL_FRAMEBUFFER_EXT, GL_STENCIL_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, 0)
			
			' Generate mipmaps for texture, need to bind after Render
			glBindTexture(GL_TEXTURE_2D,texture[0])
			glGenerateMipmapEXT(GL_TEXTURE_2D)
			glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0)
			glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, 0)
		EndIf
		
	End Method
	
	Function LoadAlphaTexture:TTexture( file:String,flags:Int=11,alphamask%=0 )
	
		Local map:TPixmap=LoadPixmap(file)
		If map.format<>PF_RGBA8888 Then map=map.Convert(PF_RGBA8888)
		If alphamask ' only if alpha mask
			For Local iy%=0 To PixmapWidth(map)-1
				For Local ix%=0 To PixmapHeight(map)-1
					Local rgba%=ReadPixel(map,ix,iy)
					Local alp%=rgba & alphamask
					If alp & $FF000000 ' alpha
						alp=alp Shr 24 ' convert to byte
					ElseIf alp & $00FF0000 ' blue
						alp=alp Shr 16
					ElseIf alp & $0000FF00 ' green
						alp=alp Shr 8
					EndIf
					alp=alp*(Float(alp)/255.0) ' hack to make darker colors less visible
					WritePixel map,ix,iy,(rgba & $00FFFFFF)|(alp Shl 24)
				Next
			Next
		EndIf
		Local tex:TTexture=CreateTexture(PixmapWidth(map),PixmapHeight(map),flags)
		tex.BufferToTex PixmapPixelPtr(map,0,0)
		Return tex
		
	End Function
	
	Method TextureFlags( flags:Int )
	
		TextureFlags_( GetInstance(Self),flags )
		
	End Method
	
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
