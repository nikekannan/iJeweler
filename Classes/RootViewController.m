    //
//  RootViewController.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 2/1/11.
//  Copyright 2011 no. All rights reserved.
//

#import "MyJewelerAppDelegate.h"
#import "RootViewController.h"
#import "QuestionsVC.h"
#import "AskCategory.h"
#import "AskQuestionVC.h"
#import "PersonalShoppingAsstVC.h"
#import "Constants.h"
#import "AnswersVC.h"
#import "DetailedAnswersVC.h"
#import "PersonalAsstVC.h"
#import "BannerView.h"

#import "EducationVC.h"
#import "JewelersVC.h"
#import "NewsVC.h"
#import "HelpVC.h"
#import "CouponsVC.h"
#import "BannersVC.h"
#import "MyCategoriesVC.h"

@implementation RootViewController

@synthesize activeDownload;
@synthesize urlConnection;
@synthesize delegate;
@synthesize isBannerAnimating;

- (void)dealloc
{
    [banner release];
    [activeDownload release];
	[urlConnection cancel];
	[urlConnection release];
	[obj_QuestionsVC release];	
    [super dealloc];
}


- (void) viewWillAppear:(BOOL)animated
{
    isBannerAnimating = YES;
    loadFirstBanner = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
    [self performSelector:@selector(animateBanner) withObject:nil afterDelay:ANIMATE_BANNER_AFTER_DELAY];

	[[NSUserDefaults standardUserDefaults] setInteger:20 forKey:@"page"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) viewWillDisappear:(BOOL)animated  
{
    isBannerAnimating = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    loadFirstBanner = YES;
    isInfoVisible = NO;

//	NSLog(@"myid - %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"]);
	[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:41.0/255.0 green:32.0/255.0 blue:23.0/255.0 alpha:1.0]];
	[self.navigationItem setTitle:@"iJeweler"];

	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
	[self.navigationItem setBackBarButtonItem:back];
	[back release];	
    
    
    MyJewelerAppDelegate *appDelegate = (MyJewelerAppDelegate*)[[UIApplication sharedApplication] delegate];
    Banner *o = [appDelegate getAd];
    banner = [[BannerView alloc] init];
    [banner setFrame:CGRectMake(0,0,320,60)];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [banner setFrame:CGRectMake(0,445,320,60)];
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
    // WithFrame:CGRectMake(0,0,kBannerWidth,kBannerHeight) userid:[o bannerID] link:[o bannerURL]];
	obj_QuestionsVC = [[QuestionsVC alloc] init];
	
	[self.view setBackgroundColor:[UIColor clearColor]];
	[self loadTable];
    [self prepareInfoView];
#pragma mark - Top scroll
//	[self prepareScrollView];
    [super viewDidLoad];
}

