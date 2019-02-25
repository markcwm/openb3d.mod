
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
	?bmxng
	Global surf_map:TPtrMap=New TPtrMap
	?Not bmxng
	Global surf_map:TMap=New TMap
	?
	Field instance:Byte Ptr
	
	Field exists:Int=0
	
	Function CreateObject:TSurface( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TSurface=New TSurface
		?bmxng
		surf_map.Insert( inst,obj )
		?Not bmxng
		surf_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function FreeObject( inst:Byte Ptr )
	
		?bmxng
		surf_map.Remove( inst )
		?Not bmxng
		surf_map.Remove( String(Int(inst)) )
		?
		
	End Function
	
	Function GetObject:TSurface( inst:Byte Ptr )
	
		?bmxng
		Return TSurface( surf_map.ValueForKey( inst ) )
		?Not bmxng
		Return TSurface( surf_map.ValueForKey( String(Int(inst)) ) )
		?
		
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
		
		exists=1
		
	End Method
	
	Method DebugFields( debug_subobjects:Int=0,debug_base_types:Int=0 )
	
		Local pad:String
		Local loop:Int=debug_subobjects
		If debug_base_types>debug_subobjects Then loop=debug_base_types
		For Local i%=1 Until loop
			pad:+"  "
		Next
		If debug_subobjects Then debug_subobjects:+1
		If debug_base_types Then debug_base_types:+1
		DebugLog pad+" Surface instance: "+StringPtr(GetInstance(Self))
		
		' short
		DebugLog pad+" tris: "+StringPtr(tris)
		If tris<>Null Then DebugLog(pad+" tris[0] = "+tris[0]+" [1] = "+tris[1]+" [2] = "+tris[2]+" ...")
		
		' int
		If no_verts<>Null Then DebugLog(pad+" no_verts: "+no_verts[0]) Else DebugLog(pad+" no_verts: Null")
		If no_tris<>Null Then DebugLog(pad+" no_tris: "+no_tris[0]) Else DebugLog(pad+" no_tris: Null")
		
		DebugLog pad+" vert_bone1_no: "+StringPtr(vert_bone1_no)
		If vert_bone1_no<>Null Then DebugLog(pad+" vert_bone1_no[0] = "+vert_bone1_no[0]+" [1] = "+vert_bone1_no[1]+" ...")
		DebugLog pad+" vert_bone2_no: "+StringPtr(vert_bone2_no)
		If vert_bone2_no<>Null Then DebugLog(pad+" vert_bone2_no[0] = "+vert_bone2_no[0]+" [1] = "+vert_bone2_no[1]+" ...")
		DebugLog pad+" vert_bone3_no: "+StringPtr(vert_bone3_no)
		If vert_bone3_no<>Null Then DebugLog(pad+" vert_bone3_no[0] = "+vert_bone3_no[0]+" [1] = "+vert_bone3_no[1]+" ...")
		DebugLog pad+" vert_bone4_no: "+StringPtr(vert_bone4_no)
		If vert_bone4_no<>Null Then DebugLog(pad+" vert_bone4_no[0] = "+vert_bone4_no[0]+" [1] = "+vert_bone4_no[1]+" ...")
		
		If vert_array_size<>Null Then DebugLog(pad+" vert_array_size: "+vert_array_size[0]) Else DebugLog(pad+" vert_array_size: Null")
		If tri_array_size<>Null Then DebugLog(pad+" tri_array_size: "+tri_array_size[0]) Else DebugLog(pad+" tri_array_size: Null")
		If vmin<>Null Then DebugLog(pad+" vmin: "+vmin[0]) Else DebugLog(pad+" vmin: Null")
		If vmax<>Null Then DebugLog(pad+" vmax: "+vert_array_size[0]) Else DebugLog(pad+" vmax: Null")
		If vbo_enabled<>Null Then DebugLog(pad+" vbo_enabled: "+vert_array_size[0]) Else DebugLog(pad+" vbo_enabled: Null")
		If reset_vbo<>Null Then DebugLog(pad+" reset_vbo: "+vert_array_size[0]) Else DebugLog(pad+" reset_vbo: Null")
		If alpha_enable<>Null Then DebugLog(pad+" alpha_enable: "+vert_array_size[0]) Else DebugLog(pad+" alpha_enable: Null")
		
		' uint
		DebugLog pad+" vbo_id: "+StringPtr(vbo_id)
		For Local id:Int=0 To 5
			DebugLog pad+" vbo_id["+id+"] = "+vbo_id[id]
		Next
		
		' float
		DebugLog pad+" vert_coords: "+StringPtr(vert_coords)
		If vert_coords<>Null Then DebugLog(pad+" vert_coords[0] = "+vert_coords[0]+" [1] = "+vert_coords[1]+" [2] = "+vert_coords[2]+" ...")
		DebugLog pad+" vert_norm: "+StringPtr(vert_norm)
		If vert_norm<>Null Then DebugLog(pad+" vert_norm[0] = "+vert_norm[0]+" [1] = "+vert_norm[1]+" [2] = "+vert_norm[2]+" ...")
		DebugLog pad+" vert_col: "+StringPtr(vert_col)
		If vert_col<>Null Then DebugLog(pad+" vert_col[0] = "+vert_col[0]+" [1] = "+vert_col[1]+" [2] = "+vert_col[2]+" ...")
		DebugLog pad+" vert_tex_coords0: "+StringPtr(vert_tex_coords0)
		If vert_tex_coords0<>Null Then DebugLog(pad+" vert_tex_coords0[0] = "+vert_tex_coords0[0]+" [1] = "+vert_tex_coords0[1]+" ...")
		DebugLog pad+" vert_tex_coords1: "+StringPtr(vert_tex_coords1)
		If vert_tex_coords1<>Null Then DebugLog(pad+" vert_tex_coords1[0] = "+vert_tex_coords1[0]+" [1] = "+vert_tex_coords1[1]+" ...")
		
		DebugLog pad+" vert_weight1: "+StringPtr(vert_weight1)
		If vert_weight1<>Null Then DebugLog(pad+" vert_weight1[0] = "+vert_weight1[0]+" [1] = "+vert_weight1[1]+" ...")
		DebugLog pad+" vert_weight2: "+StringPtr(vert_weight2)
		If vert_weight2<>Null Then DebugLog(pad+" vert_weight2[0] = "+vert_weight2[0]+" [1] = "+vert_weight2[1]+" ...")
		DebugLog pad+" vert_weight3: "+StringPtr(vert_weight3)
		If vert_weight3<>Null Then DebugLog(pad+" vert_weight3[0] = "+vert_weight3[0]+" [1] = "+vert_weight3[1]+" ...")
		DebugLog pad+" vert_weight4: "+StringPtr(vert_weight4)
		If vert_weight4<>Null Then DebugLog(pad+" vert_weight4[0] = "+vert_weight4[0]+" [1] = "+vert_weight4[1]+" ...")
		
		' brush
		DebugLog pad+" brush: "+StringPtr(TBrush.GetInstance(brush))
		If debug_subobjects And brush<>Null Then brush.DebugFields( debug_subobjects,debug_base_types )
		
		' shader
		DebugLog pad+" ShaderMat: "+StringPtr(TShader.GetInstance(ShaderMat))
		'If debug_subobjects And ShaderMat<>Null Then ShaderMat.DebugFields( debug_subobjects,debug_base_types )
		
		DebugLog ""
		
	End Method
	
	Method SurfaceFloatArrayCopy:Float Ptr( varid:Int,surf:TSurface )
	
		Select varid
			Case SURFACE_vert_coords
				Return SurfaceCopyFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_coords,TSurface.GetInstance(surf) )
			Case SURFACE_vert_norm
				Return SurfaceCopyFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_norm,TSurface.GetInstance(surf) )
			Case SURFACE_vert_tex_coords0
				Return SurfaceCopyFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_tex_coords0,TSurface.GetInstance(surf) )
			Case SURFACE_vert_tex_coords1
				Return SurfaceCopyFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_tex_coords1,TSurface.GetInstance(surf) )
			Case SURFACE_vert_col
				Return SurfaceCopyFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_col,TSurface.GetInstance(surf) )
		End Select
		
	End Method
	
	Method SurfaceIntArrayResize:Int Ptr( varid:Int,size:Int )
	
		Select varid
			Case SURFACE_vert_bone1_no
				Return SurfaceResizeIntArray_( TSurface.GetInstance(Self),SURFACE_vert_bone1_no,size )
			Case SURFACE_vert_bone2_no
				Return SurfaceResizeIntArray_( TSurface.GetInstance(Self),SURFACE_vert_bone2_no,size )
			Case SURFACE_vert_bone3_no
				Return SurfaceResizeIntArray_( TSurface.GetInstance(Self),SURFACE_vert_bone3_no,size )
			Case SURFACE_vert_bone4_no
				Return SurfaceResizeIntArray_( TSurface.GetInstance(Self),SURFACE_vert_bone4_no,size )
			End Select
		
	End Method
	
	Method SurfaceFloatArrayResize:Float Ptr( varid:Int,size:Int )
	
		Select varid
			Case SURFACE_vert_coords
				Return SurfaceResizeFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_coords,size )
			Case SURFACE_vert_norm
				Return SurfaceResizeFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_norm,size )
			Case SURFACE_vert_tex_coords0
				Return SurfaceResizeFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_tex_coords0,size )
			Case SURFACE_vert_tex_coords1
				Return SurfaceResizeFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_tex_coords1,size )
			Case SURFACE_vert_col
				Return SurfaceResizeFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_col,size )
			Case SURFACE_vert_weight1
				Return SurfaceResizeFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_weight1,size )
			Case SURFACE_vert_weight2
				Return SurfaceResizeFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_weight2,size )
			Case SURFACE_vert_weight3
				Return SurfaceResizeFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_weight3,size )
			Case SURFACE_vert_weight4
				Return SurfaceResizeFloatArray_( TSurface.GetInstance(Self),SURFACE_vert_weight4,size )
		End Select
		
	End Method
	
	Method SurfaceFloatArrayAdd( varid:Int,value:Float )
	
		Select varid
			Case SURFACE_vert_coords
				SurfaceVectorPushBackFloat_( TSurface.GetInstance(Self),SURFACE_vert_coords,value )
				vert_coords=SurfaceFloat_( TSurface.GetInstance(Self),SURFACE_vert_coords )
			Case SURFACE_vert_norm
				SurfaceVectorPushBackFloat_( TSurface.GetInstance(Self),SURFACE_vert_norm,value )
				vert_norm=SurfaceFloat_( GetInstance(Self),SURFACE_vert_norm )
			Case SURFACE_vert_tex_coords0
				SurfaceVectorPushBackFloat_( TSurface.GetInstance(Self),SURFACE_vert_tex_coords0,value )
				vert_tex_coords0=SurfaceFloat_( GetInstance(Self),SURFACE_vert_tex_coords0 )
			Case SURFACE_vert_tex_coords1
				SurfaceVectorPushBackFloat_( TSurface.GetInstance(Self),SURFACE_vert_tex_coords1,value )
				vert_tex_coords1=SurfaceFloat_( GetInstance(Self),SURFACE_vert_tex_coords1 )
			Case SURFACE_vert_col
				SurfaceVectorPushBackFloat_( TSurface.GetInstance(Self),SURFACE_vert_col,value )
				vert_col=SurfaceFloat_( GetInstance(Self),SURFACE_vert_col )
			Case SURFACE_vert_weight1
				SurfaceVectorPushBackFloat_( TSurface.GetInstance(Self),SURFACE_vert_weight1,value )
				vert_weight1=SurfaceFloat_( GetInstance(Self),SURFACE_vert_weight1 )
			Case SURFACE_vert_weight2
				SurfaceVectorPushBackFloat_( TSurface.GetInstance(Self),SURFACE_vert_weight2,value )
				vert_weight2=SurfaceFloat_( GetInstance(Self),SURFACE_vert_weight2 )
			Case SURFACE_vert_weight3
				SurfaceVectorPushBackFloat_( TSurface.GetInstance(Self),SURFACE_vert_weight3,value )
				vert_weight3=SurfaceFloat_( GetInstance(Self),SURFACE_vert_weight3 )
			Case SURFACE_vert_weight4
				SurfaceVectorPushBackFloat_( TSurface.GetInstance(Self),SURFACE_vert_weight4,value )
				vert_weight4=SurfaceFloat_( GetInstance(Self),SURFACE_vert_weight4 )
		End Select
		
	End Method
	
	' Extra
	
	Method FreeSurface()
	
		If exists
			exists=0
			FreeSurface_( GetInstance(Self) )
			FreeObject( GetInstance(Self) )
		EndIf
		
	End Method
	
	' Openb3d
	
	Method UpdateTexCoords()
	
		UpdateTexCoords_( GetInstance(Self) )
		vert_tex_coords1=SurfaceFloat_( GetInstance(Self),SURFACE_vert_tex_coords1 )
		
	End Method
	
	Method GetSurfaceBrush:TBrush() ' same as function in TBrush
	
		Local inst:Byte Ptr=GetSurfaceBrush_( GetInstance(Self) )
		Local brush:TBrush=TBrush.GetObject(inst)
		If brush=Null And inst<>Null Then brush=TBrush.CreateObject(inst)
		Return brush
		
	End Method
	
	Function CreateSurface:TSurface( mesh:TMesh,brush:TBrush=Null ) ' same as method in TSurface
	
		Local inst:Byte Ptr=CreateSurface_( TMesh.GetInstance(mesh),TBrush.GetInstance(brush) )
		Local surf:TSurface=CreateObject(inst)
		mesh.CopyList(mesh.surf_list)
		Return surf
		
	End Function
	
	' Minib3d
	
	Method New()
	
		If TGlobal.Log_New
			DebugLog " New TSurface"
		EndIf
		
	End Method
	
	Method Delete()
		
		If TGlobal.Log_Del
			DebugLog " Del TSurface"
		EndIf
			
	End Method
	
	Method PaintSurface( bru:TBrush )
	
		PaintSurface_( GetInstance(Self),TBrush.GetInstance(bru) )
		If brush<>Null Then brush.InitFields()
		
	End Method
	
	Method ClearSurface( clear_verts:Int=True,clear_tris:Int=True )
	
		ClearSurface_( GetInstance(Self),clear_verts,clear_tris )
		
	End Method
	
	Method AddVertex:Int( x:Float,y:Float,z:Float,u:Float=0,v:Float=0,w:Float=0 )
	
		Local no:Int=AddVertex_( GetInstance(Self),x,y,z,u,v,w )
		vert_coords=SurfaceFloat_( GetInstance(Self),SURFACE_vert_coords )
		vert_norm=SurfaceFloat_( GetInstance(Self),SURFACE_vert_norm )
		vert_tex_coords0=SurfaceFloat_( GetInstance(Self),SURFACE_vert_tex_coords0 )
		vert_tex_coords1=SurfaceFloat_( GetInstance(Self),SURFACE_vert_tex_coords1 )
		vert_col=SurfaceFloat_( GetInstance(Self),SURFACE_vert_col )
		Return no
		
	End Method
	
	Method AddTriangle:Int( v0:Int,v1:Int,v2:Int )
	
		Local no:Int=AddTriangle_( GetInstance(Self),v0,v1,v2 )
		tris=SurfaceUShort_( GetInstance(Self),SURFACE_tris )
		Return no
		
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
	Method RemoveTri( tri:Int )
	
		RemoveTri_( GetInstance(Self),tri )
		tris=SurfaceUShort_( GetInstance(Self),SURFACE_tris )
		
	End Method
	
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
