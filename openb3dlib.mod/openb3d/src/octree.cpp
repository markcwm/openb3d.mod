#include "global.h"
#include "entity.h"
#include "camera.h"
#include "brush.h"
#include "pick.h"
#include "octree.h"
#include "csg.h"

namespace CSG{
	void ScanObject(Mesh* mesh);
	void SplitTriangles(Mesh* obj1);
	void RebuildMesh(Mesh* mesh, Mesh* mesh2, int invert, int keepshared);

}

static Camera* EyePoint;
static Matrix* Mat;
//CollisionInfo* CI;
static Line Ray;
static float radius;

static MeshInfo* Mesh_info;
static int total_verts;
static float Xcf, Ycf, Zcf;

static list<Mesh*>* delete_list;



void OcTreeChild::AddToOctree(Mesh* mesh1, int level, float X, float Y, float Z, float Near, float Far, int block){


	if (X<x-width || X>=x+width) 
		return;
	if (Y<y-height || Y>=y+height) 
		return;
	if (Z<z-depth || Z>=z+depth) 
		return;
	
	if (level==0){
		mesh=mesh1;
		if (mesh!=0){
			if (block!=0){
				if (mesh->parent!=0) {
					mesh->parent->child_list.remove(mesh);
				}else{
					Global::root_ent->child_list.remove(mesh);
				}
			}else{
				mesh->hide=true;
			}
			mesh->Alpha();
		}
		/*mesh->GetBounds();
		if ((mesh->max_x>width	|| mesh->min_x<-width)	||
		    (mesh->max_y>height	|| mesh->min_y<-height)	||
		    (mesh->max_z>depth	|| mesh->min_z<-depth))	{
			mesh->FitMesh(-width, -height, -depth, width*2, height*2, depth*2,1);
		}*/


		node_near=Near*Near;
		node_far=Far*Far;

		isBlock=block;

		return;
	}

	if (child[0]==0){

		//isLeaf=0;
		for(int i=0;i<=7;i++){
			child[i]=new OcTreeChild;
			child[i]->width=width/2;
			child[i]->height=height/2;
			child[i]->depth=depth/2;
			child[i]->child[0]=0;
			child[i]->mesh=0;
			child[i]->node_far=1000000;


			switch(i){
				case 0:
					child[i]->x=x-width/2;
					child[i]->y=y-height/2;
					child[i]->z=z-depth/2;
					break;
				case 1:
					child[i]->x=x+width/2;
					child[i]->y=y-height/2;
					child[i]->z=z-depth/2;
					break;
				case 2:
					child[i]->x=x-width/2;
					child[i]->y=y+height/2;
					child[i]->z=z-depth/2;
					break;
				case 3:
					child[i]->x=x+width/2;
					child[i]->y=y+height/2;
					child[i]->z=z-depth/2;
					break;
				case 4:
					child[i]->x=x-width/2;
					child[i]->y=y-height/2;
					child[i]->z=z+depth/2;
					break;
				case 5:
					child[i]->x=x+width/2;
					child[i]->y=y-height/2;
					child[i]->z=z+depth/2;
					break;
				case 6:
					child[i]->x=x-width/2;
					child[i]->y=y+height/2;
					child[i]->z=z+depth/2;
					break;
				case 7:
					child[i]->x=x+width/2;
					child[i]->y=y+height/2;
					child[i]->z=z+depth/2;
			}
			child[i]->AddToOctree(mesh1, level-1, X, Y, Z, Near, Far, block);
		}
	} else{

		for(int i=0;i<=7;i++){
			child[i]->AddToOctree(mesh1, level-1, X, Y, Z, Near, Far, block);
		}
	}



}


OcTreeChild* OcTreeChild::CopyChild(){
	OcTreeChild* newchild=new OcTreeChild;
	newchild->width=width;
	newchild->height=height;
	newchild->depth=depth;

	newchild->x=x;
	newchild->y=y;
	newchild->z=z;

	newchild->node_near=node_near;
	newchild->node_far=node_far;

	newchild->isBlock=isBlock;
	if (isBlock!=0) 
		{newchild->mesh=mesh;}
	else
		{newchild->mesh=0;}

	if (child[0]!=0){
	
		for(int i=0;i<=7;i++){
			//child[i]->mat=mat;

			newchild->child[i]=child[i]->CopyChild();
		}

	}else{
		newchild->child[0]=0;
	}
	return newchild;
}

void OcTreeChild::FreeChild(){
	if (child[0]!=0){
	
		for(int i=0;i<=7;i++){
			//child[i]->mat=mat;

			child[i]->FreeChild();
		}

	}

	/*if (isBlock==0 && mesh!=0){
		//mesh->EntityParent(Global::root_ent);
		//mesh->FreeEntity();
	}*/

	delete this;

}

