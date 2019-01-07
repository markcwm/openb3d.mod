#ifdef EMSCRIPTEN
#include <GLES3/gl3.h>
#include <GLES3/gl2ext.h>
#define GLES2
#endif

#include "glew_glee.h" // glee or glew

#include "postfx.h"
#include "shadow.h"
//#include "sprite_batch.h"


list<PostFX*> PostFX::fx_list;

PostFX* PostFX::CreatePostFX(Camera* cam, int passes){
	PostFX* postfx=new PostFX();

	postfx->cam=cam;

	postfx->vx=cam->vx;
	postfx->vy=cam->vy;
	postfx->vwidth=cam->vwidth;
	postfx->vheight=cam->vheight;

	postfx->no_passes=passes;

	postfx->pass=new FXPass[passes];

	/*postfx->tex=new unsigned int[1];
	glGenTextures (1, &postfx->tex[0]);
	postfx->ShaderFX=fx;

	glBindTexture (GL_TEXTURE_2D, postfx->tex[0]);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);*/

	postfx->framebuffer=new unsigned int[passes];
	glGenFramebuffers(passes, &postfx->framebuffer[0]);
	glGenRenderbuffers(1, &postfx->renderbuffer);

	/*glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA16F, cam->vwidth, cam->vheight, 0, GL_RGBA, GL_FLOAT, 0);

	glBindFramebuffer(GL_FRAMEBUFFER, postfx->framebuffer[0]);
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, postfx->tex[0], 0);*/

	glBindRenderbuffer(GL_RENDERBUFFER, postfx->renderbuffer);
	glRenderbufferStorage( GL_RENDERBUFFER, GL_DEPTH_STENCIL, cam->vwidth, cam->vheight);
	glBindRenderbuffer(GL_RENDERBUFFER, 0);


	fx_list.push_back(postfx);

	return postfx;
}

void PostFX::AddRenderTarget(int pass_no, int numColBufs, bool depth, int format, float scale){
	int numT=numColBufs;
	if (depth) 
		numT++;
	pass[pass_no].tex=new unsigned int[numT];

	pass[pass_no].numColBufs=numColBufs;
	glGenTextures (numT, &pass[pass_no].tex[0]);

	int iFormat;
	switch (format){
	case 32:
		iFormat=GL_RGBA32F;
		break;
	case 16:
		iFormat=GL_RGBA16F;
		break;
	case 8:
	default:
		iFormat=GL_RGBA8;
	}

	if (scale==1.0){
		pass[pass_no].width=cam->vwidth;
		pass[pass_no].height=cam->vheight;
	}else{
		pass[pass_no].width=(int)((float)cam->vwidth*scale);
		pass[pass_no].height=(int)((float)cam->vheight*scale);
	}

	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer[pass_no]);

	for (int i=0;i<numColBufs;i++){
		glBindTexture (GL_TEXTURE_2D, pass[pass_no].tex[i]);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);

#ifndef GLES2
		glTexImage2D(GL_TEXTURE_2D, 0, iFormat, pass[pass_no].width, pass[pass_no].height, 0, GL_RGBA, GL_FLOAT, 0);		
#else
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, pass[pass_no].width, pass[pass_no].height, 0, GL_RGBA, GL_UNSIGNED_BYTE, 0);
#endif

		glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0+i, GL_TEXTURE_2D, pass[pass_no].tex[i], 0);

	}

	if (depth){
		pass[pass_no].d=numColBufs;
		glBindTexture (GL_TEXTURE_2D, pass[pass_no].tex[numColBufs]);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
		glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);

#ifndef GLES2
		glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_STENCIL, pass[pass_no].width, pass[pass_no].height, 0, GL_DEPTH_COMPONENT, GL_FLOAT, 0);		
#else
		glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_STENCIL, pass[pass_no].width, pass[pass_no].height, 0, GL_DEPTH_COMPONENT, GL_UNSIGNED_BYTE, 0);
#endif
		glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_TEXTURE_2D, pass[pass_no].tex[numColBufs], 0);

	}else{
		pass[pass_no].d=0;
		glFramebufferRenderbuffer( GL_FRAMEBUFFER, GL_DEPTH_STENCIL_ATTACHMENT, GL_RENDERBUFFER, renderbuffer); 
	}
	glBindFramebuffer(GL_FRAMEBUFFER, 0);

}

void PostFX::PostFXShader(int pass_no, Shader* shader){
	pass[pass_no].ShaderFX=shader;
}

void PostFX::PostFXShaderPass(int pass_no, string name, int v){
	pass[pass_no].PassLoc=glGetUniformLocation(pass[pass_no].ShaderFX->GetProgram(), name.c_str());
	pass[pass_no].PassValue=v;
}

void PostFX::PostFXBuffer(int pass_no, int source_pass, int index, int slot){
	int tex_source;
	if (index==0) {
		tex_source=pass[source_pass].tex[pass[source_pass].d];
	}else{
		tex_source=pass[source_pass].tex[index-1];
	}
	pass[pass_no].buffer_in_out.push_back(slot);
	pass[pass_no].buffer_in_out.push_back(tex_source);
}

