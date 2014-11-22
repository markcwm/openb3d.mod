/*
 *  sprite.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef SPRITE_H
#define SPRITE_H

#include "mesh.h"

#include <iostream>
using namespace std;

class Sprite : public Mesh{

public:

	float angle;
	float scale_x,scale_y;
	float handle_x,handle_y; 
	int view_mode;
	int render_mode;

	Sprite* CopyEntity(Entity* parent_ent=NULL);
	static Sprite* CreateSprite(Entity* parent_ent=NULL);
	static Sprite* LoadSprite(string tex_file,int tex_flag=1,Entity* parent_ent=NULL);
	void RotateSprite(float ang);	
	void ScaleSprite(float s_x,float s_y);
	void HandleSprite(float h_x,float h_y);
	void SpriteViewMode(int mode);
	void SpriteRenderMode(int mode);
	void SpriteTexCoords(int cell_x,int cell_y,int cell_w,int cell_h,int tex_w,int tex_h,int uv_set=0);
	void SpriteVertexColor(int v,float r,float g,float b);
	
	Sprite(){
	
		angle=0.0;
		scale_x=scale_y=1.0;
		handle_x=handle_y=0.0;
		view_mode=1;
		render_mode=1;
	
	}

	void FreeEntity(void);

};

#endif
