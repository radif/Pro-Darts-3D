//
//  Wavefront_OBJ_LoaderAppDelegate.h
//  Wavefront OBJ Loader
//
//  Created by Jeff LaMarche on 12/14/08.
//  Copyright Jeff LaMarche 2008. All rights reserved.
//
#import "SplashView.h"

@class GLViewController;

@interface Wavefront_OBJ_LoaderAppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow				*window;
	GLViewController		*controller;
	SplashView  *m_splashScreen;
	//Settings
	NSMutableArray *settingsArray;
	

	
	
}

-(void)setMyettings:(NSString *) mySettings forElementNumber:(int) indexObject;
-(NSString *)getMyettings:(id *) mySettings forElementNumber:(int) indexObject;
-(void)getSettingsFromFile;
-(void)saveSettingsToFile;


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GLViewController *controller;
@end
