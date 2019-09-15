/*
 *  texture.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "glew_glee.h" // glee or glew

#include "texture.h"
#include "stb_image.h"

#include "texture_filter.h"
#include "string_helper.h"
#include "file.h"
#include "global.h"
#include "shadow.h"
#include "dds.h"

#include <stdio.h>
#include <string.h>
#include <math.h>

list<Texture*> Texture::tex_list;
list<Texture*> Texture::tex_list_all;
int Texture::isunique=0;
int Texture::AnIsoSupport=0;

void CopyPixels(unsigned char *src,unsigned int srcW,unsigned int srcH,unsigned int srcX,unsigned int srcY, unsigned char *dst,unsigned int dstW,unsigned int dstH,unsigned int bPP,int invert);
void ApplyAlpha(Texture* tex, unsigned char *src);
void ApplyMask(Texture* tex, unsigned char *src, unsigned char maskred, unsigned char maskgrn, unsigned char maskblu);
int CheckAlpha(Texture* tex, unsigned char *src);

Texture* Texture::Copy(int copyflags){
	Texture *tex=new Texture();
	
	tex->file=file;
	tex->blend=blend;
	tex->coords=coords;
	tex->u_scale=u_scale;
	tex->v_scale=v_scale;
	tex->u_pos=u_pos;
	tex->v_pos=v_pos;
	tex->angle=angle;
	tex->file_abs=file_abs;
	
	if (copyflags) flags=copyflags; // use new flags instead of the original ones
	
	Texture::isunique=true;
	if(no_frames<2){
		Texture::LoadTexture(file,flags,tex);
	}else{
		Texture::LoadAnimTexture(file,flags,width,height,0,no_frames,tex);
	}
	Texture::isunique=false;
	return tex;
}

Texture* Texture::LoadTexture(string filename,int flags,Texture* tex){
	filename=File::ResourceFilePath(filename);
	if(filename.empty()) return NULL;
	
	return Texture::LoadAnimTexture(filename,flags,0,0,0,1,tex);
}

Texture* Texture::LoadAnimTexture(string filename,int flags, int frame_width,int frame_height,int first_frame,int frame_count,Texture* tex){

	if (flags&128) return Texture::LoadCubemapTexture(filename,flags,frame_width,frame_height,first_frame,frame_count,tex);
	
	//filename=Strip(filename); // get rid of path info
	filename=File::ResourceFilePath(filename);

	/*if (filename==""){
		cout << "Error: Can't Find Texture: " << filename << endl;
		return NULL;
	}*/

	if(tex==NULL) tex=new Texture();
	tex->file=filename;

	// set tex.flags before TexInList
	tex->flags=flags;
	tex->FilterFlags();

	// check to see if texture with same properties exists already, if so return existing texture
	Texture* old_tex=tex->TexInList(tex_list);
	if(old_tex!=NULL && Texture::isunique==false){
		delete tex;
		tex_list_all.push_back(old_tex);
		return old_tex;
	}else{
		tex_list_all.push_back(tex);
		tex_list.push_back(tex);
	}

	string filename_left=Left(filename,Len(filename)-4);
	string filename_right=Right(filename,3);

	//const char* c_filename_left=filename_left.c_str();
	//const char* c_filename_right=filename_right.c_str();

	unsigned char* buffer;
	DirectDrawSurface *dds;
	bool dds_ext=false;
	if (Right(filename,4)==".dds" || Right(filename,4)==".DDS"){
		dds=DirectDrawSurface::LoadSurface(filename,false,NULL,0);
		if (!dds){
			cout << "Error: Can't Load File '"+filename+"'" << endl;
			return NULL;
		}
		dds_ext=true;
		
		tex->width=dds->width;
		tex->height=dds->height;
		
		if(!dds->IsCompressed()){
			if(flags&2) ApplyAlpha(tex,dds->buffer);
			
			if(flags&4) ApplyMask(tex,dds->buffer,0,0,0);
		}
	}else{
		buffer=stbi_load(filename.c_str(),&tex->width,&tex->height,0,4);
		if (!buffer){
			cout << "Error: Can't Load File '"+filename+"'" << endl;
			return NULL;
		}
		
		//int mask=CheckAlpha(tex,buffer); // assimp hack to determine tex flags, if mask=4 image has no alpha values
		
		if(flags&2) ApplyAlpha(tex,buffer);
		
		if(flags&4) ApplyMask(tex,buffer,0,0,0);
	}

	unsigned int name;
	if (frame_count<2 || (frame_width==0 && frame_height==0)){
		if (dds_ext){
			glGenTextures (1,&name);
			glBindTexture (dds->target,name);
			dds->TextureParameters(tex->flags);
			
			if(dds->target==GL_TEXTURE_CUBE_MAP){
				dds->UploadTextureCubeMap();
				tex->flags|=128;
			}else
				dds->UploadTexture2D(tex->flags&8);
		}else{
			glGenTextures (1,&name);
			glBindTexture (GL_TEXTURE_2D,name);
#ifndef GLES2
			//glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, tex->width, tex->height, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA,tex->width, tex->height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
#else
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, tex->width, tex->height, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			glGenerateMipmap(GL_TEXTURE_2D);
#endif
		}

		tex->texture=name;
	} else {

		tex->no_frames=frame_count;
		tex->frames=new unsigned int[frame_count];

		unsigned char* dstbuffer=new unsigned char[frame_width*frame_height*4];

		//tex.gltex=tex.gltex[..tex.no_frames]

		int xframes=tex->width/frame_width; // fixes not loading yframes/columns
		int yframes=tex->height/frame_height;
		int x=first_frame % xframes;
		int y=(first_frame/xframes) % yframes;
		
		for (int i=0;i<frame_count;i++){
			if (dds_ext){
				glGenTextures (1,&name);
				glBindTexture (GL_TEXTURE_2D,name);
				
				dds->TextureParameters(tex->flags);
				dds->UploadTextureSubImage2D(x*frame_width, y*frame_height, frame_width, frame_height, dstbuffer, tex->flags&8, GL_TEXTURE_2D, 0);
			}else{
				CopyPixels(buffer,tex->width, tex->height, x*frame_width, y*frame_height, dstbuffer, frame_width, frame_height, 4, 0);
				
				glGenTextures (1,&name);
				glBindTexture (GL_TEXTURE_2D,name);
#ifndef GLES2
				gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA,frame_width, frame_height, GL_RGBA, GL_UNSIGNED_BYTE, dstbuffer);
#else
				glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, frame_width, frame_height, 0, GL_RGBA, GL_UNSIGNED_BYTE, dstbuffer);
				glGenerateMipmap(GL_TEXTURE_2D);
#endif
			}
			
			x=x+1; // left-right frames
			if (x>=xframes){ // top-bottom frames
				x=0;
				y=y+1;
			}
			
			tex->frames[i]=name;
		}
		
		tex->texture=tex->frames[0];
		tex->width=frame_width;
		tex->height=frame_height;
		delete[] dstbuffer;
	}
	
	if (dds_ext){
		tex->format=dds->format;
		dds->FreeDirectDrawSurface(true);
	}else{
		stbi_image_free(buffer);
	}
	
	return tex;

}

