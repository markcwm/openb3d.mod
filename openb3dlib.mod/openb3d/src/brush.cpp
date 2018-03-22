/*
 *  brush.mm
 *  iminib3d
 *
 *  Created by Si Design.
 *  Copyright Simon Harrison. All rights reserved.
 *
 */

#include "brush.h"
#include <string.h>

Brush* Brush::Copy(){

	Brush* brush=new Brush();

	brush->no_texs=no_texs;
	brush->name=name;
	brush->red=red;
	brush->green=green;
	brush->blue=blue;
	brush->alpha=alpha;
	brush->shine=shine;
	brush->blend=blend;
	brush->fx=fx;
	brush->cache_frame[0]=cache_frame[0];
	brush->cache_frame[1]=cache_frame[1];
	brush->cache_frame[2]=cache_frame[2];
	brush->cache_frame[3]=cache_frame[3];
	brush->cache_frame[4]=cache_frame[4];
	brush->cache_frame[5]=cache_frame[5];
	brush->cache_frame[6]=cache_frame[6];
	brush->cache_frame[7]=cache_frame[7];
	brush->tex[0]=tex[0];
	brush->tex[1]=tex[1];
	brush->tex[2]=tex[2];
	brush->tex[3]=tex[3];
	brush->tex[4]=tex[4];
	brush->tex[5]=tex[5];
	brush->tex[6]=tex[6];
	brush->tex[7]=tex[7];

	return brush;

}

void Brush::FreeBrush(){

	delete this;

}

Brush* Brush::CreateBrush(float r,float g,float b){

	Brush* brush=new Brush();
	brush->red  = r/255.0;
	brush->green= g/255.0;
	brush->blue = b/255.0;

	return brush;

}

Brush* Brush::LoadBrush(string file,int flags,float u_scale,float v_scale){

	Brush* brush=new Brush();
	brush->tex[0]=Texture::LoadTexture(file,flags);
	brush->cache_frame[0]=brush->tex[0]->texture;
	brush->no_texs=1;
	brush->tex[0]->u_scale=u_scale;
	brush->tex[0]->v_scale=v_scale;

	return brush;

}

void Brush::BrushColor(float r,float g,float b){
	red   = r/255.0;
	green = g/255.0;
	blue  = b/255.0;
}

void Brush::BrushAlpha(float a){
	alpha = a;
}

void Brush::BrushShininess(float s){
	shine = s;
}

void Brush::BrushTexture(Texture* texture, int frame, int index){
	tex[index]=texture;
	cache_frame[index]=texture->texture;

	if((index+1)>no_texs)
	  no_texs=index+1;

	if (texture->no_frames>2){
		if(frame<0)
		  frame=0;

		if(frame>texture->no_frames-1)
		  frame=texture->no_frames-1;

		cache_frame[index]=texture->frames[frame];
    // brush.tex[index]=texture;

	}
	// if(frame<0) frame=0;
	// if(frame>texture->no_frames-1) frame=texture->no_frames-1;
	// tex_frame=frame;

}

void Brush::BrushBlend(int blend_no){
	blend = blend_no;
}

void Brush::BrushFX(int fx_no){
	fx = fx_no;
}

void Brush::NameBrush(string b_name){
	name=b_name;
}

/* moved to entity.mm to avoid dependency issues
Brush* Brush::GetEntityBrush(Entity* ent){
	return ent->brush->Copy();
}
*/

/* moved to surface.mm to avoid dependency issues
Brush* GetSurfaceBrush(Surface* surf){
	return surf->brush->Copy();
}
*/

// moved from texture.mm
Texture* Brush::GetBrushTexture(int index){
	return tex[index];
}

int Brush::CompareBrushes(Brush* brush1,Brush* brush2){

	// returns true if specified brush1 has same properties as brush2

	if(brush1==NULL && brush2!=NULL) return false;
	if(brush1!=NULL && brush2==NULL) return false;
	if(brush1!=NULL && brush2!=NULL){
		if(brush1->no_texs!=brush2->no_texs) return false;
		if(brush1->red!=brush2->red) return false;
		if(brush1->green!=brush2->green) return false;
		if(brush1->blue!=brush2->blue) return false;
		if(brush1->alpha!=brush2->alpha) return false;
		if(brush1->shine!=brush2->shine) return false;
		if(brush1->blend!=brush2->blend) return false;
		if(brush1->fx!=brush2->fx) return false;
		for(int i=0;i<=7;i++){
			if(brush1->tex[i]==NULL && brush2->tex[i]!=NULL) return false;
			if(brush1->tex[i]!=NULL && brush2->tex[i]==NULL) return false;
			if(brush1->tex[i]!=NULL && brush2->tex[i]!=NULL){
				if(brush1->tex[i]->texture!=brush2->tex[i]->texture) return false;
				if(brush1->tex[i]->blend!=brush2->tex[i]->blend) return false;
				if(brush1->tex[i]->coords!=brush2->tex[i]->coords) return false;
			}
		}
	}

	return true;

}
