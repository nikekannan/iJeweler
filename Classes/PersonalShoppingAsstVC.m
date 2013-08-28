    //
//  PersonalShoppingAsstVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/27/11.
//  Copyright 2011 no. All rights reserved.
//

#import "PersonalShoppingAsstVC.h"
#import	"AddPersonVC.h"
#import "UpdatePersonVC.h"
#import "Constants.h"

@implementation PersonalShoppingAsstVC
@synthesize isBannerAnimating;

- (void)dealloc 
{
	if(infoArray !=nil)
	{
		[infoArray release];
	}
    [banner release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    isBannerAnimating = YES;
    loadFirstBanner = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
    [self performSelector:@selector(animateBanner) withObject:nil afterDelay:ANIMATE_BANNER_AFTER_DELAY];
    
	[self.navigationItem setTitle:@"Personal Shopping Ass't"];
	[self getDataFromDB];
}

- (void) viewWillDisappear:(BOOL)animated  
{
    isBannerAnimating = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    loadFirstBanner = YES;
    isInfoVisible = NO;
    
	[self.navigationItem setTitle:@"Personal Shopping Ass't"];
	[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:41.0/255.0 green:32.0/255.0 blue:23.0/255.0 alpha:1.0]];

    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0,0,43,25)];
    
    UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0,0,43,25)];
    [b setImage:[UIImage imageNamed:@"addperson_button.png"] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(addNewPerson) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:b];
    
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    [self.navigationItem setRightBarButtonItem:add];
//	UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewPerson)];
    [add release];
	[b release];
    [buttonView release];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(25,0,200,30)];
    [titleView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,30)];
    [l setText:@"Personal Shopping Ass't"];
    [l setBackgroundColor:[UIColor clearColor]];
    [l setFont:[UIFont boldSystemFontOfSize:16.0]];
    [l setTextColor:[UIColor whiteColor]];
    [l setTextAlignment:UITextAlignmentCenter];
    [titleView addSubview:l];
    [self.navigationItem setTitleView:titleView];
    
    [titleView release];
    [l release];
    
	
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
	[self.navigationItem setBackBarButtonItem:back];
	[back release];

	[self loadTable];
    
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
    
    [self prepareInfoView];

    [super viewDidLoad];
}

