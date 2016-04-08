
Rem
bbdoc: Surface
End Rem
Type TSurface

	' no of vertices and triangles in surface
	Field no_verts:Int Ptr ' 0
	Field no_tris:Int Ptr ' 0
	
	' arrays containing vertex and triangle info
	Field vert_coords:Float Ptr ' vector
	Field vert_norm:Float Ptr ' vector
	Field vert_tex_coords0:Float Ptr ' vector
	Field vert_tex_coords1:Float Ptr ' vector
	Field vert_col:Float Ptr ' vector
	Field tris:Short Ptr ' ushort vector
	
	' arrays containing vertex bone no and weights info - used by animated meshes only
	Field vert_bone1_no:Int Ptr ' vector - bone no used to reference bones[] array belonging to TMesh
	Field vert_bone2_no:Int Ptr ' vector
	Field vert_bone3_no:Int Ptr ' vector
	Field vert_bone4_no:Int Ptr ' vector
	Field vert_weight1:Float Ptr ' vector
	Field vert_weight2:Float Ptr ' vector
	Field vert_weight3:Float Ptr ' vector
	Field vert_weight4:Float Ptr ' vector
	
	' brush applied to surface
	Field brush:TBrush ' new
	Field ShaderMat:TShader ' openb3d - NULL
	
	' vbo
	Field vbo_id:Int Ptr ' unsigned int array [7] - 0
	
	' misc vars
	Field vert_array_size:Int Ptr ' 1
	Field tri_array_size:Int Ptr ' 1
	Field vmin:Int Ptr ' used for trimming verts from b3d files - 1000000
	Field vmax:Int Ptr ' used for trimming verts from b3d files - 0
	
	' reset flag - this is set when mesh shape is changed in TSurface and TMesh
	Field vbo_enabled:Int Ptr ' openb3d: Global::vbo_enabled
	Field reset_vbo:Int Ptr ' (-1 = all) - -1
	
	' used by Compare to sort array, and TMesh.Update to enable/disable alpha blending
	Field alpha_enable:Int Ptr ' false
	
	' wrapper
	Global surf_map:TMap=New TMap
	Field instance:Byte Ptr
	
	Function CreateObject:TSurface( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TSurface=New TSurface
		surf_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		surf_map.Remove( String(Long(inst)) )
		
	End Function
	
	Function GetObject:TSurface( inst:Byte Ptr )
	
		Return TSurface( surf_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	Function GetInstance:Byte Ptr( obj:TSurface ) ' Get C++ instance from object
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		' short
		tris=SurfaceUShort_( GetInstance(Self),SURFACE_tris )
		
		' int
		no_verts=SurfaceInt_( GetInstance(Self),SURFACE_no_verts )
		no_tris=SurfaceInt_( GetInstance(Self),SURFACE_no_tris )
		vert_bone1_no=SurfaceInt_( GetInstance(Self),SURFACE_vert_bone1_no )
		vert_bone2_no=SurfaceInt_( GetInstance(Self),SURFACE_vert_bone2_no )
		vert_bone3_no=SurfaceInt_( GetInstance(Self),SURFACE_vert_bone3_no )
		vert_bone4_no=SurfaceInt_( GetInstance(Self),SURFACE_vert_bone4_no )
		vert_array_size=SurfaceInt_( GetInstance(Self),SURFACE_vert_array_size )
		tri_array_size=SurfaceInt_( GetInstance(Self),SURFACE_tri_array_size )
		vmin=SurfaceInt_( GetInstance(Self),SURFACE_vmin )
		vmax=SurfaceInt_( GetInstance(Self),SURFACE_vmax )
		vbo_enabled=SurfaceInt_( GetInstance(Self),SURFACE_vbo_enabled )
		reset_vbo=SurfaceInt_( GetInstance(Self),SURFACE_reset_vbo )
		alpha_enable=SurfaceInt_( GetInstance(Self),SURFACE_alpha_enable )
		
		' uint
		vbo_id=SurfaceUInt_( GetInstance(Self),SURFACE_vbo_id )
		
		' float
		vert_coords=SurfaceFloat_( GetInstance(Self),SURFACE_vert_coords )
		vert_norm=SurfaceFloat_( GetInstance(Self),SURFACE_vert_norm )
		vert_tex_coords0=SurfaceFloat_( GetInstance(Self),SURFACE_vert_tex_coords0 )
		vert_tex_coords1=SurfaceFloat_( GetInstance(Self),SURFACE_vert_tex_coords1 )
		vert_col=SurfaceFloat_( GetInstance(Self),SURFACE_vert_col )
		vert_weight1=SurfaceFloat_( GetInstance(Self),SURFACE_vert_weight1 )
		vert_weight2=SurfaceFloat_( GetInstance(Self),SURFACE_vert_weight2 )
		vert_weight3=SurfaceFloat_( GetInstance(Self),SURFACE_vert_weight3 )
		vert_weight4=SurfaceFloat_( GetInstance(Self),SURFACE_vert_weight4 )
		
		' brush
		Local inst:Byte Ptr=SurfaceBrush_( GetInstance(Self),SURFACE_brush )
		brush=TBrush.GetObject(inst)
		If brush=Null And inst<>Null Then brush=TBrush.CreateObject(inst)
		
		' shader
		inst=SurfaceShader_( GetInstance(Self),SURFACE_ShaderMat )
		ShaderMat=TShader.GetObject(inst) ' no CreateObject
		
	End Method
	
	' Openb3d
	
	Method UpdateTexCoords()
	
		UpdateTexCoords_( GetInstance(Self) )
		
	End Method
	
	Method GetSurfaceBrush:TBrush() ' same as function in TBrush
	
		Local inst:Byte Ptr=GetSurfaceBrush_( GetInstance(Self) )
		Local brush:TBrush=TBrush.GetObject(inst)
		If brush=Null And inst<>Null Then brush=TBrush.CreateObject(inst)
		Return brush
		
	End Method
	
	Function CreateSurface:TSurface( mesh:TMesh,brush:TBrush=Null ) ' same as method in TSurface
	
		Local inst:Byte Ptr=CreateSurface_( TMesh.GetInstance(mesh),TBrush.GetInstance(brush) )
		Return CreateObject(inst)
		
	End Function
	
	' Minib3d
	
	Method New()
	
		If LOG_NEW
			DebugLog "New TSurface"
		EndIf
	
	End Method
	
	Method Delete()
	
		FreeVBO()
		
		If LOG_DEL
			DebugLog "Del TSurface"
		EndIf
			
	End Method
	
	Method PaintSurface( brush:TBrush )
	
		PaintSurface_( GetInstance(Self),TBrush.GetInstance(brush) )
		
	End Method
	
	Method ClearSurface( clear_verts:Int=True,clear_tris:Int=True )
	
		ClearSurface_( GetInstance(Self),clear_verts,clear_tris )
		
	End Method
	
	Method AddVertex:Int( x:Float,y:Float,z:Float,u:Float=0,v:Float=0,w:Float=0 )
	
		Return AddVertex_( GetInstance(Self),x,y,z,u,v,w )
		
	End Method
	
	Method AddTriangle:Int( v0:Int,v1:Int,v2:Int )
	
		Return AddTriangle_( GetInstance(Self),v0,v1,v2 )
		
	End Method
	
	Method CountVertices:Int()
	
		Return CountVertices_( GetInstance(Self) )
		
	End Method
	
	Method CountTriangles:Int()
	
		Return CountTriangles_( GetInstance(Self) )
		
	End Method
	
	Method VertexCoords( vid:Int,x:Float,y:Float,z:Float )
	
		VertexCoords_( GetInstance(Self),vid,x,y,z )
	
	End Method
			
	Method VertexColor( vid:Int,r:Float,g:Float,b:Float,a:Float=1 )
	
		VertexColor_( GetInstance(Self),vid,r,g,b,a )

	End Method
	
	Method VertexNormal( vid:Int,nx:Float,ny:Float,nz:Float )
	
		VertexNormal_( GetInstance(Self),vid,nx,ny,nz )

	End Method
	
	Method VertexTexCoords( vid:Int,u:Float,v:Float,w:Float=0,coord_set:Int=0 )
	
		VertexTexCoords_( GetInstance(Self),vid,u,v,w,coord_set )

	End Method
		
	Method VertexX:Float( vid:Int )
	
		Return VertexX_( GetInstance(Self),vid )

	End Method

	Method VertexY:Float( vid:Int )
	
		Return VertexY_( GetInstance(Self),vid )

	End Method
	
	Method VertexZ:Float( vid:Int )
	
		Return VertexZ_( GetInstance(Self),vid )

	End Method
	
	Method VertexRed:Float( vid:Int )
	
		Return VertexRed_( GetInstance(Self),vid )

	End Method
	
	Method VertexGreen:Float( vid:Int )
	
		Return VertexGreen_( GetInstance(Self),vid )

	End Method
	
	Method VertexBlue:Float( vid:Int )
	
		Return VertexBlue_( GetInstance(Self),vid )

	End Method
	
	Method VertexAlpha:Float( vid:Int )
	
		Return VertexAlpha_( GetInstance(Self),vid )
		
	End Method
	
	Method VertexNX:Float( vid:Int )
	
		Return VertexNX_( GetInstance(Self),vid )

	End Method
	
	Method VertexNY:Float( vid:Int )
	
		Return VertexNY_( GetInstance(Self),vid )

	End Method
	
	Method VertexNZ:Float( vid:Int )
	
		Return VertexNZ_( GetInstance(Self),vid )

	End Method
	
	Method VertexU:Float( vid:Int,coord_set:Int=0 )
	
		Return VertexU_( GetInstance(Self),vid,coord_set )

	End Method
	
	Method VertexV:Float( vid:Int,coord_set:Int=0 )
	
		Return VertexV_( GetInstance(Self),vid,coord_set )

	End Method
	
	Method VertexW:Float( vid:Int,coord_set:Int=0 )
	
		Return VertexW_( GetInstance(Self),vid,coord_set )

	End Method
	
	Method TriangleVertex:Int( tri_no:Int,corner:Int )
	
		Return TriangleVertex_( GetInstance(Self),tri_no,corner )
		
	End Method
	
	' Internal
	
	Method Copy:TSurface()
	
		Local inst:Byte Ptr=SurfaceCopy_( GetInstance(Self) )
		Return CreateObject(inst)
		
	End Method
	
	' recalculates all normals in a surface
	Method UpdateNormals()
	
		SurfaceUpdateNormals_( GetInstance(Self) )
		
	End Method
	
	' returns x component of a triangle normal (unused)
	Method TriangleNX:Float(tri_no:Int)

		Return TriangleNX_( GetInstance(Self),tri_no )
		
	End Method
	
	' returns y component of a triangle normal (unused)
	Method TriangleNY:Float(tri_no:Int)
	
		Return TriangleNY_( GetInstance(Self),tri_no )
			
	End Method
	
	' returns z component of a triangle normal (unused)
	Method TriangleNZ:Float(tri_no:Int)
	
		Return TriangleNZ_( GetInstance(Self),tri_no )
		
	End Method
	
	' called in Mesh::Render and Mesh::UpdateShadow
	Method UpdateVBO()
	
		UpdateVBO_( GetInstance(Self) )
	
	End Method
	
	' called by ~Surface
	Method FreeVBO()
	
		FreeVBO_( GetInstance(Self) )
	
	End Method
	
	' removes a tri from a surface - called in Load3ds and LoadX
	Function RemoveTri( surf:TSurface,tri:Int )
	
		RemoveTri_( GetInstance(surf),tri )
		
	End Function
	
	' sets the vertex colors of a surface - called by MeshColor
	Method SurfaceColor( r:Float,g:Float,b:Float,a:Float=1.0 )
	
		SurfaceColor_( GetInstance(Self),r,g,b,a )
		
	End Method
	
	' sets the red component of the vertex colors of a surface - called by MeshRed
	Method SurfaceRed( r:Float )
	
		SurfaceRed_( GetInstance(Self),r )
		
	End Method
	
	' sets the green component of the vertex colors of a surface - called by MeshGreen
	Method SurfaceGreen( g:Float )
	
		SurfaceGreen_( GetInstance(Self),g )
		
	End Method
	
	' sets the blue component of the vertex colors of a surface - called by MeshBlue
	Method SurfaceBlue( b:Float )
	
		SurfaceBlue_( GetInstance(Self),b )
		
	End Method
	
	' sets the alpha component of the vertex colors of a surface - called by MeshAlpha
	Method SurfaceAlpha( a:Float )
	
		SurfaceAlpha_( GetInstance(Self),a )
	
	End Method
	
	Method FreeSurface()
	
		FreeSurface_( GetInstance(self) )
		
	End Method
	
	Rem
	' todo - used to sort surfaces into alpha order. used by TMesh.Update
	Method Compare:Int(other:Object)
	
		
	
	End Method
	EndRem
	
	Rem
	' removes redundent verts (non-working)
	Function RemoveVerts(surf:TSurface)
	
		
		
	End Function
	EndRem
	
End Type
