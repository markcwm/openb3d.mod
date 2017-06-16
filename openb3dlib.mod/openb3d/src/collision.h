#ifndef COLLISION_H
#define COLLISION_H

#include "tree.h"
#include "geom.h"

#include <set>
#include <map>
#include <vector>

using namespace std;

class MeshCollider;

const float COLLISION_EPSILON=.001f;

//collision methods
enum{
	COLLISION_METHOD_SPHERE=1,
	COLLISION_METHOD_POLYGON=2,
	COLLISION_METHOD_BOX=3
};

//collision actions
enum{
	COLLISION_RESPONSE_NONE=0,
	COLLISION_RESPONSE_STOP=1,
	COLLISION_RESPONSE_SLIDE=2,
	COLLISION_RESPONSE_SLIDEXZ=3,
};

struct Collision{

	float time;
	Vector normal;
	int surface;
	int index;

	Collision():time(1){
  }

	//Collision():time(1),surface(0),index(~0){}

	bool update         ( const Line &line,float time,const Vector &normal );
	bool sphereCollide  ( const Line &src_line,float src_radius,const Vector &dest,float dest_radius );
	bool sphereCollide  ( const Line &line    ,float radius    ,const Vector &dest,const Vector &radii );
	bool triangleCollide( const Line &src_line,float src_radius,const Vector &v0,const Vector &v1,const Vector &v2 );
	bool boxCollide     ( const Line &src_line,float src_radius,const Box &box );
};

struct CollisionInfo{

	Vector dv;
	Vector sv;
	Vector radii;

	Vector panic;

	Transform y_tform;

	float radius,inv_y_scale;
	float y_scale;

	int n_hit;
	Plane planes[2];

	Line coll_line;
	Vector dir;

	float td;
	float td_xz;

	int hits;

	float dst_radius;
	float ax;
	float ay;
	float az;
	float bx;
	float by;
	float bz;
};

// start of wrapper funcs

Vector* C_CreateVecObject(float x,float y,float z);
void C_DeleteVecObject(Vector* vec);
void C_UpdateVecObject(Vector* vec,float x,float y,float z);
float C_VecX(Vector* vec);
float C_VecY(Vector* vec);
float C_VecZ(Vector* vec);

Line* C_CreateLineObject(float ox,float oy,float oz,float dx,float dy,float dz);
void C_UpdateLineObject(Line* line,float ox,float oy,float oz,float dx,float dy,float dz);
void C_DeleteLineObject(Line* line);

MMatrix* C_CreateMatrixObject(Vector* vec_i,Vector* vec_j,Vector* vec_k);
void C_UpdateMatrixObject(MMatrix* mat,Vector* vec_i,Vector* vec_j,Vector* vec_k);
void C_DeleteMatrixObject(MMatrix* mat);

Transform* C_CreateTFormObject(MMatrix* mat,Vector* vec);
void C_UpdateTFormObject(Transform* tform,MMatrix* mat,Vector* vec);
void C_DeleteTFormObject(Transform* tform);

CollisionInfo* C_CreateCollisionInfoObject(Vector* dv,Vector* sv,Vector* radii);
void C_UpdateCollisionInfoObject2(CollisionInfo* ci,Vector* dv,Vector* sv,Vector* radii);
void C_UpdateCollisionInfoObject(CollisionInfo* ci,float dst_radius,float ax,float ay,float az,float bx,float by,float bz);
void C_DeleteCollisionInfoObject(CollisionInfo* ci);

Collision* C_CreateCollisionObject();
void C_DeleteCollisionObject(Collision* col);

int C_CollisionDetect(CollisionInfo* ci,Collision* coll,Transform* dst_tform,MeshCollider* mesh_col,int method);
int C_CollisionResponse(CollisionInfo* ci,Collision* coll,int response);
int C_CollisionFinal(CollisionInfo* ci);

int C_Pick(CollisionInfo* ci,const Line* line,float radius,Collision* coll,Transform* dst_tform,MeshCollider* mesh_col,int pick_geom);

float C_CollisionPosX();
float C_CollisionPosY();
float C_CollisionPosZ();
float C_CollisionX();
float C_CollisionY();
float C_CollisionZ();
float C_CollisionNX();
float C_CollisionNY();
float C_CollisionNZ();
float C_CollisionTime();
int   C_CollisionSurface();
int   C_CollisionTriangle();

#endif
