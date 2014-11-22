/*
 *  pick.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "pick.h"

list<Entity*> Pick::ent_list;

float Pick::picked_x;
float Pick::picked_y;
float Pick::picked_z;
float Pick::picked_nx;
float Pick::picked_ny;
float Pick::picked_nz;
float Pick::picked_time;
Entity* Pick::picked_ent;
Surface* Pick::picked_surface;
int Pick::picked_triangle;

Entity* Pick::CameraPick(Camera* cam,float vx,float vy){
	
	cam->project_enabled=true;

	float px=0.0;
	float py=0.0;
	float pz=0.0;

	int r=gluUnProject(vx,vy,0.0,&cam->mod_mat[0],&cam->proj_mat[0],&cam->viewport[0],&px,&py,&pz);

	float x=px;
	float y=py;
	float z=-pz;
		
	r=gluUnProject(vx,vy,1.0,&cam->mod_mat[0],&cam->proj_mat[0],&cam->viewport[0],&px,&py,&pz);

	float x2=px;
	float y2=py;
	float z2=-pz;

	return PickMain(x,y,z,x2,y2,z2);

}

Entity* Pick::EntityPick(Entity* ent,float range){

	Entity::TFormPoint(0.0,0.0,0.0,ent,NULL);
	float x=Entity::TFormedX();
	float y=Entity::TFormedY();
	float z=Entity::TFormedZ();
	
	Entity::TFormPoint(0.0,0.0,range,ent,NULL);
	float x2=Entity::TFormedX();
	float y2=Entity::TFormedY();
	float z2=Entity::TFormedZ();
	
	return PickMain(x,y,z,x2,y2,z2);

}

Entity* Pick::LinePick(float x,float y,float z,float dx,float dy,float dz,float radius){

	return PickMain(x,y,z,x+dx,y+dy,z+dz,radius);

}

int Pick::EntityVisible(Entity* src_ent,Entity* dest_ent){

	// get pick values
	
	float px=picked_x;
	float py=picked_y;
	float pz=picked_z;
	float pnx=picked_nx;
	float pny=picked_ny;
	float pnz=picked_nz;
	float ptime=picked_time;
	Entity* pent=picked_ent;
	Surface* psurf=picked_surface;
	int ptri=picked_triangle;

	// perform line pick

	float ax=src_ent->EntityX(true);
	float ay=src_ent->EntityY(true);
	float az=src_ent->EntityZ(true);
	
	float bx=dest_ent->EntityX(true);
	float by=dest_ent->EntityY(true);
	float bz=dest_ent->EntityZ(true);

	Entity* pick=PickMain(ax,ay,az,bx,by,bz);
	
	// if picked entity was dest ent then dest_picked flag to true
	int dest_picked=false;
	if(picked_ent==dest_ent) dest_picked=true;
	
	// restore pick values
	
	picked_x=px;
	picked_y=py;
	picked_z=pz;
	picked_nx=pnx;
	picked_ny=pny;
	picked_nz=pnz;
	picked_time=ptime;
	picked_ent=pent;
	picked_surface=psurf;
	picked_triangle=ptri;
	
	// return false (not visible) if nothing picked, or dest ent wasn't picked
	if(pick!=NULL && dest_picked!=true){
	
		return false;
		
	}
	
	return true;
	
}

float Pick::PickedX(){
	return picked_x;
}

float Pick::PickedY(){
	return picked_y;
}

float Pick::PickedZ(){
	return picked_z;
}

float Pick::PickedNX(){
	return picked_nx;
}

float Pick::PickedNY(){
	return picked_ny;
}

float Pick::PickedNZ(){
	return picked_nz;
}

float Pick::PickedTime(){
	return picked_time;
}

Entity* Pick::PickedEntity(){
	return picked_ent;
}

Surface* Pick::PickedSurface(){
	return picked_surface;
}

int Pick::PickedTriangle(){
	return picked_triangle;
}

// requires two absolute positional values
Entity* Pick::PickMain(float ax,float ay,float az,float bx,float by,float bz,float radius){

	static Vector* c_vec_a=C_CreateVecObject(0.0,0.0,0.0);
	static Vector* c_vec_b=C_CreateVecObject(0.0,0.0,0.0);
	static Vector* c_vec_radius=C_CreateVecObject(0.0,0.0,0.0);
	static CollisionInfo* c_col_info=C_CreateCollisionInfoObject(c_vec_a,c_vec_b,c_vec_radius);

	static Line* c_line=C_CreateLineObject(0.0,0.0,0.0,0.0,0.0,0.0);

	static Vector* c_vec_i=C_CreateVecObject(0.0,0.0,0.0);
	static Vector* c_vec_j=C_CreateVecObject(0.0,0.0,0.0);
	static Vector* c_vec_k=C_CreateVecObject(0.0,0.0,0.0);

	static MMatrix* c_mat=C_CreateMatrixObject(c_vec_i,c_vec_j,c_vec_k);	
	static Vector* c_vec_v=C_CreateVecObject(0.0,0.0,0.0);
	static Transform* c_tform=C_CreateTFormObject(c_mat,c_vec_v);

	picked_ent=NULL;
	picked_time=1.0;

	C_UpdateLineObject(c_line,ax,ay,az,bx-ax,by-ay,bz-az);
	
	Collision* c_col=C_CreateCollisionObject();
	
	int pick=false;

	list<Entity*>::iterator it;
	c_col_info->coll_line=*c_line;
	c_col_info->radius=radius;
	
	for(it=Pick::ent_list.begin();it!=Pick::ent_list.end();++it){
		
		Entity &ent=**it;
		
		if((ent.pick_mode==0) || (ent.Hidden()==true)) continue;
					
		C_UpdateVecObject(c_vec_i,ent.mat.grid[0][0],ent.mat.grid[0][1],-ent.mat.grid[0][2]);
		C_UpdateVecObject(c_vec_j,ent.mat.grid[1][0],ent.mat.grid[1][1],-ent.mat.grid[1][2]);
		C_UpdateVecObject(c_vec_k,-ent.mat.grid[2][0],-ent.mat.grid[2][1],ent.mat.grid[2][2]);
		
		C_UpdateMatrixObject(c_mat,c_vec_i,c_vec_j,c_vec_k);
		C_UpdateVecObject(c_vec_v,ent.mat.grid[3][0],ent.mat.grid[3][1],-ent.mat.grid[3][2]);
		C_UpdateTFormObject(c_tform,c_mat,c_vec_v);
		
		// if pick mode is sphere or box then update collision info object to include entity radius/box info
		if(ent.pick_mode!=2){
			C_UpdateCollisionInfoObject(c_col_info,ent.radius_x,ent.box_x,ent.box_y,ent.box_z,ent.box_x+ent.box_w,ent.box_y+ent.box_h,ent.box_z+ent.box_d);
		}
	
		MeshCollider* tree=NULL;
		
		if(dynamic_cast<Mesh*>(&ent)!=0){
		
			Mesh* m=dynamic_cast<Mesh*>(&ent);
		
			m->TreeCheck(); // create collision tree for mesh if necessary
			tree=m->c_col_tree;
		} else if(dynamic_cast<Terrain*>(&ent)!=0){
			Terrain* t=dynamic_cast<Terrain*>(&ent);
			t->TreeCheck(c_col_info); // create collision tree for terrain if necessary
			tree=t->c_col_tree;
		}
	
		pick=C_Pick(c_col_info,c_line,radius,c_col,c_tform,tree,ent.pick_mode);
		
		if(pick){
			picked_ent=&ent;
		}
		
	}
	
	C_DeleteCollisionObject(c_col);

	if(picked_ent!=NULL){

		picked_x=C_CollisionX();
		picked_y=C_CollisionY();
		picked_z=C_CollisionZ();
		
		picked_nx=C_CollisionNX();
		picked_ny=C_CollisionNY();
		picked_nz=C_CollisionNZ();

		picked_time=C_CollisionTime();
		
		if(dynamic_cast<Mesh*>(picked_ent)){
			picked_surface=dynamic_cast<Mesh*>(picked_ent)->GetSurface(C_CollisionSurface());
		}else{
			picked_surface=NULL;
		}

		picked_triangle=C_CollisionTriangle();
		
	}
	
	return picked_ent;

}
