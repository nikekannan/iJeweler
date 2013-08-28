    //
//  AddMoreEventsVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 5/1/11.
//  Copyright 2011 no. All rights reserved.
//

#import "AddMoreEventsVC.h"
#import "CustomDatePickerView.h"
#import "CustomPickerView.h"
#import "Constants.h"

#define	TITLE_FONT_SIZE 14

@implementation AddMoreEventsVC
@synthesize rowid;
@synthesize dateStr;
@synthesize isBannerAnimating;

static int selectedrow;

- (void)dealloc {
    [banner release];
	[dateStr release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated	
{
    isBannerAnimating = YES;
    loadFirstBanner = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
    [self performSelector:@selector(animateBanner) withObject:nil afterDelay:ANIMATE_BANNER_AFTER_DELAY];

	[self getOtherEventsList];
}

- (void) viewWillDisappear:(BOOL)animated  
{
    isBannerAnimating = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
    loadFirstBanner = YES;
    isInfoVisible = NO;

	selectedrow = -1;
	NSLog(@"rowid - %d",rowid);
	
	transitioning = YES;
	isUpdatePSA = NO;
	[self.navigationItem setTitle:@"Other events"];
	dateFormatter = [[NSDateFormatter alloc] init];
	eventsArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"Anniversary", @"Birthday",@"Wedding day",@"Christmas",@"Thanks giving",nil]];
	
	add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self	action:@selector(nextTransition)];
	[self.navigationItem setRightBarButtonItem:add];
	[add release];
	
	containerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,367)];
	[containerView setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:containerView];
    
    MyJewelerAppDelegate *appDelegate = (MyJewelerAppDelegate*)[[UIApplication sharedApplication] delegate];
    Banner *o = [appDelegate getAd];
    banner = [[BannerView alloc] init];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [banner setFrame:CGRectMake(0,448,320,60)];
    }
    else
    {
        [banner setFrame:CGRectMake(0,360,320,60)];
    }
    [banner setTag:[[o bannerID] intValue]];
    [banner setImage:[o bannerImage]];
    [banner setUid:[o bannerID]];
    [banner setWeblink:[o bannerURL]];
    [self.view addSubview:banner];

	
	[self loadForm];
	[self loadTable];
	[self loadEventPickerView];
	[self loadDatePickerView];
    
    [self prepareInfoView];

    [super viewDidLoad];
}

- (void) loadTable
{
	view1 = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,350)];
	[view1 setBackgroundColor:[UIColor clearColor]];
	[view1 setUserInteractionEnabled:YES];
	[view1 setHidden:NO];
	
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 350) style:UITableViewStylePlain];
	[myTable setDelegate:self];
	[myTable setDataSource:self];
	[myTable setBackgroundColor:[UIColor clearColor]];
	[myTable setSeparatorColor:[UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0]];
	[view1 addSubview:myTable];
	[containerView addSubview:view1];
	
	[view1 release];
}

