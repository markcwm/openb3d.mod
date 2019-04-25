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
ModuleInfo "Wrapper: Mark Mcvittie"
ModuleInfo "License: zlib/libpng"

ModuleInfo "History: 1.00 - DirectDrawSurface pixmap loader"
ModuleInfo "History: Initial Release - Apr 2019"

?win32
ModuleInfo "CC_OPTS: -DGLEW_STATIC" ' build static .a otherwise .dll (Win only)

Import Pub.Glew
Import Pub.OpenGL ' order is important, glew before OpenGL
?macos
Import Pub.Glew
Import Pub.OpenGL
?linux
Import Pub.Glew
Import Pub.OpenGL
?opengles
ModuleInfo "CC_OPTS: -UGLES2" ' untested!

Import Pub.OpenGLES
?
Import Brl.GLMax2D
Import Brl.Pixmap
Import Brl.RamStream
Import Brl.Retro
Import Brl.Map

Import "source.bmx"

' DirectDrawSurface varid
Const DDS_buffer:Int=		1
Const DDS_mipmaps:Int=		2
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
	Function DirectDrawSurfaceUChar_:Byte Ptr( obj:Byte Ptr,varid:Int )
	Function DirectDrawSurfaceInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function DirectDrawSurfaceUInt_:Int Ptr( obj:Byte Ptr,varid:Int )
	Function DirectDrawSurfaceArray_:Byte Ptr( obj:Byte Ptr,varid:Int,index:Int )
	
	' methods
	Function DDSLoadSurface_:Byte Ptr( filename:Byte Ptr,Flip:Int,buffer:Byte Ptr,bufsize:Int )
	Function DDSFreeDirectDrawSurface_( surface:Byte Ptr,free_buffer:Int )
	Function DDSCountMipmaps_:Int( width:Int,height:Int )
	Function DDSCopyRect_( src:Byte Ptr,srcW:Int,srcH:Int,srcX:Int,srcY:Int,dst:Byte Ptr,dstW:Int,dstH:Int,bPP:Int,invert:Int,format:Int )
	
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
		
		Local file:String = ""
		Local cString:Byte Ptr = file.ToCString()
		imgPtr = DDSLoadSurface_(cString, 0, buffer, bufLen) ' 0 to not flip image
		MemFree cString
		
		If imgPtr
			TDDS.current_surface = TDDS.CreateObject(imgPtr)
			channels = TDDS.current_surface.components[0] ' may be 24 or 32-bit
			width = TDDS.current_surface.width[0]
			height = TDDS.current_surface.height[0]
			
			Local pf:Int
			Select channels
				Case 3
					pf = PF_RGB888
				Case 4
					pf = PF_RGBA8888
			EndSelect
			
			If pf
				pixmap = CreatePixmap(width, height, pf, BytesPerPixel[pf])
				TDDS.current_surface.pixmap = pixmap
			EndIf
			
			CloseStream(ram)
			TDDS.current_buffer = buffer
			'MemFree(buffer) ' must be freed later in FreeDDS
		EndIf
		
		Return pixmap
		
	End Method
	
End Type

New TPixmapLoaderDDS
