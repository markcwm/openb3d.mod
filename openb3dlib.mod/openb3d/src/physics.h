#ifndef PHYSICS_H
#define PHYSICS_H

#include "entity.h"

class Constraint{
	static list<Constraint*> constraint_list;

	Entity* P1;
	Entity* P2;

	float length;

public:
	static Constraint* CreateConstraint(Entity* p1, Entity* p2, float l);
	static void Update();
};

class RigidBody{
	static list<RigidBody*> rigidBody_list;
	Entity* body;

	Entity* Points[4];

public:
	static RigidBody* CreateRigidBody(Entity* body, Entity* p1, Entity* p2, Entity* p3, Entity* p4);
	static void Update();
};


#endif
