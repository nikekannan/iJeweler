//
//  AddPersonVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/28/11.
//  Copyright 2011 no. All rights reserved.
//

#import "AddPersonVC.h"
#import "CustomDatePickerView.h"
#import "CustomPickerView.h"
#import "AskQuestionVC.h"
#import "Constants.h"

#define JEWEL_COLOR_TAG 200
#define JEWEL_STYLE_TAG 300
#define WATCH_STYLE_TAG 400
#define TITLE_FONT_SIZE 14
@implementation AddPersonVC

@synthesize dateStr;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[self.navigationItem setTitle:@"Add Person"];
	isPickerUP = NO;
	//	isDatePickerUP = NO;
	//	isEventPickerUP = NO;
	//	isRelationPickerUP = NO;
	
	save = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(sendPSA)];
	[self.navigationItem setRightBarButtonItem:save];
	[save release];
	
	dateFormatter = [[NSDateFormatter alloc] init];
	stoneNameArray = [[NSMutableArray alloc] initWithObjects:@"Garnet",@"Amethyst", @"Aquamarine, Bloodstone ", @"Diamond", @"Emerald", @"Pearl, Moonstone, Alexandrite", @"Ruby", @"Peridot, Sardonyx", @"Sapphire", @"Opal, Pink Tourmaline", @"Citrine, Yellow Topaz", @"Blue Topaz, Turquoise",nil];
	relationArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"Self",@"Friend",@"Father", @"Mother", @"Son", @"Daughter", @"Brother", @"Sister", @"Uncle", @"Aunt", @"Wife", @"Husband", @"Cousin", @"Niece", @"Nephew", @"Mother in Law", @"Father in Law", @"Sister in Law", @"Brother in Law",@"Grand Father", @"Grand Mother",nil]];
	eventsArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"Anniversary", @"Birthday",@"Wedding day",@"Christmas",@"Thanks giving",nil]];
	jewelColorArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"White",@"Yellow",@"Yellow & White",@"All",nil]];
	jewelStyleArray = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"Modern",@"Vintage", @"Channel", @"Traditional", @"Simple", @"Bling",@"All",nil]];
	watchStyleArray	= [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects: 
															 @"Rolex",
															 @"Cartier",
															 @"Patek Philippe",
															 @"TAG Heuer",
															 @"Chopard",
															 @"Bell",
															 @"Nixon",
															 @"Breitling",
															 @"Audemars Piguet",
															 @"IWC",
															 @"Piaget",
															 @"Breguet",
															 @"Tissot",
															 @"Jaeger-Le-Coultre",
															 @"Girard-Perregaux",
															 @"Longines",
															 @"Rado",
															 @"Vacheron Constantin",
															 @"Hublot",
															 @"A.Lange&Sohne",
															 @"Raymond Weil",
															 @"Baume&Mercier",
															 @"Blancpain",
															 @"Ulysse Nardin",
															 @"Movado",
															 nil]];
	[watchStyleArray sortUsingSelector:@selector(compare:)];
	[watchStyleArray addObject:@"All"];
	
	for(int i = 0 ; i < [watchStyleArray count]; i++)
	{
		if(i < [jewelColorArray count])	jewelColor[i] = 0 ;
		if(i < [jewelStyleArray count])	jewelStyle[i] = 0 ;
		watchStyle[i] = 0 ;
	}
	
	[self.view setBackgroundColor:[UIColor clearColor]];
	[self loadScrollView];
	[self loadRelationPickerView];
	[self loadEventPickerView];
	[self loadDatePickerView];
    [super viewDidLoad];
}

- (void) loadRelationPickerView
{
	relationPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,416,320,200)];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [relationPickerView setFrame:CGRectMake(0,416 + 88, 320, 200)];
    }
	[relationPickerView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
	
	UIToolbar *myToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
	[myToolBar setTintColor:[UIColor colorWithRed:41.0/255.0 green:32.0/255.0 blue:23.0/255.0 alpha:1.0]];
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem	*done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(animatePickerView:)];
	[done setTag:501];
	[myToolBar setItems:[NSArray arrayWithObjects:flexSpace,done,nil]];
	[relationPickerView addSubview:myToolBar];
	[myToolBar release];
	[flexSpace release];
	[done release];
	
	CustomPickerView *o = [[CustomPickerView alloc] init];
	[o setTag:501];
	[o setDelegate:self];
	[o setShowsSelectionIndicator:YES];
	[relationPickerView addSubview:o];	
	[self.view addSubview:relationPickerView];
	[relationPickerView release];
	[o release];	
}