Texture* Texture::LoadCubemapTexture(string filename,int flags, int frame_width,int frame_height,int first_frame,int frame_count,Texture* tex){

		//filename=Strip(filename); // get rid of path info
		filename=File::ResourceFilePath(filename);

		/*if (filename==""){
			cout << "Error: Cannot Find Texture: " << filename << endl;
			return NULL;
		}*/

		if(tex==NULL) tex=new Texture();
		tex->file=filename;

		// set tex.flags before TexInList
		tex->flags=flags;
		tex->FilterFlags();

		// check to see if texture with same properties exists already, if so return existing texture
		Texture* old_tex=tex->TexInList(tex_list);
		if(old_tex!=NULL && Texture::isunique==false){
			delete tex;
			tex_list_all.push_back(old_tex);
			return old_tex;
		}else{
			tex_list_all.push_back(tex);
			tex_list.push_back(tex);
		}

		string filename_left=Left(filename,Len(filename)-4);
		string filename_right=Right(filename,3);
		//const char* c_filename_left=filename_left.c_str();
		//const char* c_filename_right=filename_right.c_str();
		
		unsigned char* buffer;
		DirectDrawSurface *dds;
		bool dds_ext=false;
		if (Right(filename,4)==".dds" || Right(filename,4)==".DDS"){
			dds=DirectDrawSurface::LoadSurface(filename,false,NULL,0);
			if (!dds){
				cout << "Error: Can't Load File '"+filename+"'" << endl;
				return NULL;
			}
			dds_ext=true;
			
			tex->width=dds->width;
			tex->height=dds->height;
			
			if(!dds->IsCompressed()){
				if(flags&2) ApplyAlpha(tex,dds->buffer);
				
				if(flags&4) ApplyMask(tex,dds->buffer,0,0,0);
			}
		}else{
			buffer=stbi_load(filename.c_str(),&tex->width,&tex->height,0,4);
			if (!buffer){
				cout << "Error: Can't Load File '"+filename+"'" << endl;
				return NULL;
			}
			
			//int mask=CheckAlpha(tex,buffer); // assimp hack to determine tex flags, if mask=4 image has no alpha values
			
			if(flags&2) ApplyAlpha(tex,buffer);
			
			if(flags&4) ApplyMask(tex,buffer,0,0,0);
		}
		
		unsigned int name;
		tex->no_frames=1;
		tex->frames=new unsigned int[6];

		unsigned char* dstbuffer=new unsigned char[frame_width*frame_height*4];
		glGenTextures (1,&name);
		glBindTexture (GL_TEXTURE_CUBE_MAP,name);

		int xframes=tex->width/frame_width; // fixes not loading yframes/columns
		int yframes=tex->height/frame_height;
		int x,y,cubeid;
		
		//tex.gltex=tex.gltex[..tex.no_frames]
		for (int i=0;i<6;i++){
			cubeid=Global::cubemap_frame[i];
			x=cubeid % xframes; // left-right frames
			y=(cubeid/xframes) % yframes; // top-bottom frames
			
			if (dds_ext){
				dds->TextureParameters(tex->flags);
				dds->UploadTextureSubImage2D(frame_width*x, frame_height*y, frame_width, frame_height, dstbuffer, tex->flags&8, Global::cubemap_face[i], Global::flip_cubemap);
			}else{
				CopyPixels(buffer, tex->width, tex->height, frame_width*x, frame_height*y, dstbuffer, frame_width, frame_height, 4, Global::flip_cubemap);
#ifndef GLES2
				gluBuild2DMipmaps(Global::cubemap_face[i], GL_RGBA, frame_width, frame_height, GL_RGBA, GL_UNSIGNED_BYTE, dstbuffer);
#else
				glTexImage2D(Global::cubemap_face[i], 0, GL_RGBA, frame_width, frame_height, 0, GL_RGBA, GL_UNSIGNED_BYTE, dstbuffer);
				glGenerateMipmap(GL_TEXTURE_CUBE_MAP);
#endif
			}
		}

		tex->texture=name;
		delete[] dstbuffer;
		
		if (dds_ext){
			tex->format=dds->format;
			dds->FreeDirectDrawSurface(true);
		}else{
			stbi_image_free(buffer);
		}
		
		return tex;
}

