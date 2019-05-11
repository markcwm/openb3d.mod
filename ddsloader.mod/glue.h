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
DirectDrawSurface* DDSLoadSurface_(char* filename,int flip,unsigned char* buffer,int bufsize);
void DDSFreeDirectDrawSurface_(DirectDrawSurface* surface,int free_buffer);
int DDSCountMipmaps_(int width, int height);
void DDSCopyRect_(unsigned char* src,unsigned int srcW,unsigned int srcH,unsigned int srcX,unsigned int srcY,unsigned char* dst,unsigned int dstW,unsigned int dstH,unsigned int bPP,int invert,int format);

#ifdef __cplusplus
}; // extern "C"
#endif

#endif
