/*
 *  surface.mm
 *  iminib3d
 *
 *  Created by Simon Harrison.
 *  Copyright Si Design. All rights reserved.
 *
 */

#include "glew.h"

/*
#ifdef linux
#define GL_GLEXT_PROTOTYPES
#include <GL/gl.h>
#include <GL/glext.h>

#endif
#ifdef WIN32
#include <gl\GLee.h>
#endif

#ifdef __APPLE__
#include "GLee.h"
#endif
*/

#include "surface.h"

#include "global.h"
#include "geom.h"

#include <vector>
#include <map>
using namespace std;

// ***todo***
/*
// used to sort surfaces into alpha order. used by TMesh.Update
Method Compare(other:Object)

	If TSurface(other)

		If alpha_enable>TSurface(other).alpha_enable Then Return 1
		If alpha_enable<TSurface(other).alpha_enable Then Return -1

	EndIf

	Return 0

End Method
*/

Surface::Surface(){

	no_verts=0;
	no_tris=0;

	brush=new Brush;

	for(int i=0;i<7;i++){vbo_id[i]=0;}

	vert_array_size=1;
	tri_array_size=1;
	vmin=1000000; // used for trimming verts from b3d files
	vmax=0; // used for trimming verts from b3d files

	// reset flag - this is set when mesh shape is changed in TSurface and TMesh
	reset_vbo=-1; // (-1 = all)
	vbo_enabled=Global::vbo_enabled;

	// used by Compare to sort array, and TMesh.Update to enable/disable alpha blending
	alpha_enable=false;
	ShaderMat=Global::ambient_shader;

}

Surface::~Surface(){

	FreeVBO();

	delete brush;

}

Surface* Surface::Copy(){

	Surface* surf=new Surface();

	surf->no_verts=no_verts;
	surf->no_tris=no_tris;

	surf->tris=tris;
	surf->vert_coords=vert_coords;
	surf->vert_tex_coords0=vert_tex_coords0;
	surf->vert_tex_coords1=vert_tex_coords1;
	surf->vert_norm=vert_norm;
	surf->vert_col=vert_col;

	surf->vert_bone1_no=vert_bone1_no;
	surf->vert_bone2_no=vert_bone2_no;
	surf->vert_bone3_no=vert_bone3_no;
	surf->vert_bone4_no=vert_bone4_no;
	surf->vert_weight1=vert_weight1;
	surf->vert_weight2=vert_weight2;
	surf->vert_weight3=vert_weight3;
	surf->vert_weight4=vert_weight4;

	//surf->brush=brush->Copy();
	surf->brush->no_texs=brush->no_texs;
	surf->brush->name=brush->name;
	surf->brush->red=brush->red;
	surf->brush->green=brush->green;
	surf->brush->blue=brush->blue;
	surf->brush->alpha=brush->alpha;
	surf->brush->shine=brush->shine;
	surf->brush->blend=brush->blend;
	surf->brush->fx=brush->fx;
	for(int i=0;i<=7;i++){
		surf->brush->tex[i]=brush->tex[i];
		surf->brush->cache_frame[i]=brush->cache_frame[i];
	}


	surf->vert_array_size=vert_array_size;
	surf->tri_array_size=tri_array_size;
	surf->vmin=vmin;
	surf->vmax=vmax;

	surf->vbo_enabled=vbo_enabled;
	surf->reset_vbo=-1;

	surf->ShaderMat=ShaderMat;

	return surf;

}

void Surface::ClearSurface(int clear_verts,int clear_tris){

	if(clear_verts==true){

		no_verts=0;

		vert_coords.clear();
		vert_norm.clear();
		vert_col.clear();
		vert_tex_coords0.clear();
		vert_tex_coords1.clear();

		vert_array_size=1;

	}

	if(clear_tris==true){

		no_tris=0;

		tris.clear();

		tri_array_size=1;

	}

	// mesh shape has changed - update reset flag
	reset_vbo=-1; // (-1 = all)

}

