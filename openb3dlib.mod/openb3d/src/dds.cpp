
#include "file.h"
#include "dds.h"
//#include <GL/glew.h>
#include "glew_glee.h" // glee or glew
#include "string_helper.h"

#include <stdio.h>
#include <strings.h>
#include <math.h>
#include <algorithm>

struct DXTColorBlock{
	unsigned short col0;
	unsigned short col1;
	unsigned char row[4];
};

struct DXT3AlphaBlock {
	unsigned short row[4];
};

struct DXT5AlphaBlock {
	unsigned char alpha0;
	unsigned char alpha1;
	unsigned char row[6];
};

typedef void (*FlipDXT)(DXTColorBlock *line,unsigned int num);

enum{ DXT_MASK=0x00000007 };

inline void DXT_FlipAlphaDXT5(DXT5AlphaBlock *block){
	unsigned char bits[4][4];
	unsigned int bit, *p;

	bit=0;
	memcpy(&bit,&block->row[0],3);

	bits[0][0]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[0][1]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[0][2]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[0][3]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[1][0]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[1][1]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[1][2]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[1][3]=(unsigned char)(bit & DXT_MASK);

	bit=0;
	memcpy(&bit,&block->row[3],3);

	bits[2][0]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[2][1]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[2][2]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[2][3]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[3][0]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[3][1]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[3][2]=(unsigned char)(bit & DXT_MASK);
	bit>>=3;
	bits[3][3]=(unsigned char)(bit & DXT_MASK);
	
	p=((unsigned int*)&(block->row[0]));

	*p=*p | (bits[3][0]<<0);
	*p=*p | (bits[3][1]<<3);
	*p=*p | (bits[3][2]<<6);
	*p=*p | (bits[3][3]<<9);

	*p=*p | (bits[2][0]<<12);
	*p=*p | (bits[2][1]<<15);
	*p=*p | (bits[2][2]<<18);
	*p=*p | (bits[2][3]<<21);

	p=((unsigned int*)&(block->row[3]));

	*p=*p | (bits[1][0]<<0);
	*p=*p | (bits[1][1]<<3);
	*p=*p | (bits[1][2]<<6);
	*p=*p | (bits[1][3]<<9);

	*p &= 0xff000000;

	*p=*p | (bits[0][0]<<12);
	*p=*p | (bits[0][1]<<15);
	*p=*p | (bits[0][2]<<18);
	*p=*p | (bits[0][3]<<21);
}

inline void DXT_SwapPointer(void *ptr1,void *ptr2,unsigned int size){
	static vector<unsigned char> tmp;
	void *ptr;

	// FIXME:
	//	Use shrink to fit?
	//	Max size to avoid possible overflows?
	if (tmp.size()<size+1)
		tmp.resize(size<10?10:size+1);

	ptr=&tmp[0];
	memcpy(ptr,ptr1,size);
	memcpy(ptr1,ptr2,size);
	memcpy(ptr2,ptr,size);
}

template<short size>
inline void DXT_SwapPointer(void *ptr1,void *ptr2){
	unsigned char temp[size];

	memcpy(temp,ptr1,size);
	memcpy(ptr1,ptr2,size);
	memcpy(ptr2,temp,size);
}

inline void DXT_FlipBlocksDXTC1(DXTColorBlock *line,unsigned int num){
	DXTColorBlock *current;
	unsigned int i;

	current=line;
	for(i=0; i<num; i++){
		swap(current->row[0],current->row[3]);
		swap(current->row[1],current->row[2]);

		current++;
	}

}

inline void DXT_FlipBlocksDXTC3(DXTColorBlock *line,unsigned int num){
	DXT3AlphaBlock	*block;
	DXTColorBlock	*current;
	unsigned int i;

	current=line;
	for(i=0; i<num; i++){
		block=(DXT3AlphaBlock*)current;

		swap(block->row[0],block->row[3]);
		swap(block->row[1],block->row[2]);

		current++;

		swap(current->row[0],current->row[3]);
		swap(current->row[1],current->row[2]);

		current++;
	}
}

