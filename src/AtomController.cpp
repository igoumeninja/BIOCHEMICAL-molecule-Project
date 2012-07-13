#include "AtomController.h"

AtomController::AtomController() {

}

void AtomController::addAtom(Atom atom) {
	atoms.push_back(atom);
}

void AtomController::draw() {
	lastAtomPosition = ofVec3f(0,0,0);  //we use these to draw lines
	lastAtomGroup = 0;					//between atoms belonging to the same aminoacid
	for (list<Atom>::iterator atom = atoms.begin(); atom != atoms.end(); atom++){
		if (atom->tempTransparency > atom->transparency){		//Newly created atoms start out more opaque
			atom->tempTransparency = atom->tempTransparency - 5;//and fade out till they reach their normal transparency
		}
		ofSetColor(atom->color.r, atom->color.g,atom->color.b, atom->tempTransparency);
		ofSphere(atom->position, atom->displacement*2); 
		if (atom != atoms.begin() && atom->group == lastAtomGroup) {
			ofSetColor(128,255,0,96);  //Connect atoms belonging to the same
			ofLine(lastAtomPosition,atom->position);
		}
		lastAtomPosition = atom->position;
		lastAtomGroup = atom->group;
	}
}

void AtomController::clear() { //we erase all atoms created so far
	for (list<Atom>::iterator atom = atoms.begin(); atom != atoms.end(); atom++) {
		atom = atoms.erase(atom);
	}
}