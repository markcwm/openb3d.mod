
Rem
bbdoc: Voxelsprite mesh entity
End Rem
Type TVoxelSprite Extends TMesh

	Function CreateObject:TVoxelSprite( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TVoxelSprite=New TVoxelSprite
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
	
	' Openb3d
	
	Function CreateVoxelSprite:TVoxelSprite( slices:Int=64,parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateVoxelSprite_( slices,GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Method VoxelSpriteMaterial( mat:TMaterial )
	
		VoxelSpriteMaterial_( GetInstance(Self),TMaterial.GetInstance(mat) )
		
	End Method
	
End Type
