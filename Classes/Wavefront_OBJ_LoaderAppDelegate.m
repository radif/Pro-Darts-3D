//
//  Wavefront_OBJ_LoaderAppDelegate.m
//  Wavefront OBJ Loader
//
//  Created by Jeff LaMarche on 12/14/08.
//  Copyright Jeff LaMarche 2008. All rights reserved.
//

#import "Wavefront_OBJ_LoaderAppDelegate.h"
#import "GLViewController.h"
#import "GLView.h"



@implementation Wavefront_OBJ_LoaderAppDelegate
@synthesize window;
@synthesize controller;

- (void)applicationDidFinishLaunching:(UIApplication*)application
{
	
	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	[self getSettingsFromFile];
	
	CGRect	rect = [[UIScreen mainScreen] bounds];
	
	//window = [[UIWindow alloc] initWithFrame:rect];
	m_splashScreen = [[SplashView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[window addSubview:m_splashScreen];
	//Add Loading Pic;
	
	
	[window makeKeyAndVisible];
	
	
	 [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(onSplashExpired:) userInfo:nil repeats:NO];
	

	
	
	
//	NSString *extensionString = [NSString stringWithUTF8String:(char *)glGetString(GL_EXTENSIONS)];
//	NSArray *extensions = [extensionString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//	for (NSString *oneExtension in extensions)
//		NSLog(oneExtension);

}

- (void)onSplashExpired:(id)userData
{
	CGRect	rect = [[UIScreen mainScreen] bounds];
	GLViewController *theController = [[GLViewController alloc] init];
	self.controller = theController;
	[theController release];
	
	GLView *glView = [[GLView alloc] initWithFrame:rect];
	
	
	
	
	glView.controller = controller;
	glView.animationInterval = 1.0 / kRenderingFrequency;
	
	[glView startAnimation];
	//[glView release];
	[m_splashScreen removeFromSuperview];
	[window addSubview:glView];
}

- (void)dealloc
{
	[window release];
	[m_splashScreen release];
	
	[controller release];
	[super dealloc];
}
#pragma mark Settings

-(void)getSettingsFromFile{//This mehod can only be used once througout the life of the program!!!
	
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	
	
	
	NSString *newPath =[NSString stringWithFormat: @"%@/Settings.plist",[filePaths objectAtIndex: 0]];
	if ([[NSFileManager defaultManager] fileExistsAtPath:newPath]) {
		settingsArray=[[NSMutableArray alloc] initWithContentsOfFile:newPath];
		
	}else{
		
		settingsArray=[[NSMutableArray alloc]initWithObjects:@"2",@"-60.000000",nil];
		//Numbers; Sexy (only 2); Letters (up to 7); Words (up to 7)
	}
	
}
-(void)saveSettingsToFile{
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	
	
	
	NSString *newPath =[NSString stringWithFormat: @"%@/Settings.plist",[filePaths objectAtIndex: 0]];
	[settingsArray writeToFile:newPath atomically:YES];
}


-(void)setMyettings:(NSString *) mySettings forElementNumber:(int) indexObject{
	[settingsArray replaceObjectAtIndex:indexObject withObject:mySettings];
	
}
-(NSString *)getMyettingsforElementNumber:(int) indexObject{
	return [settingsArray objectAtIndex:indexObject];
}

#pragma mark Buttons;


		 
	


@end
