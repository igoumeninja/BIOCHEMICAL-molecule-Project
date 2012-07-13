#pragma once
#include "ofMain.h"
#include "ofxOsc.h"
#include "AtomController.h"
#include <list>
using std::list;

// listen on port 12345
#define PORT 12345
#define NUM_MSG_STRINGS 20
#define MAX_ELEMENTS			20000

class testApp : public ofBaseApp {
	public:

		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y);
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
		void rotateAround();
		void getOscMessages();
		void readSerial();
		float smooth(float data, float smoothVal, float smoothedData);
		void goToAtom(Atom atom);
		ofVec3f calculateRotation(string srt);


		ofxOscReceiver receiver;

		ofVec3f rotation;
		float rotationX;
		float rotationY;
		float rotationZ;
		float distance;
		float previousDistance;
		// Serial stuff
		string serialData;
		ofSerial serial; // add serial capabilities

		ofVec3f camPosition;

	int atomID,numAtoms, groupID;
	float posX, posY, posZ;
	float bIso;
	string type_symbol, acid;

	bool manualRotation;
	bool leftMouseDown;
	bool rightMouseDown;
	bool manualAlpha;
	int helix;
	int sheet;
	int alpha;


	AtomController atomController;
	Atom lastAtom;

	// Shader Stuff
	ofShader shader;
	ofFbo fbo, drawFbo;

	ofTexture texture;
};