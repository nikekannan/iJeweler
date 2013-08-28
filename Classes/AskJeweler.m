//
//  AskJeweler.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 05/05/11.
//  Copyright 2011 Deemag Infotech Pvt Ltd. All rights reserved.
//

#import "AskJeweler.h"
#import "Constants.h"

@implementation AskJeweler
@synthesize questionStr;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[self.navigationItem setTitle:@"Ask a Question"];
	[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:41.0/255.0 green:32.0/255.0 blue:23.0/255.0 alpha:1.0]];
	[self.view setBackgroundColor:[UIColor clearColor]];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicator setCenter:CGPointMake(160, 320)];
	[self.view addSubview:activityIndicator];
    
	
	questionTextView = [[UITextView alloc] initWithFrame:CGRectMake(10,10,300, 180)];
	[questionTextView setDelegate:self];
	[questionTextView setTag:102];
	[questionTextView setScrollsToTop:YES];
	[questionTextView setEditable:YES];
    [questionTextView becomeFirstResponder];
	questionTextView.layer.cornerRadius =7;
	[questionTextView setText:questionStr];
	[questionTextView setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[questionTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
	[questionTextView setKeyboardType:UIKeyboardTypeDefault];
	[questionTextView setReturnKeyType:UIReturnKeySend];
	[questionTextView setFont:[UIFont systemFontOfSize:14]];
	[questionTextView setTextColor:[UIColor blackColor]];
	[self.view addSubview:questionTextView];
	[questionTextView release];
       
    [super viewDidLoad];
}

- (void) loadZipView
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter your zip" message:@"\n\nNo. of Jewelers to be questioned\n\n\n" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel",nil];
	
	zip = [[UITextField alloc] initWithFrame:CGRectMake(40,44,200,30)];
	[zip setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[zip becomeFirstResponder];
	[zip setPlaceholder:@"Zip"];	
	[zip setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"ZIP"]];	
	[zip setBorderStyle:UITextBorderStyleRoundedRect];
	[zip setFont:[UIFont systemFontOfSize:16]];
	[zip setTextAlignment:UITextAlignmentCenter];
	[zip setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[alert addSubview:zip];
	
	numberTxt = [[UITextField alloc] initWithFrame:CGRectMake(40,114,200,30)];
	[numberTxt setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[numberTxt setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	[numberTxt setPlaceholder:@"Maximum 10"];	
	[numberTxt setBorderStyle:UITextBorderStyleRoundedRect];
	[numberTxt setFont:[UIFont systemFontOfSize:14]];
	[numberTxt setTextAlignment:UITextAlignmentCenter];
	[numberTxt setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];	
	[alert addSubview:numberTxt];	
	
	[alert setTag:999];
	[alert show];
	[alert release];
	[zip release];
	[numberTxt release];
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
	isKeyBoardUp = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	isKeyBoardUp = NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
	if ( [ text isEqualToString: @"\n" ] ) {
		[textView resignFirstResponder];
		isKeyBoardUp = NO;
        [self loadZipView];
		return NO;
	}
	return YES;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if([alertView tag] == 999)
	{
		if(buttonIndex == 0 && ([[zip text] length] > 0) )
		{
			[[NSUserDefaults standardUserDefaults] setObject:[zip text] forKey:@"ZIP"];
			[[NSUserDefaults standardUserDefaults] synchronize];
			
			[self callToFindReverseGeoCoding];
		}
		else 
		{
			[questionTextView becomeFirstResponder];
		}
	}
	else if ([alertView tag] == 101)
	{
		[self performSelector:@selector(goBack) withObject:nil afterDelay:0.3];
	}
}

#pragma mark SQLITE ACCESS 
- (void) saveQuestion:(NSString*)qid
{
	NSMutableString *question = [[NSMutableString alloc] initWithString:[questionTextView text]];
	[question	replaceOccurrencesOfString:@"'" withString:@"_SQ_" options:1 range:NSMakeRange(0, [question length])];
	[question	replaceOccurrencesOfString:@"\"" withString:@"_DQ_" options:1 range:NSMakeRange(0, [question length])];
	
	MySQLite *o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	[o readDb:[NSString stringWithFormat:@"insert into questions values ( '%@', '%@', 0)",qid,question]];
	[o hasNextRow];
	[o closeDb];
	[o release];	
	[question release];	
}
#pragma mark  -

#pragma mark ASI SUPPORT 


- (void) callToFindReverseGeoCoding
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	//NSError *err;
	NSMutableString *address = [[NSMutableString alloc] initWithString:[zip text]];
	[address replaceOccurrencesOfString:@" " withString:@"%20" options:1 range:NSMakeRange(0, [address length])];
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",address]];
    NSString *geoOutput = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&err];
    NSDictionary *results = [geoOutput JSONValue];
    if([[results objectForKey:@"status"] isEqualToString:@"OK"])
    {
        NSArray *arr = [results objectForKey:@"results"];
		mylat = [[[[[arr objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"] floatValue];
		mylng = [[[[[arr objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"] floatValue];
		[self sendMessage];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter a valid Zip code" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		[alert setTag:-1];
		[alert release];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	}
	[address release];
}


- (void) sendMessage
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[activityIndicator startAnimating];
	
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/askJewelerOnly.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:[numberTxt text] forKey:@"limit"];
	[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"] forKey:@"fromid"];  // from is myid
	[req setPostValue:@"Server time" forKey:@"date_time"];
	[req setPostValue:@"0" forKey:@"type"];
	[req setPostValue:[NSString stringWithFormat:@"%d",VERSION] forKey:@"version"];
	[req setPostValue:[questionTextView text] forKey:@"msg"];
	[req setPostValue:[NSString stringWithFormat:@"%f",mylat]	forKey:@"mylat"];
	[req setPostValue:[NSString stringWithFormat:@"%f",mylng]	forKey:@"mylng"];
    
	[req setDelegate:self];
	[req startAsynchronous];
	NSError *error = [req error];
	if (!error) {
		//NSLog(@"response -%@",[req responseString]);
	}
	[req release];
	[url release];	
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activityIndicator stopAnimating];
	NSLog(@"\nnew question response - %@\n",[request responseString]);
	if ( [[request responseString] intValue] > 0)
	{
		UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"Your question sent successfully" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show]; [alert setTag:101];
		[alert release];
		[self performSelector:@selector(saveQuestion:) withObject:[request responseString] afterDelay:0.3];
	}
	else if([[request responseString] isEqualToString:@"FAILED"])
	{ 
		UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"No Jewelers available near by you, try again later" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show]; [alert setTag:-1];
		[alert release];		
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activityIndicator stopAnimating];
}
#pragma mark - 

#pragma mark Get categories
- (NSString *)stringWithUrl:(NSURL *)url
{
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
											timeoutInterval:30];
	// Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
									returningResponse:&response
												error:&error];
	
 	// Construct a String around the Data from the response
	return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

- (void) goBack
{
	[self.navigationController popViewControllerAnimated:YES];
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
	[questionStr release];
    [super dealloc];
}


@end
