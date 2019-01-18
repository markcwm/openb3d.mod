
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
	Field pixmap:TPixmap
	Field discard:Float=1
	Field gltex:Int Ptr
	'Field cube_pixmap:TPixmap[7]
	Field no_mipmaps:Int[1]
	
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
		tex_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		tex_map.Remove( inst )
		?Not bmxng
		tex_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TTexture( inst:Byte Ptr )
	
		?bmxng
		Return TTexture( tex_map.ValueForKey( inst ) )
		?Not bmxng
		Return TTexture( tex_map.ValueForKey( String(Int(inst)) ) )
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
		gltex=frames ' as in Minib3d
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
					Local inst:Byte Ptr=StaticIterListTexture_( TEXTURE_class,TEXTURE_tex_list,Varptr tex_list_id )
					Local obj:TTexture=GetObject(inst) ' no CreateObject
					If obj Then ListAddLast( list,obj )
				EndIf
			Case tex_list_all
				If StaticListSize_( TEXTURE_class,TEXTURE_tex_list_all )
					Local inst:Byte Ptr=StaticIterListTexture_( TEXTURE_class,TEXTURE_tex_list,Varptr tex_list_all_id )
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
					Local inst:Byte Ptr=StaticIterListTexture_( TEXTURE_class,TEXTURE_tex_list,Varptr tex_list_id )
					Local obj:TTexture=GetObject(inst) ' no CreateObject
					If obj Then ListAddLast( list,obj )
				Next
			Case tex_list_all
				tex_list_all_id=0
				For Local id:Int=0 To StaticListSize_( TEXTURE_class,TEXTURE_tex_list_all )-1
					Local inst:Byte Ptr=StaticIterListTexture_( TEXTURE_class,TEXTURE_tex_list_all,Varptr tex_list_all_id )
					Local obj:TTexture=GetObject(inst) ' no CreateObject
					If obj Then ListAddLast( list,obj )
				Next
		End Select
		
	End Function
	
	Method TextureListAdd( list:TList )
	
		Select list
			Case tex_list
				GlobalListPushBackTexture_( TEXTURE_tex_list,GetInstance(Self) )
				AddList_(list)
			Case tex_list_all
				GlobalListPushBackTexture_( TEXTURE_tex_list_all,GetInstance(Self) )
				AddList_(list)
		End Select
		
	End Method
	
	Method TextureListRemove( list:TList )
	
		Select list
			Case tex_list
				GlobalListRemoveTexture_( TEXTURE_tex_list,GetInstance(Self) )
				ListRemove( list,Self ) ; tex_list_id:-1
			Case tex_list_all
				GlobalListRemoveTexture_( TEXTURE_tex_list_all,GetInstance(Self) )
				ListRemove( list,Self ) ; tex_list_all_id:-1
		End Select
		
	End Method
	
	Function NewTexture:TTexture()
	
		Local inst:Byte Ptr=NewTexture_()
		Return CreateObject(inst)
		
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
	
	' Extra
	
	' Set discard value (as 0..1) above which to ignore pixel's alpha value, default is 1 (only if flag 2)
	Method AlphaDiscard( alpha:Float=0.01 )
	
		discard=alpha
		
	End Method
	
	' Set texture flags, see LoadTexture for values
	Method TextureFlags( flags:Int )
	
		TextureFlags_( GetInstance(Self),flags )
		
	End Method
	
	' GL equivalent, param is a const, limited to 12 calls per texture, experimental
	Method TextureGLTexEnvi( target:Int,pname:Int,param:Int )
	
		TextureGLTexEnvi_( GetInstance(Self),target,pname,param )
		
	End Method
	
	' GL equivalent, param is a float, limited to 12 calls per texture, experimental
	Method TextureGLTexEnvf( target:Int,pname:Int,param:Float )
	
		TextureGLTexEnvf_( GetInstance(Self),target,pname,param )
		
	End Method
	
	' Set texture multitex factor, used in interpolate and custom TexBlend options
	Method TextureMultitex( f:Float )
	
		TextureMultitex_( GetInstance(Self),f )
		
	End Method
	
	' Gets a Blitz string from a C string
	Method GetString:String( strPtr:Byte Ptr )
	
		Select strPtr
			Case file
				Return String.FromCString( TextureString_( GetInstance(Self),TEXTURE_file ) )
			Case file_abs
				Return String.FromCString( TextureString_( GetInstance(Self),TEXTURE_file_abs ) )
		End Select
		
	End Method
	
	' Sets a C string from a Blitz string
	Method SetString( strPtr:Byte Ptr, strValue:String )
	
		Select strPtr
			Case file
				Local cString:Byte Ptr=strValue.ToCString()
				SetTextureString_( GetInstance(Self),TEXTURE_file,cString )
				MemFree cString
				file=TextureString_( GetInstance(Self),TEXTURE_file )
			Case file_abs
				Local cString:Byte Ptr=strValue.ToCString()
				SetTextureString_( GetInstance(Self),TEXTURE_file_abs,cString )
				MemFree cString
				file_abs=TextureString_( GetInstance(Self),TEXTURE_file_abs )
		End Select
	
	End Method
	
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
	
	' Minib3d
	
	Method New()
	
		If TGlobal.Log_New
			DebugLog "New TTexture"
		EndIf
	
	End Method
	
	Method Delete()
	
		If TGlobal.Log_Del
			DebugLog "Del TTexture"
		EndIf
	
	End Method
	
	Method FreeTexture()
	
		If exists
			For Local tex:TTexture=EachIn tex_list_all
				If tex=Self Then ListRemove( tex_list_all,Self ) ; tex_list_all_id:-1
			Next
			
			ListRemove( tex_list,Self ) ; tex_list_id:-1
			pixmap=Null
			
			FreeTexture_( GetInstance(Self) )
			FreeObject( GetInstance(Self) )
			exists=0
		EndIf
		
	End Method
	
	Function CreateTexture:TTexture( width:Int,height:Int,flags:Int=9,frames:Int=1 )
	
		Local inst:Byte Ptr=CreateTexture_( width,height,flags,frames )
		Return CreateObject(inst)
		
	End Function
	
	Function LoadTexture:TTexture( file:String,flags:Int=9,tex:TTexture=Null )
	
		Select TGlobal.Texture_Loader
		
			Case 2 ' library
				Local map:TPixmap=Null, name%
				Local cString:Byte Ptr=file.ToCString()
				Local inst:Byte Ptr=LoadTexture_( cString,flags,GetInstance(tex) )
				If tex=Null Then tex=CreateObject(inst)
				MemFree cString
				tex.no_mipmaps[0]=1+Log2(Max(tex.width[0],tex.height[0])) ' calculate mipmap levels
				Return tex
				
			Default ' wrapper
				Return LoadAnimTextureStream(file,flags,0,0,0,1,tex)
				
		EndSelect
		
	End Function
	
	Function LoadAnimTexture:TTexture( file:String,flags%,frame_width%,frame_height%,first_frame%,frame_count%,tex:TTexture=Null )
	
		Select TGlobal.Texture_Loader
		
			Case 2 ' library
				Local cString:Byte Ptr=file.ToCString()
				Local inst:Byte Ptr=LoadAnimTexture_( cString,flags,frame_width,frame_height,first_frame,frame_count,GetInstance(tex) )
				If tex=Null Then tex=CreateObject(inst)
				MemFree cString
				tex.no_mipmaps[0]=1+Log2(Max(tex.width[0],tex.height[0])) ' calculate mipmap levels
				Return tex
				
			Default ' wrapper
				Return LoadAnimTextureStream(file,flags,frame_width,frame_height,first_frame,frame_count,tex)
				
		EndSelect
		
	End Function
	
	Function LoadAnimTextureStream:TTexture( url:Object,flags%,frame_width%,frame_height%,first_frame%,frame_count%,tex:TTexture=Null )
	
		If (flags & 128) Then Return LoadCubeMapTextureStream(url,flags,frame_width,frame_height,first_frame,frame_count,tex)
		
		Local file$=String(url)
		If FileFind(file)=False Then Return Null ' strips any directories from file
		
		If tex=Null Then tex=NewTexture()
		tex.SetString(tex.file,file)
		tex.SetString(tex.file_abs,FileAbs(file)) ' returns absolute path of file if relative
		
		' set tex.flags before TexInList
		tex.flags[0]=flags
		tex.FilterFlags()
		
		' check to see if texture with same properties exists already, if so return existing texture
		Local old_tex:TTexture=tex.TexInList()
		If old_tex<>Null
			If frame_width>0 And frame_height>0 And frame_count=1 And old_tex<>tex ' load area of same image
				tex.TextureListAdd( tex_list )
				tex.TextureListAdd( tex_list_all )
			Else
				old_tex.TextureListAdd( tex_list_all )
				FreeObject( GetInstance(tex) ) ; tex.exists=0
				
				If TGlobal.Log_Texture Then DebugLog " Texture already exists: "+file
				Return old_tex
			EndIf
		ElseIf old_tex<>tex ' tex not pre-existing
			tex.TextureListAdd( tex_list )
			tex.TextureListAdd( tex_list_all )
		EndIf
		
		tex.pixmap=LoadPixmap(url) ' streams
		If tex.pixmap=Null
			If TGlobal.Log_Texture Then DebugLog " No pixmap texture loaded: "+file
			Return tex
		EndIf
		
		' check to see if pixmap contain alpha layer, set alpha_present to true if so (do this before converting)
		Local alpha_present:Int=False
		If tex.pixmap.format=PF_RGBA8888 Or tex.pixmap.format=PF_BGRA8888 Or tex.pixmap.format=PF_A8 Then alpha_present=True
		If tex.pixmap.format<>PF_RGBA8888 Then tex.pixmap=tex.pixmap.Convert(PF_RGBA8888)
		
		Local mask:Int=CheckAlpha(tex.pixmap)
		If (flags & 2048) Then flags=flags | mask ' determine tex flags, 4 if no alpha
		
		' if alpha flag is true and pixmap doesn't contain alpha info, apply alpha based on color values
		If (flags & 2)
			If alpha_present=False Or mask=4 Then tex.pixmap=ApplyAlpha(tex.pixmap,tex.discard)
		EndIf
		
		If (flags & 4) Then tex.pixmap=MaskPixmap(tex.pixmap,0,0,0) ' mask any pixel at 0,0,0 - set with ClsColor?
		
		Local name:Int
		If frame_width>0 And frame_height>0 ' anim texture
		
			Local animmap:TPixmap=CreatePixmap(frame_width,frame_height,tex.pixmap.format) ' format=PF_RGBA8888
			
			tex.no_frames[0]=frame_count
			tex.frames=TextureNewUIntArray_( GetInstance(tex),TEXTURE_frames,frame_count )
			tex.gltex=tex.frames ' as in Minib3d
			
			Local width:Int=frame_width
			Local height:Int=frame_height
			Local xframes:Int=tex.pixmap.width/width
			Local yframes:Int=tex.pixmap.height/height
			If first_frame>(xframes*yframes)-1 Then first_frame=(xframes*yframes)-1 ' maximum first_frame
			Local x:Int=first_frame Mod xframes
			Local y:Int=(first_frame/xframes) Mod yframes
			
			For Local i:Int=0 To frame_count-1 ' copy tex.pixmap rect to animmap pixels
				CopyRect_(tex.pixmap.pixels,tex.pixmap.width,tex.pixmap.height,x*width,y*height,animmap.pixels,width,height,4,0)
				
				x=x+1 ' left-right frames
				If x>=xframes ' top-bottom frames
					x=0
					y=y+1
				EndIf
				
				glGenTextures(1,Varptr name)
				glBindtexture(GL_TEXTURE_2D,name)
				gluBuild2DMipmaps(GL_TEXTURE_2D,GL_RGBA,width,height,GL_RGBA,GL_UNSIGNED_BYTE,animmap.pixels)
				
				tex.frames[i]=name
			Next
			
			tex.texture[0]=tex.frames[0]
			tex.width[0]=width
			tex.height[0]=height
			
		Else ' whole image
		
			'If (flags & 8192) Then tex.pixmap=XFlipPixmap(tex.pixmap) ' these functions are too slow, flip in an editor
			'If (flags & 16384) Then tex.pixmap=YFlipPixmap(tex.pixmap)
			
			glGenTextures(1,Varptr name)
			glBindtexture(GL_TEXTURE_2D,name)
			gluBuild2DMipmaps(GL_TEXTURE_2D,GL_RGBA,tex.pixmap.width,tex.pixmap.height,GL_RGBA,GL_UNSIGNED_BYTE,tex.pixmap.pixels)
			
			tex.texture[0]=name
			tex.width[0]=tex.pixmap.width
			tex.height[0]=tex.pixmap.height
			
		EndIf
		
		tex.no_mipmaps[0]=1+Log2(Max(tex.width[0],tex.height[0])) ' calculate mipmap levels
		
		Return tex
		
	End Function
	
	' Load cubemaps in 4 * 3 cross rather than single strip
	Function LoadCubeMapTextureStream:TTexture( url:Object,flags:Int,frame_width%,frame_height%,first_frame%,frame_count%,tex:TTexture=Null )
	
		Local file$=String(url)
		If FileFind(file)=False Then Return Null ' strips any directories from file
		
		If tex=Null Then tex=NewTexture()
		tex.SetString(tex.file,file)
		tex.SetString(tex.file_abs,FileAbs(file)) ' returns absolute path of file if relative
		
		' set tex.flags before TexInList
		tex.flags[0]=flags
		tex.FilterFlags()
		
		' check to see if texture with same properties exists already, if so return existing texture
		Local old_tex:TTexture=tex.TexInList()
		If old_tex<>Null
			old_tex.TextureListAdd( tex_list_all )
			FreeObject( GetInstance(tex) ) ; tex.exists=0
			
			If TGlobal.Log_Texture Then DebugLog " Texture already exists: "+file
			Return old_tex
		ElseIf old_tex<>tex
			tex.TextureListAdd( tex_list )
			tex.TextureListAdd( tex_list_all )
		EndIf
		
		tex.pixmap=LoadPixmap(url) ' streams
		If tex.pixmap=Null
			If TGlobal.Log_Texture Then DebugLog " No pixmap texture loaded: "+file
			Return tex
		EndIf
		
		' check to see if pixmap contain alpha layer, set alpha_present to true if so (do this before converting)
		Local alpha_present:Int=False
		If tex.pixmap.format=PF_RGBA8888 Or tex.pixmap.format=PF_BGRA8888 Or tex.pixmap.format=PF_A8 Then alpha_present=True
		If tex.pixmap.format<>PF_RGBA8888 Then tex.pixmap=tex.pixmap.Convert(PF_RGBA8888)
		
		Local mask:Int=CheckAlpha(tex.pixmap)
		If (flags & 2048) Then flags=flags | mask ' determine tex flags, 4 if no alpha
		
		' if alpha flag is true and pixmap doesn't contain alpha info, apply alpha based on color values
		If (flags & 2)
			If alpha_present=False Or mask=4 Then tex.pixmap=ApplyAlpha(tex.pixmap,tex.discard)
		EndIf
		
		If (flags & 4) Then tex.pixmap=MaskPixmap(tex.pixmap,0,0,0) ' mask any pixel at 0,0,0 - set with ClsColor?
		
		Local width:Int=frame_width
		Local height:Int=frame_height
		Local xframes:Int=tex.pixmap.width/width
		Local yframes:Int=tex.pixmap.height/height
		Local x:Int, y:Int, cubeid:Int
		Local bpp:Int=BytesPerPixel[tex.pixmap.format]
		
		Local cubemap:TPixmap=CreatePixmap(width,height,tex.pixmap.format) ' format=PF_RGBA8888
		
		Local name:Int
		glGenTextures(1,Varptr name)
		glBindtexture(GL_TEXTURE_CUBE_MAP,name)
		
		For Local i:Int=0 To 5 ' copy tex.pixmap rect to cubemap
			cubeid=TGlobal.Cubemap_Frame[i]
			x=cubeid Mod xframes ' left-right frames
			y=(cubeid/xframes) Mod yframes ' top-bottom frames
			
			CopyRect_(tex.pixmap.pixels,tex.pixmap.width,tex.pixmap.height,x*width,y*height,cubemap.pixels,width,height,bpp,1)
			
			gluBuild2DMipmaps(TGlobal.Cubemap_Face[i],GL_RGBA,width,height,GL_RGBA,GL_UNSIGNED_BYTE,cubemap.pixels)
		Next
		
		tex.texture[0]=name
		tex.no_frames[0]=1
		tex.width[0]=width
		tex.height[0]=height
		tex.no_mipmaps[0]=1+Log2(Max(tex.width[0],tex.height[0])) ' calculate mipmap levels
		
		Return tex
		
	End Function
	
	' strips any directories from file, returns if file is found
	' fixes FileFind not finding incbin or zip paths, topic=88901 (SLotman)
	Function FileFind:Int( file:String Var )
	
		'Local TS:TStream = OpenFile(file,True,False)
		Local stream:TStream = ReadFile(file)
		If Not stream
			Repeat ' strip \ dirs (Win)
				file=Right(file,(Len(file)-Instr(file,"\",1)))
			Until Instr(file,"\",1)=0
			
			Repeat ' strip / dirs
				file=Right(file,(Len(file)-Instr(file,"/",1)))
			Until Instr(file,"/",1)=0
			
			stream = OpenStream(file,True,False)
			If Not stream
				If TGlobal.Log_Texture Then DebugLog " Invalid texture stream: "+file
				Return False
			Else ' file found after strip dir
				CloseStream(stream)
				stream=Null
			EndIf
		Else ' incbin or zip file found
			CloseStream stream
			stream=Null	
		EndIf
		
		Return True
		
	End Function
	
	' returns absolute path of file if relative and not incbin or zip
	Function FileAbs:String( file:String )
	
		Local file_abs$
		
		If Instr(file,":")=False ' not incbin or zip
			file_abs=CurrentDir()+"/"+file
		Else
			file_abs=file
		EndIf
		file_abs=Replace(file_abs,"\","/")
		
		Return file_abs
		
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
	
	' quick test for Assimp to see if true alpha used in image, if true returns 2 (for tex flags)
	Function CheckAlpha:Int( map:TPixmap )
		Local rgba%, alp%, a0%, a1%
		Local sqrw#=Sqr(PixmapWidth(map))
		Local sqrh#=Sqr(PixmapHeight(map))
		Local sizew%=Int(PixmapWidth(map)/sqrw)
		Local sizeh%=Int(PixmapHeight(map)/sqrh)
		
		For Local iy%=0 Until sizeh ' check sqrt times pixel columns
			For Local ix%=0 Until sizew ' check sqrt times pixel rows
				rgba=ReadPixel(map,ix*sizew,iy*sizeh)
				alp=(rgba & $FF000000) Shr 24
				If alp=0 Then a0:+1
				If alp=255 Then a1:+1
			Next
		Next
		
		If a0=sizew*sizeh Or a1=sizew*sizeh Then Return 4 ' mask flag, no alpha values
		Return 2 ' alpha flag
	End Function
	
	' applys alpha to a pixmap based on average of colour values
	Function ApplyAlpha:TPixmap( map:TPixmap Var,alpha# )
		Local rgba%, red%, grn%, blu%, alp%
		Local discard%=alpha * 255
		
		For Local iy%=0 Until PixmapHeight(map)
			For Local ix%=0 Until PixmapWidth(map)
				rgba=ReadPixel(map,ix,iy)
				red=rgba & $000000FF
				grn=(rgba & $0000FF00) Shr 8
				blu=(rgba & $00FF0000) Shr 16
				alp=(red + grn + blu) / 3.0
				If alp < discard Then WritePixel map,ix,iy,(rgba & $00FFFFFF)|(alp Shl 24)
			Next
		Next
		
		Return map
	End Function
	
	' like MaskPixmap
	' used to allow masking pixels in a defined range to account for jpg noise but removed since you should use png/tga
	Function ApplyMask:TPixmap( map:TPixmap Var, maskred%, maskgrn%, maskblu% )
		Local rgba%, red%, grn%, blu%
		
		For Local iy%=0 To PixmapHeight(map)-1
			For Local ix%=0 To PixmapWidth(map)-1
				rgba=ReadPixel(map,ix,iy)
				red=rgba & $000000FF
				grn=(rgba & $0000FF00) Shr 8
				blu=(rgba & $00FF0000) Shr 16
				If red = maskred And grn = maskgrn And blu = maskblu
					WritePixel map,ix,iy,(rgba & $00FFFFFF)
				EndIf
			Next
		Next
		
		Return map
	End Function
	
	' return texture size as pow2
	Function Pow2Size:Int( n:Int )
	
		Local t:Int=1
		While t<n
			t:*2
		Wend
		Return t
		
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