inline void DXT_FlipBlocksDXTC5(DXTColorBlock *line,unsigned int num){
	DXT5AlphaBlock	*block;
	DXTColorBlock	*current;
	unsigned int i;

	current=line;
	for(i=0; i<num; i++){
		block=(DXT5AlphaBlock*)current;

		DXT_FlipAlphaDXT5(block);

		current++;

		swap(current->row[0],current->row[3]);
		swap(current->row[1],current->row[2]);

		current++;
	}
}

// ==========================================================================================================
enum{
	DDSD_CAPS					=0x00000001,
	DDSD_HEIGHT					=0x00000002,
	DDSD_WIDTH					=0x00000004,
	DDSD_PITCH					=0x00000008,
	DDSD_PIXELFORMAT			=0x00001000,
	DDSD_MIPMAPCOUNT			=0x00020000,
	DDSD_LINEARSIZE				=0x00080000,
	DDSD_DEPTH					=0x00800000,

	DDPF_ALPHAPIXELS			=0x00000001,
	DDPF_FOURCC					=0x00000004,
	DDPF_RGB					=0x00000040,
	DDPF_RGBA					=0x00000041,

	DDSCAPS_COMPLEX				=0x00000008,
	DDSCAPS_TEXTURE				=0x00001000,
	DDSCAPS_MIPMAP				=0x00400000,

	DDSCAPS2_CUBEMAP			=0x00000200,
	DDSCAPS2_CUBEMAP_POSITIVEX	=0x00000400,
	DDSCAPS2_CUBEMAP_NEGATIVEX	=0x00000800,
	DDSCAPS2_CUBEMAP_POSITIVEY	=0x00001000,
	DDSCAPS2_CUBEMAP_NEGATIVEY	=0x00002000,
	DDSCAPS2_CUBEMAP_POSITIVEZ	=0x00004000,
	DDSCAPS2_CUBEMAP_NEGATIVEZ	=0x00008000,
	DDSCAPS2_CUBEMAP_ALL_FACES	=0x0000FC00,
	DDSCAPS2_VOLUME				=0x00200000,

	FOURCC_DXT1					=0x31545844,
	FOURCC_DXT3					=0x33545844,
	FOURCC_DXT5					=0x35545844
};

#pragma pack(push,packed)
#pragma pack(1)

struct DDSPixelFormat{
	unsigned int	size;
	unsigned int	flags;
	unsigned int	fourcc;
	unsigned int	rgbbitcount;
	unsigned int	rbitmask;
	unsigned int	gbitmask;
	unsigned int	bbitmask;
	unsigned int	abitmask;
};

struct DDSHeader{
	unsigned int	size;
	unsigned int	flags;
	unsigned int	height;
	unsigned int	width;
	unsigned int	pitchoflinearsize;
	unsigned int	depth;
	unsigned int	mipmapcount;
	unsigned int	reserved1[11];
	DDSPixelFormat	pixelformat;
	unsigned int	caps1;
	unsigned int	caps2;
	unsigned int	reserved2[3];
};

#pragma pack(pop,packed)

inline int DDS_Clamp(int a) { return a<1?1:a; }