Texture* Texture::CreateTexture(int width,int height,int flags, int frames){

	Texture* tex=new Texture();

	tex->flags=flags;
	tex->FilterFlags();
	tex->width=width;
	tex->height=height;

	unsigned int name;
	glGenTextures (1,&name);
	tex->texture=name;


	return tex;

}

Texture* Texture::NewTexture(){
	Texture* tex=new Texture();
	return tex;
}

void Texture::FreeTexture(){
	tex_list_all.remove(this); // remove before checking
	
	Texture* tex_all=this->TexInList(tex_list_all);
	Texture* tex=this->TexInList(tex_list);
	
	if(tex!=NULL && tex_all==NULL){ // tex is unique
		glDeleteTextures(1, &texture); // delete if no other refs
		
		tex_list.remove(this);
		delete this;
	}
}

void Texture::DrawTexture(int x,int y){
  //	[texture drawAtPoint:CGPointMake(x,y)];
}

void Texture::TextureBlend(int blend_no){
	blend=blend_no;
}

void Texture::TextureCoords(int coords_no){
	coords=coords_no;
}

void Texture::ScaleTexture(float u_s,float v_s){
	u_scale=1.0/u_s;
	v_scale=1.0/v_s;
}

void Texture::PositionTexture(float u_p,float v_p){
	u_pos=-u_p;
	v_pos=-v_p;
}

