
// CONSTANTS
#define SIGN(x)	((x < 0.0f) ? -1.0f : 1.0f)
#define kFilteringFactor			0.1
#define kAccelerometerFrequency		20.0 // Hz
#define kSpeedFactor		800.0 // Hz

#define kGravityForce		0.9 // G-Force
#define kWaitingTime		40//frames to wait
#define kReplaySlowDownFactor 6//Has to be int 6 means 6 times slower

#import "GLViewController.h"
#import "GLView.h"


#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
@implementation GLViewController

-(void)setupView:(GLView*)view
{		
	
	srandom(time(NULL));
	
	//Retrieving Settings
	[self getSettingsFromDelegate];
		
	//Setup Game Variables

	

	//Setup Physics
	
	
	const GLfloat			lightAmbient[] = {0.2, 0.2, 0.2, 1.0};
	const GLfloat			lightDiffuse[] = {1.0, 1.0, 1.0, 1.0};
	
	const GLfloat			lightPosition[] = {5.0, -2.0, -15.0, 0.0}; 
	const GLfloat			light2Position[] = {-5.0, -2.0, -15.0, 0.0};
	const GLfloat			lightShininess = 0.0;
	const GLfloat			zNear = 0.01, zFar = 250.0, fieldOfView = 45.0; 
	GLfloat size; 
	glEnable(GL_DEPTH_TEST);
	glMatrixMode(GL_PROJECTION);
	
	size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0); 
	CGRect rect = view.bounds; 
	glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / 
			   (rect.size.width / rect.size.height), zNear, zFar); 
	glViewport(0, 0, rect.size.width, rect.size.height);  
	glMatrixMode(GL_MODELVIEW);
	glShadeModel(GL_SMOOTH); 
	glEnable(GL_LIGHTING);
	
	
	glEnable(GL_LIGHT0);
	glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient);
	glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse);
	glLightfv(GL_LIGHT0, GL_POSITION, lightPosition); 
	glLightfv(GL_LIGHT0, GL_SHININESS, &lightShininess);
	
	glEnable(GL_LIGHT1);
	glLightfv(GL_LIGHT1, GL_AMBIENT, lightAmbient);
	glLightfv(GL_LIGHT2, GL_DIFFUSE, lightDiffuse);
	glLightfv(GL_LIGHT2, GL_POSITION, light2Position); 
	glLightfv(GL_LIGHT2, GL_SHININESS, &lightShininess);
	
	
	
		
	glLoadIdentity(); 
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f); 	
	
	
	glGetError(); // Clear error codes
	
	
	
	for(int i=0;i<numberOfRooms;i++){
	
		room[i] = [[OpenGLWaveFrontObject alloc] initWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"room%i",i] ofType:@"obj"]];

	
	
	}
	
	

	
	for(int i=0;i<numberOfDarts;i++){
	
		dart[i] = [[OpenGLWaveFrontObject alloc] initWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"dart%i",i] ofType:@"obj"]];
				
		
	}


	//SetupButtons
	
	
	
	opaqueView=[[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
	opaqueView.alpha=.4;
	opaqueView.backgroundColor=[UIColor blackColor];
	
	titleImage=[[UIImageView alloc]init];
	titleImage.frame=CGRectMake(20.0f, 10.0f, 280.0f, 50.0f);
	titleImage.image=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gameTitle" ofType:@"png"]];
	
	playButton = [[UIButton alloc] initWithFrame:CGRectMake(-320.0f, 302, 211, 50)];
	[playButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"playButton" ofType:@"png"]] forState:UIControlStateNormal];
	[playButton addTarget:self action:@selector(playGameButtonPressed:) forControlEvents:UIControlEventTouchDown];
	
	setupButton = [[UIButton alloc] initWithFrame:CGRectMake(-320.0f, 362, 211, 50)];
	[setupButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settingsButton" ofType:@"png"]] forState:UIControlStateNormal];
	[setupButton addTarget:self action:@selector(setupButtonPressed:) forControlEvents:UIControlEventTouchDown];
	
	doneButton = [[UIButton alloc] initWithFrame:CGRectMake(-320.0f, 422, 211, 50)];
	[doneButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"doneButton" ofType:@"png"]] forState:UIControlStateNormal];
	[doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchDown];
	
	leftButton = [[UIButton alloc] initWithFrame:CGRectMake(20, -80, 66, 70)];
	[leftButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"leftArrow" ofType:@"png"]] forState:UIControlStateNormal];
	[leftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchDown];
	
	
	rightButton = [[UIButton alloc] initWithFrame:CGRectMake(240.0f, -80, 66, 70)];
	[rightButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rightArrow" ofType:@"png"]] forState:UIControlStateNormal];
	[rightButton addTarget:self action:@selector(rightButtonPressed:) forControlEvents:UIControlEventTouchDown];
	
	
	
	roomLabel=[[UILabel alloc]initWithFrame:CGRectMake(78, -80, 160, 40)];
	roomLabel.font=[UIFont  fontWithName:@"MarkerFelt-Thin" size:22];
	roomLabel.textAlignment=UITextAlignmentCenter;
	roomLabel.text= [self roomNames:currentRoomNumber];
	roomLabel.backgroundColor=[UIColor blackColor];
	roomLabel.alpha=.4f;
	roomLabel.textColor=[UIColor whiteColor];
	
	/////
	
	
	upButton = [[UIButton alloc] initWithFrame:CGRectMake(-150, 280, 70, 40)];
	[upButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"upArrow" ofType:@"png"]] forState:UIControlStateNormal];
	[upButton addTarget:self action:@selector(upButtonPressed:) forControlEvents:UIControlEventTouchDown];
	[upButton addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchCancel];
	[upButton addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchUpInside];
		[upButton addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchUpOutside];
	upButtonActive=NO;
	
	downButton = [[UIButton alloc] initWithFrame:CGRectMake(-150, 350, 70, 40)];
	[downButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"downArrow" ofType:@"png"]] forState:UIControlStateNormal];
	[downButton addTarget:self action:@selector(downButtonPressed:) forControlEvents:UIControlEventTouchDown];
	[downButton addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchCancel];
	[downButton addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchUpInside];
	[downButton addTarget:self action:@selector(buttonCancel:) forControlEvents:UIControlEventTouchUpOutside];
	downButtonActive=NO;
	
	
	distanceLabel=[[UILabel alloc]initWithFrame:CGRectMake(-200, 315, 180, 35)];
	distanceLabel.font=[UIFont  fontWithName:@"MarkerFelt-Thin" size:18];
	distanceLabel.textAlignment=UITextAlignmentCenter;
	
	int labelDistance;
	labelDistance=-zDistance*3;
	distanceLabel.text= [NSString stringWithFormat:@"Distance: %i inches",labelDistance];
	distanceLabel.backgroundColor=[UIColor blackColor];
	distanceLabel.textColor=[UIColor whiteColor];
	distanceLabel.alpha=.4f;
	
	dartNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 20)];
	dartNumberLabel.font=[UIFont  fontWithName:@"Georgia" size:18];
	dartNumberLabel.textAlignment=UITextAlignmentLeft;
	dartNumberLabel.text= [NSString stringWithFormat:@"Dart: %i/%i",currentlyFlyingDartNumber+1,numberOfDarts];
	dartNumberLabel.backgroundColor=[UIColor clearColor];
	dartNumberLabel.textColor=[UIColor yellowColor];
	
	scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(210, 10, 150, 20)];
	scoreLabel.font=[UIFont  fontWithName:@"Georgia" size:18];
	scoreLabel.textAlignment=UITextAlignmentLeft;
	scoreLabel.text= [NSString stringWithFormat:@"Score: %i",score];
	scoreLabel.backgroundColor=[UIColor clearColor];
	scoreLabel.textColor=[UIColor yellowColor];
	
	messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(00, 150, 320, 100)];
	messageLabel.font=[UIFont  fontWithName:@"MarkerFelt-Thin" size:48];
	messageLabel.textAlignment=UITextAlignmentCenter;
	messageLabel.text= [self roomNames:currentRoomNumber];
	messageLabel.backgroundColor=[UIColor clearColor];
	messageLabel.textColor=[UIColor yellowColor];
	messageLabel.alpha=0.0f;
	
	/////
	
	
	
	
	presentHelpButton = [[UIButton alloc] initWithFrame:CGRectMake(-320.0f, 422, 211, 50)];
	[presentHelpButton setImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"helpButton" ofType:@"png"]] forState:UIControlStateNormal];
	[presentHelpButton addTarget:self action:@selector(presentHelpButtonPressed:) forControlEvents:UIControlEventTouchDown];
	
	
	helpTextView=[[UITextView alloc]initWithFrame:CGRectMake(330, 70, 260, 340)];
	//helpTextView.text=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help" ofType:@"txt"]];
	//helpTextView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"brickwall" ofType:@"png"]]];
	helpTextView.backgroundColor=[UIColor blackColor];
	helpTextView.textColor=[UIColor whiteColor];
	helpTextView.font= [UIFont fontWithName:@"Georgia" size:18];
	helpTextView.editable=NO;
	helpTextView.alpha=.5;
	helpTextView.scrollEnabled=YES;
	helpTextView.bounces=NO;
	helpTextView.delegate=self;
	//Setup Help Text
	
	
	NSArray *windows = [[UIApplication sharedApplication] windows];
	mainWindow = [windows objectAtIndex:0];
	//mainWindow =[[UIApplication sharedApplication]mainWindow];
	
	[mainWindow addSubview:messageLabel];
	[mainWindow addSubview:opaqueView];
	[mainWindow addSubview:titleImage];
	[mainWindow addSubview:playButton];
	[mainWindow addSubview:setupButton];
	[mainWindow addSubview:doneButton];
	[mainWindow addSubview:leftButton];
	[mainWindow addSubview:rightButton];
	[mainWindow addSubview:helpTextView];
	[mainWindow addSubview:roomLabel];
	[mainWindow addSubview:upButton];
	[mainWindow addSubview:downButton];
	[mainWindow addSubview:distanceLabel];
	
	
	[mainWindow addSubview:presentHelpButton];
	
	//Loading sounds
	buttonSound = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button" ofType:@"wav"]];
	scrollSound=[[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"scroll" ofType:@"wav"]];
	
	for (int i=0;i<5;i++){
		targetSound[i] = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"target%i",i] ofType:@"wav"]];
		wallSound[i] = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"wall%i",i] ofType:@"wav"]];
		floorSound[i] = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"floor%i",i] ofType:@"wav"]];
	}
	
	innerBullSound = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"innerBull" ofType:@"aif"]];
	outerBullSound = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"outerBull" ofType:@"aif"]];
	hurryUP = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hurryup" ofType:@"wav"]];
	
	
	introMusic = [[AVAudioPlayer alloc]
			  initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/intro.aif",[[NSBundle mainBundle] resourcePath]]] error:NULL];
	introMusic.volume=.5f;
	introMusic.numberOfLoops=10000;
	
	for (int i=0;i<numberOfRooms;i++){
		roomAmbientSound[i] = [[AVAudioPlayer alloc]
					 initWithContentsOfURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/room%i.aif",[[NSBundle mainBundle] resourcePath],i ]] error:NULL];
		roomAmbientSound[i].volume=.2f;
		roomAmbientSound[i].numberOfLoops=10000;
		
	}
	
	

	
//	//Configure and start accelerometer
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelerometerFrequency)];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
	
	//Setup the initial game state
	gameState=-1;//Needded in order t avoid cleanup initially
	[self setTheGameState:0];
}
#pragma mark Animations

