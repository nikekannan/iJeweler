//
//  AddPersonVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/28/11.
//  Copyright 2011 no. All rights reserved.
//

#import "UpdatePersonVC.h"
#import "CustomDatePickerView.h"
#import "CustomPickerView.h"
#import "AskQuestionVC.h"
#import "AddMoreEventsVC.h"
#import "AskJeweler.h"
#import "Constants.h"

#define JEWEL_COLOR_TAG 200
#define JEWEL_STYLE_TAG 300
#define WATCH_STYLE_TAG 400
#define	TITLE_FONT_SIZE 14

static int psaSharedRowid;

@implementation UpdatePersonVC
@synthesize rowid;
@synthesize dateStr;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	psaSharedRowid = -1;
	[self.navigationItem setTitle:@"Update Person"];
	isPickerUP = NO;
	isShareViewUP = NO;
	isUpdatePSA = NO;
	if(VERSION == 2)
	{
		UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(animateShareView)];
		[self.navigationItem setRightBarButtonItem:share];
		[share release];		
	}
	
	UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
	[self.navigationItem setBackBarButtonItem:back];
	[back release];
	
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
	[self getDataFromDB];
	[self getJewelersList];
	[self loadToolBar];
	[self loadShareView];
	[self loadRelationPickerView];
	[self loadEventPickerView];
	[self loadDatePickerView];
    [super viewDidLoad];
}

