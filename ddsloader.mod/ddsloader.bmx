' ddsloader.bmx

SuperStrict

Rem
bbdoc: Graphics/Stb Image loader
about:
The stb image loader module provides the ability to load different image format #pixmaps.
Supported formats include, BMP, PSD, TGA, GIF, HDR, PIC and PNM
End Rem
Module Openb3dmax.DDSloader

ModuleInfo "Version: 1.00"
ModuleInfo "Author: Spinduluz"
ModuleInfo "License: zlib/libpng"
ModuleInfo "Credits: Mark Mcvittie"

ModuleInfo "History: 1.00 - DirectDrawSurface pixmap factory loader"
ModuleInfo "History: Initial Release - Apr 2019"

Import Pub.Glew
Import Brl.Pixmap
Import Brl.RamStream
Import Brl.Map

Import "source.bmx"

' DirectDrawSurface varid
Const DDS_buffer:Int=		1
Const DDS_mipmap:Int=		2
Const DDS_width:Int=		3
Const DDS_height:Int=		4
Const DDS_depth:Int=		5
Const DDS_mipmapcount:Int=	6
Const DDS_pitch:Int=		7
Const DDS_size:Int=			8
Const DDS_dxt:Int=			9
Const DDS_format:Int=		10
Const DDS_components:Int=	11
Const DDS_target:Int=		12

Extern' "C"

	' data
	Function DirectDrawSurfaceChar_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function DirectDrawSurfaceInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function DirectDrawSurfaceUInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	
	' methods
	?bmxng
	Function DDS_LoadSurface:Byte Ptr( filename:Byte Ptr,Flip:Byte Ptr,buffer:Byte Ptr,bufsize:Size_T )
	?Not bmxng
	Function DDS_LoadSurface:Byte Ptr( filename:Byte Ptr,Flip:Byte Ptr,buffer:Byte Ptr,bufsize:Int )
	?
	Function DDS_UploadTexture( surface:Byte Ptr,tex:Byte Ptr )
	Function DDS_FreeDirectDrawSurface( surface:Byte Ptr )
	
End Extern

Include "TDDS.bmx"

Type TPixmapLoaderDDS Extends TPixmapLoader

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
		
		Local file:String=""
		Local cString:Byte Ptr=file.ToCString()
		imgPtr=DDS_LoadSurface( cString,False,buffer,bufLen ) ' force RGBA
		MemFree cString
		
		TDDS.current_surface=TDDS.CreateObject(imgPtr)
		channels=TDDS.current_surface.components[0] ' may be 24 or 32-bit
		
		If imgPtr
			Local pf:Int
			Select channels
				Case 3
					pf = PF_RGB888
				Case 4
					pf = PF_RGBA8888
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
			'MemFree(buffer) ' buffer must be freed later by DDS_FreeDirectDrawSurface
		EndIf
		
		Return pixmap
		
	End Method
	
End Type

New TPixmapLoaderDDS
