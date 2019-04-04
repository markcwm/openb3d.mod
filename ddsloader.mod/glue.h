#ifndef data_h
#define data_h

#include "src/dds.h"

#include <vector>
#include <list>

#ifdef __cplusplus
extern "C" {
#endif

// data
char* DirectDrawSurfaceChar_( DirectDrawSurface* obj,int varid );
int* DirectDrawSurfaceInt_( DirectDrawSurface* obj,int varid );
unsigned int* DirectDrawSurfaceUInt_( DirectDrawSurface* obj,int varid );

// methods
DirectDrawSurface* LoadSurface_(char* filename,int flip,unsigned char* buffer,int bufsize);
void FreeDirectDrawSurface_(DirectDrawSurface* surface);

#ifdef __cplusplus
}; // extern "C"
#endif

#endif
