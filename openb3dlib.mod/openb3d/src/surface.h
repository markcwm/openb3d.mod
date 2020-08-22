/*
 *  surface.h
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#ifndef SURFACE_H
#define SURFACE_H

#include "brush.h"
#include "shadermat.h"

#include <vector>
using namespace std;

class Surface{

public:

	// no of vertices and triangles in surface

	int no_verts;
	int no_tris;
	
	// arrays containing vertex and triangle info

	vector<float> vert_coords;
	vector<float> vert_norm;
	vector<float> vert_tex_coords0;
	vector<float> vert_tex_coords1;
	vector<float> vert_col;
	vector<unsigned short> tris;

	// arrays containing vertex bone no and weights info - used by animated meshes only
	
	vector<int> vert_bone1_no; // stores bone no - bone no used to reference bones[] array belonging to TMesh
	vector<int> vert_bone2_no;
	vector<int> vert_bone3_no;
	vector<int> vert_bone4_no;
	vector<float> vert_weight1;
	vector<float> vert_weight2;
	vector<float> vert_weight3;
	vector<float> vert_weight4;

	// brush applied to surface

	Brush* brush;
	Shader* ShaderMat;
	
	// vbo
	
	unsigned int vbo_id[7];
	
	// misc vars
	
	int vert_array_size;
	int tri_array_size;
	int vmin; // used for trimming verts from b3d files
	int vmax; // used for trimming verts from b3d files

	// reset flag - this is set when mesh shape is changed in TSurface and TMesh
	int vbo_enabled;
	int reset_vbo; // (-1 = all)
	
	// used by Compare to sort array, and TMesh.Update to enable/disable alpha blending
	int alpha_enable;

	Surface();
	~Surface();
	static Surface* NewSurface();
	Surface* Copy();
	void ClearSurface(int clear_verts=true,int clear_tris=true);			
	int AddVertex(float x,float y,float z,float u=0.0,float v=0.0,float w=0.0);
	int AddTriangle(unsigned short,unsigned short,unsigned short);
	int CountVertices();
	int CountTriangles();
	void VertexCoords(int vid,float x,float y,float z);	
	void VertexNormal(int vid,float nx,float ny,float nz);
	void VertexColor(int vid,float r,float g,float b,float a=1.0);
	void VertexTexCoords(int vid,float u,float v,float w=0.0,int coord_set=0);	
	float VertexX(int vid);
	float VertexY(int vid);
	float VertexZ(int vid);
	float VertexRed(int vid);
	float VertexGreen(int vid);
	float VertexBlue(int vid);
	float VertexAlpha(int vid);
	float VertexNX(int vid);
	float VertexNY(int vid);
	float VertexNZ(int vid);
	float VertexU(int vid,int coord_set=0);
	float VertexV(int vid,int coord_set=0);
	float VertexW(int vid,int coord_set=0);
	Brush* GetSurfaceBrush();
	void PaintSurface(Brush* bru);
	void SurfaceColor(float r,float g,float b,float a);
	void SurfaceColor(float r,float g,float b);
	void SurfaceRed(float r);
	void SurfaceGreen(float g);
	void SurfaceBlue(float b);
	void SurfaceAlpha(float a);
	void UpdateNormals();
	int TriangleVertex(int tri_no,int corner);
	float TriangleNX(int tri_no);
	float TriangleNY(int tri_no);
	float TriangleNZ(int tri_no);
	void UpdateVBO();
	void FreeVBO();
	void RemoveTri(int tri);
	void UpdateTexCoords();

};

#endif
