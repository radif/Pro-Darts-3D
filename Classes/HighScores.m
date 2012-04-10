//
//  HighScores.m
//  Darts3D
//
//  Created by Radif Sharafullin on 5/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HighScores.h"
@interface UIAlertView (extended)
- (UITextField *) textFieldAtIndex: (int) index;
- (void) addTextFieldWithValue: (NSString *) value label: (NSString *) label;
@end

@implementation HighScores

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	scrollSound=[[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"scroll" ofType:@"wav"]];
	scoresTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, 260, 335) style:UITableViewStylePlain];
	scoresTable.backgroundColor=[UIColor clearColor];
	scoresTable.delegate = self;
	scoresTable.dataSource = self;
	scoresTable.rowHeight=30;
	scoresTable.bounces=NO;
	scoresTable.scrollEnabled=YES;
	scoresTable.indicatorStyle=UIScrollViewIndicatorStyleBlack;
	self.view.frame=CGRectMake(30, 60, 260, 355);
	self.view.backgroundColor=[UIColor clearColor];
	//[self.view addSubview:scoresTable];
	
	
	
	UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 19, 19)];
	numberLabel.backgroundColor=[UIColor blueColor];
	numberLabel.textColor=[UIColor whiteColor];
	numberLabel.textAlignment=UITextAlignmentCenter;
	numberLabel.font=[UIFont fontWithName:@"Arial" size:14];
	numberLabel.text=@"";
	[self.view addSubview:numberLabel];
	[numberLabel release];
	
	
	UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 19)];
	nameLabel.backgroundColor=[UIColor blueColor];
	nameLabel.textColor=[UIColor whiteColor];
	nameLabel.font=[UIFont fontWithName:@"Arial" size:14];
	nameLabel.text=@" Player";
	[self.view addSubview:nameLabel];
	[nameLabel release];
	
	UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(171, 0, 45, 19)];
	scoreLabel.backgroundColor=[UIColor blueColor];
	scoreLabel.textColor=[UIColor whiteColor];
	scoreLabel.font=[UIFont fontWithName:@"Arial" size:14];
	scoreLabel.textAlignment=UITextAlignmentCenter;
	scoreLabel.text=@"Pts";
	[self.view addSubview:scoreLabel];
	[scoreLabel release];
	
	UILabel *distanceLabel= [[UILabel alloc]initWithFrame:CGRectMake(217, 0, 43, 19)];
	distanceLabel.backgroundColor=[UIColor blueColor];
	distanceLabel.textColor=[UIColor whiteColor];
	distanceLabel.font=[UIFont fontWithName:@"Arial" size:14];
	distanceLabel.textAlignment=UITextAlignmentCenter;
	distanceLabel.text=@"Dist";
	[self.view addSubview:distanceLabel];
	[distanceLabel release];
	
	
	
	
	
	
	
	[self getSettings];
	[self refreshTheList];
	[self refreshTheList];
	[self refreshTheList];
	

	
	
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[scoresTable release];
	[scrollSound release];
	[scores release];
    [nameFromFile release];
	[super dealloc];
	
}
#pragma mark Custom
-(void) setNewScore:(int)theNewScore withDistance:(int)theNewDistance{
	score = theNewScore;
	distance= theNewDistance;
	//Get the name
	
	UIAlertView *alert = [[UIAlertView alloc] 
						  initWithTitle: @"Score Board" 
						  message:[NSString stringWithFormat:@"You've got %i points\nPlease, enter your name:",score]
						  delegate:self
						  cancelButtonTitle:@"Esc"
						  otherButtonTitles:@"Enter", nil];
	[alert addTextFieldWithValue:nameFromFile label:@"Enter Name"];
	
	// Name field
	UITextField *tf = [alert textFieldAtIndex:0];
	tf.clearButtonMode = UITextFieldViewModeWhileEditing;
	tf.keyboardType = UIKeyboardTypeAlphabet;
	tf.keyboardAppearance = UIKeyboardAppearanceAlert;
	tf.autocapitalizationType = UITextAutocapitalizationTypeWords;
	tf.autocorrectionType = UITextAutocorrectionTypeNo;
	
	
	// URL field
	
	[alert show];
	
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex==1){
		nameFromFile=[[[alertView textFieldAtIndex:0] text]copy];
		if (([[[alertView textFieldAtIndex:0] text] isEqual:@""]) | ([[alertView textFieldAtIndex:0] text]==nil)){
			[scores addObject:[NSString stringWithFormat:@"%i|%i|Anonymous",score,distance]];
		}else{
			[scores addObject:[NSString stringWithFormat:@"%i|%i|%@",score,distance,[[alertView textFieldAtIndex:0] text]]];
		}
		
		[self refreshTheList];
		[self saveSettings];
	}else{
		
	}
	[NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(refreshTableOff) userInfo:nil repeats:NO];
	[alertView release];
}

-(void)refreshTableOff{
	[scoresTable removeFromSuperview];
  		[NSTimer scheduledTimerWithTimeInterval:.05f target:self selector:@selector(refreshTableOn) userInfo:nil repeats:NO];

}

