
Rem
bbdoc: Particle Batch mesh entity
End Rem
Type TParticleBatch Extends TMesh
	
	Function CreateObject:TParticleBatch( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TParticleBatch=New TParticleBatch
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
	
	
	
End Type

Rem
bbdoc: Particle Emitter entity
End Rem
Type TParticleEmitter Extends TEntity
	
	Function CreateObject:TParticleEmitter( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TParticleEmitter=New TParticleEmitter
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
	
	Function CreateParticleEmitter:TParticleEmitter( particle:TEntity,parent_ent:TEntity=Null )
	
		Local inst:Byte Ptr=CreateParticleEmitter_( TEntity.GetInstance(particle),TEntity.GetInstance(parent_ent) )
		Return CreateObject(inst)
		
	End Function
	
	Method EmitterVector( startx:Float,starty:Float,startz:Float,endx:Float,endy:Float,endz:Float )
	
		EmitterVector_( GetInstance(Self),startx,starty,startz,endx,endy,endz )
		
	End Method
	
	Method EmitterRate( r:Float )
	
		EmitterRate_( GetInstance(Self),r )
		
	End Method
	
	Method EmitterParticleLife( startl:Int,endl:Int,randl:Int=0 )
	
		EmitterParticleLife_( GetInstance(Self),startl,endl,randl )
		
	End Method
	
	Method EmitterParticleFunction( EmitterFunction( ent:Byte Ptr,life:Int ) )
	
		EmitterParticleFunction_( GetInstance(Self),EmitterFunction )
		
	End Method
	
	Method EmitterParticleSpeed( starts:Float,ends:Float=0 )
	
		EmitterParticleSpeed_( GetInstance(Self),starts,ends )
		
	End Method
	
	Method EmitterVariance( v:Float )
	
		EmitterVariance_( GetInstance(Self),v )
		
	End Method
	
	Method EmitterParticleAlpha( starta:Float,enda:Float,mida:Float=0,midlife:Int=0 )
	
		EmitterParticleAlpha_( GetInstance(Self),starta,enda,mida,midlife )
		
	End Method
	
	Method EmitterParticleScale( startsx:Float,startsy:Float,endsx:Float,endsy:Float,midsx:Float=1,midsy:Float=1,midlife:Int=0 )
	
		EmitterParticleScale_( GetInstance(Self),startsx,startsy,endsx,endsy,midsx,midsy,midlife )
		
	End Method
	
	Method EmitterParticleColor( startr:Float,startg:Float,startb:Float,endr:Float,endg:Float,endb:Float,midr:Float=255,midg:Float=255,midb:Float=255,midlife:Int=0 )
	
		EmitterParticleColor_( GetInstance(Self),startr,startg,startb,endr,endg,endb,midr,midg,midb,midlife )
		
	End Method
	
	Method EmitterParticleRotate( startr:Float,endr:Float,midr:Float=0,midlife:Int=0 )
	
		EmitterParticleRotate_( GetInstance(Self),startr,endr,midr,midlife )
		
	End Method
	
	' Internal
	
	Method CopyEntity:TParticleEmitter( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Local particle:TParticleEmitter=CreateObject(inst)
		If pick_mode[0] Then TPick.AddList_(TPick.ent_list)
		Return particle
		
	End Method
	
	Method Update() ' empty
	
		
		
	End Method
	
End Type

' TFieldArray
