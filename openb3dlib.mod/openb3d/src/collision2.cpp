/*
 *  collision2.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "collision2.h"

#include "entity.h"
#include "pivot.h"
#include "mesh.h"
#include "camera.h"
#include "terrain.h"
#include "surface.h"
#include "collision.h"
#include "tree.h"
#include "geom.h"

#include <vector>
#include <list>
#include <iostream>

using namespace std;

extern Vector col_coords;

list<CollisionPair*> CollisionPair::cp_list;
list<Entity*> CollisionPair::ent_lists[MAX_TYPES];

 // dynamic to static
void UpdateCollisions(){
	UpdateStaticCollisions();
	UpdateDynamicCollisions();
}

int PositionEntities(int update_old,int add_to_new){
	int new_pos=false;
	list<CollisionPair*>::iterator cp_it;
	for(cp_it=CollisionPair::cp_list.begin();cp_it!=CollisionPair::cp_list.end();cp_it++){
		CollisionPair col_pair=**cp_it;

		// loop through src entities
		list<Entity*>::iterator src_ent_it;
		for(src_ent_it=CollisionPair::ent_lists[col_pair.src_type].begin();src_ent_it!=CollisionPair::ent_lists[col_pair.src_type].end();src_ent_it++){
			Entity& ent=**src_ent_it;
			if(ent.no_collisions!=0){
				if(update_old){
					ent.old_x=ent.EntityX(true);
					ent.old_y=ent.EntityY(true);
					ent.old_z=ent.EntityZ(true);
				}

				if(add_to_new){
					ent.new_x=(ent.new_x-ent.EntityX(true))+ent.EntityX(true);
					ent.new_y=(ent.new_y-ent.EntityY(true))+ent.EntityY(true);
					ent.new_z=(ent.new_z-ent.EntityZ(true))+ent.EntityZ(true);
				}
				ent.PositionEntity(ent.new_x,ent.new_y,ent.new_z);
				new_pos=true;
			}
		}
	}

	return new_pos;

}

void clearCollisions(){

	list<CollisionPair*>::iterator cp_it;

	for(cp_it=CollisionPair::cp_list.begin();cp_it!=CollisionPair::cp_list.end();cp_it++){

		CollisionPair col_pair=**cp_it;

		// loop through src entities
		list<Entity*>::iterator src_ent_it;

		for(src_ent_it=CollisionPair::ent_lists[col_pair.src_type].begin();src_ent_it!=CollisionPair::ent_lists[col_pair.src_type].end();src_ent_it++){

			Entity& ent=**src_ent_it;

			ent.no_collisions=0;
			for(unsigned int ix=0;ix<ent.collision.size();ix++){
				delete ent.collision[ix];
			}
			ent.collision.clear();
		}
	}
}

void UpdateStaticCollisions(){
	list<CollisionPair*>::iterator cp_it;
	for(cp_it=CollisionPair::cp_list.begin();cp_it!=CollisionPair::cp_list.end();cp_it++){
		CollisionPair col_pair=**cp_it;

		// if no entities exist of src_type or des_type then do not check for collisions
		if((CollisionPair::ent_lists[col_pair.src_type].size()==0)||(CollisionPair::ent_lists[col_pair.des_type].size()==0)) continue;

		// loop through src entities
		list<Entity*>::iterator src_ent_it;

		for(src_ent_it=CollisionPair::ent_lists[col_pair.src_type].begin();src_ent_it!=CollisionPair::ent_lists[col_pair.src_type].end();src_ent_it++){
			Entity& ent=**src_ent_it;
			// clear collisions
			ent.no_collisions=0;
			for(unsigned int ix=0;ix<ent.collision.size();ix++){
				delete ent.collision[ix];
			}
			ent.collision.clear();

			// if src entity is hidden or it's parent is hidden then do not check for collision
			if(ent.Hidden()==true) continue;

			Vector c_vec_a(ent.EntityX(true),ent.EntityY(true),ent.EntityZ(true));
			Vector c_vec_b(ent.old_x,ent.old_y,ent.old_z);
			Vector c_vec_radius(ent.radius_x,ent.radius_y,ent.radius_x);

			CollisionInfo* c_col_info=C_CreateCollisionInfoObject(&c_vec_a,&c_vec_b,&c_vec_radius);

			Collision* c_coll=NULL;

			int response=0;

			// repeat until there's no collision between src and dest entities
			for(;;){
				int hit=false;

				c_coll=C_CreateCollisionObject();
				Entity* ent2_hit=NULL;

				// loop through des entities that are paired with src entities
				list<Entity*>::iterator des_ent_it;

				for(des_ent_it=CollisionPair::ent_lists[col_pair.des_type].begin();des_ent_it!=CollisionPair::ent_lists[col_pair.des_type].end();des_ent_it++){
					Entity& ent2=**des_ent_it;

					// if des entity is hidden or it's parent is hidden then do not check for collision
					if(ent2.Hidden()==true) continue;

					// if src ent is same as des entity then do not check for collision
					if(&ent==&ent2) continue;

					//if(QuickCheck(ent,ent2)==false) continue; // quick check to see if entities are colliding
					Matrix mat;

					if(ent2.dynamic!=true){
						mat.Overwrite(ent2.mat);
					}else{
						mat.Overwrite(ent2.old_mat);
					}

					Vector c_vec_i(mat.grid[0][0],mat.grid[0][1],-mat.grid[0][2]);
					Vector c_vec_j(mat.grid[1][0],mat.grid[1][1],-mat.grid[1][2]);
					Vector c_vec_k(-mat.grid[2][0],-mat.grid[2][1],mat.grid[2][2]);

					MMatrix c_mat(c_vec_i,c_vec_j,c_vec_k);
					Vector c_vec_v(mat.grid[3][0],mat.grid[3][1],-mat.grid[3][2]);

					Transform c_tform(c_mat,c_vec_v);

					// if pick mode is sphere or box then update collision info object to include entity radius/box info
					if(col_pair.col_method!=COLLISION_METHOD_POLYGON){
						C_UpdateCollisionInfoObject(c_col_info,ent2.radius_x,ent2.box_x,ent2.box_y,ent2.box_z,ent2.box_x+ent2.box_w,ent2.box_y+ent2.box_h,ent2.box_z+ent2.box_d);
					}

					MeshCollider* tree=NULL;
					if(dynamic_cast<Mesh*>(&ent2)!=0){
						Mesh* m=dynamic_cast<Mesh*>(&ent2);
						m->TreeCheck(); // create collision tree for mesh if necessary
						tree=m->c_col_tree;
					}else if(dynamic_cast<Terrain*>(&ent2)!=0){
						Terrain* t=dynamic_cast<Terrain*>(&ent2);
						t->TreeCheck(c_col_info); // create collision tree for terrain if necessary
						tree=t->c_col_tree;
					}


					hit=C_CollisionDetect(c_col_info,c_coll,&c_tform,tree,col_pair.col_method);

					if(hit){

						ent2_hit=&ent2;

					}

					response=col_pair.response;

				} // end of dest ent loop

				if(ent2_hit){

					ent.no_collisions=ent.no_collisions+1;

					//int i=ent.no_collisions-1;
					CollisionImpact* eci=new CollisionImpact;
					ent.collision.push_back(eci);

					eci->x=C_CollisionX();
					eci->y=C_CollisionY();
					eci->z=C_CollisionZ();
					eci->nx=C_CollisionNX();
					eci->ny=C_CollisionNY();
					eci->nz=C_CollisionNZ();
					eci->ent=ent2_hit;

					if(dynamic_cast<Mesh*>(ent2_hit)!=NULL){
						eci->surf=dynamic_cast<Mesh*>(ent2_hit)->GetSurface(C_CollisionSurface());
					}else{
						eci->surf=NULL;
					}

					eci->tri=C_CollisionTriangle();

					if(C_CollisionResponse(c_col_info,c_coll,response)==false) break;

				}else{

					break;

				}

				C_DeleteCollisionObject(c_coll);

			} // end of infinite loop

			C_DeleteCollisionObject(c_coll);

			int hits=C_CollisionFinal(c_col_info);

			if(hits){

				ent.new_x=C_CollisionPosX();
				ent.new_y=C_CollisionPosY();
				ent.new_z=C_CollisionPosZ();

				// moved from PositionEntities
				ent.PositionEntity(ent.new_x,ent.new_y,ent.new_z,true);
			}
			C_DeleteCollisionInfoObject(c_col_info);
		} // end of src ent loop
	} // end of collision pair loop
}

// dynamic to dynamic
void UpdateDynamicCollisions(){

	Vector c_vec_i(1.0,0.0,0.0);
	Vector c_vec_j(0.0,1.0,0.0);
	Vector c_vec_k(0.0,0.0,1.0);

	MMatrix c_mat(c_vec_i,c_vec_j,c_vec_k);
	Vector c_vec_v(0.0,0.0,0.0);

	Transform c_tform(c_mat,c_vec_v);

	static Pivot* piv1o=Pivot::CreatePivot();
	static Pivot* piv1=Pivot::CreatePivot(piv1o);
	static Pivot* piv11=Pivot::CreatePivot(piv1o);
	static Pivot* piv111=Pivot::CreatePivot(piv1o);

	static Pivot* piv2o=Pivot::CreatePivot();
	static Pivot* piv2=Pivot::CreatePivot(piv2o);

	/*static Mesh* sphere=Mesh::CreateSphere();
	sphere->HideEntity();*/

	list<CollisionPair*>::iterator cp_it;

	for(cp_it=CollisionPair::cp_list.begin();cp_it!=CollisionPair::cp_list.end();cp_it++){
		CollisionPair col_pair=**cp_it;

		// if no entities exist of src_type or des_type then do not check for collisions
		if((CollisionPair::ent_lists[col_pair.src_type].size()==0)||(CollisionPair::ent_lists[col_pair.des_type].size()==0)) continue;

		// loop through src entities
		list<Entity*>::iterator src_ent_it;

		for(src_ent_it=CollisionPair::ent_lists[col_pair.src_type].begin();src_ent_it!=CollisionPair::ent_lists[col_pair.src_type].end();src_ent_it++){

			Entity& ent=**src_ent_it;

			// if src entity is hidden or it's parent is hidden then do not check for collision
			if(ent.Hidden()==true) continue;

			// loop through des entities that are paired with src entities
			list<Entity*>::iterator des_ent_it;

			for(des_ent_it=CollisionPair::ent_lists[col_pair.des_type].begin();des_ent_it!=CollisionPair::ent_lists[col_pair.des_type].end();des_ent_it++){

				Entity& ent2=**des_ent_it;

				if(ent2.dynamic!=true) continue;

				// if des entity is hidden or it's parent is hidden then do not check for collision
				if(ent2.Hidden()==true) continue;

				// if src ent is same as des entity then do not check for collision
				if(&ent==&ent2) continue;

				//if(QuickCheckDynamic(ent,ent2)==false) continue; // quick check to see if entities are colliding

				float dx;
				float dy;
				float dz;

				dx=ent.EntityX(true)-ent2.EntityX(true);
				dy=ent.EntityY(true)-ent2.EntityY(true);
				dz=ent.EntityZ(true)-ent2.EntityZ(true);

				float dx2;
				float dy2;
				float dz2;

				dx2=ent.old_x-ent2.old_x;
				dy2=ent.old_y-ent2.old_y;
				dz2=ent.old_z-ent2.old_z;

				piv1->PositionEntity(dx,dy,dz,false);
				piv2->PositionEntity(dx2,dy2,dz2,false);

				//piv1o->RotateEntity(-ent2.mat.GetPitch(),-ent2.mat.GetYaw(),-ent2.mat.GetRoll());
				ent2.mat.GetInverse2(piv1o->mat);
				piv1o->mat.SetTranslate(0,0,0);
				piv1->MQ_Update();
				piv11->MQ_Update();
				piv111->MQ_Update();
				//piv2o->RotateEntity(-ent2.old_pitch,-ent2.old_yaw,-ent2.old_roll);
				ent2.old_mat.GetInverse2(piv2o->mat);
				piv2o->mat.SetTranslate(0,0,0);
				piv2->MQ_Update();

				float xx=1,xy=0,xz=0;
				float yx=0,yy=1,yz=0;
				float zx=0,zy=0,zz=1;

				ent2.mat.TransformVec(xx,xy,xz);
				ent2.mat.TransformVec(yx,yy,yz);
				ent2.mat.TransformVec(zx,zy,zz);

				piv1o->sx=1/sqrt((xx*xx)+(xy*xy)+(xz*xz));
				piv1o->sy=1/sqrt((yx*yx)+(yy*yy)+(yz*yz));
				piv1o->sz=1/sqrt((zx*zx)+(zy*zy)+(zz*zz));


				Vector vec_a(piv1->EntityX(true),piv1->EntityY(true),piv1->EntityZ(true));
				Vector vec_b(piv2->EntityX(true),piv2->EntityY(true),piv2->EntityZ(true));
				Vector vec_radius(ent.radius_x*piv1o->sx,ent.radius_x*piv1o->sy,ent.radius_x*piv1o->sz);

				CollisionInfo* c_col_info=C_CreateCollisionInfoObject(&vec_a,&vec_b,&vec_radius);

				//

				MeshCollider* tree=NULL;
				if(dynamic_cast<Mesh*>(&ent2)!=0){
					Mesh* m=dynamic_cast<Mesh*>(&ent2);
					m->TreeCheck(); // create collision tree for mesh if necessary
					tree=m->c_col_tree;
				}

				Collision* c_coll=NULL;
				// repeat until there's no collision between src and dest entities

				for(;;){

					c_coll=C_CreateCollisionObject();

					int hit=C_CollisionDetect(c_col_info,c_coll,&c_tform,tree,2); // method set to 2

					if(hit){

						if(C_CollisionResponse(c_col_info,c_coll,col_pair.response)==false) break;

					}else{

						break;

					}

					C_DeleteCollisionObject(c_coll);

				}

				C_DeleteCollisionObject(c_coll);

				int hits=C_CollisionFinal(c_col_info);

				if(hits){

					// register collision

					ent.no_collisions=ent.no_collisions+1;

					//int i=ent.no_collisions-1;
					CollisionImpact* eci=new CollisionImpact;
					ent.collision.push_back(eci);

					eci->x=C_CollisionX();
					eci->y=C_CollisionY();
					eci->z=C_CollisionZ();
					eci->nx=C_CollisionNX();
					eci->ny=C_CollisionNY();
					eci->nz=C_CollisionNZ();
					eci->ent=&ent2;

					if(dynamic_cast<Mesh*>(&ent2)!=NULL){
						eci->surf=dynamic_cast<Mesh*>(&ent2)->GetSurface(C_CollisionSurface());
					}else{
						eci->surf=NULL;
					}

					eci->tri=C_CollisionTriangle();

					//

					float x=C_CollisionPosX();
					float y=C_CollisionPosY();
					float z=C_CollisionPosZ();

					piv1o->RotateEntity(0,0,0);

					piv1->PositionEntity(x,y,z,true);
					piv11->PositionEntity(eci->x,eci->y,eci->z,true);

					//piv2o->RotateEntity(0,0,0,false);
					//piv2o->ScaleEntity(1,1,1,false);
					piv2o->mat.LoadIdentity();
					piv2->PositionEntity(eci->nx,eci->ny,eci->nz,false);

					//piv1o->PositionEntity(ent2.EntityX(true),ent2.EntityY(true),ent2.EntityZ(true),true);
					//piv1o->RotateEntity(ent2.mat.GetPitch(),ent2.mat.GetYaw(),ent2.mat.GetRoll());
					//piv1o->ScaleEntity(1, 1, 1);
					piv1o->mat.Overwrite(ent2.mat);
					piv1o->mat.Scale(piv1o->sx,piv1o->sy,piv1o->sz);
					piv1->MQ_Update();
					piv11->MQ_Update();


					//piv2o->RotateEntity(ent2.EntityPitch(),ent2.EntityYaw(),ent2.EntityRoll());
					piv2o->mat.Overwrite(ent2.mat);
					piv2o->mat.SetTranslate(0,0,0);
					piv2->MQ_Update();


					x=piv1->EntityX(true);
					y=piv1->EntityY(true);
					z=piv1->EntityZ(true);

					//sphere->PositionEntity(x,y,z,true);

					ent.new_x=x;
					ent.new_y=y;
					ent.new_z=z;

					// moved from PositionEntities

					/*ent.new_x=(ent.new_x-ent.EntityX(true))+ent.EntityX(true);
					ent.new_y=(ent.new_y-ent.EntityY(true))+ent.EntityY(true);
					ent.new_z=(ent.new_z-ent.EntityZ(true))+ent.EntityZ(true);*/

					ent.PositionEntity(ent.new_x,ent.new_y,ent.new_z,true);

					//

					// update stored collision impact values
					eci->x=piv11->EntityX(true);
					eci->y=piv11->EntityY(true);
					eci->z=piv11->EntityZ(true);
					eci->nx=piv2->EntityX(true);
					eci->ny=piv2->EntityY(true);
					eci->nz=piv2->EntityZ(true);

				}

				// reset

				//C_DeleteCollisionObject(c_coll);
				C_DeleteCollisionInfoObject(c_col_info);

				piv2->PositionEntity(0,0,0,true);
				piv2->RotateEntity(0,0,0,true);

				piv1->PositionEntity(0,0,0,true);
				piv1->RotateEntity(0,0,0,true);

				piv11->PositionEntity(0,0,0,true);
				piv11->RotateEntity(0,0,0,true);

				piv111->PositionEntity(0,0,0,true);
				piv111->RotateEntity(0,0,0,true);

				piv1o->PositionEntity(0,0,0,true);
				piv1o->RotateEntity(0,0,0,true);
				piv1o->ScaleEntity(1,1,1,true);

				piv2o->PositionEntity(0,0,0,true);
				piv2o->RotateEntity(0,0,0,true);
				piv2o->ScaleEntity(1,1,1,true);

			} // end of dest ent loop

		} // end of src ent loop

	} // end of collision pairs loop

}

