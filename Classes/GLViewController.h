

#define numberOfDarts				10
//10
#define numberOfRooms				3
//3



#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "OpenGLWaveFrontObject.h"
#import "SoundEffect.h"
#import "gluLookAt.h"
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"
#import "HighScores.h"



@class GLView;

@interface GLViewController : UIViewController  <UIAccelerometerDelegate, UITextViewDelegate> {
	//Objects
	OpenGLWaveFrontObject *room[numberOfRooms];
	OpenGLWaveFrontObject *dart[numberOfDarts];	
	//Game Variables
		
	int gameState;
	bool gameStateChanged;
	int currentDartNumber;
	int currentRoomNumber;
	int currentlyFlyingDartNumber;
	//View Variables
	Vertex3D cameraPosition;
	Vertex3D targetPosition;
	Vertex3D initialDartPosition;
	GLfloat zDistance;

	//Physics
	GLfloat dartSpeed, dartSpeedSlow;
	Rotation3D rotationStep;
	GLfloat gravityStep;
	Vertex3D XYStep;
	Vertex3D xyFixingStep;
	
	//Replay function
	NSString *lastMessage;
	Vertex3D dartTrack[1000];
	Vertex3D dartRotations[1000];
	int dartTrackCounter;
	int dartTrackTotal;
	int replayBeep;
	int waitingCounter;
	
	//Main Menu
	bool mainMenuThrow;
	bool mainMenuCameraToTheLeft;
	bool mainMenuCameraToTheRight;
	bool mainMenuWatchTheFirstDart;
	bool mainMenuWatchTheFirstRound;
	
	Vertex3D  initialPosition[numberOfDarts ] ;
	
	
	//Settings
	int settingsCounter;
	
	//Buttons:
	UIView *opaqueView;
	UIButton *playButton;
	UIButton *setupButton;
	UIButton *presentHelpButton;
	UIButton *doneButton;
	UIButton *leftButton;
	UIButton *rightButton;
	UIButton *upButton;
	UIButton *downButton;
	UIImageView *titleImage;
	UITextView *helpTextView;
	UILabel *roomLabel;
	UILabel *distanceLabel;
	UILabel *messageLabel;
	UIWindow *mainWindow;
	bool upButtonActive;
	bool downButtonActive;
	//Controls:
	float xaccel, yaccel, xvelocity, yvelocity;
	CGPoint startLocation;
	bool moved;
	
	NSTimeInterval lastTime;
	
	//Display
	
	UILabel *dartNumberLabel;
	UILabel *scoreLabel;
	int score;
	
	

	//Scores:
	HighScores  *myHighScores;
	
	//Audio
	SoundEffect *buttonSound;
	SoundEffect *targetSound[5];
	SoundEffect *wallSound[5];
	SoundEffect *floorSound[5];
	SoundEffect *innerBullSound;
	SoundEffect *outerBullSound;
	SoundEffect *scrollSound;
	SoundEffect *hurryUP;
	AVAudioPlayer *introMusic;
	AVAudioPlayer *roomAmbientSound[3];
	


	
	



}
- (void)drawView:(GLView*)view;
- (void)setupView:(GLView*)view;

//Custom:

-(void)getSettingsFromDelegate;
-(void)setSettingsToDelegate;
-(void)mainMenuAnimation;
-(void)setupAnimation;
-(void)targetAnimation;
-(void)flightAnimation;
-(void)replayAnimation;
-(void)highScoresAnimation;
-(void)highScoresAnimation;
-(void)setTheGameState:(int )newGameState;
-(Rotation3D )checkRotations:(Rotation3D ) therotation;
-(void) setMainMenu;
-(NSString *) roomNames:(int) rmNum;
- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;
-(void)showMessage:(NSString *)message;
-(int)triangulateTheScore;
-(void)updateLabels;
-(NSString *)messageGenerator:(bool) positiveFactor;
-(NSString *) generateScoreMessage;

@end
