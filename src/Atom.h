#include "ofMain.h"

class Atom {
	public:
		ofVec3f position, initPosition;
		float displacement;
		string type, acid;
		int id, group;
		ofColor color;
		ofVbo vbo;

		Atom(int, ofVec3f, float, string, int, string);
		Atom();
		ofVbo initVbo(ofVec3f center, float radius);
		void draw();


	private:
		int transparency;
};