- (void) loadToolBar
{
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,372,320,44)];
	[toolbar setTintColor:[UIColor colorWithRed:41.0/255.0 green:32.0/255.0 blue:23.0/255.0 alpha:1.0]];	
	UIBarButtonItem	 *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem	 *update = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(updatePSA)];
	[toolbar setItems:[NSArray arrayWithObjects:flex,update,flex,nil]];
	[self.view addSubview:toolbar];
	[toolbar release];
	[flex release];
	[update release];
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
	myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, 320, 372)];
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
	[nameTxtField setText:[infoArray objectAtIndex:0]];
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
	[relationTxtField setText:[infoArray objectAtIndex:1]];
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
	[eventTxtField setText:[infoArray objectAtIndex:2]];
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
	
	y += gap+5;
	
	UIButton *additionalEvents = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[additionalEvents setFrame:CGRectMake(10, y, 300, 35)];
	[additionalEvents setTitle:@"Tap here to add/edit more events" forState:UIControlStateNormal];
	additionalEvents.titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
	[additionalEvents addTarget:self action:@selector(addMoreEvents) forControlEvents:UIControlEventTouchUpInside];
	[myScrollView addSubview:additionalEvents];
	
	y += gap+5;	
	
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
	[budgetTxtField1 setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[budgetTxtField1 setPlaceholder:@"$ From"];
 	[budgetTxtField1 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[budgetTxtField1 setAutocorrectionType:UITextAutocorrectionTypeNo];
	[budgetTxtField1 setBorderStyle:UITextBorderStyleRoundedRect];
	[budgetTxtField1 setText:[NSString stringWithFormat:@"$%@",[infoArray objectAtIndex:3]]];
 	[budgetTxtField1 setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	[budgetTxtField1 setFont:[UIFont systemFontOfSize:16]];
	[budgetTxtField1 setTextColor:[UIColor blackColor]];
	[myScrollView addSubview:budgetTxtField1];
	[budgetTxtField1 release];	
	
	budgetTxtField2 = [[UITextField alloc] initWithFrame:CGRectMake(165,y,145, 30)];
	[budgetTxtField2 setDelegate:self];
	[budgetTxtField2 setTag:101];
	[budgetTxtField2 setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[budgetTxtField2 setPlaceholder:@"$ To"];
 	[budgetTxtField2 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[budgetTxtField2 setAutocorrectionType:UITextAutocorrectionTypeNo];
	[budgetTxtField2 setBorderStyle:UITextBorderStyleRoundedRect];
	[budgetTxtField2 setText:[NSString stringWithFormat:@"$%@",[infoArray objectAtIndex:4]]];
 	[budgetTxtField2 setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	[budgetTxtField2 setFont:[UIFont systemFontOfSize:16]];
	[budgetTxtField2 setTextColor:[UIColor blackColor]];
	[myScrollView addSubview:budgetTxtField2];
	[budgetTxtField2 release];	
	
	y += gap;	
	
	// dob
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
	[dobTxtField setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[dobTxtField setPlaceholder:@"YYYY-MM-DD"];
	[dobTxtField setUserInteractionEnabled:NO];
 	[dobTxtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[dobTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[dobTxtField setBorderStyle:UITextBorderStyleRoundedRect];
	[dobTxtField setText:[infoArray objectAtIndex:5]];
 	[dobTxtField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
	[dobTxtField setFont:[UIFont systemFontOfSize:16]];
	[dobTxtField setTextColor:[UIColor blackColor]];
	[myScrollView addSubview:dobTxtField];
	[dobTxtField release];	
	
	[self setDateStr:[infoArray objectAtIndex:6]];
	
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
	
	stoneNumber = [[infoArray objectAtIndex:7]intValue];
	
	birthStoneImageView = [[ UIImageView alloc] initWithFrame:CGRectMake(180, y, 48, 48)];
	birthStoneImageView.layer.cornerRadius = 5;
	[birthStoneImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",stoneNumber]]];
	[myScrollView addSubview:birthStoneImageView];
	[birthStoneImageView release];
	
	y += gap;
	
	
	stoneNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(113,y+10,180,25)];		
	[stoneNameLabel setFont:[UIFont boldSystemFontOfSize:12]];
	[stoneNameLabel setTextColor:txtColor];
	[stoneNameLabel	setShadowColor:shadowColor];
    if(stoneNumber >=0 && stoneNumber <=11)
    {
        [stoneNameLabel setText:(((stoneNumber - 1) >=0)?[stoneNameArray objectAtIndex:(stoneNumber - 1)]:nil)];
    }
	[stoneNameLabel	setTextAlignment:UITextAlignmentCenter];
	[stoneNameLabel setShadowOffset:CGSizeMake(0,1)];
	[stoneNameLabel setBackgroundColor:[UIColor clearColor]];
	[myScrollView addSubview:stoneNameLabel];
	[stoneNameLabel release];
	
	y += gap;
	
    if(VERSION == 1 || VERSION == 2)
    {
        askQtnAboutStone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [askQtnAboutStone setFrame:CGRectMake(10, y, 300, 35)];
        [askQtnAboutStone setTitle:[NSString stringWithFormat:@"Ask a question about %@",(((stoneNumber - 1) >=0)?[stoneNameArray objectAtIndex:(stoneNumber - 1)]:nil)] forState:UIControlStateNormal];
        askQtnAboutStone.titleLabel.numberOfLines =2;
        askQtnAboutStone.titleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
        [askQtnAboutStone addTarget:self action:@selector(askAQuestion) forControlEvents:UIControlEventTouchUpInside];
        [myScrollView addSubview:askQtnAboutStone];        
        
        y += gap;
    }
	
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
		[checkbox setImage:((jewelColor[i-1] == 0)?[UIImage imageNamed:@"checkbox.png"]:[UIImage imageNamed:@"checked.png"])];
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
		[checkbox setImage:((jewelStyle[i-1] == 0)?[UIImage imageNamed:@"checkbox.png"]:[UIImage imageNamed:@"checked.png"])];
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
		[checkbox setImage:((watchStyle[i-1] == 0)?[UIImage imageNamed:@"checkbox.png"]:[UIImage imageNamed:@"checked.png"])];
		[myScrollView addSubview:checkbox];
		[checkbox release];		
		
		y +=gap;
		
	}	
	
	
	[myScrollView setContentSize:CGSizeMake(320, y+gap)];	
	[self.view addSubview:myScrollView];
	[myScrollView release];
}



- (void) loadShareView
{
	shareView = [[UIView alloc] initWithFrame:CGRectMake(0,416,320,416)];
	//[shareView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
	
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,320) style:UITableViewStyleGrouped];
	[myTable setBackgroundColor:[UIColor clearColor]];
	[myTable setDelegate:self];
	[myTable setDataSource:self];
	[myTable setSeparatorColor:[UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0]];
	[shareView addSubview:myTable];
	[self.view addSubview:shareView];
	
	UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[shareButton setFrame:CGRectMake(100, 380, 120 , 30)];
	[shareButton setTitle:@"Share" forState:UIControlStateNormal];
	[shareButton addTarget:self action:@selector(sharePSA) forControlEvents:UIControlEventTouchUpInside];
	[shareView addSubview:shareButton];
		
	[myTable release];
	[shareView release];
}

#pragma mark -


#pragma mark Button Action
- (void) animateShareView
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	if(isShareViewUP)
	{
		[self.navigationItem setTitle:@"Update Person"];
		[myScrollView setHidden:NO];
		isShareViewUP = NO;
		[shareView setFrame:CGRectMake(0,416,320,416)];
	}
	else 
	{
		[self.navigationItem setTitle:@"Share"];
		[myScrollView setHidden:YES];
		isShareViewUP = YES;
		[shareView setFrame:CGRectMake(0,0,320,416)];
	}
	[UIView commitAnimations];
}

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

- (void) addMoreEvents
{
	AddMoreEventsVC *o = [[AddMoreEventsVC alloc] init];
	[o setRowid:rowid];
	[self.navigationController pushViewController:o animated:YES];
	[o release];
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
	NSLog(@"tag - %d",tag);
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
	NSLog(@"date selected - %@",[dateFormatter stringFromDate:[sender date]]);
	[birthStoneImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",stoneNumber]]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
	[self setDateStr:[dateFormatter stringFromDate:[sender date]]];
	[dateFormatter setDateFormat:@"MM-dd-yyyy"];
	[dobTxtField setText:[dateFormatter stringFromDate:[sender date]]];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	psaSharedRowid = [indexPath row];
	[self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.3];
}
#pragma mark -

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [jewelersArray count];
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
		[titleLabel setFrame:CGRectMake(20,5,250,30)];
		[titleLabel setNumberOfLines:3];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		//[titleLabel setTextAlignment:UITextAlignmentRight];
		[cell addSubview:titleLabel];
		[titleLabel release];	
	}
	
	UILabel *titleLabel = (UILabel*)[cell viewWithTag:101];
	[titleLabel setText:[[jewelersArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
	
	if(indexPath.row == psaSharedRowid) [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	else [cell setAccessoryType:UITableViewCellAccessoryNone];
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

#pragma mark -
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

#pragma mark SQLITE Access  
- (void) getDataFromDB
{
	infoArray = [[NSMutableArray alloc] init];
	MySQLite *o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	[o readDb:[NSString stringWithFormat:@"select * from personalshopping where id='%d'",rowid]];
	while([o hasNextRow])
	{
		for(int i = 0 ; i < 8 ; i++)
		{
			[infoArray addObject:[o getColumn:i+1 type:@"text"]];
		}	
	}
	[o closeDb];
	[o release];	
	
	o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	[o readDb:[NSString stringWithFormat:@"select * from jewelcolor where id='%d'",rowid]];
	if([o hasNextRow])
	{
		for(int i = 0 ; i < [jewelColorArray count] ; i++)
		{
			jewelColor[i] = [[o getColumn:i+1 type:@"text"] intValue];
		}
	}
	[o closeDb];
	[o release];	
	
	o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	[o readDb:[NSString stringWithFormat:@"select * from jewelstyle where id='%d'",rowid]];
	if([o hasNextRow])
	{
		for(int i = 0 ; i < [jewelStyleArray count] ; i++)
		{
			jewelStyle[i] = [[o getColumn:i+1 type:@"text"] intValue];
		}		
	}
	[o closeDb];
	[o release];	
	
	o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	[o readDb:[NSString stringWithFormat:@"select * from watchstyle where id='%d'",rowid]];
	if([o hasNextRow])
	{
		for(int i = 0 ; i < [watchStyleArray count] ; i++)
		{
			watchStyle[i] = [[o getColumn:i+1 type:@"text"] intValue];
		}		
	}
	[o closeDb];
	[o release];		
	
	//[self performSelector:@selector(loadScrollView) withObject:nil afterDelay:2];
	[self loadScrollView];
}

- (void) getJewelersList
{
	if(jewelersArray !=nil)
	{
		[jewelersArray release];
	}
	
	jewelersArray = [[NSMutableArray alloc] init];
	
	MySQLite *o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	[o readDb:@"select qid,fromid,name from qatable group by fromid"];
	while([o hasNextRow])
	{
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setObject:[o getColumn:0 type:@"text"] forKey:@"qid"];
		[dict setObject:[o getColumn:1 type:@"text"] forKey:@"fromid"];
		[dict setObject:[o getColumn:2 type:@"text"] forKey:@"name"];
		[jewelersArray addObject:dict];
		[dict release];
	}
	[o closeDb];
	[o release];	
}

#pragma mark -
#pragma mark ASI support
- (void) updatePSA
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	//[activityIndicator startAnimating];
	isUpdatePSA = YES;
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
	
	NSMutableString *budget1 = [[NSMutableString alloc] initWithString:[budgetTxtField1	text]];
	[budget1 replaceOccurrencesOfString:@"$" withString:@"" options:1 range:NSMakeRange(0, [budget1 length])];

	NSMutableString *budget2 = [[NSMutableString alloc] initWithString:[budgetTxtField2	text]];
	[budget2 replaceOccurrencesOfString:@"$" withString:@"" options:1 range:NSMakeRange(0, [budget2 length])];

	
	//MyJewelerAppDelegate *appDelegate = (MyJewelerAppDelegate*) [[UIApplication sharedApplication] delegate];
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/psa.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:@"1" forKey:@"option"];
	[req setPostValue:[NSString stringWithFormat:@"%d",rowid] forKey:@"id"];
	[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"] forKey:@"myid"];
	[req setPostValue:(([[nameTxtField text]length] > 0)?[nameTxtField text]:@"NA") forKey:@"name"];  // fromid and toid interchanged
	[req setPostValue:(([[relationTxtField text]length] > 0)?[relationTxtField text]:@"NA") forKey:@"relationship"];
	[req setPostValue:(([[eventTxtField text]length] > 0)?[eventTxtField text]:@"NA") forKey:@"eventname"];
	[req setPostValue:(([budget1 length] > 0)?budget1:@"NA") forKey:@"budget1"];
	[req setPostValue:(([budget2 length] > 0)?budget2:@"NA") forKey:@"budget2"];
	[req setPostValue:(([dateStr length] > 0)?dateStr:@"NA") forKey:@"dob"];
	[req setPostValue:tempJewelColorStr forKey:@"jewelcolor"];
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
	[budget1 release];
	[budget2 release];
}

- (void) sharePSA
{
	if(psaSharedRowid >= 0)
	{
		isUpdatePSA = NO;
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/share.php",URL]];
		ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
		[req setPostValue:[[jewelersArray objectAtIndex:psaSharedRowid] objectForKey:@"qid"] forKey:@"qid"];
		[req setPostValue:[[jewelersArray objectAtIndex:psaSharedRowid] objectForKey:@"fromid"] forKey:@"jid"];
		[req setPostValue:[NSString stringWithFormat:@"%d",rowid] forKey:@"psaid"];
		[req setDelegate:self];
		[req startAsynchronous];		
	}
	else 
	{
		[self animateShareView];
	}
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	//[activityIndicator stopAnimating];
	NSLog(@"response - %@",[request responseString]);
	if(isUpdatePSA)
	{
		if([[request responseString] isEqualToString:@"SUCCESS"])
		{
			[self performSelector:@selector(saveToDB) withObject:nil afterDelay:0.3];
		}
		else if([[request responseString] isEqualToString:@"FAILED"])
		{
			
		}	
	}
	else {
		[self animateShareView];
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	//[activityIndicator stopAnimating];
}

#pragma mark -


#pragma mark Save

- (void) saveToDB
{
	NSMutableString *budget1 = [[NSMutableString alloc] initWithString:[budgetTxtField1	text]];
	[budget1 replaceOccurrencesOfString:@"$" withString:@"" options:1 range:NSMakeRange(0, [budget1 length])];
	
	NSMutableString *budget2 = [[NSMutableString alloc] initWithString:[budgetTxtField2	text]];
	[budget2 replaceOccurrencesOfString:@"$" withString:@"" options:1 range:NSMakeRange(0, [budget2 length])];
	
	
	NSMutableString *query1 = [[NSMutableString alloc] initWithString:@"update personalshopping set "];
	[query1 appendFormat:@"c1 = '%@', c2 = '%@', c3 = '%@', c4 = '%@', c5 = '%@', c6 = '%@', c7 = '%@',  c8 = '%d' where id= '%d'",(([[nameTxtField text]length] > 0)?[nameTxtField text]:@"NA"),(([[relationTxtField text]length] > 0)?[relationTxtField text]:@"NA"), (([[eventTxtField text]length] > 0)?[eventTxtField text]:@"NA"), (([budget1 length] > 0)?budget1:@"NA"), (([budget2 length] > 0)?budget2:@"NA"), (([[dobTxtField text]length] > 0)?[dobTxtField text]:@"NA"),(([dateStr length] > 0)?dateStr:@"NA"),stoneNumber,rowid];
	
	NSMutableString *query2 = [[NSMutableString alloc] initWithString:@"update jewelcolor set "];
	[query2 appendFormat:@"c1 = '%d', c2 = '%d', c3 = '%d', c4 = '%d' where id = '%d'", jewelColor[0],jewelColor[1],jewelColor[2],jewelColor[3], rowid];
	
	NSMutableString *query3 = [[NSMutableString alloc] initWithString:@"update jewelstyle set "];
	[query3 appendFormat:@"c1 = '%d', c2 = '%d', c3 = '%d', c4 = '%d', c5 = '%d', c6 = '%d', c7 = '%d' where id = '%d'", jewelStyle[0],jewelStyle[1],jewelStyle[2],jewelStyle[3],jewelStyle[4],jewelStyle[5], jewelStyle[6], rowid];
	
	NSMutableString *query4 = [[NSMutableString alloc] initWithString:@"update watchstyle set "];
	[query4 appendFormat:@"c1 = '%d', c2 = '%d', c3 = '%d', c4 = '%d', c5 = '%d', c6 = '%d', c7 = '%d', c8 = '%d', c9 = '%d', c10 = '%d', c11 = '%d', c12 = '%d', c13 = '%d', c14 = '%d', c15 = '%d', c16 = '%d', c17 = '%d', c18 = '%d', c19 = '%d', c20 = '%d', c21 = '%d', c22 = '%d', c23 = '%d', c24 = '%d', c25 = '%d', c26 = '%d' where id = '%d'", watchStyle[0],watchStyle[1],watchStyle[2],watchStyle[3],watchStyle[4],watchStyle[5], watchStyle[6],watchStyle[7],watchStyle[8],watchStyle[9],watchStyle[10],watchStyle[11], watchStyle[12],watchStyle[13],watchStyle[14],watchStyle[15],watchStyle[16],watchStyle[17], watchStyle[18],watchStyle[19],watchStyle[20],watchStyle[21],watchStyle[22],watchStyle[23],watchStyle[24], watchStyle[25], rowid];
	
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
	[budget1 release];
	[budget2 release];
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
	AskJeweler *o = [[AskJeweler alloc] init];
	[o setQuestionStr:[NSString stringWithFormat:@"I would like to know about %@",[stoneNameArray objectAtIndex:stoneNumber-1]]];
	[self.navigationController pushViewController:o animated:YES];
	[o release];	
}

- (void) reloadTable
{
	[myTable reloadData];
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
	if(jewelersArray !=nil)
	{
		[jewelersArray release];
	}	
	[dateStr release];
	[dateFormatter release];
	[stoneNameArray release];
	[infoArray release];
	[relationArray release];
	[eventsArray release];
	[jewelColorArray release];
	[jewelStyleArray release];
	[watchStyleArray release];
    [super dealloc];
}


@end
