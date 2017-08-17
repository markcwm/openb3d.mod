
#include <memory.h>
#include <vector>
#include <iostream>
#include "texture.h"

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

	static DirectDrawSurface *LoadSurface(const string& filename,bool flip=true);

	DirectDrawSurface();
	~DirectDrawSurface() {}

	void FreeDirectDrawSurface();

	bool IsCompressed();
	void Flip();

	void UploadTexture(Texture *tex);
	void UploadTexture2D();
	void UploadTextureCubeMap();
};

