
#include <iostream>
#include <string>

#include "glew_glee.h" // glee or glew

#include "surface.h"
#include "camera.h"
#include "shadermat.h"
#include "file.h"
#include "global.h"
#include "stb_image.h"

#include "bmaxdebug.h"

list<ShaderObject*> ShaderObject::ShaderObjectList;
list<ProgramObject*> ProgramObject::ProgramObjectList;
int Shader::ShaderIDCount;

static int default_program=0;

#ifndef GLES2
static int No_samplers=0;
#else
static unsigned int vbo_id;
#endif

enum{
USE_FLOAT_1_UNI,
USE_FLOAT_2_UNI,
USE_FLOAT_3_UNI,
USE_FLOAT_4_UNI,
USE_FLOAT_1_ATT,
USE_FLOAT_2_ATT,
USE_FLOAT_3_ATT,
USE_FLOAT_4_ATT,
USE_INTEGER_1,
USE_INTEGER_2,
USE_INTEGER_3,
USE_INTEGER_4,
USE_ENTITY_MATRIX,
USE_ENTITY_INVERSE_MATRIX,
USE_SURFACE,
USE_MODEL_MATRIX,
USE_VIEW_MATRIX,
USE_PROJ_MATRIX,
USE_MODELVIEW_MATRIX,
USE_FUNCTION,
USE_ENTITY_COORDS
};

void Shader::FreeShader(){
	if(!arb_program->Program) return;
	arb_program->DeActivate(); // Ensure the shader is not used
	
	list<ShaderObject*>::iterator it;
	for(it=arb_program->vList.begin();it!=arb_program->vList.end();it++){
		ShaderObject* obj=*it;
		obj->DeleteShader(obj, GL_VERTEX_SHADER);
	}
	for(it=arb_program->fList.begin();it!=arb_program->fList.end();it++){
		ShaderObject* obj=*it;
		obj->DeleteShader(obj, GL_FRAGMENT_SHADER);
	}
	for(it=arb_program->gList.begin();it!=arb_program->gList.end();it++){
		ShaderObject* obj=*it;
		obj->DeleteShader(obj, GL_GEOMETRY_SHADER);
	}
	
	glDeleteProgram(arb_program->Program);
	delete this;
}


ShaderObject* ShaderObject::CreateShader(string shaderFileName, int shadertype){
	// Load the shader and dump it into a Byte Array
	File* file=File::ReadFile(shaderFileName); // opens as ASCII!
	if(file==0) {
		return 0;
	}

	fseek(file->pFile, 0L, SEEK_END);
	unsigned long FileLength = ftell(file->pFile);
	fseek(file->pFile, 0L, SEEK_SET);
	// wrong size "void main(){}"
	if (FileLength<13){
		file->CloseFile();
		return 0;
	}
	char* shaderSrc = new char[FileLength+1];
	// out of memory
	if (shaderSrc == 0) {
		file->CloseFile();
		return 0;
	}

	// FileLength isn't always strlen cause some characters are stripped in ascii read...
	// it is important to 0-terminate the real length later, len is just max possible value...
	shaderSrc[FileLength] = 0;
	unsigned int i=0;
	while (!file->Eof()){
		shaderSrc[i] = file->ReadByte();       // get character from file.
		i++;
	}
	shaderSrc[i] = 0;  // 0-terminate it at the correct position
	file->CloseFile();

	ShaderObject* myShader = new ShaderObject;
	
	myShader->ShaderObj = glCreateShader(shadertype);
	//myShader->ShaderType = shadertype; // 1 = Vert, 2 = Frag

	// Send shader to ShaderObject, then compile it
	glShaderSource(myShader->ShaderObj,1, (const GLchar**)&shaderSrc, 0);
	glCompileShader(myShader->ShaderObj);

	// Did the shader compile successfuly?
	int compiled;
	glGetShaderiv(myShader->ShaderObj,GL_COMPILE_STATUS, &compiled);

	if (!compiled){
		int maxLength = 0; // maxLength includes the NULL character
		glGetShaderiv(myShader->ShaderObj, GL_INFO_LOG_LENGTH, &maxLength);
		
		vector<char> infoLog(maxLength);
		glGetShaderInfoLog(myShader->ShaderObj, maxLength, &maxLength, &infoLog[0]);
#ifdef OPENB3D_DEBUG
		DebugLog("%s; %s",shaderFileName.c_str(),&infoLog[0]);
#endif
		// don't leak the shader
		myShader->DeleteShader(myShader, shadertype);
		
		delete [] shaderSrc;
		delete myShader;
		return 0;
	}


	//myShader.Attached = New TList
	myShader->shaderName = shaderFileName;
	ShaderObject::ShaderObjectList.push_back(myShader);
	delete [] shaderSrc;
	
	return myShader;
}



ShaderObject* ShaderObject::CreateShaderFromString(string shadercode, int shadertype){
	// Load the shader and dump it into a Byte Array
	if (shadercode == ""){
		return 0;
	}
	
	//Local tempShaderName:String = "Code"+Rand(10000)
	unsigned int FileLength = shadercode.size();
	// wrong size "void main(){}"
	if (FileLength<13){
		return 0;
	}

	ShaderObject* myShader = new ShaderObject;
	
	myShader->ShaderObj = glCreateShader(shadertype);
	//myShader->ShaderType = shadertype; // 1 = Vert, 2 = Frag

	//Create a Byte Array to which the Shader Source will be copied to
	//The extra Array Byte (FileLength+1) is so we can Null terminate the array
	char* shaderSrc;

	shaderSrc = new char[FileLength+1];
	if (shaderSrc == 0) return 0;   // can't reserve memory
   
	// FileLength isn't always strlen cause some characters are stripped in ascii read...
	// it is important to 0-terminate the real length later, len is just max possible value... 
	shaderSrc[FileLength] = 0; 

	unsigned int i=0;
	while (i<FileLength)
	{
		shaderSrc[i] = shadercode[i];       // get character from file.
		i++;
	}
    
	shaderSrc[i] = 0;  // 0-terminate it at the correct position


	// Send shader to ShaderObject, then compile it
	glShaderSource(myShader->ShaderObj,1, (const GLchar**)&shaderSrc, 0);
	glCompileShader(myShader->ShaderObj);

	// Did the shader compile successfuly?
	int compiled;
	glGetShaderiv(myShader->ShaderObj,GL_COMPILE_STATUS, &compiled);

	if (!compiled){
		int maxLength = 0; // maxLength includes the NULL character
		glGetShaderiv(myShader->ShaderObj, GL_INFO_LOG_LENGTH, &maxLength);
		
		vector<char> infoLog(maxLength);
		glGetShaderInfoLog(myShader->ShaderObj, maxLength, &maxLength, &infoLog[0]);
#ifdef OPENB3D_DEBUG
		DebugLog("%s; %s",shadercode.c_str(),&infoLog[0]);
#endif
		// don't leak the shader
		myShader->DeleteShader(myShader, shadertype);
		
		delete [] shaderSrc;
		delete myShader;
		return 0;
	}


	//myShader.Attached = New TList
	//myShader->shaderName = shaderFileName;
	ShaderObject::ShaderObjectList.push_back(myShader);
	delete [] shaderSrc;
	
	return myShader;
}

void ShaderObject::DeleteShader(ShaderObject* myShader, int shadertype){
	if (myShader==0) return;

	ShaderObject::ShaderObjectList.remove(myShader);
	
	// Detach this ShaderObject from all ProgramObjects it was attached to
	list<ProgramObject*>::iterator it;

	for(it=ProgramObject::ProgramObjectList.begin();it!=ProgramObject::ProgramObjectList.end();it++){
		ProgramObject* p=*it;
		
		p->DetachShader(myShader, shadertype);
	}
	
	// Delete the shader
	glDeleteShader(myShader->ShaderObj);
	delete myShader;
}

