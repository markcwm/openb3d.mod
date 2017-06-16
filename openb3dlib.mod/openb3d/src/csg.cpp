#include "csg.h"
list<CSGTriangle*> CSGTriangle::CSGTriangle_list;

namespace CSG{

float npicked[3], tpicked[3];

float dist(float x, float y, float z, float x2, float y2, float z2){

	x2=x2-x;
	y2=y2-y;
	z2=z2-z;
	return sqrt(x2*x2+y2*y2+z2*z2);

}

float PointDistanceToLine(float ax, float ay, float az, float bx, float by, float bz, float px, float py, float pz){
	// Calculates the shortest distance between a point P(xyz) and a line segment defined by A(xyz) and B(xyz) - danny.

	//get the length of each side of the triangle ABP
	float ab = sqrt( (bx-ax)*(bx-ax) + (by-ay)*(by-ay) + (bz-az)*(bz-az) );
	float bp = sqrt( (px-bx)*(px-bx) + (py-by)*(py-by) + (pz-bz)*(pz-bz) );
	float pa = sqrt( (ax-px)*(ax-px) + (ay-py)*(ay-py) + (az-pz)*(az-pz) );

	//get the triangle's semiperimeter
	float semi = (ab+bp+pa) / 2.0;
	
	//get the triangle's area
	float area = sqrt( semi * (semi-ab) * (semi-bp) * (semi-pa) );
	
	//return closest distance P to AB
	return (2.0 * (area/ab));
	
}

CSGTriangle* MakeTriangle(Mesh* mesh, Surface* surf, float x0, float y0, float z0, float u0, float v0, float x1, float y1, float z1, float u1, float v1, float x2, float y2, float z2, float u2, float v2, int loop, CSGTriangle* org){

	//distance between corners
	float d1 = dist(x0,y0,z0, x1,y1,z1);
	float d2 = dist(x1,y1,z1, x2,y2,z2);
	float d3 = dist(x2,y2,z2, x0,y0,z0);
			
	//size of triangle
	float opp = PointDistanceToLine(x0,y0,z0,x1,y1,z1,x2,y2,z2);
	
	//remove empty triangles
	float ep = 0.01;
	if ((opp < ep) || (d1<ep) || (d2<ep) || (d3<ep)) 
		return 0;

	CSGTriangle* t = new CSGTriangle;
	CSGTriangle::CSGTriangle_list.push_back(t);

	//store mesh/surf pointer	
	t->mesh = mesh;
	t->surf = surf;

	//store coords		
	t->x0 = x0;
	t->y0 = y0;
	t->z0 = z0;
	t->x1 = x1;
	t->y1 = y1;
	t->z1 = z1;
	t->x2 = x2;
	t->y2 = y2;
	t->z2 = z2;
	
	t->u0 = u0;
	t->v0 = v0;
	t->u1 = u1;
	t->v1 = v1;
	t->u2 = u2;
	t->v2 = v2;
	
	t->loop = loop;

	//calculate normal
	float ax = x1 - x0;
	float ay = y1 - y0;
	float az = z1 - z0;
	float bx = x2 - x1;
	float by = y2 - y1;
	float bz = z2 - z1;
	float Nx = ( ay * bz ) - ( az * by );
	float Ny = ( az * bx ) - ( ax * bz );
	float Nz = ( ax * by ) - ( ay * bx );
	float Ns = sqrt( Nx*Nx + Ny*Ny + Nz*Nz );
	if (Ns > 0){
		Nx = Nx / Ns;
		Ny = Ny / Ns;
		Nz = Nz / Ns;
	}
	
	if (org!=0){
		t->onx = org->onx;
		t->ony = org->ony;
		t->onz = org->onz;
	}else{
		t->onx = Nx;
		t->ony = Ny;
		t->onz = Nz;
	}
	t->nx = Nx;
	t->ny = Ny;
	t->nz = Nz;
		
	t->d = -((t->nx * x0) + (t->ny * y0) + (t->nz * z0));
		
	return t;

}

void ScanObject(Mesh* mesh){

	//scan each surface
	for (int si = 1; si<=mesh->CountSurfaces(); si++){

		//get surface	
		Surface* s = mesh->GetSurface(si);
		
		//scan each triangle
		for (int t = 0; t<= s->CountTriangles() - 1; t++){

			//get triangle vertices		
			float v0 = s->TriangleVertex(t, 0);
			float v1 = s->TriangleVertex(t, 1);
			float v2 = s->TriangleVertex(t, 2);

			//get vertex coords			
			float v0x = s->VertexX(v0);
			float v0y = s->VertexY(v0);
			float v0z = s->VertexZ(v0);
			/*Entity::TFormPoint(v0x, v0y, v0z, mesh, 0);
			v0x = Entity::TFormedX();
			v0y = Entity::TFormedY();
			v0z = Entity::TFormedZ();*/

			float v1x = s->VertexX(v1);
			float v1y = s->VertexY(v1);
			float v1z = s->VertexZ(v1);
			/*Entity::TFormPoint(v1x, v1y, v1z, mesh, 0);
			v1x = Entity::TFormedX();
			v1y = Entity::TFormedY();
			v1z = Entity::TFormedZ();*/

			float v2x = s->VertexX(v2);
			float v2y = s->VertexY(v2);
			float v2z = s->VertexZ(v2);
			/*Entity::TFormPoint(v2x, v2y, v2z, mesh, 0);
			v2x = Entity::TFormedX();
			v2y = Entity::TFormedY();
			v2z = Entity::TFormedZ();*/

			//get triangle uv coords		
			float uu0 = s->VertexU(v0);
			float vv0 = s->VertexV(v0);
			float uu1 = s->VertexU(v1);
			float vv1 = s->VertexV(v1);
			float uu2 = s->VertexU(v2);
			float vv2 = s->VertexV(v2);

			//create triangle
			MakeTriangle(mesh, s, v0x,v0y,v0z, uu0,vv0, v1x,v1y,v1z, uu1,vv1, v2x,v2y,v2z, uu2, vv2, 0, 0);
			
		}
		
	}
		
}

int ray_plane(float p1x, float p1y, float p1z, float p2x, float p2y, float p2z, float nx, float ny, float nz, float d){

	float denom,mu;
	
	//Calculate the position on the Line that intersects the plane
	denom = nx * (p2x - p1x) + ny * (p2y - p1y) + nz * (p2z - p1z);
	
	if (abs(denom) < 0.0001) 
		return 0;	//Line And plane don't intersect
	      
	mu = - (d + nx * p1x + ny * p1y + nz * p1z) / denom;
	npicked[0] = (p1x + mu * (p2x - p1x));
	npicked[1] = (p1y + mu * (p2y - p1y));
	npicked[2] = (p1z + mu * (p2z - p1z));

	//comment this out if you want an infinite ray
	if ((mu < 0) || (mu > 1))
		 return 0;	//Intersection Not along Line segment
		      
	return 1;

}

int SplitTriangle(CSGTriangle* t1, CSGTriangle* t2, int dosplit = 0, int loop = 1){

	int split;

	//temp arrays
	int stest[3];
	float ssx[3];
	float ssy[3];
	float ssz[3];
	float ssu[3];
	float ssv[3];

	float nx = t2->nx;
	float ny = t2->ny;
	float nz = t2->nz;
	float d = t2->d;

	//get world space coords t1
	float v0x = t1->x0; float v0y = t1->y0; float v0z = t1->z0;
	float v1x = t1->x1; float v1y = t1->y1; float v1z = t1->z1;
	float v2x = t1->x2; float v2y = t1->y2; float v2z = t1->z2;

	//calculate plane intersection		
	stest[0] = ray_plane(v0x,v0y,v0z, v1x,v1y,v1z, nx,ny,nz,d);
	ssx[0] = npicked[0];
	ssy[0] = npicked[1];
	ssz[0] = npicked[2];
	stest[1] = ray_plane(v1x,v1y,v1z, v2x,v2y,v2z, nx,ny,nz,d);
	ssx[1] = npicked[0];
	ssy[1] = npicked[1];
	ssz[1] = npicked[2];
	stest[2] = ray_plane(v2x,v2y,v2z, v0x,v0y,v0z, nx,ny,nz,d);
	ssx[2] = npicked[0];
	ssy[2] = npicked[1];
	ssz[2] = npicked[2];
	
	//get triangle uv coords
	float u0 = t1->u0;
	float v0 = t1->v0;
	float u1 = t1->u1;
	float v1 = t1->v1;
	float u2 = t1->u2;
	float v2 = t1->v2;

	//get picked uv coords
	float d1 = dist(v0x,v0y,v0z, ssx[0],ssy[0],ssz[0]); 	//distance from side 1
	float d2 = dist(ssx[0],ssy[0],ssz[0],v1x,v1y,v1z);  	//distance from side 2
	float dd = d1 + d2;					//total distance
	if (dd == 0) {
		ssu[0] = u0;
		ssv[0] = v0;
	}else{
		ssu[0] = u0 + (u1-u0) * d1 / dd;			//interpolate u
		ssv[0] = v0 + (v1-v0) * d1 / dd;			//interpolate v
	}

	d1 = dist(v1x,v1y,v1z, ssx[1],ssy[1],ssz[1]);		//distance from side 1
	d2 = dist(ssx[1],ssy[1],ssz[1],v2x,v2y,v2z);		//distance from side 2
	dd = d1 + d2;						//total distance
	if (dd == 0) {
		ssu[1] = u1;
		ssv[1] = v1;
	}else{
		ssu[1] = u1 + (u2-u1) * d1 / dd;			//interpolate u
		ssv[1] = v1 + (v2-v1) * d1 / dd;			//interpolate v
	}

	d1 = dist(v2x,v2y,v2z, ssx[2],ssy[2],ssz[2]);		//distance from side 1
	d2 = dist(ssx[2],ssy[2],ssz[2],v0x,v0y,v0z);		//distance from side 2
	dd = d1 + d2;						//total distance
	if (dd == 0) {
		ssu[2] = u2;
		ssv[2] = v2;
	}else{
		ssu[2] = u2 + (u0-u2) * d1 / dd;		//interpolate u
		ssv[2] = v2 + (v0-v2) * d1 / dd;		//interpolate v
	}
				
	//all edges (which is a strange situation..)
	if (stest[0]!=0 && stest[1]!=0 && stest[2]!=0){
		//split = false;
		if (dosplit!=0){
			//determine which corner should be dropped
			//based on the distance  corner<->intersection point
			float d01 = dist(ssx[0],ssy[0],ssz[0], v0x,v0y,v0z);
			float d02 = dist(ssx[1],ssy[1],ssz[1], v0x,v0y,v0z);
			float d11 = dist(ssx[1],ssy[1],ssz[1], v1x,v1y,v1z);
			float d12 = dist(ssx[2],ssy[2],ssz[2], v1x,v1y,v1z);
			float d21 = dist(ssx[2],ssy[2],ssz[2], v2x,v2y,v2z);
			float d22 = dist(ssx[0],ssy[0],ssz[0], v2x,v2y,v2z);
			if (d02<d01)
				d01=d02;
			if (d12<d11)
				d11=d12;
			if (d22<d21)
				d21=d22;
			if ((d01 >= d11) && (d01 >= d21))
				stest[1] = false;
			if ((d11 > d01) && (d11 >= d21))
				stest[2] = false;
			if ((d21 > d01) && (d21 > d11))
				stest[0] = false;
		}
	}
	
	//edge 0
	if (stest[0]!=0 && stest[1]!=0){
		split = true;
		if (dosplit!=0){
			MakeTriangle(t1->mesh, t1->surf, v0x,v0y,v0z,u0,v0, ssx[0],ssy[0],ssz[0],ssu[0],ssv[0], ssx[1],ssy[1],ssz[1],ssu[1],ssv[1], loop, t1);
			MakeTriangle(t1->mesh, t1->surf, v0x,v0y,v0z,u0,v0, ssx[1],ssy[1],ssz[1],ssu[1],ssv[1], v2x, v2y, v2z,u2,v2, loop, t1);
			MakeTriangle(t1->mesh, t1->surf, ssx[0],ssy[0],ssz[0],ssu[0],ssv[0], v1x,v1y,v1z,u1,v1,
			ssx[1],ssy[1], ssz[1],ssu[1], ssv[1], loop, t1);
		}
	}
	//edge 1
	if (stest[1]!=0 && stest[2]!=0){
		split = true;
		if (dosplit!=0){
			MakeTriangle(t1->mesh, t1->surf, v0x,v0y,v0z,u0,v0, v1x,v1y,v1z,u1,v1, ssx[2],ssy[2],ssz[2],ssu[2],ssv[2], loop, t1);
			MakeTriangle(t1->mesh, t1->surf, ssx[2],ssy[2],ssz[2],ssu[2],ssv[2], v1x,v1y,v1z,u1,v1,
			ssx[1],ssy[1], ssz[1],ssu[1], ssv[1], loop, t1);
			MakeTriangle(t1->mesh, t1->surf, ssx[2],ssy[2],ssz[2],ssu[2],ssv[2], ssx[1],ssy[1],ssz[1],ssu[1],ssv[1], v2x,v2y,v2z,u2,v2, loop, t1);
		}
	}
	//edge 2
	if  (stest[2]!=0 && stest[0]!=0){
		split = true;
		if (dosplit!=0){
			MakeTriangle(t1->mesh, t1->surf, v0x,v0y,v0z,u0,v0, ssx[0],ssy[0],ssz[0],ssu[0],ssv[0], ssx[2],ssy[2],ssz[2],ssu[2],ssv[2], loop, t1);
			MakeTriangle(t1->mesh, t1->surf, ssx[0],ssy[0],ssz[0],ssu[0],ssv[0], v1x,v1y,v1z,u1,v1, ssx[2],ssy[2],ssz[2],ssu[2],ssv[2], loop, t1);
			MakeTriangle(t1->mesh, t1->surf, ssx[2],ssy[2],ssz[2],ssu[2],ssv[2], v1x,v1y,v1z,u1,v1, v2x,v2y,v2z,u2,v2, loop, t1);
		}
	}
	//only corner 0 (which is also very weird)
	if (stest[0]!=0 && stest[1]==0 && stest[2]==0){
		split = true;
		if (dosplit!=0){
			MakeTriangle(t1->mesh, t1->surf,  v0x,v0y,v0z,u0,v0, ssx[0],ssy[0],ssz[0],ssu[0],ssv[0], v2x,v2y,v2z,u2,v2, loop, t1);
			MakeTriangle(t1->mesh, t1->surf,  ssx[0],ssy[0],ssz[0],ssu[0],ssv[0], v1x,v1y,v1z,u1,v1, v2x,v2y,v2z,u2,v2, loop, t1);
		}
	}
	//only corner 1 (idem)
	if (stest[1]!=0 && stest[2]==0 && stest[0]==0){
		split = true;
		if (dosplit!=0){
			MakeTriangle(t1->mesh, t1->surf,  v1x,v1y,v1z,u1,v1, ssx[1],ssy[1],ssz[1],ssu[1],ssv[1], v0x,v0y,v0z,u0,v0, loop, t1);
			MakeTriangle(t1->mesh, t1->surf,  ssx[1],ssy[1],ssz[1],ssu[1],ssv[1], v2x,v2y,v2z,u2,v2, v0x,v0y,v0z,u0,v0, loop, t1);
		}
	}
	//only corner 2 (idem)
	if (stest[2]!=0 && stest[0]==0 && stest[1]==0){
		split = true;
		if (dosplit!=0){
			MakeTriangle(t1->mesh, t1->surf,  v2x,v2y,v2z,u2,v2, ssx[2],ssy[2],ssz[2],ssu[2],ssv[2], v1x,v1y,v1z,u1,v1, loop, t1);
			MakeTriangle(t1->mesh, t1->surf,  ssx[2],ssy[2],ssz[2],ssu[2],ssv[2], v0x,v0y,v0z,u0,v0, v1x,v1y,v1z,u1,v1, loop, t1);
		}
	}
	//none
	if (stest[0]==0 && stest[1]==0 && stest[2]==0){
		split = false;
	}
			
	return split;
	
}

float findmin(float a,float b,float c){

	if (b < a) 
		a = b;
	if (c < a) 
		a = c;
	
	return a;
	
}

float findmax(float a,float b,float c){

	if (b > a) 
		a = b;
	if (c > a) 
		a = c;
	
	return a;
	
}

bool BoxesOverlap(float x0, float y0, float z0, float w0, float h0, float d0, float x2, float y2, float z2, float w2, float h2, float d2){
	if ((x0 > (x2 + w2)) || ((x0 + w0) < x2)) 
		return false;
	if ((y0 > (y2 + h2)) || ((y0 + h0) < y2)) 
		return false;
	if ((z0 > (z2 + d2)) || ((z0 + d0) < z2)) 
		return false;
	return true;
}


bool CSGTrisIntersect(CSGTriangle* t1, CSGTriangle* t2){

	//get coords t1
	float x0 = t1->x0; float y0 = t1->y0; float z0 = t1->z0;
	float x1 = t1->x1; float y1 = t1->y1; float z1 = t1->z1;
	float x2 = t1->x2; float y2 = t1->y2; float z2 = t1->z2;

	//get coords t2
	float tx0 = t2->x0; float ty0 = t2->y0; float tz0 = t2->z0;
	float tx1 = t2->x1; float ty1 = t2->y1; float tz1 = t2->z1;
	float tx2 = t2->x2; float ty2 = t2->y2; float tz2 = t2->z2;


	//determine min/max x/y/z values
	float nx1 = findmin(x0,x1,x2);
	float nx2 = findmax(x0,x1,x2);
	float ny1 = findmin(y0,y1,y2);
	float ny2 = findmax(y0,y1,y2);
	float nz1 = findmin(z0,z1,z2);
	float nz2 = findmax(z0,z1,z2);

	//width/height/depth	
	nx2 = nx2 - nx1; 
	if (nx2 < 0.01) 
		 nx2 = 0.01;
	ny2 = ny2 - ny1; 
	if (ny2 < 0.01) 
		 ny2 = 0.01;
	nz2 = nz2 - nz1; 
	if (nz2 < 0.01) 
		nz2 = 0.01;

	//determine min/max x/y/z values
	float tnx1 = findmin(tx0,tx1,tx2);
	float tnx2 = findmax(tx0,tx1,tx2);
	float tny1 = findmin(ty0,ty1,ty2);
	float tny2 = findmax(ty0,ty1,ty2);
	float tnz1 = findmin(tz0,tz1,tz2);
	float tnz2 = findmax(tz0,tz1,tz2);

	//with/height/depth	
	tnx2 = tnx2 - tnx1;
	if (tnx2 < 0.01)
		tnx2 = 0.01;
	tny2 = tny2 - tny1;
	if (tny2 < 0.01)
		tny2 = 0.01;
	tnz2 = tnz2 - tnz1;
	if (tnz2 < 0.01)
		tnz2 = 0.01;

	return BoxesOverlap(nx1,ny1,nz1,nx2,ny2,nz2,tnx1,tny1,tnz1,tnx2,tny2,tnz2);

}


void SplitTriangles(Mesh* obj1){

	//reset 'loop' flag for all triangles

	list<CSGTriangle*>::iterator it1;

	for(it1=CSGTriangle::CSGTriangle_list.begin();it1!=CSGTriangle::CSGTriangle_list.end();it1++){
		CSGTriangle* t1=*it1;
		t1->loop = 0;
	}

	int loop = 0;
	//loop through each triangle
	list<CSGTriangle*>::iterator it2;

	for(it2=CSGTriangle::CSGTriangle_list.begin();it2!=CSGTriangle::CSGTriangle_list.end();it2++){

		CSGTriangle* t2=*it2;

		//if triangle doesn't belong to mesh, start testing	
		if (t2->mesh != obj1) {
		
			loop++;
					
			//loop through each triangles
			for(it1=CSGTriangle::CSGTriangle_list.begin();it1!=CSGTriangle::CSGTriangle_list.end();it1++){
				CSGTriangle* t1=*it1;
			
				//test if triangle belongs to mesh, and isn't bisected yet
				if ((t1->mesh == obj1) && (t1->loop < loop)){
				
					//if tr1 and tr2 intersect
					if (CSGTrisIntersect(t1, t2)) {
										
						//test if triangles intersect each other
						int test1 = SplitTriangle(t1, t2, false, loop);
						int test2 = SplitTriangle(t2, t1, false, loop);
							
						//if so, bisect t1 by t2
						if (test1!=0 && test2!=0){
							SplitTriangle(t1, t2, true, loop);
							//remove original triangle
							delete t1;
							it1=CSGTriangle::CSGTriangle_list.erase(it1);
						}
						
					}
					
				}
			
			}
		
		}
		
	}

}

Mesh* CopyMeshAt(Mesh* mesh){

	Mesh* mesh2 = mesh->CopyMesh();
	//mesh2->ScaleMesh(mesh->EntityWidth(), mesh->EntityHeight(), mesh->EntityDepth());
	//mesh2->RotateMesh(mesh->GlobalEntityPitch(), mesh->GlobalEntityYaw(), mesh->GlobalEntityRoll());
	//mesh2->PositionMesh(mesh->EntityX(), mesh->EntityY(), mesh->EntityZ());

	for(int s=1;s<=mesh2->CountSurfaces();s++){

		Surface* surf=mesh2->GetSurface(s);

		for(int v=0;v<=surf->CountVertices()-1;v++){

			float vx=surf->vert_coords[v*3];
			float vy=surf->vert_coords[v*3+1];
			float vz=-surf->vert_coords[v*3+2];

			Entity::TFormPoint (vx,vy,vz,mesh,0);

			surf->vert_coords[v*3] = Entity::tformed_x;
			surf->vert_coords[v*3+1] = Entity::tformed_y;
			surf->vert_coords[v*3+2] = -Entity::tformed_z;

			float nx=surf->vert_norm[v*3];
			float ny=surf->vert_norm[v*3+1];
			float nz=-surf->vert_norm[v*3+2];

			Entity::TFormNormal (nx,ny,nz,mesh,0);

			surf->vert_norm[v*3] = Entity::tformed_x;
			surf->vert_norm[v*3+1] = Entity::tformed_y;
			surf->vert_norm[v*3+2] = -Entity::tformed_z;


		}

		// mesh shape has changed - update reset flag
		surf->reset_vbo=surf->reset_vbo|1;

	}

	// mesh shape has changed - update reset flags
	mesh2->reset_bounds=true;
	mesh2->reset_col_tree=true;

	
	return mesh2;
	
}

bool Ray_Intersect_Triangle(float Px, float  Py, float  Pz, float  Dx, float  Dy, float Dz, float V0x, float V0y, float V0z,
float V1x, float V1y, float V1z, float V2x, float V2y, float V2z, int Extend_To_Infinity=true, int Cull_Backfaces=false, int Flip_Faces=false){
	
	Dx=Dx-Px;
	Dy=Dy-Py;
	Dz=Dz-Pz;	
	/*; crossproduct(b,c) =
	; ax = (by * cz) - (cy * bz) 
	; ay = (bz * cx) - (cz * bx) 	
	; az = (bx * cy) - (cx * by)

	; dotproduct(v,q) =
	; (vx * qx) + (vy * qy) + (vz * qz)	
	; DP =  1 = Vectors point in same direction.          (  0 degrees of seperation)
	; DP =  0 = Vectors are perpendicular to one another. ( 90 degrees of seperation)
	; DP = -1 = Vectors point in opposite directions.     (180 degrees of seperation) 
	;
	; The dot product is also reffered to as "the determinant" or "the inner product"*/

	if (Flip_Faces!=false) {
		float tx = V0x;
		float ty = V0y;
		float tz = V0z;
		V0x = V2x;
		V0y = V2y;
		V0z = V2z;
		V2x = tx;
		V2y = ty;
		V2z = tz;
	}

	// Calculate the vector that represents the first side of the triangle.
	float E1x = V2x - V0x;
	float E1y = V2y - V0y;
	float E1z = V2z - V0z;

	// Calculate the vector that represents the second side of the triangle.
	float E2x = V1x - V0x;
	float E2y = V1y - V0y;
	float E2z = V1z - V0z;

	// Calculate a vector which is perpendicular to the vector between point 0 and point 1,
	// and the direction vector for the ray.
	// Hxyz = Crossproduct(Dxyz, E2xyz)
	float Hx = (Dy * E2z) - (E2y * Dz);
	float Hy = (Dz * E2x) - (E2z * Dx);
	float Hz = (Dx * E2y) - (E2x * Dy);

	// Calculate the dot product of the above vector and the vector between point 0 and point 2.
	float A = (E1x * Hx) + (E1y * Hy) + (E1z * Hz);

	// If we should ignore triangles the ray passes through the back side of,
	// and the ray points in the same direction as the normal of the plane,
	// then the ray passed through the back side of the plane,  
	// and the ray does not intersect the plane the triangle lies in.
	if ((Cull_Backfaces == true) && (A >= 0)) 
		return false;
		
	// If the ray is almost parralel to the plane,
	// then the ray does not intersect the plane the triangle lies in.
	if ((A > -0.00001) && (A < 0.00001)) 
		return false;
	
	// Inverse Determinant. (Dot Product) 
	// (Scaling factor for UV's?)
	float F = 1.0 / A;

	// Calculate a vector between the starting point of our ray, and the first point of the triangle,
	// which is at UV(0,0)
	float Sx = Px - V0x;
	float Sy = Py - V0y;
	float Sz = Pz - V0z;
	
	// Calculate the U coordinate of the intersection point.
	//
	//	Sxyz is the vector between the start of our ray and the first point of the triangle.
	//	Hxyz is the normal of our triangle.
	//	
	// U# = F# * (DotProduct(Sxyz, Hxyz))
	float U = F * ((Sx * Hx) + (Sy * Hy) + (Sz * Hz));
	
	// Is the U coordinate outside the range of values inside the triangle?
	if ((U < 0.0) || (U > 1.0)){
		// The ray has intersected the plane outside the triangle.
		return false;
	}

	// Not sure what this is, but it's definitely NOT the intersection point.
	//
	//	Sxyz is the vector from the starting point of the ray to the first corner of the triangle.
	//	E1xyz is the vector which represents the first side of the triangle.
	//	The crossproduct of these two would be a vector which is perpendicular to both.
	//
	// Qxyz = CrossProduct(Sxyz, E1xyz)
	float Qx = (Sy * E1z) - (E1y * Sz);
	float Qy = (Sz * E1x) - (E1z * Sx);
	float Qz = (Sx * E1y) - (E1x * Sy);
	
	// Calculate the V coordinate of the intersection point.
	//	
	//	Dxyz is the vector which represents the direction the ray is pointing in.
	//	Qxyz is the intersection point I think?
	//
	// V# = F# * DotProduct(Dxyz, Qxyz)
	float V = F * ((Dx * Qx) + (Dy * Qy) + (Dz * Qz));
	
	// Is the V coordinate outside the range of values inside the triangle?	
	// Does U+V exceed 1.0?  
	if ((V < 0.0) || ((U + V) > 1.0)){

		// The ray has intersected the plane outside the triangle.		
		return false;

		// The reason we check U+V is because if you imagine the triangle as half a square, U=1 V=1 would
		// be in the lower left hand corner which would be in the lower left triangle making up the square.
		// We are looking for the upper right triangle, and if you think about it, U+V will always be less
		// than or equal to 1.0 if the point is in the upper right of the triangle.

	}

	// Calculate the distance of the intersection point from the starting point of the ray, Pxyz.
	// This distance is scaled so that at Pxyz, the start of the ray, T=0, and at Dxyz, the end of the ray, T=1.
	// If the intersection point is behind Pxyz, then T will be negative, and if the intersection point is
	// beyond Dxyz then T will be greater than 1. 
	float T = F * ((E2x * Qx) + (E2y * Qy) + (E2z * Qz));

	// If the triangle is behind Pxyz, ignore this intersection.
	// We want a directional ray, which only intersects triangles in the direction it points.
	if (T < 0) 
		return false;

	// If the plane is beyond Dxyz, amd we do not want the ray to extend to infinity, then ignore this intersection.
	if ((Extend_To_Infinity == false) && (T > 1))
		return false;

	//-------------------------------------------------
	//Calculate intersection point
	float nx=(E1y*E2z)-(E1z*E2y);
	float ny=(E1z*E2x)-(E1x*E2z);
	float nz=(E1x*E2y)-(E1y*E2x);
	float d = -nx*V0x - ny*V0y - nz*V0z ;
	
	float denom = nx*Dx + ny*Dy + nz*Dz;
	float mu = - (d + nx*Px + ny*Py + nz*Pz) / denom;
	
	tpicked[0] = Px + mu * Dx;
	tpicked[1] = Py + mu * Dy;
	tpicked[2] = Pz + mu * Dz;
	//-------------------------------------------------

	// The ray intersects the triangle!		
	return true;

}

float Ray_Intersect_Mesh_Max(Mesh* mesh, float Px, float Py, float Pz, float Dx, float Dy, float Dz, bool Extend_To_Infinity=true, bool Cull_Backfaces=false, bool Flip_Mesh=false, bool Method=1){

	float max = 65536;
	int count = 0;
	
	int Surfaces = mesh->CountSurfaces();

	// Make sure there's a surface, because the mesh might be empty.
	if (Surfaces > 0){

		for (int SurfaceLoop = 1;SurfaceLoop<=Surfaces;SurfaceLoop++){

			Surface* surface = mesh->GetSurface(SurfaceLoop);
	
			// Examine all triangles in this surface.	
			int Tris  = surface->CountTriangles();
			for (int TriLoop = 0; TriLoop<= Tris-1; TriLoop++){
	
				int V0 = surface->TriangleVertex(TriLoop, 0);
				int V1 = surface->TriangleVertex(TriLoop, 1);
				int V2 = surface->TriangleVertex(TriLoop, 2);
		
				float V0x = surface->VertexX(V0);
				float V0y = surface->VertexY(V0);
				float V0z = surface->VertexZ(V0);

				float V1x = surface->VertexX(V1);
				float V1y = surface->VertexY(V1);
				float V1z = surface->VertexZ(V1);

				float V2x = surface->VertexX(V2);
				float V2y = surface->VertexY(V2);
				float V2z = surface->VertexZ(V2);

				/*Entity::TFormPoint(V0x, V0y, V0z, mesh, 0);
				V0x = Entity::TFormedX();
				V0y = Entity::TFormedY();
				V0z = Entity::TFormedZ();

				Entity::TFormPoint(V1x, V1y, V1z, mesh, 0);
				V1x = Entity::TFormedX();
				V1y = Entity::TFormedY();
				V1z = Entity::TFormedZ();
			
				Entity::TFormPoint(V2x, V2y, V2z, mesh, 0);
				V2x = Entity::TFormedX();
				V2y = Entity::TFormedY();
				V2z = Entity::TFormedZ();*/
				
				bool Intersected = Ray_Intersect_Triangle(Px, Py, Pz, Px+Dx, Py+Dy, Pz+Dz, V0x, V0y, V0z, V1x, V1y, V1z, V2x, V2y, V2z, Extend_To_Infinity, Cull_Backfaces, Flip_Mesh);
				if (Intersected){
					
					float d = dist(Px, Py, Pz, tpicked[0], tpicked[1], tpicked[2]);
					if (d < max) 
						max = d;
					count++;
					
				}
		
			}
	
		}
		
	}
	
	if (Method == 1) {
		return max;
	}else{
		return count;
	}

}



void RebuildMesh(Mesh* mesh, Mesh* mesh2, int invert = false, int keepshared = false){
		
	//setup dummy mesh, used for picking
	Mesh* dummy = CopyMeshAt(mesh2);
	
	//loop through each surface
	for(int si=1;si<=mesh->CountSurfaces();si++){
	
		//get and clear surface
		Surface* surf = mesh->GetSurface(si);
		surf->ClearSurface(true, true);
	
		//rebuild triangles that belong to this surface

		list<CSGTriangle*>::iterator ic;
	
		for(ic=CSGTriangle::CSGTriangle_list.begin();ic!=CSGTriangle::CSGTriangle_list.end();ic++){

			CSGTriangle* c=*ic;

			if (c->surf == surf){

				//convert vertex world coords into mesh coords
				/*Entity::TFormPoint(c->x0,c->y0,c->z0, 0, mesh);
				float x0 = Entity::TFormedX();
				float y0 = Entity::TFormedY();
				float z0 = Entity::TFormedZ();

				Entity::TFormPoint(c->x1,c->y1,c->z1, 0, mesh);
				float x1 = Entity::TFormedX();
				float y1 = Entity::TFormedY();
				float z1 = Entity::TFormedZ();

				Entity::TFormPoint(c->x2,c->y2,c->z2, 0, mesh);
				float x2 = Entity::TFormedX();
				float y2 = Entity::TFormedY();
				float z2 = Entity::TFormedZ();*/

				float x0 = c->x0;
				float y0 = c->y0;
				float z0 = c->z0;

				float x1 = c->x1;
				float y1 = c->y1;
				float z1 = c->z1;

				float x2 = c->x2;
				float y2 = c->y2;
				float z2 = c->z2;
			
				//distance between corners
				float d1 = dist(x0,y0,z0, x1,y1,z1);
				float d2 = dist(x1,y1,z1, x2,y2,z2);
				float d3 = dist(x2,y2,z2, x0,y0,z0);
			
				//size of triangle
				float opp = PointDistanceToLine(x0,y0,z0,x1,y1,z1,x2,y2,z2);
	
				//remove empty triangles
				float ep = 0.0001;
				if (!((opp < ep) || (d1<ep) || (d2<ep) || (d3<ep))) {

					//get middle point				
					float mx = (c->x0+c->x1+c->x2) / 3.0;
					float my = (c->y0+c->y1+c->y2) / 3.0;
					float mz = (c->z0+c->z1+c->z2) / 3.0;
					
					/*;offset middle point slightly (don't ask why - tweak)
					;mx=mx+(c\nx*0.0001)
					;my=my+(c\ny*0.0001)
					;mz=mz+(c\nz*0.0001)
					
					;METHOD 1
					;linepick from middle in direction normal
					LinePick mx, my, mz, -c\nx * 1000, -c\ny * 1000, -c\nz * 1000
					finside = (PickedEntity() <> dummy2)
					time# = dist(mx,my,mz,PickedX(),PickedY(),PickedZ())
										
					;;METHOD 2*/
					float d1 = Ray_Intersect_Mesh_Max(dummy, mx, my, mz, -c->nx, -c->ny, -c->nz, true, true, false);
					float d2 = Ray_Intersect_Mesh_Max(dummy, mx, my, mz, -c->nx, -c->ny, -c->nz, true, true, true);
					int finside = (d1 <= d2);
					float time;

					if (finside) {
						time = d1;
					}else{
						time = d2;
					}
					//test for shared edges (they are not detected as being inside the dummy mesh)					
					int fshared = (time < 0.001) & finside;
											
					//invert if requested
					if (invert!=0) 
						finside = !finside;

					if (fshared!=0)
						finside = keepshared;
					
					//if picked the inside of the other shape
					if (finside!=0){

						//actual add triangle to surface
						int v0 = surf->AddVertex(x0, y0, z0, c->u0, c->v0);
						int v1 = surf->AddVertex(x1, y1, z1, c->u1, c->v1);
						int v2 = surf->AddVertex(x2, y2, z2, c->u2, c->v2);
						surf->VertexNormal (v0, c->nx, c->ny, c->nz);
						surf->VertexNormal (v1, c->nx, c->ny, c->nz);
						surf->VertexNormal (v2, c->nx, c->ny, c->nz);
						surf->AddTriangle (v0, v1, v2);
						
					}
			
				}
				
			}
		
		}
		
	}
	
	dummy->FreeEntity();
				
}

Mesh* MeshCSG(Mesh* m1, Mesh* m2, int method){

	//part A
	Mesh* mesh1 = CopyMeshAt(m1);
	Mesh* mesh2 = CopyMeshAt(m2);

	//scan triangles mesh1/mesh2	
	ScanObject(mesh1);
	ScanObject(mesh2);

	//split triangles mesh 1 vs other scanned triangles	
	unsigned int tris=0;
	while (tris!=CSGTriangle::CSGTriangle_list.size()){
		tris=CSGTriangle::CSGTriangle_list.size();
		SplitTriangles(mesh1);	
		SplitTriangles(mesh1);	
	}

	//rebuild 1st mesh, and leave out triangles inside/outside 2nd mesh (dep. on method)
	RebuildMesh(mesh1, m2, (method==2), false); //mesh, other mesh, invert, keepshared
	
	//setup second mesh
	//mesh2->FreeEntity();

	list<CSGTriangle*>::iterator it;
	
	for(it=CSGTriangle::CSGTriangle_list.begin();it!=CSGTriangle::CSGTriangle_list.end();it++){
		delete *it;
	}
	CSGTriangle::CSGTriangle_list.clear();

	//setup partA	
	Mesh* partA = mesh1;
	
	//part B
	mesh1 = CopyMeshAt(m1);
	//mesh2 = CopyMeshAt(m2);

	//scan triangles
	ScanObject(mesh1);
	ScanObject(mesh2);

	//split mesh2	
	tris=0;
	while (tris!=CSGTriangle::CSGTriangle_list.size()){
		tris=CSGTriangle::CSGTriangle_list.size();
		SplitTriangles(mesh2);	
		SplitTriangles(mesh2);	
	}
	
	//rebuild mesh2
	RebuildMesh(mesh2, m1, (method!=1), (method==1)); //mesh, other mesh, invert, keepshared
	mesh1->FreeEntity();
	
	for(it=CSGTriangle::CSGTriangle_list.begin();it!=CSGTriangle::CSGTriangle_list.end();it++){
		delete *it;
	}
	CSGTriangle::CSGTriangle_list.clear();

	//setup partB
	Mesh* partB = mesh2;
	if (method == 0)
		partB->FlipMesh();

	//add partB to partA	

	partB->AddMesh(partA);
	partB->FreeEntity();
		
	mesh1 = partA;

	return mesh1;

}
}
