
Rem
bbdoc: Loads a DDS file as a Max2D image in DXT1/3/5 compressed or RGB/RGBA uncompressed formats
End Rem
Function LoadImageDDS:TImage( url:Object,flags%=-1,mr%=0,mg%=0,mb%=0 )

	Local pixmap:TPixmap=LoadPixmap(url)
	Local dds:TDDS=TDDS.current_surface
	If dds.pixmap=Null
		DebugLog " No pixmap image loaded: "+String(url)
		Return Null
	EndIf
	
	Local name:Int
	glGenTextures(1, Varptr name)
	glBindTexture(GL_TEXTURE_2D, name)
	
	dds.UploadTexture2D()
	
	glBindTexture(GL_TEXTURE_2D, name)
	glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE, dds.pixmap.pixels)
	
	Local img:TImage=TImage.Create( dds.pixmap.width,dds.pixmap.height,1,flags,mr,mg,mb )
	img.SetPixmap 0,dds.pixmap
	
	dds.FreeDDS()
	Return img
	
End Function

Rem
bbdoc: DirectDrawSurface
End Rem
Type TDDS

	Global current_surface:TDDS
	Global current_buffer:Byte Ptr
	
	Field buffer:Byte Ptr
	Field mipmaps_array:TDDS[1]
	
	Field width:Int Ptr
	Field height:Int Ptr
	Field depth:Int Ptr
	Field mipmapcount:Int Ptr
	Field pitch:Int Ptr
	Field size:Int Ptr
	
	Field dxt:Byte Ptr
	Field format:Int Ptr
	Field components:Int Ptr
	Field target:Int Ptr
	
	Field pixmap:TPixmap
	
	' wrapper
	?bmxng
	Global dds_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global dds_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	Field exists:Int=0 ' Free
	
	Function CreateObject:TDDS( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TDDS=New TDDS
		?bmxng
		dds_map.Insert( inst,obj )
		?Not bmxng
		dds_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		dds_map.Remove( inst )
		?Not bmxng
		dds_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TDDS( inst:Byte Ptr )
	
		?bmxng
		Return TDDS( dds_map.ValueForKey( inst ) )
		?Not bmxng
		Return TDDS( dds_map.ValueForKey( String(Int(inst)) ) )
		?
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TDDS ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		' char
		buffer=DirectDrawSurfaceUChar_( GetInstance(Self),DDS_buffer )
		dxt=DirectDrawSurfaceUChar_( GetInstance(Self),DDS_dxt )
		
		' int
		width=DirectDrawSurfaceInt_( GetInstance(Self),DDS_width )
		height=DirectDrawSurfaceInt_( GetInstance(Self),DDS_height )
		depth=DirectDrawSurfaceInt_( GetInstance(Self),DDS_depth )
		mipmapcount=DirectDrawSurfaceInt_( GetInstance(Self),DDS_mipmapcount )
		pitch=DirectDrawSurfaceInt_( GetInstance(Self),DDS_pitch )
		size=DirectDrawSurfaceInt_( GetInstance(Self),DDS_size )
		
		' uint
		format=DirectDrawSurfaceUInt_( GetInstance(Self),DDS_format )
		components=DirectDrawSurfaceUInt_( GetInstance(Self),DDS_components )
		target=DirectDrawSurfaceUInt_( GetInstance(Self),DDS_target )
		
		' dds
		mipmaps_array=mipmaps_array[..mipmapcount[0]+1]
		For Local id:Int=0 Until mipmapcount[0]
			Local inst:Byte Ptr=DirectDrawSurfaceArray_( GetInstance(Self),DDS_mipmaps,id )
			mipmaps_array[id]=GetObject(inst)
			If mipmaps_array[id]=Null And inst<>Null Then mipmaps_array[id]=CreateObject(inst)
		Next
		
		exists=1
		
	End Method
	
	Function StringPtr:String( inst:Byte Ptr )
	
		?bmxng
		Return String(inst)
		?Not bmxng
		Return String(Int(inst))
		?
		
	End Function
	
	Method DebugFields( debug_subobjects:Int=0,debug_base_types:Int=0 )
	
		Local pad:String
		Local loop:Int=debug_subobjects
		If debug_base_types>debug_subobjects Then loop=debug_base_types
		For Local i%=1 Until loop
			pad:+"  "
		Next
		If debug_subobjects Then debug_subobjects:+1
		If debug_base_types Then debug_base_types:+1
		DebugLog pad+" DDS instance: "+StringPtr(GetInstance(Self))
		
		' char
		If buffer<>Null Then DebugLog(pad+" buffer: "+buffer[0]) Else DebugLog(pad+" buffer: Null")
		If dxt<>Null Then DebugLog(pad+" dxt: "+dxt[0]) Else DebugLog(pad+" dxt: Null")
		
		' int
		If width<>Null Then DebugLog(pad+" width: "+width[0]) Else DebugLog(pad+" width: Null")
		If height<>Null Then DebugLog(pad+" height: "+height[0]) Else DebugLog(pad+" height: Null")
		If depth<>Null Then DebugLog(pad+" depth: "+depth[0]) Else DebugLog(pad+" depth: Null")
		If mipmapcount<>Null Then DebugLog(pad+" mipmapcount: "+mipmapcount[0]) Else DebugLog(pad+" mipmapcount: Null")
		If pitch<>Null Then DebugLog(pad+" pitch: "+pitch[0]) Else DebugLog(pad+" pitch: Null")
		If size<>Null Then DebugLog(pad+" size: "+size[0]) Else DebugLog(pad+" size: Null")
		
		' uint
		If format<>Null Then DebugLog(pad+" format: "+format[0]) Else DebugLog(pad+" format: Null")
		If components<>Null Then DebugLog(pad+" components: "+components[0]) Else DebugLog(pad+" components: Null")
		If target<>Null Then DebugLog(pad+" target: "+target[0]) Else DebugLog(pad+" target: Null")
		
		DebugLog ""
		
	End Method
	
	' Openb3d
	
	Method FreeDDS()
	
		If exists
			exists=0
			MemFree(current_buffer)
			DDSFreeDirectDrawSurface( GetInstance(Self),0 ) ' don't free buffer, it was freed in Bmax
			FreeObject( GetInstance(Self) )
		EndIf
		
	End Method
	
	Method IsCompressed:Int()
	
		If format[0]=GL_COMPRESSED_RGB_S3TC_DXT1_EXT Or format[0]=GL_COMPRESSED_RGBA_S3TC_DXT3_EXT Or format[0]=GL_COMPRESSED_RGBA_S3TC_DXT5_EXT
			Return True
		EndIf
		
	End Method
	
	Method UploadTexture2D()
	
		If IsCompressed()
			'glTexParameteri(target,GL_GENERATE_MIPMAP,GL_TRUE)
			glCompressedTexImage2D(GL_TEXTURE_2D,0,format[0],width[0],height[0],0,size[0],dxt)
			For Local j:Int=0 Until mipmapcount[0]
				Local mip:TDDS=mipmaps_array[j]
				glCompressedTexImage2D(GL_TEXTURE_2D,j+1,format[0],mip.width[0],mip.height[0],0,mip.size[0],mip.dxt)
			Next
		Else
			glTexImage2D(GL_TEXTURE_2D,0,components[0],width[0],height[0],0,format[0],GL_UNSIGNED_BYTE,dxt)
			For Local j:Int=0 Until mipmapcount[0]
				Local mip:TDDS=mipmaps_array[j]
				glTexImage2D(GL_TEXTURE_2D,j+1,components[0],mip.width[0],mip.height[0],0,format[0],GL_UNSIGNED_BYTE,mip.dxt)
			Next
		EndIf
		
	End Method
	
	Method UploadTextureCubeMap( i:Int,face:Int )
	
		Local surf:TDDS=mipmaps_array[i]
		If IsCompressed()
			glCompressedTexImage2D(face,0,format[0],surf.width[0],surf.height[0],0,surf.size[0],surf.dxt)
			'DebugLog "sw="+surf.width[0]+" sh="+surf.height[0]+" f="+format[0]+" ss="+surf.size[0]+" x="+Hex(Long(surf.dxt))+" smc="+surf.mipmapcount[0]
			For Local j:Int=0 Until surf.mipmapcount[0]
				Local mip:TDDS=surf.mipmaps_array[j]
				glCompressedTexImage2D(face,j+1,format[0],mip.width[0],mip.height[0],0,mip.size[0],mip.dxt)
			Next
		Else
			glTexImage2D(face,0,components[0],surf.width[0],surf.height[0],0,format[0],GL_UNSIGNED_BYTE,surf.dxt)
			'DebugLog "sw="+surf.width[0]+" sh="+surf.height[0]+" f="+format[0]+" c="+components[0]+" x="+Hex(Long(surf.dxt))+" smc="+surf.mipmapcount[0]
			For Local j:Int=0 Until surf.mipmapcount[0]
				Local mip:TDDS=surf.mipmaps_array[j]
				glTexImage2D(face,j+1,components[0],mip.width[0],mip.height[0],0,format[0],GL_UNSIGNED_BYTE,mip.dxt)
			Next
		EndIf
		
	End Method
	
End Type