- (void) loadForm
{
	view2 = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,350)];
	[view2 setBackgroundColor:[UIColor clearColor]];
	[view2 setUserInteractionEnabled:YES];
	[view2 setHidden:YES];

	UIColor *shadowColor = [UIColor blackColor];
	UIColor *txtColor = [UIColor lightGrayColor];

	int y = 15;
	int gap = 40;
	
	// Event name
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,y,250,15)];		
	[titleLabel setFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
	[titleLabel setText:@"Event Name"];
	[titleLabel setTextColor:txtColor];
	[titleLabel	setShadowColor:shadowColor];
	[titleLabel setShadowOffset:CGSizeMake(0,1)];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[view2 addSubview:titleLabel];
	[titleLabel release];
	
	y += 20;	
	
	eventTxtField = [[UITextField alloc] initWithFrame:CGRectMake(10,y,260, 30)];
	[eventTxtField setDelegate:self];
	[eventTxtField setTag:101];
	[eventTxtField setKeyboardAppearance:UIKeyboardAppearanceAlert];
 	[eventTxtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[eventTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[eventTxtField setBorderStyle:UITextBorderStyleRoundedRect];
 	[eventTxtField setKeyboardType:UIKeyboardTypeDefault];
	[eventTxtField setText:[infoArray objectAtIndex:2]];
	[eventTxtField setFont:[UIFont systemFontOfSize:16]];
	[eventTxtField setTextColor:[UIColor blackColor]];
	[view2 addSubview:eventTxtField];
	[eventTxtField release];				
	
	UIButton *eventListButton = [[UIButton alloc] initWithFrame:CGRectMake(280, y, 30, 30)];
	[eventListButton setTag:502];
	[eventListButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
	[eventListButton addTarget:self action:@selector(animatePickerView:) forControlEvents:UIControlEventTouchUpInside];
	[view2 addSubview:eventListButton];
	[eventListButton release];
	
	y += gap;
	
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,y,250,15)];		
	[titleLabel setFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
	[titleLabel setText:@"Date of Event"];
	[titleLabel setTextColor:txtColor];
	[titleLabel	setShadowColor:shadowColor];
	[titleLabel setShadowOffset:CGSizeMake(0,1)];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[view2 addSubview:titleLabel];
	[titleLabel release];
	
	y += 20;	
	
	dobTxtField = [[UITextField alloc] initWithFrame:CGRectMake(10,y,260, 30)];
	[dobTxtField setDelegate:self];
	[dobTxtField setTag:101];
	[dobTxtField setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[dobTxtField setPlaceholder:@"YYYY-MM-DD"];
	[dobTxtField setUserInteractionEnabled:NO];
 	[dobTxtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[dobTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[dobTxtField setBorderStyle:UITextBorderStyleRoundedRect];
//	[dobTxtField setText:[infoArray objectAtIndex:5]];
 	[dobTxtField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	[dobTxtField setFont:[UIFont systemFontOfSize:16]];
	[dobTxtField setTextColor:[UIColor blackColor]];
	[view2 addSubview:dobTxtField];
	[dobTxtField release];	
	
	UIButton *dobListButton = [[UIButton alloc] initWithFrame:CGRectMake(280, y, 30, 30)];
	[dobListButton setTag:503];
	[dobListButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
	[dobListButton addTarget:self action:@selector(animatePickerView:) forControlEvents:UIControlEventTouchUpInside];
	[view2 addSubview:dobListButton];
	[dobListButton release];
	
	y += gap+10;
	
	UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[saveButton setFrame:CGRectMake(25, y, 120, 25)];
	[saveButton setTitle:@"Save" forState:UIControlStateNormal];
	[saveButton addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[view2 addSubview:saveButton];

	UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[cancelButton setFrame:CGRectMake(160+15, y, 120, 25)];
	[cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	[view2 addSubview:cancelButton];
	
	
	[containerView addSubview:view2];
	[view2 release];	
}

- (void) loadEventPickerView
{
	eventPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,416,320,200)];
	[eventPickerView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
	
	UIToolbar *myToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	[myToolBar setTintColor:[UIColor colorWithRed:41.0/255.0 green:32.0/255.0 blue:23.0/255.0 alpha:1.0]];
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem	*done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(animatePickerView:)];
	[done setTag:502];
	[myToolBar setItems:[NSArray arrayWithObjects:flexSpace,done,nil]];
	[eventPickerView addSubview:myToolBar];
	[myToolBar release];
	[flexSpace release];
	[done release];
	
	CustomPickerView *o = [[CustomPickerView alloc] init];
	[o setTag:502];
	[o setDelegate:self];
	[o setShowsSelectionIndicator:YES];
	[eventPickerView addSubview:o];	
	[self.view addSubview:eventPickerView];
	[eventPickerView release];
	[o release];	
}

- (void) loadDatePickerView
{
	datePickerHolder = [[UIView alloc] initWithFrame:CGRectMake(0,416,320,200)];
	[datePickerHolder setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
	
	UIToolbar *myToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	[myToolBar setTintColor:[UIColor colorWithRed:41.0/255.0 green:32.0/255.0 blue:23.0/255.0 alpha:1.0]];
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem	*done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(animatePickerView:)];
	[done setTag:503];
	[myToolBar setItems:[NSArray arrayWithObjects:flexSpace,done,nil]];
	[datePickerHolder addSubview:myToolBar];
	[myToolBar release];
	[flexSpace release];
	[done release];
	
	CustomDatePickerView *o = [[CustomDatePickerView alloc] init];
	[datePickerHolder addSubview:o];
	[o setTag:503];
	[o setDate:[NSDate date] animated:YES];
	[o addTarget:self action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:datePickerHolder];
	[datePickerHolder release];
	[o release];
}

- (void) dateSelected:(id)sender
{
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	[self setDateStr:[dateFormatter stringFromDate:[sender date]]];
	[dateFormatter setDateFormat:@"MM-dd-yyyy"];
	[dobTxtField setText:[dateFormatter stringFromDate:[sender date]]];
}

- (void) saveButtonClicked
{
	if([[eventTxtField text] length] > 0 && [[dobTxtField text] length] > 0)
	{
		if(isUpdatePSA)
		{
			[self updateOtherEvent];
		}
		else 
		{
			[self addOtherEventToServer];
		}		
	}
}

- (void) cancelButtonClicked
{
	[eventTxtField setText:nil];
	[dobTxtField setText:nil];
	if(isUpdatePSA)
	{
		isUpdatePSA = NO;
	}
	[self nextTransition];
}

#pragma mark Animate view
- (void) editEvent
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
	transitioning = NO;
	[view1 setHidden:YES];
	[view2 setHidden:NO];
	[add setEnabled:NO];
	[eventTxtField setText:nil];
	[dobTxtField setText:nil];
	[self.navigationItem setTitle:@"Edit Event"];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:containerView cache:YES];		
	[UIView commitAnimations];
}
-(void)nextTransition
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
	if(transitioning)
	{
		transitioning = NO;
		[view1 setHidden:YES];
		[view2 setHidden:NO];
		[add setEnabled:NO];
//		if(!isUpdatePSA)
//		{
			[eventTxtField setText:nil];
			[dobTxtField setText:nil];
//		}
		[self.navigationItem setTitle:@"Add new Event"];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:containerView cache:YES];		
	}
	else 
	{
		transitioning = YES;
		[view1 setHidden:NO];
		[view2 setHidden:YES];
		[add setEnabled:YES];
		[self resignAllTextFields];
		[self.navigationItem setTitle:@"Other events"];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];	
	}
	[UIView commitAnimations];
	
}

- (void) animatePickerView:(id)sender
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	
	if ([sender tag] == 502)
	{
		if(isPickerUP)
		{
			isPickerUP = NO;
 			[eventPickerView setFrame:CGRectMake(0,416,320,200)];
			[containerView setUserInteractionEnabled:YES];
		}
		else 
		{
			isPickerUP = YES;
 			[eventPickerView setFrame:CGRectMake(0,216,320,200)];
			[containerView setUserInteractionEnabled:NO];
		}		
	}
	else if ([sender tag] == 503)
	{
		if(isPickerUP)
		{
			isPickerUP = NO;
			[self resignAllTextFields];
 			[datePickerHolder setFrame:CGRectMake(0,416,320,200)];
			[containerView setUserInteractionEnabled:YES];
		}
		else 
		{
			isPickerUP = YES;
 			[datePickerHolder setFrame:CGRectMake(0,216,320,200)];
			[containerView setUserInteractionEnabled:NO];
		}		
	}
	[UIView commitAnimations];
}
#pragma mark -

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	selectedrow = indexPath.row;
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	isUpdatePSA = YES;
	[self editEvent];
	[eventTxtField setText:[[infoArray objectAtIndex:indexPath.row] objectForKey:@"eventname"]];
	NSArray *temp = [[NSArray alloc] initWithArray:[[[infoArray objectAtIndex:indexPath.row] objectForKey:@"eventdate"] componentsSeparatedByString:@"-"]];
	[dobTxtField setText:[NSString stringWithFormat:@"%@-%@-%@",[temp objectAtIndex:1],[temp objectAtIndex:2], [temp objectAtIndex:0]]];
	[self setDateStr:[[infoArray objectAtIndex:indexPath.row] objectForKey:@"eventdate"]];
}
#pragma mark -

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [infoArray count];;
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
//		v.layer.cornerRadius = 7;
        cell.selectedBackgroundView = v;
		[v release];
		
		// for  event name
		UILabel *titleLabel = [[UILabel alloc] init];		
		[titleLabel setTag:101];
		[titleLabel setFrame:CGRectMake(10,5,200,30)];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		//[titleLabel setTextAlignment:UITextAlignmentRight];
		[cell addSubview:titleLabel];
		[titleLabel release];
		
