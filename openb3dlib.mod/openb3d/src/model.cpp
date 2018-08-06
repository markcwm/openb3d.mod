/*
 *  model.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "model.h"

#include "entity.h"
#include "bone.h"
#include "mesh.h"
#include "texture.h"
#include "animation_keys.h"
#include "quaternion.h"
#include "file.h"
//#include "misc.h"

const int TEXS=1;
const int BRUS=2;
const int NODE=3;
const int ANIM=4;
const int MESH=5;
const int VRTS=6;
const int TRIS=7;
const int BONE=8;
const int KEYS=9;

Mesh* LoadAnimB3D(string f_name,Entity* parent_ent_ext){

	// Start file reading

	File* file;

	file=File::ReadResourceFile(f_name);

	////if(file==NULL) RuntimeError("Could Not Find File");

	// dir stuff

	// get current dir - we'll change it back at end of func
	/* ***todo***
	Local cd$=CurrentDir$()

	// get directory of b3d file name, set current dir to match it so we can find textures
	Local dir$=f_name$
	Local ins=0
	while(Instr(dir,"\\",ins+1)!=0){
		ins=Instr(dir,"\\",ins+1);
	}
	while(Instr(dir,"/",ins+1)!=0){
		ins=Instr(dir,"/",ins+1);
	}
	if(ins!=0) dir=Left(dir,ins-1);

	if(dir!="") ChangeDir(dir);
	*/

	// Header info

	string tag;
	string prev_tag;
	string new_tag;

	tag=ReadTag(file);
	file->ReadInt();
	file->ReadInt();

	//int vno=
	file->ReadInt();


	//if(tag!="BB3D") RuntimeError(tag.c_str());//"Invalid b3d file");
	//if((vno/100)>0) RuntimeError("Invalid b3d file version");

	// Locals

	int size=0;
	int node_level=-1;
	int old_node_level=-1;
	int node_pos[100]={0};

	// tex local vars
	int tex_no=0;
	vector<Texture*> tex;
	string te_file="";
	int te_flags=0;
	int te_blend=0;
	int te_coords=0;
	float te_u_pos=0.0;
	float te_v_pos=0.0;
	float te_u_scale=0.0;
	float te_v_scale=0.0;
	float te_angle=0.0;

	// brush local vars
	int brush_no=0;
	vector<Brush*> brush;
	int b_no_texs=0;
	string b_name="";
	float b_red=0.0;
	float b_green=0.0;
	float b_blue=0.0;
	float b_alpha=0.0;
	float b_shine=0.0;
	int b_blend=0.0;
	int b_fx=0;
	int b_tex_id=0;

	// node local vars
	string n_name="";
	float n_px=0.0;
	float n_py=0.0;
	float n_pz=0.0;
	float n_sx=0.0;
	float n_sy=0.0;
	float n_sz=0.0;
	float n_rx=0.0;
	float n_ry=0.0;
	float n_rz=0.0;
	float n_qw=0.0;
	float n_qx=0.0;
	float n_qy=0.0;
	float n_qz=0.0;

	// mesh local vars
	Mesh* mesh=NULL;
	int m_brush_id=0;

	// verts local vars
	Mesh* v_mesh=NULL;
	Surface* v_surf=NULL;
	int v_flags=0;
	int v_tc_sets=0;
	int v_tc_size=0;
	int v_sz=0;
	float v_x=0.0;
	float v_y=0.0;
	float v_z=0.0;
	float v_nx=0.0;
	float v_ny=0.0;
	float v_nz=0.0;
	float v_r=0.0;
	float v_g=0.0;
	float v_b=0.0;
	float v_u=0.0;
	float v_v=0.0;
	float v_w=0.0;
	float v_a=0.0;
	int v_id=0;

	// tris local vars
	Surface* surf=NULL;
	int tr_brush_id=0;
	//int tr_sz=0;
	int tr_vid0=0;
	int tr_vid1=0;
	int tr_vid2=0;


	// anim local vars
	//int a_flags=0;
	int a_frames=0;
	//int a_fps=0;

	// bone local vars
	Bone* bo_bone=0;
	int bo_no_bones=0;
	int bo_vert_id=0;
	float bo_vert_w=0.0;

	// key local vars
	int k_flags=0;
	int k_frame=0;
	float k_px=0.0;
	float k_py=0.0;
	float k_pz=0.0;
	float k_sx=0.0;
	float k_sy=0.0;
	float k_sz=0.0;
	float k_qw=0.0;
	float k_qx=0.0;
	float k_qy=0.0;
	float k_qz=0.0;

	Entity* parent_ent=NULL; // parent_ent - used to keep track of parent entitys within model, separate to parent_ent_ext paramater which is external to model
	Entity* root_ent=NULL;

	Entity* last_ent=NULL; // last created entity, used for assigning parent ent in node code

	// Begin chunk (tag) reading

	do{

		new_tag=ReadTag(file);

		if(NewTag(new_tag)==true){

			prev_tag=tag;
			tag=new_tag;
			file->ReadInt();

			size=file->ReadInt();

			// deal with nested nodes

			old_node_level=node_level;
			if(tag=="NODE"){

				node_level=node_level+1;

				if(node_level>0){

					int fd=0;
					do{
						fd=file->FilePos()-node_pos[node_level-1];
						if(fd>=8){

							node_level=node_level-1;

						}

					}while(fd>=8);

				}

				node_pos[node_level]=file->FilePos()+size;

			}

			// up level
			if(node_level>old_node_level){

				if(node_level>0){
					parent_ent=last_ent;
				}else{
					parent_ent=NULL;
				}

			}

			// down level
			if(node_level<old_node_level){

				Entity* tent=root_ent;

				// get parent entity of last entity of new node level
				if(node_level>1){

					int cc=0;
					for(int levs=1;levs<=node_level-2;levs++){
						cc=tent->CountChildren();
						tent=tent->GetChild(cc);
					}
					cc=tent->CountChildren();
					tent=tent->GetChild(cc);
					parent_ent=tent;

				}

				if(node_level==1) parent_ent=root_ent;
				if(node_level==0) parent_ent=NULL;

			}

			// output debug tree
			string tab="";
			string info="";
			if(tag=="NODE"){
				//info=" (name="+last_ent->name+")";
				if(parent_ent!=NULL) info=info+" (parent= "+parent_ent->name+")";
			}
			for(int i=1;i<node_level;i++){
				tab=tab+"-";
			}
			//cout << tab << tag << info << endl;

		}else{

			tag="";

		}

		int tag_id=TagID(tag);

		if(tag_id==TEXS){

			//Local tex_no=0 // moved to top

			new_tag=ReadTag(file);

			while(NewTag(new_tag)!=true && file->Eof()==false){

				te_file=b3dReadString(file);

				te_flags=file->ReadInt();
				te_blend=file->ReadInt();
				te_u_pos=file->ReadFloat();
				te_v_pos=file->ReadFloat();
				te_u_scale=file->ReadFloat();
				te_v_scale=file->ReadFloat();
				te_angle=file->ReadFloat();

				// hidden tex coords 1 flag
				if(te_flags&65536){
					te_flags=te_flags-65536;
					te_coords=1;
				}else{
					te_coords=0;
				}

				// convert tex angle from rad to deg
				te_angle=te_angle*(180.0/PI);

				//todo*** - load tex after setting values
				// create texture object so we can set texture values (blend etc) before loading texture
				Texture* new_tex=new Texture();

				// .flags and .file set in LoadTexture
				new_tex->blend=te_blend;
				new_tex->coords=te_coords;
				new_tex->u_pos=te_u_pos;
				new_tex->v_pos=te_v_pos;
				new_tex->u_scale=te_u_scale;
				new_tex->v_scale=te_v_scale;
				new_tex->angle=te_angle;

				// load texture, providing texture we created above as parameter.
				// if a texture exists with all the same values as above (blend etc), the existing texture will be returned.
				// if not then the texture created above (supplied as param below) will be returned
				Texture* temp_tex=Texture::LoadTexture(te_file,te_flags,new_tex); //***todo***
				if(temp_tex!=NULL) new_tex=temp_tex; // crash if can't find texture fix
				//Texture* new_tex=Texture::LoadTexture(te_file,te_flags);

				/*new_tex->blend=te_blend;
				new_tex->coords=te_coords;
				new_tex->u_pos=te_u_pos;
				new_tex->v_pos=te_v_pos;
				new_tex->u_scale=te_u_scale;
				new_tex->v_scale=te_v_scale;
				new_tex->angle=te_angle;*/

				tex_no=tex_no+1;

				tex.push_back(new_tex);

				new_tag=ReadTag(file);

			}

		}else if(tag_id==BRUS){

			//Local brush_no=0 // moved to top

			b_no_texs=file->ReadInt();

			new_tag=ReadTag(file);

			while((NewTag(new_tag)!=true) && (file->Eof()==false)){

				b_name=b3dReadString(file);

				b_red=file->ReadFloat();

				b_green=file->ReadFloat();
				b_blue=file->ReadFloat();
				b_alpha=file->ReadFloat();
				b_shine=file->ReadFloat();
				b_blend=file->ReadInt();
				b_fx=file->ReadInt();

				Brush* new_brush=Brush::CreateBrush();
				new_brush->no_texs=b_no_texs;
				new_brush->name=b_name;
				new_brush->red=b_red;
				new_brush->green=b_green;
				new_brush->blue=b_blue;
				new_brush->alpha=b_alpha;

				new_brush->shine=b_shine;
				new_brush->blend=b_blend;
				new_brush->fx=b_fx;

				for(int ix=0;ix<b_no_texs;ix++){

					b_tex_id=file->ReadInt();

					if(b_tex_id>=0){
						new_brush->tex[ix]=tex[b_tex_id];
						new_brush->cache_frame[ix]=tex[b_tex_id]->texture;
						
						if (tex[b_tex_id]->flags&2 && new_brush->blend==1){
							new_brush->fx=new_brush->fx|32; // transparency fx for brush alpha tex
						}
					}else{
						new_brush->tex[ix]=NULL;
					}

				}

				brush_no=brush_no+1;

				brush.push_back(new_brush);

				new_tag=ReadTag(file);

			}

		}else if(tag_id==NODE){

			new_tag=ReadTag(file);

			n_name=b3dReadString(file);
			n_px=file->ReadFloat();
			n_py=file->ReadFloat();
			n_pz=file->ReadFloat()*-1;
			n_sx=file->ReadFloat();
			n_sy=file->ReadFloat();
			n_sz=file->ReadFloat();
			n_qw=file->ReadFloat();
			n_qx=file->ReadFloat();
			n_qy=file->ReadFloat();
			n_qz=file->ReadFloat();
			float pitch=0;
			float yaw=0;
			float roll=0;
			QuatToEuler(n_qw,n_qx,n_qy,-n_qz,pitch,yaw,roll);
			n_rx=-pitch;
			n_ry=yaw;
			n_rz=roll;

			new_tag=ReadTag(file);

			if(new_tag=="NODE" || new_tag=="ANIM"){

				// make //piv// entity a mesh, not a pivot, as B3D does
				Mesh* piv=new Mesh;
				piv->class_name="Mesh";

				piv->name=n_name;
				piv->px=n_px;
				piv->py=n_py;
				piv->pz=n_pz;
				piv->sx=n_sx;
				piv->sy=n_sy;
				piv->sz=n_sz;
				piv->rx=n_rx;
				piv->ry=n_ry;
				piv->rz=n_rz;
				piv->qw=n_qw;
				piv->qx=n_qx;
				piv->qy=n_qy;
				piv->qz=n_qz;

				//piv.UpdateMat(True)
				Entity::entity_list.push_back(piv);
				last_ent=piv;

				// root ent?
				if(root_ent==NULL) root_ent=piv;

				// if ent is root ent, and external parent specified, add parent
				if(root_ent==piv) piv->AddParent(parent_ent_ext);

				// if ent nested then add parent
				if(node_level>0) piv->AddParent(parent_ent);

				QuatToMat(-n_qw,n_qx,n_qy,-n_qz,piv->mat);

				piv->mat.grid[3][0]=n_px;
				piv->mat.grid[3][1]=n_py;
				piv->mat.grid[3][2]=n_pz;

				piv->mat.Scale(n_sx,n_sy,n_sz);

				if(piv->parent!=NULL){
					Matrix* new_mat=piv->parent->mat.Copy();
					new_mat->Multiply(piv->mat);
					piv->mat.Overwrite(*new_mat);//.Multiply(mat)
					delete new_mat;
				}

			}

		}else if(tag_id==MESH){

			m_brush_id=file->ReadInt();

			mesh=new Mesh;
			mesh->class_name="Mesh";
			mesh->name=n_name;
			mesh->px=n_px;
			mesh->py=n_py;
			mesh->pz=n_pz;
			mesh->sx=n_sx;
			mesh->sy=n_sy;
			mesh->sz=n_sz;
			mesh->rx=n_rx;
			mesh->ry=n_ry;
			mesh->rz=n_rz;
			mesh->qw=n_qw;
			mesh->qx=n_qx;
			mesh->qy=n_qy;
			mesh->qz=n_qz;

			Entity::entity_list.push_back(mesh);
			last_ent=mesh;

			// root ent?
			if(root_ent==NULL) root_ent=mesh;

			// if ent is root ent, and external parent specified, add parent
			if(root_ent==mesh) mesh->AddParent(parent_ent_ext);

			// if ent nested then add parent
			if(node_level>0) mesh->AddParent(parent_ent);

			QuatToMat(-n_qw,n_qx,n_qy,-n_qz,mesh->mat);

			mesh->mat.grid[3][0]=n_px;
			mesh->mat.grid[3][1]=n_py;
			mesh->mat.grid[3][2]=n_pz;

			mesh->mat.Scale(n_sx,n_sy,n_sz);

			if(mesh->parent!=NULL){
				Matrix* new_mat=mesh->parent->mat.Copy();
				new_mat->Multiply(mesh->mat);
				mesh->mat.Overwrite(*new_mat);//.Multiply(mat)
				delete new_mat;
			}

		}else if(tag_id==VRTS){

			if(v_mesh!=NULL) {
				v_mesh->FreeEntity();
				v_mesh=NULL;
			}
			if(v_surf!=NULL) {
				//delete v_surf;
				v_surf=NULL;
			}

			v_mesh=new Mesh;
			v_surf=v_mesh->CreateSurface();
			v_flags=file->ReadInt();
			v_tc_sets=file->ReadInt();
			v_tc_size=file->ReadInt();
			v_sz=12+v_tc_sets*v_tc_size*4;
			if(v_flags & 1) v_sz=v_sz+12;
			if(v_flags & 2) v_sz=v_sz+16;

			new_tag=ReadTag(file);

			while((NewTag(new_tag)!=true) && (file->Eof())==false){

				v_x=file->ReadFloat();
				v_y=file->ReadFloat();
				v_z=file->ReadFloat();

				if(v_flags&1){
					v_nx=file->ReadFloat();
					v_ny=file->ReadFloat();
					v_nz=file->ReadFloat();
				}

				if(v_flags&2){
					v_r=file->ReadFloat()*255.0; // *255 as VertexColor requires 0-255 values
					v_g=file->ReadFloat()*255.0;
					v_b=file->ReadFloat()*255.0;
					v_a=file->ReadFloat();
				}

				v_id=v_surf->AddVertex(v_x,v_y,v_z);
				v_surf->VertexColor(v_id,v_r,v_g,v_b,v_a);
				v_surf->VertexNormal(v_id,v_nx,v_ny,v_nz);

				//read tex coords...
				for(int j=0;j<v_tc_sets;j++){ // texture coords per vertex - 1 for simple uv, 8 max
					for(int k=1;k<v_tc_size+1;k++){ // components per set - 2 for simple uv, 4 max
						if(k==1) v_u=file->ReadFloat();
						if(k==2) v_v=file->ReadFloat();
						if(k==3) v_w=file->ReadFloat();
					}
					if(j==0 || j==1) v_surf->VertexTexCoords(v_id,v_u,v_v,v_w,j);
				}

				new_tag=ReadTag(file);

			}

		}else if(tag_id==TRIS){

			int old_tr_brush_id=tr_brush_id;
			tr_brush_id=file->ReadInt();

			// don't create new surface if tris chunk has same brush as chunk immediately before it
			if(prev_tag!="TRIS" || tr_brush_id!=old_tr_brush_id){
				// no further tri data for this surf - trim verts

				if(prev_tag=="TRIS") TrimVerts(surf);

				// new surf - copy arrays
				surf=mesh->CreateSurface();
				surf->vert_coords=v_surf->vert_coords;
				surf->vert_col=v_surf->vert_col;
				surf->vert_norm=v_surf->vert_norm;
				surf->vert_tex_coords0=v_surf->vert_tex_coords0;
				surf->vert_tex_coords1=v_surf->vert_tex_coords1;
				surf->no_verts=v_surf->no_verts;

			}

			//tr_sz=12;

			new_tag=ReadTag(file);

			while(NewTag(new_tag)!=true && file->Eof()==false){

				tr_vid0=file->ReadInt();
				tr_vid1=file->ReadInt();
				tr_vid2=file->ReadInt();

				// Find out minimum and maximum vertex indices - used for TrimVerts func after
				// (TrimVerts used due to .b3d format not being an exact fit with Blitz3D itself)
				if(tr_vid0<surf->vmin) surf->vmin=tr_vid0;
				if(tr_vid1<surf->vmin) surf->vmin=tr_vid1;
				if(tr_vid2<surf->vmin) surf->vmin=tr_vid2;

				if(tr_vid0>surf->vmax) surf->vmax=tr_vid0;
				if(tr_vid1>surf->vmax) surf->vmax=tr_vid1;
				if(tr_vid2>surf->vmax) surf->vmax=tr_vid2;

				surf->AddTriangle(tr_vid0,tr_vid1,tr_vid2);

				new_tag=ReadTag(file);

			}

			if(m_brush_id>-1) mesh->PaintEntity(*brush[m_brush_id]); // negative is invalid brush id
			if(tr_brush_id>-1) surf->PaintSurface(brush[tr_brush_id]);

			if( ( (v_flags & 1)==0) && (new_tag!="TRIS")) mesh->UpdateNormals(); // if no normal data supplied and no further tri data then update normals

			// no further tri data for this surface - trim verts
			if(new_tag!="TRIS") TrimVerts(surf);

		}else if(tag_id==ANIM){

			//a_flags=
			file->ReadInt();
			a_frames=file->ReadInt();
			//a_fps=
			file->ReadFloat();

			if(mesh!=NULL){

				mesh->anim=1;

				//mesh->frames=a_frames
				mesh->anim_seqs_first[0]=0;
				mesh->anim_seqs_last[0]=a_frames;

				// create anim surfs, copy vertex coords array, add to anim_surf_list
				list<Surface*>::iterator it;

				for(it=mesh->surf_list.begin();it!=mesh->surf_list.end();it++){

					Surface& surf=**it;

					Surface* anim_surf=new Surface();
					mesh->anim_surf_list.push_back(anim_surf);

					anim_surf->no_verts=surf.no_verts;

					anim_surf->vert_coords=surf.vert_coords;

					anim_surf->vert_bone1_no.resize(surf.no_verts+1);
					anim_surf->vert_bone2_no.resize(surf.no_verts+1);
					anim_surf->vert_bone3_no.resize(surf.no_verts+1);
					anim_surf->vert_bone4_no.resize(surf.no_verts+1);
					anim_surf->vert_weight1.resize(surf.no_verts+1);
					anim_surf->vert_weight2.resize(surf.no_verts+1);
					anim_surf->vert_weight3.resize(surf.no_verts+1);
					anim_surf->vert_weight4.resize(surf.no_verts+1);

					// transfer vmin/vmax values for using with TrimVerts func after
					anim_surf->vmin=surf.vmin;
					anim_surf->vmax=surf.vmax;

				}

			}

		}else if(tag_id==BONE){

			new_tag=ReadTag(file);

			bo_bone=new Bone;
			bo_no_bones=bo_no_bones+1;

			while(NewTag(new_tag)!=true && file->Eof()==false){

				bo_vert_id=file->ReadInt();
				bo_vert_w=file->ReadFloat();

				// assign weight values, with the strongest weight in vert_weight[1], and weakest in vert_weight[4]

				list<Surface*>::iterator it;

				for(it=mesh->anim_surf_list.begin();it!=mesh->anim_surf_list.end();it++){

					Surface& anim_surf=**it;

					if(bo_vert_id>=anim_surf.vmin && bo_vert_id<=anim_surf.vmax){

						int vid=bo_vert_id-anim_surf.vmin;

						if(bo_vert_w>anim_surf.vert_weight1[vid]){

							anim_surf.vert_bone4_no[vid]=anim_surf.vert_bone3_no[vid];
							anim_surf.vert_weight4[vid]=anim_surf.vert_weight3[vid];

							anim_surf.vert_bone3_no[vid]=anim_surf.vert_bone2_no[vid];
							anim_surf.vert_weight3[vid]=anim_surf.vert_weight2[vid];

							anim_surf.vert_bone2_no[vid]=anim_surf.vert_bone1_no[vid];
							anim_surf.vert_weight2[vid]=anim_surf.vert_weight1[vid];

							anim_surf.vert_bone1_no[vid]=bo_no_bones;
							anim_surf.vert_weight1[vid]=bo_vert_w;

						}else if(bo_vert_w>anim_surf.vert_weight2[vid]){

							anim_surf.vert_bone4_no[vid]=anim_surf.vert_bone3_no[vid];
							anim_surf.vert_weight4[vid]=anim_surf.vert_weight3[vid];

							anim_surf.vert_bone3_no[vid]=anim_surf.vert_bone2_no[vid];
							anim_surf.vert_weight3[vid]=anim_surf.vert_weight2[vid];

							anim_surf.vert_bone2_no[vid]=bo_no_bones;
							anim_surf.vert_weight2[vid]=bo_vert_w;

						}else if(bo_vert_w>anim_surf.vert_weight3[vid]){

							anim_surf.vert_bone4_no[vid]=anim_surf.vert_bone3_no[vid];
							anim_surf.vert_weight4[vid]=anim_surf.vert_weight3[vid];

							anim_surf.vert_bone3_no[vid]=bo_no_bones;
							anim_surf.vert_weight3[vid]=bo_vert_w;

						}else if(bo_vert_w>anim_surf.vert_weight4[vid]){

							anim_surf.vert_bone4_no[vid]=bo_no_bones;
							anim_surf.vert_weight4[vid]=bo_vert_w;

						}

					}

				}

				new_tag=ReadTag(file);

			}

			bo_bone->class_name="Bone";
			bo_bone->name=n_name;
			bo_bone->px=n_px;
			bo_bone->py=n_py;
			bo_bone->pz=n_pz;
			bo_bone->sx=n_sx;
			bo_bone->sy=n_sy;
			bo_bone->sz=n_sz;
			bo_bone->rx=n_rx;
			bo_bone->ry=n_ry;
			bo_bone->rz=n_rz;
			bo_bone->qw=n_qw;
			bo_bone->qx=n_qx;
			bo_bone->qy=n_qy;
			bo_bone->qz=n_qz;

			bo_bone->n_px=n_px;
			bo_bone->n_py=n_py;
			bo_bone->n_pz=n_pz;
			bo_bone->n_sx=n_sx;
			bo_bone->n_sy=n_sy;
			bo_bone->n_sz=n_sz;
			bo_bone->n_rx=n_rx;
			bo_bone->n_ry=n_ry;
			bo_bone->n_rz=n_rz;
			bo_bone->n_qw=n_qw;
			bo_bone->n_qx=n_qx;
			bo_bone->n_qy=n_qy;
			bo_bone->n_qz=n_qz;

			bo_bone->keys=new AnimationKeys();

			bo_bone->keys->frames=a_frames;
			bo_bone->keys->flags.resize(a_frames+1);
			bo_bone->keys->px.resize(a_frames+1);
			bo_bone->keys->py.resize(a_frames+1);
			bo_bone->keys->pz.resize(a_frames+1);
			bo_bone->keys->sx.resize(a_frames+1);
			bo_bone->keys->sy.resize(a_frames+1);
			bo_bone->keys->sz.resize(a_frames+1);
			bo_bone->keys->qw.resize(a_frames+1);
			bo_bone->keys->qx.resize(a_frames+1);
			bo_bone->keys->qy.resize(a_frames+1);
			bo_bone->keys->qz.resize(a_frames+1);

			// root ent?
			if(root_ent==NULL) root_ent=bo_bone;

			// if ent nested then add parent
			if(node_level>0) bo_bone->AddParent(parent_ent);

			QuatToMat(-bo_bone->n_qw,bo_bone->n_qx,bo_bone->n_qy,-bo_bone->n_qz,bo_bone->mat);

			bo_bone->mat.grid[3][0]=bo_bone->n_px;
			bo_bone->mat.grid[3][1]=bo_bone->n_py;
			bo_bone->mat.grid[3][2]=bo_bone->n_pz;

			if(bo_bone->parent!=NULL && dynamic_cast<Bone*>(bo_bone->parent)!=NULL){ // And... onwards needed to prevent inv_mat being incorrect if external parent supplied
				Matrix* new_mat=bo_bone->parent->mat.Copy();
				new_mat->Multiply(bo_bone->mat);
				bo_bone->mat.Overwrite(*new_mat);
				delete new_mat;
			}

			bo_bone->mat.GetInverse(bo_bone->inv_mat);

			if(new_tag!="KEYS"){
				Entity::entity_list.push_back(bo_bone);
				mesh->bones.resize(bo_no_bones);
				mesh->bones[bo_no_bones-1]=bo_bone;
				last_ent=bo_bone;
			}

		}else if(tag_id==KEYS){

			k_flags=file->ReadInt();

			new_tag=ReadTag(file);

			while(NewTag(new_tag)!=true && file->Eof()==false){

				k_frame=file->ReadInt();

				if(k_flags&1){
					k_px=file->ReadFloat();
					k_py=file->ReadFloat();
					k_pz=-file->ReadFloat();
				}
				if(k_flags&2){
					k_sx=file->ReadFloat();
					k_sy=file->ReadFloat();
					k_sz=file->ReadFloat();
				}
				if(k_flags&4){
					k_qw=-file->ReadFloat();
					k_qx=file->ReadFloat();
					k_qy=file->ReadFloat();
					k_qz=-file->ReadFloat();
				}

				if(bo_bone!=NULL){ // check if bo_bone exists - it won't for non-boned, keyframe anims

					bo_bone->keys->flags[k_frame]=bo_bone->keys->flags[k_frame]+k_flags;

					if(k_flags&1){
						bo_bone->keys->px[k_frame]=k_px;
						bo_bone->keys->py[k_frame]=k_py;
						bo_bone->keys->pz[k_frame]=k_pz;
					}
					if(k_flags&2){
						bo_bone->keys->sx[k_frame]=k_sx;
						bo_bone->keys->sy[k_frame]=k_sy;
						bo_bone->keys->sz[k_frame]=k_sz;
					}
					if(k_flags&4){
						bo_bone->keys->qw[k_frame]=k_qw;
						bo_bone->keys->qx[k_frame]=k_qx;
						bo_bone->keys->qy[k_frame]=k_qy;
						bo_bone->keys->qz[k_frame]=k_qz;
					}

				}
				new_tag=ReadTag(file);

			}

			if(new_tag!="KEYS"){

				if(bo_bone!=NULL){ // check if bo_bone exists - it won't for non-boned, keyframe anims

					Entity::entity_list.push_back(bo_bone);
					mesh->bones.resize(bo_no_bones);
					mesh->bones[bo_no_bones-1]=bo_bone;
					last_ent=bo_bone;

				}

			}

		}else{

			file->ReadByte();

		}

	}while(!file->Eof());

	file->CloseFile();

	vector<Brush*>::iterator it;

	for(it=brush.begin();it!=brush.end();it++){
		Brush* b=*it;
		delete b;
	}

	if(v_mesh!=NULL) {
		v_mesh->FreeEntity();
	}
	//ChangeDir(cd); // ***todo***

	//cout << endl << "Finished loading b3d" << endl;

	return dynamic_cast<Mesh*> (root_ent);

}