int Surface::AddVertex(float x,float y,float z,float u,float v,float w){

	no_verts++;

	vert_coords.push_back(x);
	vert_coords.push_back(y);
	vert_coords.push_back(-z); // ***ogl***

	vert_norm.push_back(0.0);
	vert_norm.push_back(0.0);
	vert_norm.push_back(0.0);

	vert_col.push_back(1.0);
	vert_col.push_back(1.0);
	vert_col.push_back(1.0);
	vert_col.push_back(1.0);

	vert_tex_coords0.push_back(u);
	vert_tex_coords0.push_back(v);

	vert_tex_coords1.push_back(0.0);
	vert_tex_coords1.push_back(0.0);

	return no_verts-1;

}

int Surface::AddTriangle(unsigned short v0,unsigned short v1,unsigned short v2){

	no_tris++;

	tris.push_back(v2);
	tris.push_back(v1);
	tris.push_back(v0);

	reset_vbo=reset_vbo|1|2|16;

	return no_tris;

}

int Surface::CountVertices(){

	return no_verts;

}

int Surface::CountTriangles(){

	return no_tris;

}

void Surface::VertexCoords(int vid,float x,float y,float z){

	vid=vid*3;
	vert_coords[vid]=x;
	vert_coords[vid+1]=y;
	vert_coords[vid+2]=z*-1; // ***ogl***

	// mesh shape has changed - update reset flag
	reset_vbo=reset_vbo|1;

}

void Surface::VertexNormal(int vid,float nx,float ny,float nz){

	vid=vid*3;

	vert_norm[vid]=nx;
	vert_norm[vid+1]=ny;
	vert_norm[vid+2]=-nz; // ***ogl***

	// mesh state has changed - update reset flags
	reset_vbo=reset_vbo|4;

}

void Surface::VertexColor(int vid,float r,float g,float b,float a){

	vid=vid*4;
	vert_col[vid]=r/255.0;
	vert_col[vid+1]=g/255.0;
	vert_col[vid+2]=b/255.0;
	vert_col[vid+3]=a;

	// mesh state has changed - update reset flags
	reset_vbo=reset_vbo|8;

}

void Surface::VertexTexCoords(int vi,float u,float v,float w,int coords_set){

	vi=vi*2;

	if(coords_set==0){

		vert_tex_coords0[vi]=u;
		vert_tex_coords0[vi+1]=v;

	}else if(coords_set==1){

		vert_tex_coords1[vi]=u;
		vert_tex_coords1[vi+1]=v;

	}else{
		vi=vi*3/2;

		vert_tex_coords1[vi]=u;
		vert_tex_coords1[vi+1]=v;
		vert_tex_coords1[vi+2]=w;

	}

	// mesh state has changed - update reset flags
	reset_vbo=reset_vbo|2;

}

float Surface::VertexX(int vid){

	return vert_coords[vid*3];

}

float Surface::VertexY(int vid){

	return vert_coords[(vid*3)+1];

}

float Surface::VertexZ(int vid){

	return -vert_coords[(vid*3)+2]; // ***ogl***

}

float Surface::VertexRed(int vid){

	return vert_col[vid*4]*255.0;

}

float Surface::VertexGreen(int vid){

	return vert_col[(vid*4)+1]*255.0;

}

float Surface::VertexBlue(int vid){

	return vert_col[(vid*4)+2]*255.0;

}

float Surface::VertexAlpha(int vid){

	return vert_col[(vid*4)+3];

}

float Surface::VertexNX(int vid){

	return vert_norm[vid*3];

}

float Surface::VertexNY(int vid){

	return vert_norm[(vid*3)+1];

}

float Surface::VertexNZ(int vid){

	return -vert_norm[(vid*3)+2]; // ***ogl***

}

float Surface::VertexU(int vid,int coord_set){

	if(coord_set==0){
		return vert_tex_coords0[vid*2];
	}else if(coord_set==1){
		return vert_tex_coords1[vid*2];
	}else{
		return vert_tex_coords1[vid*3];
	}

}

