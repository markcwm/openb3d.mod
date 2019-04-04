// glue.cpp

#include "glue.h"

#include <stdio.h>
#include <string.h>

// DirectDrawSurface varid
const int DDS_buffer=		1;
const int DDS_mipmap=		2;
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

char* DirectDrawSurfaceChar_( DirectDrawSurface* obj,int varid ){
	switch (varid){
		case DDS_buffer : return (char*)&obj->buffer;
		case DDS_dxt : return (char*)&obj->dxt;
	}
	return NULL;
}

int* DirectDrawSurfaceInt_( DirectDrawSurface* obj,int varid ){
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

unsigned int* DirectDrawSurfaceUInt_( DirectDrawSurface* obj,int varid ){
	switch (varid){
		case DDS_format : return &obj->format;
		case DDS_components : return &obj->components;
		case DDS_target : return &obj->target;
	}
	return NULL;
}

// methods

DirectDrawSurface* DDS_LoadSurface(char* filename,int flip,unsigned char* buffer,int bufsize){
	return DirectDrawSurface::LoadSurface(filename,flip,buffer,bufsize);
}

void DDS_FreeDirectDrawSurface(DirectDrawSurface* surface,int free_buffer){
	surface->FreeDirectDrawSurface(free_buffer);
}

} // end extern C