-(void) addNewPerson
{
	AddPersonVC *o = [[AddPersonVC alloc] init];
	[self.navigationController pushViewController:o animated:YES];
	[o release];	
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
	return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UpdatePersonVC *o = [[UpdatePersonVC alloc] init];
	[o setRowid:[[[infoArray objectAtIndex:indexPath.row] objectForKey:@"id"] intValue]];
	[self.navigationController pushViewController:o animated:YES];
	[o release];
}
#pragma mark -

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [infoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"cellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil)
	{
		cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		//[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		
		UIView *v = [[UIView alloc] init];			
        v.backgroundColor = [UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0];		
        cell.selectedBackgroundView = v;
		[v release];
		
		// for  title
		UILabel *titleLabel = [[UILabel alloc] init];		
		[titleLabel setTag:101];
		[titleLabel setFrame:CGRectMake(10,5,250,30)];
		[titleLabel setNumberOfLines:3];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		//[titleLabel setTextAlignment:UITextAlignmentRight];
		[cell addSubview:titleLabel];
		[titleLabel release];	
		
		titleLabel = [[UILabel alloc] init];		
		[titleLabel setTag:102];
		[titleLabel setFrame:CGRectMake(210,5,80,30)];
		[titleLabel setFont:[UIFont systemFontOfSize:14]];
		[titleLabel setTextColor:[UIColor lightGrayColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextAlignment:UITextAlignmentRight];
		[cell addSubview:titleLabel];
		[titleLabel release];	
		
		UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, 14, 14, 12)];
		[arrow setImage:[UIImage imageNamed:@"cell_arrow.png"]];
		[cell addSubview:arrow];
		[arrow release];
	}
	
	UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
	[titleLabel setText:[[infoArray objectAtIndex:indexPath.row] objectForKey:@"name"]];

	UILabel *daysLabel = (UILabel*)[cell viewWithTag:102];
	
	if([[[infoArray objectAtIndex:indexPath.row] objectForKey:@"days"] intValue] == 0)
	{
		[daysLabel setText:@"Today"];
	}
	else if(([[[infoArray objectAtIndex:indexPath.row] objectForKey:@"days"] intValue] < 0) || ([[[infoArray objectAtIndex:indexPath.row] objectForKey:@"days"] intValue] > 7) )
	{
		[daysLabel setText:nil];
	}
	else 
	{
		[daysLabel setText:(([[[infoArray objectAtIndex:indexPath.row] objectForKey:@"days"]intValue] > 1)?[NSString stringWithFormat:@"%@ days",[[infoArray objectAtIndex:indexPath.row] objectForKey:@"days"]]:@"1 day")];
	}
	// testing
	// [daysLabel setText:[NSString stringWithFormat:@"%@ days",[[infoArray objectAtIndex:indexPath.row] objectForKey:@"days"]]];
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	//	printf("\ncanEditRowAtIndexPath\n");
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	
	[self deletePSA:[[infoArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
	NSString *query1 = [[NSString alloc] initWithFormat:@"DELETE FROM personalshopping WHERE id ='%@'",[[infoArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
	NSString *query2 = [[NSString alloc] initWithFormat:@"DELETE FROM jewelcolor WHERE id ='%@'",[[infoArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
	NSString *query3 = [[NSString alloc] initWithFormat:@"DELETE FROM jewelstyle WHERE id ='%@'",[[infoArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
	NSString *query4 = [[NSString alloc] initWithFormat:@"DELETE FROM watchstyle WHERE id ='%@'",[[infoArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
	for(int i = 0 ; i < 4 ; i++)
	{
		MySQLite *sqlObj = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
		[sqlObj openDb];
		if(i == 0)	[sqlObj readDb:query1];
		if(i == 1)	[sqlObj readDb:query2];
		if(i == 2)	[sqlObj readDb:query3];
		if(i == 3)	[sqlObj readDb:query4];
		[sqlObj hasNextRow];
		[sqlObj closeDb];
		[sqlObj release];
	}
	
	[infoArray removeObjectAtIndex:[indexPath row]];
	
	[query1 release];
	[query2 release];
	[query3 release];
	[query4 release];
	
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
#pragma mark ASI support 
- (void) deletePSA:(NSString*)psaID
{
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/psa.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:@"2" forKey:@"option"];
	[req setPostValue:psaID forKey:@"id"];
	[req setDelegate:self];
	[req startAsynchronous];	
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	NSLog(@"delete psa response - %@",[request responseString]);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void) getDataFromDB
{
	if(infoArray !=nil)
	{
		[infoArray release];
	}
	
	//@"select ((strftime('%s',strftime('%Y','now')||'-'||strftime('%m',c7)||'-'||strftime('%d',c7)) - strftime('%s','now')) / (60 * 60 * 24) )  from personalshopping;"
	
	infoArray = [[NSMutableArray alloc] init];
	
	MySQLite *o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	[o readDb:@"select id,c1,((strftime('%s',strftime('%Y','now')||'-'||strftime('%m',c7)||'-'||strftime('%d',c7)) - strftime('%s','now')) / (60 * 60 * 24) ) from personalshopping order by c1"];
	while ([o hasNextRow]) 
	{
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setObject:[o getColumn:0 type:@"text"] forKey:@"id"];
		[dict setObject:[o getColumn:1 type:@"text"] forKey:@"name"];
		[dict setObject:[o getColumn:2 type:@"text"] forKey:@"days"];
		[infoArray addObject:dict];
		[dict release];
	}
	[o closeDb];
	[o release];
	[myTable reloadData];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
