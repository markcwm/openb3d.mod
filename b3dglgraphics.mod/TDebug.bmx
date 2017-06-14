
Rem
bbdoc: Debug functions
EndRem
Type TDebug
	
	Global cno:Int ' child no (numpad keys - + to change)
	Global surf_no:Int ' surf no (numpad keys / * to change)
	
	Global info:Int=1 ' current info page (numpad keys 1-4)
	Global show_ents:Int=True ' show/hide debug ents (key 0)
	
	' debug entities
	Global bounding_sphere:TMesh
	Global debug_mesh:TMesh
	Global debug_surf:TSurface
	Global marker:TMesh
	
	' Minib3d
	
	Function DebugWorld()
	
		Local no_ents:Int
		Local no_cams:Int
		Local no_lights:Int
		Local no_pivs:Int
		Local no_meshes:Int
		Local no_sprites:Int
		Local no_bones:Int
		
		For Local ent:TEntity=EachIn TEntity.entity_list
		
			no_ents:+1
			
			If TCamera(ent)<>Null Then no_cams:+1
			If TLight(ent)<>Null Then no_lights:+1
			If TPivot(ent)<>Null Then no_pivs:+1
			If TMesh(ent)<>Null Then no_meshes:+1
			If TSprite(ent)<>Null Then no_sprites:+1
			If TBone(ent)<>Null Then no_bones:+1	
			
		Next
		
		Text 0,120,"Entities: "+String(no_ents)
		Text 0,140,"Cameras: "+String(no_cams)
		Text 0,160,"Lights: "+String(no_lights)
		Text 0,180,"Pivots: "+String(no_pivs)
		Text 0,200,"Meshes: "+String(no_meshes)
		Text 0,220,"Sprites: "+String(no_sprites)
		Text 0,240,"Bones: "+String(no_bones)
		
	End Function
	
	Function DebugEntity:TEntity(ent:TEntity,cam:TCamera=Null)
	
		If ent=Null Then Return Null
		
		Local no_children:Int=0
		Local old_cent:TEntity=ent.GetChildFromAll(cno,no_children)
		If old_cent<>Null Then old_cent.EntityColor 255,255,255
		
		If KeyHit(KEY_NUMADD) Then cno=cno+1
		If KeyHit(KEY_NUMSUBTRACT) Then cno=cno-1
		Local no_childs:Int=TEntity.CountAllChildren(ent)
		If cno<0 Then cno=0
		If cno>no_childs Then cno=no_childs
		
		no_children=0
		Local cent:TEntity=ent.GetChildFromAll(cno,no_children)
		
		If cent=Null Then cent=ent ' if no children entity then use main entity
		
		If cent<>Null
		
			' select surface
			Local surf:TSurface
			If TMesh(cent)<>Null	
				If KeyHit(KEY_NUMDIVIDE) Then surf_no:-1
				If KeyHit(KEY_NUMMULTIPLY) Then surf_no:+1
				If surf_no<1 Then surf_no=1
				If surf_no>TMesh(cent).CountSurfaces() Then surf_no=TMesh(cent).CountSurfaces()
				surf:TSurface=GetSurface(TMesh(cent),surf_no)
			Else
				surf_no=0
				surf=Null
			EndIf
			
			If KeyHit(KEY_NUM0) Then show_ents=1-show_ents
			
			UpdateBoundingSphere(cent)
			UpdateSurface(cent,surf)
			UpdateMarker(cent,cam)
			
			If KeyHit(KEY_NUM1) Then info=1
			If KeyHit(KEY_NUM2) Then info=2
			If KeyHit(KEY_NUM3) Then info=3
			If KeyHit(KEY_NUM4) Then info=4
			If KeyHit(KEY_NUM5) Then info=5
			
			Text 0,0,"Entity: "+String(cno)+"/"+no_childs+". Name: "+cent.EntityName()+". Class: "+cent.EntityClass()
			
			If info=1 Then EntityInfo1(cent)
			If info=2 Then EntityInfo2(cent,surf)
			If info=3 Then EntityInfo3(cent,surf)
			If info=4 Then EntityInfo4(cent,cam)
			If info=5 Then EntityInfo4(cent,cam)
			
		EndIf
		
		Return cent
		
	End Function
	
	Function UpdateBoundingSphere(ent:TEntity)
	
		If bounding_sphere=Null
			bounding_sphere=TMesh.CreateSphere(16)
			bounding_sphere.EntityAlpha(0.25)
			bounding_sphere.EntityColor(255,0,0)
		EndIf
		
		If show_ents=False Or TMesh(ent)=Null
			bounding_sphere.HideEntity
			Return
		EndIf
		
		bounding_sphere.ShowEntity
		
		' use absolute value as cull_radius will be negative value if set by MeshCullRadius (manual cull)
		Local radius#=Abs(ent.cull_radius[0]) ' cull_radius
		
		' mesh centre
		Local x#=TMesh(ent).min_x[0] ' min_x
		Local y#=TMesh(ent).min_y[0] ' min_y
		Local z#=TMesh(ent).min_z[0] ' min_z
		x=x+(TMesh(ent).max_x[0]-TMesh(ent).min_x[0])/2.0 ' max_x
		y=y+(TMesh(ent).max_y[0]-TMesh(ent).min_y[0])/2.0 ' max_y
		z=z+(TMesh(ent).max_z[0]-TMesh(ent).min_z[0])/2.0 ' max_z
		
		' transform mesh centre into world space
		TEntity.TFormPoint(x,y,z,ent,Null)
		x=TEntity.TFormedX()
		y=TEntity.TFormedY()
		z=TEntity.TFormedZ()
		
		' radius - apply entity scale
		Local rx#=radius*ent.EntityScaleX(True)
		Local ry#=radius*ent.EntityScaleY(True)
		Local rz#=radius*ent.EntityScaleZ(True)
		If rx>=ry And rx>=rz
			radius=Abs(rx)
		Else If ry>=rx And ry>=rz
			radius=Abs(ry)
		Else
			radius=Abs(rz)
		EndIf
		
		bounding_sphere.PositionEntity(x,y,z,True)
		bounding_sphere.ScaleEntity(radius,radius,radius)
		
	End Function
	
	Function UpdateSurface(ent:TEntity,surf:TSurface)
	
		If debug_mesh=Null
			debug_mesh=TMesh.CreateMesh()
			debug_surf=debug_mesh.CreateSurface()
			debug_mesh.EntityColor(255,0,0)
			debug_mesh.EntityAlpha(0.5)
			'debug_mesh.ScaleMesh(1.2,1.2,1.2)
			debug_mesh.EntityOrder(-99)
		Else
			debug_surf.ClearSurface(True,True)
		EndIf
		
		If show_ents=False Or surf=Null
			debug_mesh.HideEntity
			Return
		EndIf		
		
		debug_mesh.ShowEntity
		
		For Local tri:Int=0 Until surf.CountTriangles()
		
			Local v:Int[3]
			v[0]=surf.TriangleVertex(tri,0)
			v[1]=surf.TriangleVertex(tri,1)
			v[2]=surf.TriangleVertex(tri,2)
			
			Local nv:Int[3]
			For Local i:Int=0 To 2
			
				Local vx:Float=surf.VertexX(v[i])
				Local vy:Float=surf.VertexY(v[i])
				Local vz:Float=surf.VertexZ(v[i])
				
				TEntity.TFormPoint vx,vy,vz,ent,Null
				vx=TEntity.TFormedX()
				vy=TEntity.TFormedY()
				vz=TEntity.TFormedZ()
				
				nv[i]=debug_surf.AddVertex(vx,vy,vz)
				
			Next
					
			debug_surf.AddTriangle(nv[0],nv[1],nv[2])
			
		Next
		
		debug_mesh.PositionMesh(0,0,0) ' reset bounds 
		
	End Function
	
	Function UpdateMarker(ent:TEntity,cam:TCamera)
	
		If cam=Null Then Return
		
		' mesh centre marker
		Local x#=TMesh(ent).min_x[0] ' min_x
		Local y#=TMesh(ent).min_y[0] ' min_y
		Local z#=TMesh(ent).min_z[0] ' min_z
		x=x+(TMesh(ent).max_x[0]-TMesh(ent).min_x[0])/2.0 ' max_x
		y=y+(TMesh(ent).max_y[0]-TMesh(ent).min_y[0])/2.0 ' max_y
		z=z+(TMesh(ent).max_z[0]-TMesh(ent).min_z[0])/2.0 ' max_z
		
		' transform mesh centre into world space
		TEntity.TFormPoint(x,y,z,ent,Null)
		x=TEntity.TFormedX()
		y=TEntity.TFormedY()
		z=TEntity.TFormedZ()
		
		cam.CameraProject(x,y,z)
		
		Text Int(ProjectedX()),Int(ProjectedY()),"X"
		
		' entity centre marker
		TEntity.TFormPoint(ent.EntityX(True),ent.EntityY(True),ent.EntityZ(True),ent,Null)
		x=TEntity.TFormedX()
		y=TEntity.TFormedY()
		z=TEntity.TFormedZ()
		
		cam.CameraProject(x,y,z)
		
		Text Int(ProjectedX()),Int(ProjectedY()),"O"
		
	End Function
	
	Function EntityInfo1(ent:TEntity) ' entity info
	
		'Text 0,100, "Hidden: "+ent.hidden+" Parent Hidden: "+ent.parent_hidden
		
		Text 0,40,"1. Entity Position Info"
		Text 0,80,"Global:"
		
		Local xx#=0
		
		xx=ent.EntityX(True)
		If xx<0.0001 And xx>-0.0001 Then xx=0
		Text 0,100,"X: "+String(xx)
		
		xx=ent.EntityY(True)
		If xx<0.0001 And xx>-0.0001  Then xx=0
		Text 0,120,"Y: "+String(xx)
		
		xx=ent.EntityZ(True)
		If xx<0.0001 And xx>-0.0001  Then xx=0
		Text 0,140,"Z: "+String(xx)
		
		xx=ent.EntityPitch(True)
		If xx<0.0001 And xx>-0.0001  Then xx=0
		Text 0,160,"Pitch: "+String(xx)
		
		xx=ent.EntityYaw(True)
		If xx<0.0001 And xx>-0.0001  Then xx=0
		Text 0,180,"Yaw: "+String(xx)
		
		xx=ent.EntityRoll(True)
		If xx<0.0001 And xx>-0.0001  Then xx=0
		Text 0,200,"Roll: "+String(xx)
		
		Text 0,240,"Local:"
		
		xx=ent.EntityX(False)
		If xx<0.0001 And xx>-0.0001  Then xx=0
		Text 0,260,"X: "+String(xx)
		
		xx=ent.EntityY(False)
		If xx<0.0001 And xx>-0.0001  Then xx=0
		Text 0,280,"Y: "+String(xx)
		
		xx=ent.EntityZ(False)
		If xx<0.0001 And xx>-0.0001  Then xx=0
		Text 0,300,"Z: "+String(xx)
		
		xx=ent.EntityPitch(False)
		If xx<0.0001 And xx>-0.0001  Then xx=0
		Text 0,320,"Pitch: "+String(xx)
		
		xx=ent.EntityYaw(False)
		If xx<0.0001 And xx>-0.0001  Then xx=0
		Text 0,340,"Yaw: "+String(xx)
		
		xx=ent.EntityRoll(False)
		If xx<0.0001 And xx>-0.0001  Then xx=0
		Text 0,360,"Roll: "+String(xx)
		
		Local tx:Int=0
		Local ty:Int=380
		For Local iy:Int=0 To 3
			tx=0
			ty=ty+20
			For Local ix:Int=0 To 3
				xx=ent.mat.grid[(4*ix)+iy] ' [ix,iy]
				If xx<0.0001 And xx>-0.0001 Then xx=0
				Text tx,ty,String(xx)
				tx=tx+100
			Next
		Next
		
	End Function
	
	Function EntityInfo2(ent:TEntity,surf:TSurface) ' surface info
	
		If TMesh(ent)<>Null
		
			Text 0,40,"2. Surface Info"
			
			If TSurface(surf)<>Null
			
				Text 0,80,"Surface "+surf_no+"/"+TMesh(ent).CountSurfaces()
				Text 0,100,"Vertices: "+surf.CountVertices()+"/"+TMesh(ent).CountVertices()
				Text 0,120,"Triangles: "+surf.CountTriangles()+"/"+TMesh(ent).CountTriangles()
				Text 0,160,"Alpha Enabled: "+surf.alpha_enable[0] ' alpha_enable
				Text 0,200,"Surf Vmin: "+surf.vmin[0] ' vmin
				Text 0,220,"Surf Vmax: "+surf.vmax[0] ' vmax
				
			Else
			
				Text 0,80,"No surface"
				
			EndIf
			
		Else
		
			Text 0,80, "Entity is not a mesh!"
			
		EndIf
		
	End Function
	
	Function EntityInfo3(ent:TEntity,surf:TSurface) ' brush info
	
		Text 0,40,"3. Brush Info"
		
		If surf<>Null
		
			Text 0,80,"Surface "+surf_no+"/"+TMesh(ent).CountSurfaces()+" Brush:"
			
			If surf.brush<>Null
			
				Text 0,100,"Name: "+String.FromCString(surf.brush.name) ' name
				Text 0,120,"Red: "+surf.brush.red[0] ' red
				Text 0,140,"Green: "+surf.brush.green[0] ' green
				Text 0,160,"Blue: "+surf.brush.blue[0] ' blue
				Text 0,180,"Alpha: "+surf.brush.alpha[0] ' alpha
				Text 0,200,"Blend: "+surf.brush.blend[0] ' blend
				Text 0,220,"FX: "+surf.brush.fx[0] ' fx
				
				If surf.brush.tex[0]<>Null
					Text 0,240,"Tex0 Name: "+String.FromCString(surf.brush.tex[0].file) ' file
					Text 0,260,"Tex0 Flags: "+surf.brush.tex[0].flags[0] ' flags
					Text 0,280,"Tex0 Blend: "+surf.brush.tex[0].blend[0] ' blend
				EndIf
				If surf.brush.tex[1]<>Null
					Text 0,300,"Tex1 Name: "+String.FromCString(surf.brush.tex[1].file)
					Text 0,320,"Tex1 Flags: "+surf.brush.tex[1].flags[0]
					Text 0,340,"Tex1 Blend: "+surf.brush.tex[1].blend[0]
				EndIf
				If surf.brush.tex[2]<>Null
					Text 0,360,"Tex2 Name: "+String.FromCString(surf.brush.tex[2].file)
					Text 0,380,"Tex2 Flags: "+surf.brush.tex[2].flags[0]
					Text 0,400,"Tex2 Blend: "+surf.brush.tex[2].blend[0]
				EndIf
				If surf.brush.tex[3]<>Null
					Text 0,420,"Tex3 Name: "+String.FromCString(surf.brush.tex[3].file)
					Text 0,440,"Tex3 Flags: "+surf.brush.tex[3].flags[0]
					Text 0,460,"Tex3 Blend: "+surf.brush.tex[3].blend[0]
				EndIf
				
			Else
			
				Text 0,100,"No brush"
				
			EndIf
			
		Else
		
			Text 0,100,"No surface"
			
		EndIf
		
		Text 200,80,"Entity Brush:"
		
		If ent.brush<>Null
		
			Text 200,100,"Name: "+String.FromCString(ent.brush.name)
			Text 200,120,"Red: "+ent.brush.red[0]
			Text 200,140,"Green: "+ent.brush.green[0]
			Text 200,160,"Blue: "+ent.brush.blue[0]
			Text 200,180,"Alpha: "+ent.brush.alpha[0]
			Text 200,200,"Blend: "+ent.brush.blend[0]
			Text 200,220,"FX: "+ent.brush.fx[0]
			
			If ent.brush.tex[0]<>Null
				Text 200,240,"Tex0 Name: "+String.FromCString(ent.brush.tex[0].file)
				Text 200,160,"Tex0 Flags: "+ent.brush.tex[0].flags[0]
				Text 200,280,"Tex0 Blend: "+ent.brush.tex[0].blend[0]
			EndIf
			If ent.brush.tex[1]<>Null
				Text 200,300,"Tex1 Name: "+String.FromCString(ent.brush.tex[1].file)
				Text 200,320,"Tex1 Flags: "+ent.brush.tex[1].flags[0]
				Text 200,340,"Tex1 Blend: "+ent.brush.tex[1].blend[0]
			EndIf
			If ent.brush.tex[2]<>Null
				Text 200,360,"Tex2 Name: "+String.FromCString(ent.brush.tex[2].file)
				Text 200,380,"Tex2 Flags: "+ent.brush.tex[2].flags[0]
				Text 200,400,"Tex2 Blend: "+ent.brush.tex[2].blend[0]
			EndIf
			If ent.brush.tex[3]<>Null
				Text 200,420,"Tex3 Name: "+String.FromCString(ent.brush.tex[3].file)
				Text 200,440,"Tex3 Flags: "+ent.brush.tex[3].flags[0]
				Text 200,460,"Tex3 Blend: "+ent.brush.tex[3].blend[0]
			EndIf
			
		Else
		
			Text 0,100,"No brush"
			
		EndIf
		
	End Function
	
	Function EntityInfo4(ent:TEntity,cam:TCamera) ' cam info
	
		Text 0,40,"3. Camera Info"
		
		If cam<>Null
		
			Text 0,80,"EntityInView: "+String(cam.EntityInView(ent))
			
		Else
		
			Text 0,80, "Camera entity not specified!"
			
		EndIf
		
	End Function
	
End Type
