' TMD2.bmx
' MD2 loader from Openb3d (by Angelo Rosina)

Type TMD2Vertex
	Field x:Float, y:Float, z:Float
	Field normalindex:Byte ' index to precalculated normal table for lighting
End Type

Type TMD2Triangle
	Field v0:Short, v1:Short, v2:Short
	Field t0:Short, t1:Short, t2:Short
End Type

Type TMD2TexCoords
	Field u:Float
	Field v:Float
End Type

Type TMD2Frame
	Field name:String
	Field sx:Float, sy:Float, sz:Float
	Field tx:Float, ty:Float, tz:Float
	Field verts:TMD2Vertex[]	
End Type

Type TMD2

	Global md2_anorms:Float[] = [ -0.525731,  0.000000,  0.850651, ..
	-0.442863,  0.238856,  0.864188, ..
	-0.295242,  0.000000,  0.955423, ..
	-0.309017,  0.500000,  0.809017, ..
	-0.162460,  0.262866,  0.951056, ..
	 0.000000,  0.000000,  1.000000, ..
	 0.000000,  0.850651,  0.525731, ..
	-0.147621,  0.716567,  0.681718, ..
	 0.147621,  0.716567,  0.681718, ..
	 0.000000,  0.525731,  0.850651, ..
	 0.309017,  0.500000,  0.809017, ..
	 0.525731,  0.000000,  0.850651, ..
	 0.295242,  0.000000,  0.955423, ..
	 0.442863,  0.238856,  0.864188, .. 
	 0.162460,  0.262866,  0.951056, .. 
	-0.681718,  0.147621,  0.716567, .. 
	-0.809017,  0.309017,  0.500000, .. 
	-0.587785,  0.425325,  0.688191, .. 
	-0.850651,  0.525731,  0.000000, .. 
	-0.864188,  0.442863,  0.238856, .. 
	-0.716567,  0.681718,  0.147621, .. 
	-0.688191,  0.587785,  0.425325, .. 
	-0.500000,  0.809017,  0.309017, .. 
	-0.238856,  0.864188,  0.442863, .. 
	-0.425325,  0.688191,  0.587785, .. 
	-0.716567,  0.681718, -0.147621, .. 
	-0.500000,  0.809017, -0.309017, .. 
	-0.525731,  0.850651,  0.000000, .. 
	 0.000000,  0.850651, -0.525731, .. 
	-0.238856,  0.864188, -0.442863, .. 
	 0.000000,  0.955423, -0.295242, .. 
	-0.262866,  0.951056, -0.162460, .. 
	 0.000000,  1.000000,  0.000000, .. 
	 0.000000,  0.955423,  0.295242, .. 
	-0.262866,  0.951056,  0.162460, .. 
	 0.238856,  0.864188,  0.442863, .. 
	 0.262866,  0.951056,  0.162460, .. 
	 0.500000,  0.809017,  0.309017, .. 
	 0.238856,  0.864188, -0.442863, .. 
	 0.262866,  0.951056, -0.162460, .. 
	 0.500000,  0.809017, -0.309017, .. 
	 0.850651,  0.525731,  0.000000, .. 
	 0.716567,  0.681718,  0.147621, .. 
	 0.716567,  0.681718, -0.147621, .. 
	 0.525731,  0.850651,  0.000000, .. 
	 0.425325,  0.688191,  0.587785, .. 
	 0.864188,  0.442863,  0.238856, .. 
	 0.688191,  0.587785,  0.425325, .. 
	 0.809017,  0.309017,  0.500000, .. 
	 0.681718,  0.147621,  0.716567, .. 
	 0.587785,  0.425325,  0.688191, .. 
	 0.955423,  0.295242,  0.000000, .. 
	 1.000000,  0.000000,  0.000000, .. 
	 0.951056,  0.162460,  0.262866, .. 
	 0.850651, -0.525731,  0.000000, .. 
	 0.955423, -0.295242,  0.000000, .. 
	 0.864188, -0.442863,  0.238856, .. 
	 0.951056, -0.162460,  0.262866, .. 
	 0.809017, -0.309017,  0.500000, .. 
	 0.681718, -0.147621,  0.716567, .. 
	 0.850651,  0.000000,  0.525731, .. 
	 0.864188,  0.442863, -0.238856, .. 
	 0.809017,  0.309017, -0.500000, .. 
	 0.951056,  0.162460, -0.262866, .. 
	 0.525731,  0.000000, -0.850651, .. 
	 0.681718,  0.147621, -0.716567, .. 
	 0.681718, -0.147621, -0.716567, .. 
	 0.850651,  0.000000, -0.525731, .. 
	 0.809017, -0.309017, -0.500000, .. 
	 0.864188, -0.442863, -0.238856, .. 
	 0.951056, -0.162460, -0.262866, .. 
	 0.147621,  0.716567, -0.681718, .. 
	 0.309017,  0.500000, -0.809017, .. 
	 0.425325,  0.688191, -0.587785, .. 
	 0.442863,  0.238856, -0.864188, .. 
	 0.587785,  0.425325, -0.688191, .. 
	 0.688191,  0.587785, -0.425325, .. 
	-0.147621,  0.716567, -0.681718, .. 
	-0.309017,  0.500000, -0.809017, .. 
	 0.000000,  0.525731, -0.850651, .. 
	-0.525731,  0.000000, -0.850651, .. 
	-0.442863,  0.238856, -0.864188, .. 
	-0.295242,  0.000000, -0.955423, .. 
	-0.162460,  0.262866, -0.951056, .. 
	 0.000000,  0.000000, -1.000000, .. 
	 0.295242,  0.000000, -0.955423, .. 
	 0.162460,  0.262866, -0.951056, .. 
	-0.442863, -0.238856, -0.864188, .. 
	-0.309017, -0.500000, -0.809017, .. 
	-0.162460, -0.262866, -0.951056, .. 
	 0.000000, -0.850651, -0.525731, .. 
	-0.147621, -0.716567, -0.681718, .. 
	 0.147621, -0.716567, -0.681718, .. 
	 0.000000, -0.525731, -0.850651, .. 
	 0.309017, -0.500000, -0.809017, .. 
	 0.442863, -0.238856, -0.864188, .. 
	 0.162460, -0.262866, -0.951056, .. 
	 0.238856, -0.864188, -0.442863, .. 
	 0.500000, -0.809017, -0.309017, .. 
	 0.425325, -0.688191, -0.587785, .. 
	 0.716567, -0.681718, -0.147621, .. 
	 0.688191, -0.587785, -0.425325, .. 
	 0.587785, -0.425325, -0.688191, .. 
	 0.000000, -0.955423, -0.295242, .. 
	 0.000000, -1.000000,  0.000000, .. 
	 0.262866, -0.951056, -0.162460, .. 
	 0.000000, -0.850651,  0.525731, .. 
	 0.000000, -0.955423,  0.295242, .. 
	 0.238856, -0.864188,  0.442863, .. 
	 0.262866, -0.951056,  0.162460, .. 
	 0.500000, -0.809017,  0.309017, .. 
	 0.716567, -0.681718,  0.147621, .. 
	 0.525731, -0.850651,  0.000000, .. 
	-0.238856, -0.864188, -0.442863, .. 
	-0.500000, -0.809017, -0.309017, .. 
	-0.262866, -0.951056, -0.162460, .. 
	-0.850651, -0.525731,  0.000000, .. 
	-0.716567, -0.681718, -0.147621, .. 
	-0.716567, -0.681718,  0.147621, .. 
	-0.525731, -0.850651,  0.000000, .. 
	-0.500000, -0.809017,  0.309017, .. 
	-0.238856, -0.864188,  0.442863, .. 
	-0.262866, -0.951056,  0.162460, .. 
	-0.864188, -0.442863,  0.238856, .. 
	-0.809017, -0.309017,  0.500000, .. 
	-0.688191, -0.587785,  0.425325, .. 
	-0.681718, -0.147621,  0.716567, .. 
	-0.442863, -0.238856,  0.864188, .. 
	-0.587785, -0.425325,  0.688191, .. 
	-0.309017, -0.500000,  0.809017, .. 
	-0.147621, -0.716567,  0.681718, .. 
	-0.425325, -0.688191,  0.587785, .. 
	-0.162460, -0.262866,  0.951056, .. 
	 0.442863, -0.238856,  0.864188, .. 
	 0.162460, -0.262866,  0.951056, .. 
	 0.309017, -0.500000,  0.809017, .. 
	 0.147621, -0.716567,  0.681718, .. 
	 0.000000, -0.525731,  0.850651, .. 
	 0.425325, -0.688191,  0.587785, .. 
	 0.587785, -0.425325,  0.688191, .. 
	 0.688191, -0.587785,  0.425325, .. 
	-0.955423,  0.295242,  0.000000, .. 
	-0.951056,  0.162460,  0.262866, .. 
	-1.000000,  0.000000,  0.000000, .. 
	-0.850651,  0.000000,  0.525731, .. 
	-0.955423, -0.295242,  0.000000, .. 
	-0.951056, -0.162460,  0.262866, .. 
	-0.864188,  0.442863, -0.238856, .. 
	-0.951056,  0.162460, -0.262866, .. 
	-0.809017,  0.309017, -0.500000, .. 
	-0.864188, -0.442863, -0.238856, .. 
	-0.951056, -0.162460, -0.262866, .. 
	-0.809017, -0.309017, -0.500000, .. 
	-0.681718,  0.147621, -0.716567, .. 
	-0.681718, -0.147621, -0.716567, .. 
	-0.850651,  0.000000, -0.525731, .. 
	-0.688191,  0.587785, -0.425325, .. 
	-0.587785,  0.425325, -0.688191, .. 
	-0.425325,  0.688191, -0.587785, .. 
	-0.425325, -0.688191, -0.587785, .. 
	-0.587785, -0.425325, -0.688191, .. 
	-0.688191, -0.587785, -0.425325]
	
	Function LoadMD2:TMesh( url:Object, parent_ent:TEntity=Null )
		Local file:TStream = LittleEndianStream(ReadFile(url))
		If file = Null
			DebugLog " Invalid MD2 stream: "+String(url)
			Return Null
		EndIf
		
		Local mesh:TMesh = LoadMD2FromStream(file, url, parent_ent)
		
		CloseStream file
		Return mesh
	End Function
	
	Function LoadMD2FromStream:TMesh( file:TStream,url:Object,parent_ent:TEntity=Null )
		Local magic:Int=ReadInt(file)
		If magic<>844121161 ' "IDP2"
			DebugLog " Invalid MD2 file: "+String(url)
			Return Null
		EndIf
		
		Local version:Int=ReadInt(file)
		If version<>8
			DebugLog " Invalid MD2 version: "+version
		EndIf
		
		Local mesh:TMesh=NewMesh()
		mesh.SetString(mesh.class_name, "Mesh")
		mesh.AddParent(parent_ent)
		mesh.EntityListAdd(TEntity.entity_list)
		
		Local skinwidth:Int=ReadInt(file) ' tex width
		Local skinheight:Int=ReadInt(file) ' tex height
		Local framesize:Int=ReadInt(file) ' memory for vertices
		Local num_skins:Int=ReadInt(file) ' tex versions (red/blue team)
		Local num_vertices:Int=ReadInt(file)
		Local num_st:Int=ReadInt(file) ' texture coords
		Local num_tris:Int=ReadInt(file) ' triangles
		Local num_glcmds:Int=ReadInt(file) ' number of GL commands
		Local num_frames:Int=ReadInt(file) ' keyframes
		Local offset_skins:Int=ReadInt(file) ' data offsets
		Local offset_st:Int=ReadInt(file)
		Local offset_tris:Int=ReadInt(file)
		Local offset_frames:Int=ReadInt(file)
		Local offset_glcmds:Int=ReadInt(file)
		Local offset_end:Int=ReadInt(file)
		
		Local skin:String[num_skins]
		Local frames:TMD2Frame[]=New TMD2Frame[num_frames]
		Local tris:TMD2Triangle[]=New TMD2Triangle[num_tris]
		Local coords:TMD2TexCoords[]=New TMD2TexCoords[num_st]
		
		If TGlobal3D.Log_MD2 Then DebugLog(" skinwidth: "+skinwidth)
		If TGlobal3D.Log_MD2 Then DebugLog(" skinheight: "+skinheight)
		If TGlobal3D.Log_MD2 Then DebugLog(" framesize: "+framesize)
		If TGlobal3D.Log_MD2 Then DebugLog(" num_skins: "+num_skins)
		If TGlobal3D.Log_MD2 Then DebugLog(" num_vertices: "+num_vertices)
		If TGlobal3D.Log_MD2 Then DebugLog(" num_st: "+num_st)
		If TGlobal3D.Log_MD2 Then DebugLog(" num_tris: "+num_tris)
		If TGlobal3D.Log_MD2 Then DebugLog(" num_frames: "+num_frames)
		If TGlobal3D.Log_MD2 Then DebugLog(" offset_skins: "+offset_skins)
		If TGlobal3D.Log_MD2 Then DebugLog(" offset_st: "+offset_st)
		If TGlobal3D.Log_MD2 Then DebugLog(" offset_tris: "+offset_tris)
		If TGlobal3D.Log_MD2 Then DebugLog(" offset_frames: "+offset_frames)
		
		Local surf:TSurface=mesh.CreateSurface()
		surf.no_verts[0]=num_vertices
		surf.vert_tex_coords0=surf.SurfaceFloatArrayResize(SURFACE_vert_tex_coords0, num_vertices*2)
		surf.vert_tex_coords1=surf.SurfaceFloatArrayResize(SURFACE_vert_tex_coords1, num_vertices*2)
		surf.vert_col=surf.SurfaceFloatArrayResize(SURFACE_vert_col, num_vertices*4)
		
		Local anim_surf:TSurface=mesh.NewSurface()
		mesh.MeshListAdd(mesh.anim_surf_list, anim_surf)
		anim_surf.no_verts[0]=surf.no_verts[0]
		anim_surf.vert_coords=anim_surf.SurfaceFloatArrayResize(SURFACE_vert_coords, num_vertices*3)
		
		SeekStream(file, offset_skins)
		
		For Local i:Int=0 Until num_skins
			skin[i]=ReadString(file, 64)
		Next
		
		SeekStream(file, offset_st)
		
		For Local i:Int=0 Until num_st
			coords[i]=New TMD2TexCoords
			coords[i].u=Float(ReadShort(file))/Float(skinwidth)
			coords[i].v=Float(ReadShort(file))/Float(skinheight)
		Next
		
		SeekStream(file, offset_tris)
		
		For Local i:Int=0 Until num_tris
			tris[i]=New TMD2Triangle
			tris[i].v0=ReadShort(file)
			tris[i].v1=ReadShort(file)
			tris[i].v2=ReadShort(file)
			tris[i].t0=ReadShort(file)
			tris[i].t1=ReadShort(file)
			tris[i].t2=ReadShort(file)
			
			surf.AddTriangle(tris[i].v2, tris[i].v1, tris[i].v0) ' reverse winding order
			
			surf.VertexTexCoords(tris[i].v0, coords[tris[i].t0].u, coords[tris[i].t0].v)
			surf.VertexTexCoords(tris[i].v1, coords[tris[i].t1].u, coords[tris[i].t1].v)
			surf.VertexTexCoords(tris[i].v2, coords[tris[i].t2].u, coords[tris[i].t2].v)
		Next
		
		SeekStream(file, offset_frames)
		
		For Local i:Int=0 Until num_frames
			frames[i]=New TMD2Frame
			frames[i].sx=ReadFloat(file)
			frames[i].sy=ReadFloat(file)
			frames[i].sz=ReadFloat(file)
			frames[i].tx=ReadFloat(file)
			frames[i].ty=ReadFloat(file)
			frames[i].tz=ReadFloat(file)
			
			frames[i].name=Trim( ReadString(file, 16) )
			If i=0 Then mesh.SetString(mesh.name, frames[i].name)
			
			If TGlobal3D.Log_MD2 Then DebugLog(" frames["+i+"].name: "+frames[i].name)
			If TGlobal3D.Log_MD2 Then DebugLog(" scale: "+frames[i].sx+", "+frames[i].sy+", "+frames[i].sz)
			If TGlobal3D.Log_MD2 Then DebugLog(" trans: "+frames[i].tx+", "+frames[i].ty+", "+frames[i].tz)
			
			frames[i].verts=New TMD2Vertex[num_vertices]
			For Local v:Int=0 Until num_vertices
				frames[i].verts[v]=New TMD2Vertex
				frames[i].verts[v].x=Float(ReadByte(file)) * frames[i].sx + frames[i].tx
				frames[i].verts[v].y=Float(ReadByte(file)) * frames[i].sy + frames[i].ty
				frames[i].verts[v].z=Float(ReadByte(file)) * frames[i].sz + frames[i].tz
				frames[i].verts[v].normalindex=ReadByte(file)
				
				'If TGlobal3D.Log_MD2 And v=0 Then DebugLog(" v[0]: "+frames[i].verts[v].x+", "+frames[i].verts[v].y+", "+frames[i].verts[v].z+", ni="+frames[i].verts[v].normalindex)
				
				TGlobal3D.Matrix_MD2.TransformVec(frames[i].verts[v].x, frames[i].verts[v].y, frames[i].verts[v].z, 1) ' transform by LoaderMatrix
				
				surf.SurfaceFloatArrayAdd(SURFACE_vert_coords, frames[i].verts[v].x) ' AddVertex
				surf.SurfaceFloatArrayAdd(SURFACE_vert_coords, frames[i].verts[v].y)
				surf.SurfaceFloatArrayAdd(SURFACE_vert_coords, -frames[i].verts[v].z) ' invert z for ogl
				
				surf.SurfaceFloatArrayAdd(SURFACE_vert_norm, md2_anorms[frames[i].verts[v].normalindex+2]) ' add normal
				surf.SurfaceFloatArrayAdd(SURFACE_vert_norm, md2_anorms[frames[i].verts[v].normalindex+1])
				surf.SurfaceFloatArrayAdd(SURFACE_vert_norm, -md2_anorms[frames[i].verts[v].normalindex]) ' invert z for ogl
			Next
			
			anim_surf.SurfaceFloatArrayAdd(SURFACE_vert_weight4, i)
		Next
		
		If num_frames>1 Then mesh.anim[0]=2
		mesh.anim_seqs_first[0]=0
		mesh.anim_seqs_last[0]=num_frames-1
		mesh.no_surfs[0]=-1
		
		If TGlobal3D.Log_MD2 Then DebugLog("")
		Return mesh
	End Function
		
End Type
