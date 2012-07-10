#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
	ofBackground(0, 0, 0, 255);
	ofSetBackgroundAuto(true);
	ofEnableAlphaBlending();
	ofSetWindowTitle("biochemical molecule");
	ofSetFrameRate(60); // if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps.
	ofSetVerticalSync(false);

	manualAlpha = false;
	manualRotation = true;
	sheet = 0;
	helix = 0;

	cout << "listening for osc messages on port " << PORT << "\n";
	receiver.setup(PORT);
	ofSetSphereResolution(8);
	//ofEnableSmoothing();
	//camPosition = ofVec3f(ofGetWidth()/2, ofGetHeight()/2, -200);
	distance = 0;
	previousDistance = 0;
	serial.listDevices();
	serial.setup("COM6", 57600); // initialize com port
	//shader.load("shaders/noise.vert", "shaders/noise.frag");
	shader.setupShaderFromFile(GL_FRAGMENT_SHADER, "shaders/noise.frag");
	shader.linkProgram();
	fbo.allocate(1366,768, GL_RGBA);
	drawFbo.allocate(1366,768, GL_RGBA);
	texture.allocate(1366,768, GL_RGBA);
	ofHideCursor();
}

//--------------------------------------------------------------
void testApp::update(){

	//read serial
	if (!manualRotation) {
		readSerial();
	} else {
		rotation.y = smooth(360*sin((float)ofGetFrameNum()/2000),0.9,rotation.y);
		rotation.x = smooth(180*cos((float)ofGetFrameNum()/3000),0.9,rotation.x);
	}
	if (lastAtom.id != nil) {
		goToAtom(lastAtom);
	}

	//calculate alpha
	alpha = (((float)ofGetMouseX()/(float)ofGetWidth())*128) -64;

	// check for waiting messages
	while(receiver.hasWaitingMessages()){
		// get the next message
		ofxOscMessage m;
		receiver.getNextMessage(&m);
		if(m.getAddress() == "atomID"){
			// both the arguments are int32's
			atomID		=	m.getArgAsInt32 ( 0 );
			posX		=	ofMap(m.getArgAsFloat( 1 ), 100,200, -400 ,400);
			posY		=	ofMap(m.getArgAsFloat( 2 ), -50, 50, -400 ,400);
			posZ		=	ofMap(m.getArgAsFloat( 3 ), -30, 30, -400 ,400);
			bIso		=	ofMap(m.getArgAsFloat( 4 ), 0, 60, 0 , 10);
			type_symbol	=	m.getArgAsString(5);
			groupID		= m.getArgAsInt32(6);
			acid		= m.getArgAsString(7);
			if (lastAtom.id  == nil) {
				camPosition = ofVec3f(posX,posY,posZ);
			}			
			lastAtom = Atom(atomID,ofVec3f(posX,posY,posZ),bIso,type_symbol,groupID,acid);
			atoms.push_back(lastAtom);
		} else if (m.getAddress() == "zoom") {
			float tempDistance = m.getArgAsInt32(0);
			distance = smooth(tempDistance, 0.95, previousDistance);
			previousDistance = distance;
		} else if (m.getAddress() == "manualmode") {
			int tempManMode = m.getArgAsInt32(0);
			if (tempManMode == 0) {
				manualRotation = false;
			} else {
				manualRotation = true;
			}
		} else if (m.getAddress() == "isSheet") {
			if (m.getArgAsInt32(0) == 1) {
				sheet = 1;
			} else {
				sheet = 0;
			}
		} else if (m.getAddress() == "isHelix") {
			if (m.getArgAsInt32(0) == 1) {
				helix = 1;
			} else {
				helix = 0;
			}
		}

	}
}


