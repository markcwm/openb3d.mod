#ifndef PHYSICS_H
#define PHYSICS_H

#include "entity.h"

class Constraint{
public:
	static list<Constraint*> constraint_list;

	Entity* P1;
	Entity* P2;

	float length;

	static Constraint* CreateConstraint(Entity* p1, Entity* p2, float l);
	static void Update();
	void FreeConstraint();
};

class RigidBody{
public:
	static list<RigidBody*> rigidBody_list;
	Entity* body;

	Entity* Points[4];

	static RigidBody* CreateRigidBody(Entity* body, Entity* p1, Entity* p2, Entity* p3, Entity* p4);
	static void Update();
	void FreeRigidBody();
};


#endif