// Due to the .b3d format not being an exact fit with B3D, we need to slice vert arrays
// Otherwise we duplicate all vert information per surf
void TrimVerts(Surface* surf){

	if(surf->no_tris==0) return; // surf has no tri info, do not trim

	int vmin=surf->vmin;
	int vmax=surf->vmax;

	//surf->vert_coords=surf->vert_coords[vmin*3..vmax*3+3]
	vector<float> coords(surf->vert_coords.begin()+vmin*3,surf->vert_coords.begin()+vmax*3+3);
	surf->vert_coords=coords;

	//surf->vert_col=surf->vert_col[vmin*4..vmax*4+4]
	vector<float> col(surf->vert_col.begin()+vmin*4,surf->vert_col.begin()+vmax*4+4);
	surf->vert_col=col;

	//surf->vert_norm=surf->vert_norm[vmin*3..vmax*3+3]
	vector<float> norm(surf->vert_norm.begin()+vmin*3,surf->vert_norm.begin()+vmax*3+3);
	surf->vert_norm=norm;

	//surf->vert_tex_coords0=surf->vert_tex_coords0[vmin*2..vmax*2+2]
	vector<float> tex_coords0(surf->vert_tex_coords0.begin()+vmin*2,surf->vert_tex_coords0.begin()+vmax*2+2);
	surf->vert_tex_coords0=tex_coords0;

	//surf->vert_tex_coords1=surf->vert_tex_coords1[vmin*2..vmax*2+2]
	vector<float> tex_coords1(surf->vert_tex_coords1.begin()+vmin*2,surf->vert_tex_coords1.begin()+vmax*2+2);
	surf->vert_tex_coords1=tex_coords1;

	for(int i=0;i<((surf->no_tris*3)+3);i++){
		surf->tris[i]=surf->tris[i]-vmin; // reassign vertex indices
	}

	surf->no_verts=(vmax-vmin)+1;

}