/*void OcTreeChild::FreeOctreeNode(int level, float X, float Y, float Z){
}*/

void OcTree::OctreeMesh(Mesh* mesh, int level, float X, float Y, float Z, float Near, float Far){
	mesh->EntityParent(this);
	mesh->HideEntity();
	child.AddToOctree(mesh, level, X, Y, Z, Near, Far, 0);

}

void OcTree::OctreeBlock(Mesh* mesh, int level, float X, float Y, float Z, float Near, float Far){
	child.AddToOctree(mesh, level, X, Y, Z, Near, Far, 1);

}



OcTree* OcTree::CreateOcTree(float w, float h, float d, Entity* parent_ent){

	OcTree* oct=new OcTree;

	oct->AddParent(*parent_ent);
	mesh_info=C_NewMeshInfo();
	oct->c_col_tree=C_CreateColTree(mesh_info);
	C_DeleteMeshInfo(mesh_info);

	terrain_list.push_back(oct);

	oct->child.width=w;//(mesh2->max_x-mesh2->min_x)/2;
	oct->child.height=h;//(mesh2->max_x-mesh2->min_x)/2;
	oct->child.depth=d;//(mesh2->max_x-mesh2->min_x)/2;

	oct->child.x=0;
	oct->child.y=0;
	oct->child.z=0;

	oct->child.child[0]=0;
	oct->child.mesh=0;
	oct->child.node_far=1000000;

	//oct->Rotation=&oct->rotmat;


	return oct;
}


void OcTree::UpdateTerrain(){

	if (Rendered_Blocks.size()>0){
		list<Mesh*>::iterator it;

		for(it=Rendered_Blocks.begin();it!=Rendered_Blocks.end();it++){
			Mesh* m=*it;
			delete m;
		}
		Rendered_Blocks.clear();
	}

	delete_list=&Rendered_Blocks;

	TFormPoint(eyepoint->EntityX(true), eyepoint->EntityY(true), eyepoint->EntityZ(true), 0, this);
	Xcf = tformed_x;
	Ycf = tformed_y;
	Zcf = -tformed_z;

	if(sx>=sy && sx>=sz){
		radius=sx;
	}else{
		if(sy>=sx && sy>=sz){
			radius=sy;
		}else{
			radius=sz;
		}
	}

	if(child.width>=child.height && child.width>=child.depth){
		radius=child.width*radius;
	}else{
		if(child.height>=child.width && child.height>=child.depth){
			radius=child.height*radius;
		}else{
			radius=child.depth*radius;
		}
	}

	float crs=radius*radius;
	radius=sqrt(crs+crs+crs)/child.width;



	EyePoint=eyepoint;
	Mat=&mat;
	child.RenderChild();
}



void OcTreeChild::RenderChild(){

	float vcx=x;
	float vcy=y;
	float vcz=z;

	float rd=radius*width;

	/*if(width>=height && width>=depth){
		rd=width*radius;
	}else{
		if(height>=width && height>=depth){
			rd=height*radius;
		}else{
			rd=depth*radius;
		}
	}

	float crs=rd*rd;
	rd=sqrt(crs+crs+crs);
	*/

	Mat->TransformVec(vcx, vcy, vcz, 1);

	for (int i = 0 ;i<= 5; i++){
		float d = EyePoint->frustum[i][0] * vcx + EyePoint->frustum[i][1] * vcy - EyePoint->frustum[i][2] * vcz + EyePoint->frustum[i][3];
		if (d <= -rd) return;//{ds=ds/10; break;}
	}



	float dx,dy,dz;	
	float rc;	

	/* compute distance from node To camera (squared) */
	dx = x - Xcf;
	dy = y - Ycf;
	dz = -z - Zcf;
	rc = dx*dx+dy*dy+dz*dz;




	if (rc>node_near && mesh!=0){
		Matrix mat2;
		mat2.LoadIdentity();


		if (isBlock==0){
			/*mat2.SetTranslate(x+mesh->px, y+mesh->py, -z-mesh->pz);
			mat2.Multiply2(*Mat);
			mesh->mat=mat2;*/
			if(mesh->Alpha()){
				mesh->alpha_order=EyePoint->EntityDistanceSquared(mesh);
			}

			EyePoint->RenderListAdd(mesh);				//A mesh is added to the render list, to be z-sorted
			mesh->hide=true;					//If it has been unhidden, hide it again
		}else{
			mat2.Scale(width, height, depth); 
			mat2.SetTranslate(x, y, -z);
			mat2.Multiply2(*Mat);
			if(mesh->Alpha()){
				Mesh* mesh_temp=new Mesh();			//An alpha block is cloned...

				mesh_temp->brush=mesh->brush;

				if(mesh->anim_render){
					mesh_temp->anim=mesh->anim;
					mesh_temp->anim_render=mesh->anim_render;
					mesh_temp->anim_surf_list=mesh->anim_surf_list;
				}
				mesh_temp->surf_list=mesh->surf_list;
				


				mesh_temp->mat=mat2;
				mesh_temp->alpha_order=EyePoint->EntityDistanceSquared(mesh);
				EyePoint->RenderListAdd(mesh_temp);		//and the clone is added to the render list, to be z-sorted

				delete_list->push_back(mesh_temp);

			}else{
				mesh->mat=mat2;
				mesh->Render();					//A non-alpha block is rendered immediately
			}
		}

	}
	if (child[0]!=0 && rc<node_far){
	
		for(int i=0;i<=7;i++){
			//child[i]->mat=mat;

			child[i]->RenderChild();
		}

	}

}




