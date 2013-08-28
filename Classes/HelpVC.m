    //
//  HelpVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelpVC.h"


@implementation HelpVC
@synthesize url;
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
	wv = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,320,410)];
	[wv loadRequest:[NSURLRequest requestWithURL:url]];
	[wv setDelegate:self];
	[wv setScalesPageToFit:YES];
	[self.view addSubview:wv];
	[wv release];
    [super viewDidLoad];
}

- (void) viewWillDisappear:(BOOL)animated
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[super viewWillDisappear:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
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
	[url release];
    [super dealloc];
}


@end
