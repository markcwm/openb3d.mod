
' TOcTreeChild

Rem
bbdoc: Octree terrain entity
End Rem
Type TOcTree Extends TTerrain
	
	Function CreateObject:TOcTree( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TOcTree=New TOcTree
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		Super.InitFields()
				
	End Method
	
	' Openb3d
	
	Function CreateOcTree:TOcTree( w:Float,h:Float,d:Float,parent_ent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateOcTree_( w,h,d,GetInstance(parent_ent) )
		Return CreateObject(inst)
		
	End Function
	
	Method OctreeBlock( mesh:TMesh,level:Int,X:Float,Y:Float,Z:Float,Near:Float=0,Far:Float=1000 )
	
		OctreeBlock_( GetInstance(Self),GetInstance(mesh),level,X,Y,Z,Near,Far )
		
	End Method
	
	Method OctreeMesh( mesh:TMesh,level:Int,X:Float,Y:Float,Z:Float,Near:Float=0,Far:Float=1000 )
	
		OctreeMesh_( GetInstance(Self),GetInstance(mesh),level,X,Y,Z,Near,Far )
		
	End Method
	
End Type
