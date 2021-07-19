#ifndef BRUSH_H
#define BRUSH_H

/*
 *  brush.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */


#include "texture.h"

#include <string>
#include <iostream>

using namespace std;

class Brush{

public:
	static list<Brush*> brush_list;

	int no_texs;
	string name;
	float red,green,blue,alpha;
	float shine;
	int blend,fx;
	unsigned int cache_frame[8];
	Texture* tex[8];

	// extra
	int glBlendFunc[2];
	
	Brush(){

		no_texs=0;
		name="";

		red=1.0,green=1.0,blue=1.0,alpha=1.0,shine=0.0;
		blend=0,fx=0;
		//tex_frame=0;

		for(int i=0;i<8;i++){
			tex[i]=NULL;
			cache_frame[i]=0;
		}

	};

	Brush* Copy();
	void FreeBrush();
	static Brush* CreateBrush(float r=255.0,float g=255.0,float b=255.0);
	static Brush* LoadBrush(string file,int flags=1,float u_scale=1.0,float v_scale=1.0);
	void BrushColor(float r,float g,float b);
	void BrushAlpha(float a);
	void BrushShininess(float s);
	void BrushTexture(Texture* texture,int frame=0,int index=0);
	void BrushBlend(int blend_no);
	void BrushFX(int fx_no);
	//static Brush* GetEntityBrush(Entity* ent); // moved to entity.mm to avoid dependency isssues
	//static Brush* GetSurfaceBrush(Surface* surf); // move to surface.mm to avoid dependency isssues
	Texture* GetBrushTexture(int index=0);
	static int CompareBrushes(Brush* brush1,Brush* brush2);

};

#endif
