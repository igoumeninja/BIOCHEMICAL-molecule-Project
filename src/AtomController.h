#include "ofMain.h"
#include "Atom.h"

class AtomController {
	public:
		list<Atom> atoms;
		AtomController();
		void addAtom(Atom atom);
		void draw();
		void clear();

		ofVec3f lastAtomPosition;
		ofVec3f lastAcidPosition;
		int lastAtomGroup;
};