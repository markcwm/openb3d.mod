
#include <stdlib.h> 
#include "stdio.h"
#include "glew_glee.h" // glee or glew


#include "camera.h"
#include "particle.h"
#include "surface.h"
#include "pick.h"

list<ParticleBatch*> ParticleBatch::particle_batch_list;
list<ParticleEmitter*> ParticleEmitter::emitter_list;

ParticleBatch* ParticleBatch::GetParticleBatch(Texture* tex,int blend,int order){

		ParticleBatch* particle_batch=NULL;
	
		// check if particle batch already exists for specified texture, if so return it
		list<ParticleBatch*>::iterator it;
		for(it=particle_batch_list.begin();it!=particle_batch_list.end();it++){
			particle_batch=*it;
			if(particle_batch->brush.tex[0]==tex && particle_batch->brush.blend==blend && particle_batch->order==order){
				return particle_batch;		//*particle_batch->surf_list.begin();
			}
		}
		
		// if no particle batch surface exists, create new particle batch with new surface
		particle_batch=new ParticleBatch;
		Surface* surf=new Surface;
		surf->vbo_enabled=false;
		surf->ShaderMat=Global::ambient_shader;
		particle_batch->surf_list.push_back(surf);
		particle_batch->hide=false;
		entity_list.push_back(particle_batch);
		Global::root_ent->child_list.push_back(particle_batch);


		particle_batch->brush.tex[0]=tex;
		particle_batch->brush.blend=blend;
		particle_batch->order=order;
		particle_batch_list.push_back(particle_batch);
		return particle_batch;

}

void ParticleBatch::Render(){
	int depth_mask_disabled=false;

	Surface* surf=*surf_list.begin();

#ifndef GLES2
	glDisable(GL_ALPHA_TEST); // ?

	if(Global::fx1!=true){
		Global::fx1=true;
		//glDisableClientState(GL_NORMAL_ARRAY);
	}

	if(Global::fx2!=true){
		Global::fx2=true;
		glEnableClientState(GL_COLOR_ARRAY);
		glEnable(GL_COLOR_MATERIAL);
	}

	if(surf->alpha_enable==true){
		if(Global::alpha_enable!=true){
			Global::alpha_enable=true;
			glEnable(GL_BLEND);
		}
		glDepthMask(GL_FALSE); // must be set to false every time, as it's always equal to true before it's called
		depth_mask_disabled=true; // set this to true to we know when to enable depth mask at bottom of function
	}else{
		if(Global::alpha_enable!=false){
			Global::alpha_enable=false;
			glDisable(GL_BLEND);
			//glDepthMask(GL_TRUE); already set to true
		}
	}
#else
	Global::shader=&Global::shader_particle;
	glUseProgram(Global::shader->ambient_program);
	glUniformMatrix4fv(Global::shader->view, 1 , 0, &Global::camera_in_use->mod_mat[0] );
	glUniformMatrix4fv(Global::shader->proj, 1 , 0, &Global::camera_in_use->proj_mat[0] );

#endif

	if(brush.blend!=Global::blend_mode){
		Global::blend_mode=brush.blend;

		switch(brush.blend){
			case 0:
				glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); // alpha
				break;
			case 1:
				glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA); // alpha
				break;
			case 2:
				glBlendFunc(GL_DST_COLOR,GL_ZERO); // multiply
				break;
			case 3:
				glBlendFunc(GL_SRC_ALPHA,GL_ONE); // additive and alpha
				break;
		}

	}


	if(surf->ShaderMat!=NULL){
		surf->ShaderMat->TurnOn(mat, surf, 0, &brush);
	}else{
#ifndef GLES2
		glEnable( GL_POINT_SPRITE ); 

		float quadratic[] = {0,0,1};
		glPointParameterfv( GL_POINT_DISTANCE_ATTENUATION, quadratic );

		glEnable( GL_POINT_SMOOTH );
		glPointSize(brush.tex[0]->width * Global::camera_in_use->vheight*.5);
		glActiveTexture(GL_TEXTURE0);
		glEnable( GL_TEXTURE_2D );

		if(brush.tex[0]->flags&4){
			glEnable(GL_ALPHA_TEST);
		}

		switch(brush.tex[0]->blend){
			case 0: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_REPLACE);
			break;
			case 1: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_DECAL);
			break;
			case 2: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
			//case 2 glTexEnvf(GL_TEXTURE_ENV,GL_COMBINE_RGB_EXT,GL_MODULATE);
			break;
			case 3: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_ADD);
			break;
			case 4:
				glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE_EXT);
				glTexEnvf(GL_TEXTURE_ENV, GL_COMBINE_RGB_EXT, GL_DOT3_RGB_EXT);
				break;
			case 5:
				glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_COMBINE);
				glTexEnvi(GL_TEXTURE_ENV,GL_COMBINE_RGB,GL_MODULATE);
				glTexEnvi(GL_TEXTURE_ENV,GL_RGB_SCALE,2.0);
				break;
			default: glTexEnvf(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);
		}


		glTexEnvf(GL_POINT_SPRITE, GL_COORD_REPLACE, GL_TRUE);
		glBindTexture(GL_TEXTURE_2D, brush.tex[0]->texture);


	}

	glBindBuffer(GL_ARRAY_BUFFER,0); // reset - necessary for when non-vbo surf follows vbo surf
	glColorPointer(4,GL_FLOAT,0,&surf->vert_col[0]);

	glVertexPointer(3,GL_FLOAT,0,&surf->vert_coords[0]);