void PostFX::PostFXTexture(int pass_no, Texture* tex, int slot, int frame){
	pass[pass_no].buffer_in_out.push_back(slot);
	if (tex->no_frames>2){
		pass[pass_no].buffer_in_out.push_back(tex->frames[frame]);
	}else{
		pass[pass_no].buffer_in_out.push_back(tex->texture);
	}
}

void PostFX::PostFXFunction(int pass_no, void (*PassFunction)(void)){
	pass[pass_no].PassFunction=PassFunction;
}


void PostFX::Render(){

	GLenum DrawBuffers[9] = {GL_COLOR_ATTACHMENT0, GL_COLOR_ATTACHMENT1, GL_COLOR_ATTACHMENT2, GL_COLOR_ATTACHMENT3, 
				 GL_COLOR_ATTACHMENT4, GL_COLOR_ATTACHMENT5, GL_COLOR_ATTACHMENT6, GL_COLOR_ATTACHMENT7,
				 GL_COLOR_ATTACHMENT8};

	//Render on a frame buffer
	glBindFramebuffer(GL_FRAMEBUFFER, framebuffer[0]);
	glDrawBuffers(pass[0].numColBufs, DrawBuffers);

	Global::camera_in_use=cam;
	cam->Render();
	if (Global::Shadows_enabled==true)
		ShadowObject::Update(cam);


#ifndef GLES2
	glBindBuffer(GL_ARRAY_BUFFER,0); 
	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	glLoadIdentity();
	glMatrixMode(GL_MODELVIEW);
	glPushMatrix();
	glDisable(GL_LIGHTING);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);

	glLoadIdentity();
	glOrtho(0 , 1 , 1 , 0 , 0 , 1);

	glDisable(GL_DEPTH_TEST);
	glColor4f(1.0, 1.0, 1.0, 1.0);

	if(Global::fx1!=true){
		Global::fx1=true;
		glDisableClientState(GL_NORMAL_ARRAY);
	}
	if(Global::fx2!=false){
		Global::fx2=false;
		glDisableClientState(GL_COLOR_ARRAY);
	}

	if(Global::alpha_enable!=false){
		Global::alpha_enable=false;
		glDisable(GL_BLEND);
	}


	GLfloat q3[] = {0,0,0,1,1,1,1,0};
	GLfloat qv[] = {0,1,0,0,1,0,1,1};
	 
	glVertexPointer(2, GL_FLOAT, 0, q3);
	glTexCoordPointer(2, GL_FLOAT, 0, qv);
#else
	glBindBuffer(GL_ARRAY_BUFFER, Global::stencil_vbo);

//	glVertexAttribPointer(Global::shader->vposition, 2, GL_FLOAT, GL_FALSE, 0, 0);
//	glEnableVertexAttribArray(Global::shader->vposition);

#endif

	for (int it=0; it<no_passes; it++){
		if(it==no_passes-1){
			glBindFramebuffer(GL_FRAMEBUFFER, 0);
			//glBindRenderbuffer(GL_RENDERBUFFER, 0);
			glViewport(vx,vy,vwidth,vheight);
			glScissor(vx,vy,vwidth,vheight);
		}else{
			glBindFramebuffer(GL_FRAMEBUFFER, framebuffer[it+1]);
			glDrawBuffers(pass[it+1].numColBufs, DrawBuffers);
			glViewport(0,0,pass[it+1].width,pass[it+1].height);
			glScissor(0,0,pass[it+1].width,pass[it+1].height);
		}

		for (unsigned int it2=0; it2<pass[it].buffer_in_out.size();it2+=2){
			glActiveTexture(GL_TEXTURE0 + pass[it].buffer_in_out[it2]);
			//glClientActiveTexture(GL_TEXTURE0 + pass[it].buffer_in_out[it2]);
			glEnable(GL_TEXTURE_2D);
			glBindTexture (GL_TEXTURE_2D, pass[it].buffer_in_out[it2+1]);
		}


		//Display render image
		if (pass[it].ShaderFX!=0){
#ifndef GLES2
			pass[it].ShaderFX->ProgramAttriBegin();
#else
			pass[it].ShaderFX->ProgramAttriBegin();
			glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 0, 0);
			glEnableVertexAttribArray(0);

#endif
		}

		if (pass[it].PassLoc!=-1){
			glUniform1i(pass[it].PassLoc, pass[it].PassValue);
		}

		if (!pass[it].buffer_in_out.empty()){

			glDrawArrays(GL_TRIANGLE_FAN,0,4);

		}
		if (pass[it].PassFunction!=0){
			pass[it].PassFunction();
		}

		if (pass[it].ShaderFX!=0){
			pass[it].ShaderFX->ProgramAttriEnd();
		}
		for (unsigned int it2=0; it2<pass[it].buffer_in_out.size();it2+=2){
			glActiveTexture(GL_TEXTURE0 + pass[it].buffer_in_out[it2]);
			//glClientActiveTexture(GL_TEXTURE0 + pass[it].buffer_in_out[it2]);
			glDisable(GL_TEXTURE_2D);
		}
	}

	glEnable(GL_DEPTH_TEST);
#ifndef GLES2
	glEnable(GL_LIGHTING);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);

	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
	glPopMatrix();
#else
	glDisableVertexAttribArray(0);
#endif
	glDisable(GL_TEXTURE_2D);

}


