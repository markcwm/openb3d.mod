Rem
bbdoc: Surface
End Rem
Type TSurface

	' no of vertices and triangles in surface

	Field no_verts:Int=0
	Field no_tris:Int=0
	
	' arrays containing vertex and triangle info
	
	Field tris:Short[0]
	Field vert_coords#[0]
	Field vert_tex_coords0#[0]
	Field vert_tex_coords1#[0]
	Field vert_norm#[0]
	Field vert_col#[0]
	
	' arrays containing vertex bone no and weights info - used by animated meshes only
	
	Field vert_bone1_no:Int[0] ' stores bone no - bone no used to reference bones[] array belonging to TMesh
	Field vert_bone2_no:Int[0]
	Field vert_bone3_no:Int[0]
	Field vert_bone4_no:Int[0]
	Field vert_weight1:Float[0]
	Field vert_weight2:Float[0]
	Field vert_weight3:Float[0]
	Field vert_weight4:Float[0]

	' brush applied to surface

	Field brush:TBrush=New TBrush
	
	' vbo
	
	Field vbo_id:Int[7]
	
	' misc vars
	
	Field vert_array_size:Int=1
	Field tri_array_size:Int=1
	Field vmin:Int=1000000 ' used for trimming verts from b3d files
	Field vmax:Int=0 ' used for trimming verts from b3d files

	' reset flag - this is set when mesh shape is changed in TSurface and TMesh
	Field reset_vbo:Int=-1 ' (-1 = all)
	
	' used by Compare to sort array, and TMesh.Update to enable/disable alpha blending
	Field alpha_enable:Int=False
	
	Global surf_map:TMap=New TMap
	Field instance:Byte Ptr
	
	' Create and map object from C++ instance
	Function NewObject:TSurface( inst:Byte Ptr )
	
		Local obj:TSurface=New TSurface
		surf_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		Return obj
		
	End Function
	
	' Delete object from C++ instance
	Function DeleteObject( inst:Byte Ptr )
	
		surf_map.Remove( String(Long(inst)) )
		
	End Function
	
	' Get object from C++ instance
	Function GetObject:TSurface( inst:Byte Ptr )
	
		Return TSurface( surf_map.ValueForKey( String(Long(inst)) ) )
		
	End Function
	
	' Get C++ instance from object (used for passing object to C++ function)
	Function GetInstance:Byte Ptr( obj:TSurface )
	
		If obj=Null Then Return Null ' Attempt to pass null object to function
		Return obj.instance
		
	End Function
	
	Method UpdateTexCoords()
	
		UpdateTexCoords_( GetInstance(Self) )
		
	End Method
	
	Function CreateSurface:TSurface( mesh:TMesh,brush:TBrush=Null )
	
		Local instance:Byte Ptr=CreateSurface_( TMesh.GetInstance(mesh),TBrush.GetInstance(brush) )
		Return NewObject(instance)
		
	End Function
	
	Method GetSurfaceBrush:TBrush()
	
		Local instance:Byte Ptr=GetSurfaceBrush_( GetInstance(Self) )
		Local brush:TBrush=TBrush.GetObject(instance)
		If brush=Null And instance<>Null Then brush=TBrush.NewObject(instance)
		Return brush
		
	End Method
	
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

	' used to sort surfaces into alpha order. used by TMesh.Update
	Method Compare:Int(other:Object)
	
		
	
	End Method
						
	Method Copy:TSurface()
	
		
	
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
	
	Method UpdateNormals()
	
		Rem
		
		End Rem
	
	End Method
		
	Method TriangleNX:Float(tri_no:Int)

		
		
	End Method

	Method TriangleNY:Float(tri_no:Int)
	
		
			
	End Method

	Method TriangleNZ:Float(tri_no:Int)
	
		
		
	End Method
	
	Method UpdateVBO()
	
		
	
	End Method
	
	Method FreeVBO()
	
		
	
	End Method
	
	' removes a tri from a surface
	Function RemoveTri(surf:TSurface,tri:Int)
	
		
		
	End Function
	
	' removes redundent verts (non-working)
	Function RemoveVerts(surf:TSurface)
	
		
		
	End Function

End Type