#else
		//glEnable( GL_PROGRAM_POINT_SIZE );
		glActiveTexture(GL_TEXTURE0);
		//glTexEnvf(GL_POINT_SPRITE, GL_COORD_REPLACE, GL_TRUE);
		glBindTexture(GL_TEXTURE_2D, brush.tex[0]->texture);

		surf->reset_vbo=9;
		surf->UpdateVBO();
		glBindBuffer(GL_ARRAY_BUFFER,surf->vbo_id[0]);
		glVertexAttribPointer(Global::shader->vposition, 3, GL_FLOAT, GL_FALSE, 0, 0);
		glEnableVertexAttribArray(Global::shader->vposition);
		glBindBuffer(GL_ARRAY_BUFFER,surf->vbo_id[4]);
		glVertexAttribPointer(Global::shader->color, 4, GL_FLOAT, GL_FALSE, 0, 0);
		glEnableVertexAttribArray(Global::shader->color);
		glUniform1i(Global::shader->texflag, brush.tex[0]->flags&4);
	}

#endif
	glDrawArrays(GL_POINTS,0,surf->no_verts);

#ifndef GLES2
	glDisable( GL_POINT_SPRITE ); 
	glDisable( GL_POINT_SMOOTH );
#endif

	// enable depth mask again if it was disabled when blend was enabled
	if(depth_mask_disabled==true){
		glDepthMask(GL_TRUE);
		depth_mask_disabled=false; // set to false again for when we repeat loop
	}



	//Trails

	if (trail>1){
		float r=(brush.red-2)/trail;
		float g=(brush.green-2)/trail;
		float b=(brush.blue-2)/trail;
		float a=(brush.alpha-2)/trail;
		for(int i=0;i<=surf->no_verts-1;i++){
			surf->vert_col[i*4]+=r;
			surf->vert_col[i*4+1]+=g;
			surf->vert_col[i*4+2]+=b;
			surf->vert_col[i*4+3]+=a;
			surf->vert_coords[i*3]+=px;
			surf->vert_coords[i*3+1]+=py;
			surf->vert_coords[i*3+2]+=pz;

		}
	}


	int del_trail_points=surf->no_verts/trail;

	if (del_trail_points!=0){
		surf->vert_tex_coords0.clear();
		surf->vert_tex_coords1.clear();
		if (surf->no_verts<=del_trail_points){
			surf->vert_coords.clear();
			surf->vert_col.clear();
			surf->no_verts=0;
		}else{
			surf->vert_coords.erase(surf->vert_coords.begin(),surf->vert_coords.begin()+del_trail_points*3);
			surf->vert_col.erase(surf->vert_col.begin(),surf->vert_col.begin()+del_trail_points*4);
			surf->no_verts-=del_trail_points;
		}
	}