// perform quick check to see whether it is possible that ent and ent 2 are intersecting
int QuickCheck(Entity& ent,Entity& ent2){

	// check to see if src ent has moved since last update - if not, no intersection
	if(ent.old_x==ent.EntityX(true) && ent.old_y==ent.EntityY(true) && ent.old_z==ent.EntityZ(true)){
		return false;
	}

	return true;

}


/*
 // dynamic to static
void UpdateStaticCollisions(){

	static Vector* c_vec_a=C_CreateVecObject(0.0,0.0,0.0);
	static Vector* c_vec_b=C_CreateVecObject(0.0,0.0,0.0);
	static Vector* c_vec_radius=C_CreateVecObject(0.0,0.0,0.0);

	static Vector* c_vec_i=C_CreateVecObject(0.0,0.0,0.0);
	static Vector* c_vec_j=C_CreateVecObject(0.0,0.0,0.0);
	static Vector* c_vec_k=C_CreateVecObject(0.0,0.0,0.0);

	static MMatrix* c_mat=C_CreateMatrixObject(c_vec_i,c_vec_j,c_vec_k);

	static Vector* c_vec_v=C_CreateVecObject(0.0,0.0,0.0);

	static Transform* c_tform=C_CreateTFormObject(c_mat,c_vec_v);

	// loop through collision setup list, containing pairs of src entities and des entities to be check for collisions
	for(int i=0;i<MAX_TYPES;i++){

		// if no entities exist of src_type then do not check for collisions
		if(CollisionPair::ent_lists[i].size()==0) continue;

		// loop through src entities
		list<Entity*>::iterator it;

		for(it=CollisionPair::ent_lists[i].begin();it!=CollisionPair::ent_lists[i].end();it++){

			Entity& ent=**it;

			ent.no_collisions=0;
			for(int ix=0;ix<ent.collision.size();ix++){
				delete ent.collision[ix];
			}
			ent.collision.clear();

			// if src entity is hidden or it's parent is hidden then do not check for collision
			if(ent.Hidden()==true) continue;

			C_UpdateVecObject(c_vec_a,ent.EntityX(true),ent.EntityY(true),ent.EntityZ(true));
			C_UpdateVecObject(c_vec_b,ent.old_x,ent.old_y,ent.old_z);
			C_UpdateVecObject(c_vec_radius,ent.radius_x,ent.radius_y,ent.radius_x);

			CollisionInfo* c_col_info=C_CreateCollisionInfoObject(c_vec_a,c_vec_b,c_vec_radius);

			Collision* c_coll=NULL;

			int response=0;
			for(;;){

				int hit=false;

				c_coll=C_CreateCollisionObject();

				Entity* ent2_hit=NULL;

				list<CollisionPair*>::iterator it2;

				for(it2=CollisionPair::cp_list.begin();it2!=CollisionPair::cp_list.end();it2++){

					CollisionPair col_pair=**it2;

					if(col_pair.src_type=i){

						// if no entities exist of des_type then do not check for collisions
						if(CollisionPair::ent_lists[col_pair.des_type].size()==0) continue;

						// loop through des entities that are paired with src entities
						list<Entity*>::iterator it3;

						for(it3=CollisionPair::ent_lists[col_pair.des_type].begin();it3!=CollisionPair::ent_lists[col_pair.des_type].end();it3++){

							Entity& ent2=**it3;

							// if des entity is hidden or it's parent is hidden then do not check for collision
							if(ent2.Hidden()==true) continue;

							// if src ent is same as des entity then do not check for collision
							if(&ent==&ent2) continue;

							if(QuickCheck(ent,ent2)==false) continue; // quick check to see if entities are colliding

							C_UpdateVecObject(c_vec_i,ent2.mat.grid[0][0],ent2.mat.grid[0][1],-ent2.mat.grid[0][2]);
							C_UpdateVecObject(c_vec_j,ent2.mat.grid[1][0],ent2.mat.grid[1][1],-ent2.mat.grid[1][2]);
							C_UpdateVecObject(c_vec_k,-ent2.mat.grid[2][0],-ent2.mat.grid[2][1],ent2.mat.grid[2][2]);

							C_UpdateMatrixObject(c_mat,c_vec_i,c_vec_j,c_vec_k);
							C_UpdateVecObject(c_vec_v,ent2.mat.grid[3][0],ent2.mat.grid[3][1],-ent2.mat.grid[3][2]);

							C_UpdateTFormObject(c_tform,c_mat,c_vec_v);

							// if pick mode is sphere or box then update collision info object to include entity radius/box info
							if(col_pair.col_method!=COLLISION_METHOD_POLYGON){
								C_UpdateCollisionInfoObject(c_col_info,ent2.radius_x,ent2.box_x,ent2.box_y,ent2.box_z,ent2.box_x+ent2.box_w,ent2.box_y+ent2.box_h,ent2.box_z+ent2.box_d);
							}

							MeshCollider* tree=NULL;
							if(dynamic_cast<Mesh*>(&ent2)!=0){
								Mesh* m=dynamic_cast<Mesh*>(&ent2);
								m->TreeCheck(); // create collision tree for mesh if necessary
								tree=m->c_col_tree;
							}

							hit=C_CollisionDetect(c_col_info,c_coll,c_tform,tree,col_pair.col_method);

							if(hit){

								ent2_hit=&ent2;

							}

							response=col_pair.response;

						}

					}

				}

				if(ent2_hit!=NULL){

					ent.no_collisions=ent.no_collisions+1;

					//int i=ent.no_collisions-1;
					CollisionImpact* eci=new CollisionImpact;
					ent.collision.push_back(eci);

					eci->x=C_CollisionX();
					eci->y=C_CollisionY();
					eci->z=C_CollisionZ();
					eci->nx=C_CollisionNX();
					eci->ny=C_CollisionNY();
					eci->nz=C_CollisionNZ();
					eci->ent=ent2_hit;

					if(dynamic_cast<Mesh*>(ent2_hit)!=NULL){
						eci->surf=dynamic_cast<Mesh*>(ent2_hit)->GetSurface(C_CollisionSurface());
					}else{
						eci->surf=NULL;
					}

					eci->tri=C_CollisionTriangle();

					if(C_CollisionResponse(c_col_info,c_coll,response)==false) break;

				}else{

					break;

				}

				C_DeleteCollisionObject(c_coll);

			}

			C_DeleteCollisionObject(c_coll);

			int hits=C_CollisionFinal(c_col_info);

			if(hits){

				float x=C_CollisionPosX();
				float y=C_CollisionPosY();
				float z=C_CollisionPosZ();

				ent.PositionEntity(x,y,z,true);

			}

			C_DeleteCollisionInfoObject(c_col_info);

			ent.old_x=ent.EntityX(true);
			ent.old_y=ent.EntityY(true);
			ent.old_z=ent.EntityZ(true);

		}

	}

}
*/
