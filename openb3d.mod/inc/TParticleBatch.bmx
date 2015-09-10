
Rem
bbdoc: Particle Batch mesh entity
End Rem
Type TParticleBatch Extends TMesh
	
	Function CreateObject:TParticleBatch( inst:Byte Ptr ) ' Create and map object from C++ instance
	
		If inst=Null Then Return Null
		Local obj:TParticleBatch=New TParticleBatch
		ent_map.Insert( String(Long(inst)),obj )
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
		ent_map.Insert( String(Long(inst)),obj )
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
	
	Method EmitterVector( x:Float,y:Float,z:Float )
	
		EmitterVector_( GetInstance(Self),x,y,z )
		
	End Method
	
	Method EmitterRate( r:Float )
	
		EmitterRate_( GetInstance(Self),r )
		
	End Method
	
	Method EmitterParticleLife( l:Int )
	
		EmitterParticleLife_( GetInstance(Self),l )
		
	End Method
	
	Method EmitterParticleFunction( EmitterFunction( ent:Byte Ptr,life:Int ) )
	
		EmitterParticleFunction_( GetInstance(Self),EmitterFunction )
		
	End Method
	
	Method EmitterParticleSpeed( s:Float )
	
		EmitterParticleSpeed_( GetInstance(Self),s )
		
	End Method
	
	Method EmitterVariance( v:Float )
	
		EmitterVariance_( GetInstance(Self),v )
		
	End Method
	
	' Internal
	
	Method CopyEntity:TParticleEmitter( parent:TEntity=Null )
	
		Local inst:Byte Ptr=CopyEntity_( GetInstance(Self),GetInstance(parent) )
		Return CreateObject(inst)
		
	End Method
	
	Method Update() ' empty
	
		
		
	End Method
	
End Type

' TFieldArray
