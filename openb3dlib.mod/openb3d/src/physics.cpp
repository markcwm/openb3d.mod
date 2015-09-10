#include "physics.h"

list<Constraint*> Constraint::constraint_list;
list<RigidBody*> RigidBody::rigidBody_list;


void Constraint::Update(){
	list<Constraint*>::iterator it;

	for(it=Constraint::constraint_list.begin();it!=Constraint::constraint_list.end();it++){
		Constraint* c=*it;
		float d, dx, dy, dz;
		dx=c->P1->mat.grid[3][0] - c->P2->mat.grid[3][0];
		dy=c->P1->mat.grid[3][1] - c->P2->mat.grid[3][1];
		dz=c->P1->mat.grid[3][2] - c->P2->mat.grid[3][2];
		d=(dx*dx + dy*dy + dz*dz);

		float diff;
		diff=(d - c->length) / d * .25;

		c->P1->mat.grid[3][0]-= dx * diff;
		c->P1->mat.grid[3][1]-= dy * diff;
		c->P1->mat.grid[3][2]-= dz * diff;

		c->P2->mat.grid[3][0]+= dx * diff;
		c->P2->mat.grid[3][1]+= dy * diff;
		c->P2->mat.grid[3][2]+= dz * diff;
	}
}

Constraint* Constraint::CreateConstraint(Entity* p1, Entity* p2, float l){
	Constraint* c=new Constraint;
	c->P1=p1;
	c->P2=p2;
	c->length=l*l;
	constraint_list.push_back(c);

	return c;
}

void RigidBody::Update(){
	list<RigidBody*>::iterator it;

	for(it=RigidBody::rigidBody_list.begin();it!=RigidBody::rigidBody_list.end();it++){
		RigidBody* b=*it;
		b->body->mat.grid[3][0]=b->Points[0]->mat.grid[3][0];
		b->body->mat.grid[3][1]=b->Points[0]->mat.grid[3][1];
		b->body->mat.grid[3][2]=b->Points[0]->mat.grid[3][2];

		/*b->body->px=b->Points[0]->mat.grid[3][0];
		b->body->py=b->Points[0]->mat.grid[3][1];
		b->body->pz=b->Points[0]->mat.grid[3][2];*/

		b->body->mat.grid[0][0]=b->Points[1]->mat.grid[3][0]-b->Points[0]->mat.grid[3][0];
		b->body->mat.grid[0][1]=b->Points[1]->mat.grid[3][1]-b->Points[0]->mat.grid[3][1];
		b->body->mat.grid[0][2]=b->Points[1]->mat.grid[3][2]-b->Points[0]->mat.grid[3][2];

		b->body->mat.grid[1][0]=b->Points[2]->mat.grid[3][0]-b->Points[0]->mat.grid[3][0];
		b->body->mat.grid[1][1]=b->Points[2]->mat.grid[3][1]-b->Points[0]->mat.grid[3][1];
		b->body->mat.grid[1][2]=b->Points[2]->mat.grid[3][2]-b->Points[0]->mat.grid[3][2];

		b->body->mat.grid[2][0]=b->Points[0]->mat.grid[3][0]-b->Points[3]->mat.grid[3][0];
		b->body->mat.grid[2][1]=b->Points[0]->mat.grid[3][1]-b->Points[3]->mat.grid[3][1];
		b->body->mat.grid[2][2]=b->Points[0]->mat.grid[3][2]-b->Points[3]->mat.grid[3][2];

		/*b->body->rotmat.grid[0][0]=b->body->mat.grid[0][0];
		b->body->rotmat.grid[0][1]=b->body->mat.grid[0][1];
		b->body->rotmat.grid[0][2]=-b->body->mat.grid[0][2];

		b->body->rotmat.grid[1][0]=b->body->mat.grid[1][0];
		b->body->rotmat.grid[1][1]=b->body->mat.grid[1][1];
		b->body->rotmat.grid[1][2]=-b->body->mat.grid[1][2];

		b->body->rotmat.grid[2][0]=b->body->mat.grid[2][0];
		b->body->rotmat.grid[2][1]=b->body->mat.grid[2][1];
		b->body->rotmat.grid[2][2]=-b->body->mat.grid[2][2];*/

		list<Entity*>::iterator it2;

		for(it2=b->body->child_list.begin();it2!=b->body->child_list.end();it2++){
			Entity* ent=*it2;
			ent->MQ_Update();
		}

	}

}

RigidBody* RigidBody::CreateRigidBody(Entity* body, Entity* p1, Entity* p2, Entity* p3, Entity* p4){
	RigidBody* b=new RigidBody;
	b->body=body;
	b->Points[0]=p1;
	b->Points[1]=p2;
	b->Points[2]=p3;
	b->Points[3]=p4;

	rigidBody_list.push_back(b);
	return b;
}
