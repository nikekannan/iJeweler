    //
//  EducationVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EducationVC.h"
#import "Constants.h"

@implementation EducationVC

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

- (void) viewWillDisappear:(BOOL)animated
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[super viewWillDisappear:YES];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	//http://www.gia.edu/resources/flash/4cs/GIA.swf
	
	UIWebView *wv = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,410)];
	if(VERSION	== 2)
	{
		[wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.youtube.com/watch?v=oqhaty0ny0g"]]];
	}
	else 
	{
		[wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://link.brightcove.com/services/player/bcpid50177546001?bctid=608239568001"]]];
	}

	[wv setScalesPageToFit:YES];
	[wv setDelegate:self];
	[self.view addSubview:wv];
	[wv release];
	
    [super viewDidLoad];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return YES;
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


- (void)dealloc {
    [super dealloc];
}


@end