void Texture::RotateTexture(float ang){
	angle=ang;
}

/*
Method TextureWidth()

	Return width

End Method

Method TextureHeight()

	Return height

End Method
*/

string Texture::TextureName(){
	return file;
}

void Texture::ClearTextureFilters(){
	TextureFilter::tex_filter_list.clear();
}

void Texture::AddTextureFilter(string text_match,int flags){
	TextureFilter* filter=new TextureFilter();
	filter->text_match=text_match;
	filter->flags=flags;
	TextureFilter::tex_filter_list.push_back(filter);
}

Texture* Texture::TexInList(list<Texture*>& list_ref){
	// check if tex already exists in list and if so return it
	list<Texture*>::iterator it;
	for(it=list_ref.begin();it!=list_ref.end();it++){
		Texture* tex=*it;
		if(file==tex->file && flags==tex->flags && blend==tex->blend){
			//if(u_scale==tex->u_scale && v_scale==tex->v_scale && u_pos==tex->u_pos && v_pos==tex->v_pos && angle==tex->angle){
				return tex;
			//}
		}
	}
	return NULL;
}

void Texture::FilterFlags(){
	// combine specifieds flag with texture filter flags
	list<TextureFilter*>::iterator it;
	for(it=TextureFilter::tex_filter_list.begin();it!=TextureFilter::tex_filter_list.end();it++){
		TextureFilter* filter=*it;
		if(Instr(file,filter->text_match)) flags=flags|filter->flags;
	}
}

// used in LoadTexture, strips path info from filename
/*string Texture::Strip(string filename){
	string stripped_filename=filename;
	string::size_type idx;

	idx=filename.find('/');
	if(idx!=string::npos){
		stripped_filename=filename.substr(filename.rfind('/')+1);
	}

	idx=filename.find("\\");
	if(idx!=string::npos){
		stripped_filename=filename.substr(filename.rfind("\\")+1);
	}

	return stripped_filename;

}*/

void Texture::BufferToTex(unsigned char* buffer, int frame){
	if(flags&128){
		glBindTexture (GL_TEXTURE_CUBE_MAP,texture);
#ifndef GLES2
		switch (cube_face){
		case 0:
			gluBuild2DMipmaps(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, GL_RGBA,width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			break;
		case 1:
			gluBuild2DMipmaps(GL_TEXTURE_CUBE_MAP_POSITIVE_Z, GL_RGBA,width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			break;
		case 2:
			gluBuild2DMipmaps(GL_TEXTURE_CUBE_MAP_POSITIVE_X, GL_RGBA,width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			break;
		case 3:
			gluBuild2DMipmaps(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, GL_RGBA,width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			break;
		case 4:
			gluBuild2DMipmaps(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, GL_RGBA,width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			break;
		case 5:
			gluBuild2DMipmaps(GL_TEXTURE_CUBE_MAP_POSITIVE_Y, GL_RGBA,width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			break;
		}
#else
		switch(cube_face){
		case 0:
			glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			break;
		case 1:
			glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			break;
		case 2:
			glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			break;
		case 3:
			glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			break;
		case 4:
			glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			break;
		case 5:
			glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
			break;
		}
		glGenerateMipmap(GL_TEXTURE_CUBE_MAP);

#endif
	}else{
		glBindTexture (GL_TEXTURE_2D,texture);
#ifndef GLES2
		gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA,width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
#else
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
		glGenerateMipmap(GL_TEXTURE_2D);
#endif
	}

}

void Texture::BackBufferToTex(int frame){
	if(flags&128){
		glBindTexture (GL_TEXTURE_CUBE_MAP,texture);
		switch (cube_face){
		case 0:
			glCopyTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X,0,GL_RGBA,0,Global::height-height,width,height,0);
			break;
		case 1:
			glCopyTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z,0,GL_RGBA,0,Global::height-height,width,height,0);
			break;
		case 2:
			glCopyTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X,0,GL_RGBA,0,Global::height-height,width,height,0);
			break;
		case 3:
			glCopyTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z,0,GL_RGBA,0,Global::height-height,width,height,0);
			break;
		case 4:
			glCopyTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y,0,GL_RGBA,0,Global::height-height,width,height,0);
			break;
		case 5:
			glCopyTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y,0,GL_RGBA,0,Global::height-height,width,height,0);
			break;
		}
#ifndef GLES2
		glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP_SGIS, GL_TRUE);
#else
		glGenerateMipmap(GL_TEXTURE_2D);
#endif
	}else{
		glBindTexture (GL_TEXTURE_2D,texture);
		glCopyTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,0,Global::height-height,width,height,0);
