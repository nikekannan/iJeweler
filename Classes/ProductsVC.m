//
//  ProductsVC.m
//  MyJeweler
//
//  Created by Nik on 28/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductsVC.h"
#import "ProductDetailsVC.h"
#import "Constants.h"

@implementation ProductsVC
@synthesize productsArray;


- (void)dealloc
{
    [productsArray release];
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
    [self loadTable];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:back];
    [back release];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Load products
- (void) loadTable
{
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,410) style:UITableViewStyleGrouped];
	[myTable setDelegate:self];
	[myTable setDataSource:self];
	[myTable setBackgroundColor:[UIColor clearColor]];
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
    return [productsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60.0;
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
		[titleLabel setFrame:CGRectMake(10,5,265,50)];
		[titleLabel setNumberOfLines:3];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
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
    [titleLabel setText:[[productsArray objectAtIndex:[indexPath row]] objectForKey:@"name"]];
	return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductDetailsVC *obj = [[ProductDetailsVC alloc] init];
    [obj setInfoDict:[productsArray objectAtIndex:[indexPath row]]];
    [self.navigationController pushViewController:obj animated:YES];
    [obj release];    
}

@end