//		// date
//		titleLabel = [[UILabel alloc] init];		
//		[titleLabel setTag:102];
//		[titleLabel setFrame:CGRectMake(10,35,250,20)];
//		[titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//		[titleLabel setTextColor:[UIColor lightGrayColor]];
//		[titleLabel setBackgroundColor:[UIColor clearColor]];
//		//[titleLabel setTextAlignment:UITextAlignmentRight];
//		[cell addSubview:titleLabel];
//		[titleLabel release];
		
		// days
		titleLabel = [[UILabel alloc] init];		
		[titleLabel setTag:103];
		[titleLabel setFrame:CGRectMake(200,5,100,30)];
		[titleLabel setFont:[UIFont systemFontOfSize:14]];
		[titleLabel setTextColor:[UIColor lightGrayColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextAlignment:UITextAlignmentRight];
		[cell addSubview:titleLabel];
		[titleLabel release];
	}
	
	UILabel *eventName = (UILabel*)[cell viewWithTag:101];
	[eventName setText:[[infoArray objectAtIndex:indexPath.row] objectForKey:@"eventname"]];

//	UILabel *eventDate = (UILabel*)[cell viewWithTag:102];
//	[eventDate setText:[[infoArray objectAtIndex:indexPath.row] objectForKey:@"eventdate"]];
	
	int numdays = [[[infoArray objectAtIndex:indexPath.row] objectForKey:@"days"] intValue];
	UILabel *days = (UILabel*)[cell viewWithTag:103];
	if(numdays == 0)
	{
		[days setText:@"Today"];
	}
	else if((numdays < 0) || (numdays > 7) )
	{
		[days setText:nil];
	}
	else 
	{
		[days setText:((numdays > 1)?[NSString stringWithFormat:@"%@ days",[[infoArray objectAtIndex:indexPath.row] objectForKey:@"days"]]:@"1 day")];
	}
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	//	printf("\ncanEditRowAtIndexPath\n");
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self deleteOtherEvent:[[infoArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
	[infoArray removeObjectAtIndex:[indexPath row]];
	
	[myTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	[myTable endUpdates];	
	[myTable reloadData];
}	


#pragma mark -
#pragma mark UIPickerViewDelegate & UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if ([pickerView tag] == 502)
	{
		return [eventsArray count];
	}	
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if ([pickerView tag] == 502)
	{
		return [eventsArray objectAtIndex:row];
	}
	
	return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if ([pickerView tag] == 502)
	{
		[eventTxtField setText:[eventsArray objectAtIndex:row]];
	}
}


#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	//[self scrollViewToCenterOfScreen:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	//[myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

- (void) resignAllTextFields
{
	[dobTxtField resignFirstResponder];
	[eventTxtField resignFirstResponder];
}

#pragma mark -
#pragma mark Banner action
- (void) bannerClicked
{
    NSLog(@"bannerClicked %@",banner.weblink);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:banner.weblink]];
}

