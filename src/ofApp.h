#pragma once

#include "ofxiOS.h"
#include "Ball.h"
#include "ofxOsc.h"

#define HOST "192.168.1.19"
#define SEND_PORT 8000
#define RECEIVE_PORT 8000
#define NUM_MSG_STRINGS 20

class ofApp : public ofxiOSApp{
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
    
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);
	
        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
	
        void gotMessage(ofMessage msg);
    
    private:
    
        int getBallsIndex(ofTouchEventArgs & touch);
    
        vector<Ball> balls;
        map<int, int> touchID;
        ofImage BackgroundPic;
    
        ofxOscSender sender;
        ofxOscReceiver receiver;
        
        int current_msg_string;
        string msg_strings[NUM_MSG_STRINGS];
        float timers[NUM_MSG_STRINGS];
};
