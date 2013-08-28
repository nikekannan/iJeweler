    //
//  AnswersVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/29/11.
//  Copyright 2011 no. All rights reserved.
//

#import "AnswersVC.h"
#import "DetailedAnswersVC.h"
#import "Constants.h"

#define CELL_HEIGHT 70.0
@implementation AnswersVC

@synthesize infoDict;
@synthesize delegate;
@synthesize isBannerAnimating;

- (void)dealloc {
	if(answersArray !=nil)
	{
		[answersArray release];
	}
	[infoDict release];
	[obj_DetailedAnswersVC release];
    [banner release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    isBannerAnimating = YES;
    loadFirstBanner = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
    [self performSelector:@selector(animateBanner) withObject:nil afterDelay:ANIMATE_BANNER_AFTER_DELAY];

	[[NSUserDefaults standardUserDefaults] setInteger:22 forKey:@"page"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self getAnswers];	
}

- (void) viewWillDisappear:(BOOL)animated  
{
    isBannerAnimating = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    //banner
    loadFirstBanner = YES;
    isInfoVisible = NO;

	[self.navigationItem setTitle:@"Answers"];
	obj_DetailedAnswersVC = [[DetailedAnswersVC alloc] init];
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
	[self.navigationItem setBackBarButtonItem:back];
	[back release];	
	
    MyJewelerAppDelegate *appDelegate = (MyJewelerAppDelegate*)[[UIApplication sharedApplication] delegate];
    Banner *o = [appDelegate getAd];
    banner = [[BannerView alloc] init];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [banner setFrame:CGRectMake(0,448,320,60)];
    }
    else
    {
        [banner setFrame:CGRectMake(0,360,320,60)];
    }
    [banner setTag:[[o bannerID] intValue]];
    [banner setImage:[o bannerImage]];
    [banner setUid:[o bannerID]];
    [banner setWeblink:[o bannerURL]];
    [self.view addSubview:banner];
    
    [self performSelector:@selector(animateBanner) withObject:nil afterDelay:ANIMATE_BANNER_AFTER_DELAY];

	[self loadTable];
    [self prepareInfoView];

    [super viewDidLoad];
}

