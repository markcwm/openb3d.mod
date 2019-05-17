
Rem
bbdoc: Loads a DDS file as a Max2D image
about: Loads compressed DXT1/3/5 or uncompressed RGB/RGBA/BGR/BGRA
End Rem
Function LoadImageDDS:TImage( url:Object, flags%=FILTEREDIMAGE, mr%=0, mg%=0, mb%=0 )

	Local pixmap:TPixmap = LoadPixmap(url)
	Local dds:TDDS = TDDS(TDDS.dds_list.Last())
	If dds.pixmap = Null
		DebugLog " No pixmap image loaded: "+String(url)
		Return Null
	EndIf
	
	If RedBitsPerPixel[0] = 0
		DebugLog " Max2d not compressed textures version"
	EndIf
	
	Local img:TImage = TImage.Create(dds.pixmap.width, dds.pixmap.height, 1, flags, mr, mg, mb)
	
	Local pix_format% = dds.format[0]
	If dds.format[0] = GL_COMPRESSED_RGB_S3TC_DXT1_EXT Then pix_format = GL_RGB
	If dds.format[0] = GL_COMPRESSED_RGBA_S3TC_DXT3_EXT Then pix_format = GL_RGBA
	If dds.format[0] = GL_COMPRESSED_RGBA_S3TC_DXT5_EXT Then pix_format = GL_RGBA
	
	Local name:Int
	glGenTextures(1, Varptr name)
	glBindTexture(GL_TEXTURE_2D, name)
	
	dds.ImageParameters(flags)
	dds.UploadTexture2D(flags & MIPMAPPEDIMAGE)
	
	If RedBitsPerPixel[0] = 0
		glGetTexImage(GL_TEXTURE_2D, 0, pix_format, GL_UNSIGNED_BYTE, dds.pixmap.pixels)
		glDeleteTextures(1, Varptr name)
	Else
		GreenBitsPerPixel[0] = dds.format[0] ' store dds format
		BlueBitsPerPixel[0] = name ' store texture name
	EndIf
	
	img.SetPixmap(0, dds.pixmap)
	
	dds.FreeDDS()
	Return img
	
End Function

Rem
bbdoc: Loads a DDS file as a Max2D multi-frame image
about: Loads compressed DXT1/3/5 or uncompressed RGB/RGBA/BGR/BGRA
End Rem
Function LoadAnimImageDDS:TImage( url:Object, cell_width%, cell_height%, first_cell%, cell_count%, flags%=FILTEREDIMAGE, mr%=0, mg%=0, mb%=0 )

	Local pixmap:TPixmap = LoadPixmap(url)
	Local dds:TDDS = TDDS(TDDS.dds_list.Last())
	If dds.pixmap = Null
		DebugLog " No pixmap image loaded: "+String(url)
		Return Null
	EndIf
	
	If RedBitsPerPixel[0] = 0
		DebugLog " Max2d not compressed textures version"
	EndIf
	
	Local x_cells% = dds.pixmap.width / cell_width
	Local y_cells% = dds.pixmap.height / cell_height
	If (first_cell+cell_count) > (x_cells*y_cells) Then Return Null
	
	Local img:TImage = TImage.Create(cell_width, cell_height, cell_count, flags, mr, mg, mb)
	
	Local pix_format% = dds.format[0]
	If dds.format[0] = GL_COMPRESSED_RGB_S3TC_DXT1_EXT Then pix_format = GL_RGB
	If dds.format[0] = GL_COMPRESSED_RGBA_S3TC_DXT3_EXT Then pix_format = GL_RGBA
	If dds.format[0] = GL_COMPRESSED_RGBA_S3TC_DXT5_EXT Then pix_format = GL_RGBA
	
	Local name:Int
	For Local cell% = first_cell To (first_cell+cell_count-1)
		Local x% = (cell Mod x_cells) * cell_width
		Local y% = (cell / x_cells) * cell_height
		
		Local animmap:TPixmap = CreatePixmap(cell_width, cell_height, dds.pixmap.format, BytesPerPixel[dds.pixmap.format])
		
		glGenTextures(1, Varptr name)
		glBindtexture(GL_TEXTURE_2D, name)
		
		dds.ImageParameters(flags)
		dds.UploadTextureSubImage2D(x, y, cell_width, cell_height, animmap.pixels, flags & MIPMAPPEDIMAGE)
		
		If RedBitsPerPixel[0] = 0
			glGetTexImage(GL_TEXTURE_2D, 0, pix_format, GL_UNSIGNED_BYTE, animmap.pixels)
			glDeleteTextures(1, Varptr name)
		Else
			DDSCopyRect_(dds.dxt, dds.width[0], dds.height[0], x, y, animmap.pixels, cell_width, cell_height, dds.components[0], 0, dds.format[0])
			GreenBitsPerPixel[0] = dds.format[0] ' store dds format
			BlueBitsPerPixel[0] = name ' store texture name
		EndIf
		
		img.SetPixmap(cell-first_cell, animmap)
	Next
	
	dds.FreeDDS()
	Return img
	
