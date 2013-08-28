    //
//  MetalPricesVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 3/27/11.
//  Copyright 2011 no. All rights reserved.
//

#import "MetalPricesVC.h"
#import "Constants.h"

@implementation MetalPricesVC
@synthesize index;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{	
	isGoBack = NO;
	// background image

//	int totalwidth = [UIScreen mainScreen].applicationFrame.size.width;
//	int totalheight = [UIScreen mainScreen].applicationFrame.size.height;	
	
	myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,416)];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [myWebView setFrame:CGRectMake(0,0,320,416 + 88)];
    }
// 	[myWebView setBackgroundColor:[UIColor colorWithPatternImage:backImg]];
	[myWebView setOpaque:YES];
	[myWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[myWebView setDelegate:self];
 	[myWebView setDataDetectorTypes:UIDataDetectorTypeAll];
// 	[myWebView setScalesPageToFit:YES];
	[myWebView setUserInteractionEnabled:YES];
	
	NSString *filePath = nil;
	NSURL *localFileUrl = nil;
	filePath = [NSString stringWithString:[[NSBundle mainBundle] pathForResource:self.title ofType:@"html"]];
	localFileUrl = [NSURL fileURLWithPath:filePath];
	[myWebView loadRequest:[NSURLRequest requestWithURL:localFileUrl]];
	
	[self prepareToolBar];
	[self.view addSubview:myWebView];
	[myWebView release];
    [super viewDidLoad];
}


#pragma mark UIWebViewDelegate methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	//[myWebView setDataDetectorTypes:UIDataDetectorTypeAll];
	return YES;	
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
 	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[myWebView setHidden:YES];	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
 	//[self performSelector:@selector(unHideWebView) withObject:nil afterDelay:1];
 	[myWebView setHidden:NO];
  	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


- (void) unHideWebView 
{
	if([myWebView isLoading])
	{
 		[myWebView setHidden:YES];
	} 
	else
	{
 		[myWebView setHidden:NO];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}	
}

- (void) prepareToolBar
{
//	int totalwidth = [UIScreen mainScreen].applicationFrame.size.width;
//	int totalheight = [UIScreen mainScreen].applicationFrame.size.height;
	
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,372,320,44)];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [toolbar setFrame:CGRectMake(0,372 + 88,320,44)];
    }

//	[toolbar setBarStyle:UIBarStyleBlackOpaque];
    [toolbar setTintColor:[UIColor colorWithRed:41.0/255.0 green:32.0/255.0 blue:23.0/255.0 alpha:1.0]];
	
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBackward)];
	UIBarButtonItem *forward = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goForward)]; 
	UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(doReferesh)];
	UIBarButtonItem *stop = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(doStop)];
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];	
	
	[toolbar setItems:[NSArray arrayWithObjects:flexSpace,back,flexSpace,forward,flexSpace,refresh,flexSpace,stop,flexSpace,nil]];
 	
	[self.view addSubview:toolbar];
	[toolbar release];
	[back release];
	[forward release];
	[refresh release];
    [stop release];
	[flexSpace release];	
}


#pragma mark Functional methods
- (void)goBackward 
{
 	if([myWebView canGoBack]) 
	{	
 		[myWebView goBack];
		[myWebView setHidden:YES];
		isGoBack = YES;			
	}
	//	else 
	//	{
	//		[self.navigationController popViewControllerAnimated:YES];	
	//	}	
}

- (void)goForward 
{
	[myWebView goForward];
}

- (void) doReferesh 
{
	[myWebView setHidden:YES];
	[myWebView reload];
}

- (void) doStop
{
    [myWebView stopLoading];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
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


- (void)dealloc {
    [super dealloc];
}


@end