#ifndef GLES2
	if(surf->ShaderMat!=NULL){
		surf->ShaderMat->TurnOff();
	}
#else
	glDisableVertexAttribArray(Global::shader->vposition);
#endif

}

//todo: variance
void ParticleEmitter::Update(){
	list<ParticleData>::iterator it;

	rate_counter++;
	if (hide==false && rate_counter>rate){
		rate_counter=0;
		ParticleData particle;
		particle.ent=particle_base->CopyEntity(0);
		particle.ent->hide=true;
		
		int plus=lastlife - midlife; // end - endplus
		if (plus==0){
			particle.particleLife=midlife; // no random
		}else{
			particle.particleLife=midlife + (rand() % plus);
		}
		initlife=particle.particleLife;
		particle.vx=0;
		particle.vy=0;
		particle.vz=firstspeed;
		particle.fgx=firstgx;
		particle.fgy=firstgy;
		particle.fgz=firstgz;
		particle.lgx=lastgx;
		particle.lgy=lastgy;
		particle.lgz=lastgz;
		
		particle.ent->px=mat.grid[3][0];
		particle.ent->py=mat.grid[3][1];
		particle.ent->pz=-mat.grid[3][2];
		
		if (variance>0.000000001){ // RAND_MAX = 32767 constant
			particle.vx+=static_cast <float> (rand()) / (static_cast <float> (RAND_MAX/variance)) - (variance/2);
			particle.vy+=static_cast <float> (rand()) / (static_cast <float> (RAND_MAX/variance)) - (variance/2);
			particle.vz+=static_cast <float> (rand()) / (static_cast <float> (RAND_MAX/variance)) - (variance/2);
		}
		mat.TransformVec(particle.vx,particle.vy,particle.vz);
		particles.push_back(particle);
	}

	for(it=particles.begin();it!=particles.end();it++){
		ParticleData &particle=*it;
		
		if (particle.particleLife<=0){
			particle.ent->FreeEntity();
			it=particles.erase(it);
			continue;
		}
		
		// new: default functions
		float lifeleft=static_cast <float> (particle.particleLife) / static_cast <float> (lastlife);
		float invlifeleft=1.0 - lifeleft;
		
		if (particle.particleLife==(initlife - firstlife)){ // end - start
			particle.ent->hide=false; // show
		}
		
		float fla=(firsta * lifeleft) + (lasta * invlifeleft); // if only start/end values, blend first with last
		if (midlifea>0){ // if mid values, blend first+mid with mid+last
			fla=(((firsta * lifeleft) + (halfa * invlifeleft)) * lifeleft) + (((halfa * lifeleft) + (lasta * invlifeleft)) * invlifeleft);
		}
		if (fla>1) fla=1;
		if (fla>0) particle.ent->EntityAlpha(fla);
		
		float flsx=(firstsx * lifeleft) + (lastsx * invlifeleft);
		float flsy=(firstsy * lifeleft) + (lastsy * invlifeleft);
		if (midlifes>0){
			flsx=(((firstsx * lifeleft) + (halfsx * invlifeleft)) * lifeleft) + (((halfsx * lifeleft) + (lastsx * invlifeleft)) * invlifeleft);
			flsy=(((firstsy * lifeleft) + (halfsy * invlifeleft)) * lifeleft) + (((halfsy * lifeleft) + (lastsy * invlifeleft)) * invlifeleft);
		}
		if (flsx>0 && flsy>0) dynamic_cast<Sprite*>(particle.ent)->ScaleSprite(flsx, flsy);
		
		float flr=(firstr * lifeleft) + (lastr * invlifeleft);
		float flg=(firstg * lifeleft) + (lastg * invlifeleft);
		float flb=(firstb * lifeleft) + (lastb * invlifeleft);
		if (midlifec>0){
			flr=(((firstr * lifeleft) + (halfr * invlifeleft)) * lifeleft) + (((halfr * lifeleft) + (lastr * invlifeleft)) * invlifeleft);
			flg=(((firstg * lifeleft) + (halfg * invlifeleft)) * lifeleft) + (((halfg * lifeleft) + (lastg * invlifeleft)) * invlifeleft);
			flb=(((firstb * lifeleft) + (halfb * invlifeleft)) * lifeleft) + (((halfb * lifeleft) + (lastb * invlifeleft)) * invlifeleft);
		}
		particle.ent->EntityColor(flr, flg, flb, false);
		
		float flrt=(firstrt * lifeleft) + (lastrt * invlifeleft);
		if (midlifert>0){
			flrt=(((firstrt * lifeleft) + (halfrt * invlifeleft)) * lifeleft) + (((halfrt * lifeleft) + (lastrt * invlifeleft)) * invlifeleft);
		}
		float rt=fmod(dynamic_cast<Sprite*>(particle.ent)->angle + flrt, 360);
		if (rt>-360 && rt<360) dynamic_cast<Sprite*>(particle.ent)->RotateSprite(rt);
		
		// callback function overrides default functions
		if (UpdateParticle!=0){
			UpdateParticle (particle.ent, particle.particleLife);
		}
		
		particle.vx+=(particle.fgx * lifeleft) + (particle.lgx * invlifeleft);
		particle.vy+=(particle.fgy * lifeleft) + (particle.lgy * invlifeleft);
		particle.vz+=(particle.fgz * lifeleft) + (particle.lgz * invlifeleft);

		particle.ent->px+=particle.vx;
		particle.ent->py+=particle.vy;
		particle.ent->pz+=particle.vz;
		particle.ent->mat.SetTranslate(particle.ent->px, particle.ent->py, -particle.ent->pz);

		particle.particleLife--;

	}
}

