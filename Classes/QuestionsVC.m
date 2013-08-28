    //
//  QuestionsVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/27/11.
//  Copyright 2011 no. All rights reserved.
//

#import "QuestionsVC.h"
#import "RegisterVC.h"
#import "AnswersVC.h"
#import "Constants.h"

#define	CELL_HEIGHT 65.0

@implementation QuestionsVC
@synthesize delegate;
@synthesize isBannerAnimating;

- (void)dealloc 
{
	if(questionsArray !=nil)
	{
		[questionsArray release];
	}
	[activityIndicator release];
	[obj_AnswersVC release];
    [banner release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    isBannerAnimating = YES;
    loadFirstBanner = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
    [self performSelector:@selector(animateBanner) withObject:nil afterDelay:ANIMATE_BANNER_AFTER_DELAY];

	[[NSUserDefaults standardUserDefaults] setInteger:21 forKey:@"page"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self getQuestions];
	[self performSelector:@selector(loadQuestions) withObject:nil afterDelay:0.3];
	//[self loadQuestions];
}

- (void) viewWillDisappear:(BOOL)animated  
{
    isBannerAnimating = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    //banner
    loadFirstBanner = YES;
    isInfoVisible = NO;

    isDeleteQuestion = NO;
    
	obj_AnswersVC = [[AnswersVC alloc] init];
	[self.navigationItem setTitle:@"Questions"];
	[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:41.0/255.0 green:32.0/255.0 blue:23.0/255.0 alpha:1.0]];
	
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadQuestions)];
	[self.navigationItem setRightBarButtonItem:refresh];
	[refresh release];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicator setCenter:CGPointMake(160, 200)];
	[self.view addSubview:activityIndicator];
    
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

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if([[NSUserDefaults standardUserDefaults] boolForKey:@"REGISTERED"])
	{
		//AnswersVC *o = [[AnswersVC alloc] init];
		[obj_AnswersVC setInfoDict:[questionsArray objectAtIndex:indexPath.row]];
		[self.navigationController pushViewController:obj_AnswersVC animated:YES];
		//[o release];
	}
	else 
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"It seems you are not a registered user." message:@"Click \"Ok\" to  register" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
		[alert show];
		[alert setTag:999];
		[alert release];
	}	
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [questionsArray count];
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
		
		UILabel *countLabel = [[UILabel alloc] init];
		[countLabel setTag:102];
		[countLabel setFrame:CGRectMake(5,(CELL_HEIGHT-12)/2, 12, 12)];
		countLabel.layer.cornerRadius = 7;
		[countLabel setBackgroundColor:[UIColor clearColor]];
		[cell addSubview:countLabel];
		[countLabel release];
		
 		// for  title
		UILabel *titleLabel = [[UILabel alloc] init];		
		[titleLabel setTag:101];
		[titleLabel setFrame:CGRectMake(30,7,270,50)];
		[titleLabel setNumberOfLines:3];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[titleLabel setTextColor:[UIColor whiteColor]];//colorWithRed:1 green:1 blue:1 alpha:0.7]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		//[titleLabel setTextAlignment:UITextAlignmentRight];
		[cell addSubview:titleLabel];
		[titleLabel release];
		
		UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, (CELL_HEIGHT-12)/2, 14, 12)];
		[arrow setImage:[UIImage imageNamed:@"cell_arrow.png"]];
        [arrow setTag:103];
		[cell addSubview:arrow];
		[arrow release];
	}
	
	UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
	NSMutableString	*temp = [[NSMutableString alloc] initWithString:[[questionsArray objectAtIndex:indexPath.row] objectForKey:@"question"]];
	[temp replaceOccurrencesOfString:@"_SQ_" withString:@"'" options:1 range:NSMakeRange(0, [temp length])];
	[temp replaceOccurrencesOfString:@"_DQ_" withString:@"\"" options:1 range:NSMakeRange(0, [temp length])];
	[titleLabel setText:temp];
	[temp release];
	
	UILabel *colorLabel = (UILabel*)[cell viewWithTag:102];
	if([[[questionsArray objectAtIndex:indexPath.row] objectForKey:@"count"] intValue] > 0)
	{
		[colorLabel setBackgroundColor:[UIColor orangeColor]];
	}
	else 
	{
		[colorLabel setBackgroundColor:[UIColor clearColor]];
	}
    
    UIImageView *arrow = (UIImageView*) [cell viewWithTag:103];
    [arrow setImage:[UIImage imageNamed:@"cell_arrow.png"]];

	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	
	[self deleteQuestion:[[questionsArray objectAtIndex:indexPath.row] objectForKey:@"qid"]];
	NSString *query1 = [[NSString alloc] initWithFormat:@"DELETE FROM questions WHERE id ='%@'",[[questionsArray objectAtIndex:indexPath.row] objectForKey:@"qid"]];
	NSString *query2 = [[NSString alloc] initWithFormat:@"DELETE FROM qatable WHERE qid ='%@'",[[questionsArray objectAtIndex:indexPath.row] objectForKey:@"qid"]];
	for(int i = 0 ; i < 2 ; i++)
	{
		MySQLite *sqlObj = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
		[sqlObj openDb];
		if(i == 0)	[sqlObj readDb:query1];
		if(i == 1)	[sqlObj readDb:query2];
		[sqlObj hasNextRow];
		[sqlObj closeDb];
		[sqlObj release];
	}
	
	[questionsArray removeObjectAtIndex:[indexPath row]];
	
	[query1 release];
	[query2 release];
	
	[myTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	[myTable endUpdates];	
	[myTable reloadData];
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

#pragma mark  UIAlertViewDelegate method 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if([alertView tag] == 999 && buttonIndex == 1)
	{
		RegisterVC *o = [[RegisterVC alloc] init];
		[self.navigationController pushViewController:o animated:YES];
		[o release];		
	}
}