-(void)refreshTableOn{
	[self.view addSubview:scoresTable];
	
}



-(void) refreshTheList{
	//Sorting:
	int tempInt0, tempInt1;
	
	NSArray *tempValues;
	
	
	
	if([scores count]>1){
		//Sort Distance (max in the beginning)
		for(int i=0;i<[scores count]-1;i++){
			
			tempValues=[[scores objectAtIndex:i] componentsSeparatedByString:@"|"];
			if ([tempValues count]>0){
				tempInt0=[[tempValues objectAtIndex:1]intValue];
			}
			tempValues=nil;
			
			for (int j=i+1;j<[scores count];j++){
				
				tempValues=[[scores objectAtIndex:j] componentsSeparatedByString:@"|"];
				if ([tempValues count]>0){
					tempInt1=[[tempValues objectAtIndex:1]intValue];
				}
				
				
				if (tempInt1>tempInt0){
					//swapping:
					
					[scores exchangeObjectAtIndex:i withObjectAtIndex:j];
				}
				
				tempValues=nil;
			}
			
			
		}
		
		
		//Sort Scores
		
		
		int temp0, temp1;
		int prevII=0;
		
		tempValues=[[scores objectAtIndex:0] componentsSeparatedByString:@"|"];
		if ([tempValues count]>0){
			temp0=[[tempValues objectAtIndex:1]intValue];
		}
		tempValues=nil;
		
		for (int ii=1;ii<[scores count];ii++){
			tempValues=[[scores objectAtIndex:ii] componentsSeparatedByString:@"|"];
			if ([tempValues count]>0){
				temp1=[[tempValues objectAtIndex:1]intValue];
			}
			tempValues=nil;
			if (temp0!=temp1) {
				
				//NSLog(@"Sort: %i - %i",(prevII)+1,(ii-1)+1);
				//Sort Here: (prevII),(ii-1)
				
				if ((ii-1) - prevII>0){
					
					for(int i=prevII;i<=(ii-1)-1;i++){
						
						tempValues=[[scores objectAtIndex:i] componentsSeparatedByString:@"|"];
						if ([tempValues count]>0){
							tempInt0=[[tempValues objectAtIndex:0]intValue];
						}
						tempValues=nil;
						
						for (int j=i+1;j<=(ii-1);j++){
							
							tempValues=[[scores objectAtIndex:j] componentsSeparatedByString:@"|"];
							if ([tempValues count]>0){
								tempInt1=[[tempValues objectAtIndex:0]intValue];
							}
							tempValues=nil;
							
							if (tempInt1>tempInt0){
								//swapping:
								//NSLog(@"		SWAP: %i with %i",(i)+1,(j)+1);
								[scores exchangeObjectAtIndex:i withObjectAtIndex:j];
							}
							
							
						}
						
						
					}
				
				}
				
				
				
				tempValues=[[scores objectAtIndex:ii] componentsSeparatedByString:@"|"];
				if ([tempValues count]>0){
					temp0=[[tempValues objectAtIndex:1]intValue];
				}
				tempValues=nil;
				prevII=ii;
			
			}
			
			
			
			
			if (ii==[scores count]-1) {
				
				//NSLog(@"Sort: %i - %i",(prevII)+1,(ii)+1);
				//Sort Here:(prevII),(ii)
				
				if ((ii) - prevII>0){
					
					for(int i=prevII;i<=(ii)-1;i++){
						
						tempValues=[[scores objectAtIndex:i] componentsSeparatedByString:@"|"];
						if ([tempValues count]>0){
							tempInt0=[[tempValues objectAtIndex:0]intValue];
						}
						tempValues=nil;
						
						for (int j=i+1;j<=(ii);j++){
							
							tempValues=[[scores objectAtIndex:j] componentsSeparatedByString:@"|"];
							if ([tempValues count]>0){
								tempInt1=[[tempValues objectAtIndex:0]intValue];
							}
							tempValues=nil;
							
							if (tempInt1>tempInt0){
								//swapping:
								//NSLog(@"		SWAP: %i with %i",(i)+1,(j)+1);
								[scores exchangeObjectAtIndex:i withObjectAtIndex:j];
							}
							
							
						}
						
						
					}
					
				}
				
				
				
				
				
				
				
				tempValues=[[scores objectAtIndex:ii] componentsSeparatedByString:@"|"];
				if ([tempValues count]>0){
					temp0=[[tempValues objectAtIndex:1]intValue];
				}
				tempValues=nil;
				prevII=ii;
				
			}
			
			
			
			
		}
			

		
	}
	
	//Removing Names
	
	NSString *prevName;
	
	if([scores count]>1){
		//Sort Distance (max in the beginning)
		for(int i=0;i<[scores count]-1;i++){
			
			tempValues=[[scores objectAtIndex:i] componentsSeparatedByString:@"|"];
			if ([tempValues count]>0){
				prevName=[[tempValues objectAtIndex:2]copy];
				tempInt0=[[tempValues objectAtIndex:0]intValue];
				tempInt1=[[tempValues objectAtIndex:1]intValue];
			}
			tempValues=nil;
			
			for (int j=i+1;j<[scores count];j++){
				
				tempValues=[[scores objectAtIndex:j] componentsSeparatedByString:@"|"];
				if ([tempValues count]>0){
					
					if (([prevName  isEqual:[tempValues objectAtIndex:2]]) &(tempInt1==[[tempValues objectAtIndex:1]intValue]) &(tempInt0>= [[tempValues objectAtIndex:0]intValue]  )){
					
						//NSLog(@"repeat: %@", prevName);
						[scores removeObjectAtIndex:j];
					}
					tempValues=nil;
				
				
				}
				
				

				}
				
				
			}
			[prevName release];
		}
	
		
	
	
	

	

}