- (void) loadTable
{
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,350) style:UITableViewStylePlain];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [myTable setFrame:CGRectMake(0,0,320,448)];
    }
	[myTable setDelegate:self];
	[myTable setDataSource:self];
	[myTable setBackgroundColor:[UIColor clearColor]];
	[myTable setSeparatorColor:[UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0]];
	[self.view addSubview:myTable];
	[myTable release];	
}
#pragma mark -

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	//DetailedAnswersVC *o = [[DetailedAnswersVC alloc] init];
    [obj_DetailedAnswersVC setTitle:[[answersArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
	[obj_DetailedAnswersVC setInfoDict:[answersArray objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:obj_DetailedAnswersVC animated:YES];
	//[o	release];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [answersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"cellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil)
	{
		cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		UIView *v = [[UIView alloc] init];		
		
        v.backgroundColor = [UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0];		
        cell.selectedBackgroundView = v;
		[v release];
				
		// for  Answers
		UILabel *answerLabel = [[UILabel alloc] init];		
		[answerLabel setTag:101];
		[answerLabel setFrame:CGRectMake(30,5,270,50)];
		[answerLabel setNumberOfLines:4];
		[answerLabel setFont:[UIFont systemFontOfSize:14]];
		[answerLabel setTextColor:[UIColor whiteColor]];
		[answerLabel setBackgroundColor:[UIColor clearColor]];
		[cell addSubview:answerLabel];
		[answerLabel release];
		
		// jeweler name
		UILabel *jeweler = [[UILabel alloc] init];		
		[jeweler setTag:102];
		[jeweler setFrame:CGRectMake(10,52,290,15)];
		[jeweler setFont:[UIFont boldSystemFontOfSize:12]];
		[jeweler setTextColor:[UIColor grayColor]];
		[jeweler setTextColor:[UIColor orangeColor]];
		[jeweler setTextAlignment:UITextAlignmentRight];
		[jeweler setBackgroundColor:[UIColor clearColor]];
		[cell addSubview:jeweler];
		[jeweler release];
		
		UILabel *countLabel = [[UILabel alloc] init];
		[countLabel setTag:103];
		[countLabel setFrame:CGRectMake(5,(CELL_HEIGHT-12)/2, 12, 12)];
		countLabel.layer.cornerRadius = 7;
		[countLabel setBackgroundColor:[UIColor clearColor]];
		[cell addSubview:countLabel];
		[countLabel release];
		
		UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, (70-12)/2, 14, 12)];
		[arrow setImage:[UIImage imageNamed:@"cell_arrow.png"]];
        [arrow setTag:104];
		[cell addSubview:arrow];
		[arrow release];		
		
	}
	
	UILabel *answerLabel = (UILabel*)[cell viewWithTag:101];
	NSMutableString	*temp = [[NSMutableString alloc] initWithString:[[answersArray objectAtIndex:indexPath.row] objectForKey:@"msg"]];
	[temp replaceOccurrencesOfString:@"_SQ_" withString:@"'" options:1 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"_DQ_" withString:@"\"" options:1 range:NSMakeRange(0, [temp length])];
	[answerLabel setText:temp];
		
	UILabel *jeweler = (UILabel*)[cell viewWithTag:102];
	[jeweler setText:[[answersArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
	[temp release];
	
	UILabel *colorLabel = (UILabel*)[cell viewWithTag:103];
	if([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"qcount"] intValue] > 0)
	{
		[colorLabel setBackgroundColor:[UIColor orangeColor]];
	}
	else 
	{
		[colorLabel setBackgroundColor:[UIColor clearColor]];
	}
	
    UIImageView *arrow = (UIImageView*) [cell viewWithTag:104];
    [arrow setImage:[UIImage imageNamed:@"cell_arrow.png"]];

	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
#pragma mark -

#pragma mark DownloaderDelegate

- (void) refreshAnswersVC
{
//	[self getAnswers];
//	NSLog(@"need to refreshAnswersVC");
}

- (void) refershDetailedAnswersVC
{
	[obj_DetailedAnswersVC getAnswers];
}

#pragma mark -
#pragma mark Banner action
- (void) bannerClicked
{
    NSLog(@"bannerClicked %@",banner.weblink);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:banner.weblink]];
}

- (void) animateBanner
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [banner setAlpha:0.0];
    [UIView setAnimationDidStopSelector:@selector(animateBanner1)];
    [UIView commitAnimations];       
}

- (void) animateBanner1
{
    MyJewelerAppDelegate *appDelegate = (MyJewelerAppDelegate*)[[UIApplication sharedApplication] delegate];
    Banner *o = [appDelegate getAd];
    [banner setTag:[[o bannerID] intValue]];
    [banner setImage:[o bannerImage]];
    [banner setUid:[o bannerID]];
    [banner setWeblink:[o bannerURL]];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [banner setAlpha:1.0];
    [UIView setAnimationDidStopSelector:@selector(changeBanner)];
    [UIView commitAnimations];       
}

- (void) changeBanner
{
    if(isBannerAnimating)
    {
        [self performSelector:@selector(animateBanner) withObject:nil afterDelay:ANIMATE_BANNER_AFTER_DELAY];
    }
}

-(void) bannerAskaQuestionClicked:(id)sender
{
    //    NSLog(@"bannerAskaQuestionClicked %d",[banner tag]);
    AskBannerQuestionVC *o = [[AskBannerQuestionVC alloc] init];
    [o setToid:[NSString stringWithFormat:@"%d",[banner tag]]];
    [self.navigationController pushViewController:o animated:YES];
    [o release];
}
#pragma mark -
#pragma mark Info view
- (void) prepareInfoView
{
    infoView  = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, 280)];
    [infoView setUserInteractionEnabled:YES];
    
    UIImageView *callout = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320,280)];
    [callout setImage:[UIImage imageNamed:@"callout.png"]];
    [infoView addSubview:callout];
    
    UITextView *txt = [[UITextView alloc] initWithFrame:CGRectMake(40,50, 240, 155)];
    if(VERSION == 2)
    {
        [txt setText:JEWELER_INFO_TXT];
    }
    else
    {
        [txt setText:SUPPLIER_INFO_TXT];
    }
    [txt setBackgroundColor:[UIColor clearColor]];
    [txt setFont:[UIFont systemFontOfSize:14.0]];
    [txt setTextColor:[UIColor blackColor]];
    [txt setEditable:NO];
    [txt setScrollEnabled:YES];
    [txt setShowsVerticalScrollIndicator:NO];
    [infoView addSubview:txt];
    [txt release];
    
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(10,10,30,30)];
    [close setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(animateInfoView) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:close];   
    
    [infoView setAlpha:0.0];
    [self.view addSubview:infoView];
    [close release];
    [callout release];
    [infoView release];
}

- (void) animateInfoView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if(isInfoVisible)
    {
        isInfoVisible = NO;
        [myTable setUserInteractionEnabled:YES];
        [infoView setAlpha:0.0];
    }
    else
    {
        isInfoVisible = YES;
        [myTable setUserInteractionEnabled:NO];
        [infoView setAlpha:1.0];
        
    }
    [UIView commitAnimations];  
}
#pragma mark -
#pragma mark SQLITE ACCESS 
- (void) getAnswers
{
	if(answersArray !=nil)
	{
		[answersArray removeAllObjects];
		[answersArray release];
	}
	
	answersArray = [[NSMutableArray alloc] init];

	MySQLite *o;
	
	o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	NSMutableString	*query = [[NSMutableString alloc] initWithString:@"Select * from qatable "];
	[query appendFormat:@"where type = 1 and qid = '%@' group by fromid order by date_time",[infoDict objectForKey:@"qid"]];
	// Query for answers for a question by reply
	// "Select * from qatable where type = 1 and qid = '%s' group by fromid order by date_time", qid
	[o readDb:query];
	while([o hasNextRow])
	{
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setObject:[o getColumn:0 type:@"text"] forKey:@"qid"];
		[dict setObject:[o getColumn:1 type:@"text"] forKey:@"fromid"];
		[dict setObject:[o getColumn:2 type:@"text"] forKey:@"name"];
		[dict setObject:[o getColumn:3 type:@"text"] forKey:@"toid"];
		[dict setObject:[o getColumn:4 type:@"text"] forKey:@"date_time"];
		[dict setObject:[o getColumn:5 type:@"text"] forKey:@"type"];
		[dict setObject:[o getColumn:6 type:@"text"] forKey:@"msg"];
		[dict setObject:[o getColumn:7 type:@"text"] forKey:@"qcount"];
		[answersArray addObject:dict];
		[dict release];		
	}
	[o closeDb];
	[o release];	
	[query release];
	
	NSLog(@"answersvc arr - %@",answersArray);
	[myTable reloadData];[myTable reloadData];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