float Surface::VertexV(int vid,int coord_set){

	if(coord_set==0){
		return vert_tex_coords0[(vid*2)+1];
	}else if(coord_set==1){
		return vert_tex_coords1[(vid*2)+1];
	}else{
		return vert_tex_coords1[(vid*3)+1];
	}

}

float Surface::VertexW(int vid,int coord_set){

	if(coord_set==0 || coord_set==1){
		return 0;
	}else{
		return vert_tex_coords1[(vid*3)+2];
	}

}

Brush* Surface::GetSurfaceBrush(){

	return brush->Copy();

}

void Surface::PaintSurface(Brush* bru){

	brush->no_texs=bru->no_texs;
	brush->name=bru->name;
	brush->red=bru->red;
	brush->green=bru->green;
	brush->blue=bru->blue;
	brush->alpha=bru->alpha;
	brush->shine=bru->shine;
	brush->blend=bru->blend;
	brush->fx=bru->fx;
	for(int i=0;i<=7;i++){
		brush->tex[i]=bru->tex[i];
		brush->cache_frame[i]=bru->cache_frame[i];
	}

}

void Surface::SurfaceColor(float r,float g,float b,float a){

	int v,vid;
	for( v=0;v<no_verts;v++ ){

		vid=v*4;
		vert_col[vid]=r/255.0;
		vert_col[vid+1]=g/255.0;
		vert_col[vid+2]=b/255.0;
		vert_col[vid+3]=a;

	}

}

void Surface::SurfaceColor(float r,float g,float b){

	int v,vid;
	for( v=0;v<no_verts;v++ ){

		vid=v*4;
		vert_col[vid]=r/255.0;
		vert_col[vid+1]=g/255.0;
		vert_col[vid+2]=b/255.0;
		//vert_col[vid+3]=a;

	}

}

void Surface::SurfaceRed(float r){

	int v,vid;
	for( v=0;v<no_verts;v++ ){

		vid=v*4;
		vert_col[vid]=r/255.0;
		//vert_col[vid+1]=g/255.0;
		//vert_col[vid+2]=b/255.0;
		//vert_col[vid+3]=a;

	}

}

void Surface::SurfaceGreen(float g){

	int v,vid;
	for( v=0;v<no_verts;v++ ){

		vid=v*4;
		//vert_col[vid]=r/255.0;
		vert_col[vid+1]=g/255.0;
		//vert_col[vid+2]=b/255.0;
		//vert_col[vid+3]=a;

	}

}

void Surface::SurfaceBlue(float b){

	int v,vid;
	for( v=0;v<no_verts;v++ ){

		vid=v*4;
		//vert_col[vid]=r/255.0;
		//vert_col[vid+1]=g/255.0;
		vert_col[vid+2]=b/255.0;
		//vert_col[vid+3]=a;

	}

}

void Surface::SurfaceAlpha(float a){

	int v,vid;
	for( v=0;v<no_verts;v++ ){

		vid=v*4;
		vert_col[vid+3]=a;

	}

}