//--------------------------------------------------------------
void testApp::draw(){
	//ofEnableBlendMode(OF_BLENDMODE_ADD);
	fbo.begin();
	ofClear(0,0,0,1);
	ofTranslate(ofGetWidth()/2,ofGetHeight()/2,450);
	ofFill();
	ofRotateX(rotation.x);
	ofRotateY(rotation.y);
	ofRotateZ(rotation.z);
	ofPushMatrix();
	ofTranslate(-camPosition);
	
	ofSetColor(0,0,0,1);
	lastAtomPosition = ofVec3f(0,0,0);
	lastAtomGroup = 0;
	for (list<Atom>::iterator atom = atoms.begin(); atom != atoms.end(); atom++){
		if (!manualAlpha){
			if (atom->tempTransparency > atom->transparency){
				atom->tempTransparency = atom->tempTransparency - 5;
			}
			ofSetColor(atom->color.r, atom->color.g,atom->color.b, atom->tempTransparency);
		} else {
			int tempAlpha = alpha + atom->color.a;
			if (tempAlpha > 255) tempAlpha = 255;
			if (tempAlpha < 0) tempAlpha = 0;
			ofSetColor(atom->color.r,atom->color.g,atom->color.b,tempAlpha);
		}
		//ofSetColor(255,0,0,128);
		ofSphere(atom->position, atom->displacement*2);
		if (atom != atoms.begin()) {
			int tempAlpha;
			if (manualAlpha) {
				tempAlpha = alpha;
			} else {
				tempAlpha = 0;
			}
			if (atom->group != lastAtomGroup) {

			//	ofSetColor(255,128,0,128+tempAlpha);
			} else {
				ofSetColor(128,255,0,96+(int)tempAlpha);
				ofLine(lastAtomPosition,atom->position);
			}
		}
		lastAtomPosition = atom->position;
		lastAtomGroup = atom->group;
	}
	ofPopMatrix();
	fbo.end();
	//ofDisableBlendMode();
	ofSetColor(255);
	texture = fbo.getTextureReference();

	drawFbo.begin();
	ofClear(0,0,0,1);
		shader.begin();
			shader.setUniformTexture("tex0", texture, 1);
			shader.setUniform2f("resolution", 1366 ,768);
			shader.setUniform1i("dissolution", ofRandom(0,5));
			shader.setUniform1f("time", (1 + (helix*2) + (sheet*2)));
			shader.setUniform1i("transpose", sheet);
			//cout << (float)ofGetMouseY()/100 << endl;
			glBegin(GL_QUADS);  
				glTexCoord2f(0, 0); glVertex3f(0, 0, 0);  
				glTexCoord2f(1366, 0); glVertex3f(1366, 0, 0);  
				glTexCoord2f(1366, 768); glVertex3f(1366, 768, 0);  
				glTexCoord2f(0,768);  glVertex3f(0,768, 0);  
			glEnd(); 
		shader.end();
	drawFbo.end();

	drawFbo.draw(0,0);
	ofSetWindowTitle("biochemical molecule " + ofToString(ofGetFrameRate()));
}

void testApp::goToAtom(Atom atom) {
	camPosition = ofVec3f(smooth(atom.position.x,0.99,camPosition.x),smooth(atom.position.y,0.99,camPosition.y),smooth(atom.position.z,0.99,camPosition.z));
}

void testApp::readSerial() {
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
				cout << rotation << endl;
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
	tempVec.x = -ofToFloat(tempString.substr(0,tempPosition));
	tempString = tempString.substr(tempPosition+1,tempString.size());
	tempPosition = tempString.find(",");
	tempVec.z = ofToFloat(tempString.substr(0,tempPosition));
	tempString = tempString.substr(tempPosition+1,tempString.size());
	tempPosition = tempString.find(",");
	tempVec.y = -ofToFloat(tempString.substr(0,tempPosition));
	return ofVec3f(tempVec.x,tempVec.y,tempVec.z);
	return tempVec;
}
//--------------------------------------------------------------
void testApp::keyPressed(int key){
	switch(key) {
		case 'R':
		case 'r':
			manualRotation = !manualRotation;
			break;

			
		case 'F':
		case 'f':
			ofToggleFullscreen();
			break;

		case 'A':
		case 'a':
			manualAlpha = !manualAlpha;
			break;

		case 'C':
		case 'c':
			for (list<Atom>::iterator atom = atoms.begin(); atom != atoms.end(); atom++) {
				atom = atoms.erase(atom);
			}
	}
}

float testApp::smooth(float data, float filterVal, float smoothedData) {
	if (filterVal > 1){
		filterVal = .99;
	}
	else if (filterVal <= 0){
		filterVal = 0;
	}

  smoothedData = (data * (1 - filterVal)) + (smoothedData  *  filterVal);

  return smoothedData;
}

//--------------------------------------------------------------
void testApp::keyReleased(int key){

}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y){

}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){


}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){

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