End Function

Rem
bbdoc: DirectDrawSurface
End Rem
Type TDDS

	Global dds_list:TList = CreateList()
	
	Field buffer:Byte Ptr
	Field mipmaps:TDDS[1]
	
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
	
	' wrapper
	Field pixmap:TPixmap
	Field bmx_buffer:Byte Ptr
	
	?bmxng
	Global dds_map:TPtrMap = New TPtrMap
	?Not bmxng
	Global dds_map:TMap = New TMap
	?
	Field instance:Byte Ptr
	Field exists:Int = 0 ' Free
	
	Function CreateObject:TDDS( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst = Null Then Return Null
		Local obj:TDDS = New TDDS
		?bmxng
		dds_map.Insert( inst, obj )
		?Not bmxng
		dds_map.Insert( String(Int(inst)), obj )
		?
		obj.instance = inst
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
		buffer = DirectDrawSurfaceUChar_( GetInstance(Self), DDS_buffer )
		dxt = DirectDrawSurfaceUChar_( GetInstance(Self), DDS_dxt )
		
		' int
		width = DirectDrawSurfaceInt_( GetInstance(Self), DDS_width )
		height = DirectDrawSurfaceInt_( GetInstance(Self), DDS_height )
		depth = DirectDrawSurfaceInt_( GetInstance(Self), DDS_depth )
		mipmapcount = DirectDrawSurfaceInt_( GetInstance(Self), DDS_mipmapcount )
		pitch = DirectDrawSurfaceInt_( GetInstance(Self), DDS_pitch )
		size = DirectDrawSurfaceInt_( GetInstance(Self), DDS_size )
		
		' uint
		format = DirectDrawSurfaceUInt_( GetInstance(Self), DDS_format )
		components = DirectDrawSurfaceUInt_( GetInstance(Self), DDS_components )
		target = DirectDrawSurfaceUInt_( GetInstance(Self), DDS_target )
		
		' dds
		If mipmapcount[0] > 0
			mipmaps = mipmaps[..mipmapcount[0]]
			For Local id:Int = 0 Until mipmapcount[0]
				Local inst:Byte Ptr = DirectDrawSurfaceArray_( GetInstance(Self), DDS_mipmaps, id )
				mipmaps[id] = GetObject(inst)
				If mipmaps[id] = Null And inst <> Null Then mipmaps[id] = CreateObject(inst)
			Next
		EndIf
		
		exists=1
		
	End Method
	
	Function StringPtr:String( inst:Byte Ptr )
	
		?bmxng
		Return String(inst)
		?Not bmxng
		Return String(Int(inst))
		?
		
	End Function
	
	Method DebugFields( debug_subobjects:Int = 0, debug_base_types:Int = 0 )
	
		Local pad:String
		Local loop:Int=debug_subobjects
		If debug_base_types > debug_subobjects Then loop = debug_base_types
		For Local i% = 1 Until loop
			pad:+"  "
		Next
		If debug_subobjects Then debug_subobjects:+1
		If debug_base_types Then debug_base_types:+1
		DebugLog pad+" DDS instance: "+StringPtr(GetInstance(Self))
		
		' char
		If buffer <> Null Then DebugLog(pad+" buffer: "+StringPtr(buffer)) Else DebugLog(pad+" buffer: Null")
		If dxt <> Null Then DebugLog(pad+" dxt: "+StringPtr(dxt)) Else DebugLog(pad+" dxt: Null")
		
		' int
		If width <> Null Then DebugLog(pad+" width: "+width[0]) Else DebugLog(pad+" width: Null")
		If height <> Null Then DebugLog(pad+" height: "+height[0]) Else DebugLog(pad+" height: Null")
		If depth <> Null Then DebugLog(pad+" depth: "+depth[0]) Else DebugLog(pad+" depth: Null")
		If mipmapcount <> Null Then DebugLog(pad+" mipmapcount: "+mipmapcount[0]) Else DebugLog(pad+" mipmapcount: Null")
		If pitch <> Null Then DebugLog(pad+" pitch: "+pitch[0]) Else DebugLog(pad+" pitch: Null")
		If size <> Null Then DebugLog(pad+" size: "+size[0]) Else DebugLog(pad+" size: Null")
		
		' uint
		If format <> Null Then DebugLog(pad+" format: "+format[0]) Else DebugLog(pad+" format: Null")
		If components <> Null Then DebugLog(pad+" components: "+components[0]) Else DebugLog(pad+" components: Null")
		If target <> Null Then DebugLog(pad+" target: "+target[0]) Else DebugLog(pad+" target: Null")
		
		DebugLog ""
		
	End Method
	
	' Openb3d
	
	Method FreeDDS()
	
		If exists
			exists = 0
			GreenBitsPerPixel[0] = 0
			BlueBitsPerPixel[0] = 0
			ListRemove TDDS.dds_list, Self
			DDSFreeDirectDrawSurface_( GetInstance(Self), 0 ) ' don't free buffer, it was freed in Bmax
			If bmx_buffer <> Null And width[0]>0 And height[0]>0 ' check avoids crash in GL 2.0
				MemFree(bmx_buffer)
			EndIf
			For Local id:Int = 0 Until mipmapcount[0]
				If mipmaps[id] <> Null Then FreeObject( GetInstance(mipmaps[id]) )
			Next
			FreeObject( GetInstance(Self) )
		EndIf
		
	End Method
	
	Method GetPitch:Int( width%, format%, components% )
	
		If format = GL_COMPRESSED_RGB_S3TC_DXT1_EXT Or format = GL_COMPRESSED_RGBA_S3TC_DXT3_EXT Or format = GL_COMPRESSED_RGBA_S3TC_DXT5_EXT
			Local bpp:Int
			If format = GL_COMPRESSED_RGB_S3TC_DXT1_EXT Then bpp = 8 Else bpp = 16
			Return ((width+3) / 4) * bpp
		EndIf
		Return width * components
		
	End Method
	
	Method IsCompressed:Int()
	
		If format[0] = GL_COMPRESSED_RGB_S3TC_DXT1_EXT Or format[0] = GL_COMPRESSED_RGBA_S3TC_DXT3_EXT Or format[0] = GL_COMPRESSED_RGBA_S3TC_DXT5_EXT
			Return True
		EndIf
		Return False
		
	End Method
	
	Method ImageParameters( flags%=FILTEREDIMAGE )
	
		' set texture parameters
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
		
		If (flags & FILTEREDIMAGE)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
			If (flags & MIPMAPPEDIMAGE)
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
			Else
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
			EndIf
		Else
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST)
			If (flags & MIPMAPPEDIMAGE)
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST_MIPMAP_NEAREST)
			Else
				glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST)
			EndIf
		EndIf
		
	End Method
	
	Method TextureParameters( tex_flags%=9 )
	
		' mipmapping texture flag
		If (tex_flags & 8)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR)
		Else ' no mipmaps
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST) 'GL_LINEAR
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST) 'GL_LINEAR
		EndIf
		
		' clamp u flag
		If (tex_flags & 16)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE)
		Else
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
		EndIf
		
		' clamp v flag
		If (tex_flags & 32)
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE)
		Else
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
		EndIf
		
	End Method
	
	Method UploadTexture2D( mipmap_flag%=0 )
	
		Local row%, mmc% = mipmapcount[0]
		
		If mipmapcount[0] > DDSCountMipmaps_(width[0], height[0]) ' fix if too many mipmaps
			mmc = DDSCountMipmaps_(width[0], height[0])
		EndIf
		
		If IsCompressed()
			row = GetPitch(width[0], format[0], 0)
			glPixelStorei(GL_UNPACK_ROW_LENGTH, row)
			glCompressedTexImage2D(GL_TEXTURE_2D, 0, format[0], width[0], height[0], 0, size[0], dxt)
			
			For Local j:Int = 0 Until mmc
				Local mip:TDDS = mipmaps[j]
				If mip.width[0] = 0 Or mip.height[0] = 0 Or mipmap_flag = 0 Then Exit
				row = GetPitch(mip.width[0], format[0], 0)
				glPixelStorei(GL_UNPACK_ROW_LENGTH, row)
				glCompressedTexImage2D(GL_TEXTURE_2D, j+1, format[0], mip.width[0], mip.height[0], 0, mip.size[0], mip.dxt)
			Next
		Else
			glPixelStorei(GL_UNPACK_ALIGNMENT, components[0])
			row = GetPitch(width[0], format[0], components[0])
			glPixelStorei(GL_UNPACK_ROW_LENGTH, row / components[0])
			glTexImage2D(GL_TEXTURE_2D, 0, components[0], width[0], height[0], 0, format[0], GL_UNSIGNED_BYTE, dxt)
			
			For Local j:Int = 0 Until mmc
				Local mip:TDDS = mipmaps[j]
				If mip.width[0] = 0 Or mip.height[0] = 0 Or mipmap_flag = 0 Then Exit
				row = GetPitch(mip.width[0], format[0], components[0])
				glPixelStorei(GL_UNPACK_ROW_LENGTH, row / components[0])
				glTexImage2D(GL_TEXTURE_2D, j+1, components[0], mip.width[0], mip.height[0], 0, format[0], GL_UNSIGNED_BYTE, mip.dxt)
			Next
		EndIf
		
		glPixelStorei(GL_UNPACK_ROW_LENGTH, 0)
		
	End Method
	
	Method UploadTextureSubImage2D( ix%, iy%, iwidth%, iheight%, pixels:Byte Ptr=Null, mipmap_flag%=0, target%=GL_TEXTURE_2D, inv%=0 )
		
		Local mwidth%, mheight%, row%, height4%, mmc% = mipmapcount[0]
		
		If mipmapcount[0] > DDSCountMipmaps_(iwidth, iheight) ' fix if too many mipmaps (anim strip)
			mmc = DDSCountMipmaps_(iwidth, iheight)
		EndIf
		
		If IsCompressed()
			If iheight > 4 Then height4 = iheight/4 Else height4 = 1
			row = GetPitch(iwidth, format[0], 0)
			glPixelStorei(GL_UNPACK_ROW_LENGTH, row)
			DDSCopyRect_(dxt, width[0], height[0], ix, iy, pixels, iwidth, iheight, 0, inv, format[0])
			glCompressedTexImage2D(target, 0, format[0], iwidth, iheight, 0, row*height4, pixels)
			
			For Local j:Int = 0 Until mmc
				Local mip:TDDS = mipmaps[j]
				Local pow2% = 2 ^ (j+1) ' 2/4/8
				mwidth = iwidth / pow2 ; mheight = iheight / pow2
				If mheight > 4 Then height4 = mheight/4 Else height4 = 1
				If mwidth = 0 Or mheight = 0 Or mipmap_flag = 0 Then Exit
				row = GetPitch(mwidth, format[0], 0)
				glPixelStorei(GL_UNPACK_ROW_LENGTH, row)
				DDSCopyRect_(mip.dxt, mip.width[0], mip.height[0], ix/pow2, iy/pow2, pixels, mwidth, mheight, 0, inv, format[0])
				glCompressedTexImage2D(target, j+1, format[0], mwidth, mheight, 0, row*height4, pixels)
			Next
		Else
			glPixelStorei(GL_UNPACK_ALIGNMENT, components[0])
			row = GetPitch(iwidth, format[0], components[0])
			glPixelStorei(GL_UNPACK_ROW_LENGTH, row / components[0])
			DDSCopyRect_(dxt, width[0], height[0], ix, iy, pixels, iwidth, iheight, components[0], inv, format[0])
			glTexImage2D(target, 0, components[0], iwidth, iheight, 0, format[0], GL_UNSIGNED_BYTE, pixels)
			
			For Local j:Int = 0 Until mmc
				Local mip:TDDS = mipmaps[j]
				Local pow2% = 2 ^ (j+1) ' 2/4/8
				mwidth = iwidth / pow2 ; mheight = iheight / pow2
				If mwidth = 0 Or mheight = 0 Or mipmap_flag = 0 Then Exit
				row = GetPitch(mwidth, format[0], components[0])
				glPixelStorei(GL_UNPACK_ROW_LENGTH, row / components[0])
				DDSCopyRect_(mip.dxt, mip.width[0], mip.height[0], ix/pow2, iy/pow2, pixels, mwidth, mheight, components[0], inv, format[0])
				glTexImage2D(target, j+1, components[0], mwidth, mheight, 0, format[0], GL_UNSIGNED_BYTE, pixels)
			Next
		EndIf
		
		glPixelStorei(GL_UNPACK_ROW_LENGTH, 0)
		
	End Method
	
	Method UploadTextureCubeMap() ' not tested (DDS cubemap-in-mipmaps format)
	
		For Local i%=0 To 5
			Local face% = GL_TEXTURE_CUBE_MAP_POSITIVE_X+i
			Local surf:TDDS = mipmaps[i]
			
			If IsCompressed()
				glCompressedTexImage2D(face, 0, format[0], surf.width[0], surf.height[0], 0, surf.size[0], surf.dxt)
				For Local j:Int=0 Until surf.mipmapcount[0]
					Local mip:TDDS=surf.mipmaps[j]
					glCompressedTexImage2D(face, j+1, format[0], mip.width[0], mip.height[0], 0, mip.size[0], mip.dxt)
				Next
			Else
				glTexImage2D(face, 0, components[0], surf.width[0], surf.height[0], 0, format[0], GL_UNSIGNED_BYTE, surf.dxt)
				For Local j:Int=0 Until surf.mipmapcount[0]
					Local mip:TDDS=surf.mipmaps[j]
					glTexImage2D(face, j+1, components[0], mip.width[0], mip.height[0], 0, format[0], GL_UNSIGNED_BYTE, mip.dxt)
				Next
			EndIf
		Next
		
	End Method
	
End Type
