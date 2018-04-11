
Rem
bbdoc: Fluid mesh entity
End Rem
Type TFluid Extends TMesh
	
	Function CreateObject:TFluid( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TFluid=New TFluid
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
	
	Function CreateFluid:TFluid()
	
		Local inst:Byte Ptr=CreateFluid_()
		Return CreateObject(inst)
		
	End Function
	
	Method FluidArray( Array:Float Var,w:Int,h:Int,d:Int )
	
		FluidArray_( GetInstance(Self),Varptr(Array),w,h,d )
		
	End Method
	
	Method FluidFunction( FieldFunction:Float( x:Float,y:Float,z:Float ) )
	
		FluidFunction_( GetInstance(Self),FieldFunction )
		
	End Method
	
	Method FluidThreshold( threshold:Float )
	
		FluidThreshold_( GetInstance(Self),threshold )
		
	End Method
	
End Type

Rem
bbdoc: Blob entity
End Rem
Type TBlob Extends TEntity
	
	Function CreateObject:TBlob( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TBlob=New TBlob
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
	
	Function CreateBlob:TBlob( fluid:TFluid,radius:Float,parent_ent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateBlob_( GetInstance(fluid),radius,GetInstance(parent_ent) )
		Return CreateObject(inst)
		
	End Function
	
	' Internal
	
	Method CopyEntity:TBlob( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Local blob:TBlob=CreateObject(inst)
		If pick_mode[0] Then TPick.AddList_(TPick.ent_list)
		Return blob
		
	End Method
	
	Method Update() ' empty
	
		
		
	End Method
	
End Type

' TFieldArray
