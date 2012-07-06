#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){
	ofBackground(200, 200, 200, 200);
	ofSetBackgroundAuto(true);
	ofEnableSmoothing();
	ofEnableAlphaBlending(); 
	ofSetWindowTitle("biochemical molecule");
	batang.loadFont("/Users/ari/Media/fonts/favorites/Batang.ttf", 9, true, true);
	ofSetFrameRate(60); // if vertical sync is off, we can go a bit fast... this caps the framerate at 60fps.
	ofSetVerticalSync(false);

	
	// listen on the given port
	cout << "listening for osc messages on port " << PORT << "\n";
	receiver.setup(PORT);

	current_msg_string = 0;
	mouseX = 0;
	mouseY = 0;
	mouseButtonState = "";

	ofSetSphereResolution(4);
	ofEnableSmoothing();
	ofEnablePointSprites();

}

//--------------------------------------------------------------
void testApp::update(){

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
			atomID					=	m.getArgAsInt32 ( 0 );
			posX[atomID]			=	ofMap(m.getArgAsFloat( 1 ), 100,200, 0 ,ofGetWidth());
			posY[atomID]			=	ofMap(m.getArgAsFloat( 2 ), -50, 50, 0 ,ofGetHeight());
			posZ[atomID]			=	ofMap(m.getArgAsFloat( 3 ), -30, 30, 0 ,400);
			bIso[atomID]			=	ofMap(m.getArgAsFloat( 4 ), 0, 50, 0 , 10);
			type_symbol[atomID]		=	m.getArgAsString( 5 );
			
			//batang.drawString("conditions:" + conditions[cityID], ofGetWidth()-200, 2*15);
			
//			ofSetColor(255, 255, 255);
//			ofFill();
//			ofBox(m.getArgAsFloat(0), m.getArgAsFloat(1), m.getArgAsFloat(2), 5);
		}
		if (numAtoms < atomID)	{				
			numAtoms = atomID;
			//triangulator.addPoint(lonToX(longitude[cityID]), latToY(latitude[cityID]));	
		}
	}
}


//--------------------------------------------------------------
void testApp::draw(){
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); // GL_SRC_ALPHA_SATURATE,GL_ONE     GL_SRC_ALPHA, GL_ONE
	ofFill();	
	ofSetColor(0,0,0,10);
	ofRect(0,0,ofGetWidth(),ofGetHeight());			

	ofPushMatrix();         // push the current coordinate position
    ofRotateX(ofGetMouseY());          // change the coordinate system
    ofRotateY(ofGetMouseX());          // change the coordinate system	
	//ofSetColor(255, 255, 255);
	for (int i = 0; i < atomID; i++) {
		//cout << type_symbol[i] << endl;
		if (type_symbol[i] == "N") {
			ofSetColor(255, 0, 0, 25);
		} else if (type_symbol[i] == "C") {
			ofSetColor(125, 125, 125, 25);
		} else if (type_symbol[i] == "O") {
			ofSetColor(0,0,255, 25);			
		} else {
			ofSetColor(255,255,255, 25);
		}
		ofSphere(posX[i], posY[i], posZ[i], bIso[i]);			
	}
    ofPopMatrix();

}

//--------------------------------------------------------------
void testApp::keyPressed(int key){
	switch(key) {
		case 'M':
		case 'm':
			if(cam.getMouseInputEnabled()) cam.disableMouseInput();
			else cam.enableMouseInput();
			break;
			
		case 'F':
		case 'f':
			ofToggleFullscreen();
			break;
	}

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