#pragma mark TableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [scores count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
  //  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  //  if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
   // }
    
    // Set up the cell...
	
	
	
	NSString *tempName;
	int tempScore;
	int tempDistance;
	NSArray *tempValues;
	
	if ([scores count]>0)tempValues=[[scores objectAtIndex:indexPath.row] componentsSeparatedByString:@"|"];
	
	if ([tempValues count]>0){
		tempName=[tempValues objectAtIndex:2];
		tempScore=[[tempValues objectAtIndex:0]intValue];
		tempDistance=[[tempValues objectAtIndex:1]intValue];
	}
	
	cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.backgroundColor=[UIColor whiteColor];
	
	UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, 19, 29)];
	numberLabel.backgroundColor=[UIColor blueColor];
	numberLabel.textColor=[UIColor whiteColor];
	numberLabel.textAlignment=UITextAlignmentCenter;
	numberLabel.font=[UIFont fontWithName:@"Arial" size:12];
	numberLabel.text=[NSString stringWithFormat:@"%i",indexPath.row+1];
	[cell addSubview:numberLabel];
	[numberLabel release];
	
	
	UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 1, 150, 29)];
	nameLabel.backgroundColor=[UIColor blueColor];
	nameLabel.textColor=[UIColor whiteColor];
	nameLabel.font=[UIFont fontWithName:@"Arial" size:16];
	nameLabel.text=[NSString stringWithFormat:@" %@",tempName];
	[cell addSubview:nameLabel];
	[nameLabel release];
	
	UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(171, 1, 45, 29)];
	scoreLabel.backgroundColor=[UIColor blueColor];
	scoreLabel.textColor=[UIColor whiteColor];
	scoreLabel.font=[UIFont fontWithName:@"Arial" size:16];
	scoreLabel.textAlignment=UITextAlignmentCenter;
	scoreLabel.text=[NSString stringWithFormat:@"%i",tempScore];
	[cell addSubview:scoreLabel];
	[scoreLabel release];
	
	UILabel *distanceLabel= [[UILabel alloc]initWithFrame:CGRectMake(217, 1, 45, 29)];
	distanceLabel.backgroundColor=[UIColor blueColor];
	distanceLabel.textColor=[UIColor whiteColor];
	distanceLabel.font=[UIFont fontWithName:@"Arial" size:16];
	distanceLabel.textAlignment=UITextAlignmentCenter;
	distanceLabel.text=[NSString stringWithFormat:@"%i",tempDistance];
	[cell addSubview:distanceLabel];
	[distanceLabel release];
	
	
	tempValues =nil;
	tempName=nil;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[scrollSound play];
}

/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 return @"High Scores";
 }
 */
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 - (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 
 if ([[chapterArray objectAtIndex:bookNumber-1]intValue ]==1){
 return @"One Chapter:";
 }else{
 
 return [NSString stringWithFormat: @"%i Chapters:",[[chapterArray objectAtIndex:bookNumber-1]intValue ]];
 }
 }
 */

#pragma mark Files:
-(void)getSettings{
	
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 ); 
	
	
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat: @"%@/Scores.plist",[filePaths objectAtIndex: 0]]]) {
		scores=[[NSMutableArray alloc] initWithContentsOfFile:[NSString stringWithFormat: @"%@/Scores.plist",[filePaths objectAtIndex: 0]]];
		
	}else{
		scores=[[NSMutableArray alloc]initWithObjects:nil];
	}
	
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat: @"%@/Name.txt",[filePaths objectAtIndex: 0]]]) {
		
		NSArray *namesArray=[[NSArray alloc] initWithContentsOfFile: [NSString stringWithFormat: @"%@/Name.txt",[filePaths objectAtIndex: 0]]];
		
		nameFromFile=[[namesArray objectAtIndex:0]copy];
		[namesArray release];
		
	}else{
		nameFromFile=[@"" copy];
	}
	
}

-(void)saveSettings{
	
	NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																 
																 NSDocumentDirectory, 
																 NSUserDomainMask,
																 YES
																 );
	
	
	
	[scores writeToFile:[NSString stringWithFormat: @"%@/Scores.plist",[filePaths objectAtIndex: 0]] atomically:YES];
	NSArray *namesArray=[[NSArray alloc] initWithObjects:nameFromFile,nil];
						 
	[namesArray writeToFile:[NSString stringWithFormat: @"%@/Name.txt",[filePaths objectAtIndex: 0]] atomically:YES];				
	[namesArray release];

}

@end
