//
//  SplashView.m
//  KJVBible
//
//  Created by Radif Sharafullin on 3/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SplashView.h"


@implementation SplashView

- (id)initWithFrame:(CGRect)frame 
{
	if (self = [super initWithFrame:frame]) 
	{
		UIImage *titleScreen = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"loading.png"]];
		self.image = titleScreen;
		[titleScreen release];
	}
	return self;
}


- (void)dealloc 
{
	[super dealloc];
}




@end

