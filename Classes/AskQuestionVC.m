    //
//  AskQuestionVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 2/1/11.
//  Copyright 2011 no. All rights reserved.
//

#import "AskQuestionVC.h"
#import "Constants.h"


@implementation AskQuestionVC
@synthesize questionStr;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	category = -1;
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
    
    if(VERSION == 2)
    {
        [questionTextView becomeFirstResponder];
    }
    else 
    {
        [questionTextView setReturnKeyType:UIReturnKeyDefault];

        UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self  action:@selector(sendButtonClicked)];
        [self.navigationItem setRightBarButtonItem:send];
        [send release];
        
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10,200,300,25)];
        [l setText:@"Choose a category of your question"];
        [l setBackgroundColor:[UIColor clearColor]];
        [l setTextColor:[UIColor whiteColor]];
        [l setTextAlignment:UITextAlignmentCenter];
        [l setFont:[UIFont boldSystemFontOfSize:16]];
        [self.view addSubview:l];
        [l release];
        
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/categories.php?myid=%@",URL,[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"]]];
        NSString *response =[self stringWithUrl:url];
        NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[response JSONValue]];
        
        categoryArray = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"categories_list"]];
        [dict release];
        [url release];
        
        [self loadTable];
    }

		
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

- (void) loadTable
{
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(10,230,300,159) style:UITableViewStylePlain];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [myTable setFrame:CGRectMake(10,230,300,239)];
    }
	[myTable setDelegate:self];
	[myTable setDataSource:self];
    myTable.layer.cornerRadius = 7;
	[myTable setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
	[myTable setSeparatorColor:[UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0]];
	[self.view addSubview:myTable];
	[myTable release];	
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [categoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"cellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil)
	{
		cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		
		UIView *v = [[UIView alloc] initWithFrame:CGRectZero];	
        v.backgroundColor = [UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0];	
        cell.selectedBackgroundView = v;
		[v release];
		
		// for  title
		UILabel *titleLabel = [[UILabel alloc] init];		
		[titleLabel setTag:101];
		[titleLabel setFrame:CGRectMake(10,5,300,30)];
		[titleLabel setNumberOfLines:2];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextAlignment:UITextAlignmentLeft];
		[cell addSubview:titleLabel];
		[titleLabel release];
		
		UIImageView *checkbox = [[UIImageView alloc] initWithFrame:CGRectMake(270, 12,16, 16)];
		[checkbox setTag:102];
		[checkbox setImage:[UIImage imageNamed:@"checkbox.png"]];
		[cell addSubview:checkbox];
		[checkbox release];		
	}
	UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
	[titleLabel setText:[[categoryArray objectAtIndex:indexPath.row] objectForKey:@"category"]];
	
	UIImageView *checkbox = (UIImageView*)[cell viewWithTag:102];
	[checkbox setImage:[UIImage imageNamed:@"checkbox.png"]];
	
	if(indexPath.row == category)
	{
        [checkbox setImage:[UIImage imageNamed:@"checked.png"]];
	}
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	category = indexPath.row;
	[self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.3];
}

- (void) reloadTableView
{
	[myTable reloadData];
}
#pragma mark -

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
        if(VERSION == 2)
        {
            [self loadZipView];
        }
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

- (void) sendButtonClicked
{	
    if(category >= 0 && [[questionTextView text] length] > 0)
    {
        [self loadZipView];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Type your question and choose its corresponding category" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert setTag:-1];
        [alert show];
        [alert release];
    }
}

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
	
	MyJewelerAppDelegate *appDelegate = (MyJewelerAppDelegate*) [[UIApplication sharedApplication] delegate];
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/newQuestion.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:[numberTxt text] forKey:@"limit"];
	[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"] forKey:@"fromid"];  // from is myid
	[req setPostValue:[appDelegate getDate:3] forKey:@"date_time"];
	[req setPostValue:@"0" forKey:@"type"];
	[req setPostValue:[NSString stringWithFormat:@"%d",VERSION] forKey:@"version"];
	[req setPostValue:[questionTextView text] forKey:@"msg"];
	[req setPostValue:[NSString stringWithFormat:@"%f",mylat]	forKey:@"mylat"];
	[req setPostValue:[NSString stringWithFormat:@"%f",mylng]	forKey:@"mylng"];
	
	if(VERSION == 0 || VERSION == 1)
	{
		[req setPostValue:[[categoryArray objectAtIndex:category] objectForKey:@"id"] forKey:@"category_id"];
	}

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
		[self performSelector:@selector(saveQuestion:) withObject:[request responseString] afterDelay:0.3];
		UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"Your question sent successfully" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show]; [alert setTag:101];
		[alert release];
	}
	else if([[request responseString] isEqualToString:@"FAILED"])
	{ 
		NSString *alertMsg = nil;
		if(VERSION == 0)			alertMsg = @"No Suppliers available near by you, try again later";
		else if(VERSION == 1)			alertMsg = @"No Suppliers available near by you, try again later";
		else if(VERSION == 2)			alertMsg = @"No Jewelers available near by you, try again later";
		UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:alertMsg message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