inline bool DDS_GetInfo(DDSHeader *header,unsigned int& format,int& components,unsigned int& target){
	target=GL_TEXTURE_2D;
	if(header->caps2 & DDSCAPS2_CUBEMAP){
		target=GL_TEXTURE_CUBE_MAP;
	}
	// texture3D not implemented?
	if(header->caps2 & DDSCAPS2_VOLUME){
		return false;
	}

	DDSPixelFormat& pf=header->pixelformat;

	if(header->pixelformat.flags & DDPF_FOURCC){
		switch(header->pixelformat.fourcc)
		{
		case FOURCC_DXT1:
			format=GL_COMPRESSED_RGB_S3TC_DXT1_EXT;
			components=3;
			break;

		case FOURCC_DXT3:
			format=GL_COMPRESSED_RGBA_S3TC_DXT3_EXT;
			components=4;
			break;

		case FOURCC_DXT5:
			format=GL_COMPRESSED_RGBA_S3TC_DXT5_EXT;
			components=4;
			break;
		}
	}else if(header->pixelformat.flags & DDPF_RGBA && header->pixelformat.rgbbitcount==32){
		if(pf.rbitmask==0x00ff0000 && pf.gbitmask==0x0000ff00 && pf.bbitmask==0x000000ff && pf.abitmask==0xff000000){
			format=GL_BGRA;
			components=4;
		}else{
			format=GL_RGBA;
			components=4;
		}
	}else if(header->pixelformat.flags & DDPF_RGB && header->pixelformat.rgbbitcount==32){
		if(pf.rbitmask==0x00ff0000 && pf.gbitmask==0x0000ff00 && pf.bbitmask==0x000000ff){
			format=GL_BGRA;
			components=4;
		}else{
			format=GL_RGBA;
			components=4;
		}
	}else if(header->pixelformat.flags & DDPF_RGB && header->pixelformat.rgbbitcount==24){
		if(pf.rbitmask==0x00ff0000 && pf.gbitmask==0x0000ff00 && pf.bbitmask==0x000000ff){
			format=GL_BGR;
			components=3;
		}else{
			format=GL_RGB;
			components=3;
		}
	}else if(header->pixelformat.rgbbitcount==8){ // Luminance?
		return false;
	}else{
		return false;
	}

	return true;
}

inline int DDS_GetSizeBytes(int width,int height,int format,int components){
	if(format==GL_COMPRESSED_RGB_S3TC_DXT1_EXT || format==GL_COMPRESSED_RGBA_S3TC_DXT3_EXT || format==GL_COMPRESSED_RGBA_S3TC_DXT5_EXT){
		return ((width+3)/4) * ((height+3)/4) * (format==GL_COMPRESSED_RGB_S3TC_DXT1_EXT?8:16);
	}
	return width * height * components;
}

inline int DDS_GetPitch(int width,unsigned int format,int components){
	if(format==GL_COMPRESSED_RGB_S3TC_DXT1_EXT || format==GL_COMPRESSED_RGBA_S3TC_DXT3_EXT || format==GL_COMPRESSED_RGBA_S3TC_DXT5_EXT){
		return ((width+3)/4) * ((format==GL_COMPRESSED_RGB_S3TC_DXT1_EXT?8:16));
	}
	return width * components;
}

//	It might not be much point in doing this (unused)
inline DirectDrawSurface* GetDirectDrawSurfacePtr(){
	static DirectDrawSurface dds[16];
	static int index=0;

	DirectDrawSurface* s=&dds[index++ & 15];
	return s;
}

