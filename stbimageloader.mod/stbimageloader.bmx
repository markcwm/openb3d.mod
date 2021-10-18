' stbimageloader.bmx

SuperStrict

Rem
bbdoc: STB Image loader
about:
The stb image loader module provides the ability to load different image formats as #pixmaps.
Supported formats: BMP, PSD, TGA, GIF, PIC and PNM (BRL loaders are used for JPG and PNG).
End Rem
Module Openb3d.Stbimageloader

ModuleInfo "Version: 1.00"
ModuleInfo "Author: Sean Barrett and contributers (see stb_image.c)"
ModuleInfo "License: zlib/libpng"
ModuleInfo "Credits: Bruce A Henderson, Mark Mcvittie"

ModuleInfo "History: 1.00 - StbImage 1.35"
ModuleInfo "History: Initial Release - Apr 2018"

Import Brl.Pixmap
Import Brl.RamStream

Import "glue.c"

Extern' "C"

	?bmxng
	Function b3d_stbi_load_from_memory:Byte Ptr( buffer:Byte Ptr,bufLen:Size_T,width:Int Ptr,height:Int Ptr,chan:Int Ptr,req_chan:Int ) = "stbi_load_from_memory"
	Function b3d_stbi_info_from_memory:Int( buffer:Byte Ptr,bufLen:Size_T,width:Int Ptr,height:Int Ptr,chan:Int Ptr ) = "stbi_info_from_memory"
	?Not bmxng
	Function b3d_stbi_load_from_memory:Byte Ptr( buffer:Byte Ptr,bufLen:Int,width:Int Ptr,height:Int Ptr,chan:Int Ptr,req_chan:Int ) = "stbi_load_from_memory"
	Function b3d_stbi_info_from_memory:Int( buffer:Byte Ptr,bufLen:Int,width:Int Ptr,height:Int Ptr,chan:Int Ptr ) = "stbi_info_from_memory"
	?
	Function b3d_stbi_image_free( stbi_handle:Byte Ptr ) = "stbi_image_free"
	
End Extern

Const B3D_STBI_grey:Int       = 1
Const B3D_STBI_grey_alpha:Int = 2
Const B3D_STBI_rgb:Int        = 3
Const B3D_STBI_rgb_alpha:Int  = 4

Type TPixmapLoaderB3D Extends TPixmapLoader

	Method LoadPixmap:TPixmap( stream:TStream )
	
		?bmxng
		Local bufLen:Size_T = StreamSize(stream)
		?Not bmxng
		Local bufLen:Int = StreamSize(stream)
		?
		Local buffer:Byte Ptr = MemAlloc(bufLen)
		Local ram:TRamStream = CreateRamStream(buffer, bufLen, True, True)
		CopyStream(stream, ram)
		
		Local pixmap:TPixmap, imgPtr:Byte Ptr, width:Int, height:Int, channels:Int
		
		Local test:Int = b3d_stbi_info_from_memory(buffer, bufLen, Varptr width, Varptr height, Varptr channels)
		
		If test = True ' prevents crash
			imgPtr = b3d_stbi_load_from_memory(buffer, bufLen, Varptr width, Varptr height, Varptr channels, 4) ' force RGBA
			If channels = 3 Then channels = 4 ' for uncompressed BMP, may be 24 or 32-bit
		EndIf
		
		If imgPtr
			Local pf:Int
			Select channels
				Case B3D_STBI_grey ' 1
					pf = PF_I8
				Case B3D_STBI_rgb ' 3
					pf = PF_RGB888
				Case B3D_STBI_rgb_alpha ' 4
					pf = PF_RGBA8888
				Case B3D_STBI_grey_alpha ' 2
					Local src:Byte Ptr = imgPtr
					Local dst:Byte Ptr = pixmap.pixels
					pixmap = CreatePixmap(width, height, PF_RGBA8888)
					
					For Local y:Int = 0 Until height
						For Local x:Int = 0 Until width
							Local a:Int = src[0]
							Local i:Int = src[1]
							dst[0] = i
							dst[1] = i
							dst[2] = i
							dst[3] = a
							src:+2
							dst:+4
						Next
					Next
			EndSelect
			
			If pf
				pixmap = CreatePixmap(width, height, pf, BytesPerPixel[pf])
				?bmxng
				MemCopy(pixmap.pixels, imgPtr, Size_T(width * height * BytesPerPixel[pf]))
				?Not bmxng
				MemCopy(pixmap.pixels, imgPtr, Int(width * height * BytesPerPixel[pf]))
				?
			EndIf
			
			CloseStream(ram)
			MemFree(buffer)
			b3d_stbi_image_free(imgPtr)
		EndIf
		
		Return pixmap
		
	End Method
	
End Type

New TPixmapLoaderB3D