#ifndef GLES2
		glTexParameteri(GL_TEXTURE_2D, GL_GENERATE_MIPMAP_SGIS, GL_TRUE);
#else
		glGenerateMipmap(GL_TEXTURE_2D);
#endif
	}
}

void Texture::CameraToTex(Camera* cam, int frame){

	GLenum target;

	Global::camera_in_use=cam;

	if(flags&128){
		target=GL_TEXTURE_CUBE_MAP;
	}else{
		target=GL_TEXTURE_2D;
	}
	

	glBindTexture (target, texture);

	if (framebuffer==0){
		framebuffer=new unsigned int[2];
		glGenFramebuffers(1, &framebuffer[0]);
		glGenRenderbuffers(1, &framebuffer[1]);
		if(flags&128){
			for (int i=0;i<6;i++){
				switch(i){
					case 0:
						glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
						break;
					case 1:
						glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
						break;
					case 2:
						glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
						break;
					case 3:
						glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
						break;
					case 4:
						glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
						break;
					case 5:
						glTexImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
						break;
				}
			}
		}else{
			glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
		}

	}

	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer[0]);

	if(flags&128){
		switch (cube_face){
		case 0:
			glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_NEGATIVE_X, texture, 0);
			break;
		case 1:
			glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_POSITIVE_Z, texture, 0);
			break;
		case 2:
			glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_POSITIVE_X, texture, 0);
			break;
		case 3:
			glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, texture, 0);
			break;
		case 4:
			glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, texture, 0);
			break;
		case 5:
			glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_CUBE_MAP_POSITIVE_Y, texture, 0);
			break;
		}

	}else{
		glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, texture, 0);
	}

	//Depth buffer
	glBindRenderbuffer(GL_RENDERBUFFER, framebuffer[1]);
	glRenderbufferStorage( GL_RENDERBUFFER, GL_DEPTH_STENCIL, width, height);
#ifndef GLES2
	glFramebufferRenderbuffer( GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, framebuffer[1]); 
	glFramebufferRenderbuffer( GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, framebuffer[1]); 
#else
	glFramebufferRenderbuffer( GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_RENDERBUFFER, framebuffer[1]); 
#endif

	cam->Render();

	if (Global::Shadows_enabled==true)
		ShadowObject::Update(cam);


	glFramebufferRenderbuffer( GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, 0); 

	glGenerateMipmap(target);
	glBindFramebuffer(GL_FRAMEBUFFER, 0);
	glBindRenderbuffer(GL_RENDERBUFFER, 0);


}


