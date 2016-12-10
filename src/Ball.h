#pragma once

#define BOUNCE_FACTOR			0.7
#define ACCELEROMETER_FORCE		0.2
#define RADIUS					25

#define NUM_SAMPLE              23
#define NUM_BALL_IMAGE          9


class Ball{

    public:
        ofPoint pos;
        ofPoint vel;
        bool bDragged;
        ofImage ballImage;
        ofSoundPlayer MusicPlayer;
	
        //----------------------------------------------------------------
        void init(int id) {
            pos.set(ofRandomWidth(), ofRandomHeight(), 0);
            vel.set(ofRandomf(), ofRandomf(), 0);
            
            ballImage.load("ball/Ball" + ofToString(rand() % NUM_BALL_IMAGE + 1) + ".png");
		
            bDragged = false;
            
        }
	
        //----------------------------------------------------------------	
        void update() {
            vel.x += ACCELEROMETER_FORCE * ofxAccelerometer.getForce().x * ofRandomuf();
            vel.y += -ACCELEROMETER_FORCE * ofxAccelerometer.getForce().y * ofRandomuf();        // this one is subtracted cos world Y is opposite to opengl Y
		
            // add vel to pos
            pos += vel;
		
            // check boundaries
            if(pos.x < RADIUS) {
                pos.x = RADIUS;
                vel.x *= -BOUNCE_FACTOR;
                playRandom();
            } else if(pos.x >= ofGetWidth() - RADIUS) {
                pos.x = ofGetWidth() - RADIUS;
                vel.x *= -BOUNCE_FACTOR;
                playRandom();
            }
		
            if(pos.y < RADIUS) {
                pos.y = RADIUS;
                vel.y *= -BOUNCE_FACTOR;
                playRandom();
            } else if(pos.y >= ofGetHeight() - RADIUS) {
                pos.y = ofGetHeight() - RADIUS;
                vel.y *= -BOUNCE_FACTOR;
                playRandom();
            }
        }
	
        //----------------------------------------------------------------
        void draw() {
            if( bDragged ){
                ballImage.resize(RADIUS * 3, RADIUS * 3);
                ballImage.draw(pos.x - RADIUS * 1.5, pos.y - RADIUS * 1.5);
            }else{
                ballImage.resize(RADIUS * 2, RADIUS * 2);
                ballImage.draw(pos.x - RADIUS, pos.y - RADIUS);
            }
        }
	
        //----------------------------------------------------------------	
        void moveTo(int x, int y) {
            pos.set(x, y, 0);
            vel.set(0, 0, 0);
        }
    
        void playRandom() {
            MusicPlayer.load("music/MusicBox" + ofToString(rand() % NUM_SAMPLE + 1) + ".aif");
            MusicPlayer.setVolume(0.8);
            MusicPlayer.play();
        }
};