//ShaderMat

Sampler* Sampler::Create(int Slot, Texture* Tex){
	Sampler* S = new Sampler;
	//S->Name = Name;
	S->Slot = Slot;
	S->texture = Tex;
	return S;
}


	
Shader* Shader::CreateShaderMaterial(string Name){
	Shader* s= new Shader;
	s->texCount=0;
	if (Name == ""){
		Name = "NoName";
	}
	if (1==1){//HardwareInfo->ShaderSupport{
		stringstream sstm;
		sstm << Name << s->ID;
		s->ID = ShaderIDCount;
		s->arb_program = ProgramObject::Create(sstm.str());
		s->name = Name;
	}else{
		return 0;
	}
	ShaderIDCount++;

	for (int i=0; i<=254; i++){
		s->Shader_Tex[i] = 0;
	}

	return s;
}
	
/*void Shader::UpdateData(Surface* surf) {
	for (unsigned int i=0;i<Parameters.size();i++){
		switch(Parameters[i].type){
		case 0:
			if (arb_program !=0){arb_program->SetParameter1F(Parameters[i].name,*(Parameters[i].fp[0]));}
			break;
		case 7:
			if (arb_program !=0){arb_program->SetParameter3F(Parameters[i].name, 
			Parameters[i].ent->EntityX(), 
			Parameters[i].ent->EntityY(),
			Parameters[i].ent->EntityZ());}
			break;
		case 13:
			if (arb_program !=0){arb_program->SetParameterArray(Parameters[i].name,Parameters[i].surf,Parameters[i].vbo);}
			break;
		case 14:
			if (arb_program !=0){
				GLfloat modelViewMatrix[16];
				glGetFloatv(GL_MODELVIEW_MATRIX, modelViewMatrix);
				arb_program->SetMatrix4F(Parameters[i].name, modelViewMatrix);
			}
			break;

		case 15:
			if (arb_program !=0){
				GLfloat modelViewMatrix[16];
				glGetFloatv(GL_PROJECTION_MATRIX, modelViewMatrix);
				arb_program->SetMatrix4F(Parameters[i].name, modelViewMatrix);
			}
			break;


		//default:
		}
	}
}
	*/
