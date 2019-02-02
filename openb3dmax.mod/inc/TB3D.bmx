' TB3D.bmx
' B3D loader from Minib3d (by Simon Harrison)

Type TB3D

	Global filepath$
	
	Function LoadAnimB3D:TMesh( url:Object,parent_ent_ext:TEntity=Null )
	
		' Start file reading
		Local file:TStream=LittleEndianStream(ReadFile(url)) 'ReadStream("littleendian::"+url)
		If file=Null
			DebugLog " Invalid B3D stream: "+String(url)
			Return Null
		EndIf
		
		Local mesh:TMesh=LoadAnimB3DFromStream(file, url, parent_ent_ext)
		
		CloseStream file
		Return mesh
		
	End Function
	
	Function LoadAnimB3DFromStream:TMesh( file:TStream,url:Object,parent_ent_ext:TEntity=Null )
	
		' get current dir - we'll change it back at end of func
		Local cd$=CurrentDir()
		Local dir$=String(url) 'f_name
		filepath = ExtractDir(String(url))
		
		' get directory of b3d file name, set current dir to match it so we can find textures
		Local in:Int=0
		While Instr(dir, "\", in+1)<>0
			in=Instr(dir, "\", in+1)
		Wend
		While Instr(dir, "/", in+1)<>0
			in=Instr(dir, "/", in+1)
		Wend
		If in<>0 Then dir=Left(dir, in-1)
		If filepath<>"" Then ChangeDir(filepath)
		
		' Header info
		Local tag$
		Local prev_tag$
		Local new_tag$
		tag=ReadTag(file)
		ReadLong(file)
		Local vno:Int=ReadInt(file)
		If tag<>"BB3D"
			DebugLog " Invalid B3D file: "+dir
			Return Null
		EndIf
		If vno/100>0
			DebugLog " Invalid B3D version: "+vno
			Return Null
		EndIf
		If TGlobal.Log_B3D Then DebugLog(" Dir="+dir+" file.size="+ file.Size())
		
		' Locals
		Local size:Int=0, node_level:Int=-1, old_node_level:Int=-1
		Local node_pos:Int[100]
		Local info$, tab$, old_tag$
		' tex local vars
		Local tex_no:Int=0
		Local tex:TTexture[1]
		Local te_file$
		Local te_flags:Int=0, te_blend:Int=0, te_coords:Int=0
		Local te_u_pos#=0, te_v_pos#=0, te_u_scale#=0, te_v_scale#=0, te_angle#=0
		' brush local vars
		Local brush_no:Int=0, b_no_texs:Int=0
		Local brush:TBrush[1]
		Local b_name$
		Local b_red#=0, b_green#=0, b_blue#=0, b_alpha#=0, b_shine#=0
		Local b_blend:Int=0, b_fx:Int=0, b_tex_id:Int=0
		' node local vars
		Local n_name$=""
		Local n_px#=0, n_py#=0, n_pz#=0
		Local n_sx#=0, n_sy#=0, n_sz#=0
		'Local n_rx#=0, n_ry#=0, n_rz#=0
		Local n_qw#=0, n_qx#=0, n_qy#=0, n_qz#=0
		' mesh local vars
		Local mesh:TMesh
		Local m_brush_id:Int=0
		' verts local vars
		Local v_mesh:TMesh
		Local v_surf:TSurface
		Local v_flags:Int=0, v_tc_sets:Int=0, v_tc_size:Int=0, v_sz:Int=0
		Local v_x#=0, v_y#=0, v_z#=0
		Local v_nx#=0, v_ny#=0, v_nz#=0
		Local v_r#=0, v_g#=0, v_b#=0, v_a#=0
		Local v_u#=0, v_v#=0, v_w#=0	
		Local v_id:Int=0
		' tris local vars
		Local surf:TSurface
		Local tr_brush_id:Int=0, tr_sz:Int=0, tr_no:Int=0
		Local tr_vid:Int=0, tr_vid0:Int=0, tr_vid1:Int=0, tr_vid2:Int=0
		Local tr_x#=0, tr_y#=0, tr_z#=0
		Local tr_nx#=0, tr_ny#=0, tr_nz#=0
		Local tr_r#=0, tr_g#=0, tr_b#=0, tr_a#=0
		Local tr_u#=0, tr_v#=0, tr_w#=0	
		' anim local vars
		Local a_flags:Int=0, a_frames:Int=0, a_fps:Int=0
		' bone local vars
		Local bo_bone:TBone
		Local bo_no_bones:Int=0, bo_vert_id:Int=0
		Local bo_vert_w#=0
		' key local vars	
		Local k_flags:Int=0, k_frame:Int=0
		Local k_px#=0, k_py#=0, k_pz#=0
		Local k_sx#=0, k_sy#=0, k_sz#=0
		Local k_qw#=0, k_qx#=0, k_qy#=0, k_qz#=0
		' entities
		Local root_ent:TEntity=Null
		Local parent_ent:TEntity=Null ' keeps track of model parent entities (not external parent_ent_ext)
		Local last_ent:TEntity=Null ' last created entity, used for assigning parent ent in node code
		
		' Begin chunk (tag) reading
		Repeat
			new_tag=ReadTag(file)
			
			If NewTag(new_tag)=True
				
				prev_tag=tag
				tag=new_tag
				ReadInt(file)
				size=ReadInt(file)
				'If TGlobal.Log_B3D Then DebugLog(" new_tag="+new_tag+" size="+size+" pos="+StreamPos(file))
				
				' deal with nested nodes
				old_node_level=node_level
				
				If tag="NODE"
					node_level=node_level+1
					
					If node_level>0
						Local fd:Int=0
						
						Repeat
							fd=StreamPos(file)-node_pos[node_level-1]
							If fd=>8
								node_level=node_level-1
							EndIf
						Until fd<8
					EndIf
					
					node_pos[node_level]=StreamPos(file)+size
				EndIf
				
				' up level
				If node_level>old_node_level
				
					If node_level>0
						parent_ent=last_ent
					Else
						parent_ent=Null
					EndIf
					
				EndIf
				
				' down level
				If node_level<old_node_level
					Local tent:TEntity=root_ent
					
					' get parent entity of last entity of new node level
					If node_level>1 And tent<>Null
						Local cc:Int
						For Local levs:Int=1 To node_level-2
							cc=tent.CountChildren()
							If cc>0 Then tent=tent.GetChild(cc)
						Next
						
						cc=tent.CountChildren()
						tent=tent.GetChild(cc)
						parent_ent=tent
					EndIf
					
					If node_level=1 Then parent_ent=root_ent
					If node_level=0 Then parent_ent=Null
				EndIf
				
				' output debug tree
				info=""
				If tag="NODE" And parent_ent<>Null Then info=" (parent="+parent_ent.EntityName()+")"
				
				tab=""
				For Local i:Int=0 To node_level
					tab=tab+"- "
				Next
				
			Else
				tag=""
			EndIf
			
			Select tag
			
				Case "TEXS"
				
					'Local tex_no=0 ' moved to top
					old_tag=new_tag
					new_tag=ReadTag(file)
					
					While NewTag(new_tag)<>True And Eof(file)=0
					
						te_file=b3dReadString(file)
						te_flags=ReadInt(file)
						te_blend=ReadInt(file)
						te_u_pos=ReadFloat(file)
						te_v_pos=ReadFloat(file)
						te_u_scale=ReadFloat(file)
						te_v_scale=ReadFloat(file)
						te_angle=ReadFloat(file)
						
						If TGlobal.Log_B3D Then DebugLog(" "+tab+old_tag+" file="+te_file+" flags="+te_flags+" blend="+te_blend+" tex_no="+tex_no)
						
						' hidden tex coords 1 flag
						If (te_flags & 65536)
							te_flags=te_flags ~ 65536
							te_coords=1
						Else
							te_coords=0
						EndIf
						
						' convert tex angle from rad to deg
						te_angle=te_angle*(180.0/Pi)
						
						' *todo* - Load tex after setting values
						' create texture object so we can set texture values before loading texture
						tex[tex_no]=NewTexture()
						
						' .flags and .file set in LoadTexture
						tex[tex_no].blend[0]=te_blend
						tex[tex_no].coords[0]=te_coords
						tex[tex_no].u_pos[0]=te_u_pos
						tex[tex_no].v_pos[0]=te_v_pos
						tex[tex_no].u_scale[0]=te_u_scale
						tex[tex_no].v_scale[0]=te_v_scale
						tex[tex_no].angle[0]=te_angle
						
						' load texture, providing texture we created above as parameter.
						' if a texture exists with all the same values as above (blend etc)
						' the existing texture will be returned. if not then the texture
						' created above (supplied as param below) will be returned
						Local tex_name$=StripDir(te_file)
						If dir.StartsWith("incbin::") Or dir.StartsWith("zip::")
							tex_name=filepath+"/"+StripDir(te_file)
						EndIf
						
						If te_file<>"" Then tex[tex_no]=LoadTexture(tex_name, te_flags, tex[tex_no]) ' wrong path crashes streams
						If TGlobal.Log_B3D And tex[tex_no]<>Null Then DebugLog(" "+tab+new_tag+" tex_name="+tex_name+" flags="+tex[tex_no].flags[0])
						
						tex_no=tex_no+1
						tex=tex[..tex_no+1] ' resize array +1
						
						new_tag=ReadTag(file)
					Wend
					
				Case "BRUS"
				
					'Local brush_no=0 ' moved to top
					b_no_texs=ReadInt(file)
					old_tag=new_tag
					new_tag=ReadTag(file)
					
					While NewTag(new_tag)<>True And Eof(file)=0
					
						b_name=b3dReadString(file)
						b_red=ReadFloat(file)
						b_green=ReadFloat(file)
						b_blue=ReadFloat(file)
						b_alpha=ReadFloat(file)
						b_shine=ReadFloat(file)
						b_blend=ReadInt(file)
						b_fx=ReadInt(file)
						
						brush[brush_no]=CreateBrush()
						brush[brush_no].no_texs[0]=b_no_texs
						brush[brush_no].SetString(brush[brush_no].name, b_name)
						brush[brush_no].red[0]=b_red
						brush[brush_no].green[0]=b_green
						brush[brush_no].blue[0]=b_blue
						brush[brush_no].alpha[0]=b_alpha
						brush[brush_no].shine[0]=b_shine
						brush[brush_no].blend[0]=b_blend
						brush[brush_no].fx[0]=b_fx
						
						If TGlobal.Log_B3D Then DebugLog(" "+tab+old_tag+" name="+b_name+" blend="+b_blend+" fx="+b_fx+" b_no_texs="+b_no_texs)
						
						For Local ix:Int=0 To b_no_texs-1
							b_tex_id=ReadInt(file)
							
							If b_tex_id>=0 And tex[b_tex_id]<>Null ' valid id and texture
								brush[brush_no].BrushTexture(tex[b_tex_id], 0, ix)
								
								If (tex[b_tex_id].flags[0] & 2) And (brush[brush_no].fx[0] & 16)
									brush[brush_no].BrushFX(brush[brush_no].fx[0] | 32) ' transparency for brush alpha tex
								EndIf
								
								If TGlobal.Log_B3D Then DebugLog(" "+tab+old_tag+" brush_no="+brush_no+" b_tex_id="+b_tex_id+" ix="+ix+" flags="+tex[b_tex_id].flags[0])
							Else
								brush[brush_no].tex[ix]=Null
							EndIf
						Next
						brush_no=brush_no+1
						brush=brush[..brush_no+1] ' resize array +1
						
						new_tag=ReadTag(file)
					Wend
					
				Case "NODE"
				
					old_tag=new_tag
					new_tag=ReadTag(file)
					
					n_name=b3dReadString(file)
					n_px=ReadFloat(file)
					n_py=ReadFloat(file)
					n_pz=ReadFloat(file)*-1.0
					n_sx=ReadFloat(file)
					n_sy=ReadFloat(file)
					n_sz=ReadFloat(file)
					n_qw=ReadFloat(file)
					n_qx=ReadFloat(file)
					n_qy=ReadFloat(file)
					n_qz=ReadFloat(file)
					
					'Local pitch#=0
					'Local yaw#=0
					'Local roll#=0
					'TQuaternion.QuatToEuler(n_qw, n_qx, n_qy, -n_qz, pitch, yaw, roll)
					'n_rx=-pitch
					'n_ry=yaw
					'n_rz=roll
					
					new_tag=ReadTag(file)
					
					If TGlobal.Log_B3D Then DebugLog(" "+tab+old_tag+" name="+n_name+info)
					
					If new_tag="NODE" Or new_tag="ANIM"
					
						' make 'piv' entity a mesh, not a pivot, as B3D does
						Local piv:TMesh=NewMesh()
						piv.SetString(piv.class_name, "Mesh")
						piv.SetString(piv.name, n_name)
						piv.px[0]=n_px
						piv.py[0]=n_py
						piv.pz[0]=n_pz
						piv.sx[0]=n_sx
						piv.sy[0]=n_sy
						piv.sz[0]=n_sz
						piv.qw[0]=n_qw
						piv.qx[0]=n_qx
						piv.qy[0]=n_qy
						piv.qz[0]=n_qz
						
						'piv.UpdateMat(True)
						piv.EntityListAdd(TEntity.entity_list)
						last_ent=piv
						
						' root ent?
						If root_ent=Null Then root_ent=piv
						
						' if ent is root ent, and external parent specified, add parent
						If root_ent=piv Then piv.AddParent(parent_ent_ext)
						
						' if ent nested then add parent
						If node_level>0 Then piv.AddParent(parent_ent)
						
						TQuaternion.QuatToMat(-n_qw, n_qx, n_qy, -n_qz, piv.mat)
						
						piv.mat.grid[(4*3)+0]=n_px
						piv.mat.grid[(4*3)+1]=n_py
						piv.mat.grid[(4*3)+2]=n_pz
						
						piv.mat.Scale(n_sx, n_sy, n_sz)
						
						If piv.parent<>Null
							Local new_mat:TMatrix=piv.parent.mat.Copy()
							new_mat.Multiply(piv.mat)
							piv.mat.Overwrite(new_mat)
						EndIf
						
					EndIf
					
				Case "MESH"
				
					m_brush_id=ReadInt(file)
					
					If TGlobal.Log_B3D Then DebugLog(" "+tab+new_tag+" brush_id="+m_brush_id)
					
					mesh=NewMesh()
					mesh.SetString(mesh.class_name, "Mesh")
					mesh.SetString(mesh.name, n_name)
					mesh.px[0]=n_px
					mesh.py[0]=n_py
					mesh.pz[0]=n_pz
					mesh.sx[0]=n_sx
					mesh.sy[0]=n_sy
					mesh.sz[0]=n_sz
					mesh.qw[0]=n_qw
					mesh.qx[0]=n_qx
					mesh.qy[0]=n_qy
					mesh.qz[0]=n_qz
					
					mesh.EntityListAdd(TEntity.entity_list)
					last_ent=mesh
					
					' root ent?
					If root_ent=Null Then root_ent=mesh
					
					' if ent is root ent, and external parent specified, add parent
					If root_ent=mesh Then mesh.AddParent(parent_ent_ext)
					
					' if ent nested then add parent
					If node_level>0 Then mesh.AddParent(parent_ent)
					
					TQuaternion.QuatToMat(-n_qw, n_qx, n_qy, -n_qz, mesh.mat)
					
					mesh.mat.grid[(4*3)+0]=n_px
					mesh.mat.grid[(4*3)+1]=n_py
					mesh.mat.grid[(4*3)+2]=n_pz
					
					mesh.mat.Scale(n_sx, n_sy, n_sz)
					
					If mesh.parent<>Null
						Local new_mat:TMatrix=mesh.parent.mat.Copy()
						new_mat.Multiply(mesh.mat)
						mesh.mat.Overwrite(new_mat)
					EndIf
					
				Case "VRTS"
				
					If v_mesh<>Null Then v_mesh=Null
					If v_surf<>Null Then v_surf=Null
					
					v_mesh=NewMesh()
					v_surf=v_mesh.CreateSurface()
					v_flags=ReadInt(file)
					v_tc_sets=ReadInt(file)
					v_tc_size=ReadInt(file)
					
					If TGlobal.Log_B3D Then DebugLog(" "+tab+new_tag+" flags="+v_flags+" tc_sets="+v_tc_sets+" tc_size="+v_tc_size)
					
					v_sz=12+v_tc_sets*v_tc_size*4
					If (v_flags & 1) Then v_sz=v_sz+12
					If (v_flags & 2) Then v_sz=v_sz+16
					
					new_tag=ReadTag(file)
					
					While NewTag(new_tag)<>True And Eof(file)=0
					
						v_x=ReadFloat(file)
						v_y=ReadFloat(file)
						v_z=ReadFloat(file)
						
						If (v_flags & 1) ' normals
							v_nx=ReadFloat(file)
							v_ny=ReadFloat(file)
							v_nz=ReadFloat(file)
						EndIf
						
						If (v_flags & 2) ' rgba colors
							v_r=ReadFloat(file)*255.0 ' VertexColor rgb require 0-255 values
							v_g=ReadFloat(file)*255.0
							v_b=ReadFloat(file)*255.0
							v_a=ReadFloat(file)
						EndIf
						
						v_id=v_surf.AddVertex(v_x, v_y, v_z) ' inverts z
						v_surf.VertexNormal(v_id, v_nx, v_ny, v_nz)
						v_surf.VertexColor(v_id, v_r, v_g, v_b, v_a)
						
						' read texture coords per vertex: 1 for simple uv, 8 max
						For Local j:Int=0 To v_tc_sets-1
							For Local k:Int=1 To v_tc_size ' components per set: 2 for simple uv, 4 max
								If k=1 Then v_u=ReadFloat(file)
								If k=2 Then v_v=ReadFloat(file)
								If k=3 Then v_w=ReadFloat(file)
							Next
							
							If j=0 Or j=1
								v_surf.VertexTexCoords(v_id, v_u, v_v, v_w, j)
								If TGlobal.Log_B3D And v_id=0 Then DebugLog(" VRTS[0]: u="+v_u+" v="+v_v+" cset="+j+" nsets="+v_tc_sets)
							EndIf
						Next
						
						new_tag=ReadTag(file)
					Wend
					
				Case "TRIS"
				
					Local old_tr_brush_id:Int=tr_brush_id
					tr_brush_id=ReadInt(file)
					
					If TGlobal.Log_B3D Then DebugLog(" "+tab+old_tag+" tr_brush_id="+tr_brush_id)
					
					' don't create new surface if tris chunk has same brush as chunk immediately before it
					If prev_tag<>"TRIS" Or tr_brush_id<>old_tr_brush_id
					
						' no further tri data for this surf - trim verts
						If prev_tag="TRIS" Then TrimVerts(surf)
						
						' new surf - copy arrays
						surf=mesh.CreateSurface()
						
						surf.vert_coords=surf.SurfaceFloatArrayCopy(SURFACE_vert_coords, v_surf)
						surf.vert_norm=surf.SurfaceFloatArrayCopy(SURFACE_vert_norm, v_surf)
						surf.vert_tex_coords0=surf.SurfaceFloatArrayCopy(SURFACE_vert_tex_coords0, v_surf)
						surf.vert_tex_coords1=surf.SurfaceFloatArrayCopy(SURFACE_vert_tex_coords1, v_surf)
						surf.vert_col=surf.SurfaceFloatArrayCopy(SURFACE_vert_col, v_surf)
						
						surf.no_verts[0]=v_surf.no_verts[0]
					EndIf
					
					tr_sz=12
					old_tag=new_tag
					new_tag=ReadTag(file)
					
					While NewTag(new_tag)<>True And Eof(file)=0
					
						tr_vid0=ReadInt(file)
						tr_vid1=ReadInt(file)
						tr_vid2=ReadInt(file)
						
						' find out minimum and maximum vertex indices - used for TrimVerts func after
						' (TrimVerts used due to .b3d format not being an exact fit with Blitz3D itself)
						If tr_vid0<surf.vmin[0] Then surf.vmin[0]=tr_vid0
						If tr_vid1<surf.vmin[0] Then surf.vmin[0]=tr_vid1
						If tr_vid2<surf.vmin[0] Then surf.vmin[0]=tr_vid2
						
						If tr_vid0>surf.vmax[0] Then surf.vmax[0]=tr_vid0
						If tr_vid1>surf.vmax[0] Then surf.vmax[0]=tr_vid1
						If tr_vid2>surf.vmax[0] Then surf.vmax[0]=tr_vid2
						
						surf.AddTriangle(tr_vid0, tr_vid1, tr_vid2)
						
						new_tag=ReadTag(file)
						
					Wend
					
					If m_brush_id>-1 Then mesh.PaintEntity(brush[m_brush_id])
					If tr_brush_id>-1 Then surf.PaintSurface(brush[tr_brush_id])
					
					' if no normal data supplied and no further tri data then update normals
					If (v_flags & 1)=0 And new_tag<>"TRIS" Then mesh.UpdateNormals()
					
					' no further tri data for this surface - trim verts
					If new_tag<>"TRIS" Then TrimVerts(surf)
					
				Case "ANIM"
					
					a_flags=ReadInt(file)
					a_frames=ReadInt(file)
					a_fps=ReadFloat(file)
					
					If TGlobal.Log_B3D Then DebugLog(" "+tab+new_tag+" flags="+a_flags+" frames="+a_frames+" fps="+a_fps)
					
					If mesh<>Null
						mesh.anim[0]=1
						
						'mesh.frames[0]=a_frames
						mesh.anim_seqs_first[0]=0
						mesh.anim_seqs_last[0]=a_frames
						
						' create anim surfs, copy vertex coords array, add to anim_surf_list
						For Local surf:TSurface=EachIn mesh.surf_list
							Local anim_surf:TSurface=mesh.NewSurface()
							mesh.MeshListAdd(mesh.anim_surf_list, anim_surf)
							
							anim_surf.no_verts[0]=surf.no_verts[0]
							
							anim_surf.vert_coords=anim_surf.SurfaceFloatArrayCopy(SURFACE_vert_coords, surf)
							
							anim_surf.vert_bone1_no=anim_surf.SurfaceIntArrayResize(SURFACE_vert_bone1_no, surf.no_verts[0]+1)
							anim_surf.vert_bone2_no=anim_surf.SurfaceIntArrayResize(SURFACE_vert_bone2_no, surf.no_verts[0]+1)
							anim_surf.vert_bone3_no=anim_surf.SurfaceIntArrayResize(SURFACE_vert_bone3_no, surf.no_verts[0]+1)
							anim_surf.vert_bone4_no=anim_surf.SurfaceIntArrayResize(SURFACE_vert_bone4_no, surf.no_verts[0]+1)
							
							anim_surf.vert_weight1=anim_surf.SurfaceFloatArrayResize(SURFACE_vert_weight1, surf.no_verts[0]+1)
							anim_surf.vert_weight2=anim_surf.SurfaceFloatArrayResize(SURFACE_vert_weight2, surf.no_verts[0]+1)
							anim_surf.vert_weight3=anim_surf.SurfaceFloatArrayResize(SURFACE_vert_weight3, surf.no_verts[0]+1)
							anim_surf.vert_weight4=anim_surf.SurfaceFloatArrayResize(SURFACE_vert_weight4, surf.no_verts[0]+1)
							
							' transfer vmin/vmax values for using with TrimVerts func after
							anim_surf.vmin[0]=surf.vmin[0]
							anim_surf.vmax[0]=surf.vmax[0]
						Next
						
					EndIf
					
				Case "BONE"
					
					Local ix:Int=0
					old_tag=new_tag
					new_tag=ReadTag(file)
					
					bo_bone=mesh.NewBone()
					bo_no_bones=bo_no_bones+1
					
					While NewTag(new_tag)<>True And Eof(file)=0
					
						bo_vert_id=ReadInt(file)
						bo_vert_w=ReadFloat(file)
						
						'If TGlobal.Log_B3D Then DebugLog(" "+tab+old_tag+" vert_id="+bo_vert_id+" weight="+bo_vert_w)
						
						' assign weight values, with the strongest weight in vert_weight[1], and weakest in vert_weight[4]
						Local anim_surf:TSurface
						For anim_surf:TSurface=EachIn mesh.anim_surf_list
							If bo_vert_id>=anim_surf.vmin[0] And bo_vert_id<=anim_surf.vmax[0]
								If anim_surf<>Null
									Local vid:Int=bo_vert_id-anim_surf.vmin[0]
									
									If bo_vert_w>anim_surf.vert_weight1[vid]
									
										anim_surf.vert_bone4_no[vid]=anim_surf.vert_bone3_no[vid]
										anim_surf.vert_weight4[vid]=anim_surf.vert_weight3[vid]
										
										anim_surf.vert_bone3_no[vid]=anim_surf.vert_bone2_no[vid]
										anim_surf.vert_weight3[vid]=anim_surf.vert_weight2[vid]
										
										anim_surf.vert_bone2_no[vid]=anim_surf.vert_bone1_no[vid]
										anim_surf.vert_weight2[vid]=anim_surf.vert_weight1[vid]
										
										anim_surf.vert_bone1_no[vid]=bo_no_bones
										anim_surf.vert_weight1[vid]=bo_vert_w
										
									Else If bo_vert_w>anim_surf.vert_weight2[vid]
									
										anim_surf.vert_bone4_no[vid]=anim_surf.vert_bone3_no[vid]
										anim_surf.vert_weight4[vid]=anim_surf.vert_weight3[vid]
										
										anim_surf.vert_bone3_no[vid]=anim_surf.vert_bone2_no[vid]
										anim_surf.vert_weight3[vid]=anim_surf.vert_weight2[vid]
										
										anim_surf.vert_bone2_no[vid]=bo_no_bones
										anim_surf.vert_weight2[vid]=bo_vert_w
										
									Else If bo_vert_w>anim_surf.vert_weight3[vid]
									
										anim_surf.vert_bone4_no[vid]=anim_surf.vert_bone3_no[vid]
										anim_surf.vert_weight4[vid]=anim_surf.vert_weight3[vid]
										
										anim_surf.vert_bone3_no[vid]=bo_no_bones
										anim_surf.vert_weight3[vid]=bo_vert_w
										
									Else If bo_vert_w>anim_surf.vert_weight4[vid]
									
										anim_surf.vert_bone4_no[vid]=bo_no_bones
										anim_surf.vert_weight4[vid]=bo_vert_w
										
									EndIf
								EndIf
							EndIf
							
						Next
						
						new_tag=ReadTag(file)
					Wend
					
					bo_bone.SetString(bo_bone.class_name, "Bone")
					bo_bone.SetString(bo_bone.name, n_name)
					bo_bone.px[0]=n_px
					bo_bone.py[0]=n_py
					bo_bone.pz[0]=n_pz
					bo_bone.sx[0]=n_sx
					bo_bone.sy[0]=n_sy
					bo_bone.sz[0]=n_sz
					bo_bone.qw[0]=n_qw
					bo_bone.qx[0]=n_qx
					bo_bone.qy[0]=n_qy
					bo_bone.qz[0]=n_qz
					
					bo_bone.n_px[0]=n_px
					bo_bone.n_py[0]=n_py
					bo_bone.n_pz[0]=n_pz
					bo_bone.n_sx[0]=n_sx
					bo_bone.n_sy[0]=n_sy
					bo_bone.n_sz[0]=n_sz
					bo_bone.n_qw[0]=n_qw
					bo_bone.n_qx[0]=n_qx
					bo_bone.n_qy[0]=n_qy
					bo_bone.n_qz[0]=n_qz
					
					bo_bone.keys=NewAnimationKeys(bo_bone)
					bo_bone.keys.frames[0]=a_frames
					
					bo_bone.keys.flags=bo_bone.keys.AnimationKeysIntArrayResize(ANIMATIONKEYS_flags, a_frames+1)
					
					bo_bone.keys.px=bo_bone.keys.AnimationKeysFloatArrayResize(ANIMATIONKEYS_px, a_frames+1)
					bo_bone.keys.py=bo_bone.keys.AnimationKeysFloatArrayResize(ANIMATIONKEYS_py, a_frames+1)
					bo_bone.keys.pz=bo_bone.keys.AnimationKeysFloatArrayResize(ANIMATIONKEYS_pz, a_frames+1)
					bo_bone.keys.sx=bo_bone.keys.AnimationKeysFloatArrayResize(ANIMATIONKEYS_sx, a_frames+1)
					bo_bone.keys.sy=bo_bone.keys.AnimationKeysFloatArrayResize(ANIMATIONKEYS_sy, a_frames+1)
					bo_bone.keys.sz=bo_bone.keys.AnimationKeysFloatArrayResize(ANIMATIONKEYS_sz, a_frames+1)
					bo_bone.keys.qw=bo_bone.keys.AnimationKeysFloatArrayResize(ANIMATIONKEYS_qw, a_frames+1)
					bo_bone.keys.qx=bo_bone.keys.AnimationKeysFloatArrayResize(ANIMATIONKEYS_qx, a_frames+1)
					bo_bone.keys.qy=bo_bone.keys.AnimationKeysFloatArrayResize(ANIMATIONKEYS_qy, a_frames+1)
					bo_bone.keys.qz=bo_bone.keys.AnimationKeysFloatArrayResize(ANIMATIONKEYS_qz, a_frames+1)
					
					' root ent?
					If root_ent=Null Then root_ent=bo_bone
					
					' if ent nested then add parent
					If node_level>0 Then bo_bone.AddParent(parent_ent)
					
					TQuaternion.QuatToMat(-bo_bone.n_qw[0], bo_bone.n_qx[0], bo_bone.n_qy[0], -bo_bone.n_qz[0], bo_bone.mat)
					
					bo_bone.mat.grid[(4*3)+0]=bo_bone.n_px[0]
					bo_bone.mat.grid[(4*3)+1]=bo_bone.n_py[0]
					bo_bone.mat.grid[(4*3)+2]=bo_bone.n_pz[0]
					
					' And... onwards needed to prevent inv_mat being incorrect if external parent supplied
					If bo_bone.parent<>Null And TBone(bo_bone.parent)<>Null
						Local new_mat:TMatrix=bo_bone.parent.mat.Copy()
						new_mat.Multiply(bo_bone.mat)
						bo_bone.mat.Overwrite(new_mat)
						new_mat=Null
					EndIf
					
					bo_bone.mat.GetInverse(bo_bone.inv_mat)
					
					If new_tag<>"KEYS"
						bo_bone.EntityListAdd(TEntity.entity_list)
						
						mesh.MeshArrayResize(MESH_bones, bo_no_bones)
						mesh.MeshArraySet(MESH_bones, bo_no_bones-1, bo_bone)
						
						last_ent=bo_bone
					EndIf
					
				Case "KEYS"
				
					old_tag=new_tag
					k_flags=ReadInt(file)
					new_tag=ReadTag(file)
					
					While NewTag(new_tag)<>True And Eof(file)=0
						k_frame=ReadInt(file)
						
						'If TGlobal.Log_B3D Then DebugLog(" "+tab+old_tag+" flags="+k_flags+" frame="+k_frame)
						
						If (k_flags & 1)
							k_px=ReadFloat(file)
							k_py=ReadFloat(file)
							k_pz=-ReadFloat(file)
						EndIf
						If (k_flags & 2)
							k_sx=ReadFloat(file)
							k_sy=ReadFloat(file)
							k_sz=ReadFloat(file)
						EndIf
						If (k_flags & 4)
							k_qw=-ReadFloat(file)
							k_qx=ReadFloat(file)
							k_qy=ReadFloat(file)
							k_qz=-ReadFloat(file)
						EndIf
						
						' check if bo_bone exists - it won't for non-boned, keyframe anims
						If bo_bone<>Null
						
							bo_bone.keys.flags[k_frame]=bo_bone.keys.flags[k_frame]+k_flags
							If (k_flags & 1)
								bo_bone.keys.px[k_frame]=k_px
								bo_bone.keys.py[k_frame]=k_py
								bo_bone.keys.pz[k_frame]=k_pz
							EndIf
							If (k_flags & 2)
								bo_bone.keys.sx[k_frame]=k_sx
								bo_bone.keys.sy[k_frame]=k_sy
								bo_bone.keys.sz[k_frame]=k_sz
							EndIf
							If (k_flags & 4)
								bo_bone.keys.qw[k_frame]=k_qw
								bo_bone.keys.qx[k_frame]=k_qx
								bo_bone.keys.qy[k_frame]=k_qy
								bo_bone.keys.qz[k_frame]=k_qz
							EndIf
							
						EndIf
						
						new_tag=ReadTag(file)
					Wend
					
					If new_tag<>"KEYS"
					
						' check if bo_bone exists - it won't for non-boned, keyframe anims
						If bo_bone<>Null
							bo_bone.EntityListAdd(TEntity.entity_list)
							
							mesh.MeshArrayResize(MESH_bones, bo_no_bones)
							mesh.MeshArraySet(MESH_bones, bo_no_bones-1, bo_bone)
							
							last_ent=bo_bone
						EndIf
						
					EndIf
					
				Default
					ReadByte(file)
			End Select
			
		Until Eof(file)=True
		
		If TGlobal.Log_B3D ' print any mesh surface info
			Local temp_list:TList=CreateList()
			If root_ent<>Null Then ListAddLast(temp_list, TMesh(root_ent))
			Local count_children%=TEntity.CountAllChildren(TMesh(root_ent))
			
			For Local child_no%=1 To count_children
				Local count%=0
				Local child:TEntity=TMesh(root_ent).GetChildFromAll(child_no, count)
				Local child_mesh:TMesh=TMesh(child)
				If child_mesh<>Null Then ListAddLast(temp_list, child)
			Next
			
			For Local child_mesh:TMesh=EachIn temp_list
				If TGlobal.Log_B3D Then DebugLog(" MESH name="+child_mesh.EntityName())
				For Local surf:TSurface = EachIn child_mesh.surf_list
					If TGlobal.Log_B3D Then DebugLog(" TRIS no_verts="+surf.no_verts[0]+" no_tris="+surf.no_tris[0])
				Next
			Next
		EndIf
		
		ChangeDir(cd)
		If TGlobal.Log_B3D Then DebugLog("")
		Return TMesh(root_ent)
		
	End Function
	
	' Due to the .b3d format not being an exact fit with B3D, we need to slice vert arrays
	' Otherwise we duplicate all vert information per surf
	Function TrimVerts( surf:TSurface )
	
		ModelTrimVerts_(TSurface.GetInstance(surf))
		
		surf.vert_coords=SurfaceFloat_(TSurface.GetInstance(surf), SURFACE_vert_coords)
		surf.vert_norm=SurfaceFloat_(TSurface.GetInstance(surf), SURFACE_vert_norm)
		surf.vert_tex_coords0=SurfaceFloat_(TSurface.GetInstance(surf), SURFACE_vert_tex_coords0)
		surf.vert_tex_coords1=SurfaceFloat_(TSurface.GetInstance(surf), SURFACE_vert_tex_coords1)
		surf.vert_col=SurfaceFloat_(TSurface.GetInstance(surf), SURFACE_vert_col)
		surf.tris=SurfaceUShort_(TSurface.GetInstance(surf), SURFACE_tris)
		
	End Function
	
	Function b3dReadString:String( file:TStream Var )
	
		Local t$=""
		Repeat
			Local ch:Int=ReadByte(file)
			If ch=0 Then Return t
			t=t+Chr(ch)
		Forever
		
	End Function
	
	Function ReadTag:String( file:TStream )
	
		Local pos:Int=StreamPos(file)
		Local tag$=""
		
		For Local i:Int=1 To 4
			If StreamPos(file)<StreamSize(file)
				Local rb:Int=ReadByte(file)
				tag=tag+Chr(rb)
			EndIf
		Next
		
		SeekStream(file, pos)
		Return tag
		
	End Function
	
	Function NewTag:Int( tag$ )
	
		Select tag
			Case "TEXS" Return True
			Case "BRUS" Return True
			Case "NODE" Return True
			Case "ANIM" Return True
			Case "MESH" Return True
			Case "VRTS" Return True
			Case "TRIS" Return True
			Case "BONE" Return True
			Case "KEYS" Return True
			Default Return False
		End Select
		
	End Function
	
End Type
