#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
	ofBackground(0, 0, 0, 255);
	ofSetBackgroundAuto(true);
	ofEnableBlendMode(OF_BLENDMODE_ADD);
	ofSetWindowTitle("Biochemical Molecule audio-visual presentation");	
	batang.loadFont("../../../molecule/data/Batang.ttf", 9, true, true);
	//ofSetFrameRate(60); // if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps.
	ofSetVerticalSync(false);
	manualAlpha = false;
	cout << "listening for osc messages on port " << PORT << "\n";
	receiver.setup(PORT);
	current_msg_string = 0;
	mouseX = 0;
	mouseY = 0;
	mouseButtonState = "";
	ofSetSphereResolution(4);
	ofEnableSmoothing();
	ofEnablePointSprites();
	cam.setGlobalPosition(ofVec3f(0, 0, 0));
	distance = 500;
	previousDistance = 500;
	shader.load("../../../molecule/data/shaders/noise.vert", "../../../molecule/data/shaders/noise.frag");
}

//--------------------------------------------------------------
void testApp::update(){

	//calculate alpha
	alpha = (((float)ofGetMouseX()/(float)ofGetWidth())*128) -64;

	// hide old messages
	for(int i = 0; i < NUM_MSG_STRINGS; i++){
		if(timers[i] < ofGetElapsedTimef()){
			msg_strings[i] = "";
		}
	}

	// check for waiting messages
	while(receiver.hasWaitingMessages()){
		// get the next message
		ofxOscMessage m;
		receiver.getNextMessage(&m);
		if(m.getAddress() == "atomID"){
			// both the arguments are int32's
			atomID		=	m.getArgAsInt32 ( 0 );
			posX		=	ofMap(m.getArgAsFloat( 1 ), 100,200, 0 ,ofGetWidth());
			posY		=	ofMap(m.getArgAsFloat( 2 ), -50, 50, 0 ,ofGetHeight());
			posZ		=	ofMap(m.getArgAsFloat( 3 ), -30, 30, 0 ,400);
			bIso		=	ofMap(m.getArgAsFloat( 4 ), 0, 50, 0 , 10);
			type_symbol	=	m.getArgAsString(5);
			groupID		= m.getArgAsInt32(6);
			acid		= m.getArgAsString(7);
			atoms.push_back(Atom(atomID,ofVec3f(posX,posY,posZ),bIso,type_symbol,groupID,acid));
		} else if (m.getAddress() == "zoom") {
			float tempDistance = m.getArgAsInt32(0);
			if (distance < tempDistance) {
			distance = previousDistance + tempDistance/10 ;
			} else if (distance > tempDistance) {
			distance = previousDistance - tempDistance/10 ;
			}
			previousDistance = distance;
			cam.setPosition(cam.getX(),cam.getY(),distance);
			cout << distance << endl;
		}

	}
}


//--------------------------------------------------------------
void testApp::draw(){
	//shader.begin();
	//we want to pass in some varrying values to animate our type / color 
	shader.setUniform1f("timeValX", ofGetElapsedTimef() * 0.1 );
	shader.setUniform1f("timeValY", -ofGetElapsedTimef() * 0.18 );
	
	//we also pass in the mouse position 
	//we have to transform the coords to what the shader is expecting which is 0,0 in the center and y axis flipped. 
	shader.setUniform2f("mouse", mouseX - ofGetWidth()/2, ofGetHeight()/2-mouseY );

	cam.begin();
	ofFill();
	ofSetColor(0,0,0,1);
	lastAtomPosition = ofVec3f(0,0,0);
	lastAtomGroup = 0;
	for (list<Atom>::iterator atom = atoms.begin(); atom != atoms.end(); atom++){
		if (!manualAlpha){
			ofSetColor(atom->color);
		} else {
			int tempAlpha = alpha + atom->color.a;
			if (tempAlpha > 255) tempAlpha = 255;
			if (tempAlpha < 0) tempAlpha = 0;
			ofSetColor(atom->color.r,atom->color.g,atom->color.b,tempAlpha);
		}
		//ofVec3f tempPos = atom->position+(sin(((float)ofGetFrameNum()/60*atom->displacement/5))*atom->displacement/2);
		ofSphere(atom->position, atom->displacement+(sin(((float)ofGetFrameNum()/5*atom->displacement/5))*atom->displacement/2));

		if (atom != atoms.begin()) {
			if (atom->group != lastAtomGroup) {
				ofSetColor(255,128,0,128+alpha);
			} else {
				ofSetColor(128,255,0,96+alpha);
			}
			ofLine(lastAtomPosition,atom->position);
		}
		lastAtomPosition = atom->position;
		lastAtomGroup = atom->group;
	}
	cam.end();
	//shader.end();
	//ofSetWindowTitle("biochemical molecule " + ofToString(ofGetFrameRate()));
}