DirectDrawSurface *DirectDrawSurface::LoadSurface(const string& filename,bool flip,unsigned char *buffer,int bufsize){
	unsigned char *buf;
	DDSHeader *dds;
	File* file;
	int len;
	
	if(buffer==NULL){
		file=File::ReadFile(filename);
		if(file==NULL) return 0;
		
		len=file->FileSize();
		
		buffer=new unsigned char[len];
		file->Read(buffer,1,len);
	}else{
		len=bufsize;
	}
	
	buf=buffer;
	if(strncasecmp((char*)buf,"DDS ",4)) return NULL;

	buf+=4;
	dds=(DDSHeader*)buf;
	buf+=sizeof(DDSHeader);

	unsigned int format,target;
	int components;

	// Just to silence the compiler
	format=0;
	target=0;
	components=0;

	if(!DDS_GetInfo(dds,format,components,target)) return NULL;

	DirectDrawSurface *surface=new DirectDrawSurface;
	int mipmaps;

	surface->buffer=buffer;
	mipmaps=dds->mipmapcount;

	if(mipmaps!=0) mipmaps--;

	for(int i=0; i<(target==GL_TEXTURE_CUBE_MAP?6:1); i++){
		DirectDrawSurface *base;

		if(target==GL_TEXTURE_CUBE_MAP){
			surface->mipmaps.push_back(DirectDrawSurface());
			base=&surface->mipmaps.back();
		}else
			base=surface;

		base->format=format;
		base->target=target;
		base->dxt=buf;
		base->width=dds->width;
		base->height=dds->height;
		base->depth=DDS_Clamp(dds->depth);
		base->pitch=DDS_GetPitch(base->width,format,components);
		base->size=DDS_GetSizeBytes(base->width,base->height,format,components) * base->depth;
		base->components=components;
		base->mipmapcount=mipmaps;

		buf+=base->size;

		if(flip) base->Flip();

		int w,h,d;

		w=DDS_Clamp(base->width>>1);
		h=DDS_Clamp(base->height>>1);
		d=DDS_Clamp(base->depth>>1);

		for(int j=0; j<mipmaps && ( w || h ); j++){
			DirectDrawSurface *mip;
			base->mipmaps.push_back(DirectDrawSurface());
			mip=&base->mipmaps.back();

			mip->format=format;
			mip->target=target;
			mip->dxt=buf;
			mip->width=w;
			mip->height=h;
			mip->depth=d;
			mip->pitch=DDS_GetPitch(w,format,components);
			mip->size=DDS_GetSizeBytes(w,h,format,components) * d;
			mip->components=components;

			buf+=mip->size;

			if(flip) mip->Flip();

			w=DDS_Clamp(w>>1);
			h=DDS_Clamp(h>>1);
			d=DDS_Clamp(d>>1);
		}
	}

	if(target==GL_TEXTURE_CUBE_MAP && flip){
		DirectDrawSurface tmp=surface->mipmaps[3];
		surface->mipmaps[3]=surface->mipmaps[2];
		surface->mipmaps[2]=tmp;
	}

	return surface;
}

int DirectDrawSurface::CountMipmaps(int width, int height){
	return 1 + (int)(floor(log2(max(width, height))));
}

inline void DDS_InvertTexel(unsigned char* tex, int format){
	unsigned char tmp0, tmp1, tmp2, tmp3;
	int offset;
	
	if (format == GL_COMPRESSED_RGB_S3TC_DXT1_EXT) offset = 4;
	if (format == GL_COMPRESSED_RGBA_S3TC_DXT3_EXT) offset = 12;
	if (format == GL_COMPRESSED_RGBA_S3TC_DXT5_EXT) offset = 12;
	tmp0 = tex[offset];
	tmp1 = tex[offset+1];
	tmp2 = tex[offset+2];
	tmp3 = tex[offset+3];
	tex[offset] = (tmp3 & 3 << 6) | (tmp3 & 12 << 2) | (tmp3 & 48 >> 2) | (tmp3 & 192 >> 6);
	tex[offset+1] = (tmp2 & 3 << 6) | (tmp2 & 12 << 2) | (tmp2 & 48 >> 2) | (tmp2 & 192 >> 6);
	tex[offset+2] = (tmp1 & 3 << 6) | (tmp1 & 12 << 2) | (tmp1 & 48 >> 2) | (tmp1 & 192 >> 6);
	tex[offset+3] = (tmp0 & 3 << 6) | (tmp0 & 12 << 2) | (tmp0 & 48 >> 2) | (tmp0 & 192 >> 6);
}