- (void) animateBanner
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [banner setAlpha:0.0];
    [UIView setAnimationDidStopSelector:@selector(animateBanner1)];
    [UIView commitAnimations];       
}

- (void) animateBanner1
{
    MyJewelerAppDelegate *appDelegate = (MyJewelerAppDelegate*)[[UIApplication sharedApplication] delegate];
    Banner *o = [appDelegate getAd];
    [banner setTag:[[o bannerID] intValue]];
    [banner setImage:[o bannerImage]];
    [banner setUid:[o bannerID]];
    [banner setWeblink:[o bannerURL]];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [banner setAlpha:1.0];
    [UIView setAnimationDidStopSelector:@selector(changeBanner)];
    [UIView commitAnimations];       
}

- (void) changeBanner
{
    if(isBannerAnimating)
    {
        [self performSelector:@selector(animateBanner) withObject:nil afterDelay:ANIMATE_BANNER_AFTER_DELAY];
    }
}

-(void) bannerAskaQuestionClicked:(id)sender
{
    //    NSLog(@"bannerAskaQuestionClicked %d",[banner tag]);
    AskBannerQuestionVC *o = [[AskBannerQuestionVC alloc] init];
    [o setToid:[NSString stringWithFormat:@"%d",[banner tag]]];
    [self.navigationController pushViewController:o animated:YES];
    [o release];
}
#pragma mark -
#pragma mark Info view
- (void) prepareInfoView
{
    infoView  = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, 280)];
    [infoView setUserInteractionEnabled:YES];
    
    UIImageView *callout = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320,280)];
    [callout setImage:[UIImage imageNamed:@"callout.png"]];
    [infoView addSubview:callout];
    
    UITextView *txt = [[UITextView alloc] initWithFrame:CGRectMake(40,50, 240, 155)];
    if(VERSION == 2)
    {
        [txt setText:JEWELER_INFO_TXT];
    }
    else
    {
        [txt setText:SUPPLIER_INFO_TXT];
    }
    [txt setBackgroundColor:[UIColor clearColor]];
    [txt setFont:[UIFont systemFontOfSize:14.0]];
    [txt setTextColor:[UIColor blackColor]];
    [txt setEditable:NO];
    [txt setScrollEnabled:YES];
    [txt setShowsVerticalScrollIndicator:NO];
    [infoView addSubview:txt];
    [txt release];
    
    UIButton *close = [[UIButton alloc] initWithFrame:CGRectMake(10,10,30,30)];
    [close setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(animateInfoView) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:close];   
    
    [infoView setAlpha:0.0];
    [self.view addSubview:infoView];
    [close release];
    [callout release];
    [infoView release];
}

