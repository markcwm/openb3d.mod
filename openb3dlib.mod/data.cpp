// data.cpp

#include "data.h"

#include <stdio.h>
#include <string.h>

// Classid - used with static data fields
const int ACTION_class=			1;
const int ANIMATION_class=		2;
const int ANIMATIONKEYS_class=	3;
const int BONE_class=			4;
const int BRUSH_class=			5;
const int CAMERA_class=			6;
const int COLLISION_class=		7; // collision.h
const int COLLISIONINFO_class=	8;
const int COLLISIONPAIR_class=	9; // collision2.h
const int COLLISIONIMPACT_class=10;
const int CSGTRIANGLE_class=	11; // csg.h
const int ENTITY_class=			12;
const int VECTOR_class=			13; // geom.h
const int LINE_class=			14;
const int PLANE_class=			15;
const int QUAT_class=			16;
const int MMATRIX_class=		17;
const int BOX_class=			18;
const int TRANSFORM_class=		19;
const int GEOSPHERE_class=		20;
const int GLOBAL_class=			21;
const int FLUID_class=			22; // isosurface.h
const int BLOB_class=			23;
const int FIELDARRAY_class=		24;
const int LIGHT_class=			25;
const int MATERIALPLUGIN_class=	26; // material.h
const int MATRIX_class=			27;
const int MESH_class=			28;
const int OCTREE_class=			29; // octree.h
const int OCTREECHILD_class=	30;
const int PARTICLEBATCH_class=	31; // particle.h
const int PARTICLEEMITTER_class=32;
const int CONSTRAINT_class=		33; // physics.h
const int RIGIDBODY_class=		34;
const int PICK_class=			35;
const int PIVOT_class=			36;
const int QUATERNION_class=		37;
const int SHADERDATA_class=		38; // shadermat.h
const int SAMPLER_class=		39;
const int MATERIAL_class=		40;
const int SHADER_class=			41;
const int SHADEROBJECT_class=	42; // shaderobject.h
const int PROGRAMOBJECT_class=	43;
const int SHADOWTRIANGLE_class=	44; // shadow.h
const int EDGE_class=			45;
const int SHADOWOBJECT_class=	46;
const int SPRITE_class=			47;
const int SPRITEBATCH_class=	48;
const int STENCIL_class=		49;
const int SURFACE_class=		50;
const int TERRAIN_class=		51;
const int TEXTURE_class=		52;
const int TEXTUREFILTER_class=	53;
const int TILT_class=			54;
const int TOUCH_class=			55;
const int MESHCOLLIDER_class=	56; // tree.h
const int MESHINFO_class=		57;
const int VOXELSPRITE_class=	58;

// Action varid
const int ACTION_action_list=	1;
const int ACTION_act=			2;
const int ACTION_ent=			3;
const int ACTION_target=		4;
const int ACTION_rate=			5;
const int ACTION_a=				6;
const int ACTION_b=				7;
const int ACTION_c=				8;
const int ACTION_nextActions=	9;
const int ACTION_delete_list=	10;
const int ACTION_endact=		11;
const int ACTION_lifetime=		12;

// AnimationKeys varid
const int ANIMATIONKEYS_frames=	1;
const int ANIMATIONKEYS_flags=	2;
const int ANIMATIONKEYS_px=		3;
const int ANIMATIONKEYS_py=		4;
const int ANIMATIONKEYS_pz=		5;
const int ANIMATIONKEYS_sx=		6;
const int ANIMATIONKEYS_sy=		7;
const int ANIMATIONKEYS_sz=		8;
const int ANIMATIONKEYS_qw=		9;
const int ANIMATIONKEYS_qx=		10;
const int ANIMATIONKEYS_qy=		11;
const int ANIMATIONKEYS_qz=		12;

// Bone varid
const int BONE_n_px=		1;
const int BONE_n_py=		2;
const int BONE_n_pz=		3;
const int BONE_n_sx=		4;
const int BONE_n_sy=		5;
const int BONE_n_sz=		6;
const int BONE_n_rx=		7;
const int BONE_n_ry=		8;
const int BONE_n_rz=		9;
const int BONE_n_qw=		10;
const int BONE_n_qx=		11;
const int BONE_n_qy=		12;
const int BONE_n_qz=		13;
const int BONE_keys=		14;
const int BONE_mat2=		15;
const int BONE_inv_mat=		16;
const int BONE_tform_mat=	17;
const int BONE_kx=			18;
const int BONE_ky=			19;
const int BONE_kz=			20;
const int BONE_kqw=			21;
const int BONE_kqx=			22;
const int BONE_kqy=			23;
const int BONE_kqz=			24;

// Brush varid
const int BRUSH_no_texs=		1;
const int BRUSH_name=			2;
const int BRUSH_red=			3;
const int BRUSH_green=			4;
const int BRUSH_blue=			5;
const int BRUSH_alpha=			6;
const int BRUSH_shine=			7;
const int BRUSH_blend=			8;
const int BRUSH_fx=				9;
const int BRUSH_cache_frame=	10;
const int BRUSH_tex=			11;

// Camera varid
const int CAMERA_cam_list=			1;
const int CAMERA_render_list=		2;
const int CAMERA_vx=				3;
const int CAMERA_vy=				4;
const int CAMERA_vwidth=			5;
const int CAMERA_vheight=			6;
const int CAMERA_cls_r=				7;
const int CAMERA_cls_g=				8;
const int CAMERA_cls_b=				9;
const int CAMERA_cls_color=			10;
const int CAMERA_cls_zbuffer=		11;
const int CAMERA_range_near=		12;
const int CAMERA_range_far=			13;
const int CAMERA_zoom=				14;
const int CAMERA_proj_mode=			15;
const int CAMERA_fog_mode=			16;
const int CAMERA_fog_r=				17;
const int CAMERA_fog_g=				18;
const int CAMERA_fog_b=				19;
const int CAMERA_fog_range_near=	20;
const int CAMERA_fog_range_far=		21;
const int CAMERA_project_enabled=	22;
const int CAMERA_mod_mat=			23; // array [16]
const int CAMERA_proj_mat=			24; // array [16]
const int CAMERA_viewport=			25; // array [4]
const int CAMERA_projected_x=		26;
const int CAMERA_projected_y=		27;
const int CAMERA_projected_z=		28;
const int CAMERA_frustum=			29; // array [6][4]

// CollisionPair varid
const int COLLISIONPAIR_cp_list=	1;
const int COLLISIONPAIR_ent_lists=	2;
const int COLLISIONPAIR_src_type=	3;
const int COLLISIONPAIR_des_type=	4;
const int COLLISIONPAIR_col_method=	5;
const int COLLISIONPAIR_response=	6;

// CollisionImpact varid
const int COLLISIONIMPACT_x=	1;
const int COLLISIONIMPACT_y=	2;
const int COLLISIONIMPACT_z=	3;
const int COLLISIONIMPACT_nx=	4;
const int COLLISIONIMPACT_ny=	5;
const int COLLISIONIMPACT_nz=	6;
const int COLLISIONIMPACT_time=	7;
const int COLLISIONIMPACT_ent=	8;
const int COLLISIONIMPACT_surf=	9;
const int COLLISIONIMPACT_tri=	10;