void OcTree::TreeCheck(CollisionInfo* ci){

	if (Rendered_Meshes.size()>0){
		list<Mesh*>::iterator it;

		for(it=Rendered_Meshes.begin();it!=Rendered_Meshes.end();it++){
			Mesh* m=*it;
			m->hide=true;		//If it has been unhidden, hide it again
		}
		Rendered_Meshes.clear();
	}

	delete_list=&Rendered_Meshes;



	Mat=&mat;
	//CI=ci;
	Ray=ci->coll_line;
	//radius=ci->radius;

	if(sx>=sy && sx>=sz){
		radius=sx;
	}else{
		if(sy>=sx && sy>=sz){
			radius=sy;
		}else{
			radius=sz;
		}
	}

	if(c_col_tree!=NULL){
		C_DeleteColTree(c_col_tree);
		c_col_tree=NULL;
	}

	if(child.width>=child.height && child.width>=child.depth){
		radius=child.width*radius;
	}else{
		if(child.height>=child.width && child.height>=child.depth){
			radius=child.height*radius;
		}else{
			radius=child.depth*radius;
		}
	}

	float crs=radius*radius;
	radius=sqrt(crs+crs+crs)/child.width;

	mesh_info=C_NewMeshInfo();
	total_verts=0;

	Mesh_info=mesh_info;

	child.Coll_Child();

	c_col_tree=C_CreateColTree(mesh_info);
	C_DeleteMeshInfo(mesh_info);


}

void OcTreeChild::Coll_Child(){

	float vcx=x;
	float vcy=y;
	float vcz=z;

	float rd=radius*width;
	/*float rd;

	if(width>=height && width>=depth){
		rd=width;
	}else{
		if(height>=width && height>=depth){
			rd=height;
		}else{
			rd=depth;
		}
	}

	float crs=rd*rd;
	rd=sqrt(crs+crs+crs)*radius;*/

	Mat->TransformVec(vcx, vcy, vcz, 1);

	Vector Sphere;
	Sphere.x=vcx;
	Sphere.y=vcy;
	Sphere.z=vcz;
	Line dst( Ray.o-Sphere,Ray.d );

	float a=dst.d.dot(dst.d);
	if( !a ) return;
	float b=dst.o.dot(dst.d)*2;
	float c=dst.o.dot(dst.o)-rd*rd;
	float d=b*b-4*a*c;

	if (d<0) return;

	float t1=(-b+sqrt(d))/(2*a);
	float t2=(-b-sqrt(d))/(2*a);

	float t=t1<t2 ? t1 : t2;

	if (t>1) return;



	if (mesh!=0 && node_near <.0000001){
		/*Matrix mat2;
		mat2.LoadIdentity();
		mat2.SetTranslate(x, y, -z);

		mat2.Multiply2(*Mat);

		mesh->mat=mat2;*/



		/*for(int s=1;s<=mesh->CountSurfaces();s++){

			Surface* surf=mesh->GetSurface(s);*/
		if (isBlock==1){
			list<Surface*>::iterator surf_it;


			for(surf_it=mesh->surf_list.begin();surf_it!=mesh->surf_list.end();surf_it++){


				Surface* surf=*surf_it;

				int no_tris=surf->no_tris;
				int no_verts=surf->no_verts;

				// copy arrays
				short* tris=new short[no_tris*3];
				float* verts=new float[no_verts*3];
				for(int i=0;i<no_tris*3;i++){
					tris[i]=surf->tris[i];
				}

				for(int i=0;i<no_verts;i++){
					verts[i*3]=surf->vert_coords[i*3]*width+x;
					verts[i*3+1]=surf->vert_coords[i*3+1]*height+y;
					verts[i*3+2]=-surf->vert_coords[i*3+2]*depth+z;		//A block is scaled
				}

				if(no_tris!=0 && no_verts!=0){

					// inc vert index
					for(int i=0;i<=no_tris-1;i++){
						tris[i*3+0]+=total_verts;
						tris[i*3+1]+=total_verts;
						tris[i*3+2]+=total_verts;
					}

					// reverse vert order
					for(int i=0;i<=no_tris-1;i++){
						int t_v0=tris[i*3+0];
						int t_v2=tris[i*3+2];
						tris[i*3+0]=t_v2;
						tris[i*3+2]=t_v0;
					}

					// negate z vert coords
					/*for(int i=0;i<=no_verts-1;i++){
						verts[i*3+2]=-verts[i*3+2];
					}*/

					C_AddSurface(Mesh_info,no_tris,no_verts,tris,verts,0);

					total_verts+=no_verts;

				}

				delete [] tris;
				delete [] verts;
			}

		} else {
			mesh->hide=false;		//Unhide mesh, so collision checking can be done
			delete_list->push_back(mesh);

		}


//mesh->EntityColor(255-(mesh->brush.red*255),0,0);



	}
	if (child[0]!=0){
	
		for(int i=0;i<=7;i++){
			//child[i]->mat=mat;

			child[i]->Coll_Child();
		}

	}

}