string b3dReadString(File* file){
	string t="";
	for(;;){
		char ch=file->ReadByte();
		if(ch==0) return t;
		t=t+ch;
	}
}

string ReadTag(File* file){

	int pos=file->FilePos();

	string tag="";

	for(int i=0;i<4;i++){

		char rb=file->ReadByte();

		tag=tag+rb;

	}

	file->SeekFile(pos);

	//cout << endl << "tag: " << tag << endl;

	return tag;

}

int NewTag(string tag){

	if(tag=="TEXS") return true;
	if(tag=="BRUS") return true;
	if(tag=="NODE") return true;
	if(tag=="ANIM") return true;
	if(tag=="MESH") return true;
	if(tag=="VRTS") return true;
	if(tag=="TRIS") return true;
	if(tag=="BONE") return true;
	if(tag=="KEYS") return true;
	if(tag=="PHYS") return true;
	return false;

}

int TagID(string tag){

	if(tag=="TEXS") return TEXS;
	if(tag=="BRUS") return BRUS;
	if(tag=="NODE") return NODE;
	if(tag=="ANIM") return ANIM;
	if(tag=="MESH") return MESH;
	if(tag=="VRTS") return VRTS;
	if(tag=="TRIS") return TRIS;
	if(tag=="BONE") return BONE;
	if(tag=="KEYS") return KEYS;
	return 0;

}