- (void)drawView:(GLView*)view;
{
	
	//	glGetError(); // Clear error codes
	//glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glClear(GL_DEPTH_BUFFER_BIT);
	glLoadIdentity(); 
	glColor4f(0.0, 0.5, 1.0, 1.0);
	glDisable(GL_BLEND);
	
	
	

	
	//Select Game State:
	gameStateChanged=NO;
	int gamePhase=gameState;
	gameState=0;
//	NSLog(@"%i",gamePhase);
	if(gamePhase==0){
		
		[self mainMenuAnimation];
	}else if (gamePhase==1){
		
		[self mainMenuAnimation];
		
	}else if (gamePhase==2){
		[self mainMenuAnimation];
		
	}else if (gamePhase==3){
		[self setupAnimation];
		
		
	}else if (gamePhase==4){
		[self targetAnimation];
		
	}else if (gamePhase==5){
		[self flightAnimation];
	}else if (gamePhase==6){
		[self replayAnimation];
	}else if (gamePhase==7){
		[self highScoresAnimation];
	}
	
	if (gameStateChanged==NO) gameState=gamePhase;
	
	
	const GLfloat			lightAmbient[] = {0.2, 0.2, 0.2, 1.0};
	const GLfloat			lightDiffuse[] = {1.0, 1.0, 1.0, 1.0};
	
	const GLfloat			lightPosition[] = {5.0, 2.0, -15.0, 0.0}; 
	const GLfloat			light2Position[] = {0.0, 2.0, -1.0, 0.0};
	const GLfloat			lightShininess = 0.0;
	//glEnable(GL_LIGHT0);
	glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient);
	glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse);
	glLightfv(GL_LIGHT0, GL_POSITION, lightPosition); 
	glLightfv(GL_LIGHT0, GL_SHININESS, &lightShininess);
	
	//glEnable(GL_LIGHT1);
	glLightfv(GL_LIGHT1, GL_AMBIENT, lightAmbient);
	glLightfv(GL_LIGHT2, GL_DIFFUSE, lightDiffuse);
	glLightfv(GL_LIGHT2, GL_POSITION, light2Position); 
	glLightfv(GL_LIGHT2, GL_SHININESS, &lightShininess);
	
}

