    //
//  JewelersVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JewelersVC.h"
#import "WebViewVC.h"
#import "ProductCategoriesVC.h"
#import "Constants.h"

@implementation JewelersVC

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
- (void) viewWillAppear:(BOOL)animated	
{
//	if(VERSION != 2)
//	{
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comming Soon !!" message:@"List of Retail Suppliers with Mobile stores in iJeweler" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Jeweler Profit", @"InstaPayplan", @"Jewel Systems",@"Cancel",nil];
//		[alert show];
//		[alert setTag:101];
//		[alert release];				
//	}
}
- (void)viewDidLoad 
{
    if(VERSION == 2)
    {
        [self setTitle:@"Jewelers"];
    }
    else
    {
        [self setTitle:@"Suppliers"];
    }
	[self loadTable];
    [self loadData];
//	if(VERSION == 2)
//	{
//		[self.navigationItem setTitle:@"Jewelers"];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Comming Soon !!" message:@"List of Retail Jewelers with Mobile stores in iJeweler" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//		[alert show];
//		[alert setTag:100];
//		[alert release];
//	}
//	else 
//	{
//		[self.navigationItem setTitle:@"Suppliers"];
//	}
	[super viewDidLoad];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if([alertView tag] == 100)
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
	else 
	{
		if(buttonIndex == 0)
		{
			WebViewVC *o = [[WebViewVC alloc] init];
			[o setTitle:@"Jeweler Profit"];
			[o setUrl:[NSURL URLWithString:@"http://www.jewelerprofit.com/Home.html"]];
			[self.navigationController pushViewController:o animated:YES];
			[o release];
		}
		else if(buttonIndex == 1)
		{
			WebViewVC *o = [[WebViewVC alloc] init];
			[o setTitle:@"InstaPayPlan"];
			[o setUrl:[NSURL URLWithString:@"https://www.instapayplan.com/default.aspx"]];
			[self.navigationController pushViewController:o animated:YES];
			[o release];
		}
		else if(buttonIndex == 2)
		{
			WebViewVC *o = [[WebViewVC alloc] init];
			[o setTitle:@"Jewel Systems"];
			[o setUrl:[NSURL URLWithString:@"http://www.jwls.com/"]];
			[self.navigationController pushViewController:o animated:YES];
			[o release];
		}
		else 
		{
			[self.navigationController popViewControllerAnimated:YES];
		}
	}
}

- (void) loadTable
{
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,410) style:UITableViewStyleGrouped];
	if(VERSION == 0)
	{
		[myTable setFrame:CGRectMake(0,15,320,320)];
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
	return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductCategoriesVC *obj = [[ProductCategoriesVC alloc] init];
    [obj setOwnerID:[[ownersArray objectAtIndex:[indexPath row]] objectForKey:@"owner_id"]];
    [self.navigationController pushViewController:obj animated:YES];
    [obj release];
	/*
     if(VERSION == 0)
     {
     // Supplier version contains 4 items
     if(indexPath.section ==0)
     {
     [self performSelector:@selector(loadAskaCategoryVC) withObject:nil afterDelay:0.3];
     }
     else if(indexPath.section == 1)
     {
     [self performSelector:@selector(loadAskaQuestionVC) withObject:nil afterDelay:0.3];
     }
     else if(indexPath.section == 2)
     {
     [self performSelector:@selector(loadQuestionsVC) withObject:nil afterDelay:0.3];
     }
     else if(indexPath.section == 3)
     {
     [self performSelector:@selector(loadPersonalAssistantVC) withObject:nil afterDelay:0.3];
     }		
     }
     else 
     {
     // Jeweler & Consumer version contains 3 items
     if(indexPath.section ==0)
     {
     [self performSelector:@selector(loadAskaQuestionVC) withObject:nil afterDelay:0.3];
     }
     else if(indexPath.section == 1)
     {
     [self performSelector:@selector(loadQuestionsVC) withObject:nil afterDelay:0.3];
     }
     else if(indexPath.section == 2)
     {
     if(VERSION == 1) [self performSelector:@selector(loadPersonalAssistantVC) withObject:nil afterDelay:0.3];
     else [self performSelector:@selector(loadPersonalShoppingAssistantVC) withObject:nil afterDelay:0.3];
     }			
     }
	 */
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [ownersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"cellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil)
	{
		cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
 		[cell setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];

		UIView *v = [[UIView alloc] initWithFrame:CGRectZero];	
        v.backgroundColor = [UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0];	
		v.layer.cornerRadius = 7;
        cell.selectedBackgroundView = v;
		[v release];
		
		// for  title
		UILabel *titleLabel = [[UILabel alloc] init];		
		[titleLabel setTag:101];
		[titleLabel setFrame:CGRectMake(10,5,250,50)];
		[titleLabel setNumberOfLines:2];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextAlignment:UITextAlignmentLeft];
		[cell.contentView addSubview:titleLabel];
		[titleLabel release];
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, (60-12)/2, 14, 12)];
		[arrow setImage:[UIImage imageNamed:@"cell_arrow.png"]];
        [arrow setTag:104];
		[cell.contentView addSubview:arrow];
		[arrow release];		

	}
	UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
    [titleLabel setText:[[ownersArray objectAtIndex:[indexPath row]] objectForKey:@"name"]];
	return cell;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark -
#pragma mark Load oweners
- (void) loadData
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/owners.php",URL]];
    ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
    [req setPostValue:[NSString stringWithFormat:@"%d",VERSION] forKey:@"type"];
    [req setDelegate:self];
    [req startAsynchronous];
    [req release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    if([ownersArray count] > 0)
    {
        [ownersArray removeAllObjects];
        [ownersArray release];
        ownersArray = nil;
    }
    
    ownersArray = [[NSMutableArray alloc] initWithArray:[[request responseString] JSONValue]];
    
    if([ownersArray count] > 0)
    {
        [myTable reloadData];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

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
    [super dealloc];
}


@end
