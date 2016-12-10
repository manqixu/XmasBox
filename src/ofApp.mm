#include "ofApp.h"

#define INVALIDDRAG					-1


//--------------------------------------------------------------
void ofApp::setup(){	
	ofBackground(225, 225, 225);
	ofSetCircleResolution(80);
    ofSetLogLevel(OF_LOG_VERBOSE);
    
    BackgroundPic.load("background.jpg");
    BackgroundPic.resize(ofGetWidth(), ofGetHeight());

	// initialize the accelerometer
	ofxAccelerometer.setup();
	
	balls.assign(1, Ball());
	
	// initialize all of the Ball particles
	for(int i=0; i<balls.size(); i++){
		balls[i].init(i);
	}
    
    // open an outgoing connection to HOST:PORT
    sender.setup( HOST, SEND_PORT );
    
    // listen on the given port
    receiver.setup( RECEIVE_PORT );
    
    current_msg_string = 0;
}


//--------------------------------------------------------------
void ofApp::update() {
	for(int i=0; i < balls.size(); i++){
		balls[i].update();
	}
    
    // hide old messages
    for( int i=0; i<NUM_MSG_STRINGS; i++ ){
        if( timers[i] < ofGetElapsedTimef() )
            msg_strings[i] = "";
    }
    
    // check for waiting messages
    while( receiver.hasWaitingMessages() ){
        // get the next message
        ofxOscMessage m;
        receiver.getNextMessage(m);
        
        // check for mouse touchDoubleTap message
        if( m.getAddress() == "/mouse/touchDoubleTap" ){
            // both the arguments are int32's
            balls.insert(balls.end(),Ball());
            balls[balls.size() - 1].init(balls.size() - 1);
            balls[balls.size() - 1].moveTo(m.getArgAsInt32( 0 ), m.getArgAsInt32( 1 ));
        }else{
            // unrecognized message: display on the bottom of the screen
            string msg_string;
            msg_string = m.getAddress();
            msg_string += ": ";
            for( int i=0; i<m.getNumArgs(); i++ ){
                // get the argument type
                msg_string += m.getArgTypeName( i );
                msg_string += ":";
                // display the argument - make sure we get the right type
                if( m.getArgType( i ) == OFXOSC_TYPE_INT32 )
                    msg_string += ofToString( m.getArgAsInt32( i ) );
                else if( m.getArgType( i ) == OFXOSC_TYPE_FLOAT )
                    msg_string += ofToString( m.getArgAsFloat( i ) );
                else if( m.getArgType( i ) == OFXOSC_TYPE_STRING )
                    msg_string += m.getArgAsString( i );
                else
                    msg_string += "unknown";
            }
            // add to the list of strings to display
            msg_strings[current_msg_string] = msg_string;
            timers[current_msg_string] = ofGetElapsedTimef() + 5.0f;
            current_msg_string = ( current_msg_string + 1 ) % NUM_MSG_STRINGS;
            // clear the next line
            msg_strings[current_msg_string] = "";
        }
    }

}

//--------------------------------------------------------------
void ofApp::draw() {
    BackgroundPic.draw(0,0);

	ofEnableAlphaBlending();

	ofPushStyle();
		ofEnableBlendMode(OF_BLENDMODE_MULTIPLY);
		for(int i = 0; i< balls.size(); i++){
			balls[i].draw();
		}
	ofPopStyle();
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    int index = getBallsIndex(touch);
    if(index != INVALIDDRAG) {
        touchID[touch.id] = index;
        balls[index].moveTo(touch.x, touch.y);
        balls[index].bDragged = true;
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    if(getBallsIndex(touch) != INVALIDDRAG) {
        balls[touchID[touch.id]].moveTo(touch.x, touch.y);
        balls[touchID[touch.id]].bDragged = true;
    }
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
	balls[touchID[touch.id]].bDragged = false;
    touchID.erase(touch.id);
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    int index = getBallsIndex(touch);
    if(index == INVALIDDRAG) {
        balls.insert(balls.end(),Ball());
        balls[balls.size() - 1].init(balls.size() - 1);
        balls[balls.size() - 1].moveTo(touch.x, touch.y);
        // send a message to the other device
        ofxOscMessage m;
        m.setAddress( "/mouse/touchDoubleTap" );
        m.addIntArg( touch.x );
        m.addIntArg( touch.y );
        sender.sendMessage( m );
    } else {
        balls.erase(balls.begin() + index);
    }
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    
}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){
	
}

int ofApp::getBallsIndex(ofTouchEventArgs & touch) {
    for(int i = 0; i < balls.size(); i++) {
        if(balls[i].pos.x < touch.x + RADIUS && balls[i].pos.x > touch.x - RADIUS
           && balls[i].pos.y < touch.y + RADIUS && balls[i].pos.y > touch.y - RADIUS) {
            return i;
        }
    }
    return INVALIDDRAG;
}