-(void)mainMenuAnimation{
	//Retrieving Dart's position
	
	Vertex3D dartPos, dartPosForLook;
	Rotation3D dartRot;
	bool incrementFlag=NO;
	dartPos=dart[currentlyFlyingDartNumber].currentPosition;
	dartRot=dart[currentlyFlyingDartNumber].currentRotation;
	
	
	//Setup the camera angle:
	if ((mainMenuWatchTheFirstDart==YES) &(mainMenuWatchTheFirstRound==NO)){
		dartPosForLook=dart[0].currentPosition;

		gluLookAt (cameraPosition.x, cameraPosition.y, cameraPosition.z,
				   0.0, -3.0,dartPosForLook.z,
				   0.0, 1.0, 0.0);
		
	}else{
		gluLookAt (cameraPosition.x, cameraPosition.y, cameraPosition.z,
				   0.0, -3.0,0.0,
				   0.0, 1.0, 0.0);
	
	}
	
	
	//Drawing
	
	[room[currentRoomNumber] drawSelf];
	
	
	for (int i=0;i<5;i++){
		[dart[i] drawSelf];
		
	}
	
	
	//Throwing
	if (mainMenuThrow==YES){
		
		
		if ((mainMenuWatchTheFirstDart==YES) & (currentlyFlyingDartNumber==0)) dartPos.z=dartPos.z-1;
		
	if (dartPos.z<0){
	dartPos.z=dartPos.z+2;
		
	
		
		dartRot.z=dartRot.z+(random()%10)/10;
	}else{
	
		currentlyFlyingDartNumber++;
		incrementFlag=YES;
		if (currentlyFlyingDartNumber==5){
			mainMenuThrow=NO;
			mainMenuCameraToTheLeft=YES;
			mainMenuCameraToTheRight=NO;
			
			if ((mainMenuWatchTheFirstDart==YES)&(mainMenuWatchTheFirstRound==NO)) {
				mainMenuWatchTheFirstRound=YES;
			}else{
				mainMenuWatchTheFirstRound=NO;
				mainMenuWatchTheFirstDart=YES;
			}
			
		}
		
	}
	}
	
	//moving Camera
	
	if (mainMenuCameraToTheLeft==YES){
	
		if (cameraPosition.x>-20) {
		cameraPosition.x=cameraPosition.x-.5;
		cameraPosition.z=cameraPosition.z-.1;
		
		}
		else{
		
			mainMenuThrow=NO;
			mainMenuCameraToTheLeft=NO;
			mainMenuCameraToTheRight=YES;
			mainMenuWatchTheFirstDart=YES;
			[self setMainMenu];	
		} 
	}
	
	if (mainMenuCameraToTheRight==YES){
		Vertex3D poz;
		for (int i=0;i<5;i++){
			poz=dart[i].currentPosition;
			if(poz.z>initialPosition[i].z){
				poz.z=poz.z-.5;
				dart[i].currentPosition=poz;
				
			}
		}
		
		
		if (cameraPosition.x<5) {
			cameraPosition.x=cameraPosition.x+.125;
			cameraPosition.z=cameraPosition.z+.025;
			
			
		}else{
		
			mainMenuThrow=YES;
			mainMenuCameraToTheLeft=NO;
			mainMenuCameraToTheRight=NO;
			currentlyFlyingDartNumber=0;
			incrementFlag=YES;

		}
		
	
		
	}
	
	
		
	
	
	//assigning dart's position
	if (incrementFlag==NO){
	dart[currentlyFlyingDartNumber].currentPosition=dartPos;
	dartRot=[self checkRotations:dartRot];
	dart[currentlyFlyingDartNumber].currentRotation=dartRot;
	}
	
}

-(void)setupAnimation{
	
	Vertex3D dartPos;
	Rotation3D dartRot;
	//dartPos=dart[0].currentPosition;
	dartRot=dart[0].currentRotation;
	dartRot.z=dartRot.z+.4;
	dartRot=[self checkRotations:dartRot];
	
	if ((upButtonActive==YES)& (zDistance<-30.0)) {
	zDistance=zDistance+.1;
	cameraPosition.z=zDistance;
		settingsCounter++;
		if (settingsCounter==10){
			settingsCounter=0;
			int labelDistance;
			labelDistance=-zDistance*3;
			distanceLabel.text= [NSString stringWithFormat:@"Distance: %i inches",labelDistance];
		}
		
	}
	if ((downButtonActive==YES) &(zDistance>-75.0)){
		zDistance=zDistance-.1;
		cameraPosition.z=zDistance;
		
		settingsCounter++;
		if (settingsCounter==10){
			settingsCounter=0;
			int labelDistance;
			labelDistance=-zDistance*3;
			distanceLabel.text= [NSString stringWithFormat:@"Distance: %i inches",labelDistance];
		}
	}
	
	dartPos.x=cameraPosition.x-2;
	dartPos.y=cameraPosition.y-3;
	dartPos.z=cameraPosition.z+10;
	
	
	
	
	gluLookAt (cameraPosition.x, cameraPosition.y, cameraPosition.z,
			   0.0, -3.0,0.0,
			   0.0, 1.0, 0.0);
	
	
	dart[0].currentPosition=dartPos;
	dart[0].currentRotation=dartRot;
	[room[currentRoomNumber] drawSelf];
	[dart[0] drawSelf];

	
	
}


-(void)targetAnimation{
	
	
	dartTrackCounter++;
	if (dartTrackCounter==300){
		[hurryUP play];
		dartTrackCounter=0;
	
	}
	Vertex3D dartPos;
	Rotation3D dartRot;
	
	dartRot=dart[currentlyFlyingDartNumber].currentRotation;
	dartRot.z=dartRot.z+.4;
	dartRot=[self checkRotations:dartRot];


	
	
	 //Good formula, save for later
	GLfloat tanx, atanx;
	tanx = targetPosition.x / zDistance;
	
	atanx = atan(tanx); // (result in radians)
	
	dartRot.y= -(atanx * 180 / M_PI); // converted to degrees
	
	
	tanx = targetPosition.y / zDistance;
	
	atanx = atan(tanx); // (result in radians)
	
	dartRot.x= (atanx * 180 / M_PI); // converted to degrees
	
	
	
	
	
		
	targetPosition.x=targetPosition.x+xvelocity;
	targetPosition.y=targetPosition.y+yvelocity;

	// Check for boundary conditions so the target stays on-screen
	if (targetPosition.x > 50.0) targetPosition.x = 50.0;
	if (targetPosition.x < -50.0) targetPosition.x = -50.0f;
	if (targetPosition.y > 50.0) targetPosition.y = 50.0;
	if (targetPosition.y < -50.0) targetPosition.y = -50.0f;
	
	
	
	gluLookAt (cameraPosition.x, cameraPosition.y, cameraPosition.z,
			   targetPosition.x, targetPosition.y,targetPosition.z,
			   0.0, 1.0, 0.0);
	
	//initialDartPosition.x=-targetPosition.x;
	//initialDartPosition.y=-targetPosition.y;
	
	dartPos.x=initialDartPosition.x;
	dartPos.y=initialDartPosition.y;
	dartPos.z=initialDartPosition.z;
	
	//drawing
	dart[currentlyFlyingDartNumber].currentPosition=dartPos;
	dart[currentlyFlyingDartNumber].currentRotation=dartRot;
	[room[currentRoomNumber] drawSelf];
	int tempDartNum=currentlyFlyingDartNumber+1;
	for (int i=0;i<tempDartNum;i++){
	[dart[i] drawSelf];
	}
	
}

