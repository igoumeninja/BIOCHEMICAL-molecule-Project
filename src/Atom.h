#include "ofMain.h"

class Atom {
	public:
		ofVec3f position, initPosition;
		float displacement;
		string type, acid;
		int id, group;
		ofColor color;

		Atom(int, ofVec3f, float, string, int, string);
		Atom();

	private:
		int transparency;
};