// Entity varid
const int ENTITY_entity_list=		1;
const int ENTITY_child_list=		2;
const int ENTITY_parent=			3;
const int ENTITY_mat=				4;
const int ENTITY_rotmat=			5;
const int ENTITY_px=				6;
const int ENTITY_py=				7;
const int ENTITY_pz=				8;
const int ENTITY_sx=				9;
const int ENTITY_sy=				10;
const int ENTITY_sz=				11;
const int ENTITY_rx=				12;
const int ENTITY_ry=				13;
const int ENTITY_rz=				14;
const int ENTITY_qw=				15;
const int ENTITY_qx=				16;
const int ENTITY_qy=				17;
const int ENTITY_qz=				18;
const int ENTITY_brush=				19;
const int ENTITY_order=				20;
const int ENTITY_alpha_order=		21;
const int ENTITY_hide=				22;
const int ENTITY_cull_radius=		23;
const int ENTITY_name=				24;
const int ENTITY_class_name=		25;
const int ENTITY_animate_list=		26;
const int ENTITY_anim=				27; // true if mesh contains anim data
const int ENTITY_anim_render=		28; // true to render as anim mesh
const int ENTITY_anim_mode=			29;
const int ENTITY_anim_time=			30;
const int ENTITY_anim_speed=		31;
const int ENTITY_anim_seq=			32;
const int ENTITY_anim_trans=		33;
const int ENTITY_anim_dir=			34; // 1=forward, -1=backward
const int ENTITY_anim_seqs_first=	35;
const int ENTITY_anim_seqs_last=	36;
const int ENTITY_no_seqs=			37;
const int ENTITY_anim_update=		38;
const int ENTITY_anim_list=			39;
const int ENTITY_collision_type=	40;
const int ENTITY_radius_x=			41;
const int ENTITY_radius_y=			42;
const int ENTITY_box_x=				43;
const int ENTITY_box_y=				44;
const int ENTITY_box_z=				45;
const int ENTITY_box_w=				46;
const int ENTITY_box_h=				47;
const int ENTITY_box_d=				48;
const int ENTITY_no_collisions=		49;
const int ENTITY_collision=			50;
const int ENTITY_old_x=				51;
const int ENTITY_old_y=				52;
const int ENTITY_old_z=				53;
const int ENTITY_old_pitch=			54;
const int ENTITY_old_yaw=			55;
const int ENTITY_old_roll=			56;
const int ENTITY_new_x=				57;
const int ENTITY_new_y=				58;
const int ENTITY_new_z=				59;
const int ENTITY_new_no=			60;
const int ENTITY_old_mat=			61;
const int ENTITY_dynamic=			62;
const int ENTITY_dynamic_x=			63;
const int ENTITY_dynamic_y=			64;
const int ENTITY_dynamic_z=			65;
const int ENTITY_dynamic_yaw=		66;
const int ENTITY_dynamic_pitch=		67;
const int ENTITY_dynamic_roll=		68;
const int ENTITY_pick_mode=			69;
const int ENTITY_obscurer=			70;
const int ENTITY_tformed_x=			71;
const int ENTITY_tformed_y=			72;
const int ENTITY_tformed_z=			73;

// Global varid
const int GLOBAL_width=				1;
const int GLOBAL_height=			2;
const int GLOBAL_mode=				3;
const int GLOBAL_depth=				4;
const int GLOBAL_rate=				5;
const int GLOBAL_ambient_red=		6;
const int GLOBAL_ambient_green=		7;
const int GLOBAL_ambient_blue=		8;
const int GLOBAL_ambient_shader=	9;
const int GLOBAL_vbo_enabled=		10;
const int GLOBAL_vbo_min_tris=		11;
const int GLOBAL_Shadows_enabled=	12;
const int GLOBAL_anim_speed=		13;
const int GLOBAL_fog_enabled=		14;
const int GLOBAL_root_ent=			15;
const int GLOBAL_camera_in_use=		16;
const int GLOBAL_alpha_enable=		17;
const int GLOBAL_blend_mode=		18;
const int GLOBAL_fx1=				19;
const int GLOBAL_fx2=				20;

// Light varid
const int LIGHT_light_no=	1;
const int LIGHT_no_lights=	2;
const int LIGHT_max_lights=	3;	
const int LIGHT_gl_light=	4;
const int LIGHT_light_list=	5;
const int LIGHT_cast_shadow=6;
const int LIGHT_light_type=	7;
const int LIGHT_range=		8;
const int LIGHT_red=		9;
const int LIGHT_green=		10;
const int LIGHT_blue=		11;
const int LIGHT_inner_ang=	12;
const int LIGHT_outer_ang=	13;
	
// Matrix varid
const int MATRIX_grid=	1;

// Mesh varid
const int MESH_no_surfs=		1;
const int MESH_surf_list=		2;
const int MESH_anim_surf_list=	3;
const int MESH_bones=			4;
const int MESH_mat_sp=			5;
const int MESH_c_col_tree=		6;
const int MESH_reset_col_tree=	7;
const int MESH_reset_bounds=	8;
const int MESH_min_x=			9;
const int MESH_min_y=			10;
const int MESH_min_z=			11;
const int MESH_max_x=			12;
const int MESH_max_y=			13;
const int MESH_max_z=			14;

// Pick varid
const int PICK_ent_list=		1;
const int PICK_picked_x=		2;
const int PICK_picked_y=		3;
const int PICK_picked_z=		4;
const int PICK_picked_nx=		5;
const int PICK_picked_ny=		6;
const int PICK_picked_nz=		7;
const int PICK_picked_time=		8;
const int PICK_picked_ent=		9;
const int PICK_picked_surface=	10;
const int PICK_picked_triangle=	11;

// Quaternion
const int QUATERNION_x=1;
const int QUATERNION_y=2;
const int QUATERNION_z=3;
const int QUATERNION_w=4;

// ShadowObject varid
const int SHADOWOBJECT_shadow_list=		1;
const int SHADOWOBJECT_Parent=			2;
const int SHADOWOBJECT_cnt_tris=		3;
const int SHADOWOBJECT_ShadowMesh=		4;
const int SHADOWOBJECT_ShadowVolume=	5;
const int SHADOWOBJECT_Render=			6;
const int SHADOWOBJECT_Static=			7;
const int SHADOWOBJECT_VCreated=		8;
const int SHADOWOBJECT_VolumeLength=	9;
const int SHADOWOBJECT_top_caps=		10;
const int SHADOWOBJECT_parallel=		11;
const int SHADOWOBJECT_light_x=			12;
const int SHADOWOBJECT_light_y=			13;
const int SHADOWOBJECT_light_z=			14;
const int SHADOWOBJECT_midStencilVal=	15;
const int SHADOWOBJECT_ShadowRed=		16;
const int SHADOWOBJECT_ShadowGreen=		17;
const int SHADOWOBJECT_ShadowBlue=		18;
const int SHADOWOBJECT_ShadowAlpha=		19;

// Sprite varid
const int SPRITE_angle=			1;
const int SPRITE_scale_x=		2;
const int SPRITE_scale_y=		3;
const int SPRITE_handle_x=		4;
const int SPRITE_handle_y=		5; 
const int SPRITE_view_mode=		6;
const int SPRITE_render_mode=	7;