// internal 
void Shader::TurnOn(Matrix& mat, Surface* surf, vector<float>* vertices, Brush* brush){
	ProgramAttriBegin();
	// Update Data

#ifdef GLES2
	if (surf==0){
		vector<float>&vert=*vertices;
		if (vbo_id==0) {
			glGenBuffers(1,&vbo_id);
		}
		glBindBuffer(GL_ARRAY_BUFFER,vbo_id);
		glBufferData(GL_ARRAY_BUFFER,(vert.size()*sizeof(float)),&vert[0],GL_STREAM_DRAW);
	}
#endif

	for (unsigned int i=0;i<Parameters.size();i++){
		switch(Parameters[i].type){
		case USE_FLOAT_1_UNI:
			if (arb_program !=0){glUniform1f(Parameters[i].name,*(Parameters[i].fp[0]));}
			break;
		case USE_FLOAT_2_UNI:
			if (arb_program !=0){glUniform2f(Parameters[i].name,*(Parameters[i].fp[0]),*(Parameters[i].fp[1]));}
			break;
		case USE_FLOAT_3_UNI:
			if (arb_program !=0){glUniform3f(Parameters[i].name,*(Parameters[i].fp[0]),*(Parameters[i].fp[1]),
			*(Parameters[i].fp[2]));}
			break;
		case USE_FLOAT_4_UNI:
			if (arb_program !=0){glUniform4f(Parameters[i].name,*(Parameters[i].fp[0]),*(Parameters[i].fp[1]),
			*(Parameters[i].fp[2]),*(Parameters[i].fp[3]));}
			break;
		case USE_FLOAT_1_ATT:
			if (arb_program !=0){glVertexAttrib1f(Parameters[i].name,*(Parameters[i].fp[0]));}
			break;
		case USE_FLOAT_2_ATT:
			if (arb_program !=0){glVertexAttrib2f(Parameters[i].name,*(Parameters[i].fp[0]),*(Parameters[i].fp[1]));}
			break;
		case USE_FLOAT_3_ATT:
			if (arb_program !=0){glVertexAttrib3f(Parameters[i].name,*(Parameters[i].fp[0]),*(Parameters[i].fp[1]),
			*(Parameters[i].fp[2]));}
			break;
		case USE_FLOAT_4_ATT:
			if (arb_program !=0){glVertexAttrib4f(Parameters[i].name,*(Parameters[i].fp[0]),*(Parameters[i].fp[1]),
			*(Parameters[i].fp[2]),*(Parameters[i].fp[3]));}
			break;
		case USE_INTEGER_1:
			if (arb_program !=0){glUniform1i(Parameters[i].name,*(Parameters[i].ip[0]));}
			break;
		case USE_INTEGER_2:
			if (arb_program !=0){glUniform2i(Parameters[i].name,*(Parameters[i].ip[0]),*(Parameters[i].ip[1]));}
			break;
		case USE_INTEGER_3:
			if (arb_program !=0){glUniform3i(Parameters[i].name,*(Parameters[i].ip[0]),*(Parameters[i].ip[1]),
			*(Parameters[i].ip[2]));}
			break;
		case USE_INTEGER_4:
			if (arb_program !=0){glUniform4i(Parameters[i].name,*(Parameters[i].ip[0]),*(Parameters[i].ip[1]),
			*(Parameters[i].ip[2]),*(Parameters[i].ip[3]));}
			break;
		case USE_ENTITY_MATRIX:
			if (arb_program !=0){
				glUniformMatrix4fv(Parameters[i].name, 1 , 0, &Parameters[i].ent->mat.grid[0][0]);
			}
			break;
		case USE_ENTITY_INVERSE_MATRIX:
			if (arb_program !=0){
				Matrix new_mat;
				Parameters[i].ent->mat.GetInverse(new_mat);
				glUniformMatrix4fv(Parameters[i].name, 1 , 0, &new_mat.grid[0][0]);
			}
			break;
		case USE_SURFACE:
			if (arb_program !=0){
				if(Parameters[i].surf!=0){
					arb_program->SetParameterArray(Parameters[i].name,Parameters[i].surf,Parameters[i].vbo);
				}else{
					if (surf!=0){
						arb_program->SetParameterArray(Parameters[i].name,surf,Parameters[i].vbo);
					}else{
						arb_program->SetParameterArray(Parameters[i].name,vertices,Parameters[i].vbo);
					}
				}
			}
			break;
		case USE_MODEL_MATRIX:
			if (arb_program !=0){
				glUniformMatrix4fv(Parameters[i].name, 1 , 0, &mat.grid[0][0]);
			}
			break;
		case USE_VIEW_MATRIX:
			if (arb_program !=0){
				//Matrix new_mat;
				//Global::camera_in_use->mat.GetInverse(new_mat);
				glUniformMatrix4fv(Parameters[i].name, 1 , 0, &Global::camera_in_use->mod_mat[0]);
			}
			break;

		case USE_PROJ_MATRIX:
			if (arb_program !=0){
				glUniformMatrix4fv(Parameters[i].name, 1 , 0, &Global::camera_in_use->proj_mat[0]);
			}
			break;
		case USE_MODELVIEW_MATRIX:
			if (arb_program !=0){
				Matrix new_mat;
				Global::camera_in_use->mat.GetInverse(new_mat);
				new_mat.Multiply(mat);
				glUniformMatrix4fv(Parameters[i].name, 1 , 0, &new_mat.grid[0][0]);
			}
			break;
		case USE_FUNCTION:
			if (Parameters[i].Enable!=0){
				Parameters[i].Enable();
			}
			break;
		case USE_ENTITY_COORDS:
			if (arb_program !=0){arb_program->SetParameter3F(Parameters[i].name, 1,
			Parameters[i].ent->EntityX(), 
			Parameters[i].ent->EntityY(),
			Parameters[i].ent->EntityZ());}
			break;

		//default:
		}
	}

	/*if (UpdateSampler != 0){
		for (int i=0; i<=254; i++){
			if (Shader_Tex[i] == 0) break;
			if (arb_program !=0){glUniform1i(Parameters[i].name,Shader_Tex[i]->Slot);}
		}
		UpdateSampler = 0;
	}*/

	int tex_count=0, ix2=0;
	if (brush!=0) tex_count=brush->no_texs;
	if (surf!=0) {
		if(surf->brush->no_texs>tex_count) tex_count=surf->brush->no_texs;
	}
	if(Shader_Tex[0]!=0) tex_count=texCount; // shader takes precedence
	
	int DisableCubeSphereMapping=0;
	for (int ix=0;ix<=254;ix++){
		if(ix>=tex_count) break; // no more texs
		if(ix>7) ix2=0; else ix2=ix; // crash if tex[ix]>7
		if(surf!=0){ // mesh
			if(Shader_Tex[ix]!=0){
				if(Shader_Tex[ix]->texture==0 && surf->brush->tex[ix2]==0) break; // no shadertex or surfacetex
			}else{
				if(surf->brush->tex[ix2]==0) break; // no surfacetex
			}
		}else{
			if(Shader_Tex[ix]!=0){ // terrain
				if(Shader_Tex[ix]->texture==0) break; // no shadertex
			}else{
				break;
			}
		}
		
		// Main brush texture takes precedent over surface brush texture
		unsigned int texture=0;
		int tex_flags=0,tex_blend=0,tex_coords=0;
		float tex_u_scale=1.0,tex_v_scale=1.0,tex_u_pos=0.0,tex_v_pos=0.0,tex_ang=0.0;
		int tex_cube_mode=0, is3D=0, slot=ix2;//,frame=0;
		if (Shader_Tex[ix]!=0){
			texture=Shader_Tex[ix]->texture->texture;
			tex_flags=Shader_Tex[ix]->texture->flags;
			tex_blend=Shader_Tex[ix]->texture->blend;
			tex_coords=Shader_Tex[ix]->texture->coords;
			tex_u_scale=Shader_Tex[ix]->texture->u_scale;
			tex_v_scale=Shader_Tex[ix]->texture->v_scale;
			tex_u_pos=Shader_Tex[ix]->texture->u_pos;
			tex_v_pos=Shader_Tex[ix]->texture->v_pos;
			tex_ang=Shader_Tex[ix]->texture->angle;
			tex_cube_mode=Shader_Tex[ix]->texture->cube_mode;
			is3D=Shader_Tex[ix]->is3D;
			slot=Shader_Tex[ix]->Slot;
		}else if(brush->tex[ix2]!=0){
			texture=brush->cache_frame[ix2];//brush->tex[ix2]->texture;
			tex_flags=brush->tex[ix2]->flags;
			tex_blend=brush->tex[ix2]->blend;
			tex_coords=brush->tex[ix2]->coords;
			tex_u_scale=brush->tex[ix2]->u_scale;
			tex_v_scale=brush->tex[ix2]->v_scale;
			tex_u_pos=brush->tex[ix2]->u_pos;
			tex_v_pos=brush->tex[ix2]->v_pos;
			tex_ang=brush->tex[ix2]->angle;
			tex_cube_mode=brush->tex[ix2]->cube_mode;
		}else if(surf->brush->tex[ix2]!=0){
			texture=surf->brush->cache_frame[ix2];//surf->brush->tex[ix2]->texture;
			tex_flags=surf->brush->tex[ix2]->flags;
			tex_blend=surf->brush->tex[ix2]->blend;
			tex_coords=surf->brush->tex[ix2]->coords;
			tex_u_scale=surf->brush->tex[ix2]->u_scale;
			tex_v_scale=surf->brush->tex[ix2]->v_scale;
			tex_u_pos=surf->brush->tex[ix2]->u_pos;
			tex_v_pos=surf->brush->tex[ix2]->v_pos;
			tex_ang=surf->brush->tex[ix2]->angle;
			tex_cube_mode=surf->brush->tex[ix2]->cube_mode;
			//frame=surf->brush->tex_frame;
		}else break;

		glActiveTexture(GL_TEXTURE0+slot);
#ifndef GLES2
		glClientActiveTexture(GL_TEXTURE0+slot);

		if (is3D==0){
			glEnable(GL_TEXTURE_2D);
			glBindTexture(GL_TEXTURE_2D,texture); // call before glTexParameteri
			// mipmapping texture flag
			if(tex_flags&8){
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
			}else{
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
				glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
			}
		}else{
			glEnable(GL_TEXTURE_3D);
			glBindTexture(GL_TEXTURE_3D,texture); // call before glTexParameteri
			// mipmapping texture flag
			if(tex_flags&8){
				glTexParameteri(GL_TEXTURE_3D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
				glTexParameteri(GL_TEXTURE_3D,GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_LINEAR);
			}else{
				glTexParameteri(GL_TEXTURE_3D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
				glTexParameteri(GL_TEXTURE_3D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
			}
		}

		// masked texture flag
		if(tex_flags&4){
			glEnable(GL_ALPHA_TEST);
		}else{
			glDisable(GL_ALPHA_TEST);
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
	
		// ***!ES***
		// *
		// spherical environment map texture flag
		if(tex_flags&64){
			glTexGeni(GL_S,GL_TEXTURE_GEN_MODE,GL_SPHERE_MAP);
			glTexGeni(GL_T,GL_TEXTURE_GEN_MODE,GL_SPHERE_MAP);
			glEnable(GL_TEXTURE_GEN_S);
			glEnable(GL_TEXTURE_GEN_T);
			DisableCubeSphereMapping=1;
		}
					
		// cubic environment map texture flag
		if(tex_flags&128){

			glEnable(GL_TEXTURE_CUBE_MAP);
			glBindTexture(GL_TEXTURE_CUBE_MAP,texture); // call before glTexParameteri
				
			glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE);
			glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE);
			glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_WRAP_R,GL_CLAMP_TO_EDGE);
			glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_MIN_FILTER,GL_NEAREST);
			glTexParameteri(GL_TEXTURE_CUBE_MAP,GL_TEXTURE_MAG_FILTER,GL_NEAREST);
				
			glEnable(GL_TEXTURE_GEN_S);
			glEnable(GL_TEXTURE_GEN_T);
			glEnable(GL_TEXTURE_GEN_R);
			//glEnable(GL_TEXTURE_GEN_Q)
			if(tex_cube_mode==1){
				glTexGeni(GL_S,GL_TEXTURE_GEN_MODE,GL_REFLECTION_MAP);
				glTexGeni(GL_T,GL_TEXTURE_GEN_MODE,GL_REFLECTION_MAP);
				glTexGeni(GL_R,GL_TEXTURE_GEN_MODE,GL_REFLECTION_MAP);
			}
				
			if(tex_cube_mode==2){
				glTexGeni(GL_S,GL_TEXTURE_GEN_MODE,GL_NORMAL_MAP);
				glTexGeni(GL_T,GL_TEXTURE_GEN_MODE,GL_NORMAL_MAP);
				glTexGeni(GL_R,GL_TEXTURE_GEN_MODE,GL_NORMAL_MAP);
			}
			DisableCubeSphereMapping=1;
		}
		else if (DisableCubeSphereMapping!=0){

			glDisable(GL_TEXTURE_CUBE_MAP);
				
			// only disable tex gen s and t if sphere mapping isn't using them
			if((tex_flags&64)==0){
				glDisable(GL_TEXTURE_GEN_S);
				glDisable(GL_TEXTURE_GEN_T);
			}
				
			glDisable(GL_TEXTURE_GEN_R);
			//glDisable(GL_TEXTURE_GEN_Q)

		}
			
		switch(tex_blend){
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

		glEnableClientState(GL_TEXTURE_COORD_ARRAY);

		if (surf!=0) {
			if (is3D==0){

				if(surf->vbo_enabled==true && surf->no_tris>=Global::vbo_min_tris){
			
					if(tex_coords==0){
						glBindBuffer(GL_ARRAY_BUFFER,surf->vbo_id[1]);
						glTexCoordPointer(2,GL_FLOAT,0,NULL);
					}else{
						glBindBuffer(GL_ARRAY_BUFFER,surf->vbo_id[2]);
						glTexCoordPointer(2,GL_FLOAT,0,NULL);
					}
				
				}else{
			
					if(tex_coords==0){
						//glBindBufferARB(GL_ARRAY_BUFFER_ARB,0) already reset above
						glTexCoordPointer(2,GL_FLOAT,0,&surf->vert_tex_coords0[0]);
					}else{
						//glBindBufferARB(GL_ARRAY_BUFFER_ARB,0)
						glTexCoordPointer(2,GL_FLOAT,0,&surf->vert_tex_coords1[0]);
					}

				}

			}else{
				if(surf->vbo_enabled==true && surf->no_tris>=Global::vbo_min_tris){
			
					glBindBuffer(GL_ARRAY_BUFFER,surf->vbo_id[2]);
					glTexCoordPointer(3,GL_FLOAT,0,NULL);
				
				}else{
			
					//glBindBufferARB(GL_ARRAY_BUFFER_ARB,0)
					glTexCoordPointer(3,GL_FLOAT,0,&surf->vert_tex_coords1[0]);

				}
			}
		}else{
			vector<float>&Vertices=*vertices;
			glTexCoordPointer(2, GL_FLOAT, 8*sizeof(float), &Vertices[6]);
		}

							
		// reset texture matrix
		glMatrixMode(GL_TEXTURE);
		glLoadIdentity();
					
		if(tex_u_pos!=0.0 || tex_v_pos!=0.0){
			glTranslatef(tex_u_pos,tex_v_pos,0.0);
		}
		if(tex_ang!=0.0){
			glRotatef(tex_ang,0.0,0.0,1.0);
		}
		if(tex_u_scale!=1.0 || tex_v_scale!=1.0){
			glScalef(tex_u_scale,tex_v_scale,1.0);
		}

		// ***!ES***
		// if spheremap flag=true then flip tex
		if(tex_flags&64){
			glScalef(1.0,-1.0,-1.0);
		}
			
		// if cubemap flag=true then manipulate texture matrix so that cubemap is displayed properly 
		if(tex_flags&128){

			glScalef(1.0,-1.0,-1.0);
				
			// get current modelview matrix (set in last camera update)
			float mod_mat[16];
			glGetFloatv(GL_MODELVIEW_MATRIX,&mod_mat[0]);
			// get rotational inverse of current modelview matrix
			Matrix new_mat;
			new_mat.LoadIdentity();
					
			new_mat.grid[0][0] = mod_mat[0];
			new_mat.grid[1][0] = mod_mat[1];
			new_mat.grid[2][0] = mod_mat[2];

			new_mat.grid[0][1] = mod_mat[4];
			new_mat.grid[1][1] = mod_mat[5];
			new_mat.grid[2][1] = mod_mat[6];

			new_mat.grid[0][2] = mod_mat[8];
			new_mat.grid[1][2] = mod_mat[9];
			new_mat.grid[2][2] = mod_mat[10];
				
			glMultMatrixf(&new_mat.grid[0][0]);
		}

		No_samplers++;
#else
		glBindTexture(GL_TEXTURE_2D,texture); // call before glTexParameteri
#endif

						
	}
	

}
	
void Shader::TurnOff(){
	ProgramAttriEnd();
#ifndef GLES2
	for (int ix=0; ix<No_samplers; ix++){
		int slot=ix, is3D=0;
		if (Shader_Tex[ix] != 0) {
			is3D=Shader_Tex[ix]->is3D;
			slot=Shader_Tex[ix]->Slot;
		}

		glActiveTexture(GL_TEXTURE0+slot);
		glClientActiveTexture(GL_TEXTURE0+slot);
				
		// reset texture matrix
		glMatrixMode(GL_TEXTURE);
		glLoadIdentity();

		//glDisableClientState(GL_TEXTURE_COORD_ARRAY);

		if (is3D==0){
			glDisable(GL_TEXTURE_2D);
		}else{
			glDisable(GL_TEXTURE_3D);
		}
				
		glDisable(GL_TEXTURE_CUBE_MAP);
		glDisable(GL_TEXTURE_GEN_S);
		glDisable(GL_TEXTURE_GEN_T);
		glDisable(GL_TEXTURE_GEN_R);
			
	}
	No_samplers=0;
#endif
	for (unsigned int i=0;i<Parameters.size();i++){
		switch(Parameters[i].type){
		case USE_SURFACE:
			if (arb_program !=0){	
				//int loc= glGetAttribLocation(arb_program->Program, Parameters[i].name.c_str());
				//glDisableVertexAttribArray(loc);
				glDisableVertexAttribArray(Parameters[i].name);
			}
			break;
		case USE_FUNCTION:
			if (Parameters[i].Disable!=0){
				Parameters[i].Disable();
			}
			break;
		}
	}


}
		

/*	Method AddShader(_vert:String = Null , _frag:String = Null)
'		If arb_program = Null Then Return
'		Local Vert:TShaderObject
'		Local Frag:TShaderObject
'		
'		If _Vert <> Null Then 
'			Vert = TGlobal.RenderInterface.CreateVertexShaderObj(arb_program.languageType,_vert,arb_program)
'			arb_program.attachVertShader(Vert)
'		EndIf
'		
'		If _frag <> Null Then 
'			frag = TGlobal.RenderInterface.CreatePixelShaderObj(arb_program.languageType,_frag,arb_program)
'			arb_program.attachFragShader(frag)
'		EndIf
'	End Method*/
	
int Shader::AddShader(string shaderFilename, int shadertype){
	if (arb_program == 0) return 0;
	
	if (shaderFilename != ""){
		ShaderObject* myShader = ShaderObject::CreateShader(shaderFilename, shadertype);
		if (myShader!=0) {
			glAttachShader(arb_program->Program, myShader->ShaderObj);
			
			//Add this ShaderObject to this ProgramObjects list
			switch (shadertype){
				case GL_VERTEX_SHADER : arb_program->vList.push_back(myShader);
				break;
				case GL_FRAGMENT_SHADER : arb_program->fList.push_back(myShader);
				break;
				case GL_GEOMETRY_SHADER : arb_program->gList.push_back(myShader);
				break;
			}
			
			//Add this ProgramObject to this Shaders 'attached to' list
			myShader->Attached.push_back(arb_program);

			return 1; // success
		}
	}
	return 0;	
}
	
int Shader::AddShaderFromString(string shaderFilename, int shadertype){
	if (arb_program == 0) return 0;
		
	ShaderObject* myShader = ShaderObject::CreateShaderFromString(shaderFilename, shadertype);
	if (myShader!=0) {
		glAttachShader(arb_program->Program, myShader->ShaderObj);
		
		//Add this ShaderObject to this ProgramObjects list
		switch (shadertype){
			case GL_VERTEX_SHADER : arb_program->vList.push_back(myShader);
			break;
			case GL_FRAGMENT_SHADER : arb_program->fList.push_back(myShader);
			break;
			case GL_GEOMETRY_SHADER : arb_program->gList.push_back(myShader);
			break;
		}
		
		//Add this ProgramObject to this Shaders 'attached to' list
		myShader->Attached.push_back(arb_program);
		
		return 1; // success
	}
	return 0;
}

// Link a Shader to this ProgramObject
int Shader::Link(){
	glLinkProgram(arb_program->Program);

	/*-------------------------------
	'Check if it Linked successfully
	'------------------------------*/
	int linked;
	glValidateProgram(arb_program->Program);
	glGetProgramiv(arb_program->Program, GL_LINK_STATUS, &linked);
	/*if (Vert!=0) {
		glDetachShader(arb_program->Program, Vert);
	}
	if (Frag!=0) {
		glDetachShader(arb_program->Program, Frag);
	}*/

	if (linked==0){
		int maxLength = 0; // maxLength includes the NULL character
		glGetProgramiv(arb_program->Program, GL_INFO_LOG_LENGTH, &maxLength);
		
		vector<char> infoLog(maxLength);
		glGetProgramInfoLog(arb_program->Program, maxLength, &maxLength, &infoLog[0]);
#ifdef OPENB3D_DEBUG
		if (arb_program->fList.size()!=0){
			ShaderObject* obj=arb_program->fList.front();
			DebugLog("%s; %s",obj->shaderName.c_str(),&infoLog[0]);
		}
#endif
		glDeleteProgram(arb_program->Program); // The program is useless now
		
		return 0; // fail
	}

	arb_program->RefreshTypeMap();
	return 1; // success
}


Texture* Shader::AddSampler(string Name, int Slot, Texture* Tex, int is3D){
	if (Tex!=0) {
		Shader_Tex[Slot] = Sampler::Create(Slot,Tex);
		//UpdateSampler = 1;
		SetInteger(Name, Slot);
		Shader_Tex[Slot]->is3D=is3D;
	}
	texCount++;
	return Shader_Tex[Slot]->texture;
}


void Shader::ProgramAttriBegin(){
	if (arb_program !=0){
		if (this==Global::ambient_shader){
			if (default_program==arb_program->Program) return;
			default_program=arb_program->Program;
		}
		arb_program->Activate();
	}
}	

void Shader::ProgramAttriEnd(){
	if (arb_program !=0){
		if (default_program==arb_program->Program) return;
		arb_program->DeActivate();
	}
}	

void Shader::SetFloat(string name, float v1){
	if (arb_program !=0){
		if (arb_program->TypeMap.find(name) == arb_program->TypeMap.end() ){
			return;
		}
		int ParameterType=arb_program->TypeMap.find(name)->second;

		ProgramAttriBegin();
		if (ParameterType == 1){		//"Uniform" 
			int loc= glGetUniformLocation(arb_program->Program, name.c_str());
			glUniform1f(loc, v1);
			
		} else if (ParameterType == 2){		//"Attribute"
	 
			int loc= glGetAttribLocation(arb_program->Program, name.c_str());
			glVertexAttrib1f(loc, v1);

		}
		ProgramAttriEnd();
	}
}

void Shader::SetFloat2(string name, float v1, float v2){
	if (arb_program !=0){
		if (arb_program->TypeMap.find(name) == arb_program->TypeMap.end() ){
			return;
		}
		int ParameterType=arb_program->TypeMap.find(name)->second;

		ProgramAttriBegin();
		if (ParameterType == 1){		//"Uniform" 
			int loc= glGetUniformLocation(arb_program->Program, name.c_str());
			glUniform2f(loc, v1, v2);
			
		} else if (ParameterType == 2){		//"Attribute"
	 
			int loc= glGetAttribLocation(arb_program->Program, name.c_str());
			glVertexAttrib2f(loc, v1, v2);

		}
		ProgramAttriEnd();
	}
}

void Shader::SetFloat3(string name, float v1, float v2, float v3){
	if (arb_program !=0){
		if (arb_program->TypeMap.find(name) == arb_program->TypeMap.end() ){
			return;
		}
		int ParameterType=arb_program->TypeMap.find(name)->second;

		ProgramAttriBegin();
		if (ParameterType == 1){		//"Uniform" 
			int loc= glGetUniformLocation(arb_program->Program, name.c_str());
			glUniform3f(loc, v1, v2, v3);
			
		} else if (ParameterType == 2){		//"Attribute"
	 
			int loc= glGetAttribLocation(arb_program->Program, name.c_str());
			glVertexAttrib3f(loc, v1, v2, v3);

		}
		ProgramAttriEnd();
	}
}

void Shader::SetFloat4(string name, float v1, float v2, float v3, float v4){
	if (arb_program !=0){
		if (arb_program->TypeMap.find(name) == arb_program->TypeMap.end() ){
			return;
		}
		int ParameterType=arb_program->TypeMap.find(name)->second;

		ProgramAttriBegin();
		if (ParameterType == 1){		//"Uniform" 
			int loc= glGetUniformLocation(arb_program->Program, name.c_str());
			glUniform4f(loc, v1, v2, v3, v4);
			
		} else if (ParameterType == 2){		//"Attribute"
	 
			int loc= glGetAttribLocation(arb_program->Program, name.c_str());
			glVertexAttrib4f(loc, v1, v2, v3, v4);

		}
		ProgramAttriEnd();
	}
}

void Shader::UseFloat(string name, float* v1){
	if (arb_program->TypeMap.find(name) == arb_program->TypeMap.end() ){
		return;
	}
	int ParameterType=arb_program->TypeMap.find(name)->second;

	ShaderData data;
	if (ParameterType == 1){		//"Uniform" 
		data.name=glGetUniformLocation(arb_program->Program, name.c_str());
		data.type=USE_FLOAT_1_UNI;
	} else if (ParameterType == 2){		//"Attribute"
		data.name=glGetAttribLocation(arb_program->Program, name.c_str());
		data.type=USE_FLOAT_1_ATT;
	}
	data.fp[0]=v1;
	Parameters.push_back(data);
}

void Shader::UseFloat2(string name, float* v1, float* v2){
	if (arb_program->TypeMap.find(name) == arb_program->TypeMap.end() ){
		return;
	}
	int ParameterType=arb_program->TypeMap.find(name)->second;

	ShaderData data;
	if (ParameterType == 1){		//"Uniform" 
		data.name=glGetUniformLocation(arb_program->Program, name.c_str());
		data.type=USE_FLOAT_2_UNI;
	} else if (ParameterType == 2){		//"Attribute"
		data.name=glGetAttribLocation(arb_program->Program, name.c_str());
		data.type=USE_FLOAT_2_ATT;
	}
	data.fp[0]=v1;
	data.fp[1]=v2;
	Parameters.push_back(data);
}

void Shader::UseFloat3(string name, float* v1, float* v2, float* v3){
	if (arb_program->TypeMap.find(name) == arb_program->TypeMap.end() ){
		return;
	}
	int ParameterType=arb_program->TypeMap.find(name)->second;

	ShaderData data;
	if (ParameterType == 1){		//"Uniform" 
		data.name=glGetUniformLocation(arb_program->Program, name.c_str());
		data.type=USE_FLOAT_3_UNI;
	} else if (ParameterType == 2){		//"Attribute"
		data.name=glGetAttribLocation(arb_program->Program, name.c_str());
		data.type=USE_FLOAT_3_ATT;
	}
	data.fp[0]=v1;
	data.fp[1]=v2;
	data.fp[2]=v3;
	Parameters.push_back(data);
}

void Shader::UseFloat4(string name, float* v1, float* v2, float* v3, float* v4){
	if (arb_program->TypeMap.find(name) == arb_program->TypeMap.end() ){
		return;
	}
	int ParameterType=arb_program->TypeMap.find(name)->second;

	ShaderData data;
	if (ParameterType == 1){		//"Uniform" 
		data.name=glGetUniformLocation(arb_program->Program, name.c_str());
		data.type=USE_FLOAT_4_UNI;
	} else if (ParameterType == 2){		//"Attribute"
		data.name=glGetAttribLocation(arb_program->Program, name.c_str());
		data.type=USE_FLOAT_4_ATT;
	}
	data.fp[0]=v1;
	data.fp[1]=v2;
	data.fp[2]=v3;
	data.fp[3]=v4;
	Parameters.push_back(data);
}

void Shader::SetInteger(string name, int v1){
	if (arb_program !=0){
		ProgramAttriBegin();
		int loc= glGetUniformLocation(arb_program->Program, name.c_str());
		glUniform1i(loc,v1);
		ProgramAttriEnd();
	}
}

void Shader::SetInteger2(string name, int v1, int v2){
	if (arb_program !=0){
		ProgramAttriBegin();
		int loc= glGetUniformLocation(arb_program->Program, name.c_str());
		glUniform2i(loc,v1,v2);
		ProgramAttriEnd();
	}
}

void Shader::SetInteger3(string name, int v1, int v2, int v3){
	if (arb_program !=0){
		ProgramAttriBegin();
		int loc= glGetUniformLocation(arb_program->Program, name.c_str());
		glUniform3i(loc,v1,v2,v3);
		ProgramAttriEnd();
	}
}

void Shader::SetInteger4(string name, int v1, int v2, int v3, int v4){
	if (arb_program !=0){
		ProgramAttriBegin();
		int loc= glGetUniformLocation(arb_program->Program, name.c_str());
		glUniform4i(loc,v1,v2,v3,v4);
		ProgramAttriEnd();
	}
}

void Shader::UseInteger(string name, int* v1){
	ShaderData data;
	data.name=glGetUniformLocation(arb_program->Program, name.c_str());
	data.type=USE_INTEGER_1;
	data.ip[0]=v1;
	Parameters.push_back(data);
}

void Shader::UseInteger2(string name, int* v1, int* v2){
	ShaderData data;
	data.name=glGetUniformLocation(arb_program->Program, name.c_str());
	data.type=USE_INTEGER_2;
	data.ip[0]=v1;
	data.ip[1]=v2;
	Parameters.push_back(data);
}

void Shader::UseInteger3(string name, int* v1, int* v2, int* v3){
	ShaderData data;
	data.name=glGetUniformLocation(arb_program->Program, name.c_str());
	data.type=USE_INTEGER_3;
	data.ip[0]=v1;
	data.ip[1]=v2;
	data.ip[2]=v3;
	Parameters.push_back(data);
}

void Shader::UseInteger4(string name, int* v1, int* v2, int* v3, int* v4){
	ShaderData data;
	data.name=glGetUniformLocation(arb_program->Program, name.c_str());
	data.type=USE_INTEGER_4;
	data.ip[0]=v1;
	data.ip[1]=v2;
	data.ip[2]=v3;
	data.ip[3]=v4;
	Parameters.push_back(data);
}



void Shader::UseSurface(string name, Surface* surf, int vbo){
	ShaderData data;
	data.name=glGetAttribLocation(arb_program->Program, name.c_str());
	data.type=USE_SURFACE;
	data.surf=surf;
	data.vbo=vbo;
	Parameters.push_back(data);
}

void Shader::UseMatrix(string name, int mode){
	ShaderData data;
	data.name=glGetUniformLocation(arb_program->Program, name.c_str());
	if (mode==0) {		//model matrix
		data.type=USE_MODEL_MATRIX;
	}else if(mode==1){	//view matrix
		data.type=USE_VIEW_MATRIX;
	}else if(mode==2){	//projection matrix
		data.type=USE_PROJ_MATRIX;
	}else if(mode==3){	//modelview matrix
		data.type=USE_MODELVIEW_MATRIX;
	}
	Parameters.push_back(data);
}

void Shader::UseEntity(string name, Entity* ent, int mode){
	ShaderData data;
	data.name=glGetUniformLocation(arb_program->Program, name.c_str());
	if (mode==0) {		//model matrix
		data.type=USE_ENTITY_MATRIX;
	}else if(mode==1){	//view matrix
		data.type=USE_ENTITY_INVERSE_MATRIX;
	}
	data.ent=ent;
	Parameters.push_back(data);
}

void Shader::UseFunction(void (*Enable)(void), void (*Disable)(void)){
	ShaderData data;
	data.type=USE_FUNCTION;
	data.Enable=Enable;
	data.Disable=Disable;
	Parameters.push_back(data);
}



//ShaderObject

ProgramObject* ProgramObject::Create(string name){
	ProgramObject* p = new ProgramObject;
		
	//Create a new GL ProgramObject
	p->Program = glCreateProgram();
	if (p->Program == 0){
		delete p;
		p = 0;
		return 0;
	}
		
	/*--------------------------------
	'The amount of Vert & Frag Shaders
	'attached to this Program Object
	'---------------------------------*/
	
	/*--------------------------------------
	'These lists contain any Vert or Frag
	'Shader Objects Attached to this Program
	'-------------------------------------
	p->vList:TList = CreateList();
	p->fList:TList = CreateList();*/
	
	//This Program Objects Name
	p->progName = name;
		
	/*-----------------------------
	'Add this Program Object to the
	'Global list of ProgramObjects
	'------------------------------*/
	ProgramObjectList.push_back(p);
	return p;
}

void ProgramObject::Activate(){
	glUseProgram(Program);
}

void ProgramObject::DeActivate(){
	glUseProgram(default_program);
}

void ProgramObject::RefreshTypeMap(){
	TypeMap.clear();
		
	int maxlen;
	int count;
		 
	glGetProgramiv( Program,GL_ACTIVE_UNIFORM_MAX_LENGTH ,&maxlen);
	glGetProgramiv( Program,GL_ACTIVE_UNIFORMS ,&count);
	char* name=new char[maxlen+1];
	for (int i=0;i<count; i++){
		int glsize;
		GLenum gltype;
		glGetActiveUniform (Program,i,maxlen,0,&glsize,&gltype,name);
		TypeMap[name]=1;//"Uniform"
	}
	delete [] name;

	glGetProgramiv( Program,GL_ACTIVE_ATTRIBUTE_MAX_LENGTH ,&maxlen);
	glGetProgramiv( Program,GL_ACTIVE_ATTRIBUTES ,&count);
	name=new char[maxlen+1];
	for (int i=0;i<count; i++){
		int glsize;
		GLenum gltype;
		glGetActiveAttrib(Program,i,maxlen,0,&glsize,&gltype,name);
		TypeMap[name]=2;//"Attribute"
	}
	delete [] name;
		
		
}

// Get the Uniform Variable Location from a ProgramObject
int ProgramObject::GetUniLoc(string name){
	return glGetUniformLocation(Program, name.c_str());
}

// Get the Attribute Variable Location from a ProgramObject
int ProgramObject::GetAttribLoc(string name){
	return glGetAttribLocation(Program, name.c_str());
}

#ifndef GLES2
void ProgramObject::SetParameter1S(int name, float v1){
	int loc= name;
//	int loc= glGetAttribLocation(Program, name.c_str());
	glVertexAttrib1s(loc, v1);
}
	
void ProgramObject::SetParameter2S(int name, float v1, float v2) {
		int loc= name;
//	int loc= glGetAttribLocation(Program, name.c_str());
	glVertexAttrib2s(loc, v1,v2);
}
	 
void ProgramObject::SetParameter3S(int name, float v1, float v2, float v3){
	int loc= name;
//	int loc= glGetAttribLocation(Program, name.c_str());
	glVertexAttrib3s(loc, v1,v2,v3);
}
	  
void ProgramObject::SetParameter4S(int name, float v1, float v2, float v3, float v4){
	int loc= name;
//	int loc= glGetAttribLocation(Program, name.c_str());
	glVertexAttrib4s(loc, v1,v2,v3,v4);
}
#endif
	
//------------------------------------------------------------
// Int Parameter
	
void ProgramObject::SetParameter1I(int name, int v1){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniform1i(loc,v1);
}

void ProgramObject::SetParameter2I(int name, int v1, int v2){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniform2i(loc,v1,v2);
}

void ProgramObject::SetParameter3I(int name, int v1, int v2, int v3){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniform3i(loc,v1,v2,v3);
}

void ProgramObject::SetParameter4I(int name, int v1, int v2, int v3, int v4){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniform4i(loc,v1,v2,v3,v4);
}
	
//----------------------------------------------------------------------------------
// Int Vectors

void ProgramObject::SetVector1I(int name, int* v1){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniform1iv(loc,1,v1);
}
				
void ProgramObject::SetVector2I(int name, int* v1){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniform2iv(loc,1,v1);
}
										
void ProgramObject::SetVector3I(int name, int* v1){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniform3iv(loc,1,v1);
}
										
void ProgramObject::SetVector4I(int name, int* v1){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniform4iv(loc,1,v1);
}
				
#ifndef GLES2
//-------------------------------------------------------------------------------------
// Double Parameter ( automatically Attributes, because Uniform doubles does not exist)
	
void ProgramObject::SetParameter1D(int name, double v1){
	int loc= name;
//	int loc= glGetAttribLocation(Program, name.c_str());
	glVertexAttrib1d(loc, v1);
}
	 
void ProgramObject::SetParameter2D(int name, double v1, double v2){
	int loc= name;
//	int loc= glGetAttribLocation(Program, name.c_str());
	glVertexAttrib2d(loc, v1, v2);
}
	 
void ProgramObject::SetParameter3D(int name, double v1, double v2, double v3){
	int loc= name;
//	int loc= glGetAttribLocation(Program, name.c_str());
	glVertexAttrib3d(loc, v1, v2, v3);
}
	 
void ProgramObject::SetParameter4D(int name, double v1, double v2, double v3, double v4){
	int loc= name;
//	int loc= glGetAttribLocation(Program, name.c_str());
	glVertexAttrib4d(loc, v1, v2, v3, v4);
}
#endif


//-------------------------------------------------------------------------------------
// Array Parameter

void ProgramObject::SetParameterArray(int name, Surface* surf, int vbo){
	int loc= name;

	if(surf->vbo_enabled!=0){
		surf->reset_vbo=vbo;

		Surface& surf2=*surf;
		glBindBuffer(GL_ARRAY_BUFFER,0);
		switch (vbo){
		case 1:
			glBindBuffer(GL_ARRAY_BUFFER,surf2.vbo_id[0]);
			glVertexAttribPointer(loc, 3, GL_FLOAT, GL_FALSE, 0, 0);
			break;
		case 2:
			glBindBuffer(GL_ARRAY_BUFFER,surf2.vbo_id[1]);
			glVertexAttribPointer(loc, 2, GL_FLOAT, GL_FALSE, 0, 0);
			break;
		case 3:
			glBindBuffer(GL_ARRAY_BUFFER,surf2.vbo_id[2]);
			glVertexAttribPointer(loc, 2, GL_FLOAT, GL_FALSE, 0, 0);
			break;
		case 4:
			glBindBuffer(GL_ARRAY_BUFFER,surf2.vbo_id[3]);
			glVertexAttribPointer(loc, 3, GL_FLOAT, GL_FALSE, 0, 0);
			break;
		case 5:
			glBindBuffer(GL_ARRAY_BUFFER,surf2.vbo_id[4]);
			glVertexAttribPointer(loc, 3, GL_FLOAT, GL_FALSE, 16, 0);
			break;

		case 6:
			glBindBuffer(GL_ARRAY_BUFFER,surf2.vbo_id[4]);
			glVertexAttribPointer(loc, 4, GL_FLOAT, GL_FALSE, 0, 0);
			break;
		}

	}else{
		Surface& surf2=*surf;
		glBindBuffer(GL_ARRAY_BUFFER,0);
		switch (vbo){
		case 1:
			glVertexAttribPointer(loc, 3, GL_FLOAT, GL_FALSE, 0, &surf2.vert_coords[0]);
			break;
		case 2:
			glVertexAttribPointer(loc, 2, GL_FLOAT, GL_FALSE, 0, &surf2.vert_tex_coords0[0]);
			break;
		case 3:
			glVertexAttribPointer(loc, 2, GL_FLOAT, GL_FALSE, 0, &surf2.vert_tex_coords1[0]);
			break;
		case 4:
			glVertexAttribPointer(loc, 3, GL_FLOAT, GL_FALSE, 0, &surf2.vert_norm[0]);
			break;
		case 5:
			glVertexAttribPointer(loc, 3, GL_FLOAT, GL_FALSE, 16, &surf2.vert_col[0]);
			break;

		case 6:
			glVertexAttribPointer(loc, 4, GL_FLOAT, GL_FALSE, 0, &surf2.vert_col[0]);
			break;
		}
	}

	glEnableVertexAttribArray(loc);
}

void ProgramObject::SetParameterArray(int name, vector<float>* verticesPtr, int vbo){
#ifndef GLES2
	vector<float>&vertices=*verticesPtr;
	int loc= name;

	//special case, terrain surface
	glBindBuffer(GL_ARRAY_BUFFER,0);
	switch (vbo){
	case 1:
		glVertexAttribPointer(loc, 3, GL_FLOAT, GL_FALSE, 8*sizeof(float), &vertices[0]);
		break;
	case 2:
	case 3:
		glVertexAttribPointer(loc, 2, GL_FLOAT, GL_FALSE, 8*sizeof(float), &vertices[6]);
		break;
	case 4:
		glVertexAttribPointer(loc, 3, GL_FLOAT, GL_FALSE, 8*sizeof(float), &vertices[3]);
		break;
	}
	glEnableVertexAttribArray(loc);
	return;
#else
	int loc= name;

	switch (vbo){
	case 1:
		glVertexAttribPointer(loc, 3, GL_FLOAT, GL_FALSE, 8*sizeof(float), (GLvoid*)(0));
		break;
	case 2:
	case 3:
		glVertexAttribPointer(loc, 2, GL_FLOAT, GL_FALSE, 8*sizeof(float), (GLvoid*)(6*sizeof(float)));
		break;
	case 4:
		glVertexAttribPointer(loc, 3, GL_FLOAT, GL_FALSE, 8*sizeof(float), (GLvoid*)(3*sizeof(float)));
		break;
	}
	glEnableVertexAttribArray(loc);
	return;
#endif
}


//-------------------------------------------------------------------------------------
// Float Parameter

void ProgramObject::SetParameter1F(int name, int ParameterType, float v){
	
	if (ParameterType == 1){		//"Uniform" 
		int loc= name;
//		int loc= glGetUniformLocation(Program, name.c_str());
		glUniform1f(loc, v);
			
	} else if (ParameterType == 2){		//"Attribute"
 
		int loc= name;
//		int loc= glGetAttribLocation(Program, name.c_str());
		glVertexAttrib1f(loc, v);

	}
		
}

void ProgramObject::SetParameter2F(int name, int ParameterType, float v1, float v2){
	
	if (ParameterType == 1){		//"Uniform" 
		int loc= name;
//		int loc= glGetUniformLocation(Program, name.c_str());
		glUniform2f(loc, v1, v2);
			
	} else if (ParameterType == 2){		//"Attribute"
 
		int loc= name;
//		int loc= glGetAttribLocation(Program, name.c_str());
		glVertexAttrib2f(loc, v1, v2);

	}

}

void ProgramObject::SetParameter3F(int name, int ParameterType, float v1, float v2, float v3){
		
	if (ParameterType == 1){		//"Uniform" 
		int loc= name;
//		int loc= glGetUniformLocation(Program, name.c_str());
		glUniform3f(loc, v1,v2,v3);
			
	} else if (ParameterType == 2){		//"Attribute"
 
		int loc= name;
//		int loc= glGetAttribLocation(Program, name.c_str());
		glVertexAttrib3f(loc, v1, v2, v3);

	}
}

void ProgramObject::SetParameter4F(int name, int ParameterType, float v1, float v2, float v3, float v4){
		
	if (ParameterType == 1){		//"Uniform" 
		int loc= name;
//		int loc= glGetUniformLocation(Program, name.c_str());
		glUniform4f(loc, v1,v2,v3,v4);
			
	} else if (ParameterType == 2){		//"Attribute"
 
		int loc= name;
//		int loc= glGetAttribLocation(Program, name.c_str());
		glVertexAttrib4f(loc, v1, v2, v3,v4);

	}
}

//---------------------------------------------------------------------------------------------------
// Float Vectors


void ProgramObject::SetVector1F(int name, float* v1){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniform1fv(loc,1,v1);
}

void ProgramObject::SetVector2F(int name, float* v1){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniform2fv(loc,1,v1);
}

void ProgramObject::SetVector3F(int name, float* v1){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniform3fv(loc,1,v1);
}

void ProgramObject::SetVector4F(int name, float* v1){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniform4fv(loc,1,v1);
}


//--------------------------------------------------------------------------------------------------
// Matrices

void ProgramObject::SetMatrix2F(int name, float* m){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniformMatrix2fv(loc, 1 , 0, m );
} 

void ProgramObject::SetMatrix3F(int name, float* m){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniformMatrix3fv(loc, 1 , 0, m );	
}

void ProgramObject::SetMatrix4F(int name, float* m){
	int loc= name;
//	int loc= glGetUniformLocation(Program, name.c_str());
	glUniformMatrix4fv(loc, 1 , 0, m );
}

// Like AddShader but without CreateShader
void ProgramObject::AttachShader(ShaderObject* myShader, int shadertype){

	if (myShader!=0) {
		glAttachShader(Program, myShader->ShaderObj);
		
		//Add this ShaderObject to this ProgramObjects list
		switch (shadertype){
			case GL_VERTEX_SHADER : vList.push_back(myShader);
			break;
			case GL_FRAGMENT_SHADER : fList.push_back(myShader);
			break;
			case GL_GEOMETRY_SHADER : gList.push_back(myShader);
			break;
		}
				
		//Add this ProgramObject to this Shaders 'attached to' list
		myShader->Attached.push_back(this);
	}
}

// Detach a shader:tShaderObject from a tProgramObject
void ProgramObject::DetachShader(ShaderObject* myShader, int shadertype){
	list<ShaderObject*>::iterator it;

	//Add this ShaderObject to this ProgramObjects list
	switch (shadertype){
		case GL_VERTEX_SHADER :
			for(it=vList.begin();it!=vList.end();it++){
				if (myShader==*it){
					glDetachShader(Program, myShader->ShaderObj);
					//vList.remove(myShader);
					myShader->Attached.remove(this);
					break;
				}
			}
			break;
		case GL_FRAGMENT_SHADER :
			for(it=fList.begin();it!=fList.end();it++){
				if (myShader==*it){
					glDetachShader(Program, myShader->ShaderObj);
					//fList.remove(myShader);
					myShader->Attached.remove(this);
					break;
				}
			}
			break;
		case GL_GEOMETRY_SHADER :
			for(it=gList.begin();it!=gList.end();it++){
				if (myShader==*it){
					glDetachShader(Program, myShader->ShaderObj);
					//gList.remove(myShader);
					myShader->Attached.remove(this);
					break;
				}
			}
			break;
	}
	
}

void CopyPixels (unsigned char *src, unsigned int srcWidth, unsigned int srcHeight, unsigned int srcX, unsigned int srcY, unsigned char *dst, unsigned int dstWidth, unsigned int dstHeight, unsigned int bytesPerPixel);


Material* Material::LoadMaterial(string filename,int flags, int frame_width,int frame_height,int first_frame,int frame_count){

	filename=File::ResourceFilePath(filename);

	/*if (filename==""){
		cout << "Error: Cannot Find Texture: " << filename << endl;
		return NULL;
	}*/

	Material* tex=new Material();
	tex->file=filename;

	// set tex.flags before TexInList
	tex->flags=flags;
	tex->FilterFlags();

	/*// check to see if texture with same properties exists already, if so return existing texture
	Texture* old_tex=tex->TexInList();
	if(old_tex){
		return old_tex;
	}else{
		tex_list.push_back(tex);
	}*/

	//const char* c_filename_left=filename_left.c_str();
	//const char* c_filename_right=filename_right.c_str();


	unsigned char* buffer;

	buffer=stbi_load(filename.c_str(),&tex->width,&tex->height,0,4);

	unsigned int name;

#ifndef GLES2
	glGenTextures (1,&name);
	glBindTexture (GL_TEXTURE_3D,name);

	tex->no_frames=frame_count;
	//tex->frames=new unsigned int[frame_count];

	unsigned char* dstbuffer=new unsigned char[frame_width*frame_height*4*frame_count];

	glGenTextures (1,&name);
	glBindTexture (GL_TEXTURE_3D,name);


	//tex.gltex=tex.gltex[..tex.no_frames]

	int frames_in_row=tex->width/frame_width;

	for (int i=0;i<frame_count;i++){
		CopyPixels (buffer,tex->width, tex->height,frame_width*(i%frames_in_row), frame_height*(i/frames_in_row),
		dstbuffer+i*(frame_width * frame_height * 4), frame_width, frame_height, 4);


	}

	glTexParameteri(GL_TEXTURE_3D, GL_GENERATE_MIPMAP, GL_TRUE);
	glTexImage3D(GL_TEXTURE_3D, 0, GL_RGBA,frame_width, frame_height, frame_count, 0, GL_RGBA, GL_UNSIGNED_BYTE, dstbuffer);

	tex->texture=name;
	tex->width=frame_width;
	tex->height=frame_height;
	delete dstbuffer;
#else
	glGenTextures (1,&name);
	glBindTexture (GL_TEXTURE_2D,name);

	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, tex->width, tex->height, 0, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	glGenerateMipmap(GL_TEXTURE_2D);
	tex->texture=name;
	tex->no_frames=tex->width/frame_width;
	tex->width=frame_width;
	tex->height=frame_height;
#endif
	stbi_image_free(buffer);


	return tex;

}