void DirectDrawSurface::CopyRect(unsigned char* src,unsigned int srcW,unsigned int srcH,unsigned int srcX,unsigned int srcY,unsigned char* dst,unsigned int dstW,unsigned int dstH,unsigned int bPP,int invert,int format){
	unsigned char* tex;
	unsigned int x,y;
	unsigned int srcX4 = srcX/4;
	unsigned int srcY4 = srcY/4;
	unsigned int srcW4 = srcW/4;
	unsigned int srcH4 = srcH/4;
	unsigned int dstW4 = dstW/4;
	unsigned int dstH4 = dstH/4;
	unsigned int bPT = 16;
	
	if (format == GL_COMPRESSED_RGB_S3TC_DXT1_EXT) bPT = 8;
	if (format == GL_COMPRESSED_RGB_S3TC_DXT1_EXT || format == GL_COMPRESSED_RGBA_S3TC_DXT3_EXT || format == GL_COMPRESSED_RGBA_S3TC_DXT5_EXT){
		if (invert != 0){
			for (y = 0; y < dstH4; y++){
				memcpy(dst + y * dstW4 * bPT, src + (((dstH4 - 1 - y) + srcY4) * srcW4 + srcX4) * bPT, dstW4 * bPT);
				for (x = 0; x < dstW4 * bPT; x+=bPT){
					tex = dst + (y * dstW4 * bPT) + x;
					DDS_InvertTexel(tex, format);
				}
			}
		}else{
			for (y = 0; y < dstH4; y++){
				memcpy(dst + y * dstW4 * bPT, src + ((y + srcY4) * srcW4 + srcX4) * bPT, dstW4 * bPT);
			}
		}
	}else{ // uncompressed dds or not dds
		if (invert != 0){
			for (y = 0; y < dstH; y++){
				memcpy(dst + y * dstW * bPP, src + (((dstH - 1 - y) + srcY) * srcW + srcX) * bPP, dstW * bPP);
			}
		}else{
			for (y = 0; y < dstH; y++){
				memcpy(dst + y * dstW * bPP, src + ((y + srcY) * srcW + srcX) * bPP, dstW * bPP);
			}
		}
	}
}

DirectDrawSurface::DirectDrawSurface()
:buffer(NULL)
,mipmaps()
,width(0)
,height(0)
,depth(0)
,mipmapcount(0)
,pitch(0)
,size(0)
,dxt(NULL)
,format(0)
,components(0)
,target(0){
}

void DirectDrawSurface::FreeDirectDrawSurface(int free_buffer){
	if(free_buffer!=0) delete[] buffer;
	// If we're using for GetDirectDrawSurfacePtr (?)
	mipmaps.clear();
	width=0;
	height=0;
	depth=0;
	mipmapcount=0;
	pitch=0;
	size=0;
	dxt=NULL;
	format=0;
	components=0;
	target=0;

	delete this;
}

bool DirectDrawSurface::IsCompressed(){
	if(format==GL_COMPRESSED_RGB_S3TC_DXT1_EXT || format==GL_COMPRESSED_RGBA_S3TC_DXT3_EXT || format==GL_COMPRESSED_RGBA_S3TC_DXT5_EXT)
		return true;
	return false;
}

void DirectDrawSurface::Flip(){
	int linesize;
	int offset;

	if(!IsCompressed()){
		unsigned int imagesize=size/depth;
		linesize=imagesize/height;

		for(int n=0; n<depth; n++){
			offset=imagesize*n;
			
			unsigned char *t=dxt+offset;
			unsigned char *b=t+(imagesize-linesize);

			for(int i=0; i<(height>>1); i++){
				DXT_SwapPointer(t,b,linesize);

				t+=linesize;
				b-=linesize;
			}
		}
	}else{
		FlipDXT flipblocks;

		unsigned int xblocks=width/4;
		unsigned int yblocks=height/4;
		unsigned int blocksize;

		switch(format){
		case GL_COMPRESSED_RGB_S3TC_DXT1_EXT:
			blocksize=8;
			flipblocks=DXT_FlipBlocksDXTC1;
			break;
		case GL_COMPRESSED_RGBA_S3TC_DXT3_EXT:
			blocksize=16;
			flipblocks=DXT_FlipBlocksDXTC3;
			break;
		case GL_COMPRESSED_RGBA_S3TC_DXT5_EXT:
			blocksize=16;
			flipblocks=DXT_FlipBlocksDXTC5;
			break;
		default:
			return;
		}

		linesize=xblocks*blocksize;

		DXTColorBlock *t;
		DXTColorBlock *b;

		for(unsigned int j=0; j<(yblocks>>1); j++){
			t=(DXTColorBlock*)((unsigned char*)dxt+(j*linesize));
			b=(DXTColorBlock*)((unsigned char*)dxt+(((yblocks-j)-1)*linesize));

			flipblocks(t,xblocks);
			flipblocks(b,xblocks);

			DXT_SwapPointer(t,b,linesize);
		}
	}
}