// Surface varid
const int SURFACE_no_verts=			1;
const int SURFACE_no_tris=			2;
const int SURFACE_vert_coords=		3;
const int SURFACE_vert_norm=		4;
const int SURFACE_vert_tex_coords0=	5;
const int SURFACE_vert_tex_coords1=	6;
const int SURFACE_vert_col=			7;
const int SURFACE_tris=				8;
const int SURFACE_vert_bone1_no=	9;
const int SURFACE_vert_bone2_no=	10;
const int SURFACE_vert_bone3_no=	11;
const int SURFACE_vert_bone4_no=	12;
const int SURFACE_vert_weight1=		13;
const int SURFACE_vert_weight2=		14;
const int SURFACE_vert_weight3=		15;
const int SURFACE_vert_weight4=		16;
const int SURFACE_brush=			17;
const int SURFACE_ShaderMat=		18;
const int SURFACE_vbo_id=			19;
const int SURFACE_vert_array_size=	20;
const int SURFACE_tri_array_size=	21;
const int SURFACE_vmin=				22;
const int SURFACE_vmax=				23;
const int SURFACE_vbo_enabled=		24;
const int SURFACE_reset_vbo=		25;
const int SURFACE_alpha_enable=		26;
const int SURFACE_vert_tan=			27;
const int SURFACE_vert_bitan=		28;
const int SURFACE_has_tangents=		29;

// Terrain varid
const int TERRAIN_terrain_list=	1;
const int TERRAIN_triangleindex=2;
const int TERRAIN_mesh_info=	3;
const int TERRAIN_size=			4;
const int TERRAIN_vsize=		5;
const int TERRAIN_level2dzsize=	6;
const int TERRAIN_height=		7;
const int TERRAIN_c_col_tree=	8;
const int TERRAIN_eyepoint=		9;
const int TERRAIN_ShaderMat=	10;

// Texture varid
const int TEXTURE_texture=		1;
const int TEXTURE_tex_list=		2;
const int TEXTURE_file=			3;
const int TEXTURE_frames=		4;
const int TEXTURE_flags=		5;
const int TEXTURE_blend=		6;
const int TEXTURE_coords=		7;
const int TEXTURE_u_scale=		8;
const int TEXTURE_v_scale=		9;
const int TEXTURE_u_pos=		10;
const int TEXTURE_v_pos=		11;
const int TEXTURE_angle=		12;
const int TEXTURE_file_abs=		13;
const int TEXTURE_width=		14;
const int TEXTURE_height=		15;
const int TEXTURE_no_frames=	16;
const int TEXTURE_framebuffer=	17;
const int TEXTURE_cube_face=	18;
const int TEXTURE_cube_mode=	19;
const int TEXTURE_tex_list_all=	20;

// Define instance of statics
int Global::mode,Global::depth,Global::rate;

