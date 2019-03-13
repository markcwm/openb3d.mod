' TBatchSprite.bmx
' ported from Minib3d-Monkey by Adam Redwoods
' notes: may have to add a check that camera position <> origin position. if so, move origin out away from camera

Rem
bbdoc: Batch sprite mesh entity
End Rem
Type TBatchSpriteMesh Extends TMesh

	'Field surf:TSurface 
	'Field free_stack:Int[1] ' list of available vertex
	'Field num_sprites:Int=0
	'Field sprite_list:TList
	'Field id:Int=0
	'Field cam_sprite:TSprite ' use this to get cam info
	
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
	
	Method InitFields() ' Once per CreateObject
	
		Super.InitFields()
		
	End Method
	
	' create batch controller
	Function Create:TBatchSpriteMesh( parent_ent:TEntity=Null )
	
		
		
	EndFunction
	
	Method Render()
	
		
		
	EndMethod
	
EndType

Rem
bbdoc: Batch sprite entity
EndRem
Type TBatchSprite Extends TSprite

	'Field batch_id:Int ' ids start at 1
	'Field vertex_id:Int
	
	'Global b_min_x:Float, b_min_y:Float, b_max_x:Float, b_max_y:Float, b_min_z:Float, b_max_z:Float
	Global mainsprite:TBatchSpriteMesh[]=New TBatchSpriteMesh[1]	
	Global total_batch:Int Ptr
	
	Global mainsprite_id:Int=0
	
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
	
	Function InitGlobals() ' Once per Graphics3D
	
		' int
		total_batch=StaticInt_( BATCHSPRITE_class,BATCHSPRITE_total_batch )
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		Super.InitFields()
		
	End Method
	
	Function CopyArray_( list:TBatchSpriteMesh[] ) ' Global list
	
		Select list
			Case mainsprite
				mainsprite_id=0
				For Local id:Int=0 To StaticListSize_( BATCHSPRITE_class,BATCHSPRITE_mainsprite )-1
					Local inst:Byte Ptr=StaticIterVectorBatchSpriteMesh_( BATCHSPRITE_class,BATCHSPRITE_mainsprite,Varptr mainsprite_id )
					Local obj:TBatchSpriteMesh=TBatchSpriteMesh( GetObject(inst) ) ' no CreateObject
					mainsprite=mainsprite[..mainsprite_id]
					mainsprite[mainsprite_id-1]=obj
				Next
		End Select
		
	End Function
	
	Method FreeEntity()
	
		Super.FreeEntity()
		
	EndMethod
	
	Method New()
		' new batch sprite, not added to entity list
	EndMethod
	
	Method Copy()
		' use CreateSprite(), since they should all be the same
	EndMethod
	
	' add a parent to the entire batch mesh -- position only
	Function BatchSpriteParent( id:Int=0, ent:TEntity, glob:Int=True )
	
		BatchSpriteParent_( id,GetInstance(ent),glob )
		
	EndFunction
	
	' return the sprite batch main mesh entity
	Function BatchSpriteEntity:TEntity( batch_sprite:TBatchSprite=Null )
	
		Local inst:Byte Ptr=BatchSpriteEntity_( GetInstance(batch_sprite) )
		Local ent:TEntity=TEntity.GetObject(inst)
		Return ent
		
	EndFunction
	
	' move the batch sprite origin for depth sorting
	Method BatchSpriteOrigin( x:Float, y:Float, z:Float )
	
		BatchSpriteOrigin_( GetInstance(Self),x,y,z )
		
	EndMethod
	
	Function CreateBatchMesh:TBatchSpriteMesh( batchid:Int )
	
		Local inst:Byte Ptr=CreateBatchMesh_( batchid )
		Local mesh:TBatchSpriteMesh=TBatchSpriteMesh( TEntity.GetObject(inst) )
		If mesh=Null And inst<>Null Then mesh=TBatchSpriteMesh.CreateObject(inst)
		Return mesh
		
	EndFunction
	
	' add sprite to batch, use this instead of TSprite.CreateSprite()
	' if you want to add to specifc batch controller, use BatchSpriteEntity as parent_ent
	Function CreateBatchSprite:TBatchSprite( parent_ent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateBatchSprite_( GetInstance(parent_ent) )
		Return CreateObject(inst)
		
	EndFunction
	
	Function LoadBatchTexture:TBatchSpriteMesh( tex_file$, tex_flag:Int=1, id:Int=0 )
	
		Select TGlobal.Texture_Loader
		
			Case 2 ' library
				Local cString:Byte Ptr=tex_file.ToCString()
				Local inst:Byte Ptr=LoadBatchTexture_( cString,tex_flag,id )
				Local mesh:TBatchSpriteMesh=TBatchSpriteMesh.CreateObject(inst)
				MemFree cString
				Return mesh
				
			Default ' wrapper
				' does not create sprite, just loads texture
				If id<=0 Or id>total_batch[0] Then id=total_batch[0]
				If id=0 Then id=1
				Local inst:Byte Ptr=CreateBatchMesh_(id)
				Local mesh:TBatchSpriteMesh=TBatchSpriteMesh.CreateObject(inst)
				
				Local tex:TTexture=LoadTexture(tex_file, tex_flag)
				CopyArray_(mainsprite)
				mainsprite[id].EntityTexture(tex)
				
				' additive blend if sprite doesn't have alpha or masking flags set
				If (tex_flag & 2)=0 And (tex_flag & 4)=0
					mainsprite[id].EntityBlend 3
				EndIf
				
				Return mainsprite[id]
				
		EndSelect
		
	EndFunction
	
	Method UpdateBatch( cam_sprite:TSprite )
	
		
		
	End Method
	
EndType
