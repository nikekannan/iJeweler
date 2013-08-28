    //
//  JewelerInfoVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/29/11.
//  Copyright 2011 no. All rights reserved.
//

#import "JewelerInfoVC.h"
#import "Constants.h"

@implementation JewelerInfoVC
@synthesize userID;
@synthesize isBannerAnimating;

- (void)dealloc 
{
    [banner release];
	[userID release];
	[infoDict release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    isBannerAnimating = YES;
    loadFirstBanner = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
    [self performSelector:@selector(animateBanner) withObject:nil afterDelay:ANIMATE_BANNER_AFTER_DELAY];
    
	[self getInfo];
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

	[self.navigationItem setTitle:@"Jeweler Info"];
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicator setCenter:CGPointMake(160, 220)];
	[self.view addSubview: activityIndicator];
    
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
    
    [super viewDidLoad];
}



- (void) loadTable
{
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,300) style:UITableViewStyleGrouped];
	[myTable setDelegate:self];
	[myTable setDataSource:self];
	[myTable setScrollEnabled:NO];
    [myTable setBackgroundView:nil];
	[myTable setBackgroundColor:[UIColor clearColor]];
	[myTable setSeparatorColor:[UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0]];
	[self.view addSubview:myTable];
	[myTable release];	
    
    [self prepareInfoView];
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row == 0)
	{
		return 80.0;
	}
	return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.row ==1)
	{
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[self performSelector:@selector(makeACall) withObject:nil afterDelay:0.3];
	}
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ((section == 0)?1:2);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"cellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil)
	{
		cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
		[cell setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
		
		if(indexPath.section == 0 && indexPath.row == 0)
		{
			UIImage *logo = [UIImage imageNamed:@"diamond.png"];
			UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(10,10,logo.size.width, logo.size.height)];
			[logoView setImage:logo];
			[cell.contentView addSubview:logoView];
			[logoView release];
			
			UILabel *titleLabel = [[UILabel alloc] init];		
			[titleLabel setTag:101];
			[titleLabel setFrame:CGRectMake(80,10,200,60)];
			[titleLabel setNumberOfLines:3];
			[titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
			[titleLabel setText:[infoDict objectForKey:@"shopname"]];
			if([[infoDict objectForKey:@"shopname"] isEqualToString:@"NA"])
			{
				[titleLabel setText:[infoDict objectForKey:@"name"]];
			}
			[titleLabel setTextColor:[UIColor whiteColor]];
			[titleLabel setBackgroundColor:[UIColor clearColor]];
			[cell.contentView addSubview:titleLabel];
			[titleLabel release];		
		}
		else if ( indexPath.section == 1 && indexPath.row == 0)
		{
			// for  title
			UILabel *titleLabel = [[UILabel alloc] init];		
			[titleLabel setFrame:CGRectMake(10,5,60,30)];
			[titleLabel setTextAlignment:UITextAlignmentRight];
			[titleLabel setFont:[UIFont systemFontOfSize:14]];
			[titleLabel setText:@"Address:"];			
			[titleLabel setTextColor:[UIColor grayColor]];//colorWithRed:r green:g blue:b alpha:1.0]];
			[titleLabel setBackgroundColor:[UIColor clearColor]];
 			[cell.contentView addSubview:titleLabel];
			[titleLabel release];

			titleLabel = [[UILabel alloc] init];		
			[titleLabel setFrame:CGRectMake(80,5,200,50)];
			[titleLabel setNumberOfLines:3];
			[titleLabel setTag:102];
			[titleLabel setFont:[UIFont systemFontOfSize:14]];
			[titleLabel setText:[infoDict objectForKey:@"address"]];
			[titleLabel setTextColor:[UIColor whiteColor]];
			[titleLabel setBackgroundColor:[UIColor clearColor]];
			[cell.contentView addSubview:titleLabel];
			[titleLabel release];		
		}
		else 
		{
			[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
			// for  title
			UILabel *titleLabel = [[UILabel alloc] init];		
			[titleLabel setTag:101];
			[titleLabel setFrame:CGRectMake(10,5,60,30)];
			[titleLabel setTextAlignment:UITextAlignmentRight];
			[titleLabel setFont:[UIFont systemFontOfSize:14]];
			[titleLabel setText:@"Phone:"];			
			[titleLabel setTextColor:[UIColor grayColor]];
			[titleLabel setBackgroundColor:[UIColor clearColor]];
			[cell.contentView addSubview:titleLabel];
			[titleLabel release];
			
			// for  phone number
			titleLabel = [[UILabel alloc] init];		
			[titleLabel setTag:103];			
			[titleLabel setFrame:CGRectMake(80,5,150,30)];
			[titleLabel setTextAlignment:UITextAlignmentLeft];
			[titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
			[titleLabel setText:[infoDict objectForKey:@"phone"]];			
			[titleLabel setTextColor:[UIColor orangeColor]];
			[titleLabel setBackgroundColor:[UIColor clearColor]];
			[cell.contentView addSubview:titleLabel];
			[titleLabel release];				
		}
	}
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

#pragma mark -

#pragma mark Make a Call 
- (void) makeACall
{
	NSMutableString *phnoStr = [[NSMutableString alloc] initWithString:[[infoDict objectForKey:@"phone"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"]]];
	[phnoStr replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[phnoStr length])];
	[phnoStr replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[phnoStr length])];
	[phnoStr replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[phnoStr length])];
	[phnoStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,[phnoStr length])];
	NSURL *toCallString = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phnoStr]];
	if(![[UIApplication sharedApplication]canOpenURL:toCallString])
	{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Call Feature is not available in this device" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
			[alert release];
	} else {
		// if iOS 3.1 or less, show alert to call or cancel, then app loadurl
		
		UIWebView *w = [[UIWebView alloc] init];
		[w setHidden:YES];
  		NSURLRequest *req = [NSURLRequest requestWithURL:toCallString];
		[w loadRequest:req];
		[self.view addSubview:w];
		[w release];
	}	
	[phnoStr release];
}

#pragma mark -
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
- (void) getInfo
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[activityIndicator startAnimating];
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/getInfo.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
    [req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"] forKey:@"myid"]; 
	[req setPostValue:userID forKey:@"uid"];
	[req setDelegate:self];
	[req startAsynchronous];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"response - %@",[request responseString]);
	infoDict = [[NSDictionary alloc] initWithDictionary:[[request responseString] JSONValue]];
	//[myTable setHidden:NO];
	[self loadTable];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activityIndicator stopAnimating];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activityIndicator stopAnimating];
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