ParticleEmitter* ParticleEmitter::CreateParticleEmitter (Entity* particle, Entity* parent_ent){
	if(parent_ent==NULL) parent_ent=Global::root_ent;

	ParticleEmitter* emitter=new ParticleEmitter;

	emitter->particle_base=particle;

	emitter->class_name="Emitter";
		
	emitter->AddParent(parent_ent);
	entity_list.push_back(emitter);

	// update matrix
	if(emitter->parent!=NULL){
		emitter->mat.Overwrite(emitter->parent->mat);
		emitter->UpdateMat();
	}else{
		emitter->UpdateMat(true);
	}

	emitter_list.push_back(emitter);

	return emitter;
}

ParticleEmitter* ParticleEmitter::CopyEntity (Entity* parent_ent){
	if(parent_ent==NULL) parent_ent=Global::root_ent;

	ParticleEmitter* emitter=new ParticleEmitter;

	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent=*it;
		ent->CopyEntity(emitter);
	}

	emitter->class_name="Emitter";
		
	emitter->AddParent(parent_ent);
	entity_list.push_back(emitter);

	// add to collision entity list
	if(collision_type!=0){
		CollisionPair::ent_lists[collision_type].push_back(emitter);
	}
	
	// add to pick entity list
	if(pick_mode){
		Pick::ent_list.push_back(emitter);
	}
	
	// update matrix
	if(emitter->parent){
		emitter->mat.Overwrite(emitter->parent->mat);
	}else{
		emitter->mat.LoadIdentity();
	}
	
	// copy entity info

	emitter->px=px;
	emitter->py=py;
	emitter->pz=pz;
	emitter->sx=sx;
	emitter->sy=sy;
	emitter->sz=sz;
	emitter->rx=rx;
	emitter->ry=ry;
	emitter->rz=rz;
	emitter->qw=qw;
	emitter->qx=qx;
	emitter->qy=qy;
	emitter->qz=qz;

	emitter->name=name;
	emitter->class_name=class_name;
	emitter->order=order;
	emitter->hide=false;

	emitter->radius_x=radius_x;
	emitter->radius_y=radius_y;
	emitter->box_x=box_x;
	emitter->box_y=box_y;
	emitter->box_z=box_z;
	emitter->box_w=box_w;
	emitter->box_h=box_h;
	emitter->box_d=box_d;
	emitter->collision_type=collision_type;
	emitter->pick_mode=pick_mode;
	emitter->obscurer=obscurer;

	emitter_list.push_back(emitter);

	emitter->particle_base=particle_base;

	emitter->rate=rate;
	emitter->firstlife=firstlife;
	emitter->midlife=midlife; // added
	emitter->lastlife=lastlife;
	emitter->initlife=initlife;
	emitter->firstgx=firstgx;
	emitter->firstgy=firstgy;
	emitter->firstgz=firstgz;
	emitter->lastgx=lastgx;
	emitter->lastgy=lastgy;
	emitter->lastgz=lastgz;
	emitter->variance=variance;
	emitter->firstspeed=firstspeed;
	emitter->lastspeed=lastspeed;

	emitter->UpdateParticle=UpdateParticle;
	
	emitter->firsta=firsta; // new
	emitter->lasta=lasta;
	emitter->halfa=halfa;
	emitter->midlifea=midlifea;
	emitter->firstsx=firstsx;
	emitter->firstsy=firstsy;
	emitter->lastsx=lastsx;
	emitter->lastsy=lastsy;
	emitter->halfsx=halfsx;
	emitter->halfsy=halfsy;
	emitter->midlifes=midlifes;
	emitter->firstr=firstr;
	emitter->firstg=firstg;
	emitter->firstb=firstb;
	emitter->lastr=lastr;
	emitter->lastg=lastg;
	emitter->lastb=lastb;
	emitter->halfr=halfr;
	emitter->halfg=halfg;
	emitter->halfb=halfb;
	emitter->midlifec=midlifec;
	emitter->firstrt=firstrt;
	emitter->lastrt=lastrt;
	emitter->halfrt=halfrt;
	emitter->midlifert=midlifert;
	
	return emitter;

}

