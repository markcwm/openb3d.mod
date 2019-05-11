// glue.cpp

#include "glue.h"
#include "openb3d/dds.h"
#include "openb3d/glew_glee.h" // glee or glew

#include <stdio.h>
#include <string.h>
#include <math.h>

// DirectDrawSurface varid
const int DDS_buffer=		1;
const int DDS_mipmaps=		2;
const int DDS_width=		3;
const int DDS_height=		4;
const int DDS_depth=		5;
const int DDS_mipmapcount=	6;
const int DDS_pitch=		7;
const int DDS_size=			8;
const int DDS_dxt=			9;
const int DDS_format=		10;
const int DDS_components=	11;
const int DDS_target=		12;

extern "C" {

// data

unsigned char* DirectDrawSurfaceUChar_( DirectDrawSurface* obj, int varid ){
	switch (varid){
		case DDS_buffer : return (unsigned char*)&obj->buffer[0];
		case DDS_dxt : return (unsigned char*)&obj->dxt[0];
	}
	return NULL;
}

int* DirectDrawSurfaceInt_( DirectDrawSurface* obj, int varid ){
	switch (varid){
		case DDS_width : return &obj->width;
		case DDS_height : return &obj->height;
		case DDS_depth : return &obj->depth;
		case DDS_mipmapcount : return &obj->mipmapcount;
		case DDS_pitch : return &obj->pitch;
		case DDS_size : return &obj->size;
	}
	return NULL;
}

unsigned int* DirectDrawSurfaceUInt_( DirectDrawSurface* obj, int varid ){
	switch (varid){
		case DDS_format : return &obj->format;
		case DDS_components : return &obj->components;
		case DDS_target : return &obj->target;
	}
	return NULL;
}

DirectDrawSurface* DirectDrawSurfaceArray_( DirectDrawSurface* obj, int varid, int index ){
	switch (varid){
		case DDS_mipmaps : return &obj->mipmaps[index];
	}
	return NULL;
}

// methods

DirectDrawSurface* DDSLoadSurface_(char* filename, int flip, unsigned char* buffer, int bufsize){
	return DirectDrawSurface::LoadSurface(filename, flip, buffer, bufsize);
}

void DDSFreeDirectDrawSurface_(DirectDrawSurface* surface,int free_buffer){
	surface->FreeDirectDrawSurface(free_buffer);
}

int DDSCountMipmaps_(int width, int height){
	return DirectDrawSurface::CountMipmaps(width, height);
}

void DDSCopyRect_(unsigned char* src,unsigned int srcW,unsigned int srcH,unsigned int srcX,unsigned int srcY,unsigned char* dst,unsigned int dstW,unsigned int dstH,unsigned int bPP,int invert,int format){
	DirectDrawSurface::CopyRect(src, srcW, srcH, srcX, srcY, dst, dstW, dstH, bPP, invert, format);
}

} // end extern C