void OcTree::FreeEntity(){


	if (Rendered_Blocks.size()>0){
		list<Mesh*>::iterator it;

		for(it=Rendered_Blocks.begin();it!=Rendered_Blocks.end();it++){
			Mesh* m=*it;
			delete m;
		}
		Rendered_Blocks.clear();
	}


	delete c_col_tree;

	if (child.child[0]!=0){
	
		for(int i=0;i<=7;i++){
			//child[i]->mat=mat;

			child.child[i]->FreeChild();
		}

	}


	Entity::FreeEntity();

	delete this;

	return;

}


OcTree* OcTree::CopyEntity(Entity* parent_ent){

	// new octree
	OcTree* oct=new OcTree;

	// copy contents of child list before adding parent
	list<Entity*>::iterator it;
	for(it=child_list.begin();it!=child_list.end();it++){
		Entity* ent=*it;
		ent->CopyEntity(oct);
	}

	// lists

	// add parent, add to list
	oct->AddParent(*parent_ent);
	entity_list.push_back(oct);

	// add to collision entity list
	if(collision_type!=0){
		CollisionPair::ent_lists[collision_type].push_back(oct);
	}

	// add to pick entity list
	if(pick_mode){
		Pick::ent_list.push_back(oct);
	}

	// update matrix
	if(oct->parent){
		oct->mat.Overwrite(oct->parent->mat);
	}else{
		oct->mat.LoadIdentity();
	}

	// copy entity info

	oct->mat.Multiply(mat);

	oct->px=px;
	oct->py=py;
	oct->pz=pz;
	oct->sx=sx;
	oct->sy=sy;
	oct->sz=sz;
	oct->rx=rx;
	oct->ry=ry;
	oct->rz=rz;
	oct->qw=qw;
	oct->qx=qx;
	oct->qy=qy;
	oct->qz=qz;

	oct->name=name;
	oct->class_name=class_name;
	oct->order=order;
	oct->hide=false;

	oct->cull_radius=cull_radius;
	oct->radius_x=radius_x;
	oct->radius_y=radius_y;
	oct->box_x=box_x;
	oct->box_y=box_y;
	oct->box_z=box_z;
	oct->box_w=box_w;
	oct->box_h=box_h;
	oct->box_d=box_d;
	oct->collision_type=collision_type;
	oct->pick_mode=pick_mode;
	oct->obscurer=obscurer;

	//copy octree info
	oct->child.width=child.width;
	oct->child.height=child.height;
	oct->child.depth=child.depth;

	oct->child.x=child.x;
	oct->child.y=child.y;
	oct->child.z=child.z;

	oct->child.child[0]=0;
	if (child.isBlock!=0)
		{oct->child.mesh=child.mesh;}
	else
		{oct->child.mesh=0;}
	oct->child.node_far=child.node_far;
	oct->child.node_near=child.node_near;
	oct->child.isBlock=child.isBlock;

	if (child.child[0]!=0){
	
		for(int i=0;i<=7;i++){
			oct->child.child[i]=child.child[i]->CopyChild();
		}

	}

	mesh_info=C_NewMeshInfo();
	oct->c_col_tree=C_CreateColTree(mesh_info);
	C_DeleteMeshInfo(mesh_info);

	terrain_list.push_back(oct);


	return oct;
}