-(void)flightAnimation{
	
	Vertex3D dartPos;
	Rotation3D dartRot;
	dartPos=dart[currentlyFlyingDartNumber].currentPosition;
	dartRot=dart[currentlyFlyingDartNumber].currentRotation;
	
	dartPos.z=dartPos.z+dartSpeed;
	
	
	//Fixing steps;
	dartPos.x-=xyFixingStep.x;
	dartPos.y-=xyFixingStep.y;
	//Physics
	
	dartPos.x=dartPos.x+XYStep.x;
	//Also apply gravity forces
	gravityStep=gravityStep/kGravityForce;
	dartPos.y=dartPos.y-XYStep.y-gravityStep;
	if (gravityStep>dartSpeedSlow) {
		if	(dartRot.x<45){
		dartRot.x= dartRot.x+2;
			dartPos.y=dartPos.y-0.1;
		}
	}else{
		//It looks ok and simple
		if (dartRot.x>0) dartRot.x=dartRot.x-dartSpeedSlow;
		if (dartRot.x<0) dartRot.x=dartRot.x+dartSpeedSlow;
			
	}
	
	
	if ((dartPos.y<-30) & (dartRot.x<30)){
		//Straighten the position on the floor
		dartRot.x=dartRot.x/3;
		
		
	}
	
	if (dartPos.y<-35) {
		//hit the floor
		dartSpeed=0;
		rotationStep.x=0;
		rotationStep.y=0;
		rotationStep.z=0;
		XYStep.x=0;
		XYStep.y=0;
		xyFixingStep.x=0;
		xyFixingStep.y=0;
		gravityStep=0;
		dartPos.y=-35;
		dartRot.x=0;
	
		
		gluLookAt (cameraPosition.x, cameraPosition.y, cameraPosition.z,
				   targetPosition.x, targetPosition.y,targetPosition.z,
				   0.0, 1.0, 0.0);
		
		//drawing
		dart[currentlyFlyingDartNumber].currentPosition=dartPos;
		dart[currentlyFlyingDartNumber].currentRotation=dartRot;
		//Tracking
		dartTrack[dartTrackCounter]=dartPos;
		dartRotations[dartTrackCounter]=dartRot;
		dartTrackCounter++;
		
		[room[currentRoomNumber] drawSelf];
		int tempDartNum=currentlyFlyingDartNumber+1;
		for (int i=0;i<tempDartNum;i++){
			[dart[i] drawSelf];
		}
		
		
		
		//change the game state
		//Sound
		[floorSound[random()%5] play];
		currentlyFlyingDartNumber++;
		if (currentlyFlyingDartNumber == numberOfDarts){
			//Change this to scores
			//score=score+[self triangulateTheScore];
			scoreLabel.text= [NSString stringWithFormat:@"Score: %i",score];
			[self showMessage:[self messageGenerator:NO]];
			gameState=5;
			[self setTheGameState:6];
			
			return;
		}
		
		[self showMessage:[self messageGenerator:NO]];
		gameState=5;
		[self setTheGameState:6];

		return;

	
	}
	//hit the ceiling:
	if (dartPos.y>17) {
		gravityStep=.1;
		dartSpeed=dartSpeed*.5;
		XYStep.x=0;
		XYStep.y=0;
		xyFixingStep.x=90;
		xyFixingStep.y=0;
		
	}
	
	
	dartRot.x=dartRot.x+rotationStep.x;
	dartRot.y=dartRot.y+rotationStep.y;
	dartRot.z=dartRot.z+rotationStep.z;
	

	
	//Check if hit the floor or ceiling
	//floor at -35
	//ceiling at 18
	
	
	//Check collision
	if (dartPos.z>-3){
		//Check if it is within the disk:
		
		
		GLfloat targetDistance=[self distanceBetweenTwoPoints:CGPointMake(dartPos.x, dartPos.y) toPoint:CGPointMake(0.0, 0.0)];
		
		if (targetDistance<4.7){
			
			XYStep.x=0;
			XYStep.y=0;
			xyFixingStep.x=0;
			xyFixingStep.y=0;
			gravityStep=gravityStep/8;
			
			GLfloat distance;
			Vertex3D prevDartPos;
			//Check the collision
			if (currentlyFlyingDartNumber>0){
				for (int i=0;i<currentlyFlyingDartNumber;i++){
					prevDartPos=dart[i].currentPosition;
					distance=[self distanceBetweenTwoPoints:CGPointMake(prevDartPos.x,prevDartPos.y) toPoint:CGPointMake(dartPos.x, dartPos.y)];
					if (distance<0.4){
						//Current Dart has to fall because it is on the other dart
						[self showMessage:@"Collision!"];
						[wallSound[random()%5] play];
						dartPos.z=-3.2;
						rotationStep.x=-(random()%10);
						rotationStep.y=-(random()%5)+2.5;
						rotationStep.z=(random()%5);
						XYStep.x=(random()%20)/10-.5;
						XYStep.y=0.0;
						dartSpeed=-(random()%10)/15-.2;
						gravityStep=0.2;
						if ((rotationStep.y>3 )|(rotationStep.y<-3) )dartSpeed=dartSpeed-.2;
						gluLookAt (cameraPosition.x, cameraPosition.y, cameraPosition.z,
								   targetPosition.x, targetPosition.y,targetPosition.z,
								   0.0, 1.0, 0.0);
						
						//drawing
						dart[currentlyFlyingDartNumber].currentPosition=dartPos;
						dart[currentlyFlyingDartNumber].currentRotation=dartRot;
						//Tracking
						dartTrack[dartTrackCounter]=dartPos;
						dartRotations[dartTrackCounter]=dartRot;
						dartTrackCounter++;
						
						return;	
					}
				}
			}
			
		}
	}
	
	
	

	
	
	if (dartPos.z>0){
		//Check if it is within the disk:
		
				
		GLfloat targetDistance=[self distanceBetweenTwoPoints:CGPointMake(dartPos.x, dartPos.y) toPoint:CGPointMake(0.0, 0.0)];
			
		if (targetDistance<4.7){

			dartSpeed=0;
			rotationStep.x=0;
			rotationStep.y=0;
			rotationStep.z=0;
			XYStep.x=0;
			XYStep.y=0;
			xyFixingStep.x=0;
			xyFixingStep.y=0;
			gravityStep=0;
			dartPos.z=-(random()%30)/100;
						
			[targetSound[random()%5] play];
			//Disk
			
			gluLookAt (cameraPosition.x, cameraPosition.y, cameraPosition.z,
					   targetPosition.x, targetPosition.y,targetPosition.z,
					   0.0, 1.0, 0.0);
			
			//drawing
			dart[currentlyFlyingDartNumber].currentPosition=dartPos;
			dart[currentlyFlyingDartNumber].currentRotation=dartRot;
			//Tracking
			dartTrack[dartTrackCounter]=dartPos;
			dartRotations[dartTrackCounter]=dartRot;
			dartTrackCounter++;
			
			

			
			//End overlay check
			
			
			
			currentlyFlyingDartNumber++;
			if (currentlyFlyingDartNumber == numberOfDarts){
				
				
				score=score+[self triangulateTheScore];
				scoreLabel.text= [NSString stringWithFormat:@"Score: %i",score];
				[self showMessage:[self generateScoreMessage] ];

				
				//drawing
				dart[currentlyFlyingDartNumber].currentPosition=dartPos;
				dart[currentlyFlyingDartNumber].currentRotation=dartRot;
				//Tracking
				dartTrack[dartTrackCounter]=dartPos;
				dartRotations[dartTrackCounter]=dartRot;
				dartTrackCounter++;
				
				[room[currentRoomNumber] drawSelf];
				int tempDartNum=currentlyFlyingDartNumber+1;
				for (int i=0;i<tempDartNum;i++){
					[dart[i] drawSelf];
				}
				
				gameState=5;
				[self setTheGameState:6];
		
				
				
				return;
			}
				 score=score+[self triangulateTheScore];
			    scoreLabel.text= [NSString stringWithFormat:@"Score: %i",score];
				[self showMessage:[self generateScoreMessage] ];

			
			//drawing
			dart[currentlyFlyingDartNumber].currentPosition=dartPos;
			dart[currentlyFlyingDartNumber].currentRotation=dartRot;
			//Tracking
			dartTrack[dartTrackCounter]=dartPos;
			dartRotations[dartTrackCounter]=dartRot;
			dartTrackCounter++;
			
			[room[currentRoomNumber] drawSelf];
			int tempDartNum=currentlyFlyingDartNumber+1;
			for (int i=0;i<tempDartNum;i++){
				[dart[i] drawSelf];
			}
			
			gameState=5;
			[self setTheGameState:6];
						
			return;
			
		}else{
		//hit the wall
			dartPos.z=-0.01;
			rotationStep.x=-(random()%10);
			rotationStep.y=-(random()%20)+10;
			rotationStep.z=(random()%5);
			XYStep.x=(random()%20)/10-.5;
			XYStep.y=0.0;
			dartSpeed=-(random()%20)/25-.5;
			
			if ((rotationStep.y>3 )|(rotationStep.y<-3)) dartSpeed=dartSpeed-.2;
			[wallSound[random()%5] play];
			//May change in the future to the room material property eg brick or wood
			//now wait till it falls on floor
		}
		
		
	}
	
	
	
	gluLookAt (cameraPosition.x, cameraPosition.y, cameraPosition.z,
			   targetPosition.x, targetPosition.y,targetPosition.z,
			   0.0, 1.0, 0.0);
	
	//drawing
	dart[currentlyFlyingDartNumber].currentPosition=dartPos;
	dart[currentlyFlyingDartNumber].currentRotation=dartRot;
	//Tracking
	dartTrack[dartTrackCounter]=dartPos;
	dartRotations[dartTrackCounter]=dartRot;
	dartTrackCounter++;
	
	[room[currentRoomNumber] drawSelf];
	int tempDartNum=currentlyFlyingDartNumber+1;
	for (int i=0;i<tempDartNum;i++){
		[dart[i] drawSelf];
	}
	
	
	
}

