#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){

	//Setup OpenFrameworks stuff
	ofBackground(0, 0, 0, 255);
	ofEnableAlphaBlending();
	ofSetWindowTitle("Biochemical Molecule Sonification Project");
	ofSetFrameRate(60);
	ofSetVerticalSync(false);
	ofSetSphereResolution(8);
	ofHideCursor();

	//Setup the booleans
	manualAlpha = false; //When true, the overall alpha can be controlled manually
	manualRotation = false; //When true, the camera rotation is defined by the 9dof, when false the rotation is automatic
	sheet = 0;
	helix = 0;

	
	//Setup the serial port that will receive data from the 9dof
	//serial.setup("COM6", 57600);
	//Setup the osc receiver
	receiver.setup(PORT);
	sender.setup("127.0.0.1",57120);
	//Camera distance from the atoms
	distance = 0;
	previousDistance = 0;

	//Setup the effect shader
	shader.setupShaderFromFile(GL_FRAGMENT_SHADER, "shaders/noise.frag");
	shader.linkProgram();
	
	//Allocate the texture and the fbos
	fbo.allocate(ofGetWidth(),ofGetHeight(), GL_RGBA);
	drawFbo.allocate(ofGetWidth(),ofGetHeight(), GL_RGBA);
	texture.allocate(ofGetWidth(),ofGetHeight(), GL_RGBA);
}

//--------------------------------------------------------------
void testApp::update(){

	rotateAround(); // Calculate rotation

	if (lastAtom.id != nil) { // Move to last created atom, if an atom has been created
		goToAtom(lastAtom);
	}


	alpha = (((float)ofGetMouseX()/(float)ofGetWidth())*128) -64; //calculate alpha

	getOscMessages(); // Get any incoming Osc messages

}

void testApp::rotateAround(){ 
	if (manualRotation) {
		readSerial(); //rotate using the 9dof
	} else {
		rotation.y = smooth(360*sin((float)ofGetFrameNum()/2000),0.9,rotation.y);	//slowly rotate back and forth 
		rotation.x = smooth(180*cos((float)ofGetFrameNum()/3000),0.9,rotation.x);	//in x and y axes
	}
}

void testApp::getOscMessages(){
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
			atomController.addAtom(lastAtom);
		} else if (m.getAddress() == "zoom") { //remotely zoom in or out
			float tempDistance = m.getArgAsInt32(0);
			distance = smooth(tempDistance, 0.95, previousDistance);
			previousDistance = distance;
		} else if (m.getAddress() == "manualmode") { //remotely enable or disable manual rotation
			int tempManMode = m.getArgAsInt32(0);
			if (tempManMode == 0) {
				manualRotation = false;
			} else {
				manualRotation = true;
			}
		} else if (m.getAddress() == "isSheet") { //set a variable for using to create an effect when drawing with the shader
			if (m.getArgAsInt32(0) == 1) {
				sheet = 1;
			} else {
				sheet = 0;
			}
		} else if (m.getAddress() == "isHelix") { //set a variable for using to create an effect when drawing with the shader
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
	fbo.begin(); //First, we draw the scene completely inside the fbo.
		ofEnableBlendMode(OF_BLENDMODE_ADD); //Using OF_BLENDMODE_ADD for an aesthetically pleasing effect.
		//ofEnableBlendMode(OF_BLENDMODE_ALPHA);
		ofClear(0,0,0,0);
		ofTranslate(ofGetWidth()/2,ofGetHeight()/2,450);
		// ofFill();

		ofRotateX(rotation.x);
		ofRotateY(rotation.y);
		ofRotateZ(rotation.z);
	
		ofPushMatrix();
			ofTranslate(-camPosition);		//Moving the "camera"
			ofSetColor(0,0,0,0.5);
			atomController.draw();			// Drawing the atoms
		ofPopMatrix();
		ofDisableBlendMode();
	fbo.end();							// End drawing to the fbo.
	ofSetColor(255);
	
	texture = fbo.getTextureReference();// Using the fbo as a texture for the shader
	drawFbo.begin();					//Start drawing inside drawFbo
	//ofClear(0,0,0,1);
		shader.begin();					//Beginning shading
			shader.setUniformTexture("tex0", texture, 1);//Setting the texture for use inside the shader
			shader.setUniform2f("resolution", ofGetWidth() ,ofGetHeight());
			shader.setUniform1i("dissolution", ofRandom(0,5));
			shader.setUniform1f("time", (1 + (helix*2) + (sheet*2)));
			shader.setUniform1i("transpose", sheet);
			glBegin(GL_QUADS);			//Creating a rectangle to draw the shaded texture into.
				glTexCoord2f(0, 0); glVertex3f(0, 0, 0);  
				glTexCoord2f(ofGetWidth(), 0); glVertex3f(ofGetWidth(), 0, 0);  
				glTexCoord2f(ofGetWidth(), ofGetHeight()); glVertex3f(ofGetWidth(), ofGetHeight(), 0);  
				glTexCoord2f(0,ofGetHeight());  glVertex3f(0,ofGetHeight(), 0);  
			glEnd(); 
		shader.end();					//Finish shading
	drawFbo.end();						//Finish drawing inside the drawFbo

	drawFbo.draw(0,0);		//Finally we draw the drawFbo

	ofSetWindowTitle("Biochemical Molecule Sonification Project " + ofToString(ofGetFrameRate())); // Displaying the framerate
}

void testApp::goToAtom(Atom atom) { //Smoothly move the camera to each newly created atom
	camPosition = ofVec3f(smooth(atom.position.x,0.99,camPosition.x),smooth(atom.position.y,0.99,camPosition.y),smooth(atom.position.z,0.99,camPosition.z));
}

void testApp::readSerial() {
		int nRead  = 0; 
		unsigned char bytesReturned[1];
		char		bytesRead[1];				
		char		bytesReadString[2];	
		memset(bytesReadString, 0, 2);
		memset(bytesReturned, 0, 1);
		while( (nRead = serial.readBytes( bytesReturned, 1)) > 0){ //We read the serial byte by byte
			memcpy(bytesReadString, bytesReturned, 1);
			if (ofToString(bytesReadString) != "\n") {		//If the byte received is not an endl we add the byte to serialData string.
				serialData += bytesReadString;
			} else {										//When we reach the end of line 
				rotation = calculateRotation(serialData);	//we send the data to calculateRotation() and assign the result to rotation
				serialData = "";							//and empty it.
			}
		};
}

ofVec3f testApp::calculateRotation(string str) {  //Here we split the data received to x-y-z rotations and return a 3d vector 
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
			atomController.clear(); //Erase all atoms.

		case 'S':
		case 's':
			ofxOscMessage m;
			m.setAddress("start");
			sender.sendMessage(m);
	}
}

float testApp::smooth(float data, float filterVal, float smoothedData) {//Smoothing function for smooth transition
	if (filterVal > 1){													//between two values. Taken from:
		filterVal = .99;												//http://arduino.cc/playground/Main/Smooth
	}																	//By Paul Badger
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

