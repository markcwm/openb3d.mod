#ifndef __functions_h__
#define __functions_h__


#ifdef WIN32
 #ifdef BUILD_DLL
  #define DLL_EXPORT __declspec(dllexport)
 #else
  #define DLL_EXPORT __declspec(dllimport)
 #endif
#else
 #define DLL_EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

// extra
void DLL_EXPORT FreeShader(Shader *shader);
void DLL_EXPORT FreeStencil(Stencil *stencil);
void DLL_EXPORT TextureFlags(Texture* tex, int flags);
void DLL_EXPORT FreeSurface(Surface* surf);
void DLL_EXPORT TextureGLTexEnv(Texture* tex, int target, int pname, int param);
void DLL_EXPORT BrushGLColor(Brush* brush, float r, float g, float b, float a);
void DLL_EXPORT BrushGLBlendFunc(Brush* brush, int sfactor, int dfactor);

// rendering
void DLL_EXPORT BufferToTex(Texture* tex,unsigned char* buffer, int frame);
void DLL_EXPORT BackBufferToTex(Texture* tex,int frame);
void DLL_EXPORT CameraToTex(Texture* tex, Camera* cam, int frame);
void DLL_EXPORT TexToBuffer(Texture* tex,unsigned char* buffer, int frame);


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
void DLL_EXPORT MeshCullRadius(Entity* ent, float radius);
// Blitz3D functions, A-Z

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddAnimSeq">Online Help</a>
*/
int DLL_EXPORT AddAnimSeq(Entity* ent,int length);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddMesh">Online Help</a>
*/
void DLL_EXPORT AddMesh(Mesh* mesh1,Mesh* mesh2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddTriangle">Online Help</a>
*/
int DLL_EXPORT AddTriangle(Surface* surf,int v0,int v1,int v2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddVertex">Online Help</a>
*/
int DLL_EXPORT AddVertex(Surface* surf,float x, float y,float z,float u, float v,float w);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AmbientLight">Online Help</a>
*/
void DLL_EXPORT AmbientLight(float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AntiAlias">Online Help</a>
*/
void DLL_EXPORT AntiAlias(int samples);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animate">Online Help</a>
*/
void DLL_EXPORT Animate(Entity* ent,int mode,float speed,int seq,int trans);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animating">Online Help</a>
*/
int DLL_EXPORT Animating(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimLength">Online Help</a>
*/
int DLL_EXPORT AnimLength(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimSeq">Online Help</a>
*/
int DLL_EXPORT AnimSeq(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimTime">Online Help</a>
*/
float DLL_EXPORT AnimTime(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushAlpha">Online Help</a>
*/
void DLL_EXPORT BrushAlpha(Brush* brush, float a);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushBlend">Online Help</a>
*/
void DLL_EXPORT BrushBlend(Brush* brush,int blend);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushColor">Online Help</a>
*/
void DLL_EXPORT BrushColor(Brush* brush,float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushFX">Online Help</a>
*/
void DLL_EXPORT BrushFX(Brush* brush,int fx);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushShininess">Online Help</a>
*/
void DLL_EXPORT BrushShininess(Brush* brush,float s);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushTexture">Online Help</a>
*/
void DLL_EXPORT BrushTexture(Brush* brush,Texture* tex,int frame,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsColor">Online Help</a>
*/
void DLL_EXPORT CameraClsColor(Camera* cam, float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsMode">Online Help</a>
*/
void DLL_EXPORT CameraClsMode(Camera* cam,int cls_depth,int cls_zbuffer);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogColor">Online Help</a>
*/
void DLL_EXPORT CameraFogColor(Camera* cam,float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogMode">Online Help</a>
*/
void DLL_EXPORT CameraFogMode(Camera* cam,int mode);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogRange">Online Help</a>
*/
void DLL_EXPORT CameraFogRange(Camera* cam,float nnear,float nfar);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraPick">Online Help</a>
*/
Entity* DLL_EXPORT CameraPick(Camera* cam,float x,float y);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProject">Online Help</a>
*/
void DLL_EXPORT CameraProject(Camera* cam,float x,float y,float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProjMode">Online Help</a>
*/
void DLL_EXPORT CameraProjMode(Camera* cam,int mode);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraRange">Online Help</a>
*/
void DLL_EXPORT CameraRange(Camera* cam,float nnear,float nfar);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraViewport">Online Help</a>
*/
void DLL_EXPORT CameraViewport(Camera* cam,int x,int y,int width,int height);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraZoom">Online Help</a>
*/
void DLL_EXPORT CameraZoom(Camera* cam,float zoom);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearCollisions">Online Help</a>
int ClearCollisions(){
	Global::ClearCollisions();
}
*/
/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearSurface">Online Help</a>
*/
void DLL_EXPORT ClearSurface(Surface* surf,int clear_verts,int clear_tris);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearTextureFilters">Online Help</a>
*/
void DLL_EXPORT ClearTextureFilters();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearWorld">Online Help</a>
*/
void DLL_EXPORT ClearWorld(int entities,int brushes,int textures);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionEntity">Online Help</a>
*/
Entity* DLL_EXPORT CollisionEntity(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Collisions">Online Help</a>
*/
void DLL_EXPORT Collisions(int src_no,int dest_no,int method_no,int response_no);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNX">Online Help</a>
*/
float DLL_EXPORT CollisionNX(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNY">Online Help</a>
*/
float DLL_EXPORT CollisionNY(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNZ">Online Help</a>
*/
float DLL_EXPORT CollisionNZ(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionSurface">Online Help</a>
*/
Surface* DLL_EXPORT CollisionSurface(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTime">Online Help</a>
*/
float DLL_EXPORT CollisionTime(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTriangle">Online Help</a>
*/
int DLL_EXPORT CollisionTriangle(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionX">Online Help</a>
*/
float DLL_EXPORT CollisionX(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionY">Online Help</a>
*/
float DLL_EXPORT CollisionY(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionZ">Online Help</a>
*/
float DLL_EXPORT CollisionZ(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountChildren">Online Help</a>
*/
int DLL_EXPORT CountChildren(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountCollisions">Online Help</a>
*/
int DLL_EXPORT CountCollisions(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyEntity">Online Help</a>
*/
Entity* DLL_EXPORT CopyEntity(Entity* ent,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyMesh">Online Help</a>
*/
Mesh* DLL_EXPORT CopyMesh(Mesh* mesh,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountSurfaces">Online Help</a>
*/
int DLL_EXPORT CountSurfaces(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountTriangles">Online Help</a>
*/
int DLL_EXPORT CountTriangles(Surface* surf);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountVertices">Online Help</a>
*/
int DLL_EXPORT CountVertices(Surface* surf);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateBrush">Online Help</a>
*/
Brush* DLL_EXPORT CreateBrush(float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCamera">Online Help</a>
*/
Camera* DLL_EXPORT CreateCamera(Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCone">Online Help</a>
*/
Mesh* DLL_EXPORT CreateCone(int segments,int solid,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCylinder">Online Help</a>
*/
Mesh* DLL_EXPORT CreateCylinder(int segments,int solid,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCube">Online Help</a>
*/
Mesh* DLL_EXPORT CreateCube(Entity* parent);

Terrain* DLL_EXPORT CreateGeosphere(int size, Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateMesh">Online Help</a>
*/
Mesh* DLL_EXPORT CreateMesh(Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateLight">Online Help</a>
*/
Light* DLL_EXPORT CreateLight(int light_type,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreatePivot">Online Help</a>
*/
Pivot* DLL_EXPORT CreatePivot(Entity* parent);

Mesh* DLL_EXPORT CreatePlane(int divisions,Entity* parent);

Mesh* DLL_EXPORT CreateQuad(Entity* parent);

ShadowObject* DLL_EXPORT CreateShadow(Mesh* parent, char Static);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSphere">Online Help</a>
*/
Mesh* DLL_EXPORT CreateSphere(int segments,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSprite">Online Help</a>
*/
Sprite* DLL_EXPORT CreateSprite(Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSurface">Online Help</a>
*/
Surface* DLL_EXPORT CreateSurface(Mesh* mesh,Brush* brush);

/*
*/
Stencil* DLL_EXPORT CreateStencil();

/*
*/
Terrain* DLL_EXPORT CreateTerrain(int size, Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateTexture">Online Help</a>
*/
Texture* DLL_EXPORT CreateTexture(int width,int height,int flags,int frames);

/*
*/
VoxelSprite* DLL_EXPORT CreateVoxelSprite(int slices, Entity* parent);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaPitch">Online Help</a>
*/
float DLL_EXPORT DeltaPitch(Entity* ent1,Entity* ent2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaYaw">Online Help</a>
*/
float DLL_EXPORT DeltaYaw(Entity* ent1,Entity* ent2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAlpha">Online Help</a>
*/
void DLL_EXPORT EntityAlpha(Entity* ent,float alpha);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAutoFade">Online Help</a>
*/
void DLL_EXPORT EntityAutoFade(Entity* ent,float near,float far);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBlend">Online Help</a>
*/
void DLL_EXPORT EntityBlend(Entity* ent, int blend);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBox">Online Help</a>
*/
void DLL_EXPORT EntityBox(Entity* ent,float x,float y,float z,float w,float h,float d);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityClass">Online Help</a>
*/
const char* DLL_EXPORT EntityClass(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityCollided">Online Help</a>
*/
Entity* DLL_EXPORT EntityCollided(Entity* ent,int type_no);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityColor">Online Help</a>
*/
void DLL_EXPORT EntityColor(Entity* ent,float red,float green,float blue);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityDistance">Online Help</a>
*/
float DLL_EXPORT EntityDistance(Entity* ent1,Entity* ent2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityFX">Online Help</a>
*/
void DLL_EXPORT EntityFX(Entity* ent,int fx);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityInView">Online Help</a>
*/
int DLL_EXPORT EntityInView(Entity* ent,Camera* cam);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityName">Online Help</a>
*/
const char* DLL_EXPORT EntityName(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityOrder">Online Help</a>
*/
void DLL_EXPORT EntityOrder(Entity* ent,int order);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityParent">Online Help</a>
*/
void DLL_EXPORT EntityParent(Entity* ent,Entity* parent_ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPick">Online Help</a>
*/
Entity* DLL_EXPORT EntityPick(Entity* ent,float range);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPickMode">Online Help</a>
*/
void DLL_EXPORT EntityPickMode(Entity* ent,int pick_mode,int obscurer);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPitch">Online Help</a>
*/
float DLL_EXPORT EntityPitch(Entity* ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRadius">Online Help</a>
*/
void DLL_EXPORT EntityRadius(Entity* ent,float radius_x,float radius_y);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRoll">Online Help</a>
*/
float DLL_EXPORT EntityRoll(Entity* ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityShininess">Online Help</a>
*/
void DLL_EXPORT EntityShininess(Entity* ent,float shine);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityTexture">Online Help</a>
*/
void DLL_EXPORT EntityTexture(Entity* ent,Texture* tex,int frame,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityType">Online Help</a>
*/
void DLL_EXPORT EntityType(Entity* ent,int type_no,int recursive);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityVisible">Online Help</a>
*/
int DLL_EXPORT EntityVisible(Entity* src_ent,Entity* dest_ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityX">Online Help</a>
*/
float DLL_EXPORT EntityX(Entity* ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityY">Online Help</a>
*/
float DLL_EXPORT EntityY(Entity* ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityYaw">Online Help</a>
*/
float DLL_EXPORT EntityYaw(Entity* ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityZ">Online Help</a>
*/
float DLL_EXPORT EntityZ(Entity* ent,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ExtractAnimSeq">Online Help</a>
*/
int DLL_EXPORT ExtractAnimSeq(Entity* ent,int first_frame,int last_frame,int seq);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindChild">Online Help</a>
*/
Entity* DLL_EXPORT FindChild(Entity* ent,char* child_name);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindSurface">Online Help</a>
*/
Surface* DLL_EXPORT FindSurface(Mesh* mesh,Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FitMesh">Online Help</a><p>
*/
void DLL_EXPORT FitMesh(Mesh* mesh,float x,float y,float z,float width,float height,float depth,int uniform);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FlipMesh">Online Help</a>
*/
void DLL_EXPORT FlipMesh(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeBrush">Online Help</a>
*/
void DLL_EXPORT FreeBrush(Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeEntity">Online Help</a>
*/
void DLL_EXPORT FreeEntity(Entity* ent);

void DLL_EXPORT FreeShadow(ShadowObject* shad);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeTexture">Online Help</a>
*/
void DLL_EXPORT FreeTexture(Texture* tex);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetBrushTexture">Online Help</a>
*/
Texture* DLL_EXPORT GetBrushTexture(Brush* brush,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetChild">Online Help</a>
*/
Entity* DLL_EXPORT GetChild(Entity* ent,int child_no);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityBrush">Online Help</a>
*/
Brush* DLL_EXPORT GetEntityBrush(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityType">Online Help</a>
*/
int DLL_EXPORT GetEntityType(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ResetEntity">Online Help</a>
*/
float DLL_EXPORT GetMatElement(Entity* ent,int row,int col);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetParent">Online Help</a>
*/
Entity* DLL_EXPORT GetParentEntity(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurface">Online Help</a>
*/
Surface* DLL_EXPORT GetSurface(Mesh* mesh,int surf_no);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurfaceBrush">Online Help</a>
*/
Brush* DLL_EXPORT GetSurfaceBrush(Surface* surf);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Graphics3D">Online Help</a>
*/
void DLL_EXPORT Graphics3D(int width,int height,int depth,int mode,int rate);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HandleSprite">Online Help</a>
*/
void DLL_EXPORT HandleSprite(Sprite* sprite,float h_x,float h_y);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HideEntity">Online Help</a>
*/
void DLL_EXPORT HideEntity(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightColor">Online Help</a>
*/
void DLL_EXPORT LightColor(Light* light,float red,float green,float blue);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightConeAngles">Online Help</a>
*/
void DLL_EXPORT LightConeAngles(Light* light,float inner_ang,float outer_ang);

/*

bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightRange">Online Help</a>
*/
void DLL_EXPORT LightRange(Light* light,float range);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LinePick">Online Help</a>
*/
Entity* DLL_EXPORT LinePick(float x,float y,float z,float dx,float dy,float dz,float radius);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimMesh">Online Help</a>
*/
Mesh* DLL_EXPORT LoadAnimMesh(char* file,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimTexture">Online Help</a>
*/
Texture* DLL_EXPORT LoadAnimTexture(char* file,int flags,int frame_width,int frame_height,int first_frame,int frame_count);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadBrush">Online Help</a>
*/
Brush* DLL_EXPORT LoadBrush(char *file,int flags,float u_scale,float v_scale);

Terrain* DLL_EXPORT LoadGeosphere(char* file,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadMesh">Online Help</a>
*/
Mesh* DLL_EXPORT LoadMesh(char* file,Entity* parent);


Terrain* DLL_EXPORT LoadTerrain(char* file,Entity* parent);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadTexture">Online Help</a>
*/
Texture* DLL_EXPORT LoadTexture(char* file,int flags);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadSprite">Online Help</a>
*/
Sprite* DLL_EXPORT LoadSprite(char* tex_file,int tex_flag,Entity* parent);

/*
*/
Mesh* DLL_EXPORT MeshCSG(Mesh* m1, Mesh* m2, int method);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshDepth">Online Help</a>
*/
float DLL_EXPORT MeshDepth(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshesIntersect">Online Help</a>
*/
int DLL_EXPORT MeshesIntersect(Mesh* mesh1,Mesh* mesh2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshHeight">Online Help</a>
*/
float DLL_EXPORT MeshHeight(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshWidth">Online Help</a>
*/
float DLL_EXPORT MeshWidth(Mesh* mesh);

void DLL_EXPORT ModifyGeosphere(Geosphere* geo, int x, int z, float new_height);

void DLL_EXPORT ModifyTerrain(Terrain* terr, int x, int z, float new_height);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MoveEntity">Online Help</a>
*/
void DLL_EXPORT MoveEntity(Entity* ent,float x,float y,float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=NameEntity">Online Help</a>
*/
void DLL_EXPORT NameEntity(Entity* ent,char* name);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintEntity">Online Help</a>
*/
void DLL_EXPORT PaintEntity(Entity* ent,Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintMesh">Online Help</a>
*/
void DLL_EXPORT PaintMesh(Mesh* mesh,Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintSurface">Online Help</a>
*/
void DLL_EXPORT PaintSurface(Surface* surf,Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedEntity">Online Help</a>
*/
Entity* DLL_EXPORT PickedEntity();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNX">Online Help</a>
*/
float DLL_EXPORT PickedNX();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNY">Online Help</a>
*/
float DLL_EXPORT PickedNY();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNZ">Online Help</a>
*/
float DLL_EXPORT PickedNZ();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedSurface">Online Help</a>
*/
Surface* DLL_EXPORT PickedSurface();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTime">Online Help</a>
*/
float DLL_EXPORT PickedTime();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTriangle">Online Help</a>
*/
int DLL_EXPORT PickedTriangle();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedX">Online Help</a>
*/
float DLL_EXPORT PickedX();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedY">Online Help</a>
*/
float DLL_EXPORT PickedY();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedZ">Online Help</a>
*/
float DLL_EXPORT PickedZ();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PointEntity">Online Help</a>
*/
void DLL_EXPORT PointEntity(Entity* ent,Entity* target_ent,float roll);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionEntity">Online Help</a>
*/
void DLL_EXPORT PositionEntity(Entity* ent,float x,float y,float z,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionMesh">Online Help</a>
*/
void DLL_EXPORT PositionMesh(Mesh* mesh,float px,float py,float pz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionTexture">Online Help</a>
*/
void DLL_EXPORT PositionTexture(Texture* tex,float u_pos,float v_pos);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedX">Online Help</a>
*/
float DLL_EXPORT ProjectedX();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedY">Online Help</a>
*/
float DLL_EXPORT ProjectedY();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedZ">Online Help</a>
*/
float DLL_EXPORT ProjectedZ();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RenderWorld">Online Help</a>
*/
void DLL_EXPORT RenderWorld();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RepeatMesh">Online Help</a>
*/
Mesh* DLL_EXPORT RepeatMesh(Mesh* mesh,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ResetEntity">Online Help</a>
*/
void DLL_EXPORT ResetEntity(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateEntity">Online Help</a>
*/
void DLL_EXPORT RotateEntity(Entity* ent,float x,float y,float z,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateMesh">Online Help</a>
*/
void DLL_EXPORT RotateMesh(Mesh* mesh,float pitch,float yaw,float roll);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateSprite">Online Help</a>
*/
void DLL_EXPORT RotateSprite(Sprite* sprite,float ang);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateTexture">Online Help</a>
*/
void DLL_EXPORT RotateTexture(Texture* tex,float ang);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleEntity">Online Help</a>
*/
void DLL_EXPORT ScaleEntity(Entity* ent,float x,float y,float z,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleMesh">Online Help</a>
*/
void DLL_EXPORT ScaleMesh(Mesh* mesh,float sx,float sy,float sz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleSprite">Online Help</a>
*/
void DLL_EXPORT ScaleSprite(Sprite* sprite,float s_x,float s_y);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleTexture">Online Help</a>
*/
void DLL_EXPORT ScaleTexture(Texture* tex,float u_scale,float v_scale);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetAnimTime">Online Help</a>
*/
void DLL_EXPORT SetAnimTime(Entity* ent,float time,int seq);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeFace">Online Help</a>
*/
void DLL_EXPORT SetCubeFace(Texture* tex,int face);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeMode">Online Help</a>
*/
void DLL_EXPORT SetCubeMode(Texture* tex,int mode);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ShowEntity">Online Help</a>
*/
void DLL_EXPORT ShowEntity(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SpriteViewMode">Online Help</a>
*/
void DLL_EXPORT SpriteViewMode(Sprite* sprite,int mode);

/*
*/
void DLL_EXPORT StencilAlpha(Stencil* stencil, float a);

/*
*/
void DLL_EXPORT StencilClsColor(Stencil* stencil, float r,float g,float b);

/*
*/
void DLL_EXPORT StencilClsMode(Stencil* stencil,int cls_depth,int cls_zbuffer);

/*
*/
void DLL_EXPORT StencilMesh(Stencil* stencil, Mesh* mesh, int mode);

/*
*/
void DLL_EXPORT StencilMode(Stencil* stencil, int m, int o);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainHeight">Online Help</a>
*/
float DLL_EXPORT TerrainHeight (Terrain* terr, int x, int z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainX">Online Help</a>
*/
float DLL_EXPORT TerrainX(Terrain* terr, float x, float y, float z);

/*

bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainY">Online Help</a>
*/
float DLL_EXPORT TerrainY(Terrain* terr, float x, float y, float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainZ">Online Help</a>
*/
float DLL_EXPORT TerrainZ(Terrain* terr, float x, float y, float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureBlend">Online Help</a>
*/
void DLL_EXPORT TextureBlend(Texture* tex,int blend);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureCoords">Online Help</a>
*/
void DLL_EXPORT TextureCoords(Texture* tex,int coords);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureHeight">Online Help</a>
*/
int DLL_EXPORT TextureHeight(Texture* tex);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureFilter">Online Help</a>
*/
void DLL_EXPORT TextureFilter(char* match_text,int flags);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureName">Online Help</a>
*/
const char* DLL_EXPORT TextureName(Texture* tex);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureWidth">Online Help</a>
*/
int DLL_EXPORT TextureWidth(Texture* tex);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedX">Online Help</a>
*/
float DLL_EXPORT TFormedX();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedY">Online Help</a>
*/
float DLL_EXPORT TFormedY();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedZ">Online Help</a>
*/
float DLL_EXPORT TFormedZ();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormNormal">Online Help</a>
*/
void DLL_EXPORT TFormNormal(float x,float y,float z,Entity* src_ent,Entity* dest_ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormPoint">Online Help</a>
*/
void DLL_EXPORT TFormPoint(float x,float y,float z,Entity* src_ent,Entity* dest_ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormVector">Online Help</a>
*/
void DLL_EXPORT TFormVector(float x,float y,float z,Entity* src_ent,Entity* dest_ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TranslateEntity">Online Help</a>
*/
void DLL_EXPORT TranslateEntity(Entity* ent,float x,float y,float z,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TriangleVertex">Online Help</a>
*/
int DLL_EXPORT TriangleVertex(Surface* surf,int tri_no,int corner);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TurnEntity">Online Help</a>
*/
void DLL_EXPORT TurnEntity(Entity* ent,float x,float y,float z,int glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateNormals">Online Help</a>
*/
void DLL_EXPORT UpdateNormals(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateNormals">Online Help</a>
*/
void DLL_EXPORT UpdateTexCoords(Surface* surf);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateWorld">Online Help</a>
*/
void DLL_EXPORT UpdateWorld(float anim_speed);

/*
*/
void DLL_EXPORT UseStencil(Stencil* stencil);
/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorPitch">Online Help</a>
*/
float DLL_EXPORT VectorPitch(float vx,float vy,float vz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorYaw">Online Help</a>
*/
float DLL_EXPORT VectorYaw(float vx,float vy,float vz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexAlpha">Online Help</a>
*/
float DLL_EXPORT VertexAlpha(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexBlue">Online Help</a>
*/
float DLL_EXPORT VertexBlue(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexColor">Online Help</a>
*/
void DLL_EXPORT VertexColor(Surface* surf,int vid,float r,float g,float b,float a);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexCoords">Online Help</a>
*/
void DLL_EXPORT VertexCoords(Surface* surf,int vid,float x,float y,float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexGreen">Online Help</a>
*/
float DLL_EXPORT VertexGreen(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNormal">Online Help</a>
*/
void DLL_EXPORT VertexNormal(Surface* surf,int vid,float nx,float ny,float nz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNX">Online Help</a>
*/
float DLL_EXPORT VertexNX(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNY">Online Help</a>
*/
float DLL_EXPORT VertexNY(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNZ">Online Help</a>
*/
float DLL_EXPORT VertexNZ(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexRed">Online Help</a>
*/
float DLL_EXPORT VertexRed(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexTexCoords">Online Help</a>
*/
void DLL_EXPORT VertexTexCoords(Surface* surf,int vid,float u,float v,float w,int coord_set);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexU">Online Help</a>
*/
float DLL_EXPORT VertexU(Surface* surf,int vid,int coord_set);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexV">Online Help</a>
*/
float DLL_EXPORT VertexV(Surface* surf,int vid,int coord_set);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexW">Online Help</a>
*/
float DLL_EXPORT VertexW(Surface* surf,int vid,int coord_set);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexX">Online Help</a>
*/
float DLL_EXPORT VertexX(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexY">Online Help</a>
*/
float DLL_EXPORT VertexY(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexZ">Online Help</a>
*/
float DLL_EXPORT VertexZ(Surface* surf,int vid);

/*
*/
void DLL_EXPORT VoxelSpriteMaterial(VoxelSprite* voxelspr, Material* mat);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Wireframe">Online Help</a>
*/
void DLL_EXPORT Wireframe(int enable);


float DLL_EXPORT EntityScaleX(Entity* ent,int glob);

float DLL_EXPORT EntityScaleY(Entity* ent,int glob);

float DLL_EXPORT EntityScaleZ(Entity* ent,int glob);

Shader* DLL_EXPORT LoadShader(char* ShaderName, char* VshaderFileName, char* FshaderFileName);

Shader* DLL_EXPORT CreateShader(char* ShaderName, char* VshaderString, char* FshaderString);

void DLL_EXPORT ShadeSurface(Surface* surf, Shader* material);

void DLL_EXPORT ShadeMesh(Mesh* mesh, Shader* material);

void DLL_EXPORT ShadeEntity(Entity* ent, Shader* material);

Texture* DLL_EXPORT ShaderTexture(Shader* material, Texture* tex, char* name, int index);

void DLL_EXPORT SetFloat(Shader* material, char* name, float v1);

void DLL_EXPORT SetFloat2(Shader* material, char* name, float v1, float v2);

void DLL_EXPORT SetFloat3(Shader* material, char* name, float v1, float v2, float v3);

void DLL_EXPORT SetFloat4(Shader* material, char* name, float v1, float v2, float v3, float v4);

void DLL_EXPORT UseFloat(Shader* material, char* name, float* v1);

void DLL_EXPORT UseFloat2(Shader* material, char* name, float* v1, float* v2);

void DLL_EXPORT UseFloat3(Shader* material, char* name, float* v1, float* v2, float* v3);

void DLL_EXPORT UseFloat4(Shader* material, char* name, float* v1, float* v2, float* v3, float* v4);

void DLL_EXPORT SetInteger(Shader* material, char* name, int v1);

void DLL_EXPORT SetInteger2(Shader* material, char* name, int v1, int v2);

void DLL_EXPORT SetInteger3(Shader* material, char* name, int v1, int v2, int v3);

void DLL_EXPORT SetInteger4(Shader* material, char* name, int v1, int v2, int v3, int v4);

void DLL_EXPORT UseInteger(Shader* material, char* name, int* v1);

void DLL_EXPORT UseInteger2(Shader* material, char* name, int* v1, int* v2);

void DLL_EXPORT UseInteger3(Shader* material, char* name, int* v1, int* v2, int* v3);

void DLL_EXPORT UseInteger4(Shader* material, char* name, int* v1, int* v2, int* v3, int* v4);

void DLL_EXPORT UseSurface(Shader* material, char* name, Surface* surf, int vbo);

void DLL_EXPORT UseMatrix(Shader* material, char* name, int mode);

Material* DLL_EXPORT LoadMaterial(char* filename,int flags, int frame_width,int frame_height,int first_frame,int frame_count);

void DLL_EXPORT ShaderMaterial(Shader* material, Material* tex, char* name, int index);

OcTree* DLL_EXPORT CreateOcTree(float w, float h, float d, Entity* parent_ent);

void DLL_EXPORT AddToOctree(OcTree* octree, Mesh* mesh, int level, float X, float Y, float Z, float Near, float Far);

#ifdef __cplusplus
} // extern "C"
#endif

#endif
