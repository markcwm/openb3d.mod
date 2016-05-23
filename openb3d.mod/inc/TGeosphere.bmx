
Rem
bbdoc: Geosphere terrain entity
End Rem
Type TGeosphere Extends TTerrain
	
	Function CreateObject:TGeosphere( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TGeosphere=New TGeosphere
		ent_map.Insert( String(Long(inst)),obj )
		obj.instance=inst
		obj.InitFields()
		Return obj
		
	End Function
	
	Method InitFields() ' Once per CreateObject
	
		Super.InitFields()
				
	End Method
	
	' Openb3d
	
	Function CreateGeosphere:TGeosphere( size:Int,parent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateGeosphere_( size,GetInstance(parent) )
		Return CreateObject(inst)
		
	End Function
	
	Function LoadGeosphere:TGeosphere( file:String,parent:TEntity=Null )
	
		Local cString:Byte Ptr=file.ToCString()
		Local inst:Byte Ptr=LoadGeosphere_( cString,GetInstance(parent) )
		Local geo:TGeosphere=CreateObject(inst)
		MemFree cString
		Return geo
		
	End Function
	
	Method ModifyGeosphere( x:Int,z:Int,new_height:Float )
	
		ModifyGeosphere_( GetInstance(Self),x,z,new_height )
		
	End Method
	
	Method GeosphereHeight( h:Float )
	
		GeosphereHeight_( GetInstance(Self),h )
		
	End Method
	
End Type