- (void) prepareScrollView
{
	UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320,30)];
	[scroll setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
	[scroll setShowsHorizontalScrollIndicator:NO];
	int x = 6;
    if(VERSION == 2)
    {
        for( int i = 0 ; i < 6; i++)
        {
            UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [b1 setFrame:CGRectMake(x,2,100,25)];
            [b1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [b1 setBackgroundImage:[UIImage imageNamed:@"yellowbutton.png"] forState:UIControlStateNormal];
            b1.layer.cornerRadius = 10.0f;
			if(i == 0) [b1 setTitle:@"Education" forState:UIControlStateNormal];
			if(i == 1) [b1 setTitle:@"Jewelers" forState:UIControlStateNormal];
			if(i == 2) [b1 setTitle:@"News" forState:UIControlStateNormal];
			if(i == 3) [b1 setTitle:@"Help" forState:UIControlStateNormal];
			if(i == 4) [b1 setTitle:@"Coupons" forState:UIControlStateNormal];
			if(i == 5) [b1 setTitle:@"Banner" forState:UIControlStateNormal];
            
            [b1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [b1 setTag:200+i];
            [scroll addSubview:b1];
            x += 106;
        }
    }
    else
    {
        for( int i = 0 ; i < 7; i++)
        {
            UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [b1 setFrame:CGRectMake(x,2,100,25)];
            [b1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [b1 setBackgroundImage:[UIImage imageNamed:@"yellowbutton.png"] forState:UIControlStateNormal];
            b1.layer.cornerRadius = 10.0f;

            if(i == 0) [b1 setTitle:@"Education" forState:UIControlStateNormal];
            if(i == 1) [b1 setTitle:@"Suppliers" forState:UIControlStateNormal];
            if(i == 2) [b1 setTitle:@"News" forState:UIControlStateNormal];
            if(i == 3) [b1 setTitle:@"Help" forState:UIControlStateNormal];
            if(i == 4) [b1 setTitle:@"Buy-Sell" forState:UIControlStateNormal];
            if(i == 5) [b1 setTitle:@"Banner" forState:UIControlStateNormal];
            if(i == 6) [b1 setTitle:@"My Store" forState:UIControlStateNormal];
            
            [b1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [b1 setTag:200+i];
            [scroll addSubview:b1];
            x += 106;
        }
    }
    [scroll setContentSize:CGSizeMake(x, 30)];

	[self.view addSubview:scroll];
	[scroll release];
}
- (void) loadTable
{
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,360) style:UITableViewStyleGrouped];
	[myTable setDelegate:self];
	[myTable setDataSource:self];
    [myTable setBackgroundView:nil];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [myTable setFrame:CGRectMake(0,0,320,448)];
    }
	[myTable setBackgroundColor:[UIColor clearColor]];
	[myTable setSeparatorColor:[UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0]];
	[myTable setScrollEnabled:NO];
	[self.view addSubview:myTable];
	[myTable release];	
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(VERSION == 0)
	{
		return 60.0;
	}
	return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if(VERSION == 0)
	{
		// Supplier version contains 4 items
		if(indexPath.section ==0)
		{
			[self performSelector:@selector(loadAskaCategoryVC) withObject:nil afterDelay:0.3];
		}
		else if(indexPath.section == 1)
		{
			[self performSelector:@selector(loadAskaQuestionVC) withObject:nil afterDelay:0.3];
		}
		else if(indexPath.section == 2)
		{
			[self performSelector:@selector(loadQuestionsVC) withObject:nil afterDelay:0.3];
		}
		else if(indexPath.section == 3)
		{
			[self performSelector:@selector(loadPersonalAssistantVC) withObject:nil afterDelay:0.3];
		}		
	}
	else 
	{
		// Jeweler & Consumer version contains 3 items
		if(indexPath.section ==0)
		{
			[self performSelector:@selector(loadAskaQuestionVC) withObject:nil afterDelay:0.3];
		}
		else if(indexPath.section == 1)
		{
			[self performSelector:@selector(loadQuestionsVC) withObject:nil afterDelay:0.3];
		}
		else if(indexPath.section == 2)
		{
			if(VERSION == 1) [self performSelector:@selector(loadPersonalAssistantVC) withObject:nil afterDelay:0.3];
			else [self performSelector:@selector(loadPersonalShoppingAssistantVC) withObject:nil afterDelay:0.3];
		}			
	}
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if(VERSION == 0)
	{
		return 10.0;
	}
	return 15.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"cellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil)
	{
		cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
 		[cell setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
		
		UIView *v = [[UIView alloc] initWithFrame:CGRectZero];	
        v.backgroundColor = [UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0];	
		v.layer.cornerRadius = 7;
        cell.selectedBackgroundView = v;
		[v release];
		
		
		// for  title
		UILabel *titleLabel = [[UILabel alloc] init];		
		[titleLabel setTag:101];
		[titleLabel setFrame:CGRectMake(10,7,300,65)];
		[titleLabel setNumberOfLines:2];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextAlignment:UITextAlignmentCenter];
		[cell addSubview:titleLabel];
		[titleLabel release];
	}
	UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
	if(VERSION == 0)
	{
		[titleLabel setFrame:CGRectMake(10,5,300,50)];
		if(indexPath.section == 0)
		{
			[titleLabel setText:@"Choose your Business Categories"];
		}
		else if (indexPath.section == 1)
		{			
			[titleLabel setText:@"Ask a Question"];
		}
		else if (indexPath.section == 2)
		{			
			[titleLabel setText:@"View Answers"];
		}	
		else if (indexPath.section == 3)
		{			
			[titleLabel setText:@"Personal Assistant"];
		}	
	}
	else 
	{
		if(indexPath.section == 0)
		{
			[titleLabel setText:@"Ask a Question"];
		}
		else if (indexPath.section == 1)
		{			
			[titleLabel setText:@"View Answers"];
		}
		else if (indexPath.section == 2)
		{			
			[titleLabel setText:((VERSION==1)?@"Personal Assistant": @"Personal Shopping Assistant")];
		}			
	}
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if(VERSION == 0)
	{
		return 4;
	}	
	return 3;
}

#pragma mark Utility functions

- (void) loadAskaCategoryVC
{
	AskCategory *o = [[AskCategory alloc] init];
	[self.navigationController pushViewController:o animated:YES];
	[o release];	
}
- (void) loadAskaQuestionVC
{
	AskQuestionVC *o = [[AskQuestionVC alloc] init];
	[self.navigationController pushViewController:o animated:YES];
	[o release];	
}

- (void) loadQuestionsVC
{
	[self.navigationController pushViewController:obj_QuestionsVC animated:YES];
}

- (void) loadPersonalShoppingAssistantVC
{
	PersonalShoppingAsstVC *o = [[PersonalShoppingAsstVC alloc] init];
	[self.navigationController pushViewController:o animated:YES];
	[o release];
}

- (void) loadPersonalAssistantVC
{
	PersonalAsstVC *o = [[PersonalAsstVC alloc] init];
	[self.navigationController pushViewController:o animated:YES];
	[o release];
}

- (void) updateToken
{
	// just to update the token and latlng
	if([[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"] intValue] > 0)
	{
		NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/register.php", URL]];
		ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
		[req setPostValue:@"0" forKey:@"option"];
		[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"] forKey:@"uid"];
		[req setPostValue:[NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"mylat"]] forKey:@"lat"];
		[req setPostValue:[NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"mylng"]] forKey:@"lng"];
		[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
		[req startAsynchronous];		
		[req release];
		[url release];				
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark Banner action
-(void) bannerAskaQuestionClicked:(id)sender
{
    //    NSLog(@"bannerAskaQuestionClicked %d",[banner tag]);
    AskBannerQuestionVC *o = [[AskBannerQuestionVC alloc] init];
    [o setToid:[NSString stringWithFormat:@"%d",[banner tag]]];
    [self.navigationController pushViewController:o animated:YES];
    [o release];
}

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

#pragma mark Downloader
- (void)downloadQuestions
{
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
	NSMutableString *url = [[NSMutableString alloc] init];
	[url appendFormat:@"%@/questions.php?myid=%@&last_known_time=%@",URL,[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"],[[NSUserDefaults standardUserDefaults] objectForKey:@"last_known_time"]];
	[url replaceOccurrencesOfString:@" " withString:@"%20" options:1 range:NSMakeRange(0, [url	length])];
	NSLog(@"Downloader url - %@", url);
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:url]] delegate:self];
    self.urlConnection = conn;
    [conn release];
	[url release];
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.urlConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *response = [[NSString alloc] initWithData:self.activeDownload encoding:NSUTF8StringEncoding];
	NSDictionary *myDict = [[NSDictionary alloc] initWithDictionary:[response JSONValue]];
	NSArray *answersArray = [[NSArray alloc] initWithArray:[myDict objectForKey:@"answers"]];	
	NSArray *countArray = [[NSArray alloc] initWithArray:[myDict objectForKey:@"count"]];
	// save last known time
	[[NSUserDefaults standardUserDefaults] setObject:[myDict objectForKey:@"last_known_time"] forKey:@"last_known_time"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	NSLog(@"downloader response - %@", myDict);
	if([answersArray count] > 0)
	{
		// push the answers
		for(NSDictionary *dict in answersArray)
		{
			NSMutableString *msg = [[NSMutableString alloc] initWithString:[dict objectForKey:@"msg"]];
			[msg	replaceOccurrencesOfString:@"'" withString:@"_SQ_" options:1 range:NSMakeRange(0, [msg length])];
			[msg	replaceOccurrencesOfString:@"\"" withString:@"_DQ_" options:1 range:NSMakeRange(0, [msg length])];
			
			MySQLite *o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
			[o openDb];
			NSMutableString *query = [[NSMutableString alloc] initWithString:@"insert into qatable (qid, fromid, name, toid, date_time, type, msg, qcount, at1, at2, at3, at4, at5) "];
			[query appendFormat:@"values('%@','%@','%@','%@','%@','1','%@','0','%@','%@','%@','%@','%@')",[dict objectForKey:@"qid"],[dict objectForKey:@"fromid"],[dict objectForKey:@"name"],[dict objectForKey:@"toid"],[dict objectForKey:@"date_time"],msg,[dict objectForKey:@"at1"],[dict objectForKey:@"at2"],[dict objectForKey:@"at3"],[dict objectForKey:@"at4"],[dict objectForKey:@"at5"]];
//			NSLog(@"query - %@",query);		
			[o readDb:query];
			[o hasNextRow];
			[o closeDb];
			[o release];
			[query release];
			
			// check whether question exists
			o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
			[o openDb];
			[o readDb:[NSString stringWithFormat:@"Select * from questions where id=%@",[dict objectForKey:@"qid"]]];
			BOOL isQtnExists = NO;
			while([o hasNextRow])
			{
				isQtnExists = YES;
			}
			[o closeDb];
			[o release];
			
			// if not exists just create the question
			if(!isQtnExists)
			{
				o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
				[o openDb];
				[o readDb:[NSString stringWithFormat:@"insert into questions values ( '%@', '%@', '%@')",[dict objectForKey:@"qid"],msg,[dict objectForKey:@"count"]]];
				[o hasNextRow];
				[o closeDb];
				[o release];
			}
			[msg release];
		}
		
		for(NSDictionary *dict in countArray)
		{
			MySQLite *o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
			[o openDb];
			NSMutableString *query = [[NSMutableString alloc] initWithString:@"update qatable set "];
			[query appendFormat:@"qcount = '%@' where qid = '%@' and fromid ='%@'",[dict objectForKey:@"count"],[dict objectForKey:@"qid"],[dict objectForKey:@"fromid"]];
//			NSLog(@"query - %@",query);		
			[o readDb:query];
			[o hasNextRow];
			[o closeDb];
			[o release];
			[query release];
			
			o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
			[o openDb];
			query = [[NSMutableString alloc] initWithString:@"update questions set "];
			[query appendFormat:@"qcount = '%@' where id = '%@'",[dict objectForKey:@"count"],[dict objectForKey:@"qid"]];
//			NSLog(@"query - %@",query);		
			[o readDb:query];
			[o hasNextRow];
			[o closeDb];
			[o release];
			[query release];
		}
	}
	[myDict release];
	[countArray release];
	[answersArray release];
	
	
	
	self.activeDownload = nil;
    [response release];
    
    // Release the connection now that it's finished
    self.urlConnection = nil;
	
	
	NSLog(@"page num - %d",[[NSUserDefaults standardUserDefaults] integerForKey:@"page"]);
	// call our delegate and tell it that our icon is ready for display
	// refresh corresponding VCs
	int page = [[NSUserDefaults standardUserDefaults] integerForKey:@"page"] ;
	if(page == 21)
	{
		[obj_QuestionsVC getQuestions];
//		if(	[delegate respondsToSelector:@selector(refreshQuestionsVC)])
//		   [delegate refreshQuestionsVC];
	}
		
	else if(page == 22)
	{
		[obj_QuestionsVC refreshAnswersVC];
//		[[AnswersVC sharedInstance] getAnswers];
//		if(	[delegate respondsToSelector:@selector(refreshAnswersVC)])
//			[delegate refreshAnswersVC];
	}
		
	else if(page == 23)
	{
		[obj_QuestionsVC refreshDetailedAnswersVC];
//		[[DetailedAnswersVC sharedInstance] getAnswers];
//		if(	[delegate respondsToSelector:@selector(refershDetailedAnswersVC)])
//			[delegate refershDetailedAnswersVC];
	}
		
}
#pragma mark Scroller methods

- (void) buttonAction:(id)sender
{
	if(VERSION == 2)
	{
		switch ([sender tag])
		{
			case 200:
			{
				EducationVC *o = [[EducationVC alloc] init];
				[o setTitle:@"How to Choose Diamond"];
				[self.navigationController pushViewController:o animated:YES];
				[o release];
				//			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.gia.edu/resources/flash/4cs/GIA.swf"]];
			}
				break;
			case 201:
			{
				JewelersVC *o = [[JewelersVC alloc] init];
				[self.navigationController pushViewController:o animated:YES];
				[o release];
			}			
				break;
			case 202:
			{
				NewsVC *o = [[NewsVC alloc] init];
				[self.navigationController pushViewController:o animated:YES];
				[o release];
			}
				break;
			case 203:
			{
				HelpVC *o = [[HelpVC alloc] init];
				[o setTitle:@"Help"];
				[o setUrl:[NSURL URLWithString:@"http://www.raincatcher.org/"]];
				[self.navigationController pushViewController:o animated:YES];
				[o release];
			}
				break;
			case 204:
			{
				CouponsVC *o = [[CouponsVC alloc] init];
				[self.navigationController pushViewController:o animated:YES];
				[o release];
			}
				break;
			case 205:
			{
				BannersVC *o = [[BannersVC alloc] init];
				[self.navigationController pushViewController:o animated:YES];
				[o release];
			}
				break;
			default:
				break;
		}
	}
	else 
	{
		switch ([sender tag])
		{
			case 200:
			{
				EducationVC *o = [[EducationVC alloc] init];
				[o setTitle:@"Your Jewelry Education Starts Here"];
				[self.navigationController pushViewController:o animated:YES];
				[o release];
			}
				break;
			case 201:
			{
				JewelersVC *o = [[JewelersVC alloc] init];
				[self.navigationController pushViewController:o animated:YES];
				[o release];
			}			
				break;
			case 202:
			{
				NewsVC *o = [[NewsVC alloc] init];
				[self.navigationController pushViewController:o animated:YES];
				[o release];
			}
				break;
			case 203:
			{
				HelpVC *o = [[HelpVC alloc] init];
				[o setTitle:@"Help"];
				[o setUrl:[NSURL URLWithString:@"http://www.raincatcher.org/"]];
				[self.navigationController pushViewController:o animated:YES];
				[o release];
			}
				break;
			case 204:
			{
				CouponsVC *o = [[CouponsVC alloc] init];
				[self.navigationController pushViewController:o animated:YES];
				[o release];
			}
				break;
			case 205:
			{
				BannersVC *o = [[BannersVC alloc] init];
				[self.navigationController pushViewController:o animated:YES];
				[o release];
			}
				break;
			case 206:
			{
				MyCategoriesVC *o = [[MyCategoriesVC alloc] init];
				[self.navigationController pushViewController:o animated:YES];
				[o release];
			}
				break;
			default:
				break;
		}		
	}
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