- (void) animateInfoView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    if(isInfoVisible)
    {
        isInfoVisible = NO;
        [myTable setUserInteractionEnabled:YES];
        [infoView setAlpha:0.0];
    }
    else
    {
        isInfoVisible = YES;
        [myTable setUserInteractionEnabled:NO];
        [infoView setAlpha:1.0];
        
    }
    [UIView commitAnimations];  
}
#pragma mark -


#pragma mark ASI support
- (void) getOtherEventsList
{
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/psaOtherEvents.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:@"0" forKey:@"option"];
	// id is foreign key here
	[req setPostValue:[NSString stringWithFormat:@"%d",rowid] forKey:@"id"];
	[req start];
	NSLog(@"\n\n getOtherEventsList response - %@",[req	responseString]);
	
	NSArray *array = [[NSArray alloc] initWithArray:[[req responseString] JSONValue]];
	
	if(infoArray !=nil)
	{
		[infoArray removeAllObjects];
		[infoArray release];
	}
	infoArray = [[NSMutableArray alloc] init];
	
	for(NSDictionary *dict in array)
	{
		[infoArray addObject:dict];
	}
	[req release];
	[url release];
	[myTable reloadData];
}

- (void) addOtherEventToServer
{
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/psaOtherEvents.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:@"1" forKey:@"option"];
	// id is foreign key here
	[req setPostValue:[NSString stringWithFormat:@"%d",rowid] forKey:@"id"];
	[req setPostValue:[eventTxtField text]	forKey:@"eventname"];
	[req setPostValue:self.dateStr forKey:@"eventdate"];
	[req start];
	NSLog(@"\n\n addOtherEventToServer response - %@",[req	responseString]);
	[req release];
	[url release];	
	
	[self performSelector:@selector(nextTransition) withObject:nil afterDelay:1.0];
	[self performSelector:@selector(getOtherEventsList) withObject:nil afterDelay:0.5];
}

- (void) updateOtherEvent
{
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/psaOtherEvents.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:@"2" forKey:@"option"];
	[req setPostValue:[[infoArray objectAtIndex:selectedrow] objectForKey:@"id"] forKey:@"id"];
	[req setPostValue:[eventTxtField text]	forKey:@"eventname"];
	[req setPostValue:self.dateStr forKey:@"eventdate"];
	[req start];
	NSLog(@"\n\n updateOtherEvent response - %@",[req	responseString]);
	[req release];
	[url release];	
	
	isUpdatePSA = NO;
	[self performSelector:@selector(nextTransition) withObject:nil afterDelay:1.0];
	[self performSelector:@selector(getOtherEventsList) withObject:nil afterDelay:0.5];
}

- (void) deleteOtherEvent:(NSString*)row_id
{
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/psaOtherEvents.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:@"3" forKey:@"option"];
	[req setPostValue:row_id forKey:@"id"];
	[req start];
	NSLog(@"\n\n deleteOtherEvent response - %@",[req	responseString]);
	[req release];
	[url release];			
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




@end