void Surface::UpdateNormals(){

	int t;
	map<Vector,Vector> norm_map;

	for( t=0;t<no_tris;++t ){

		int tri_no=(t+1)*3;

		int v0=tris[tri_no-3];
		int v1=tris[tri_no-2];
		int v2=tris[tri_no-1];

		float ax=vert_coords[v1*3+0]-vert_coords[v0*3+0];
		float ay=vert_coords[v1*3+1]-vert_coords[v0*3+1];
		float az=vert_coords[v1*3+2]-vert_coords[v0*3+2];

		float bx=vert_coords[v2*3+0]-vert_coords[v1*3+0];
		float by=vert_coords[v2*3+1]-vert_coords[v1*3+1];
		float bz=vert_coords[v2*3+2]-vert_coords[v1*3+2];

		float nx=(ay*bz)-(az*by); // surf.TriangleNX#(t)
		float ny=(az*bx)-(ax*bz); // surf.TriangleNX#(t)
		float nz=(ax*by)-(ay*bx); // surf.TriangleNX#(t)

		Vector n(nx,ny,nz);
		n.normalize();

		int c;
		for( c=0;c<3;++c ){

			// get triangle vertex
			int vid[3];

			int tri_no=(t+1)*3;
			vid[0]=tris[tri_no-1];
			vid[1]=tris[tri_no-2];
			vid[2]=tris[tri_no-3];

			int v=vid[c];

			//int v=TriangleVertex(t,c,tris);

			float vx=vert_coords[v*3]; // surf.VertexX(v)
			float vy=vert_coords[(v*3)+1]; // surf.VertexY(v)
			float vz=vert_coords[(v*3)+2]; // surf.VertexZ(v)

			Vector vex;
			vex.x=vx;
			vex.y=vy;
			vex.z=vz;

			norm_map[vex]+=n;

		}

	}

	int v;
	for( v=0;v<no_verts;++v ){

		float vx=vert_coords[v*3]; // surf.VertexX(v)
		float vy=vert_coords[(v*3)+1]; // surf.VertexY(v)
		float vz=vert_coords[(v*3)+2]; // surf.VertexZ(v)

		Vector vert(vx,vy,vz);
		//vert.x=vx;
		//vert.y=vy;
		//vert.z=vz;

		Vector norm=norm_map[vert];
		//If !norm Continue;

		norm.normalize();

		vert_norm[v*3+0]=norm.x; // surf.VertexNormal(v,norm.x,norm.y,norm.z)
		vert_norm[v*3+1]=norm.y; // surf.VertexNormal(v,norm.x,norm.y,norm.z)
		vert_norm[v*3+2]=norm.z; // surf.VertexNormal(v,norm.x,norm.y,norm.z)

	}

}

int Surface::TriangleVertex(int tri_no,int corner){

	int vid[3];

	tri_no=(tri_no+1)*3;
	vid[0]=tris[tri_no-1];
	vid[1]=tris[tri_no-2];
	vid[2]=tris[tri_no-3];

	return vid[corner];

}

float Surface::TriangleNX(int tri_no){

	int v0=TriangleVertex(tri_no,0);
	int v1=TriangleVertex(tri_no,1);
	int v2=TriangleVertex(tri_no,2);

	//float ax=VertexX(v1)-VertexX(v0);
	float ay=VertexY(v1)-VertexY(v0);
	float az=VertexZ(v1)-VertexZ(v0);

	//float bx=VertexX(v2)-VertexX(v1);
	float by=VertexY(v2)-VertexY(v1);
	float bz=VertexZ(v2)-VertexZ(v1);

	return (ay*bz)-(az*by);

}

float Surface::TriangleNY(int tri_no){

	int v0=TriangleVertex(tri_no,0);
	int v1=TriangleVertex(tri_no,1);
	int v2=TriangleVertex(tri_no,2);

	float ax=VertexX(v1)-VertexX(v0);
	//float ay=VertexY(v1)-VertexY(v0);
	float az=VertexZ(v1)-VertexZ(v0);

	float bx=VertexX(v2)-VertexX(v1);
	//float by=VertexY(v2)-VertexY(v1);
	float bz=VertexZ(v2)-VertexZ(v1);

	return (az*bx)-(ax*bz);

}

float Surface::TriangleNZ(int tri_no){

	int v0=TriangleVertex(tri_no,0);
	int v1=TriangleVertex(tri_no,1);
	int v2=TriangleVertex(tri_no,2);

	float ax=VertexX(v1)-VertexX(v0);
	float ay=VertexY(v1)-VertexY(v0);
	//float az=VertexZ(v1)-VertexZ(v0);

	float bx=VertexX(v2)-VertexX(v1);
	float by=VertexY(v2)-VertexY(v1);
	//float bz=VertexZ(v2)-VertexZ(v1);

	return (ax*by)-(ay*bx);

}