-(void)replayAnimation{
	waitingCounter++;
	if (waitingCounter<kWaitingTime) {
		
		gluLookAt (cameraPosition.x, cameraPosition.y, cameraPosition.z,
				   targetPosition.x, targetPosition.y,targetPosition.z,
				   0.0, 1.0, 0.0);
		[room[currentRoomNumber] drawSelf];
		for (int i=0;i<currentlyFlyingDartNumber;i++){
			[dart[i] drawSelf];
		}
		
		return;
	}else{
	////Here starts the replay
		
		//Setup the button
		if (waitingCounter==kWaitingTime) {

			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			[[CATransition animation] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
			doneButton.frame=CGRectMake(55.0f, 422, 211, 50);
			[UIView commitAnimations];
			dartNumberLabel.textColor=[UIColor whiteColor];
			dartNumberLabel.text=@"Replay";
			
			cameraPosition.x=10;
			cameraPosition.y=.5;
			cameraPosition.z=-15;

		}
		waitingCounter=300;//to avoud overflow
		
		//Replay blinking;
		
		replayBeep++;
		
		if (replayBeep>40){
			replayBeep=0;
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.15];
			if (dartNumberLabel.alpha==0.0f){
				dartNumberLabel.alpha=1.0f;
			}else{
				dartNumberLabel.alpha=0.0f;
			}
			[UIView commitAnimations];
		}
		
	//Replay here:
		Vertex3D dartPos;
		Vertex3D dartRot;
		dartTrackCounter++;
		if (dartTrackCounter<dartTrackTotal){
			int tempCounter= dartTrackCounter/kReplaySlowDownFactor-1;
			int diffCounter=dartTrackCounter- dartTrackCounter/kReplaySlowDownFactor*kReplaySlowDownFactor;
			Vertex3D difference;
			Rotation3D rotDifference;
			
			
			
			dartPos= dartTrack[tempCounter];
			dartRot= dartRotations[tempCounter];
			
			
			difference.x=((dartPos.x-dartTrack[tempCounter+1].x)/kReplaySlowDownFactor)*diffCounter;
			difference.y=((dartPos.y-dartTrack[tempCounter+1].y)/kReplaySlowDownFactor)*diffCounter;
			difference.z=((dartPos.z-dartTrack[tempCounter+1].z)/kReplaySlowDownFactor)*diffCounter;
			
			
			//Prevent jumping

			rotDifference.x=((dartRot.x-dartRotations[tempCounter+1].x)/kReplaySlowDownFactor)*diffCounter;
			rotDifference.y=((dartRot.y-dartRotations[tempCounter+1].y)/kReplaySlowDownFactor)*diffCounter;
			rotDifference.z=((dartRot.z-dartRotations[tempCounter+1].z)/kReplaySlowDownFactor)*diffCounter;
			
			
			
			
			if (dartTrackCounter<dartTrackTotal-kReplaySlowDownFactor){
				dartPos.x=dartPos.x-difference.x;
				dartPos.y=dartPos.y-difference.y;
				dartPos.z=dartPos.z-difference.z;
				
				dartRot.x=dartRot.x-rotDifference.x;
				dartRot.y=dartRot.y-rotDifference.y;
				dartRot.z=dartRot.z-rotDifference.z;
			}

		
		
		
				
		}
		else{
			
			if (dartTrackCounter==dartTrackTotal) [self showMessage:lastMessage];
			
			
			
			
			dartPos=dartTrack[dartTrackTotal/kReplaySlowDownFactor-2];
			dartRot=dartRotations[dartTrackTotal/kReplaySlowDownFactor-2];
			
			
			if (( dartTrackCounter>dartTrackTotal+50)&( dartTrackCounter<dartTrackTotal+150)) {
				if (cameraPosition.x>-10) cameraPosition.x-=.2;
				
			}
			
			if (( dartTrackCounter>dartTrackTotal+180)&( dartTrackCounter<dartTrackTotal+300)) {
			if (cameraPosition.x<10) cameraPosition.x+=.2;

			
			}
			
			
			if ( dartTrackCounter==dartTrackTotal+360) {
				
				dartTrackCounter=1   ;
				
			}
			
		}
		
		
		gluLookAt (cameraPosition.x, cameraPosition.y, cameraPosition.z,
				   dartPos.x, dartPos.y, dartPos.z,
				   0.0, 1.0, 0.0);
		
		
		
		dart[currentlyFlyingDartNumber-1].currentPosition=dartPos;
		dart[currentlyFlyingDartNumber-1].currentRotation=dartRot;
		
		[room[currentRoomNumber] drawSelf];
		for (int i=0;i<currentlyFlyingDartNumber;i++){
			[dart[i] drawSelf];
		}
		
		
	
	
	
	
	}
	
}



-(void)highScoresAnimation{
	//Just show the disk
	dartTrackCounter++;
	
	
	if (( dartTrackCounter>180)&( dartTrackCounter<380)) {
		if (cameraPosition.x>-10) cameraPosition.x-=.1;
		
	}
	
	if (( dartTrackCounter>580)&( dartTrackCounter<900)) {
		if (cameraPosition.x<10) cameraPosition.x+=.1;
		
	}
	
	if (dartTrackCounter>900) dartTrackCounter=0;
	
	
	gluLookAt (cameraPosition.x, cameraPosition.y, cameraPosition.z,
			   0.0, 0.0, 0.0,
			   0.0, 1.0, 0.0);
	
	[room[currentRoomNumber] drawSelf];
	for (int i=0;i<currentlyFlyingDartNumber;i++){
		[dart[i] drawSelf];
	}
}


#pragma mark System
- (void)didReceiveMemoryWarning 
{
	NSLog(@"memory");
    [super didReceiveMemoryWarning]; 
}

- (void)dealloc 
{
	[room[numberOfRooms] release];
	[dart[numberOfDarts] release];
	[opaqueView release];
	[playButton release];
	[leftButton release];
	[rightButton release];
	[upButton release];
	[downButton release];
	[doneButton release];
	[helpTextView release];
	[roomLabel release];
	[distanceLabel release];
	[setupButton release];
	[titleImage release];
	[mainWindow release];
	[dartNumberLabel release];
	[scoreLabel release];
	[messageLabel release];
	[lastMessage release];
	[buttonSound release];
	[introMusic release];
	[targetSound[5] release];
	[wallSound[5] release];
	[floorSound[5] release];
	[innerBullSound release];
	[outerBullSound release];
	[scrollSound release];
	[hurryUP release];
	[roomAmbientSound[3] release];
	[presentHelpButton release];

	
    [super dealloc];
}


#pragma mark Custom

