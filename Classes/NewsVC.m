    //
//  NewsVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 9/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewsVC.h"
#import "WebViewVC.h"
#import "Constants.h"
@implementation NewsVC

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
	[self setTitle:@"News"];
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(0,00,320,380) style:UITableViewStyleGrouped];
	[myTable setDelegate:self];
	[myTable setDataSource:self];
	[myTable setBackgroundColor:[UIColor clearColor]];
	[myTable setSeparatorColor:[UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0]];
	[myTable setScrollEnabled:NO];
	[self.view addSubview:myTable];
	[myTable release];	
	[super viewDidLoad];
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
		return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	// Supplier version contains 4 items
	if(VERSION == 2)
	{
		if(indexPath.section ==0)
		{
			WebViewVC *o = [[WebViewVC alloc] init];
			[o setTitle:@"Details"];
			[o setUrl:[NSURL URLWithString:@"http://jewelrynewsnetwork.blogspot.com/2011/08/consumer-confidence-deteriorates-in.html"]];
			[self.navigationController pushViewController:o animated:YES];
			[o release];
		}
		else if(indexPath.section == 1)
		{
			WebViewVC *o = [[WebViewVC alloc] init];
			[o setTitle:@"Details"];
			[o setUrl:[NSURL URLWithString:@"http://jewelrynewsnetwork.blogspot.com/2011/08/lorraine-schwartz-designed-kardashians.html"]];
			[self.navigationController pushViewController:o animated:YES];
			[o release];		
		}
		else if(indexPath.section == 2)
		{
			WebViewVC *o = [[WebViewVC alloc] init];
			[o setTitle:@"Details"];
			[o setUrl:[NSURL URLWithString:@"http://jewelrynewsnetwork.blogspot.com/2011/08/lj-international-revenue-up-26-profit.html"]];
			[self.navigationController pushViewController:o animated:YES];
			[o release];		
		}
		else if(indexPath.section == 3)
		{
			WebViewVC *o = [[WebViewVC alloc] init];
			[o setTitle:@"Details"];
			[o setUrl:[NSURL URLWithString:@"http://jewelrynewsnetwork.blogspot.com/2011/08/tiffany-still-riding-high-reports.html"]];
			[self.navigationController pushViewController:o animated:YES];
			[o release];		
		}		
	}
	else 
	{
		if(indexPath.section ==0)
		{
			WebViewVC *o = [[WebViewVC alloc] init];
			[o setTitle:@"Details"];
			[o setUrl:[NSURL URLWithString:@"http://www.jckonline.com/"]];
			[self.navigationController pushViewController:o animated:YES];
			[o release];	
		}
		else if(indexPath.section == 1)
		{
			WebViewVC *o = [[WebViewVC alloc] init];
			[o setTitle:@"Details"];
			[o setUrl:[NSURL URLWithString:@"http://www.jckonline.com/2011/09/06/zale-to-close-25-stores-2012"]];
			[self.navigationController pushViewController:o animated:YES];
			[o release];		
		}
		else if(indexPath.section == 2)
		{
			WebViewVC *o = [[WebViewVC alloc] init];
			[o setTitle:@"Details"];
			[o setUrl:[NSURL URLWithString:@"http://www.jckonline.com/2011/09/06/more-consumers-influenced-online-reviews"]];
			[self.navigationController pushViewController:o animated:YES];
			[o release];		
		}
		else if(indexPath.section == 3)
		{
			WebViewVC *o = [[WebViewVC alloc] init];
			[o setTitle:@"Details"];
			[o setUrl:[NSURL URLWithString:@"http://www.jckonline.com/2011/09/06/fashion-s-night-out-manhattan-five-jewelry-store-events-you-should-attend"]];
			[self.navigationController pushViewController:o animated:YES];
			[o release];		
		}			
	}
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0;
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
		[titleLabel setFrame:CGRectMake(20,7,280,65)];
		[titleLabel setNumberOfLines:2];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextAlignment:UITextAlignmentCenter];
		[cell addSubview:titleLabel];
		[titleLabel release];
	}
	UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
	[titleLabel setFrame:CGRectMake(10,5,300,50)];
	if(VERSION ==2)
	{
		if(indexPath.section == 0)
		{
			[titleLabel setText:@"Consumer Confidence ‘Deteriorates’ in August"];
		}
		else if (indexPath.section == 1)
		{			
			[titleLabel setText:@"Kim Kardashian’s Wedding Band"];
		}
		else if (indexPath.section == 2)
		{			
			[titleLabel setText:@"LJ International Revenue Up 26%, Profit Up 59%"];
		}	
		else if (indexPath.section == 3)
		{			
			[titleLabel setText:@"Tiffany Still Riding High, Reports Strong Growth"];
		}			
	}
	else 
	{
		if(indexPath.section == 0)
		{
			[titleLabel setText:@"Industry and trade news/events coming soon"];
		}
		else if (indexPath.section == 1)
		{			
			[titleLabel setText:@"Zale to Close 25 Stores in 2012"];
		}
		else if (indexPath.section == 2)
		{			
			[titleLabel setText:@"More Consumers Influenced by Online Reviews"];
		}	
		else if (indexPath.section == 3)
		{			
			[titleLabel setText:@"Fashion's Night at Manhattan"];
		}			
	}
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 4;
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
