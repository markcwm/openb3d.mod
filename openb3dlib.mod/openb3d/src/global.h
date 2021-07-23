/*
 *  global.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef GLOBAL_H
#define GLOBAL_H

#include "pivot.h"
#include "mesh.h"

#ifndef GL_FRAGMENT_SHADER
#define GL_FRAGMENT_SHADER 0x8B30
#endif

#ifndef GL_VERTEX_SHADER
#define GL_VERTEX_SHADER 0x8B31
#endif

#ifndef GL_GEOMETRY_SHADER
#define GL_GEOMETRY_SHADER 0x8DD9
#endif

#ifndef GL_MULTISAMPLE
#define GL_MULTISAMPLE 0x809D
#endif

class Camera;

class Global{

public:

	static int width,height,mode,depth,rate;
	static float ambient_red,ambient_green,ambient_blue;
	static Shader* ambient_shader;
	static int cubemap_face[12],cubemap_frame[12],flip_cubemap;
#ifdef GLES2
#define GLuint unsigned int
	struct Program{
		//static GLuint ambient_current_program;
		GLuint ambient_program;

		GLuint vposition;
		GLuint vnormal;
		GLuint tex_coords;
		GLuint tex_coords2;
		GLuint color;
		GLuint shininess;

		GLuint model;
		GLuint view;
		GLuint proj;

		GLuint texflag;
		GLuint texmat;
		GLuint tex_coords_set;

		GLuint amblight;

		GLuint lightMat;
		GLuint lightType;
		GLuint lightOuterCone;
		GLuint lightColor;

		GLuint fogRange;
		GLuint fogColor;
	};

	static Program shaders[9][9][2];
	static Program shader_stencil;
	static Program shader_particle;
	static Program shader_voxel;
	static Program* shader;

	static GLuint stencil_vbo;
#endif
	static int vbo_enabled;
	static int vbo_min_tris;

	static int Shadows_enabled;

	static float anim_speed;

	static int fog_enabled; // used to keep track of whether fog is enabled between camera update and mesh render

	static Pivot* root_ent;

	static Camera* camera_in_use;
	
	static int alpha_enable;
	static int blend_mode;
	static int fx1;
	static int fx2;
	
	static Mesh* last_mesh;
	
	// anti aliasing globs
	static int aa; // anti_alias true/false
	static int ACSIZE; // accum size
	static int jitter;
	static float j_data[16][2];
	static const float j2_data[];
	static const float j3_data[];
	static const float j4_data[];
	static const float j5_data[];
	static const float j6_data[];
	static const float j8_data[];
	static const float j9_data[];
	static const float j12_data[];
	static const float j16_data[];
	
	static void Graphics();
	
	static void AmbientLight(float r,float g,float b);
	
	static void ClearCollisions();
	static void Collisions(int src_no,int dest_no,int method_no,int response_no=0);
	static void ClearWorld(int entities=true,int brushes=true,int textures=true);
	static void UpdateWorld(float anim_speed=1.0);
	static void RenderWorld();
	static void UpdateEntityAnim(Mesh& mesh);
	
	static void RenderWorldAA();
	static void AntiAlias(int samples);

	static void UseTextureFrames( int lf0,int fr1,int rt2,int bk3,int dn4,int up5 );
	static void UseTextureFaces( int lf0,int fr1,int rt2,int bk3,int dn4,int up5 );
	static void UseCubemapFlip( int flag );
	
};

bool CompareEntityOrder(Entity* ent1,Entity* ent2);

#endif
