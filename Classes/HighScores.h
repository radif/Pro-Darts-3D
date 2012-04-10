//
//  HighScores.h
//  Darts3D
//
//  Created by Radif Sharafullin on 5/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundEffect.h"



@interface HighScores : UIViewController  <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> {
	int score;
	int distance;
	UITableView *scoresTable;
	SoundEffect *scrollSound;
	NSMutableArray *scores;
	NSString *nameFromFile;
	

	
}

-(void) setNewScore:(int)theNewScore withDistance:(int)theNewDistance;
-(void) refreshTheList;
-(void)getSettings;
-(void)saveSettings;

@end
