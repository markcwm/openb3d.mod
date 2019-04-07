#ifndef glue_h
#define glue_h

#include <vector>
#include <list>

class DirectDrawSurface;

#ifdef __cplusplus
extern "C" {
#endif

// data
unsigned char* DirectDrawSurfaceUChar_( DirectDrawSurface* obj,int varid );
int* DirectDrawSurfaceInt_( DirectDrawSurface* obj,int varid );
unsigned int* DirectDrawSurfaceUInt_( DirectDrawSurface* obj,int varid );
DirectDrawSurface* DirectDrawSurfaceArray_( DirectDrawSurface* obj,int varid,int index );

// methods
DirectDrawSurface* DDSLoadSurface(char* filename,int flip,unsigned char* buffer,int bufsize);
void DDSFreeDirectDrawSurface(DirectDrawSurface* surface,int free_buffer);

#ifdef __cplusplus
}; // extern "C"
#endif

#endif