extern "C" {

// Static

char* StaticChar_( int classid,int varid ){
	switch (classid){
		case SHADOWOBJECT_class :
			switch (varid){
				case SHADOWOBJECT_top_caps : return (char*)&ShadowObject::top_caps;
			}
			break;
	}
	return NULL;
}

int* StaticInt_( int classid,int varid ){
	switch (classid){
		case GLOBAL_class :
			switch (varid){
				case GLOBAL_width : return &Global::width;
				case GLOBAL_height : return &Global::height;
				case GLOBAL_mode : return &Global::mode;
				case GLOBAL_depth : return &Global::depth;
				case GLOBAL_rate : return &Global::rate;
				case GLOBAL_vbo_enabled : return &Global::vbo_enabled;
				case GLOBAL_vbo_min_tris : return &Global::vbo_min_tris;
				case GLOBAL_Shadows_enabled : return &Global::Shadows_enabled;
				case GLOBAL_fog_enabled : return &Global::fog_enabled;
				case GLOBAL_alpha_enable : return &Global::alpha_enable;
				case GLOBAL_blend_mode : return &Global::blend_mode;
				case GLOBAL_fx1 : return &Global::fx1;
				case GLOBAL_fx2 : return &Global::fx2;
			}
			break;
		case LIGHT_class :
			switch (varid){
				case LIGHT_light_no : return &Light::light_no;
				case LIGHT_no_lights : return &Light::no_lights;
				case LIGHT_max_lights : return &Light::max_lights;
				case LIGHT_gl_light : return &Light::gl_light[0];
			}
			break;
		case PICK_class :
			switch (varid){
				case PICK_picked_triangle : return &Pick::picked_triangle;
			}
			break;
		case SHADOWOBJECT_class :
			switch (varid){
				case SHADOWOBJECT_parallel : return &ShadowObject::parallel;
				case SHADOWOBJECT_midStencilVal : return &ShadowObject::midStencilVal;
			}
			break;
		case TERRAIN_class :
			switch (varid){
				case TERRAIN_triangleindex : return &Terrain::triangleindex;
			}
			break;
	}
	return NULL;
}

float* StaticFloat_( int classid,int varid ){
	switch (classid){
		case CAMERA_class :
			switch (varid){
				case CAMERA_projected_x : return &Camera::projected_x;
				case CAMERA_projected_y : return &Camera::projected_y;
				case CAMERA_projected_z : return &Camera::projected_z;
			}
			break;
		case ENTITY_class :
			switch (varid){
				case ENTITY_tformed_x : return &Entity::tformed_x;
				case ENTITY_tformed_y : return &Entity::tformed_y;
				case ENTITY_tformed_z : return &Entity::tformed_z;
			}
			break;
		case GLOBAL_class :
			switch (varid){
				case GLOBAL_ambient_red : return &Global::ambient_red;
				case GLOBAL_ambient_green : return &Global::ambient_green;
				case GLOBAL_ambient_blue : return &Global::ambient_blue;
				case GLOBAL_anim_speed : return &Global::anim_speed;
			}
			break;
		case PICK_class :
			switch (varid){
				case PICK_picked_x : return &Pick::picked_x;
				case PICK_picked_y : return &Pick::picked_y;
				case PICK_picked_z : return &Pick::picked_z;
				case PICK_picked_nx : return &Pick::picked_nx;
				case PICK_picked_ny : return &Pick::picked_ny;
				case PICK_picked_nz : return &Pick::picked_nz;
				case PICK_picked_time : return &Pick::picked_time;
			}
			break;
		case SHADOWOBJECT_class :
			switch (varid){
				case SHADOWOBJECT_VolumeLength : return &ShadowObject::VolumeLength;
				case SHADOWOBJECT_light_x : return &ShadowObject::light_x;
				case SHADOWOBJECT_light_y : return &ShadowObject::light_y;
				case SHADOWOBJECT_light_z : return &ShadowObject::light_z;
				case SHADOWOBJECT_ShadowRed : return &ShadowObject::ShadowRed;
				case SHADOWOBJECT_ShadowGreen : return &ShadowObject::ShadowGreen;
				case SHADOWOBJECT_ShadowBlue : return &ShadowObject::ShadowBlue;
				case SHADOWOBJECT_ShadowAlpha : return &ShadowObject::ShadowAlpha;
			}
			break;
	}
	return NULL;
}

Camera* StaticCamera_( int classid,int varid ){
	switch (classid){
		case GLOBAL_class :
			switch (varid){
				case GLOBAL_camera_in_use : return Global::camera_in_use;
			}
			break;
	}
	return NULL;
}

Entity* StaticEntity_( int classid,int varid ){
	switch (classid){
		case PICK_class :
			switch (varid){
				case PICK_picked_ent : return Pick::picked_ent;
			}
			break;
	}
	return NULL;
}

Pivot* StaticPivot_( int classid,int varid ){
	switch (classid){
		case GLOBAL_class :
			switch (varid){
				case GLOBAL_root_ent : return Global::root_ent;
			}
			break;
	}
	return NULL;
}

Surface* StaticSurface_( int classid,int varid ){
	switch (classid){
		case PICK_class :
			switch (varid){
				case PICK_picked_surface : return Pick::picked_surface;
			}
			break;
	}
	return NULL;
}

int StaticListSize_( int classid,int varid ){
	
	switch (classid){
		
		case ACTION_class :
			switch (varid){
				case ACTION_action_list : return Action::action_list.size();
			}
			break;
		case CAMERA_class :
			switch (varid){
				case CAMERA_cam_list : return Camera::cam_list.size();
				//case CAMERA_render_list : return Camera::render_list.size();
			}
			break;
		case ENTITY_class :
			switch (varid){
				case ENTITY_entity_list : return Entity::entity_list.size();
				case ENTITY_animate_list : return Entity::animate_list.size();
			}
			break;
		case LIGHT_class :
			switch (varid){
				case LIGHT_light_list : return Light::light_list.size();
			}
			break;
		case PICK_class :
			switch (varid){
				case PICK_ent_list : return Pick::ent_list.size();
			}
			break;
		case SHADOWOBJECT_class :
			switch (varid){
				case SHADOWOBJECT_shadow_list : return ShadowObject::shadow_list.size();
			}
			break;
		case TEXTURE_class :
			switch (varid){
				case TEXTURE_tex_list : return Texture::tex_list.size();
				case TEXTURE_tex_list_all : return Texture::tex_list_all.size();
			}
			break;
		case TERRAIN_class :
			switch (varid){
				case TERRAIN_terrain_list : return Terrain::terrain_list.size();
			}
			break;
	}
	return 0;
}

Action* StaticIterListAction_( int classid,int varid,int &id ){
	int count=0;
	list<Action*>::iterator it;
	Action* obj;
	
	switch (classid){
		case ACTION_class :
			switch (varid){
				case ACTION_action_list :
					for(it=Action::action_list.begin(); it!=Action::action_list.end(); it++){
						obj=*it;
						if (id == count) break;
						count++;
					}
					id++;
					break;
			}
			break;
	}
	
	return obj;
}

Camera* StaticIterListCamera_( int classid,int varid,int &id ){
	int count=0;
	list<Camera*>::iterator it;
	Camera* obj;
	
	switch (classid){
		case CAMERA_class :
			switch (varid){
				case CAMERA_cam_list :
					for(it=Camera::cam_list.begin(); it!=Camera::cam_list.end(); it++){
						obj=*it;
						if (id == count) break;
						count++;
					}
					id++;
					break;
			}
			break;
	}
	
	return obj;
}

Entity* StaticIterListEntity_( int classid,int varid,int &id ){
	int count=0;
	list<Entity*>::iterator it;
	Entity* obj;
	
	switch (classid){
		case ENTITY_class :
			switch (varid){
				case ENTITY_entity_list :
					for(it=Entity::entity_list.begin(); it!=Entity::entity_list.end(); it++){
						obj=*it;
						if (id == count) break;
						count++;
					}
					id++;
					break;
				case ENTITY_animate_list :
					for(it=Entity::animate_list.begin(); it!=Entity::animate_list.end(); it++){
						obj=*it;
						if (id == count) break;
						count++;
					}
					id++;
					break;
			}
			break;
		case PICK_class :
			switch (varid){
				case PICK_ent_list :
					for(it=Pick::ent_list.begin(); it!=Pick::ent_list.end(); it++){
						obj=*it;
						if (id == count) break;
						count++;
					}
					id++;
					break;
			}
			break;
	}
	
	return obj;
}

ShadowObject* StaticIterListShadowObject_( int classid,int varid,int &id ){
	int count=0;
	list<ShadowObject*>::iterator it;
	ShadowObject* obj;
	
	switch (classid){
		case SHADOWOBJECT_class :
			switch (varid){
				case SHADOWOBJECT_shadow_list :
					for(it=ShadowObject::shadow_list.begin(); it!=ShadowObject::shadow_list.end(); it++){
						obj=*it;
						if (id == count) break;
						count++;
					}
					id++;
					break;
			}
			break;
	}
	
	return obj;
}

Terrain* StaticIterListTerrain_( int classid,int varid,int &id ){
	int count=0;
	list<Terrain*>::iterator it;
	Terrain* obj;
	
	switch (classid){
		case TERRAIN_class :
			switch (varid){
				case TERRAIN_terrain_list :
					for(it=Terrain::terrain_list.begin(); it!=Terrain::terrain_list.end(); it++){
						obj=*it;
						if (id == count) break;
						count++;
					}
					id++;
					break;
			}
			break;
	}
	
	return obj;
}

Texture* StaticIterListTexture_( int classid,int varid,int &id ){
	int count=0;
	list<Texture*>::iterator it;
	Texture* obj;
	
	switch (classid){
		case TEXTURE_class :
			switch (varid){
				case TEXTURE_tex_list :
					for(it=Texture::tex_list.begin(); it!=Texture::tex_list.end(); it++){
						obj=*it;
						if (id == count) break;
						count++;
					}
					id++;
					break;
				case TEXTURE_tex_list_all :
					for(it=Texture::tex_list_all.begin(); it!=Texture::tex_list_all.end(); it++){
						obj=*it;
						if (id == count) break;
						count++;
					}
					id++;
					break;
			}
			break;
	}
	
	return obj;
}

Light* StaticIterVectorLight_( int classid,int varid,int &id ){
	int count=0;
	vector<Light*>::iterator it;
	Light* obj;
	
	switch (classid){
		case LIGHT_class :
			switch (varid){
				case LIGHT_light_list :
					for(it=Light::light_list.begin(); it!=Light::light_list.end(); it++){
						obj=*it;
						if (id == count) break;
						count++;
					}
					id++;
					break;
			}
			break;
	}
	
	return obj;
}

// Action

int* ActionInt_( Action* obj,int varid ){
	switch (varid){
		case ACTION_act : return &obj->act;
		case ACTION_endact : return &obj->endact;
		case ACTION_lifetime : return &obj->lifetime;
	}
	return NULL;
}

float* ActionFloat_( Action* obj,int varid ){
	switch (varid){
		case ACTION_rate : return &obj->rate;
		case ACTION_a : return &obj->a;
		case ACTION_b : return &obj->b;
		case ACTION_c : return &obj->c;
	}
	return NULL;
}

Entity* ActionEntity_( Action* obj,int varid ){
	switch (varid){
		case ACTION_ent : return obj->ent;
		case ACTION_target : return obj->target;
	}
	return NULL;
}

// AnimationKeys

int* AnimationKeysInt_( AnimationKeys* obj,int varid ){
	switch (varid){
		case ANIMATIONKEYS_frames : return &obj->frames;
		case ANIMATIONKEYS_flags : return &obj->flags[0];
	}
	return NULL;
}

float* AnimationKeysFloat_( AnimationKeys* obj,int varid ){
	switch (varid){
		case ANIMATIONKEYS_px : return &obj->px[0];
		case ANIMATIONKEYS_py : return &obj->py[0];
		case ANIMATIONKEYS_pz : return &obj->pz[0];
		case ANIMATIONKEYS_sx : return &obj->sx[0];
		case ANIMATIONKEYS_sy : return &obj->sy[0];
		case ANIMATIONKEYS_sz : return &obj->sz[0];
		case ANIMATIONKEYS_qw : return &obj->qw[0];
		case ANIMATIONKEYS_qx : return &obj->qx[0];
		case ANIMATIONKEYS_qy : return &obj->qy[0];
		case ANIMATIONKEYS_qz : return &obj->qz[0];	
	}
	return NULL;
}

AnimationKeys* NewAnimationKeys_( Bone* obj ){
	if (obj==NULL){
		AnimationKeys* keys=new AnimationKeys();
		return keys;
	}else{
		obj->keys=new AnimationKeys();
		return obj->keys;
	}
}

// Bone

float* BoneFloat_( Bone* obj,int varid ){
	switch (varid){
		case BONE_n_px : return &obj->n_px;
		case BONE_n_py : return &obj->n_py;
		case BONE_n_pz : return &obj->n_pz;
		case BONE_n_sx : return &obj->n_sx;
		case BONE_n_sy : return &obj->n_sy;
		case BONE_n_sz : return &obj->n_sz;
		case BONE_n_rx : return &obj->n_rx;
		case BONE_n_ry : return &obj->n_ry;
		case BONE_n_rz : return &obj->n_rz;
		case BONE_n_qw : return &obj->n_qw;
		case BONE_n_qx : return &obj->n_qx;
		case BONE_n_qy : return &obj->n_qy;
		case BONE_n_qz : return &obj->n_qz;
		case BONE_kx : return &obj->kx;
		case BONE_ky : return &obj->ky;
		case BONE_kz : return &obj->kz;
		case BONE_kqw : return &obj->kqw;
		case BONE_kqx : return &obj->kqx;
		case BONE_kqy : return &obj->kqy;
		case BONE_kqz : return &obj->kqz;
	}
	return NULL;
}

AnimationKeys* BoneAnimationKeys_( Bone* obj,int varid ){
	switch (varid){
		case BONE_keys : return obj->keys;
	}
	return NULL;
}

Matrix* BoneMatrix_( Bone* obj,int varid ){
	switch (varid){
		case BONE_mat2 : return &obj->mat2;
		case BONE_inv_mat : return &obj->inv_mat;
		case BONE_tform_mat : return &obj->tform_mat;
	}
	return NULL;
}

// Brush

int* BrushInt_( Brush* obj,int varid ){
	switch (varid){
		case BRUSH_no_texs : return &obj->no_texs;
		case BRUSH_blend : return &obj->blend;
		case BRUSH_fx : return &obj->fx;
	}
	return NULL;
}

unsigned int* BrushUInt_( Brush* obj,int varid ){
	switch (varid){
		case BRUSH_cache_frame : return &obj->cache_frame[0]; // array 8
	}
	return NULL;
}

float* BrushFloat_( Brush* obj,int varid ){
	switch (varid){
		case BRUSH_red : return &obj->red;
		case BRUSH_green : return &obj->green;
		case BRUSH_blue : return &obj->blue;
		case BRUSH_alpha : return &obj->alpha;
		case BRUSH_shine : return &obj->shine;
	}
	return NULL;
}

const char* BrushString_( Brush* obj,int varid ){
	switch (varid){
		case BRUSH_name : return obj->name.c_str();
	}
	return NULL;
}

Texture* BrushTextureArray_( Brush* obj,int varid,int index ){
	switch (varid){
		case BRUSH_tex : return obj->tex[index];
	}
	return NULL;
}

void SetBrushString_( Brush* obj,int varid,char* cstr ){
	string str(cstr);
	switch (varid){
		case BRUSH_name :
			obj->name=str;
			break;
	}
}

// Camera

bool* CameraBool_( Camera* obj,int varid ){
	switch (varid){
		case CAMERA_cls_color : return &obj->cls_color;
		case CAMERA_cls_zbuffer : return &obj->cls_zbuffer;
	}
	return NULL;
}

int* CameraInt_( Camera* obj,int varid ){
	switch (varid){
		case CAMERA_vx : return &obj->vx;
		case CAMERA_vy : return &obj->vy;
		case CAMERA_vwidth : return &obj->vwidth;
		case CAMERA_vheight : return &obj->vheight;
		case CAMERA_proj_mode : return &obj->proj_mode;
		case CAMERA_fog_mode : return &obj->fog_mode;
		case CAMERA_project_enabled : return &obj->project_enabled;
		case CAMERA_viewport : return &obj->viewport[0]; // [4]
	}
	return NULL;
}

float* CameraFloat_( Camera* obj,int varid ){
	switch (varid){
		case CAMERA_cls_r : return &obj->cls_r;	
		case CAMERA_cls_g : return &obj->cls_g;	
		case CAMERA_cls_b : return &obj->cls_b;	
		case CAMERA_range_near : return &obj->range_near;	
		case CAMERA_range_far : return &obj->range_far;	
		case CAMERA_zoom : return &obj->zoom;	
		case CAMERA_fog_r : return &obj->fog_r;	
		case CAMERA_fog_g : return &obj->fog_g;	
		case CAMERA_fog_b : return &obj->fog_b;	
		case CAMERA_fog_range_near : return &obj->fog_range_near;	
		case CAMERA_fog_range_far : return &obj->fog_range_far;
		case CAMERA_mod_mat : return &obj->mod_mat[0]; // [16]	
		case CAMERA_proj_mat : return &obj->proj_mat[0]; // [16]
		case CAMERA_frustum : return &obj->frustum[0][0]; // [6][4]
	}
	return NULL;
}

// Entity

int* EntityInt_( Entity* obj,int varid ){
	switch (varid){
		case ENTITY_order : return &obj->order;
		case ENTITY_hide : return &obj->hide;
		case ENTITY_anim : return &obj->anim;
		case ENTITY_anim_render : return &obj->anim_render;
		case ENTITY_anim_mode : return &obj->anim_mode;
		case ENTITY_anim_seq : return &obj->anim_seq;
		case ENTITY_anim_trans : return &obj->anim_trans;
		case ENTITY_anim_dir : return &obj->anim_dir;
		case ENTITY_anim_seqs_first : return &obj->anim_seqs_first[0];
		case ENTITY_anim_seqs_last : return &obj->anim_seqs_last[0];
		case ENTITY_no_seqs : return &obj->no_seqs;
		case ENTITY_anim_update : return &obj->anim_update;
		case ENTITY_anim_list : return &obj->anim_list;
		case ENTITY_collision_type : return &obj->collision_type;
		case ENTITY_no_collisions : return &obj->no_collisions;
		case ENTITY_new_no : return &obj->new_no;
		case ENTITY_dynamic : return &obj->dynamic;
		case ENTITY_pick_mode : return &obj->pick_mode;
		case ENTITY_obscurer : return &obj->obscurer;
	}
	return NULL;
}

float* EntityFloat_( Entity* obj,int varid ){
	switch (varid){
		case ENTITY_px : return &obj->px;
		case ENTITY_py : return &obj->py;
		case ENTITY_pz : return &obj->pz;
		case ENTITY_sx : return &obj->sx;
		case ENTITY_sy : return &obj->sy;
		case ENTITY_sz : return &obj->sz;
		case ENTITY_rx : return &obj->rx;
		case ENTITY_ry : return &obj->ry;
		case ENTITY_rz : return &obj->rz;
		case ENTITY_qw : return &obj->qw;
		case ENTITY_qx : return &obj->qx;
		case ENTITY_qy : return &obj->qy;
		case ENTITY_qz : return &obj->qz;
		case ENTITY_alpha_order : return &obj->alpha_order;
		case ENTITY_cull_radius : return &obj->cull_radius;
		case ENTITY_anim_time : return &obj->anim_time;
		case ENTITY_anim_speed : return &obj->anim_speed;
		case ENTITY_radius_x : return &obj->radius_x;
		case ENTITY_radius_y : return &obj->radius_y;
		case ENTITY_box_x : return &obj->box_x;
		case ENTITY_box_y : return &obj->box_y;
		case ENTITY_box_z : return &obj->box_z;
		case ENTITY_box_w : return &obj->box_w;
		case ENTITY_box_h : return &obj->box_h;
		case ENTITY_box_d : return &obj->box_d;
		case ENTITY_old_x : return &obj->old_x;
		case ENTITY_old_y : return &obj->old_y;
		case ENTITY_old_z : return &obj->old_z;
		case ENTITY_old_pitch : return &obj->old_pitch;
		case ENTITY_old_yaw : return &obj->old_yaw;
		case ENTITY_old_roll : return &obj->old_roll;
		case ENTITY_new_x : return &obj->new_x;
		case ENTITY_new_y : return &obj->new_y;
		case ENTITY_new_z : return &obj->new_z;
		case ENTITY_dynamic_x : return &obj->dynamic_x;
		case ENTITY_dynamic_y : return &obj->dynamic_y;
		case ENTITY_dynamic_z : return &obj->dynamic_z;
		case ENTITY_dynamic_yaw : return &obj->dynamic_yaw;
		case ENTITY_dynamic_pitch : return &obj->dynamic_pitch;
		case ENTITY_dynamic_roll : return &obj->dynamic_roll;
	}
	return NULL;
}

const char* EntityString_( Entity* obj,int varid ){
	switch (varid){
		case ENTITY_name : return obj->name.c_str();
		case ENTITY_class_name : return obj->class_name.c_str();
	}
	return NULL;
}

Entity* EntityEntity_( Entity* obj,int varid ){
	switch (varid){
		case ENTITY_parent : return obj->parent;
	}
	return NULL;
}

Brush* EntityBrush_( Entity* obj,int varid ){
	switch (varid){
		case ENTITY_brush : return &obj->brush;
	}
	return NULL;
}

Matrix* EntityMatrix_( Entity* obj,int varid ){
	switch (varid){
		case ENTITY_mat : return &obj->mat;
		case ENTITY_rotmat : return &obj->rotmat;
		case ENTITY_old_mat : return &obj->old_mat;
	}
	return NULL;
}

int EntityListSize_( Entity* obj,int varid ){
	
	switch (varid){
		case ENTITY_child_list : return obj->child_list.size();
		//case ENTITY_collision : return obj->collision.size();
	}
	return 0;
}

Entity* EntityIterListEntity_( Entity* obj,int varid,int &id ){
	int count=0;
	list<Entity*>::iterator it;
	Entity* obj2;
	
	switch (varid){
		case ENTITY_child_list :
			for(it=obj->child_list.begin(); it!=obj->child_list.end(); it++){
				obj2=*it;
				if (id == count) break;
				count++;
			}
			id++;
			break;
	}
	
	return obj2;
}

void EntityListPushBackEntity_( Entity* obj,int varid,Entity* ent ){
	switch (varid){
		case ENTITY_child_list : obj->child_list.push_back(ent);
			break;
	}
}

void EntityListRemoveEntity_( Entity* obj,int varid,Entity* ent ){
	switch (varid){
		case ENTITY_child_list : obj->child_list.remove(ent);
			break;
	}
}

void GlobalListPushBackEntity_( int varid,Entity* obj ){
	switch (varid){
		case ENTITY_entity_list : Entity::entity_list.push_back(obj);
			break;
	}
}

void SetEntityString_( Entity* obj,int varid,char* cstr ){
	string str(cstr);
	switch (varid){
		case ENTITY_name :
			obj->name=str;
			break;
		case ENTITY_class_name :
			obj->class_name=str;
			break;
	}
}

// Light

char* LightChar_( Light* obj,int varid ){
	switch (varid){
		case LIGHT_cast_shadow : return (char*)&obj->cast_shadow;
		case LIGHT_light_type : return (char*)&obj->light_type;
	}
	return NULL;
}

float* LightFloat_( Light* obj,int varid ){
	switch (varid){
		case LIGHT_range : return &obj->range;
		case LIGHT_red : return &obj->red;
		case LIGHT_green : return &obj->green;
		case LIGHT_blue : return &obj->blue;
		case LIGHT_inner_ang : return &obj->inner_ang;
		case LIGHT_outer_ang : return &obj->outer_ang;
	}
	return NULL;
}

// Matrix

float* MatrixFloat_( Matrix* obj,int varid ){
	switch (varid){
		case MATRIX_grid : return &obj->grid[0][0];
	}
	return NULL;
}

Matrix* NewMatrix_(){
	Matrix* mat=new Matrix();
	mat->LoadIdentity();
	return mat;
}

// Mesh

int* MeshInt_( Mesh* obj,int varid ){
	switch (varid){
		case MESH_no_surfs : return &obj->no_surfs;
		case MESH_reset_col_tree : return &obj->reset_col_tree;
		case MESH_reset_bounds : return &obj->reset_bounds;
	}
	return NULL;
}

float* MeshFloat_( Mesh* obj,int varid ){
	switch (varid){
		case MESH_min_x : return &obj->min_x;
		case MESH_min_y : return &obj->min_y;
		case MESH_min_z : return &obj->min_z;
		case MESH_max_x : return &obj->max_x;
		case MESH_max_y : return &obj->max_y;
		case MESH_max_z : return &obj->max_z;	
	}
	return NULL;
}

Matrix* MeshMatrix_( Mesh* obj,int varid ){
	switch (varid){
		case MESH_mat_sp : return &obj->mat_sp;
	}
	return NULL;
}

int MeshListSize_( Mesh* obj,int varid ){
	
	switch (varid){
		case MESH_surf_list : return obj->surf_list.size();
		case MESH_anim_surf_list : return obj->anim_surf_list.size();
		case MESH_bones : return obj->bones.size();
	}
	return 0;
}

Surface* MeshIterListSurface_( Mesh* obj,int varid,int &id ){
	int count=0;
	list<Surface*>::iterator it;
	Surface* obj2;
	
	switch (varid){
		case MESH_surf_list :
			for(it=obj->surf_list.begin(); it!=obj->surf_list.end(); it++){
				obj2=*it;
				if (id == count) break;
				count++;
			}
			id++;
			break;
		case MESH_anim_surf_list :
			for(it=obj->anim_surf_list.begin(); it!=obj->anim_surf_list.end(); it++){
				obj2=*it;
				if (id == count) break;
				count++;
			}
			id++;
			break;
	}
	return obj2;
}

Bone* MeshIterVectorBone_( Mesh* obj,int varid,int &id ){
	int count=0;
	vector<Bone*>::iterator it;
	Bone* obj2;
	
	switch (varid){
		case MESH_bones :
			for(it=obj->bones.begin(); it!=obj->bones.end(); it++){
				obj2=*it;
				if (id == count) break;
				count++;
			}
			id++;
			break;
	}
	
	return obj2;
}

vector<Bone*>* MeshVectorBone_( Mesh* obj,int varid ){
	switch (varid){
		case MESH_bones : return &obj->bones;
	}
	return NULL;
}

void MeshListPushBackSurface_( Mesh* obj,int varid,Surface* surf ){
	switch (varid){
		case MESH_surf_list : obj->surf_list.push_back(surf);
			break;
		case MESH_anim_surf_list : obj->anim_surf_list.push_back(surf);
			break;
	}
}

void MeshListPushBackBone_( Mesh* obj,int varid,Bone* bone ){
	switch (varid){
		case MESH_bones : obj->bones.push_back(bone);
			break;
	}
}

// Model

float* SurfaceCopyFloatArray_( Surface* obj,int varid,Surface* surf ){
	switch (varid){
		case SURFACE_vert_coords : obj->vert_coords=surf->vert_coords; return &obj->vert_coords[0];
		case SURFACE_vert_col : obj->vert_col=surf->vert_col; return &obj->vert_col[0];
		case SURFACE_vert_norm : obj->vert_norm=surf->vert_norm; return &obj->vert_norm[0];
		case SURFACE_vert_tex_coords0 : obj->vert_tex_coords0=surf->vert_tex_coords0; return &obj->vert_tex_coords0[0];
		case SURFACE_vert_tex_coords1 : obj->vert_tex_coords1=surf->vert_tex_coords1; return &obj->vert_tex_coords1[0];
	}
	return NULL;
}

float* SurfaceResizeFloatArray_( Surface* obj,int varid,Surface* surf ){
	switch (varid){
		case SURFACE_vert_coords : obj->vert_coords=surf->vert_coords; return &obj->vert_coords[0];
		case SURFACE_vert_weight1 : obj->vert_weight1.resize(surf->no_verts+1); return &obj->vert_weight1[0];
		case SURFACE_vert_weight2 : obj->vert_weight2.resize(surf->no_verts+1); return &obj->vert_weight2[0];
		case SURFACE_vert_weight3 : obj->vert_weight3.resize(surf->no_verts+1); return &obj->vert_weight3[0];
		case SURFACE_vert_weight4 : obj->vert_weight4.resize(surf->no_verts+1); return &obj->vert_weight4[0];
	}
	return NULL;
}

int* SurfaceResizeIntArray_( Surface* obj,int varid,Surface* surf ){
	switch (varid){
		case SURFACE_vert_bone1_no : obj->vert_bone1_no.resize(surf->no_verts+1); return &obj->vert_bone1_no[0];
		case SURFACE_vert_bone2_no : obj->vert_bone2_no.resize(surf->no_verts+1); return &obj->vert_bone2_no[0];
		case SURFACE_vert_bone3_no : obj->vert_bone3_no.resize(surf->no_verts+1); return &obj->vert_bone3_no[0];
		case SURFACE_vert_bone4_no : obj->vert_bone4_no.resize(surf->no_verts+1); return &obj->vert_bone4_no[0];
	}
	return NULL;
}

float* AnimationKeysResizeFloatArray_( AnimationKeys* obj,int varid,int a_frames ){
	switch (varid){
		case ANIMATIONKEYS_px : obj->px.resize(a_frames+1); return &obj->px[0];
		case ANIMATIONKEYS_py : obj->py.resize(a_frames+1); return &obj->py[0];
		case ANIMATIONKEYS_pz : obj->pz.resize(a_frames+1); return &obj->pz[0];
		case ANIMATIONKEYS_sx : obj->sx.resize(a_frames+1); return &obj->sx[0];
		case ANIMATIONKEYS_sy : obj->sy.resize(a_frames+1); return &obj->sy[0];
		case ANIMATIONKEYS_sz : obj->sz.resize(a_frames+1); return &obj->sz[0];
		case ANIMATIONKEYS_qw : obj->qw.resize(a_frames+1); return &obj->qw[0];
		case ANIMATIONKEYS_qx : obj->qx.resize(a_frames+1); return &obj->qx[0];
		case ANIMATIONKEYS_qy : obj->qy.resize(a_frames+1); return &obj->qy[0];
		case ANIMATIONKEYS_qz : obj->qz.resize(a_frames+1);	return &obj->qz[0];
	}
	return NULL;
}

int* AnimationKeysResizeIntArray_( AnimationKeys* obj,int varid,int a_frames ){
	switch (varid){
		case ANIMATIONKEYS_flags : obj->flags.resize(a_frames+1); return &obj->flags[0];
	}
	return NULL;
}

vector<Bone*>* MeshResizeBoneVector_( Mesh* obj,Bone* bo_bone,int bo_no_bones ){
	obj->bones.resize(bo_no_bones);
	obj->bones[bo_no_bones-1]=bo_bone; // store last bone
	return &obj->bones;
}

// Quaternion

float* QuaternionFloat_( Quaternion* obj,int varid ){
	switch (varid){
		case QUATERNION_x : return &obj->x;
		case QUATERNION_y : return &obj->y;
		case QUATERNION_z : return &obj->z;
		case QUATERNION_w : return &obj->w;
	}
	return NULL;
}

Quaternion* NewQuaternion_(){
	Quaternion* quat=new Quaternion();
	return quat;
}

// ShadowObject

char* ShadowObjectChar_( ShadowObject* obj,int varid ){
	switch (varid){
		case SHADOWOBJECT_Render : return (char*)&obj->Render;
		case SHADOWOBJECT_Static : return (char*)&obj->Static;
		case SHADOWOBJECT_VCreated : return (char*)&obj->VCreated;
	}
	return NULL;
}

int* ShadowObjectInt_( ShadowObject* obj,int varid ){
	switch (varid){
		case SHADOWOBJECT_cnt_tris : return &obj->cnt_tris;
	}
	return NULL;
}

Mesh* ShadowObjectMesh_( ShadowObject* obj,int varid ){
	switch (varid){
		case SHADOWOBJECT_Parent : return obj->Parent;
		case SHADOWOBJECT_ShadowMesh : return obj->ShadowMesh;
	}
	return NULL;
}

Surface* ShadowObjectSurface_( ShadowObject* obj,int varid ){
	switch (varid){
		case SHADOWOBJECT_ShadowVolume : return obj->ShadowVolume;
	}
	return NULL;
}

// Sprite

int* SpriteInt_( Sprite* obj,int varid ){
	switch (varid){
		case SPRITE_view_mode : return &obj->view_mode;
		case SPRITE_render_mode : return &obj->render_mode;
	}
	return NULL;
}

float* SpriteFloat_( Sprite* obj,int varid ){
	switch (varid){
		case SPRITE_angle : return &obj->angle;
		case SPRITE_scale_x : return &obj->scale_x;
		case SPRITE_scale_y : return &obj->scale_y;
		case SPRITE_handle_x : return &obj->handle_x;
		case SPRITE_handle_y : return &obj->handle_y;
	}
	return NULL;
}

// Surface

unsigned short* SurfaceUShort_( Surface* obj,int varid ){
	switch (varid){
		case SURFACE_tris : return &obj->tris[0];
	}
	return NULL;
}

int* SurfaceInt_( Surface* obj,int varid ){
	switch (varid){
		case SURFACE_no_verts : return &obj->no_verts;
		case SURFACE_no_tris : return &obj->no_tris;
		case SURFACE_vert_bone1_no : return &obj->vert_bone1_no[0];
		case SURFACE_vert_bone2_no : return &obj->vert_bone2_no[0];
		case SURFACE_vert_bone3_no : return &obj->vert_bone3_no[0];
		case SURFACE_vert_bone4_no : return &obj->vert_bone4_no[0];
		case SURFACE_vert_array_size : return &obj->vert_array_size;
		case SURFACE_tri_array_size : return &obj->tri_array_size;
		case SURFACE_vmin : return &obj->vmin;
		case SURFACE_vmax : return &obj->vmax;
		case SURFACE_vbo_enabled : return &obj->vbo_enabled;
		case SURFACE_reset_vbo : return &obj->reset_vbo;
		case SURFACE_alpha_enable : return &obj->alpha_enable;
		case SURFACE_has_tangents : return &obj->has_tangents;
	}
	return NULL;
}

unsigned int* SurfaceUInt_( Surface* obj,int varid ){
	switch (varid){
		case SURFACE_vbo_id : return &obj->vbo_id[0];
	}
	return NULL;
}

float* SurfaceFloat_( Surface* obj,int varid ){
	switch (varid){
		case SURFACE_vert_coords : return &obj->vert_coords[0];
		case SURFACE_vert_norm : return &obj->vert_norm[0];
		case SURFACE_vert_tex_coords0 : return &obj->vert_tex_coords0[0];
		case SURFACE_vert_tex_coords1 : return &obj->vert_tex_coords1[0];
		case SURFACE_vert_col : return &obj->vert_col[0];
		case SURFACE_vert_weight1 : return &obj->vert_weight1[0];
		case SURFACE_vert_weight2 : return &obj->vert_weight2[0];
		case SURFACE_vert_weight3 : return &obj->vert_weight3[0];
		case SURFACE_vert_weight4 : return &obj->vert_weight4[0];
		case SURFACE_vert_tan : return &obj->vert_tan[0];
		case SURFACE_vert_bitan : return &obj->vert_bitan[0];
	}
	return NULL;
}

Brush* SurfaceBrush_( Surface* obj,int varid ){
	switch (varid){
		case SURFACE_brush : return obj->brush;
	}
	return NULL;
}

Shader* SurfaceShader_( Surface* obj,int varid ){
	switch (varid){
		case SURFACE_ShaderMat : return obj->ShaderMat;
	}
	return NULL;
}

// Terrain

float* TerrainFloat_( Terrain* obj,int varid ){
	switch (varid){
		case TERRAIN_size : return &obj->size;
		case TERRAIN_vsize : return &obj->vsize;
		case TERRAIN_level2dzsize : return &obj->level2dzsize[0];
		case TERRAIN_height : return obj->height;		
	}
	return NULL;
}

Camera* TerrainCamera_( Terrain* obj,int varid ){
	switch (varid){
		case TERRAIN_eyepoint : return obj->eyepoint;
	}
	return NULL;
}

Shader* TerrainShader_( Terrain* obj,int varid ){
	switch (varid){
		case TERRAIN_ShaderMat : return obj->ShaderMat;
	}
	return NULL;
}

// Texture

int* TextureInt_( Texture* obj,int varid ){
	switch (varid){
		case TEXTURE_flags : return &obj->flags;
		case TEXTURE_blend : return &obj->blend;
		case TEXTURE_coords : return &obj->coords;
		case TEXTURE_width : return &obj->width;
		case TEXTURE_height : return &obj->height;
		case TEXTURE_no_frames : return &obj->no_frames;
		case TEXTURE_cube_face : return &obj->cube_face;
		case TEXTURE_cube_mode : return &obj->cube_mode;
	}
	return NULL;
}

unsigned int* TextureUInt_( Texture* obj,int varid ){
	switch (varid){
		case TEXTURE_texture : return &obj->texture;
		case TEXTURE_frames : return &obj->frames[0];
		case TEXTURE_framebuffer : return &obj->framebuffer[0];
	}
	return NULL;
}

unsigned int* TextureNewUIntArray_( Texture* obj,int varid,int array_size ){
	switch (varid){
		case TEXTURE_frames : obj->frames=new unsigned int[array_size]; return &obj->frames[0];
		case TEXTURE_framebuffer : obj->framebuffer=new unsigned int[array_size]; return &obj->framebuffer[0];
	}
	return NULL;
}

float* TextureFloat_( Texture* obj,int varid ){
	switch (varid){
		case TEXTURE_u_scale : return &obj->u_scale;
		case TEXTURE_v_scale : return &obj->v_scale;
		case TEXTURE_u_pos : return &obj->u_pos;
		case TEXTURE_v_pos : return &obj->v_pos;
		case TEXTURE_angle : return &obj->angle;
	}
	return NULL;
}

const char* TextureString_( Texture* obj,int varid ){
	switch (varid){
		case TEXTURE_file : return obj->file.c_str();
		case TEXTURE_file_abs : return obj->file_abs.c_str();
	}
	return NULL;
}

list<Texture*>* TextureListTexture_( Texture* obj,int varid ){
	switch (varid){
		case TEXTURE_tex_list : return &obj->tex_list;
		case TEXTURE_tex_list_all : return &obj->tex_list_all;
	}
	return NULL;
}

void GlobalListPushBackTexture_( int varid,Texture* obj ){
	switch (varid){
		case TEXTURE_tex_list : Texture::tex_list.push_back(obj);
			break;
		case TEXTURE_tex_list_all : Texture::tex_list_all.push_back(obj);
			break;
	}
}

void SetTextureString_( Texture* obj,int varid,char* cstr ){
	string str(cstr);
	switch (varid){
		case TEXTURE_file :
			obj->file=str;
			break;
		case TEXTURE_file_abs :
			obj->file_abs=str;
			break;
	}
}

} // end extern C