void Texture::TexToBuffer(unsigned char* buffer, int frame){
#ifndef GLES2
	glBindTexture (GL_TEXTURE_2D,texture);
	glGetTexImage(GL_TEXTURE_2D, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
#endif
}


void Texture::DepthBufferToTex(Camera* cam=0 ){
	glBindTexture(GL_TEXTURE_2D,texture);
	if (cam==0){
		glCopyTexImage2D(GL_TEXTURE_2D,0,GL_DEPTH_COMPONENT,0,Global::height-height,width,height,0);
#ifndef GLES2
		glTexParameteri(GL_TEXTURE_2D,GL_GENERATE_MIPMAP_SGIS,GL_TRUE);
#endif
	}else{
		Global::camera_in_use=cam;
		if (framebuffer==0){
			framebuffer=new unsigned int[1];
			glGenFramebuffers(1, &framebuffer[0]);
			//glGenRenderbuffers(1, &framebuffer[1]);
			glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT24, width, height, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_BYTE, 0);

			glBindFramebuffer(GL_FRAMEBUFFER, framebuffer[0]);
			glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, texture, 0);
		}else{
			glBindFramebuffer(GL_FRAMEBUFFER, framebuffer[0]);
		}

		glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, texture, 0);
		//glBindRenderbuffer(GL_RENDERBUFFER, framebuffer[1]);

		cam->Render();
		//glFramebufferRenderbuffer( GL_FRAMEBUFFER, GL_STENCIL_ATTACHMENT, GL_RENDERBUFFER, 0); 

		glGenerateMipmap(GL_TEXTURE_2D);
		glBindFramebuffer(GL_FRAMEBUFFER, 0);
		//glBindRenderbuffer(GL_RENDERBUFFER, 0);

	}
}

void CopyPixels(unsigned char *src,unsigned int srcW,unsigned int srcH,unsigned int srcX,unsigned int srcY, unsigned char *dst,unsigned int dstW,unsigned int dstH,unsigned int bPP,int invert) {
	unsigned int y;
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

void ApplyAlpha(Texture* tex, unsigned char *src) {
	unsigned int scanline, scanlength, x, y, bpp = 4;
	unsigned char red, grn, blu;
	
	for (y = 0; y < tex->height; y++) {
		for (x = 0; x < tex->width; x++) {
			scanline = y * bpp * tex->width;
			scanlength = x * bpp;
			red = src[scanline + scanlength];
			grn = src[scanline + scanlength + 1];
			blu = src[scanline + scanlength + 2];
			src[scanline + scanlength + 3] = (red + grn + blu) / 3.0;
		}
	}
}

void ApplyMask(Texture* tex, unsigned char *src, unsigned char maskred, unsigned char maskgrn, unsigned char maskblu) {
	unsigned int scanline, scanlength, x, y, bpp = 4;
	unsigned char red, grn, blu;
	
	for (y = 0; y < tex->height; y++) {
		for (x = 0; x < tex->width; x++) {
			scanline = y * bpp * tex->width;
			scanlength = x * bpp;
			red = src[scanline + scanlength];
			grn = src[scanline + scanlength + 1];
			blu = src[scanline + scanlength + 2];
			if (red == maskred && grn == maskgrn && blu == maskblu){
				src[scanline + scanlength + 3] = 0;
			}
		}
	}
}

// quick test to see if true alpha used in image, if true returns 2 (for tex flags)
int CheckAlpha(Texture* tex, unsigned char *src){
	unsigned int scanline, scanlength, x, y, alp, a0 = 0, a1 = 0, bpp = 4;
	float sqrw = sqrt(tex->width);
	float sqrh = sqrt(tex->height);
	int sizew = tex->width / sqrw;
	int sizeh = tex->height / sqrh;
	
	for (y = 0; y < sizeh; y++){ // check sqrt times pixel columns
		for (x = 0; x < sizew; x++){ // check sqrt times pixel rows
			scanline = sizeh * y * bpp * tex->width;
			scanlength = sizew * x * bpp;
			alp = src[scanline + scanlength + 3];
			if (alp == 0) a0 = a0 + 1;
			if (alp == 255) a1 = a1 + 1;
		}
	}
	
	if (a0 == sizew * sizeh || a1 == sizew * sizeh) return 4; // mask flag, no alpha values
	return 2; // alpha flag
}

void Texture::TextureMultitex(float f){
	multitex_factor = f;
}

void Texture::TextureAnIsotropic(float f){
	max_anisotropic = f;
}