void Surface::UpdateVBO(){

	if(vbo_id[0]==0){
		glGenBuffers(6,&vbo_id[0]);

	}

	if (reset_vbo==-1) reset_vbo=1|2|4|8|16;

	if(reset_vbo&1){
		glBindBuffer(GL_ARRAY_BUFFER,vbo_id[0]);
		glBufferData(GL_ARRAY_BUFFER,(no_verts*3*4),&vert_coords[0],GL_STATIC_DRAW);
	}

	if(reset_vbo&2){
		glBindBuffer(GL_ARRAY_BUFFER,vbo_id[1]);
		glBufferData(GL_ARRAY_BUFFER,(no_verts*2*4),&vert_tex_coords0[0],GL_STATIC_DRAW);

		glBindBuffer(GL_ARRAY_BUFFER,vbo_id[2]);
		glBufferData(GL_ARRAY_BUFFER,(no_verts*2*4),&vert_tex_coords1[0],GL_STATIC_DRAW);
	}

	if(reset_vbo&4){
		glBindBuffer(GL_ARRAY_BUFFER,vbo_id[3]);
		glBufferData(GL_ARRAY_BUFFER,(no_verts*3*4),&vert_norm[0],GL_STATIC_DRAW);
	}

	if(reset_vbo&8){
		glBindBuffer(GL_ARRAY_BUFFER,vbo_id[4]);
		glBufferData(GL_ARRAY_BUFFER,(no_verts*4*4),&vert_col[0],GL_STATIC_DRAW);
	}

	if(reset_vbo&16){
		glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,vbo_id[5]);
		glBufferData(GL_ELEMENT_ARRAY_BUFFER,no_tris*3*2,&tris[0],GL_STATIC_DRAW);
	}

	reset_vbo=false;

}

void Surface::FreeVBO(){

	if(vbo_id[0]!=0){
		glDeleteBuffers(6,vbo_id);
	}

}

// removes a tri from a surface
void Surface::RemoveTri(int tri){
	int* tris=new int[no_tris*3];
	int old_no_tris=no_tris;

	for(int t=0;t<=no_tris-1;t++){

		tris[t*3+0]=TriangleVertex(t,0);
		tris[t*3+1]=TriangleVertex(t,1);
		tris[t*3+2]=TriangleVertex(t,2);

	}

	ClearSurface(false,true);

	for(int t=0;t<=old_no_tris-1;t++){

		int v0=tris[t*3+0];
		int v1=tris[t*3+1];
		int v2=tris[t*3+2];

		if(t!=tri) AddTriangle(v0,v1,v2);
	}

	delete[] tris;

}

void Surface::UpdateTexCoords(){
	float min_x,min_y,min_z,max_x,max_y,max_z;

	min_x=999999999;
	max_x=-999999999;
	min_y=999999999;
	max_y=-999999999;
	min_z=999999999;
	max_z=-999999999;


	for(int V=0;V<=CountVertices()-1;V++){

		float x=vert_coords[V*3]; // surf.VertexX(v)
		if(x<min_x) min_x=x;
		if(x>max_x) max_x=x;

		float y=vert_coords[(V*3)+1]; // surf.VertexY(v)
		if(y<min_y) min_y=y;
		if(y>max_y) max_y=y;

		float z=-vert_coords[(V*3)+2]; // surf.VertexZ(v)
		if(z<min_z) min_z=z;
		if(z>max_z) max_z=z;

	}

	float width=max_x-min_x;
	float height=max_y-min_y;
	float depth=max_z-min_z;

	vert_tex_coords1.clear();

	for(int V=0;V<=CountVertices()-1;V++){

		float x=vert_coords[V*3]; // surf.VertexX(v)
		float y=vert_coords[(V*3)+1]; // surf.VertexY(v)
		float z=-vert_coords[(V*3)+2]; // surf.VertexZ(v)

		float u=(x-min_x)/width;
		float v=(y-min_y)/height;
		float w=(z-min_z)/depth;

		vert_tex_coords1.push_back(u);
		vert_tex_coords1.push_back(v);
		vert_tex_coords1.push_back(w);

	}


}