void DirectDrawSurface::TextureParameters( int tex_flags ){
	// mipmapping texture flag
	if(tex_flags&8){
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
	}else{
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_NEAREST); //GL_LINEAR
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_NEAREST); //GL_LINEAR
	}
	
	// clamp u flag
	if(tex_flags&16){
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
	}else{
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
	}	
	
	// clamp v flag
	if(tex_flags&32){
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
	}else{
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
	}
}

/*void DirectDrawSurface::UploadTexture(Texture *tex){
	tex->format=format;
	tex->width=width;
	tex->height=height;
	if(target==GL_TEXTURE_CUBE_MAP){
		UploadTextureCubeMap();
		tex->flags|=128;
	} else 
		UploadTexture2D(tex->flags&8);
}*/

void DirectDrawSurface::UploadTexture2D( int mipmap_flag ){
	int row, mmc = mipmapcount;
	
	if (mipmapcount > CountMipmaps(width, height)) mmc = CountMipmaps(width, height); // fix if too many mipmaps
	
	if(IsCompressed()){
		row = DDS_GetPitch(width, format, 0);
		glPixelStorei(GL_UNPACK_ROW_LENGTH, row);
		glCompressedTexImage2D(GL_TEXTURE_2D, 0, format, width, height, 0, size, dxt);
		
		for(int i=0; i<mmc; i++){
			DirectDrawSurface& mip=mipmaps[i];
			if (mip.width == 0 || mip.height == 0 || mipmap_flag == 0) break;
			row = DDS_GetPitch(mip.width, format, 0);
			glPixelStorei(GL_UNPACK_ROW_LENGTH, row);
			glCompressedTexImage2D(GL_TEXTURE_2D, i+1, format, mip.width, mip.height, 0, mip.size, mip.dxt);
		}
	} else {
		glPixelStorei(GL_UNPACK_ALIGNMENT, components);
		row = DDS_GetPitch(width, format, components);
		glPixelStorei(GL_UNPACK_ROW_LENGTH, row / components);
		glTexImage2D(GL_TEXTURE_2D, 0, components, width, height, 0, format, GL_UNSIGNED_BYTE, dxt);
		
		for(int i=0; i<mmc; i++){
			DirectDrawSurface& mip=mipmaps[i];
			if (mip.width == 0 || mip.height == 0 || mipmap_flag == 0) break;
			row = DDS_GetPitch(mip.width, format, components);
			glPixelStorei(GL_UNPACK_ROW_LENGTH, row / components);
			glTexImage2D(GL_TEXTURE_2D, i+1, components, mip.width, mip.height, 0, format, GL_UNSIGNED_BYTE, mip.dxt);
		}
	}
	glPixelStorei(GL_UNPACK_ROW_LENGTH, 0);
}

