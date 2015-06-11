/*
 *  geosphere.h
 *  openb3d
 *
 *
 */

#ifndef GEOSPHERE_H
#define GEOSPHERE_H

#include "terrain.h"


class Geosphere : public Terrain{
private:
	Matrix tmat;
	float dradius;
	float* NormalsMap;
	//int* EqToToast;
	float xcf,ycf,zcf; 			//used to store camera position

	void TOASTsub(int l, float v0[], float v1[], float v2[]);
	void geosub(int l, float v0[], float v1[], float v2[]);
	void c_col_tree_geosub(int l, float v0[], float v1[], float v2[]);


	void EquirectangularToTOAST();


public:

	float hsize;

	static Geosphere* CreateGeosphere(int tsize=0, Entity* parent_ent=NULL);
	static Geosphere* LoadGeosphere(string filename,Entity* parent_ent=NULL);
	Geosphere* CopyEntity(Entity* parent_ent=NULL);
	void FreeEntity(void);

	//void TreeCheck(CollisionInfo* ci);
	void UpdateTerrain();
	void RecreateGeoROAM();
	void UpdateNormals(int preserve=0);

	void ModifyGeosphere (int x, int y, float new_height);
	void TreeCheck(CollisionInfo* ci);


};


#endif