void ParticleEmitter::FreeEntity (){
	emitter_list.remove(this);

	list<ParticleData>::iterator it;

	for(it=particles.begin();it!=particles.end();it++){
		ParticleData &particle=*it;

		particle.ent->FreeEntity();

	}
	particles.clear();


	Entity::FreeEntity();
	delete this;
	return;
}

void ParticleEmitter::EmitterVector (float startx, float starty, float startz, float endx, float endy, float endz){
	firstgx=startx * firstspeed; // new: multiply by speed
	firstgy=starty * firstspeed;
	firstgz=startz * firstspeed;
	lastgx=endx * lastspeed;
	lastgy=endy * lastspeed;
	lastgz=endz * lastspeed;
}

void ParticleEmitter::EmitterRate (float r){
	rate=1.0/r;
}

void ParticleEmitter::EmitterVariance (float v){
	variance=v;
}

void ParticleEmitter::EmitterParticleLife (int startl, int endl, int randl){
	firstlife=startl;
	midlife=endl;
	lastlife=endl + randl;
}

void ParticleEmitter::EmitterParticleSpeed (float starts, float ends){
	firstspeed=starts;
	lastspeed=ends;
}

void ParticleEmitter::EmitterParticleFunction (void (*EmitterFunction)(Entity*, int)){
	UpdateParticle=EmitterFunction;
}

void ParticleEmitter::EmitterParticleAlpha (float starta, float enda, float mida, int midlife){ // new
	firsta=starta;
	lasta=enda;
	halfa=mida;
	midlifea=midlife;
}

void ParticleEmitter::EmitterParticleColor (float startr, float startg, float startb,float endr, float endg, float endb, float midr, float midg, float midb, int midlife){ // new
	firstr=startr;
	firstg=startg;
	firstb=startb;
	lastr=endr;
	lastg=endg;
	lastb=endb;
	halfr=midr;
	halfg=midg;
	halfb=midb;
	midlifec=midlife;
}

void ParticleEmitter::EmitterParticleScale (float startsx, float startsy, float endsx, float endsy, float midsx, float midsy, int midlife){ // new
	firstsx=startsx;
	firstsy=startsy;
	lastsx=endsx;
	lastsy=endsy;
	halfsx=midsx;
	halfsy=midsy;
	midlifes=midlife;
}

void ParticleEmitter::EmitterParticleRotate (float startr, float endr, float midr, int midlife){ // new
	firstrt=startr;
	lastrt=endr;
	halfrt=midr;
	midlifert=midlife;
}
