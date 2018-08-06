#ifndef MESHCOLLIDER_H
#define MESHCOLLIDER_H

#include <set>
#include <map>
#include <vector>
using namespace std;

#include "collision.h"
#include "geom.h"

struct Collision;

class MeshCollider{
public:
	struct Vertex{
		Vector coords;
	};
	struct Triangle{
		int surface;
		int verts[3],index;
	};
	MeshCollider( const vector<Vertex> &verts,const vector<Triangle> &tris );
	~MeshCollider();

	//sphere collision
	bool collide( const Line &line,float radius,const Transform &tform,Collision *curr_coll );

	bool intersects( const MeshCollider &c,const Transform &t )const;
	
	MeshCollider(){
	}

private:
	vector<Vertex> vertices;
	vector<Triangle> triangles;

	struct Node{
		Box box;
		Node *left,*right;
		vector<int> triangles;
		Node():left(0),right(0){}
		~Node(){ delete left;delete right; }
	};

	Node *tree;
	vector<Node*> leaves;

	Box nodeBox( const vector<int> &tris );
	Node *createLeaf( const vector<int> &tris );
	Node *createNode( const vector<int> &tris );
	bool collide( const Box &box,const Line &line,float radius,const Transform &tform,Collision *curr_coll,Node *node );
};

class MeshInfo{

public:

	vector<MeshCollider::Triangle> tri_list;
	vector<MeshCollider::Vertex> vert_list;

	MeshInfo(){};

};

MeshInfo* C_NewMeshInfo();
void C_DeleteMeshInfo(MeshInfo* mesh_info);
void C_AddTriangle(MeshInfo* mesh_info, int index, short v0, short v1, short v2, int surface);
void C_AddVertex(MeshInfo* mesh_info, float x, float y, float z,int surface);
void C_AddSurface(MeshInfo* mesh_info,int no_tris,int no_verts,short tris[],float verts[],int surface);
MeshCollider* C_CreateColTree(MeshInfo* mesh_info);
void C_DeleteColTree(MeshCollider* mesh_col);

#endif