-(void)setTheGameState:(int )newGameState {
	//Cleaning up:
#pragma mark Cleanup
	switch (gameState) {
		case 0://Celanup: Main Menu
			//Celanup
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			[[CATransition animation] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
			playButton.frame=CGRectMake(-330.f, 302, 211, 50);
			setupButton.frame=CGRectMake(-330.f, 362, 211, 50);
			presentHelpButton.frame=CGRectMake(-330.f, 422, 211, 50);
			
			[UIView commitAnimations];
			[dartNumberLabel removeFromSuperview];
			[scoreLabel removeFromSuperview];
			
			break;
		case 1://Celanup: Present Help
			//Celanup: 
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			[[CATransition animation] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
			
			helpTextView.frame=CGRectMake(330, 70, 260, 340);
			doneButton.frame=CGRectMake(-320.0f, 422, 211, 50);
			
			[UIView commitAnimations];
			break;
		case 2://Celanup: Main Menu buttons
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			[[CATransition animation] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
			playButton.frame=CGRectMake(-330.f, 302, 211, 50);
			setupButton.frame=CGRectMake(-330.f, 362, 211, 50);
			presentHelpButton.frame=CGRectMake(-330.f, 422, 211, 50);
			
			[UIView commitAnimations];
			
			break;
		case 3://Celanup: Setup
			//Celanup: 
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			
			[[CATransition animation] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
			
			doneButton.frame=CGRectMake(-330.f, 422, 211, 50);
			leftButton.frame=CGRectMake(20, -80, 66, 70);
			rightButton.frame=CGRectMake(240.0f, -80, 66, 70);
			roomLabel.frame= CGRectMake(78, -80, 160, 40);
			
			distanceLabel.frame=CGRectMake(-200, 315, 180, 35);
			upButton.frame=CGRectMake(-150, 280, 70, 40);
			downButton.frame=CGRectMake(-150, 350, 70, 40);
			
			
			[UIView commitAnimations];
			opaqueView.frame=CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
			[self setSettingsToDelegate];
			
			break;
		case 4://Celanup: Target
			//Celanup: 
			
			break;
		case 5://Celanup: Flight
			//Celanup: 
			
			break;
		case 6://Replay
			//Celanup: 
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			[[CATransition animation] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
			doneButton.frame=CGRectMake(-255.0f, 422, 211, 50);
			[UIView commitAnimations];
			dartNumberLabel.alpha=1.0f;
			dartNumberLabel.textColor=[UIColor yellowColor];
			dartNumberLabel.text= [NSString stringWithFormat:@"Dart: %i/%i",currentlyFlyingDartNumber+1,numberOfDarts];
			
			
			
			break;
			
		case 7:
			[dartNumberLabel removeFromSuperview];
			[scoreLabel removeFromSuperview];
			scoreLabel.frame=CGRectMake(210, 10, 150, 20);
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			[[CATransition animation] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
			doneButton.frame=CGRectMake(-255.0f, 422, 211, 50);
			[UIView commitAnimations];
			opaqueView.frame=CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
			[myHighScores.view removeFromSuperview];
			[myHighScores release];
			
			

			break;

	}
	
#pragma mark Setup
	//Switching to a new game state
	switch (newGameState) {
		case 0://Main Menu
			//Setup
			cameraPosition.x=5;
			cameraPosition.y=.5;
			cameraPosition.z=-20;
			currentlyFlyingDartNumber=0;
			mainMenuThrow=YES;
			mainMenuCameraToTheLeft=NO;
			mainMenuCameraToTheRight=NO; 
			mainMenuWatchTheFirstDart=NO;
			mainMenuWatchTheFirstRound=NO;
			if (introMusic.isPlaying==NO) [introMusic play];
			
			[self setMainMenu];
			for(int i=0;i<numberOfDarts;i++){
				dart[i].currentPosition=initialPosition[i];
			}
			
			//Draw Menu:

			
			titleImage.frame=CGRectMake(20.0f, 10.0f, 280.0f, 50.0f);
			
						
						
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			
						
			[[CATransition animation] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
						
			playButton.frame=CGRectMake(55.5f, 302, 211, 50);
			setupButton.frame=CGRectMake(55.5f, 362, 211, 50);
			presentHelpButton.frame=CGRectMake(55.5f, 422, 211, 50);
			
			[UIView commitAnimations];
			


			
			
			break;
		case 1:
			;//Present Help
			//Setup
			
			
			[helpTextView setContentOffset:CGPointMake(0,0)];
			helpTextView.text=[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"help" ofType:@"txt"]];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
				
			[[CATransition animation] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
			//[[opaqueView layer] addAnimation:animation forKey:kAnimationKey];
			
			
			helpTextView.frame=CGRectMake(30, 70, 260, 340);
			doneButton.frame=CGRectMake(55.0f, 422, 211, 50);
			
			[UIView commitAnimations];
			
			
			break;
		case 2://Restore Main Menu Buttons
			//Setup
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			
			
			[[CATransition animation] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
			
			playButton.frame=CGRectMake(55.5f, 302, 211, 50);
			setupButton.frame=CGRectMake(55.5f, 362, 211, 50);
			presentHelpButton.frame=CGRectMake(55.5f, 422, 211, 50);
			
			[UIView commitAnimations];
			break;
		case 3://Setup
			//Setup
			
			cameraPosition.x=0;
			cameraPosition.y=0;
			cameraPosition.z=zDistance;
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			
			[[CATransition animation] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
			
			doneButton.frame=CGRectMake(55.0f, 422, 211, 50);
			
			leftButton.frame=CGRectMake(10, 80, 66, 70);
			rightButton.frame=CGRectMake(240.0f, 80, 66, 70);
			roomLabel.frame= CGRectMake(78, 95, 160, 40);
			distanceLabel.frame=CGRectMake(15, 315, 180, 35);
			upButton.frame=CGRectMake(65, 280, 70, 40);
			downButton.frame=CGRectMake(65, 350, 70, 40);

			[UIView commitAnimations];
		    opaqueView.frame=CGRectMake(-10, -10, 1, 1);
			
			
			
			break;
		case 4://Target
			//Setup
			dartTrackCounter=0;
			dartNumberLabel.textColor=[UIColor yellowColor];
			opaqueView.frame=CGRectMake(1, 1, 318, 40);
			cameraPosition.x=0;
			cameraPosition.y=0;
			cameraPosition.z=zDistance;
			targetPosition.x=0;
			targetPosition.y=0;
			targetPosition.z=0;
			moved=NO;
			initialDartPosition.x=targetPosition.x-2;
			initialDartPosition.y=targetPosition.y-3;
			initialDartPosition.z=zDistance+15;
			dart[currentlyFlyingDartNumber].currentRotation=Rotation3DMake(0.0,0.0,0.0);
			gameState=4;
			[mainWindow addSubview:dartNumberLabel];
			[mainWindow addSubview:scoreLabel];
			[self updateLabels];
			
			if ([roomAmbientSound[currentRoomNumber] isPlaying]==NO) [roomAmbientSound[currentRoomNumber] play];
			
			
			break;
		case 5://Flight
			//Setup
			dartTrackCounter=0;
			rotationStep.x=0;
			rotationStep.y=0;
			rotationStep.z=.4;
			XYStep.x=-targetPosition.x/initialDartPosition.z;
			XYStep.y=targetPosition.y/initialDartPosition.z;
			if (XYStep.y==0)XYStep.y=.01;
			
			xyFixingStep.x=dartSpeed/initialDartPosition.z*2;
			xyFixingStep.y=dartSpeed/initialDartPosition.z*3;
			
			gravityStep=.1;
			

			break;

		case 6://Replay
			dartTrackTotal=dartTrackCounter+1;
			dartTrackTotal=dartTrackTotal*kReplaySlowDownFactor;
			waitingCounter=0;
			break;
			
		case 7://High Scores
			if ([roomAmbientSound[currentRoomNumber] isPlaying]==YES) [roomAmbientSound[currentRoomNumber] stop];
			[introMusic play];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.5];
			[[CATransition animation] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
			doneButton.frame=CGRectMake(55.0f, 422, 211, 50);
			[UIView commitAnimations];
			dartNumberLabel.textColor=[UIColor whiteColor];
			//dartNumberLabel.text= [NSString stringWithFormat:@"Dart: %i/%i",currentlyFlyingDartNumber,numberOfDarts];
			dartNumberLabel.text= @"High Scores:";
			scoreLabel.frame=CGRectMake(180, 10, 150, 20);
			scoreLabel.text= [NSString stringWithFormat:@"Your Score: %i",score];
			
			
			myHighScores = [[HighScores alloc]init];
			myHighScores.view.alpha=.35;
			[mainWindow addSubview:myHighScores.view];
			[myHighScores setNewScore:score withDistance:-zDistance*3];
			
			dartTrackCounter=0;
			cameraPosition.x=10;
			cameraPosition.y=.5;
			cameraPosition.z=-20;
			

			
			
			
			break;
	}
	
	
	gameState=newGameState;
	gameStateChanged=YES;//Need to call inside the animation

}
-(NSString *) roomNames:(int) rmNum{

	switch (rmNum) {
		case 0:
			return @"Pub";
			break;
		case 1:
			return @"Frat House";
			break;
		case 2:
			return @"Rec-room";
			break;
		
	}
	return @"Brick Room";
}

-(void) setMainMenu{
	
	Vertex3D pos,pos1;
	for(int i=0;i<5;i++){
		dart[i].currentRotation=Rotation3DMake (0.0,0.0,0.0);
		pos.x=(random() % 6)-3;
		pos.y=(random() % 6)-3;
		pos.z=-(30.0*(i+1));
		
		if (i>0){
			for(int j=0;j<i;j++){
				pos1=dart[j].currentPosition;
				

					if([self distanceBetweenTwoPoints:CGPointMake(pos.x, pos.y) toPoint:CGPointMake(pos1.x, pos1.y)]<1.0 ){
						j=i;
					i=i-1;
					
					
				}

			}}
		
		initialPosition[i]=pos;
	
	}

}




#pragma mark Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (gameState==4){
		CGPoint pt = [[touches anyObject] locationInView:self.view];
		startLocation = pt;
		lastTime=[NSDate timeIntervalSinceReferenceDate];
	
	}
}

- (void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (gameState==4){
		moved=YES;
		
	}
}



- (void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
	if (gameState==4){
		if(moved==YES){
			moved=NO;
			GLfloat throwingDistance;
		CGPoint pt = [[touches anyObject] locationInView:self.view];
			NSTimeInterval timeSinceLast = [NSDate timeIntervalSinceReferenceDate] - lastTime;//in seconds
			throwingDistance = [self distanceBetweenTwoPoints:startLocation toPoint:pt];
			dartSpeed=throwingDistance/timeSinceLast/kSpeedFactor;
			dartSpeedSlow=dartSpeed/2;
			//Set game state to flying
			[self setTheGameState:5];
		}
	}

}


#pragma mark Buttons:

-(void)playGameButtonPressed:(id)sender{
	[buttonSound play];
	[introMusic stop];
	if ([roomAmbientSound[currentRoomNumber] isPlaying]==NO) [roomAmbientSound[currentRoomNumber] play];
	currentlyFlyingDartNumber=0;
	score=0;
	titleImage.frame=CGRectMake(20.0f, -60.0f, 280.0f, 50.0f);
	[self setTheGameState:4];

}
-(void)setupButtonPressed:(id)sender{
	[buttonSound play];
		[self setTheGameState:3];
	
}
-(void)presentHelpButtonPressed:(id)sender{
	[buttonSound play];

	[self setTheGameState:1];
	
}

-(void)doneButtonPressed:(id)sender{
	[buttonSound play];
	if (gameState==6){
		dart[currentlyFlyingDartNumber-1].currentPosition=dartTrack[dartTrackTotal/kReplaySlowDownFactor-2];
		dart[currentlyFlyingDartNumber-1].currentRotation=dartRotations[dartTrackTotal/kReplaySlowDownFactor-2];
		
		if (currentlyFlyingDartNumber == numberOfDarts){
			gameState=6;
			[self setTheGameState:7];
			
			
			return;
		}
		
		
		
		
		[self setTheGameState:4];
		return;
	}
	
	if (gameState==1){
		
		[self setTheGameState:2]; 
	}
	else{
		[self setTheGameState:0];
	}
	
}
-(void)leftButtonPressed:(id)sender{

	currentRoomNumber=currentRoomNumber-1;
	if (currentRoomNumber<0) currentRoomNumber=numberOfRooms-1;
	roomLabel.text= [self roomNames:currentRoomNumber];
}


-(void)rightButtonPressed:(id)sender{
	currentRoomNumber++;
	if (currentRoomNumber==numberOfRooms) currentRoomNumber=0;
	roomLabel.text= [self roomNames:currentRoomNumber];
}

-(void)upButtonPressed:(id)sender{
	if (downButtonActive==NO) upButtonActive=YES;

}
-(void)downButtonPressed:(id)sender{
	if (upButtonActive==NO) downButtonActive=YES;
}
-(void)buttonCancel:(id)sender{
	int labelDistance;
	labelDistance=-zDistance*3;
	distanceLabel.text= [NSString stringWithFormat:@"Distance: %i inches",labelDistance];

	downButtonActive=NO;
	upButtonActive=NO;
}

#pragma mark Settings
-(void)getSettingsFromDelegate{
	//NSLog(@"Settings");
	//Retrieving Settings
	currentRoomNumber=[[NSString stringWithFormat:@"%@", [[[UIApplication sharedApplication] delegate] getMyettingsforElementNumber:0]]intValue];
	zDistance=[[NSString stringWithFormat:@"%@", [[[UIApplication sharedApplication] delegate] getMyettingsforElementNumber:1]] floatValue];
}

-(void)setSettingsToDelegate{

	
	[[[UIApplication sharedApplication] delegate] setMyettings:[NSString stringWithFormat:@"%i",currentRoomNumber]  forElementNumber:0 ];
	[[[UIApplication sharedApplication] delegate] setMyettings:[NSString stringWithFormat:@"%f",zDistance]  forElementNumber:1 ];
	
	[[[UIApplication sharedApplication] delegate] saveSettingsToFile];
}
#pragma mark TextView:

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[scrollSound play];
}

#pragma mark Accelerometer:
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	if (gameState==4){
	
	// extract the acceleration components
	float xx = -[acceleration x];
	float yy = [acceleration y]+.5;
	
	// Has the direction changed?
	float accelDirX = SIGN(xvelocity) * -1.0f; 
	float newDirX = SIGN(xx);
	float accelDirY = SIGN(yvelocity) * -1.0f;
	float newDirY = SIGN(yy);
	
	// Accelerate. To increase viscosity lower the values below 1.0f
	if (accelDirX == newDirX) 
		xaccel = (abs(xaccel) + 0.85f) * SIGN(xaccel);
	if (accelDirY == newDirY) 
		yaccel = (abs(yaccel) + 0.85f) * SIGN(yaccel);
		
		
	
	// Apply acceleration changes to the current velocity
		xvelocity = -xaccel * xx*2;
	yvelocity = -yaccel * yy *2;
		
		//FIXME: accelerometer failure
		//NSLog(@"!");
		//if ((xaccel==0) | (yaccel==0)) NSLog(@"xaccel=0;");
		//if ((xvelocity==0) | (yvelocity==0)) NSLog(@"xvelocity=0;");
		
	}
	
}
#pragma mark Functions
-(NSString *) generateScoreMessage{

	Vertex3D pos = dart[currentlyFlyingDartNumber-1].currentPosition;
	
	
	//First check the bull's eye and return; in order to avoid divide by zero
	
	
	
	GLfloat angle,distance;
	int result;
	NSString *returnString;
	
	distance=[self distanceBetweenTwoPoints:CGPointMake(0.0f, 0.0f) toPoint:CGPointMake(pos.x, pos.y)];
	if (distance<0.26){
		//double bulls eye!
		[innerBullSound play];
		returnString=@"Inner Bull!!! 50";
		return returnString;
		
	}
	
	if (distance<0.41){
		//bulls eye!
		[outerBullSound play];
		returnString=@"Outer Bull! 25";
		return returnString;
		
	}
	
	
	
	
	angle= M_PI/2 - atan(pos.x/pos.y)- atan(0.0/-4.5);
	angle=angle * 180 / M_PI;//Convert to degrees
	
	if (pos.y<=0){
	}else{
		angle=angle+180;
	}
	
	if ((angle>=351) & (angle<=369)) result=6;
	if ((angle>=0) & (angle<=9)) result=6;
	
	if ((angle>=9) & (angle<=27)) result=10;
	
	if ((angle>=27) & (angle<=45)) result=15;
	if ((angle>=45) & (angle<=63)) result=2;
	if ((angle>=63) & (angle<=81)) result=17;
	
	if ((angle>=81) & (angle<=99)) result=3;
	
	if((angle>=99) & (angle<=117)) result=19;
	
	if ((angle>=117) & (angle<=135)) result=7;
	
	if ((angle>=135) & (angle<=153)) result=16;
	
	if ((angle>=153) & (angle<=171)) result=8;
	
	if ((angle>=171) & (angle<=189)) result=11;
	
	if ((angle>=189) & (angle<=207)) result=14;
	
	if ((angle>=207) & (angle<=225)) result=9;
	
	if ((angle>=225) & (angle<=243)) result=12;
	
	if ((angle>=243) & (angle<=261)) result=5;
	
	if ((angle>=261) & (angle<=279)) result=20;
	
	if ((angle>=279) & (angle<=297)) result=1;
	
	if ((angle>=297) & (angle<=315)) result=18;
	
	if ((angle>=315) & (angle<=333)) result=4;
	
	if ((angle>=333) & (angle<=351)) result=13;
	
	
	
	if (distance<2.47){
		//inner circle!
		returnString=[NSString stringWithFormat:@"%i Double", result];
		
		
	}else{
		returnString=[NSString stringWithFormat:@"%i", result];
	
	}
	
	
	
	return returnString;
	
	
	
}
-(int) triangulateTheScore{
	Vertex3D pos = dart[currentlyFlyingDartNumber-1].currentPosition;
	
	
	//First check the bull's eye and return; in order to avoid divide by zero
	
	
	
	GLfloat angle,distance;
	int result;
	
	distance=[self distanceBetweenTwoPoints:CGPointMake(0.0f, 0.0f) toPoint:CGPointMake(pos.x, pos.y)];
	if (distance<0.26){
	//double bulls eye!
		
		result=50;
		return result;
	
	}
	
	if (distance<0.41){
		//bulls eye!
		
		result=25;
		return result;
		
	}
	
	
	
	
	angle= M_PI/2 - atan(pos.x/pos.y)- atan(0.0/-4.5);
	angle=angle * 180 / M_PI;//Convert to degrees

	if (pos.y<=0){
		}else{
		angle=angle+180;
	}
	
	if ((angle>=351) & (angle<=369)) result=6;
	if ((angle>=0) & (angle<=9)) result=6;
	
	if ((angle>=9) & (angle<=27)) result=10;
	
	if ((angle>=27) & (angle<=45)) result=15;
	if ((angle>=45) & (angle<=63)) result=2;
	if ((angle>=63) & (angle<=81)) result=17;
	
	if ((angle>=81) & (angle<=99)) result=3;
	
	if((angle>=99) & (angle<=117)) result=19;
	
	if ((angle>=117) & (angle<=135)) result=7;
	
	if ((angle>=135) & (angle<=153)) result=16;
	
	if ((angle>=153) & (angle<=171)) result=8;
	
	if ((angle>=171) & (angle<=189)) result=11;
	
	if ((angle>=189) & (angle<=207)) result=14;
	
	if ((angle>=207) & (angle<=225)) result=9;
	
	if ((angle>=225) & (angle<=243)) result=12;
	
	if ((angle>=243) & (angle<=261)) result=5;
	
	if ((angle>=261) & (angle<=279)) result=20;
	
	if ((angle>=279) & (angle<=297)) result=1;
	
	if ((angle>=297) & (angle<=315)) result=18;
	
	if ((angle>=315) & (angle<=333)) result=4;
	
	if ((angle>=333) & (angle<=351)) result=13;

	
	
	if (distance<2.47){
		//inner circle!
		
		result=result*2;
		
	}
	
	
	
	return result;
	
	
	
}
-(NSString *)messageGenerator:(bool) positiveFactor{

	NSString *message;
	int randomNumber;
	if (positiveFactor==YES){
		randomNumber=(random()%3);
	//Generate Positive Message!
		switch (randomNumber) {
			case 0:
				message=@"Awesome";
				break;
			case 1:
				message=@"Nice";
				break;
			case 2:
				message=@"Great!";
				break;
			
		}
		
	}
	
	else{
	//Generate Negative Message
		randomNumber=(random()%6);
		switch (randomNumber) {
			case 0:
				message=@"Boo!";
				break;
			case 1:
				message=@"You're bad!";
				break;
			case 2:
				message=@"Missed!";
				break;
			case 3:
				message=@"Nooo!";
				break;
			case 4:
				message=@"Didn't make it!";
				break;
			case 5:
				message=@"Hit the floor!";
				break;
				
		}
	
	}
	return message;
}

- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint {
	
	float x = toPoint.x - fromPoint.x;
	float y = toPoint.y - fromPoint.y;
	
	return sqrt(x * x + y * y);
}

-(void)showMessage:(NSString *)message{


	
	//[self updateLabels];
	
	
	messageLabel.frame=CGRectMake(00, 150, 320, 100);
	messageLabel.alpha=1.0f;
	messageLabel.text=message;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	
	
	[[CATransition animation] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
	//Animation
	
	messageLabel.frame=CGRectMake(00, 0.0f, 320, 100);
	messageLabel.alpha=0.0f;
	
	[UIView commitAnimations];
	
	lastMessage=[message copy];
	
	
	NSLog(@"Screen Message: %@",message);
	
	


}

-(void)updateLabels{
	dartNumberLabel.text= [NSString stringWithFormat:@"Dart: %i/%i",currentlyFlyingDartNumber+1,numberOfDarts];
	scoreLabel.text= [NSString stringWithFormat:@"Score: %i",score];
}
#pragma mark Physics

-(Rotation3D )checkRotations:(Rotation3D ) therotation{
	
	if (therotation.x>360)therotation.x=therotation.x-360;
	if (therotation.x<0)therotation.x=therotation.x+360;
	
	if (therotation.y>360)therotation.y=therotation.y-360;
	if (therotation.y<0)therotation.y=therotation.y+360;
	
	if (therotation.z>360)therotation.z=therotation.z-360;
	if (therotation.z<0)therotation.z=therotation.z+360;
	
	return therotation;
}

@end
