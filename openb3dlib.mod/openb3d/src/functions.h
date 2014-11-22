#ifndef __functions_h__
#define __functions_h__

// functions
extern "C" {

void BufferToTex(Texture* tex,unsigned char* buffer, int frame);
void BackBufferToTex(Texture* tex,int frame);
void DepthBufferToTex(Texture* tex,int frame);
void CameraToTex(Texture* tex, Camera* cam, int frame);
void TexToBuffer(Texture* tex,unsigned char* buffer, int frame);


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
void MeshCullRadius(Entity* ent, float radius);
// Blitz3D functions, A-Z

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddAnimSeq">Online Help</a>
*/
int AddAnimSeq(Entity* ent,int length);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddMesh">Online Help</a>
*/
void AddMesh(Mesh* mesh1,Mesh* mesh2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddTriangle">Online Help</a>
*/
int AddTriangle(Surface* surf,int v0,int v1,int v2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AddVertex">Online Help</a>
*/
int AddVertex(Surface* surf,float x, float y,float z,float u, float v,float w);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AmbientLight">Online Help</a>
*/
void AmbientLight(float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AntiAlias">Online Help</a>
*/
void AntiAlias(int samples);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animate">Online Help</a>
*/
void Animate(Entity* ent,int mode,float speed,int seq,int trans);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Animating">Online Help</a>
*/
int Animating(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimLength">Online Help</a>
*/
int AnimLength(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimSeq">Online Help</a>
*/
int AnimSeq(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=AnimTime">Online Help</a>
*/
float AnimTime(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushAlpha">Online Help</a>
*/
void BrushAlpha(Brush* brush, float a);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushBlend">Online Help</a>
*/
void BrushBlend(Brush* brush,int blend);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushColor">Online Help</a>
*/
void BrushColor(Brush* brush,float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushFX">Online Help</a>
*/
void BrushFX(Brush* brush,int fx);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushShininess">Online Help</a>
*/
void BrushShininess(Brush* brush,float s);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=BrushTexture">Online Help</a>
*/
void BrushTexture(Brush* brush,Texture* tex,int frame,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsColor">Online Help</a>
*/
void CameraClsColor(Camera* cam, float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraClsMode">Online Help</a>
*/
void CameraClsMode(Camera* cam,int cls_depth,int cls_zbuffer);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogColor">Online Help</a>
*/
void CameraFogColor(Camera* cam,float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogMode">Online Help</a>
*/
void CameraFogMode(Camera* cam,int mode);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraFogRange">Online Help</a>
*/
void CameraFogRange(Camera* cam,float nnear,float nfar);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraPick">Online Help</a>
*/
Entity* CameraPick(Camera* cam,float x,float y);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProject">Online Help</a>
*/
void CameraProject(Camera* cam,float x,float y,float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraProjMode">Online Help</a>
*/
void  CameraProjMode(Camera* cam,int mode);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraRange">Online Help</a>
*/
void  CameraRange(Camera* cam,float nnear,float nfar);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraViewport">Online Help</a>
*/
void  CameraViewport(Camera* cam,int x,int y,int width,int height);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CameraZoom">Online Help</a>
*/
void  CameraZoom(Camera* cam,float zoom);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearCollisions">Online Help</a>
int ClearCollisions(){
	Global::ClearCollisions();
}
*/
/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearSurface">Online Help</a>
*/
void ClearSurface(Surface* surf,bool clear_verts,bool clear_tris);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearTextureFilters">Online Help</a>
*/
void ClearTextureFilters();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ClearWorld">Online Help</a>
*/
void ClearWorld(bool entities,bool brushes,bool textures);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionEntity">Online Help</a>
*/
Entity* CollisionEntity(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Collisions">Online Help</a>
*/
void Collisions(int src_no,int dest_no,int method_no,int response_no);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNX">Online Help</a>
*/
float CollisionNX(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNY">Online Help</a>
*/
float CollisionNY(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionNZ">Online Help</a>
*/
float CollisionNZ(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionSurface">Online Help</a>
*/
Surface* CollisionSurface(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTime">Online Help</a>
*/
float CollisionTime(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionTriangle">Online Help</a>
*/
int CollisionTriangle(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionX">Online Help</a>
*/
float CollisionX(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionY">Online Help</a>
*/
float CollisionY(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CollisionZ">Online Help</a>
*/
float CollisionZ(Entity* ent,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountChildren">Online Help</a>
*/
int CountChildren(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountCollisions">Online Help</a>
*/
int CountCollisions(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyEntity">Online Help</a>
*/
Entity* CopyEntity(Entity* ent,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CopyMesh">Online Help</a>
*/
Mesh* CopyMesh(Mesh* mesh,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountSurfaces">Online Help</a>
*/
int CountSurfaces(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountTriangles">Online Help</a>
*/
int CountTriangles(Surface* surf);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CountVertices">Online Help</a>
*/
int CountVertices(Surface* surf);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateBrush">Online Help</a>
*/
Brush* CreateBrush(float r,float g,float b);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCamera">Online Help</a>
*/
Camera* CreateCamera(Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCone">Online Help</a>
*/
Mesh* CreateCone(int segments,bool solid,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCylinder">Online Help</a>
*/
Mesh* CreateCylinder(int segments,bool solid,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateCube">Online Help</a>
*/
Mesh* CreateCube(Entity* parent);

Terrain* CreateGeosphere(int size, Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateMesh">Online Help</a>
*/
Mesh* CreateMesh(Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateLight">Online Help</a>
*/
Light* CreateLight(int light_type,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreatePivot">Online Help</a>
*/
Pivot* CreatePivot(Entity* parent);

Mesh* CreatePlane(int divisions,Entity* parent);

Mesh* CreateQuad(Entity* parent);

ShadowObject* CreateShadow(Mesh* parent, char Static);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSphere">Online Help</a>
*/
Mesh* CreateSphere(int segments,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSprite">Online Help</a>
*/
Sprite* CreateSprite(Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateSurface">Online Help</a>
*/
Surface* CreateSurface(Mesh* mesh,Brush* brush);

/*
*/
Stencil* CreateStencil();

/*
*/
Terrain* CreateTerrain(int size, Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=CreateTexture">Online Help</a>
*/
Texture* CreateTexture(int width,int height,int flags,int frames);

/*
*/
VoxelSprite* CreateVoxelSprite(int slices, Entity* parent);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaPitch">Online Help</a>
*/
float DeltaPitch(Entity* ent1,Entity* ent2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=DeltaYaw">Online Help</a>
*/
float DeltaYaw(Entity* ent1,Entity* ent2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAlpha">Online Help</a>
*/
void EntityAlpha(Entity* ent,float alpha);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityAutoFade">Online Help</a>
*/
void EntityAutoFade(Entity* ent,float near,float far);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBlend">Online Help</a>
*/
void EntityBlend(Entity* ent, int blend);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityBox">Online Help</a>
*/
void EntityBox(Entity* ent,float x,float y,float z,float w,float h,float d);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityClass">Online Help</a>
*/
const char* EntityClass(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityCollided">Online Help</a>
*/
Entity* EntityCollided(Entity* ent,int type_no);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityColor">Online Help</a>
*/
void EntityColor(Entity* ent,float red,float green,float blue);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityDistance">Online Help</a>
*/
float EntityDistance(Entity* ent1,Entity* ent2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityFX">Online Help</a>
*/
void EntityFX(Entity* ent,int fx);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityInView">Online Help</a>
*/
int EntityInView(Entity* ent,Camera* cam);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityName">Online Help</a>
*/
const char* EntityName(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityOrder">Online Help</a>
*/
void EntityOrder(Entity* ent,int order);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityParent">Online Help</a>




*/
void EntityParent(Entity* ent,Entity* parent_ent,bool glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPick">Online Help</a>
*/
Entity* EntityPick(Entity* ent,float range);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPickMode">Online Help</a>
*/
void EntityPickMode(Entity* ent,int pick_mode,bool obscurer);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityPitch">Online Help</a>
*/
float EntityPitch(Entity* ent,bool glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRadius">Online Help</a>
*/
void EntityRadius(Entity* ent,float radius_x,float radius_y);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityRoll">Online Help</a>
*/
float EntityRoll(Entity* ent,bool glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityShininess">Online Help</a>
*/
void EntityShininess(Entity* ent,float shine);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityTexture">Online Help</a>
*/
void EntityTexture(Entity* ent,Texture* tex,int frame,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityType">Online Help</a>
*/
void EntityType(Entity* ent,int type_no,bool recursive);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityVisible">Online Help</a>
*/
int EntityVisible(Entity* src_ent,Entity* dest_ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityX">Online Help</a>
*/
float EntityX(Entity* ent,bool glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityY">Online Help</a>
*/
float EntityY(Entity* ent,bool glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityYaw">Online Help</a>
*/
float EntityYaw(Entity* ent,bool glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=EntityZ">Online Help</a>
*/
float EntityZ(Entity* ent,bool glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ExtractAnimSeq">Online Help</a>
*/
int ExtractAnimSeq(Entity* ent,int first_frame,int last_frame,int seq);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindChild">Online Help</a>
*/
Entity* FindChild(Entity* ent,char* child_name);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FindSurface">Online Help</a>
*/
Surface* FindSurface(Mesh* mesh,Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FitMesh">Online Help</a><p>
*/
void FitMesh(Mesh* mesh,float x,float y,float z,float width,float height,float depth,bool uniform);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FlipMesh">Online Help</a>
*/
void FlipMesh(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeBrush">Online Help</a>
*/
void  FreeBrush(Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeEntity">Online Help</a>
*/
void FreeEntity(Entity* ent);

void FreeShadow(ShadowObject* shad);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=FreeTexture">Online Help</a>
*/
void FreeTexture(Texture* tex);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetBrushTexture">Online Help</a>
*/
Texture* GetBrushTexture(Brush* brush,int index);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetChild">Online Help</a>
*/
Entity* GetChild(Entity* ent,int child_no);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityBrush">Online Help</a>
*/
Brush* GetEntityBrush(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetEntityType">Online Help</a>
*/
int GetEntityType(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ResetEntity">Online Help</a>
*/
float GetMatElement(Entity* ent,int row,int col);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetParent">Online Help</a>
*/
Entity* GetParentEntity(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurface">Online Help</a>
*/
Surface* GetSurface(Mesh* mesh,int surf_no);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=GetSurfaceBrush">Online Help</a>
*/
Brush* GetSurfaceBrush(Surface* surf);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Graphics3D">Online Help</a>
*/
void Graphics3D(int width,int height,int depth,int mode,int rate);

/*
*/
void GraphicsResize(int width,int height);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HandleSprite">Online Help</a>
*/
void HandleSprite(Sprite* sprite,float h_x,float h_y);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=HideEntity">Online Help</a>
*/
void HideEntity(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightColor">Online Help</a>
*/
void LightColor(Light* light,float red,float green,float blue);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightConeAngles">Online Help</a>
*/
void LightConeAngles(Light* light,float inner_ang,float outer_ang);

/*

bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LightRange">Online Help</a>
*/
void LightRange(Light* light,float range);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LinePick">Online Help</a>
*/
Entity* LinePick(float x,float y,float z,float dx,float dy,float dz,float radius);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimMesh">Online Help</a>
*/
Mesh* LoadAnimMesh(char* file,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadAnimTexture">Online Help</a>
*/
Texture* LoadAnimTexture(char* file,int flags,int frame_width,int frame_height,int first_frame,int frame_count);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadBrush">Online Help</a>
*/
Brush* LoadBrush(char *file,int flags,float u_scale,float v_scale);

Terrain* LoadGeosphere(char* file,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadMesh">Online Help</a>
*/
Mesh* LoadMesh(char* file,Entity* parent);


Terrain* LoadTerrain(char* file,Entity* parent);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadTexture">Online Help</a>
*/
Texture* LoadTexture(char* file,int flags);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=LoadSprite">Online Help</a>
*/
Sprite* LoadSprite(char* tex_file,int tex_flag,Entity* parent);

/*
*/
Mesh* MeshCSG(Mesh* m1, Mesh* m2, int method = 1);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshDepth">Online Help</a>
*/
float MeshDepth(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshesIntersect">Online Help</a>
*/
int MeshesIntersect(Mesh* mesh1,Mesh* mesh2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshHeight">Online Help</a>
*/
float MeshHeight(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MeshWidth">Online Help</a>
*/
float MeshWidth(Mesh* mesh);

void ModifyGeosphere(Geosphere* geo, int x, int z, float new_height);

void ModifyTerrain(Terrain* terr, int x, int z, float new_height);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=MoveEntity">Online Help</a>
*/
void MoveEntity(Entity* ent,float x,float y,float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=NameEntity">Online Help</a>
*/
void NameEntity(Entity* ent,char* name);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintEntity">Online Help</a>
*/
void PaintEntity(Entity* ent,Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintMesh">Online Help</a>
*/
void PaintMesh(Mesh* mesh,Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PaintSurface">Online Help</a>
*/
void PaintSurface(Surface* surf,Brush* brush);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedEntity">Online Help</a>
*/
Entity* PickedEntity();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNX">Online Help</a>
*/
float PickedNX();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNY">Online Help</a>
*/
float PickedNY();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedNZ">Online Help</a>
*/
float PickedNZ();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedSurface">Online Help</a>
*/
Surface* PickedSurface();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTime">Online Help</a>
*/
float PickedTime();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedTriangle">Online Help</a>
*/
int PickedTriangle();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedX">Online Help</a>
*/
float PickedX();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedY">Online Help</a>
*/
float PickedY();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PickedZ">Online Help</a>
*/
float PickedZ();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PointEntity">Online Help</a>
*/
void PointEntity(Entity* ent,Entity* target_ent,float roll);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionEntity">Online Help</a>
*/
void PositionEntity(Entity* ent,float x,float y,float z,bool glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionMesh">Online Help</a>
*/
void PositionMesh(Mesh* mesh,float px,float py,float pz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=PositionTexture">Online Help</a>
*/
void PositionTexture(Texture* tex,float u_pos,float v_pos);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedX">Online Help</a>
*/
float ProjectedX();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedY">Online Help</a>
*/
float ProjectedY();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ProjectedZ">Online Help</a>
*/
float ProjectedZ();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RenderWorld">Online Help</a>
*/
void RenderWorld();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RepeatMesh">Online Help</a>
*/
Mesh* RepeatMesh(Mesh* mesh,Entity* parent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ResetEntity">Online Help</a>
*/
void ResetEntity(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateEntity">Online Help</a>
*/
void RotateEntity(Entity* ent,float x,float y,float z,bool glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateMesh">Online Help</a>
*/
void RotateMesh(Mesh* mesh,float pitch,float yaw,float roll);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateSprite">Online Help</a>
*/
void RotateSprite(Sprite* sprite,float ang);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=RotateTexture">Online Help</a>
*/
void RotateTexture(Texture* tex,float ang);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleEntity">Online Help</a>
*/
void ScaleEntity(Entity* ent,float x,float y,float z,bool glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleMesh">Online Help</a>
*/
void ScaleMesh(Mesh* mesh,float sx,float sy,float sz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleSprite">Online Help</a>
*/
void ScaleSprite(Sprite* sprite,float s_x,float s_y);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ScaleTexture">Online Help</a>
*/
void ScaleTexture(Texture* tex,float u_scale,float v_scale);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetAnimTime">Online Help</a>
*/
void SetAnimTime(Entity* ent,float time,int seq);

/*
*/
void SetColorState(int fx2);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeFace">Online Help</a>
*/
void SetCubeFace(Texture* tex,int face);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SetCubeMode">Online Help</a>
*/
void SetCubeMode(Texture* tex,int mode);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=ShowEntity">Online Help</a>
*/
void ShowEntity(Entity* ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=SpriteViewMode">Online Help</a>
*/
void SpriteViewMode(Sprite* sprite,int mode);

/*
*/
void StencilAlpha(Stencil* stencil, float a);

/*
*/
void StencilClsColor(Stencil* stencil, float r,float g,float b);

/*
*/
void StencilClsMode(Stencil* stencil,int cls_depth,int cls_zbuffer);

/*
*/
void StencilMesh(Stencil* stencil, Mesh* mesh, int mode=1);

/*
*/
void StencilMode(Stencil* stencil, int m, int o=1);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainHeight">Online Help</a>
*/
float TerrainHeight (Terrain* terr, int x, int z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainX">Online Help</a>
*/
float TerrainX (Terrain* terr, float x, float y, float z);

/*

bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainY">Online Help</a>
*/
float TerrainY (Terrain* terr, float x, float y, float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TerrainZ">Online Help</a>
*/
float TerrainZ (Terrain* terr, float x, float y, float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureBlend">Online Help</a>
*/
void TextureBlend(Texture* tex,int blend);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureCoords">Online Help</a>
*/
void TextureCoords(Texture* tex,int coords);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureHeight">Online Help</a>
*/
int TextureHeight(Texture* tex);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureFilter">Online Help</a>
*/
void TextureFilter(char* match_text,int flags);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureName">Online Help</a>
*/
const char* TextureName(Texture* tex);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TextureWidth">Online Help</a>
*/
int TextureWidth(Texture* tex);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedX">Online Help</a>
*/
float TFormedX();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedY">Online Help</a>
*/
float TFormedY();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormedZ">Online Help</a>
*/
float TFormedZ();

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormNormal">Online Help</a>
*/
void TFormNormal(float x,float y,float z,Entity* src_ent,Entity* dest_ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormPoint">Online Help</a>
*/
void TFormPoint(float x,float y,float z,Entity* src_ent,Entity* dest_ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TFormVector">Online Help</a>
*/
void TFormVector(float x,float y,float z,Entity* src_ent,Entity* dest_ent);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TranslateEntity">Online Help</a>
*/
void TranslateEntity(Entity* ent,float x,float y,float z,bool glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TriangleVertex">Online Help</a>
*/
int TriangleVertex(Surface* surf,int tri_no,int corner);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=TurnEntity">Online Help</a>
*/
void TurnEntity(Entity* ent,float x,float y,float z,bool glob);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateNormals">Online Help</a>
*/
void UpdateNormals(Mesh* mesh);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateNormals">Online Help</a>
*/
void UpdateTexCoords(Surface* surf);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=UpdateWorld">Online Help</a>
*/
void UpdateWorld(float anim_speed);

/*
*/
void UseStencil(Stencil* stencil);
/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorPitch">Online Help</a>
*/
float VectorPitch(float vx,float vy,float vz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VectorYaw">Online Help</a>
*/
float VectorYaw(float vx,float vy,float vz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexAlpha">Online Help</a>
*/
float VertexAlpha(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexBlue">Online Help</a>
*/
float VertexBlue(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexColor">Online Help</a>
*/
void VertexColor(Surface* surf,int vid,float r,float g,float b,float a);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexCoords">Online Help</a>
*/
void VertexCoords(Surface* surf,int vid,float x,float y,float z);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexGreen">Online Help</a>
*/
float VertexGreen(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNormal">Online Help</a>
*/
void VertexNormal(Surface* surf,int vid,float nx,float ny,float nz);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNX">Online Help</a>
*/
float VertexNX(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNY">Online Help</a>
*/
float VertexNY(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexNZ">Online Help</a>
*/
float VertexNZ(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexRed">Online Help</a>
*/
float VertexRed(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexTexCoords">Online Help</a>
*/
void VertexTexCoords(Surface* surf,int vid,float u,float v,float w,int coord_set);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexU">Online Help</a>
*/
float VertexU(Surface* surf,int vid,int coord_set);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexV">Online Help</a>
*/
float VertexV(Surface* surf,int vid,int coord_set);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexW">Online Help</a>
*/
float VertexW(Surface* surf,int vid,int coord_set);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexX">Online Help</a>
*/
float VertexX(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexY">Online Help</a>
*/
float VertexY(Surface* surf,int vid);

/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=VertexZ">Online Help</a>
*/
float VertexZ(Surface* surf,int vid);

/*
*/
void VoxelSpriteMaterial(VoxelSprite* voxelspr, Material* mat);


/*
bbdoc: <a href="http://www.blitzbasic.com/b3ddocs/command.php?name=Wireframe">Online Help</a>
*/
void Wireframe(int enable);


float EntityScaleX(Entity* ent,bool glob);

float EntityScaleY(Entity* ent,bool glob);

float EntityScaleZ(Entity* ent,bool glob);

Shader* LoadShader(char* ShaderName, char* VshaderFileName, char* FshaderFileName);

Shader* CreateShader(char* ShaderName, char* VshaderString, char* FshaderString);

void ShadeSurface(Surface* surf, Shader* material);

void ShadeMesh(Mesh* mesh, Shader* material);

void ShadeEntity(Entity* ent, Shader* material);

void ShaderTexture(Shader* material, Texture* tex, char* name, int index);

void SetFloat(Shader* material, char* name, float v1);

void SetFloat2(Shader* material, char* name, float v1, float v2);

void SetFloat3(Shader* material, char* name, float v1, float v2, float v3);

void SetFloat4(Shader* material, char* name, float v1, float v2, float v3, float v4);

void UseFloat(Shader* material, char* name, float* v1);

void UseFloat2(Shader* material, char* name, float* v1, float* v2);

void UseFloat3(Shader* material, char* name, float* v1, float* v2, float* v3);

void UseFloat4(Shader* material, char* name, float* v1, float* v2, float* v3, float* v4);

void SetInteger(Shader* material, char* name, int v1);

void SetInteger2(Shader* material, char* name, int v1, int v2):

void SetInteger3(Shader* material, char* name, int v1, int v2, int v3);

void SetInteger4(Shader* material, char* name, int v1, int v2, int v3, int v4);

void UseInteger(Shader* material, char* name, int* v1);

void UseInteger2(Shader* material, char* name, int* v1, int* v2);

void UseInteger3(Shader* material, char* name, int* v1, int* v2, int* v3);

void UseInteger4(Shader* material, char* name, int* v1, int* v2, int* v3, int* v4);

void UseSurface(Shader* material, char* name, Surface* surf, int vbo);

void UseMatrix(Shader* material, char* name, int mode);

Material* LoadMaterial(char* filename,int flags, int frame_width,int frame_height,int first_frame,int frame_count);

void ShaderMaterial(Shader* material, Material* tex, char* name, int index);






OcTree* CreateOcTree(float w, float h, float d, Entity* parent_ent=0);

void AddToOctree(OcTree* octree, Mesh* mesh, int level, float X, float Y, float Z, float Near=0.0, float Far=1000.0);


} // extern "C"

#endif
