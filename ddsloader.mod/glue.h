#ifndef data_h
#define data_h

#include <vector>
#include <list>

class DirectDrawSurface;

#ifdef __cplusplus
extern "C" {
#endif

// data
char* DirectDrawSurfaceChar_( DirectDrawSurface* obj,int varid );
int* DirectDrawSurfaceInt_( DirectDrawSurface* obj,int varid );
unsigned int* DirectDrawSurfaceUInt_( DirectDrawSurface* obj,int varid );

// methods
DirectDrawSurface* LoadSurface_(char* filename,int flip,unsigned char* buffer,int bufsize);
void FreeDirectDrawSurface_(DirectDrawSurface* surface,int free_buffer);

#ifdef __cplusplus
}; // extern "C"
#endif

#endif