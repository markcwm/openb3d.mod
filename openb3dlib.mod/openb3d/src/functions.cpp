
#ifdef OPENB3D_GLEW
#include "glew.h"
#else
#ifdef linux
#define GL_GLEXT_PROTOTYPES
#include <GL/gl.h>
#include <GL/glext.h>
#include <GL/glu.h>
#endif

#ifdef WIN32
#include <gl\GLee.h>
#include <GL\glu.h>
#endif

#ifdef __APPLE__
#include "GLee.h"
#include <OpenGL/glu.h>
#endif
#endif

#include "texture.h"
#include "entity.h"
#include "mesh.h"
#include "global.h"
#include "camera.h"
#include "pick.h"
#include "light.h"
#include "shadow.h"
#include "stencil.h"
#include "csg.h"
#include "voxel.h"
#include "octree.h"
#include "geosphere.h"
#include "isosurface.h"
#include "particle.h"
#include "physics.h"
#include "actions.h"

extern "C" {

// wrapper

void FreeShader(Shader *shader){
	shader->FreeShader();
}

void FreeStencil(Stencil *stencil){
	delete stencil;
}

void TextureFlags(Texture* tex, int flags){
	tex->flags=flags;
}

void FreeSurface(Surface* surf){
	surf->FreeVBO();
	delete surf->brush;
	delete surf;
}

void TextureGLTexEnv(Texture* tex, int target, int pname, int param){
	if(target==0) tex->glTexEnv_count=0;
	tex->glTexEnv[0][tex->glTexEnv_count] = target;
	tex->glTexEnv[1][tex->glTexEnv_count] = pname;
	tex->glTexEnv[2][tex->glTexEnv_count] = param;
	tex->TextureBlend(6);
	if(tex->glTexEnv_count<12) tex->glTexEnv_count++;
}

void BrushGLColor(Brush* brush, float r, float g, float b, float a){
	brush->red = r;
	brush->green = g;
	brush->blue = b;
	brush->alpha = a;
}

void BrushGLBlendFunc(Brush* brush, int sfactor, int dfactor){
	brush->glBlendFunc[0] = sfactor;
	brush->glBlendFunc[1] = dfactor;
	brush->BrushBlend(6);
}

// rendering

void BufferToTex(Texture* tex,unsigned char* buffer, int frame){
	tex->BufferToTex(buffer,frame);
}

void BackBufferToTex(Texture* tex,int frame){
	tex->BackBufferToTex(frame);
}

void CameraToTex(Texture* tex, Camera* cam, int frame){
	tex->CameraToTex(cam,frame);
}

void TexToBuffer(Texture* tex,unsigned char* buffer, int frame){
	tex->TexToBuffer(buffer,frame);
}


/*
bbdoc: Minib3d Only
about:
This command is the equivalent of Blitz3D's MeshCullBox command.

It is used to set the radius of a mesh's 'cull sphere' - if the 'cull sphere' is not inside the viewing area, the mesh will not
be rendered.

A mesh's cull radius is set automatically, therefore in most cases you will not have to use this command.

One time you may have to use it is for animated meshes where the default cull radius may not take into account all animation
positions, resulting in the mesh being wrongly culled at extreme positions.
*/
void MeshCullRadius(Entity* ent, float radius){
  	ent->cull_radius=-radius;
}

// Blitz3D functions, A-Z

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddAnimSeq">Online Help</a>
*/
int AddAnimSeq(Entity* ent,int length){
	return ent->AddAnimSeq(length);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddMesh">Online Help</a>
*/
void AddMesh(Mesh* mesh1,Mesh* mesh2){
	mesh1->AddMesh(mesh2);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddTriangle">Online Help</a>
*/
int AddTriangle(Surface* surf,int v0,int v1,int v2){
	return surf->AddTriangle(v0,v1,v2);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddVertex">Online Help</a>
*/
int AddVertex(Surface* surf,float x, float y,float z,float u, float v,float w){
	return surf->AddVertex(x,y,z,u,v,w);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AmbientLight">Online Help</a>
*/
void AmbientLight(float r,float g,float b){
	Global::AmbientLight(r,g,b);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AntiAlias">Online Help</a>
*/
void AntiAlias(int samples){
	//Global::AntiAlias(samples);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animate">Online Help</a>
*/
void Animate(Entity* ent,int mode,float speed,int seq,int trans){
	ent->Animate(mode,speed,seq,trans);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animating">Online Help</a>
*/
int Animating(Entity* ent){
	if (ent->anim_mode!=0) return true;
	if (ent->anim_trans!=0) return true;
	return false;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimLength">Online Help</a>
*/
int AnimLength(Entity* ent){
	return ent->AnimLength();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimSeq">Online Help</a>
*/
int AnimSeq(Entity* ent){
	//return ent->AnimSeq();
	return ent->anim_seq;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimTime">Online Help</a>
*/
float AnimTime(Entity* ent){
	return ent->AnimTime();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushAlpha">Online Help</a>
*/
void BrushAlpha(Brush* brush, float a){
	brush->BrushAlpha(a);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushBlend">Online Help</a>
*/
void BrushBlend(Brush* brush,int blend){
	brush->BrushBlend(blend);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushColor">Online Help</a>
*/
void BrushColor(Brush* brush,float r,float g,float b){
	brush->BrushColor(r,g,b);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushFX">Online Help</a>
*/
void BrushFX(Brush* brush,int fx){
	brush->BrushFX(fx);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushShininess">Online Help</a>
*/
void BrushShininess(Brush* brush,float s){
	brush->BrushShininess(s);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushTexture">Online Help</a>
*/
void BrushTexture(Brush* brush,Texture* tex,int frame,int index){
	brush->BrushTexture(tex,frame,index);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsColor">Online Help</a>
*/
void CameraClsColor(Camera* cam, float r,float g,float b){
	cam->CameraClsColor(r,g,b);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsMode">Online Help</a>
*/
void CameraClsMode(Camera* cam,int cls_depth,int cls_zbuffer){
	cam->CameraClsMode(cls_depth,cls_zbuffer);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogColor">Online Help</a>
*/
void CameraFogColor(Camera* cam,float r,float g,float b){
	cam->CameraFogColor(r,g,b);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogMode">Online Help</a>
*/
void CameraFogMode(Camera* cam,int mode){
	cam->CameraFogMode(mode);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogRange">Online Help</a>
*/
void CameraFogRange(Camera* cam,float nnear,float nfar){
	cam->CameraFogRange(nnear,nfar);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraPick">Online Help</a>
*/
Entity* CameraPick(Camera* cam,float x,float y){
	return Pick::CameraPick(cam,x,y);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProject">Online Help</a>
*/
void CameraProject(Camera* cam,float x,float y,float z){
	cam->CameraProject(x,y,z);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProjMode">Online Help</a>
*/
void  CameraProjMode(Camera* cam,int mode){
	cam->CameraProjMode(mode);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraRange">Online Help</a>
*/
void  CameraRange(Camera* cam,float nnear,float nfar){
	cam->CameraRange(nnear,nfar);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraViewport">Online Help</a>
*/
void  CameraViewport(Camera* cam,int x,int y,int width,int height){
	cam->CameraViewport(x,y,width,height);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraZoom">Online Help</a>
*/
void  CameraZoom(Camera* cam,float zoom){
	cam->CameraZoom(zoom);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearCollisions">Online Help</a>
*/
void ClearCollisions(){
	Global::ClearCollisions();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearSurface">Online Help</a>
*/
void ClearSurface(Surface* surf,bool clear_verts,bool clear_tris){
	surf->ClearSurface(clear_verts,clear_tris);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearTextureFilters">Online Help</a>
*/
void ClearTextureFilters(){
	Texture::ClearTextureFilters();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearWorld">Online Help</a>
*/
void ClearWorld(bool entities,bool brushes,bool textures){
	Global::ClearWorld(entities,brushes,textures);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionEntity">Online Help</a>
*/
Entity* CollisionEntity(Entity* ent,int index){
	return ent->CollisionEntity(index);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Collisions">Online Help</a>
*/
void Collisions(int src_no,int dest_no,int method_no,int response_no){
	Global::Collisions(src_no,dest_no,method_no,response_no);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNX">Online Help</a>
*/
float CollisionNX(Entity* ent,int index){
	return ent->CollisionNX(index);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNY">Online Help</a>
*/
float CollisionNY(Entity* ent,int index){
	return ent->CollisionNY(index);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNZ">Online Help</a>
*/
float CollisionNZ(Entity* ent,int index){
	return ent->CollisionNZ(index);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionSurface">Online Help</a>
*/
Surface* CollisionSurface(Entity* ent,int index){
	return ent->CollisionSurface(index);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTime">Online Help</a>
*/
float CollisionTime(Entity* ent,int index){
	return ent->CollisionTime(index);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTriangle">Online Help</a>
*/
int CollisionTriangle(Entity* ent,int index){
	return ent->CollisionTriangle(index);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionX">Online Help</a>
*/
float CollisionX(Entity* ent,int index){
	return ent->CollisionX(index);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionY">Online Help</a>
*/
float CollisionY(Entity* ent,int index){
	return ent->CollisionY(index);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionZ">Online Help</a>
*/
float CollisionZ(Entity* ent,int index){
	return ent->CollisionZ(index);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountChildren">Online Help</a>
*/
int CountChildren(Entity* ent){
	return ent->CountChildren();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountCollisions">Online Help</a>
*/
int CountCollisions(Entity* ent){
	return ent->CountCollisions();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyEntity">Online Help</a>
*/
Entity* CopyEntity(Entity* ent,Entity* parent){
	return ent->CopyEntity(parent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyMesh">Online Help</a>
*/
Mesh* CopyMesh(Mesh* mesh,Entity* parent){
	return mesh->CopyMesh(parent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountSurfaces">Online Help</a>
*/
int CountSurfaces(Mesh* mesh){
	return mesh->CountSurfaces();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountTriangles">Online Help</a>
*/
int CountTriangles(Surface* surf){
	return surf->CountTriangles();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountVertices">Online Help</a>
*/
int CountVertices(Surface* surf){
	return surf->CountVertices();
}

Blob* CreateBlob(Fluid* fluid, float radius, Entity* parent_ent){
	return Blob::CreateBlob(fluid, radius, parent_ent);
}

Bone* CreateBone(Mesh* mesh, Entity* parent_ent){
	return mesh->CreateBone(parent_ent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateBrush">Online Help</a>
*/
Brush* CreateBrush(float r,float g,float b){
	return Brush::CreateBrush(r,g,b);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCamera">Online Help</a>
*/
Camera* CreateCamera(Entity* parent){
	return Camera::CreateCamera(parent);
}

Constraint* CreateConstraint(Entity* p1, Entity* p2, float l){
	return Constraint::CreateConstraint(p1, p2, l);
}


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCone">Online Help</a>
*/
Mesh* CreateCone(int segments,bool solid,Entity* parent){
	return Mesh::CreateCone(segments,solid,parent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCylinder">Online Help</a>
*/
Mesh* CreateCylinder(int segments,bool solid,Entity* parent){
	return Mesh::CreateCylinder(segments,solid,parent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCube">Online Help</a>
*/
Mesh* CreateCube(Entity* parent){
	return Mesh::CreateCube(parent);
}

/*
*/
Terrain* CreateGeosphere(int size, Entity* parent){
	return Geosphere::CreateGeosphere(size,parent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateMesh">Online Help</a>
*/
Mesh* CreateMesh(Entity* parent){
	return Mesh::CreateMesh(parent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateLight">Online Help</a>
*/
Light* CreateLight(int light_type,Entity* parent){
	return Light::CreateLight(light_type,parent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreatePivot">Online Help</a>
*/
Pivot* CreatePivot(Entity* parent){
	return Pivot::CreatePivot(parent);
}

Mesh* CreatePlane(int divisions,Entity* parent){
	return Mesh::CreatePlane(divisions,parent);
}

Mesh* CreateQuad(Entity* parent){
    return Mesh::CreateQuad(parent);
}

RigidBody* CreateRigidBody(Entity* body, Entity* p1, Entity* p2, Entity* p3, Entity* p4){
	return RigidBody::CreateRigidBody(body, p1, p2, p3, p4);
}


ShadowObject* CreateShadow(Mesh* parent, char Static){
	return ShadowObject::Create(parent, Static);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSphere">Online Help</a>
*/
Mesh* CreateSphere(int segments,Entity* parent){
	return Mesh::CreateSphere(segments,parent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSprite">Online Help</a>
*/
Sprite* CreateSprite(Entity* parent){
	return Sprite::CreateSprite(parent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSurface">Online Help</a>
*/
Surface* CreateSurface(Mesh* mesh,Brush* brush){
	return mesh->CreateSurface(brush);
}

/*
*/
Stencil* CreateStencil(){
	return Stencil::CreateStencil();
}

/*
*/
Terrain* CreateTerrain(int size, Entity* parent){
	return Terrain::CreateTerrain(size,parent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateTexture">Online Help</a>
*/
Texture* CreateTexture(int width,int height,int flags,int frames){
	return Texture::CreateTexture(width,height,flags,frames);
}

/*
*/
VoxelSprite* CreateVoxelSprite(int slices, Entity* parent){
	return VoxelSprite::CreateVoxelSprite(slices, parent);
}


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaPitch">Online Help</a>
*/
float DeltaPitch(Entity* ent1,Entity* ent2){
	return ent1->DeltaPitch(ent2);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaYaw">Online Help</a>
*/
float DeltaYaw(Entity* ent1,Entity* ent2){
	return ent1->DeltaYaw(ent2);
}

void EmitterVector(ParticleEmitter* emit, float x, float y, float z){
	emit->EmitterVector(x, y, z);
}

void EmitterRate(ParticleEmitter* emit, float r){
	emit->EmitterRate(r);
}

void EmitterParticleLife(ParticleEmitter* emit, int l){
	emit->EmitterParticleLife(l);
}

void EmitterParticleFunction(ParticleEmitter* emit, void (*EmitterFunction)(Entity*, int)){
	emit->EmitterParticleFunction(EmitterFunction);
}


void EmitterParticleSpeed(ParticleEmitter* emit, float s){
	emit->EmitterParticleSpeed(s);
}

void EmitterVariance(ParticleEmitter* emit, float v){
	emit->EmitterVariance(v);
}



/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAlpha">Online Help</a>
*/
void EntityAlpha(Entity* ent,float alpha){
	ent->EntityAlpha(alpha);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAutoFade">Online Help</a>
*/
void EntityAutoFade(Entity* ent,float near,float far){
//	ent->EntityAutoFade(near,far);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBlend">Online Help</a>
*/
void EntityBlend(Entity* ent, int blend){
	ent->EntityBlend(blend);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBox">Online Help</a>
*/
void EntityBox(Entity* ent,float x,float y,float z,float w,float h,float d){
	ent->EntityBox(x,y,z,w,h,d);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityClass">Online Help</a>
*/
const char* EntityClass(Entity* ent){
	return ent->EntityClass().c_str();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityCollided">Online Help</a>
*/
Entity* EntityCollided(Entity* ent,int type_no){
	return ent->EntityCollided(type_no);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityColor">Online Help</a>
*/
void EntityColor(Entity* ent,float red,float green,float blue){
	ent->EntityColor(red,green,blue);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityDistance">Online Help</a>
*/
float EntityDistance(Entity* ent1,Entity* ent2){
	return ent1->EntityDistance(ent2);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityFX">Online Help</a>
*/
void EntityFX(Entity* ent,int fx){
	ent->EntityFX(fx);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityInView">Online Help</a>
*/
int EntityInView(Entity* ent,Camera* cam){
	return cam->EntityInView(ent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityName">Online Help</a>
*/
const char* EntityName(Entity* ent){
	return ent->EntityName().c_str();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityOrder">Online Help</a>
*/
void EntityOrder(Entity* ent,int order){
	ent->EntityOrder(order);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityParent">Online Help</a>




*/
void EntityParent(Entity* ent,Entity* parent_ent,bool glob){
	ent->EntityParent(parent_ent,glob);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPick">Online Help</a>
*/
Entity* EntityPick(Entity* ent,float range){
	return Pick::EntityPick(ent,range);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPickMode">Online Help</a>
*/
void EntityPickMode(Entity* ent,int pick_mode,bool obscurer){
	ent->EntityPickMode(pick_mode,obscurer);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPitch">Online Help</a>
*/
float EntityPitch(Entity* ent,bool glob){
	return ent->EntityPitch(glob);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRadius">Online Help</a>
*/
void EntityRadius(Entity* ent,float radius_x,float radius_y){
	ent->EntityRadius(radius_x,radius_y);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRoll">Online Help</a>
*/
float EntityRoll(Entity* ent,bool glob){
	return ent->EntityRoll(glob);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityShininess">Online Help</a>
*/
void EntityShininess(Entity* ent,float shine){
	ent->EntityShininess(shine);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityTexture">Online Help</a>
*/
void EntityTexture(Entity* ent,Texture* tex,int frame,int index){
//	Mesh*(ent).EntityTexture(Texture* tex,frame,index);
	ent->EntityTexture(tex,frame,index);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityType">Online Help</a>
*/
void EntityType(Entity* ent,int type_no,bool recursive){
	ent->EntityType(type_no,recursive);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityVisible">Online Help</a>
*/
int EntityVisible(Entity* src_ent,Entity* dest_ent){
	return Pick::EntityVisible(src_ent,dest_ent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityX">Online Help</a>
*/
float EntityX(Entity* ent,bool glob){
	return ent->EntityX(glob);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityY">Online Help</a>
*/
float EntityY(Entity* ent,bool glob){
	return ent->EntityY(glob);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityYaw">Online Help</a>
*/
float EntityYaw(Entity* ent,bool glob){
	return ent->EntityYaw(glob);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityZ">Online Help</a>
*/
float EntityZ(Entity* ent,bool glob){
	return ent->EntityZ(glob);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ExtractAnimSeq">Online Help</a>
*/
int ExtractAnimSeq(Entity* ent,int first_frame,int last_frame,int seq){
	return ent->ExtractAnimSeq(first_frame,last_frame,seq);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindChild">Online Help</a>
*/
Entity* FindChild(Entity* ent,char* child_name){
	return ent->FindChild(child_name);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindSurface">Online Help</a>
*/
Surface* FindSurface(Mesh* mesh,Brush* brush){
  //	return mesh->FindSurface(brush);
  return 0;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FitMesh">Online Help</a><p>
*/
void FitMesh(Mesh* mesh,float x,float y,float z,float width,float height,float depth,bool uniform){
	mesh->FitMesh(x,y,z,width,height,depth,uniform);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FlipMesh">Online Help</a>
*/
void FlipMesh(Mesh* mesh){
	mesh->FlipMesh();
}

void FluidArray(Fluid* fluid, float* Array, int w, int h, int d){
	fluid->FluidArray(Array, w, h, d);
}

void FluidFunction(Fluid* fluid, float (*FieldFunction)(float, float, float)){
	fluid->FluidFunction(FieldFunction);
}

void FluidThreshold(Fluid* fluid, float threshold){
	fluid->threshold=threshold;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeBrush">Online Help</a>
*/
void  FreeBrush(Brush* brush){
	brush->FreeBrush();
}

void FreeConstraint(Constraint* con){
	con->FreeConstraint();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeEntity">Online Help</a>
*/
void FreeEntity(Entity* ent){
	ent->FreeEntity();
}

void FreeRigidBody(RigidBody* body){
	body->FreeRigidBody();
}

void FreeShadow(ShadowObject* shad){
	shad->FreeShadow();
}


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeTexture">Online Help</a>
*/
void FreeTexture(Texture* tex){
	tex->FreeTexture();
}


void GeosphereHeight(Geosphere* geo, float h){
	geo->vsize=h;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetBrushTexture">Online Help</a>
*/
Texture* GetBrushTexture(Brush* brush,int index){
   return brush->GetBrushTexture(index);
  //return Texture::GetBrushTexture(brush,index);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetChild">Online Help</a>
*/
Entity* GetChild(Entity* ent,int child_no){
	return ent->GetChild(child_no);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityBrush">Online Help</a>
*/
Brush* GetEntityBrush(Entity* ent){
	return ent->GetEntityBrush();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityType">Online Help</a>
*/
int GetEntityType(Entity* ent){
	return ent->GetEntityType();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ResetEntity">Online Help</a>
*/
float GetMatElement(Entity* ent,int row,int col){
//	ent->GetMatElement(row,col);
  return 0.0f;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetParent">Online Help</a>
*/
Entity* GetParentEntity(Entity* ent){
	return ent->GetParent();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurface">Online Help</a>
*/
Surface* GetSurface(Mesh* mesh,int surf_no){
	return mesh->GetSurface(surf_no);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurfaceBrush">Online Help</a>
*/
Brush* GetSurfaceBrush(Surface* surf){
	return surf->GetSurfaceBrush();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Graphics3D">Online Help</a>
*/
void Graphics3D(int width,int height,int depth,int mode,int rate){
	Global::Graphics(); //(width,height,depth,mode,rate);
	Global::width=width;
	Global::height=height;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HandleSprite">Online Help</a>
*/
void HandleSprite(Sprite* sprite,float h_x,float h_y){
	sprite->HandleSprite(h_x,h_y);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HideEntity">Online Help</a>
*/
void HideEntity(Entity* ent){
	ent->HideEntity();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightColor">Online Help</a>
*/
void LightColor(Light* light,float red,float green,float blue){
	light->LightColor(red,green,blue);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightConeAngles">Online Help</a>
*/
void LightConeAngles(Light* light,float inner_ang,float outer_ang){
	light->LightConeAngles(inner_ang,outer_ang);
}

/*

bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightRange">Online Help</a>
*/
void LightRange(Light* light,float range){
	light->LightRange(range);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LinePick">Online Help</a>
*/
Entity* LinePick(float x,float y,float z,float dx,float dy,float dz,float radius){
	return Pick::LinePick(x,y,z,dx,dy,dz,radius);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimMesh">Online Help</a>
*/
Mesh* LoadAnimMesh(char* file,Entity* parent){
	return Mesh::LoadAnimMesh(file,parent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimSeq">Online Help</a>
*/
int LoadAnimSeq(Entity* ent, char* file){
	return ent->LoadAnimSeq(file);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimTexture">Online Help</a>
*/
Texture* LoadAnimTexture(char* file,int flags,int frame_width,int frame_height,int first_frame,int frame_count){
	return Texture::LoadAnimTexture(file,flags,frame_width,frame_height,first_frame,frame_count);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadBrush">Online Help</a>
*/
Brush* LoadBrush(char *file,int flags,float u_scale,float v_scale){
	return Brush::LoadBrush(file,flags,u_scale,v_scale);
}

Terrain* LoadGeosphere(char* file,Entity* parent){
	return Geosphere::LoadGeosphere(file,parent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadMesh">Online Help</a>
*/
Mesh* LoadMesh(char* file,Entity* parent){
	return Mesh::LoadMesh(file,parent);
}


Terrain* LoadTerrain(char* file,Entity* parent){
	return Terrain::LoadTerrain(file,parent);
}


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadTexture">Online Help</a>
*/
Texture* LoadTexture(char* file,int flags){
	return Texture::LoadTexture(file,flags);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadSprite">Online Help</a>
*/
Sprite* LoadSprite(char* tex_file,int tex_flag,Entity* parent){
	return Sprite::LoadSprite(tex_file,tex_flag,parent);
}

/*
*/
Mesh* MeshCSG(Mesh* m1, Mesh* m2, int method = 1){
	return CSG::MeshCSG(m1, m2, method);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshDepth">Online Help</a>
*/
float MeshDepth(Mesh* mesh){
	return mesh->MeshDepth();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshesIntersect">Online Help</a>
*/
int MeshesIntersect(Mesh* mesh1,Mesh* mesh2){
	return mesh1->MeshesIntersect(mesh2);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshHeight">Online Help</a>
*/
float MeshHeight(Mesh* mesh){
	return mesh->MeshHeight();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshWidth">Online Help</a>
*/
float MeshWidth(Mesh* mesh){
	return mesh->MeshWidth();
}

void ModifyGeosphere(Geosphere* geo, int x, int z, float new_height){
	geo->ModifyGeosphere ( x,  z, new_height);
}


void ModifyTerrain(Terrain* terr, int x, int z, float new_height){
	terr->ModifyTerrain ( x,  z, new_height);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MoveEntity">Online Help</a>
*/
void MoveEntity(Entity* ent,float x,float y,float z){
	ent->MoveEntity(x,y,z);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=NameEntity">Online Help</a>
*/
void NameEntity(Entity* ent,char* name){
	ent->NameEntity(name);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintEntity">Online Help</a>
*/
void PaintEntity(Entity* ent,Brush* brush){
	ent->PaintEntity(*brush);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintMesh">Online Help</a>
*/
void PaintMesh(Mesh* mesh,Brush* brush){
	mesh->PaintMesh(brush);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintSurface">Online Help</a>
*/
void PaintSurface(Surface* surf,Brush* brush){
	surf->PaintSurface(brush);
}

void ParticleColor(Sprite* sprite, float r, float g, float b, float a){
	ParticleBatch* p=ParticleBatch::GetParticleBatch(sprite->brush.tex[0],sprite->brush.blend,sprite->order);
	p->brush.red=r/255.0+2;
	p->brush.green=g/255.0+2;
	p->brush.blue=b/255.0+2;
	p->brush.alpha=a+2;
}

void ParticleVector(Sprite* sprite, float x, float y, float z){
	ParticleBatch* p=ParticleBatch::GetParticleBatch(sprite->brush.tex[0],sprite->brush.blend,sprite->order);
	p->px=x;
	p->py=y;
	p->pz=z;
}

void ParticleTrail(Sprite* sprite,int length){
	ParticleBatch* p=ParticleBatch::GetParticleBatch(sprite->brush.tex[0],sprite->brush.blend,sprite->order);
	p->trail=length;
}


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedEntity">Online Help</a>
*/
Entity* PickedEntity(){
//	return TPick.PickedEntity:TEntity();
	return Pick::PickedEntity();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNX">Online Help</a>
*/
float PickedNX(){
	return Pick::PickedNX();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNY">Online Help</a>
*/
float PickedNY(){
	return Pick::PickedNY();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNZ">Online Help</a>
*/
float PickedNZ(){
	return Pick::PickedNZ();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedSurface">Online Help</a>
*/
Surface* PickedSurface(){
//	return TPick.PickedSurface:TSurface()
	return Pick::PickedSurface();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTime">Online Help</a>
*/
float PickedTime(){
	return Pick::PickedTime();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTriangle">Online Help</a>
*/
int PickedTriangle(){
	return Pick::PickedTriangle();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedX">Online Help</a>
*/
float PickedX(){
	return Pick::PickedX();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedY">Online Help</a>
*/
float PickedY(){
	return Pick::PickedY();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedZ">Online Help</a>
*/
float PickedZ(){
	return Pick::PickedZ();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PointEntity">Online Help</a>
*/
void PointEntity(Entity* ent,Entity* target_ent,float roll){
	ent->PointEntity(target_ent,roll);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionEntity">Online Help</a>
*/
void PositionEntity(Entity* ent,float x,float y,float z,bool glob){
	ent->PositionEntity(x,y,z,glob);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionMesh">Online Help</a>
*/
void PositionMesh(Mesh* mesh,float px,float py,float pz){
	mesh->PositionMesh(px,py,pz);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionTexture">Online Help</a>
*/
void PositionTexture(Texture* tex,float u_pos,float v_pos){
	tex->PositionTexture(u_pos,v_pos);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedX">Online Help</a>
*/
float ProjectedX(){
    return Camera::projected_x;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedY">Online Help</a>
*/
float ProjectedY(){
    return Camera::projected_y;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedZ">Online Help</a>
*/
float ProjectedZ(){
    return Camera::projected_z;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RenderWorld">Online Help</a>
*/
void RenderWorld(){
	Global::RenderWorld();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RepeatMesh">Online Help</a>
*/
Mesh* RepeatMesh(Mesh* mesh,Entity* parent){
	return mesh->RepeatMesh(parent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ResetEntity">Online Help</a>
*/
void ResetEntity(Entity* ent){
	ent->ResetEntity();
}

void ResetShadow(ShadowObject* shad){
	shad->VCreated=0;
}


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateEntity">Online Help</a>
*/
void RotateEntity(Entity* ent,float x,float y,float z,bool glob){
	ent->RotateEntity(x,y,z,glob);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateMesh">Online Help</a>
*/
void RotateMesh(Mesh* mesh,float pitch,float yaw,float roll){
	mesh->RotateMesh(pitch,yaw,roll);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateSprite">Online Help</a>
*/
void RotateSprite(Sprite* sprite,float ang){
	sprite->RotateSprite(ang);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateTexture">Online Help</a>
*/
void RotateTexture(Texture* tex,float ang){
	tex->RotateTexture(ang);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleEntity">Online Help</a>
*/
void ScaleEntity(Entity* ent,float x,float y,float z,bool glob){
	ent->ScaleEntity(x,y,z,glob);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleMesh">Online Help</a>
*/
void ScaleMesh(Mesh* mesh,float sx,float sy,float sz){
	mesh->ScaleMesh(sx,sy,sz);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleSprite">Online Help</a>
*/
void ScaleSprite(Sprite* sprite,float s_x,float s_y){
	sprite->ScaleSprite(s_x,s_y);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleTexture">Online Help</a>
*/
void ScaleTexture(Texture* tex,float u_scale,float v_scale){
	tex->ScaleTexture(u_scale,v_scale);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetAnimKey">Online Help</a>
*/
void SetAnimKey(Entity* ent, float frame, int pos_key=true, int rot_key=true, int scale_key=true){
	ent->SetAnimKey(frame, pos_key, rot_key, scale_key);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetAnimTime">Online Help</a>
*/
void SetAnimTime(Entity* ent,float time,int seq){
	ent->SetAnimTime(time,seq);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeFace">Online Help</a>
*/
void SetCubeFace(Texture* tex,int face){


	tex->cube_face=face;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeMode">Online Help</a>
*/





void SetCubeMode(Texture* tex,int mode){
	tex->cube_mode=mode;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ShowEntity">Online Help</a>
*/
void ShowEntity(Entity* ent){
	ent->ShowEntity();
}

void SkinMesh(Mesh* mesh, int surf_no_get, int vid, int bone1, float weight1=1.0, int bone2=0, float weight2=0, int bone3=0, float weight3=0, int bone4=0, float weight4=0){
	mesh->SkinMesh(surf_no_get, vid, bone1, weight1, bone2, weight2, bone3, weight3, bone4, weight4);
}


void SpriteRenderMode(Sprite* sprite,int mode){
	sprite->SpriteRenderMode(mode);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SpriteViewMode">Online Help</a>
*/
void SpriteViewMode(Sprite* sprite,int mode){
	sprite->SpriteViewMode(mode);
}

/*
*/
void StencilAlpha(Stencil* stencil, float a){
	stencil->StencilAlpha(a);
}

/*
*/
void StencilClsColor(Stencil* stencil, float r,float g,float b){
	stencil->StencilClsColor(r,g,b);
}

/*
*/
void StencilClsMode(Stencil* stencil,int cls_depth,int cls_zbuffer){
	stencil->StencilClsMode(cls_depth,cls_zbuffer);
}

/*
*/
void StencilMesh(Stencil* stencil, Mesh* mesh, int mode=1){
	stencil->StencilMesh(mesh, mode);
}

/*
*/
void StencilMode(Stencil* stencil, int m, int o=1){
	stencil->StencilMode(m, o);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainHeight">Online Help</a>
*/
float TerrainHeight (Terrain* terr, int x, int z){
	return terr->TerrainHeight (x, z);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainX">Online Help</a>
*/
float TerrainX (Terrain* terr, float x, float y, float z){
	return terr->TerrainX (x, y, z);
}

/*

bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainY">Online Help</a>
*/
float TerrainY (Terrain* terr, float x, float y, float z){
	return terr->TerrainY (x, y, z);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainZ">Online Help</a>
*/
float TerrainZ (Terrain* terr, float x, float y, float z){
	return terr->TerrainZ (x, y, z);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureBlend">Online Help</a>
*/
void TextureBlend(Texture* tex,int blend){
	tex->TextureBlend(blend);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureCoords">Online Help</a>
*/
void TextureCoords(Texture* tex,int coords){
	tex->TextureCoords(coords);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureHeight">Online Help</a>
*/
int TextureHeight(Texture* tex){
  return tex->height;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureFilter">Online Help</a>
*/
void TextureFilter(char* match_text,int flags){
	Texture::AddTextureFilter(match_text,flags);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureName">Online Help</a>
*/
const char* TextureName(Texture* tex){
	return tex->TextureName().c_str();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureWidth">Online Help</a>
*/
int TextureWidth(Texture* tex){
  return tex->width;
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedX">Online Help</a>
*/
float TFormedX(){
	return Entity::TFormedX();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedY">Online Help</a>
*/
float TFormedY(){
	return Entity::TFormedY();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedZ">Online Help</a>
*/
float TFormedZ(){
	return Entity::TFormedZ();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormNormal">Online Help</a>
*/
void TFormNormal(float x,float y,float z,Entity* src_ent,Entity* dest_ent){
	Entity::TFormNormal(x,y,z,src_ent,dest_ent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormPoint">Online Help</a>
*/
void TFormPoint(float x,float y,float z,Entity* src_ent,Entity* dest_ent){
	Entity::TFormPoint(x,y,z,src_ent,dest_ent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormVector">Online Help</a>
*/
void TFormVector(float x,float y,float z,Entity* src_ent,Entity* dest_ent){
	Entity::TFormVector(x,y,z,src_ent,dest_ent);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TranslateEntity">Online Help</a>
*/
void TranslateEntity(Entity* ent,float x,float y,float z,bool glob){
	ent->TranslateEntity(x,y,z,glob);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TriangleVertex">Online Help</a>
*/
int TriangleVertex(Surface* surf,int tri_no,int corner){
	return surf->TriangleVertex(tri_no,corner);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TurnEntity">Online Help</a>
*/
void TurnEntity(Entity* ent,float x,float y,float z,bool glob){
	ent->TurnEntity(x,y,z,glob);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateNormals">Online Help</a>
*/
void UpdateNormals(Mesh* mesh){
	mesh->UpdateNormals();
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateNormals">Online Help</a>
*/
void UpdateTexCoords(Surface* surf){
	surf->UpdateTexCoords();
}


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateWorld">Online Help</a>
*/
void UpdateWorld(float anim_speed){
	Global::UpdateWorld(anim_speed);
}

/*
*/
void UseStencil(Stencil* stencil){
	if (stencil==0)
		glDisable(GL_STENCIL_TEST);
	else
		stencil->UseStencil();
}
/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorPitch">Online Help</a>
*/
float VectorPitch(float vx,float vy,float vz){
	//return Vector->VectorPitch(vx,vy,vz);
	float ang=atan2deg(sqrt(vx*vx+vz*vz),vy)-90.0;

	if (ang<=0.0001 && ang>=-0.0001) ang=0;

	return -ang;

}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorYaw">Online Help</a>
*/
float VectorYaw(float vx,float vy,float vz){
	//return Vector->VectorYaw(vx,vy,vz);
	return atan2deg(-vx,vz);

}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexAlpha">Online Help</a>
*/
float VertexAlpha(Surface* surf,int vid){
	return surf->VertexAlpha(vid);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexBlue">Online Help</a>
*/
float VertexBlue(Surface* surf,int vid){
	return surf->VertexBlue(vid);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexColor">Online Help</a>
*/
void VertexColor(Surface* surf,int vid,float r,float g,float b,float a){
	surf->VertexColor(vid,r,g,b,a);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexCoords">Online Help</a>
*/
void VertexCoords(Surface* surf,int vid,float x,float y,float z){
	surf->VertexCoords(vid,x,y,z);

}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexGreen">Online Help</a>
*/
float VertexGreen(Surface* surf,int vid){
	return surf->VertexGreen(vid);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNormal">Online Help</a>
*/
void VertexNormal(Surface* surf,int vid,float nx,float ny,float nz){
	surf->VertexNormal(vid,nx,ny,nz);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNX">Online Help</a>
*/
float VertexNX(Surface* surf,int vid){
	return surf->VertexNX(vid);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNY">Online Help</a>
*/
float VertexNY(Surface* surf,int vid){
	return surf->VertexNY(vid);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNZ">Online Help</a>
*/
float VertexNZ(Surface* surf,int vid){
	return surf->VertexNZ(vid);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexRed">Online Help</a>
*/
float VertexRed(Surface* surf,int vid){
	return surf->VertexRed(vid);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexTexCoords">Online Help</a>
*/
void VertexTexCoords(Surface* surf,int vid,float u,float v,float w,int coord_set){
	surf->VertexTexCoords(vid,u,v,w,coord_set);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexU">Online Help</a>
*/
float VertexU(Surface* surf,int vid,int coord_set){

	return surf->VertexU(vid,coord_set);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexV">Online Help</a>
*/
float VertexV(Surface* surf,int vid,int coord_set){
	return surf->VertexV(vid,coord_set);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexW">Online Help</a>
*/
float VertexW(Surface* surf,int vid,int coord_set){
	return surf->VertexW(vid,coord_set);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexX">Online Help</a>
*/
float VertexX(Surface* surf,int vid){
	return surf->VertexX(vid);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexY">Online Help</a>
*/
float VertexY(Surface* surf,int vid){
	return surf->VertexY(vid);
}

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexZ">Online Help</a>
*/
float VertexZ(Surface* surf,int vid){
	return surf->VertexZ(vid);
}

/*
*/
void VoxelSpriteMaterial(VoxelSprite* voxelspr, Material* mat){
	voxelspr->VoxelSpriteMaterial(mat);
}


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Wireframe">Online Help</a>
*/
void Wireframe(int enable){
	if (enable!=0)
	  glPolygonMode(GL_FRONT,GL_LINE);
	else
	  glPolygonMode(GL_FRONT,GL_FILL);

}

//' Blitz2D
/*
int Text(int x,int y,char* str){
	TBlitz2D.Text(x,y,str);
}

int BeginMax2D(){
	TBlitz2D.BeginMax2D();
}

int EndMax2D(){
	TBlitz2D.EndMax2D();
}
*/
//' ***extras***

float EntityScaleX(Entity* ent,bool glob){
	return ent->EntityScaleX(glob);
}

float EntityScaleY(Entity* ent,bool glob){
	return ent->EntityScaleY(glob);
}

float EntityScaleZ(Entity* ent,bool glob){
	return ent->EntityScaleZ(glob);
}

Shader* LoadShader(char* ShaderName, char* VshaderFileName, char* FshaderFileName){
	Shader* s=Shader::CreateShaderMaterial(ShaderName);
	s->AddShader(VshaderFileName, FshaderFileName);
	return s;
}

Shader* CreateShader(char* ShaderName, char* VshaderString, char* FshaderString){
	Shader* s=Shader::CreateShaderMaterial(ShaderName);
	s->AddShaderFromString(VshaderString, FshaderString);
	return s;
}

void ShadeSurface(Surface* surf, Shader* material){
	surf->ShaderMat = material;
}

void ShadeMesh(Mesh* mesh, Shader* material){
	for(int s=1;s<=mesh->CountSurfaces();s++){

		Surface* surf=mesh->GetSurface(s);
		surf->ShaderMat = material;
	}
}

void ShadeEntity(Entity* ent, Shader* material){
	Mesh* mesh=dynamic_cast<Mesh*>(ent);
	Terrain* terr=dynamic_cast<Terrain*>(ent);

	if (terr)
		terr->ShaderMat = material;
	if (mesh)
		ShadeMesh(mesh, material);
}

Texture* ShaderTexture(Shader* material, Texture* tex, char* name, int index){
	return material->AddSampler2D(name, index, tex);
}

void SetFloat(Shader* material, char* name, float v1){
	material->SetFloat(name, v1);
}

void SetFloat2(Shader* material, char* name, float v1, float v2){
	material->SetFloat2(name, v1, v2);
}

void SetFloat3(Shader* material, char* name, float v1, float v2, float v3){
	material->SetFloat3(name, v1, v2, v3);
}

void SetFloat4(Shader* material, char* name, float v1, float v2, float v3, float v4){
	material->SetFloat4(name, v1, v2, v3, v4);
}

void UseFloat(Shader* material, char* name, float* v1){
	material->UseFloat(name, v1);
}

void UseFloat2(Shader* material, char* name, float* v1, float* v2){
	material->UseFloat2(name, v1, v2);
}

void UseFloat3(Shader* material, char* name, float* v1, float* v2, float* v3){
	material->UseFloat3(name, v1, v2, v3);
}

void UseFloat4(Shader* material, char* name, float* v1, float* v2, float* v3, float* v4){
	material->UseFloat4(name, v1, v2, v3, v4);
}

void SetInteger(Shader* material, char* name, int v1){
	material->SetInteger(name, v1);
}

void SetInteger2(Shader* material, char* name, int v1, int v2){
	material->SetInteger2(name, v1, v2);
}

void SetInteger3(Shader* material, char* name, int v1, int v2, int v3){
	material->SetInteger3(name, v1, v2, v3);
}

void SetInteger4(Shader* material, char* name, int v1, int v2, int v3, int v4){
	material->SetInteger4(name, v1, v2, v3, v4);
}

void UseInteger(Shader* material, char* name, int* v1){
	material->UseInteger(name, v1);
}

void UseInteger2(Shader* material, char* name, int* v1, int* v2){
	material->UseInteger2(name, v1, v2);
}

void UseInteger3(Shader* material, char* name, int* v1, int* v2, int* v3){
	material->UseInteger3(name, v1, v2, v3);
}

void UseInteger4(Shader* material, char* name, int* v1, int* v2, int* v3, int* v4){
	material->UseInteger4(name, v1, v2, v3, v4);
}

void UseSurface(Shader* material, char* name, Surface* surf, int vbo){
	material->UseSurface(name, surf, vbo);
}

void UseMatrix(Shader* material, char* name, int mode){
	material->UseMatrix(name, mode);
}

Material* LoadMaterial(char* filename,int flags, int frame_width,int frame_height,int first_frame,int frame_count){
	return Material::LoadMaterial(filename, flags, frame_width, frame_height, first_frame, frame_count);
}

void ShaderMaterial(Shader* material, Material* tex, char* name, int index){
	material->AddSampler3D(name, index, tex);
}

void AmbientShader(Shader* material){
	Global::ambient_shader=material;
}



OcTree* CreateOcTree(float w, float h, float d, Entity* parent_ent=0){
	return OcTree::CreateOcTree(w, h, d, parent_ent);
}

void OctreeBlock(OcTree* octree, Mesh* mesh, int level, float X, float Y, float Z, float Near=0.0, float Far=1000.0){
	octree->OctreeBlock(mesh, level, X, Y, Z, Near, Far);
}

void OctreeMesh(OcTree* octree, Mesh* mesh, int level, float X, float Y, float Z, float Near=0.0, float Far=1000.0){
	octree->OctreeMesh(mesh, level, X, Y, Z, Near, Far);
}

Fluid* CreateFluid(){
	return Fluid::CreateFluid();
}

ParticleEmitter* CreateParticleEmitter(Entity* particle, Entity* parent_ent=0){
	return ParticleEmitter::CreateParticleEmitter(particle, parent_ent);
}

Action* ActMoveBy(Entity* ent, float a, float b, float c, float rate){
	return Action::AddAction(ent, ACT_MOVEBY, a, b, c, rate);
}

Action* ActTurnBy(Entity* ent, float a, float b, float c, float rate){
	return Action::AddAction(ent, ACT_TURNBY, a, b, c, rate);
}

Action* ActVector(Entity* ent, float a, float b, float c){
	return Action::AddAction(ent, ACT_VECTOR, a, b, c, 0);
}

Action* ActMoveTo(Entity* ent, float a, float b, float c, float rate){
	return Action::AddAction(ent, ACT_MOVETO, a, b, c, rate);
}

Action* ActTurnTo(Entity* ent, float a, float b, float c, float rate){
	return Action::AddAction(ent, ACT_TURNTO, a, b, c, rate);
}

Action* ActScaleTo(Entity* ent, float a, float b, float c, float rate){
	return Action::AddAction(ent, ACT_SCALETO, a, b, c, rate);
}

Action* ActFadeTo(Entity* ent, float a, float rate){
	return Action::AddAction(ent, ACT_FADETO, a, 0, 0, rate);
}

Action* ActTintTo(Entity* ent, float a, float b, float c, float rate){
	return Action::AddAction(ent, ACT_TINTTO, a, b, c, rate);
}

Action* ActTrackByPoint(Entity* ent, Entity* target, float a, float b, float c, float rate){
	return Action::AddAction(ent, ACT_TRACK_BY_POINT, target, a, b, c, rate);
}

Action* ActTrackByDistance(Entity* ent, Entity* target, float a, float rate){
	return Action::AddAction(ent, ACT_TRACK_BY_DISTANCE, target, a, 0, 0, rate);
}

Action* ActNewtonian(Entity* ent, float rate){
	return Action::AddAction(ent, ACT_NEWTONIAN, ent->mat.grid[3][0], ent->mat.grid[3][1], -ent->mat.grid[3][2], rate);
}

void AppendAction(Action* act1, Action* act2){
	act1->AppendAction(act2);
}

void FreeAction(Action* act){
	act->FreeAction();
}

void DepthBufferToTex( Texture* tex, Camera* cam=0 ){
	tex->DepthBufferToTex(cam);
}

/*void SetParameter1S(Shader* material, char* name, float v1){
	material->SetParameter1S(name, v1);
}

void SetParameter2S(Shader* material, char* name, float v1, float v2){
	material->SetParameter2S(name, v1, v2);
}

void SetParameter3S(Shader* material, char* name, float v1, float v2, float v3){
	material->SetParameter3S(name, v1, v2, v3);
}

void SetParameter4S(Shader* material, char* name, float v1, float v2, float v3, float v4){
	material->SetParameter4S(name, v1, v2, v3, v4);
}

void SetParameter1I(Shader* material, char* name, int v1){
	material->SetParameter1I(name, v1);
}

void SetParameter2I(Shader* material, char* name, int v1, int v2){
	material->SetParameter2I(name, v1, v2);
}

void SetParameter3I(Shader* material, char* name, int v1, int v2, int v3){
	material->SetParameter3I(name, v1, v2, v3);
}

void SetParameter4I(Shader* material, char* name, int v1, int v2, int v3, int v4){
	material->SetParameter4I(name, v1, v2, v3, v4);
}

void SetVector1I(Shader* material, char* name, int* v1){
	material->SetVector1I(name, v1);
}

void SetVector2I(Shader* material, char* name, int* v1){
	material->SetVector2I(name, v1);
}

void SetVector3I(Shader* material, char* name, int* v1){
	material->SetVector3I(name, v1);
}

void SetVector4I(Shader* material, char* name, int* v1){
	material->SetVector4I(name, v1);
}

void SetParameter1F(Shader* material, char* name, float v1){
	material->TurnOn();
	material->SetParameter1F(name, v1);
	material->TurnOff();
}

void SetParameter2F(Shader* material, char* name, float v1, float v2){
	material->SetParameter2F(name, v1, v2);
}

void SetParameter3F(Shader* material, char* name, float v1, float v2, float v3){
	material->SetParameter3F(name, v1, v2, v3);
}

void SetParameter4F(Shader* material, char* name, float v1, float v2, float v3, float v4){
	material->SetParameter4F(name, v1, v2, v3, v4);
}

void SetVector1F(Shader* material, char* name, float* v1){
	material->SetVector1F(name, v1);
}

void SetVector2F(Shader* material, char* name, float* v1){
	material->SetVector2F(name, v1);
}

void SetVector3F(Shader* material, char* name, float* v1){
	material->SetVector3F(name, v1);
}

void SetVector4F(Shader* material, char* name, float* v1){
	material->SetVector4F(name, v1);
}

void SetMatrix2F(Shader* material, char* name, float* m){
	material->SetMatrix2F(name, m);
}

void SetMatrix3F(Shader* material, char* name, float* m){
	material->SetMatrix3F(name, m);
}

void SetMatrix4F(Shader* material, char* name, float* m){
	material->SetMatrix4F(name, m);
}

void SetParameter1D(Shader* material, char* name, double v1){
	material->SetParameter1S(name, v1);
}

void SetParameter2D(Shader* material, char* name, double v1, double v2){
	material->SetParameter2S(name, v1, v2);
}

void SetParameter3D(Shader* material, char* name, double v1, double v2, double v3){
	material->SetParameter3S(name, v1, v2, v3);
}

void SetParameter4D(Shader* material, char* name, double v1, double v2, double v3, double v4){
	material->SetParameter4S(name, v1, v2, v3, v4);
}
*/





//' ***todo***

/*
Function LightMesh(mesh:TMesh,red#,green#,blue#,range#=0,light_x#=0,light_y#=0,light_z#=0)
End Function
Function SetAnimKey(ent:TEntity,frame,pos_key=True,rot_key=True,scale_key=True)
End Function
*/

} /* extern "C" */

