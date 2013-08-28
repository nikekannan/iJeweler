    //
//  AttachmentVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 15/02/11.
//  Copyright 2011 Deemag Infotech Pvt Ltd. All rights reserved.
//

#import "AttachmentVC.h"
#import "Constants.h"

@implementation AttachmentVC
@synthesize attachmentArr;
@synthesize qid;
@synthesize isBannerAnimating;

- (void)dealloc 
{
	[activityIndicator release];
	[attachmentArr release];
	[qid release];
    [banner release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    isBannerAnimating = YES;
    loadFirstBanner = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
    [self performSelector:@selector(animateBanner) withObject:nil afterDelay:ANIMATE_BANNER_AFTER_DELAY];
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

	[self prepareScrollView];
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
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

    [self prepareInfoView];

    [super viewDidLoad];
}

- (void) prepareScrollView
{
	pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320, 350)];
	[pageScrollView setPagingEnabled:YES];
	[pageScrollView setBackgroundColor:[UIColor clearColor]];
	[pageScrollView setShowsHorizontalScrollIndicator:YES];
	for(int i = 0 ; i < [attachmentArr count] ; i++)
	{
		UIWebView *w = [[UIWebView alloc] initWithFrame:CGRectMake((i*320), 0, 320, 350)];
		[w setDelegate:self];
		NSMutableString *htmlString = [[NSMutableString alloc] initWithString:@"<html><body>"];
		[htmlString appendString:@"<BR><BR><BR><center>"];
		[htmlString appendFormat:@"<img src = \"%@/images/%@/%@\"",URL,qid,[attachmentArr objectAtIndex:i]];
		[htmlString appendString:@"</center><BR><BR><BR>"];
		[htmlString appendString:@"</body></html>"];
		[w loadHTMLString:htmlString baseURL:nil];
		[pageScrollView addSubview:w];
		[w release];
		[htmlString release];
	}
	[pageScrollView setContentSize:CGSizeMake(640, 350)];
	[pageScrollView setScrollEnabled:YES];
	[self.view addSubview:pageScrollView];
	[pageScrollView release];
}
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[activityIndicator stopAnimating];
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
        [pageScrollView setUserInteractionEnabled:YES];
        [infoView setAlpha:0.0];
    }
    else
    {
        isInfoVisible = YES;
        [pageScrollView setUserInteractionEnabled:NO];
        [infoView setAlpha:1.0];        
    }
    [UIView commitAnimations];  
}
#pragma mark -


- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
