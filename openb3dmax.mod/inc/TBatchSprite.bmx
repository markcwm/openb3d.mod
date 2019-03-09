' TBatchSprite.bmx
' code ported from minib3d-monkey by Adam Redwoods
' notes: may have to add a check that camera position <> origin position. If so, move origin out away from camera

Rem
bbdoc: Batch sprite mesh entity
End Rem
Type TBatchSpriteMesh Extends TMesh

	Field surf:TSurface 
	Field free_stack:Int[1] ' list of available vertex
	Field num_sprites:Int=0
	Field sprite_list:TList
	'Field mat_sp:Matrix=New Matrix
	Field id:Int=0
	Field cam_sprite:TSprite ' use this to get cam info
	
	Global render_list:TList=CreateList()
	
	Function CreateObject:TBatchSpriteMesh( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TBatchSpriteMesh=New TBatchSpriteMesh
		?bmxng
		ent_map.Insert( inst,obj )
		?Not bmxng
		ent_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function NewBatchSpriteMesh:TBatchSpriteMesh()
	
		Local inst:Byte Ptr=NewMesh_()
		Return CreateObject(inst)
		
	End Function
	
	' create batch controller
	Function Create:TBatchSpriteMesh( parent_ent:TEntity=Null )
	
		Local mesh:TBatchSpriteMesh=NewBatchSpriteMesh()
		
		mesh.AddParent(parent_ent)
		mesh.EntityListAdd(TEntity.entity_list)
		
		' update matrix
		If mesh.parent<>Null
			mesh.mat.Overwrite(mesh.parent.mat)
			mesh.UpdateMat()
		Else
			mesh.UpdateMat(True)
		EndIf
		
		mesh.surf=mesh.CreateSurface()
		mesh.surf.ClearSurface()
		'mesh.surf.vbo_dyn=True
		mesh.num_sprites=0
		'mesh.free_stack=New IntStack
		mesh.EntityFX 1+2+32 ' full bright+ use vertex colors + alpha
		mesh.brush.shine[0]=0.0	
		
		mesh.SetString(mesh.class_name, "BatchSpriteMesh")
		'mesh.is_sprite=True ' no
		'mesh.is_update=True
		mesh.cull_radius[0]=-999999.0
		
		' add invisible sprite to get camera info for batch
		mesh.cam_sprite=TSprite.CreateSprite(mesh)
		Local sf:TSurface=TSurface(mesh.cam_sprite.surf_list.First())
		mesh.cam_sprite.EntityFX(3+32)
		
		sf.VertexColor(0, 0, 0, 0, 0)
		sf.VertexColor(1, 0, 0, 0, 0)
		sf.VertexColor(2, 0, 0, 0, 0)
		sf.VertexColor(3, 0, 0, 0, 0)
		
		mesh.sprite_list=CreateList()
		
		Return mesh
		
	EndFunction
	
	Method Render()
	
		' wipe out rotation matrix
		mat.grid[(4*0)+0]=1.0; mat.grid[(4*0)+1]=0.0; mat.grid[(4*0)+2]=0.0
		mat.grid[(4*1)+0]=0.0; mat.grid[(4*1)+1]=1.0; mat.grid[(4*1)+2]=0.0
		mat.grid[(4*2)+0]=0.0; mat.grid[(4*2)+1]=0.0; mat.grid[(4*2)+2]=1.0
		
		TBatchSprite.b_min_x=999999999.0
		TBatchSprite.b_max_x=-999999999.0
		TBatchSprite.b_min_y=999999999.0
		TBatchSprite.b_max_y=-999999999.0
		TBatchSprite.b_min_z=999999999.0
		TBatchSprite.b_max_z=-999999999.0
		
		For Local ent:TBatchSprite=EachIn sprite_list
			ent.UpdateBatch(cam_sprite)
			
			surf.reset_vbo[0]=surf.reset_vbo[0]|16
		Next
		
		' do our own bounds
		If num_sprites>0
			Local width#=TBatchSprite.b_max_x-TBatchSprite.b_min_x
			Local height#=TBatchSprite.b_max_y-TBatchSprite.b_min_y
			Local depth#=TBatchSprite.b_max_z-TBatchSprite.b_min_z
			
			' get bounding sphere (cull_radius#) from AABB, only get cull radius (auto cull)
			' if cull radius hasn't been set to a negative no. by TEntity.MeshCullRadius (manual cull)
			If width>=height And width>=depth
				cull_radius[0]=width
			Else
				If height>=width And height>=depth
					cull_radius[0]=height
				Else
					cull_radius[0]=depth
				EndIf
			EndIf
			
			cull_radius[0]=cull_radius[0]*0.5
			Local crs#=cull_radius[0]*cull_radius[0]
			cull_radius[0]=Sqr(crs+crs+crs)
			
			min_x[0]=TBatchSprite.b_min_x
			min_y[0]=TBatchSprite.b_min_y
			min_z[0]=TBatchSprite.b_min_z
			max_x[0]=TBatchSprite.b_max_x
			max_y[0]=TBatchSprite.b_max_y
			max_z[0]=TBatchSprite.b_max_z
			
			'If brush.tex[0] Then brush.tex[0].flags=brush.tex[0].flags | 16 |32 ' always clamp
			'If surf.brush.tex[0] Then surf.brush.tex[0].flags=surf.brush.tex[0].flags | 16 |32 ' always clamp
			
		Else ' no more sprites in batch, reduce overhead
			surf.ClearSurface()
			sprite_list.Clear()
			'free_stack.Clear()
			free_stack=[0]
			
		EndIf
		
		Super.Render()
		
	EndMethod
	
EndType

Rem
bbdoc: Batch sprite entity
EndRem
Type TBatchSprite Extends TSprite

	Field batch_id:Int ' ids start at 1
	Field vertex_id:Int
	Field sprite_link:TLink
	
	Global b_min_x:Float, b_min_y:Float, b_max_x:Float, b_max_y:Float, b_min_z:Float, b_max_z:Float
	Global mainsprite:TBatchSpriteMesh[]'=New TBatchSpriteMesh[10]	
	Global total_batch:Int=0
	Global temp_mat:TMatrix=NewMatrix()
	
	Function CreateObject:TBatchSprite( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TBatchSprite=New TBatchSprite
		?bmxng
		ent_map.Insert( inst,obj )
		?Not bmxng
		ent_map.Insert( String(Int(inst)),obj )
		?
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Function NewBatchSprite:TBatchSprite()
	
		Local inst:Byte Ptr=NewSprite_()
		Return CreateObject(inst)
		
	End Function
	
	' batch sprite not added to entity list
	Method New()
	
		'If LOG_NEW
		'	DebugLog "New TBatchSprite"
		'EndIf
	
	End Method
	
	Method Delete()
	
		'If LOG_DEL
		'	DebugLog "Del TBatchSprite"
		'EndIf
	
	End Method
	
	Method FreeEntity()
	
		If exists
			'mainsprite[batch_id].free_stack.Push(vertex_id)
			'stack push
			Local st:Int=mainsprite[batch_id].free_stack.length
			mainsprite[batch_id].free_stack=mainsprite[batch_id].free_stack[0..st+1]
			mainsprite[batch_id].free_stack[st]=vertex_id
			mainsprite[batch_id].num_sprites:-1
			sprite_link.Remove()
			
			' free self from parent's child_list
			If parent<>Null
			For Local ent:TEntity=EachIn parent.child_list
					If ent=Self
						ListRemove(parent.child_list, Self)
						parent.EntityListRemove(parent.child_list, Self)
					EndIf
				Next
			EndIf
			
			'mat.LoadIdentity()
			'brush=Null
			
			exists=0
			FreeEntityList()
			FreeObject( GetInstance(Self) )
		EndIf
		
	EndMethod
	
	' use CreateBatchSprite(), since they should all be the same
	Method Copy()
	
	EndMethod
	
	' add a parent to the entire batch mesh - position only
	Function BatchSpriteParent( id:Int=0, ent:TEntity, glob:Int=True )
	
		If id=0 Then id=total_batch
		If id=0 Then Return
		mainsprite[id].EntityParent(ent, glob)
		
	EndFunction
	
	' return the sprite batch main mesh entity
	Function BatchSpriteEntity:TEntity( batch_sprite:TBatchSprite=Null )
	
		If batch_sprite Then Return mainsprite[batch_sprite.batch_id]
		If mainsprite Then Return mainsprite[total_batch]
		
	EndFunction
	
	' move the batch sprite origin for depth sorting
	Method BatchSpriteOrigin( x:Float, y:Float, z:Float )
		
		mainsprite[batch_id].PositionEntity(x, y, z)
		
	EndMethod
	
	' create new batch
	Function CreateBatchMesh:TBatchSpriteMesh( batchid:Int )
	
		While total_batch<batchid Or total_batch=0
			total_batch:+1
			If total_batch>=mainsprite.length Then mainsprite=mainsprite[..total_batch+5]
			
			mainsprite[total_batch]=TBatchSpriteMesh.Create()
			mainsprite[total_batch].id=total_batch
		Wend
		
		Return mainsprite[total_batch]
		
	EndFunction
	
	' add sprite to batch - use this instead of TSprite.CreateSprite()
	' if you want to add to specific batch controller, use BatchSpriteEntity as parent_ent
	Function CreateBatchSprite:TBatchSprite( parent_ent:TEntity=Null )
	
		' never added to entity_list
		' if idx=0 add to last created batch
		Local idx:Int=0
		If TBatchSpriteMesh(parent_ent)<>Null Then idx=TBatchSpriteMesh(parent_ent).id
		
		Local sprite:TBatchSprite=NewBatchSprite()
		
		sprite.SetString(sprite.class_name, "BatchSprite")
		
		' update matrix
		If sprite.parent<>Null
			sprite.mat.Overwrite(sprite.parent.mat)
			sprite.UpdateMat()
		Else
			sprite.UpdateMat(True)
		EndIf

		If idx=0 Then sprite.batch_id=total_batch Else sprite.batch_id=idx
		If sprite.batch_id=0 Then sprite.batch_id=1
		Local id:Int=sprite.batch_id
		
		' create main mesh
		Local mesh:TBatchSpriteMesh
		If id > total_batch
			mesh=CreateBatchMesh(id)
			If id=0 Then id=1
		Else
			mesh=mainsprite[id]
		EndIf
		
		' get vertex id
		Local v:Int, v0:Int
		If mesh.free_stack.length<1
		
			mesh.num_sprites:+1
			v=(mesh.num_sprites-1) * 4 '4 vertex per quad
			mesh.surf.AddVertex(-1,-1, 0, 0, 1) ' v0
			mesh.surf.AddVertex(-1, 1, 0, 0, 0)
			mesh.surf.AddVertex( 1, 1, 0, 1, 0)
			mesh.surf.AddVertex( 1,-1, 0, 1, 1)
			'v=(mesh.num_sprites-1) * 3 '3 vertex per sprite
			'mesh.surf.AddVertex(-1,-3, 0, 0, 2) ' v0
			'mesh.surf.AddVertex(-1,-1, 0, 0, 0)
			'mesh.surf.AddVertex( 3,-1, 0, 2, 0)
			mesh.surf.AddTriangle(0+v, 1+v, 2+v)
			mesh.surf.AddTriangle(0+v, 2+v, 3+v)
			' v isnt guarateed to be v0, but seems to match up
			
			' since vbo expands, make sure to reset so we dont use subbuffer
			mesh.surf.reset_vbo[0]=-1
			
		Else
			Local st:Int=mesh.free_stack.length
			v=mesh.free_stack[st-1] ' pop stack
			mesh.free_stack=mesh.free_stack[0..st-1]
			mesh.num_sprites:+1
			
		EndIf
		
		mesh.reset_bounds[0]=False ' we control our own bounds
		sprite.vertex_id=v
		'sprite.sprite_link=mesh.sprite_list.AddLast(sprite)
		sprite.sprite_link=ListAddLast(mesh.sprite_list, sprite)
		
		If TBatchSpriteMesh(parent_ent)=Null And parent_ent<>Null
			sprite.EntityParent(parent_ent)
			sprite.mat.Overwrite(parent_ent.mat)
		EndIf
		
		Return sprite
		
	EndFunction
	
	' does not create sprite, just loads texture
	Function LoadBatchTexture:TBatchSpriteMesh( tex_file:String, tex_flag:Int=1, id:Int=0 )
	
		If id<=0 Or id>total_batch Then id=total_batch
		If id=0 Then id=1
		
		mainsprite=mainsprite[..10] ' init array size
		
		CreateBatchMesh(id)
		
		Local tex:TTexture=TTexture.LoadTexture(tex_file, tex_flag)
		mainsprite[id].EntityTexture(tex)
		
		' additive blend if sprite doesn't have alpha or masking flags set
		If (tex_flag & 2)=0 And (tex_flag & 4)=0
			mainsprite[id].EntityBlend 3
		EndIf
		
		ListAddLast(TBatchSpriteMesh.render_list, mainsprite[id])
		
		Return mainsprite[id]
		
	EndFunction
	
	Method UpdateBatch( cam_sprite:TSprite )
	
		' invisible
		If brush.alpha[0]=0.0 Then Return 
		
		If view_mode[0]<>2
		
			' add in mainsprite position offset
			Local x#=mat.grid[(4*3)+0] - mainsprite[batch_id].mat.grid[(4*3)+0]
			Local y#=mat.grid[(4*3)+1] - mainsprite[batch_id].mat.grid[(4*3)+1]
			Local z#=mat.grid[(4*3)+2] - mainsprite[batch_id].mat.grid[(4*3)+2]
			
			temp_mat.Overwrite(cam_sprite.mat)
			temp_mat.grid[(4*3)+0]=x
			temp_mat.grid[(4*3)+1]=y
			temp_mat.grid[(4*3)+2]=z
			mat_sp.Overwrite(temp_mat)
			
			If angle[0]<>0.0
				mat_sp.RotateRoll(angle[0])
			EndIf
			If scale_x[0]<>1.0 Or scale_y[0]<>1.0
				mat_sp.Scale(scale_x[0], scale_y[0], 1.0)
			EndIf
			If handle_x[0]<>0.0 Or handle_y[0]<>0.0
				mat_sp.Translate(-handle_x[0], -handle_y[0], 0.0)
			EndIf
			
		Else
		
			mat_sp.Overwrite(mat)
			
			If scale_x[0]<>1.0 Or scale_y[0]<>1.0
				mat_sp.Scale(scale_x[0], scale_y[0], 1.0)
			EndIf
			
		EndIf
		
		' update main mesh
		' rotate each point corner offset to face the camera with cam_mat
		' use the mat.x.y.z for position and offset from that
		Local p0:Float[], p1:Float[], p2:Float[], p3:Float[]
		'Local temp_mat:Matrix=mat_sp.Copy() 'Inverse()
		Local o:Float[]=[mat_sp.grid[(4*3)+0], mat_sp.grid[(4*3)+1], mat_sp.grid[(4*3)+2]]
		
		Local m00:Float=mat_sp.grid[(4*0)+0]
		Local m01:Float=mat_sp.grid[(4*0)+1]
		Local m10:Float=mat_sp.grid[(4*1)+0]
		Local m11:Float=mat_sp.grid[(4*1)+1]
		Local m02:Float=mat_sp.grid[(4*0)+2]
		Local m12:Float=mat_sp.grid[(4*1)+2]
		
		'p0=mat_sp.TransformPoint(-1.0,-1.0, 0.0)
		'p1=mat_sp.TransformPoint(-1.0, 1.0, 0.0)		
		'p2=mat_sp.TransformPoint( 1.0, 1.0, 0.0)
		'p3=mat_sp.TransformPoint( 1.0,-1.0, 0.0)
		p0=[-m00 + -m10 + o[0], -m01 + -m11 + o[1], m02 + m12 - o[2]]		
		p1=[-m00 + m10 + o[0], -m01 + m11 + o[1], m02 - m12 - o[2]]	
		p2=[ m00 + m10 + o[0], m01 + m11 + o[1], -m02 - m12 - o[2]]			
		p3=[ m00 - m10 + o[0], m01 - m11 + o[1], -m02 + m12 - o[2]]
		'3 triangle sprite trick (does not work for all conditions, animated sprites)
		'p0=[-m00 + -(m10+m10+m10) + o[0], -m01 + -(m11+m11+m11) + o[1], m02 + m12+m12+m12 - o[2]]				
		'p1=[-m00 + m10 + o[0], -m01 + m11 + o[1], m02 - m12 - o[2]]	
		'p2=[m00+m00+m00 + m10 + o[0], m01+m01+m01 + m11 + o[1], -(m02+m02+m02) - m12 - o[2]]			
		'p3=[0.0, 0.0, 0.0]
		
		mainsprite[batch_id].surf.VertexCoords(vertex_id+0, p0[0], p0[1], p0[2])
		mainsprite[batch_id].surf.VertexCoords(vertex_id+1, p1[0], p1[1], p1[2])
		mainsprite[batch_id].surf.VertexCoords(vertex_id+2, p2[0], p2[1], p2[2])
		mainsprite[batch_id].surf.VertexCoords(vertex_id+3, p3[0], p3[1], p3[2])
		
		Local r#=brush.red[0] '*brush.alpha
		Local g#=brush.green[0] '*brush.alpha
		Local b#=brush.blue[0] '*brush.alpha
		Local a#=brush.alpha[0] '*0.5
		
		Local vid:Int=vertex_id*4
		mainsprite[batch_id].surf.vert_col[vid]=r
		mainsprite[batch_id].surf.vert_col[vid+1]=g
		mainsprite[batch_id].surf.vert_col[vid+2]=b
		mainsprite[batch_id].surf.vert_col[vid+3]=a
		vid=(vid+4)
		mainsprite[batch_id].surf.vert_col[vid]=r
		mainsprite[batch_id].surf.vert_col[vid+1]=g
		mainsprite[batch_id].surf.vert_col[vid+2]=b
		mainsprite[batch_id].surf.vert_col[vid+3]=a
		vid=(vid+4)
		mainsprite[batch_id].surf.vert_col[vid]=r
		mainsprite[batch_id].surf.vert_col[vid+1]=g
		mainsprite[batch_id].surf.vert_col[vid+2]=b
		mainsprite[batch_id].surf.vert_col[vid+3]=a
		vid=(vid+4)
		mainsprite[batch_id].surf.vert_col[vid]=r
		mainsprite[batch_id].surf.vert_col[vid+1]=g
		mainsprite[batch_id].surf.vert_col[vid+2]=b
		mainsprite[batch_id].surf.vert_col[vid+3]=a
		
		' mesh state has changed - update reset flags
		mainsprite[batch_id].surf.reset_vbo[0]=mainsprite[batch_id].surf.reset_vbo[0]|8
		
		' determine our own bounds
		b_min_x=Min5(p0[0], p1[0], p2[0], p3[0], b_min_x)
		b_min_y=Min5(p0[1], p1[1], p2[1], p3[1], b_min_y)
		b_min_z=Min5(p0[2], p1[2], p2[2], p3[2], b_min_z)
		b_max_x=Max5(p0[0], p1[0], p2[0], p3[0], b_max_x)
		b_max_y=Max5(p0[1], p1[1], p2[1], p3[1], b_max_y)
		b_max_z=Max5(p0[2], p1[2], p2[2], p3[2], b_max_z)
		
	End Method
	
	Function Min5:Float( a:Float,b:Float,c:Float,d:Float,e:Float )
	
		Local r:Float=a
		Local t:Float=c
		
		If b<r Then r=b
		If d<t Then t=d
		If t<r Then r=t
		
		If r<e Then Return r Else Return e
		
	End Function
	
	Function Max5:Float( a:Float,b:Float,c:Float,d:Float,e:Float )
	
		Local r:Float=a
		Local t:Float=c
		
		If b>r Then r=b
		If d>t Then t=d
		If t>r Then r=t
		
		If r>e Then Return r Else Return e
		
	End Function
	
EndType
