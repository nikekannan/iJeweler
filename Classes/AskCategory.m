    //
//  AskCategory.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 3/27/11.
//  Copyright 2011 no. All rights reserved.
//

#import "AskCategory.h"
#import "Constants.h"

@implementation AskCategory

@synthesize isMultipleSelectionEnabled;
//extern int category;

- (void)viewDidLoad {
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicator setCenter:CGPointMake(160, 320)];
	[self.view addSubview:activityIndicator];
	
	[self setIsMultipleSelectionEnabled:YES];    
	[self.navigationItem setTitle:@"Select Categories"];
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/categories.php?myid=%@",URL,[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"]]];
    NSString *response =[self stringWithUrl:url];
    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[response JSONValue]];
    
	categoryArray = [[NSMutableArray alloc] initWithArray:[[dict objectForKey:@"categories_list"] valueForKey:@"category"]];
	idArray = [[NSMutableArray alloc] initWithArray:[[dict objectForKey:@"categories_list"] valueForKey:@"id"]];
    NSArray *temp = [[NSArray alloc] initWithArray:[dict objectForKey:@"my_categories"]];
    
	selectedItemDict = [[NSMutableDictionary alloc] init ];
    for(int i=0 ; i<[temp count]; i++)
    {
        [selectedItemDict setObject:@"YES" forKey:[temp objectAtIndex:i]];
    }
    [dict release];
    [temp release];
    [url release];
    [self loadTable];
    
	category = -1;
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

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


- (void) loadTable
{
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,366) style:UITableViewStylePlain];
	[myTable setDelegate:self];
	[myTable setDataSource:self];
	[myTable setBackgroundColor:[UIColor clearColor]];
	[myTable setSeparatorColor:[UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0]];
	[self.view addSubview:myTable];
	[myTable release];	
	
	UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[saveButton setFrame:CGRectMake(10,380, 300, 25)];
	[saveButton setTitle:@"Save Categories" forState:UIControlStateNormal];
	[saveButton addTarget:self action:@selector(saveCategories) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:saveButton];
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
		
		UIImageView *checkbox = [[UIImageView alloc] initWithFrame:CGRectMake(290, 12,16, 16)];
		[checkbox setTag:102];
		[checkbox setImage:[UIImage imageNamed:@"checkbox.png"]];
		[cell addSubview:checkbox];
		[checkbox release];		
	}
	UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
	[titleLabel setText:[categoryArray	objectAtIndex:indexPath.row]];
	
	UIImageView *checkbox = (UIImageView*)[cell viewWithTag:102];
	[checkbox setImage:[UIImage imageNamed:@"checkbox.png"]];
	
	if(isMultipleSelectionEnabled)
	{
		if([[selectedItemDict objectForKey:[idArray objectAtIndex:indexPath.row]] isEqualToString:@"YES"])
		{
			[checkbox setImage:[UIImage imageNamed:@"checked.png"]];
		}
	}
	else 
	{
		if(indexPath.row == category)
		{
			[checkbox setImage:[UIImage imageNamed:@"checked.png"]];
		}		
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
	
	if(isMultipleSelectionEnabled)
	{
		if([[selectedItemDict objectForKey:[idArray objectAtIndex:indexPath.row]] isEqualToString:@"YES"])
		{
			[selectedItemDict removeObjectForKey:[idArray objectAtIndex:indexPath.row]];
		}
		else 
		{
			[selectedItemDict setObject:@"YES" forKey:[idArray objectAtIndex:indexPath.row]];
		}
	}
	else 
	{
		NSLog(@"%@ - %@", [categoryArray objectAtIndex:indexPath.row], [idArray objectAtIndex:indexPath.row]);
		category = [[idArray objectAtIndex:indexPath.row] intValue];
	}
	[self performSelector:@selector(reloadTableView) withObject:nil afterDelay:0.3];
//	[self dismissModalViewControllerAnimated:YES];	
}

- (void) reloadTableView
{
	[myTable reloadData];
}
#pragma mark -

#pragma mark ASI support 
- (void) saveCategories
{
	NSLog(@"saved categories = %@",selectedItemDict);
		
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/saveCategories.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:[[selectedItemDict allKeys] JSONRepresentation] forKey:@"categories_id"]; // array of category id's as string.
	[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"] forKey:@"uid"];  // from is myid
	[req start];
	
	NSLog(@"response = %@",[req  responseString]);
	
    if([[req responseString] isEqualToString:@"SUCCESS"])
    {
        UIAlertView *alert = [[UIAlertView  alloc] initWithTitle:@"Categories saved" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else 
    {
        UIAlertView *alert = [[UIAlertView  alloc] initWithTitle:@"Network busy, try again" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
	[url release];
	[req release];
	
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
	[categoryArray release];
    [idArray release];
	[selectedItemDict release];
    [super dealloc];
}


@end
