
Rem
bbdoc: Terrain entity
End Rem
Type TTerrain Extends TEntity
	
	Function CreateObject:TTerrain( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TTerrain=New TTerrain
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		Super.InitFields()
				
	End Method
	
	' Openb3d
	
	Function CreateTerrain:TTerrain( size:Int,parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateTerrain_( size,GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Function LoadTerrain:TTerrain( file:String,parent:TEntity=Null )
	
		Local cString:Byte Ptr=file.ToCString()
		Local inst:Byte Ptr=LoadTerrain_( cString,GetInstance(parent) )
		Local terr:TTerrain=CreateObject(inst)
		MemFree cString
		Return terr
		
	End Function
	
	Method ModifyTerrain( x:Int,z:Int,new_height:Float )
	
		ModifyTerrain_( GetInstance(Self),x,z,new_height )
		
	End Method
	
	Method TerrainHeight:Float( x:Int,z:Int )
	
		Return TerrainHeight_( GetInstance(Self),x,z )
		
	End Method
	
	Method TerrainX:Float( x:Float,y:Float,z:Float )
	
		Return TerrainX_( GetInstance(Self),x,y,z )
		
	End Method
	
	Method TerrainY:Float( x:Float,y:Float,z:Float )
	
		Return TerrainY_( GetInstance(Self),x,y,z )
		
	End Method
	
	Method TerrainZ:Float( x:Float,y:Float,z:Float )
	
		Return TerrainZ_( GetInstance(Self),x,y,z )
		
	End Method
	
	' Internal
	
	Method CopyEntity:TTerrain( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return CreateObject(inst)
		
	End Method
	
	Method Update() ' empty
	
		
		
	End Method
	
End Type