- (void) loadEventPickerView
{
	eventPickerView = [[UIView alloc] initWithFrame:CGRectMake(0,416,320,200)];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [eventPickerView setFrame:CGRectMake(0,416 + 88, 320, 200)];
    }
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
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [datePickerHolder setFrame:CGRectMake(0,416 + 88, 320, 200)];
    }
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

- (void) loadScrollView
{
	myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, 320, 416)];
	[myScrollView setContentSize:CGSizeMake(320, 480)];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [myScrollView setFrame:CGRectMake(0,0, 320, 416 + 88)];
        [myScrollView setContentSize:CGSizeMake(320, 480 + 88)];
    }
	[myScrollView setBackgroundColor:[UIColor clearColor]];
	
	UIColor *shadowColor = [UIColor blackColor];
	UIColor *txtColor = [UIColor lightGrayColor];
	
	
	int y = 5;
	int gap = 40;
	
	//	for(int i = 0 ; i < 5 ; i++)
	//	{
	
	// Name
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,y,300,15)];		
	[titleLabel setFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
	[titleLabel setText:@"Name"];
	[titleLabel setTextColor:txtColor];
	[titleLabel	setShadowColor:shadowColor];
	[titleLabel setShadowOffset:CGSizeMake(0,1)];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[myScrollView addSubview:titleLabel];
	[titleLabel release];
	
	y += 20;	
	
	nameTxtField = [[UITextField alloc] initWithFrame:CGRectMake(10,y,300, 30)];
	[nameTxtField setDelegate:self];
	[nameTxtField setTag:101];
	[nameTxtField setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[nameTxtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
 	[nameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[nameTxtField setBorderStyle:UITextBorderStyleRoundedRect];
 	[nameTxtField setKeyboardType:UIKeyboardTypeDefault];
	[nameTxtField setFont:[UIFont systemFontOfSize:16]];
	[nameTxtField setTextColor:[UIColor blackColor]];
	[myScrollView addSubview:nameTxtField];
	[nameTxtField release];	
	
	y += gap;
	
	// releation
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,y,300,15)];		
	[titleLabel setFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
	[titleLabel setText:@"Relationship"];
	[titleLabel setTextColor:txtColor];
	[titleLabel	setShadowColor:shadowColor];
	[titleLabel setShadowOffset:CGSizeMake(0,1)];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[myScrollView addSubview:titleLabel];
	[titleLabel release];
	
	y += 20;	
	
	relationTxtField = [[UITextField alloc] initWithFrame:CGRectMake(10,y,260, 30)];
	[relationTxtField setDelegate:self];
	[relationTxtField setTag:101];
	[relationTxtField setKeyboardAppearance:UIKeyboardAppearanceAlert];
 	[relationTxtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[relationTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[relationTxtField setBorderStyle:UITextBorderStyleRoundedRect];
 	[relationTxtField setKeyboardType:UIKeyboardTypeDefault];
	[relationTxtField setFont:[UIFont systemFontOfSize:16]];
	[relationTxtField setTextColor:[UIColor blackColor]];
	[myScrollView addSubview:relationTxtField];
	[relationTxtField release];	
	
	UIButton *listButton = [[UIButton alloc] initWithFrame:CGRectMake(280, y, 30, 30)];
	[listButton setTag:501];
	[listButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
	[listButton addTarget:self action:@selector(animatePickerView:) forControlEvents:UIControlEventTouchUpInside];
	[myScrollView addSubview:listButton];
	[listButton release];
	
	
	y += gap;	
	
	// Event name
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,y,250,15)];		
	[titleLabel setFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
	[titleLabel setText:@"Event Name"];
	[titleLabel setTextColor:txtColor];
	[titleLabel	setShadowColor:shadowColor];
	[titleLabel setShadowOffset:CGSizeMake(0,1)];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[myScrollView addSubview:titleLabel];
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
	[eventTxtField setFont:[UIFont systemFontOfSize:16]];
	[eventTxtField setTextColor:[UIColor blackColor]];
	[myScrollView addSubview:eventTxtField];
	[eventTxtField release];				
	
	UIButton *eventListButton = [[UIButton alloc] initWithFrame:CGRectMake(280, y, 30, 30)];
	[eventListButton setTag:502];
	[eventListButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
	[eventListButton addTarget:self action:@selector(animatePickerView:) forControlEvents:UIControlEventTouchUpInside];
	[myScrollView addSubview:eventListButton];
	[eventListButton release];
	
	y += gap;	
	
	// budget
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,y,250,15)];		
	[titleLabel setFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
	[titleLabel setText:@"Budget"];
	[titleLabel setTextColor:[UIColor orangeColor]];
	[titleLabel	setShadowColor:shadowColor];
	[titleLabel setShadowOffset:CGSizeMake(0,1)];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[myScrollView addSubview:titleLabel];
	[titleLabel release];
	
	y += 20;	
	
	budgetTxtField1 = [[UITextField alloc] initWithFrame:CGRectMake(10,y,145, 30)];
	[budgetTxtField1 setDelegate:self];
	[budgetTxtField1 setTag:101];
	[budgetTxtField1 setPlaceholder:@"$ From"];
	[budgetTxtField1 setKeyboardAppearance:UIKeyboardAppearanceAlert];
 	[budgetTxtField1 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[budgetTxtField1 setAutocorrectionType:UITextAutocorrectionTypeNo];
	[budgetTxtField1 setBorderStyle:UITextBorderStyleRoundedRect];
 	[budgetTxtField1 setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	[budgetTxtField1 setFont:[UIFont systemFontOfSize:16]];
	[budgetTxtField1 setTextColor:[UIColor blackColor]];
	[myScrollView addSubview:budgetTxtField1];
	[budgetTxtField1 release];	
	
	budgetTxtField2 = [[UITextField alloc] initWithFrame:CGRectMake(165,y,145, 30)];
	[budgetTxtField2 setDelegate:self];
	[budgetTxtField2 setTag:101];
	[budgetTxtField2 setPlaceholder:@"$ To"];
	[budgetTxtField2 setKeyboardAppearance:UIKeyboardAppearanceAlert];
 	[budgetTxtField2 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[budgetTxtField2 setAutocorrectionType:UITextAutocorrectionTypeNo];
	[budgetTxtField2 setBorderStyle:UITextBorderStyleRoundedRect];
 	[budgetTxtField2 setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	[budgetTxtField2 setFont:[UIFont systemFontOfSize:16]];
	[budgetTxtField2 setTextColor:[UIColor blackColor]];
	[myScrollView addSubview:budgetTxtField2];
	[budgetTxtField2 release];	
	
	y += gap;	
	
	// budget
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,y,250,15)];		
	[titleLabel setFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
	[titleLabel setText:@"Date of Birth"];
	[titleLabel setTextColor:txtColor];
	[titleLabel	setShadowColor:shadowColor];
	[titleLabel setShadowOffset:CGSizeMake(0,1)];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[myScrollView addSubview:titleLabel];
	[titleLabel release];
	
	y += 20;	
	
	dobTxtField = [[UITextField alloc] initWithFrame:CGRectMake(10,y,260, 30)];
	[dobTxtField setDelegate:self];
	[dobTxtField setTag:101];
	[dobTxtField setPlaceholder:@"MM-DD-YYYY"];
	[dobTxtField setUserInteractionEnabled:NO];
	[dobTxtField setKeyboardAppearance:UIKeyboardAppearanceAlert];
 	[dobTxtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[dobTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[dobTxtField setBorderStyle:UITextBorderStyleRoundedRect];
 	[dobTxtField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	[dobTxtField setFont:[UIFont systemFontOfSize:16]];
	[dobTxtField setTextColor:[UIColor blackColor]];
	[myScrollView addSubview:dobTxtField];
	[dobTxtField release];	
	
	UIButton *dobListButton = [[UIButton alloc] initWithFrame:CGRectMake(280, y, 30, 30)];
	[dobListButton setTag:503];
	[dobListButton setImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
	[dobListButton addTarget:self action:@selector(animatePickerView:) forControlEvents:UIControlEventTouchUpInside];
	[myScrollView addSubview:dobListButton];
	[dobListButton release];
	
	y += gap;	
	
	// birth stone
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,y+5,150,48)];		
	[titleLabel setFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
	[titleLabel setText:@"Birth Stone"];
	[titleLabel setTextColor:txtColor];
	[titleLabel	setShadowColor:shadowColor];
	[titleLabel setShadowOffset:CGSizeMake(0,1)];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[myScrollView addSubview:titleLabel];
	[titleLabel release];
	
	birthStoneImageView = [[ UIImageView alloc] initWithFrame:CGRectMake(180, y, 48, 48)];
	birthStoneImageView.layer.cornerRadius = 5;
	[birthStoneImageView setImage:[UIImage imageNamed:@"diamond.png"]];
	[myScrollView addSubview:birthStoneImageView];
	[birthStoneImageView release];
	
	y += gap;
	
	stoneNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(113,y+10,180,25)];		
	[stoneNameLabel setFont:[UIFont boldSystemFontOfSize:12]];
	[stoneNameLabel setTextColor:txtColor];
	[stoneNameLabel	setShadowColor:shadowColor];
	[stoneNameLabel	setTextAlignment:UITextAlignmentCenter];
	[stoneNameLabel setShadowOffset:CGSizeMake(0,1)];
	[stoneNameLabel setBackgroundColor:[UIColor clearColor]];
	[myScrollView addSubview:stoneNameLabel];
	[stoneNameLabel release];
	
	y += gap;
	
	askQtnAboutStone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[askQtnAboutStone setHidden:YES];
	[askQtnAboutStone setFrame:CGRectMake(10, y, 300, 35)];
	askQtnAboutStone.titleLabel.numberOfLines =2;
	askQtnAboutStone.titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
	[askQtnAboutStone addTarget:self action:@selector(askAQuestion) forControlEvents:UIControlEventTouchUpInside];
	[myScrollView addSubview:askQtnAboutStone];
	
	y += gap;
	
	// Jewel color
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,y,250,15)];		
	[titleLabel setFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
	[titleLabel setText:@"Favourite Jewelry Metal Color"];
	[titleLabel setTextColor:txtColor];
	[titleLabel	setShadowColor:shadowColor];
	[titleLabel setShadowOffset:CGSizeMake(0,1)];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[myScrollView addSubview:titleLabel];
	[titleLabel release];
	
	y += 30; 
	for(int i = 1 ; i <= [jewelColorArray count] ; i++)
	{
		UIButton *jColorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[jColorButton setFrame:CGRectMake(((i % 2 == 0)?190: 30), y, 120 , 25)];
		[jColorButton setTag:i+10];
		[jColorButton setTitle:[jewelColorArray objectAtIndex:i-1] forState:UIControlStateNormal];
		jColorButton.titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
		[jColorButton addTarget:self action:@selector(jewelButtonColor:) forControlEvents:UIControlEventTouchUpInside];
		[myScrollView addSubview:jColorButton];
		
		UIImageView *checkbox = [[UIImageView alloc] initWithFrame:CGRectMake(((i % 2 == 0)?170: 10), y+5,16, 16)];
		[checkbox setTag:i+JEWEL_COLOR_TAG];
		[checkbox setImage:[UIImage imageNamed:@"checkbox.png"]];
		[myScrollView addSubview:checkbox];
		[checkbox release];		
		
		//[jColorButton release];
		if( (i % 2 == 0) )
		{
			y +=gap;
		}
	}	
	
	y += 20;
	
	// Jewellery Style
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,y,250,15)];		
	[titleLabel setFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
	[titleLabel setText:@"Favourite Jewelry Style"];
	[titleLabel setTextColor:txtColor];
	[titleLabel	setShadowColor:shadowColor];
	[titleLabel setShadowOffset:CGSizeMake(0,1)];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[myScrollView addSubview:titleLabel];
	[titleLabel release];
	
	y += 30; 
	for(int i = 1 ; i <= [jewelStyleArray count] ; i++)
	{
		UIButton *jColorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[jColorButton setFrame:CGRectMake(((i % 2 == 0)?190: 30), y, 120 , 25)];
		[jColorButton setTag:i+10];
		[jColorButton setTitle:[jewelStyleArray objectAtIndex:i-1] forState:UIControlStateNormal];
		jColorButton.titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
		[jColorButton addTarget:self action:@selector(jewelStyleButton:) forControlEvents:UIControlEventTouchUpInside];
		[myScrollView addSubview:jColorButton];
		
		UIImageView *checkbox = [[UIImageView alloc] initWithFrame:CGRectMake(((i % 2 == 0)?170: 10), y+5,16, 16)];
		[checkbox setTag:i+JEWEL_STYLE_TAG];
		[checkbox setImage:[UIImage imageNamed:@"checkbox.png"]];
		[myScrollView addSubview:checkbox];
		[checkbox release];		
		
		if( (i % 2 == 0) )
		{
			y +=gap;
		}
	}	
	
	y += 40;
	
	// Watch Style
	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,y,250,15)];		
	[titleLabel setFont:[UIFont boldSystemFontOfSize:TITLE_FONT_SIZE]];
	[titleLabel setText:@"Favourite Watch Brands"];
	[titleLabel setTextColor:txtColor];
	[titleLabel	setShadowColor:shadowColor];
	[titleLabel setShadowOffset:CGSizeMake(0,1)];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[myScrollView addSubview:titleLabel];
	[titleLabel release];
	
	y += 30; 
	for(int i = 1 ; i <= [watchStyleArray count] ; i++)
	{
		UIButton *jColorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[jColorButton setFrame:CGRectMake(60, y, 220 , 25)];
		[jColorButton setTag:i+10];
		[jColorButton setTitle:[watchStyleArray objectAtIndex:i-1] forState:UIControlStateNormal];
		jColorButton.titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
		[jColorButton addTarget:self action:@selector(watchStyleButton:) forControlEvents:UIControlEventTouchUpInside];
		[myScrollView addSubview:jColorButton];
		
		UIImageView *checkbox = [[UIImageView alloc] initWithFrame:CGRectMake(40, y+5,16, 16)];
		[checkbox setTag:i+WATCH_STYLE_TAG];
		[checkbox setImage:[UIImage imageNamed:@"checkbox.png"]];
		[myScrollView addSubview:checkbox];
		[checkbox release];		
		
		y +=gap;
		
	}		
	
	[myScrollView setContentSize:CGSizeMake(320, y+gap)];	
	[self.view addSubview:myScrollView];
	[myScrollView release];
}

#pragma mark Button Action
- (void) animatePickerView:(id)sender
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        if([sender tag] == 501)
        {
            if(isPickerUP)
            {
                isPickerUP = NO;
                [relationPickerView setFrame:CGRectMake(0,416 + 88,320,200)];
                [myScrollView setFrame:CGRectMake(0,0, 320, 416 + 88)];
                [myScrollView setUserInteractionEnabled:YES];
            }
            else
            {
                isPickerUP = YES;
                [relationPickerView setFrame:CGRectMake(0,216 + 88,320,200)];
                [myScrollView setFrame:CGRectMake(0,0, 320, 216 + 88)];
                [myScrollView setUserInteractionEnabled:NO];
            }
        }
        else if ([sender tag] == 502)
        {
            if(isPickerUP)
            {
                isPickerUP = NO;
                [eventPickerView setFrame:CGRectMake(0,416 + 88,320,200)];
                [myScrollView setFrame:CGRectMake(0,0, 320, 416 + 88)];
                [myScrollView setUserInteractionEnabled:YES];
                
            }
            else
            {
                isPickerUP = YES;
                [eventPickerView setFrame:CGRectMake(0,216 + 88,320,200)];
                [myScrollView setFrame:CGRectMake(0,0, 320, 216 + 88)];
                [myScrollView setUserInteractionEnabled:NO];
            }
        }
        else if ([sender tag] == 503)
        {
            if(isPickerUP)
            {
                isPickerUP = NO;
                [self resignAllTextFields];
                [datePickerHolder setFrame:CGRectMake(0,416 + 88,320,200)];
                [myScrollView setFrame:CGRectMake(0,0, 320, 416 + 88)]; 
                [myScrollView setUserInteractionEnabled:YES];
            }
            else 
            {
                isPickerUP = YES;
                [datePickerHolder setFrame:CGRectMake(0,216 + 88,320,200)];
                [myScrollView setFrame:CGRectMake(0,0, 320, 216 + 88)]; 
                [myScrollView setUserInteractionEnabled:NO];
            }		
        }
    }
    else
    {
        if([sender tag] == 501)
        {
            if(isPickerUP)
            {
                isPickerUP = NO;
                [relationPickerView setFrame:CGRectMake(0,416,320,200)];
                [myScrollView setFrame:CGRectMake(0,0, 320, 416)];
                [myScrollView setUserInteractionEnabled:YES];
            }
            else
            {
                isPickerUP = YES;
                [relationPickerView setFrame:CGRectMake(0,216,320,200)];
                [myScrollView setFrame:CGRectMake(0,0, 320, 216)];
                [myScrollView setUserInteractionEnabled:NO];
            }
        }
        else if ([sender tag] == 502)
        {
            if(isPickerUP)
            {
                isPickerUP = NO;
                [eventPickerView setFrame:CGRectMake(0,416,320,200)];
                [myScrollView setFrame:CGRectMake(0,0, 320, 416)];
                [myScrollView setUserInteractionEnabled:YES];
                
            }
            else
            {
                isPickerUP = YES;
                [eventPickerView setFrame:CGRectMake(0,216,320,200)];
                [myScrollView setFrame:CGRectMake(0,0, 320, 216)];
                [myScrollView setUserInteractionEnabled:NO];
            }
        }
        else if ([sender tag] == 503)
        {
            if(isPickerUP)
            {
                isPickerUP = NO;
                [self resignAllTextFields];
                [datePickerHolder setFrame:CGRectMake(0,416,320,200)];
                [myScrollView setFrame:CGRectMake(0,0, 320, 416)]; 
                [myScrollView setUserInteractionEnabled:YES];
            }
            else 
            {
                isPickerUP = YES;
                [datePickerHolder setFrame:CGRectMake(0,216,320,200)];
                [myScrollView setFrame:CGRectMake(0,0, 320, 216)]; 
                [myScrollView setUserInteractionEnabled:NO];
            }		
        }
    }
	[UIView commitAnimations];
	
	
}

- (void) jewelButtonColor:(id)sender
{
	int tag = ([sender tag] % 10);
	UIImageView *imgView = (UIImageView*)[self.view viewWithTag:tag+JEWEL_COLOR_TAG];
	if(jewelColor[tag-1])
	{		
		jewelColor[tag-1] = 0;
		[imgView setImage:[UIImage imageNamed:@"checkbox.png"]];
	}
	else 
	{
		jewelColor[tag-1] = 1;
		[imgView setImage:[UIImage imageNamed:@"checked.png"]];
	}
}

- (void) jewelStyleButton:(id)sender
{
	int tag = ([sender tag] % 10);
	UIImageView *imgView = (UIImageView*)[self.view viewWithTag:tag+JEWEL_STYLE_TAG];
	if(jewelStyle[tag-1])
	{		
		jewelStyle[tag-1] = 0;
		[imgView setImage:[UIImage imageNamed:@"checkbox.png"]];
	}
	else 
	{
		jewelStyle[tag-1] = 1;
		[imgView setImage:[UIImage imageNamed:@"checked.png"]];
	}	
}

- (void) watchStyleButton:(id)sender
{
	int tag = [sender tag] - 10;
	//NSLog(@"tag - %d",tag);
	UIImageView *imgView = (UIImageView*)[self.view viewWithTag:tag+WATCH_STYLE_TAG];
	if(watchStyle[tag-1])
	{		
		watchStyle[tag-1] = 0;
		[imgView setImage:[UIImage imageNamed:@"checkbox.png"]];
	}
	else 
	{
		watchStyle[tag-1] = 1;
		[imgView setImage:[UIImage imageNamed:@"checked.png"]];
	}	
}

- (void) dateSelected:(id)sender
{
	[dateFormatter setDateFormat:@"MM"];
	stoneNumber = [[dateFormatter stringFromDate:[sender date]] intValue];
	[stoneNameLabel setText:[stoneNameArray objectAtIndex:stoneNumber-1]];
	[askQtnAboutStone setHidden:NO];
	[askQtnAboutStone setTitle:[NSString stringWithFormat:@"Ask a question about %@",[stoneNameArray objectAtIndex:stoneNumber-1]] forState:UIControlStateNormal];
	//NSLog(@"date selected - %@",[dateFormatter stringFromDate:[sender date]]);
	[birthStoneImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",stoneNumber]]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	[self setDateStr:[dateFormatter stringFromDate:[sender date]]];
	[dateFormatter setDateFormat:@"MM-dd-yyyy"];
	[dobTxtField setText:[dateFormatter stringFromDate:[sender date]]];
}
#pragma mark UIPickerViewDelegate & UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if([pickerView tag] == 501)
		return [relationArray count];
	else if ([pickerView tag] == 502)
		return [eventsArray count];
	
	return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if([pickerView tag] == 501)
	{
		return [relationArray objectAtIndex:row];
	}
	else if ([pickerView tag] == 502)
	{
		return [eventsArray objectAtIndex:row];
	}
	
	return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if([pickerView tag] == 501)
	{
		[relationTxtField setText:[relationArray objectAtIndex:row]];
	}
	else 
	{
		[eventTxtField setText:[eventsArray objectAtIndex:row]];
	}
}

- (void)scrollViewToCenterOfScreen:(UIView *)theView 
{
	float contentOffsetY = theView.frame.origin.y;
	//[myScrollView setContentSize:CGSizeMake(myScrollView.contentSize.width, /*iPhoneContentOffsetY */ contentOffsetY)];	
	[myScrollView setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
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
	[nameTxtField resignFirstResponder];
	[relationTxtField resignFirstResponder];
	[dobTxtField resignFirstResponder];
	[eventTxtField resignFirstResponder];
	[budgetTxtField1 resignFirstResponder];
	[budgetTxtField2 resignFirstResponder];
}
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */
#pragma mark -

#pragma mark ASI support

- (void) sendPSA
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[save setEnabled:NO];
	//[activityIndicator startAnimating];
	
	NSMutableString *tempJewelColorStr = [[NSMutableString alloc] init];
	NSMutableString *tempJewelStyleStr = [[NSMutableString alloc] init];
	NSMutableString *tempWatchBrandStr = [[NSMutableString alloc] init];
	int i = 0;
	for(i = 0 ; i < [jewelColorArray count] ; i++)
	{
		if(jewelColor[i] == 1)
		{
			[tempJewelColorStr appendString:[jewelColorArray objectAtIndex:i]];
			[tempJewelColorStr appendString:@","];
		}
	}
	
	for(i = 0 ; i < [jewelStyleArray count] ; i++)
	{
		if(jewelStyle[i] == 1)
		{
			[tempJewelStyleStr appendString:[jewelStyleArray objectAtIndex:i]];
			[tempJewelStyleStr appendString:@","];
		}
	}

	for(i = 0 ; i < [watchStyleArray count] ; i++)
	{
		if(watchStyle[i] == 1)
		{
			[tempWatchBrandStr appendString:[watchStyleArray objectAtIndex:i]];
			[tempWatchBrandStr appendString:@","];
		}
	}
	
	if([tempJewelColorStr length] > 2) [tempJewelColorStr replaceCharactersInRange:NSMakeRange([tempJewelColorStr length]-1, 1) withString:@""];
	if([tempJewelStyleStr length] > 2) [tempJewelStyleStr replaceCharactersInRange:NSMakeRange([tempJewelStyleStr length]-1, 1) withString:@""];
	if([tempWatchBrandStr length] > 2) [tempWatchBrandStr replaceCharactersInRange:NSMakeRange([tempWatchBrandStr length]-1, 1) withString:@""];
	
	//MyJewelerAppDelegate *appDelegate = (MyJewelerAppDelegate*) [[UIApplication sharedApplication] delegate];
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/psa.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:@"0" forKey:@"option"];
	[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"] forKey:@"myid"];
	[req setPostValue:(([[nameTxtField text]length] > 0)?[nameTxtField text]:@"NA") forKey:@"name"];  // fromid and toid interchanged
	[req setPostValue:(([[relationTxtField text]length] > 0)?[relationTxtField text]:@"NA") forKey:@"relationship"];
	[req setPostValue:(([[eventTxtField text]length] > 0)?[eventTxtField text]:@"NA") forKey:@"eventname"];
	[req setPostValue:(([[budgetTxtField1 text]length] > 0)?[budgetTxtField1 text]:@"NA") forKey:@"budget1"];
	[req setPostValue:(([[budgetTxtField2 text]length] > 0)?[budgetTxtField2 text]:@"NA") forKey:@"budget2"];
	[req setPostValue:(([dateStr length] > 0)?dateStr:@"NA") forKey:@"dob"];
	[req setPostValue:tempJewelColorStr forKey:@"jewelcolor"]; // its actually a string seperated by (,)
	[req setPostValue:tempJewelStyleStr forKey:@"jewelstyle"];
	[req setPostValue:tempWatchBrandStr forKey:@"watchbrand"];
	[req setDelegate:self];
	[req startAsynchronous];
	NSError *error = [req error];
	if (!error) {
		//NSLog(@"response -",[req responseString]);
	}
	[req release];
	[url release];	
	[tempJewelColorStr release];
	[tempJewelStyleStr release];
	[tempWatchBrandStr release];
	
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	//[activityIndicator stopAnimating];
	NSLog(@"response - %@",[request responseString]);
	if([[request responseString] intValue] > 0)
	{
		[self performSelector:@selector(saveToDB:) withObject:[request responseString] afterDelay:0.3];
	}
	else if([[request responseString] isEqualToString:@"FAILED"])
	{
		[save setEnabled:YES];
	}	
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	//[activityIndicator stopAnimating];
	[save setEnabled:YES];
}

#pragma mark -

#pragma mark Save

- (void) saveToDB:(NSString*)psaID
{
	NSMutableString *query1 = [[NSMutableString alloc] initWithString:@"insert into personalshopping (id, c1, c2, c3, c4, c5, c6, c7, c8) "];
	[query1 appendFormat:@"values('%@','%@','%@', '%@','%@','%@','%@','%@','%d')",psaID,(([[nameTxtField text]length] > 0)?[nameTxtField text]:@"NA"),(([[relationTxtField text]length] > 0)?[relationTxtField text]:@"NA"), (([[eventTxtField text]length] > 0)?[eventTxtField text]:@"NA"), (([[budgetTxtField1 text]length] > 0)?[budgetTxtField1 text]:@"NA"), (([[budgetTxtField2 text]length] > 0)?[budgetTxtField2 text]:@"NA"),(([[dobTxtField text]length] > 0)?[dobTxtField text]:@"NA"), (([dateStr length] > 0)?dateStr:@"NA"),stoneNumber];
	
	NSMutableString *query2 = [[NSMutableString alloc] initWithString:@"insert into jewelcolor (id, c1, c2, c3, c4) "];
	[query2 appendFormat:@"values('%@','%d','%d','%d','%d')", psaID,jewelColor[0],jewelColor[1],jewelColor[2],jewelColor[3]];
	
	NSMutableString *query3 = [[NSMutableString alloc] initWithString:@"insert into jewelstyle (id, c1, c2, c3, c4, c5, c6, c7) "];
	[query3 appendFormat:@"values('%@','%d','%d','%d','%d','%d','%d','%d')",psaID, jewelStyle[0],jewelStyle[1],jewelStyle[2],jewelStyle[3],jewelStyle[4],jewelStyle[5],jewelStyle[6]];
	
	NSMutableString *query4 = [[NSMutableString alloc] initWithString:@"insert into watchstyle (id, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18, c19, c20, c21, c22, c23, c24, c25, c26) "];
	[query4 appendFormat:@"values('%@','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d','%d')",psaID, watchStyle[0],watchStyle[1],watchStyle[2],watchStyle[3],watchStyle[4],watchStyle[5], watchStyle[6],watchStyle[7],watchStyle[8],watchStyle[9],watchStyle[10],watchStyle[11], watchStyle[12],watchStyle[13],watchStyle[14],watchStyle[15],watchStyle[16],watchStyle[17], watchStyle[18],watchStyle[19],watchStyle[20],watchStyle[21],watchStyle[22],watchStyle[23],watchStyle[24],watchStyle[25]];
	
//	NSLog(@"\nquery1 - %@",query1);
//	NSLog(@"\nquery2 - %@",query2);
//	NSLog(@"\nquery3 - %@",query3);
//	NSLog(@"\nquery4 - %@",query4);
	
	[self executeSQLQuery:query1];
	[self executeSQLQuery:query2];
	[self executeSQLQuery:query3];
	[self executeSQLQuery:query4];
	
	[query1 release];
	[query2 release];
	[query3 release];
	[query4 release];
	
	[self performSelector:@selector(goBack) withObject:nil afterDelay:0.5];
}

- (void) executeSQLQuery:(NSString*)query
{
	MySQLite *o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	[o readDb:query];
	[o hasNextRow];
	[o closeDb];
	[o release];	
}

- (void) goBack
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) askAQuestion
{
	AskQuestionVC *o = [[AskQuestionVC alloc] init];
	[o setQuestionStr:[NSString stringWithFormat:@"I would like to know about %@",[stoneNameArray objectAtIndex:stoneNumber-1]]];
	[self.navigationController pushViewController:o animated:YES];
	[o release];	
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
	[dateStr release];
	[dateFormatter release];
	[stoneNameArray release];
	[relationArray release];
	[eventsArray release];
	[jewelColorArray release];
	[jewelStyleArray release];
	[watchStyleArray release];
    [super dealloc];
}


@end
