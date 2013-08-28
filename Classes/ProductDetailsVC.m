//
//  ProductDetailsVC.m
//  MyJeweler
//
//  Created by Nik on 28/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailsVC.h"
#import "Constants.h"

@implementation ProductDetailsVC
@synthesize  infoDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [infoDict release];
    [detailsDict release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    showDetails = NO;
	infoButton = [[UIBarButtonItem alloc] initWithTitle:@"Details" style:UIBarButtonItemStyleDone target:self action:@selector(detailsView)];
	[self.navigationItem setRightBarButtonItem:infoButton];
    [infoButton release];
    [self prepareForm];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) setNavigationTitleView:(NSString*) titleStr 
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50,0,190,40)];
	[view setUserInteractionEnabled:YES];
	[view setBackgroundColor:[UIColor clearColor]];
	NSLog(@"len - %d",[titleStr length]);
	UILabel *nameLabel = [[UILabel alloc] init];
	[nameLabel setFrame:CGRectMake(0, 0, 190, 40)];
	[nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setNumberOfLines:3];
	[nameLabel setTextColor:[UIColor whiteColor]];
    if([titleStr length] > 44)
    {
        [nameLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [nameLabel setNumberOfLines:3];
    }
    else
    {
        [nameLabel setFont:[UIFont boldSystemFontOfSize:14]];
    }
	[nameLabel setText:titleStr];
	[nameLabel setTextAlignment:UITextAlignmentCenter];
	[view addSubview:nameLabel];
	[nameLabel release];
	self.navigationItem.titleView = view;
	[view release];	
}


- (void) prepareForm
{
    [self setNavigationTitleView:[infoDict objectForKey:@"name"]];
    [code setText:[infoDict objectForKey:@"code"]];
    [price setText:[NSString stringWithFormat:@"$%@",[infoDict objectForKey:@"price"]]];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[infoDict objectForKey:@"image"]]]];
    
    detailsDict = [[NSDictionary alloc] initWithDictionary:[infoDict objectForKey:@"details"]];
    [self loadTable];
}

- (void) detailsView
{
    if(showDetails)
    {
        showDetails = NO;
        [myTable setUserInteractionEnabled:NO];
        [myTable setHidden:YES];
        [infoButton setTitle:@"Details"];
    }
    else
    {
        showDetails = YES;
        [myTable setUserInteractionEnabled:YES];
        [myTable setHidden:NO];
        [infoButton setTitle:@"Cancel"];
    }
}
#pragma mark - View Life cycle
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) loadTable
{
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,420) style:UITableViewStyleGrouped];
	[myTable setDelegate:self];
	[myTable setDataSource:self];
    [myTable setHidden:YES];
    [myTable setUserInteractionEnabled:NO];
    [myTable.layer setCornerRadius:7.0];
	[myTable setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]]];
	[myTable setSeparatorColor:[UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0]];
	[self.view addSubview:myTable];
	[myTable release];	
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[detailsDict allKeys] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        
		UIView *v = [[UIView alloc] initWithFrame:CGRectZero];	
        v.backgroundColor = [UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0];	
		v.layer.cornerRadius = 7;
        cell.selectedBackgroundView = v;
		[v release];
		
		// for  title
		UILabel *titleLabel = [[UILabel alloc] init];		
		[titleLabel setTag:101];
		[titleLabel setFrame:CGRectMake(10,5,180,35)];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [titleLabel setNumberOfLines:2];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextAlignment:UITextAlignmentLeft];
		[cell.contentView addSubview:titleLabel];
		[titleLabel release];
        
        titleLabel = [[UILabel alloc] init];		
		[titleLabel setTag:102];
		[titleLabel setFrame:CGRectMake(180,5,110,35)];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
		[titleLabel setTextColor:[UIColor yellowColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextAlignment:UITextAlignmentRight];
		[cell.contentView addSubview:titleLabel];
		[titleLabel release];
    }
    
	UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
	UILabel *valueLabel = (UILabel*)[cell viewWithTag:102];
    
    [titleLabel setText:[[detailsDict allKeys] objectAtIndex:[indexPath row]]];
    [valueLabel setText:[detailsDict objectForKey:[[detailsDict allKeys] objectAtIndex:[indexPath row]]]];
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIWebVieWDelegate
- (void)webViewDidStartLoad:(UIWebView *)webview
{
    [webview setHidden:YES];
    [activity startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webview
{
    [webview setHidden:NO];
    [activity stopAnimating];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