void DirectDrawSurface::UploadTextureSubImage2D( int ix, int iy, int iwidth, int iheight, unsigned char* pixels, int mipmap_flag, int target, int inv ){

		int mwidth, mheight, row, height4, mmc = mipmapcount;
		
		if (mipmapcount > CountMipmaps(iwidth, iheight)) mmc = CountMipmaps(iwidth, iheight); // fix if too many mipmaps (anim strip)

		if (IsCompressed()){
			if (iheight > 4) height4 = iheight/4; else height4 = 1;
			row = DDS_GetPitch(iwidth, format, 0);
			glPixelStorei(GL_UNPACK_ROW_LENGTH, row);
			CopyRect(dxt, width, height, ix, iy, pixels, iwidth, iheight, 0, inv, format);
			glCompressedTexImage2D(target, 0, format, iwidth, iheight, 0, row*height4, pixels);
			
			for(int j=0; j<mmc; j++){
				DirectDrawSurface& mip=mipmaps[j];
				int pow2 = pow(2, j+1); // 2/4/8
				mwidth = iwidth / pow2; mheight = iheight / pow2;
				if (mheight > 4) height4 = mheight/4; else height4 = 1;
				if (mwidth == 0 || mheight == 0 || mipmap_flag == 0) break;
				row = DDS_GetPitch(mwidth, format, 0);
				glPixelStorei(GL_UNPACK_ROW_LENGTH, row);
				CopyRect(mip.dxt, mip.width, mip.height, ix/pow2, iy/pow2, pixels, mwidth, mheight, 0, inv, format);
				glCompressedTexImage2D(target, j+1, format, mwidth, mheight, 0, row*height4, pixels);
			}
		}else{
			glPixelStorei(GL_UNPACK_ALIGNMENT, components);
			row = DDS_GetPitch(iwidth, format, components);
			glPixelStorei(GL_UNPACK_ROW_LENGTH, row / components);
			CopyRect(dxt, width, height, ix, iy, pixels, iwidth, iheight, components, inv, format);
			glTexImage2D(target, 0, components, iwidth, iheight, 0, format, GL_UNSIGNED_BYTE, pixels);
			
			for(int j=0; j<mmc; j++){
				DirectDrawSurface& mip=mipmaps[j];
				int pow2 = pow(2, j+1); // 2/4/8
				mwidth = iwidth / pow2; mheight = iheight / pow2;
				if (mwidth == 0 || mheight == 0 || mipmap_flag == 0) break;
				row = DDS_GetPitch(mwidth, format, components);
				glPixelStorei(GL_UNPACK_ROW_LENGTH, row / components);
				CopyRect(mip.dxt, mip.width, mip.height, ix/pow2, iy/pow2, pixels, mwidth, mheight, components, inv, format);
				glTexImage2D(target, j+1, components, mwidth, mheight, 0, format, GL_UNSIGNED_BYTE, pixels);
			}
		}
		
		glPixelStorei(GL_UNPACK_ROW_LENGTH, 0);
}

void DirectDrawSurface::UploadTextureCubeMap(){ // not tested (DDS cubemap-in-mipmaps format)
	DirectDrawSurface *s;
	unsigned int t=0;

	for(int i=0; i<6; i++){
		t=GL_TEXTURE_CUBE_MAP_POSITIVE_X+i;
		s=&mipmaps[i];

		if(IsCompressed()){
			glCompressedTexImage2D(t,0,format,s->width,s->height,0,s->size,s->dxt);
			for(int i=0; i<s->mipmapcount; i++){
				DirectDrawSurface& mip=s->mipmaps[i];
				glCompressedTexImage2D(t,i+1,format,mip.width,mip.height,0,mip.size,mip.dxt);
			}
		} else {
			glTexImage2D(t,0,components,s->width,s->height,0,format,GL_UNSIGNED_BYTE,s->dxt);
			for(int i=0; i<s->mipmapcount; i++){
				DirectDrawSurface& mip=s->mipmaps[i];
				glTexImage2D(t,i+1,components,mip.width,mip.height,0,format,GL_UNSIGNED_BYTE,mip.dxt);
			}
		}
	}
}