/* void testApp::readSerial() {
		int nRead  = 0; 
		unsigned char bytesReturned[1];
		char		bytesRead[1];				// data from serial, we will be trying to read 3
		char		bytesReadString[2];			// a string needs a null terminator, so we need 3 + 1 bytes
		memset(bytesReadString, 0, 2);
		memset(bytesReturned, 0, 1);
		while( (nRead = serial.readBytes( bytesReturned, 1)) > 0){
			memcpy(bytesReadString, bytesReturned, 1);
			if (ofToString(bytesReadString) != "\n") {
				serialData += bytesReadString;
			} else {
				rotation = calculateRotation(serialData);
				if (rotation.x != 0 && rotation.y != 0 && rotation.z !=0 &&
					rotation.x < 180 && rotation.y <180 && rotation.z < 180 &&
					rotation.x < -180 && rotation.y > -180 && rotation.z > -180){
					cam.orbit(rotation.z,rotation.y,distance);
					cam.roll(rotation.x);
					cout << rotation << endl;
				}
				serialData = "";
			}
		};
}  

ofVec3f testApp::calculateRotation(string str) {
	ofVec3f tempVec;
	string tempString;
	int tempPosition = str.find(":");
	tempString = str.substr(tempPosition+1,str.size());
	tempPosition = tempString.find(",");
	tempVec.x = ofToFloat(tempString.substr(0,tempPosition));
	tempString = tempString.substr(tempPosition+1,tempString.size());
	tempPosition = tempString.find(",");
	tempVec.y = ofToFloat(tempString.substr(0,tempPosition));
	tempString = tempString.substr(tempPosition+1,tempString.size());
	tempPosition = tempString.find(",");
	tempVec.z = ofToFloat(tempString.substr(0,tempPosition));
	return tempVec;
}
 
*/

//--------------------------------------------------------------
void testApp::keyPressed(int key){
	switch(key) {
		case 'M':
		case 'm':
//			if(cam.getMouseInputEnabled()) cam.disableMouseInput();
//			else cam.enableMouseInput();
			break;
			
		case 'F':
		case 'f':
			ofToggleFullscreen();
			break;

		case 'L':
		case 'l':
			lookAtMedian();
			break;

		case 'A':
		case 'a':
			manualAlpha = !manualAlpha;
			break;

						
	}

}



void testApp::lookAtMedian() {
	float maxX, minX,maxY,minY,maxZ,minZ;
	medianVector.zero();
	for (list<Atom>::iterator atom = atoms.begin(); atom != atoms.end(); atom++) {
		medianVector += atom->position;
	}
	medianVector /= atoms.size();
	cam.setGlobalPosition(medianVector);
	cam.setPosition(medianVector);
	//stageCenter.setPosition(medianVector);
	//cam.setParent(stageCenter);
	//cam.lookAt(stageCenter);
	cout << medianVector << endl;
}


//--------------------------------------------------------------
void testApp::keyReleased(int key){

}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y){

	cam.orbit(ofGetMouseX(),ofGetMouseY(),distance);


}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){
	distance = x;
}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){
	cam.roll(ofGetMouseX());
}

//--------------------------------------------------------------
void testApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void testApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void testApp::dragEvent(ofDragInfo dragInfo){

}