#pragma mark -

#pragma mark DownloaderDelegate

- (void) refreshQuestionsVC
{
	NSLog(@"need to refreshQuestionsVC");
	
}

- (void) refreshAnswersVC
{
	[obj_AnswersVC getAnswers];
}

- (void) refreshDetailedAnswersVC
{
	[obj_AnswersVC refershDetailedAnswersVC];
}
#pragma mark -
#pragma mark ASI Support 

- (void)loadQuestions 
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[activityIndicator startAnimating];
	
	isDeleteQuestion = NO;
	//MyJewelerAppDelegate *appDelegate = (MyJewelerAppDelegate*) [[UIApplication sharedApplication] delegate];

	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/questions.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"] forKey:@"myid"];
	[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"last_known_time"] forKey:@"last_known_time"];
	[req setDelegate:self];
	[req startAsynchronous];
	[req release];
	[url release];	
}


- (void) deleteQuestion:(NSString*)qid
{
	isDeleteQuestion =YES;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[activityIndicator startAnimating];
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/deletequestion.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:qid forKey:@"qid"];
	[req setDelegate:self];
	[req startAsynchronous];	
}

//#pragma mark  ASI Delegate methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activityIndicator stopAnimating];
	
	NSLog(@"response  -%@",[request responseString]);

	if(!isDeleteQuestion)
	{
		NSDictionary *myDict = [[NSDictionary alloc] initWithDictionary:[[request responseString] JSONValue]];
		NSArray *answersArray = [[NSArray alloc] initWithArray:[myDict objectForKey:@"answers"]];	
		NSArray *countArray = [[NSArray alloc] initWithArray:[myDict objectForKey:@"count"]];	
		[[NSUserDefaults standardUserDefaults] setObject:[myDict objectForKey:@"last_known_time"] forKey:@"last_known_time"];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
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
//				NSLog(@"query - %@",query);		
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
//				NSLog(@"query - %@",query);		
				[o readDb:query];
				[o hasNextRow];
				[o closeDb];
				[o release];
				[query release];
				
				o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
				[o openDb];
				query = [[NSMutableString alloc] initWithString:@"update questions set "];
				[query appendFormat:@"qcount = '%@' where id = '%@'",[dict objectForKey:@"count"],[dict objectForKey:@"qid"]];
//				NSLog(@"query - %@",query);		
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
		
		[self performSelector:@selector(getQuestions) withObject:nil afterDelay:0.3];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	if(!isDeleteQuestion)
	{
		NSError *error = [request error];
		NSLog(@"error - %@\n",error);
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Network error" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert release];	
	}
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activityIndicator stopAnimating];
}

#pragma mark -
#pragma mark SQLITE ACCESS 
- (void) getQuestions
{
	if(questionsArray !=nil)
	{
		[questionsArray removeAllObjects];
		[questionsArray release];
	}
	
	questionsArray = [[NSMutableArray alloc] init];
	
	MySQLite *o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	//[o readDb:@"Select a.id, a.question, b.qcount from questions a, qatable b where a.id = b.qid"];
	[o readDb:@"Select * from questions order by id desc"];
	while([o hasNextRow])
	{
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setObject:[o getColumn:0 type:@"text"] forKey:@"qid"];
		[dict setObject:[o getColumn:1 type:@"text"] forKey:@"question"];
		[dict setObject:[o getColumn:2 type:@"text"] forKey:@"count"];
		[questionsArray addObject:dict];
		[dict release];		
	}
	[o closeDb];
	[o release];
	
	[self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.3];
}

- (void) reloadTable
{
	[myTable reloadData];
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



// response in DICT
//		if([mainDic objectForKey:[dict objectForKey:@"qid"]] == nil )
//		{
//			// QID
//			NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
//			[mainDic setObject:subDic forKey:[dict objectForKey:@"qid"]];
//			[subDic release];
//		}
//
//		if([[mainDic objectForKey:[dict objectForKey:@"qid"]] objectForKey:[dict objectForKey:@"fromid"]] == nil)
//		{
//			NSMutableArray *messageArray = [[NSMutableArray alloc] init];
//			[messageArray addObject:dict];
//			[[mainDic objectForKey:[dict objectForKey:@"qid"]] setObject:messageArray forKey:[dict objectForKey:@"fromid"]];
//			[messageArray release];
//		}
//		else 
//		{
//			NSMutableArray *messageArray  = [[mainDic objectForKey:[dict objectForKey:@"qid"]] objectForKey:[dict objectForKey:@"fromid"]];
//			[messageArray addObject:dict];
//			[[mainDic objectForKey:[dict objectForKey:@"qid"]] setObject:messageArray forKey:[dict objectForKey:@"fromid"]];
//		}


@end
