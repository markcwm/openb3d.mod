#ifndef ACTIONS_H
#define ACTIONS_H

#include "entity.h"

enum{ACT_COMPLETED,
ACT_MOVEBY,
ACT_TURNBY,
ACT_VECTOR,
ACT_MOVETO,
ACT_TURNTO,
ACT_SCALETO,
ACT_FADETO,
ACT_TINTTO,
ACT_TRACK_BY_POINT,
ACT_TRACK_BY_DISTANCE,
ACT_NEWTONIAN
};

class Action{

public:
	static list<Action*> action_list;

	int act;

	Entity* ent;
	Entity* target;		//Optional, target entity for some actions

	float rate;
	float a,b,c;

	list<Action*> nextActions;
	
	// extra
	static list<Action*> delete_list;
	int endact,active;

	static Action* AddAction(Entity* ent, int action, Entity* t, float a, float b, float c, float rate);
	static Action* AddAction(Entity* ent, int action, float a, float b, float c, float rate){
		return AddAction(ent, action, 0, a, b, c, rate);
	};
	static Action* AddAction(Entity* ent, int action, Entity* t, float rate){
		return AddAction(ent, action, t, 0, 0, 0, rate);
	};
	void AppendAction (Action* a);
	void FreeAction ();
	static void Update();
	void EndAction();
	Action* ActInList(list<Action*>& list_ref);
};



#endif
