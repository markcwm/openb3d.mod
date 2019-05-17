
#include <memory.h>
#include <vector>
#include <iostream>
//#include "texture.h"

using namespace std;

class DirectDrawSurface{
public:
	unsigned char *buffer;
	vector<DirectDrawSurface> mipmaps;

	int width;
	int height;
	int depth;
	int mipmapcount;
	int pitch;
	int size;

	unsigned char *dxt;
	unsigned int format;
	unsigned int components;
	unsigned int target;

	static DirectDrawSurface *LoadSurface(const string& filename,bool flip=true,unsigned char *buffer=NULL,int bufsize=0);
	static int CountMipmaps(int width, int height);
	static void CopyRect(unsigned char* src,unsigned int srcW,unsigned int srcH,unsigned int srcX,unsigned int srcY,unsigned char* dst,unsigned int dstW,unsigned int dstH,unsigned int bPP,int invert,int format);

	DirectDrawSurface();
	~DirectDrawSurface() {}

	void FreeDirectDrawSurface(int free_buffer);

	bool IsCompressed();
	void Flip();

	void TextureParameters( int tex_flags );
	//void UploadTexture(Texture *tex);
	void UploadTexture2D(int mipmap_flag);
	void UploadTextureSubImage2D(int ix, int iy, int iwidth, int iheight, unsigned char* pixels, int mipmap_flag, int target, int inv);
	void UploadTextureCubeMap();
	
};

