    //
//  DetailedAnswersVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 1/29/11.
//  Copyright 2011 no. All rights reserved.
//

#import "DetailedAnswersVC.h"
#import "JewelerInfoVC.h"
#import "AttachmentVC.h"
#import "Constants.h"

#define CELL_WIDTH 290.0;
#define boundary  @"--------75023658052007"

@implementation DetailedAnswersVC
@synthesize infoDict;
@synthesize delegate;
@synthesize isBannerAnimating;

static	 int attachmentNumber;

- (void)dealloc 
{
    [banner release];
	if(answersArray!=nil)
	{
		[answersArray release];
	}
	[activityIndicator release];
	[infoDict release];
	[containerView release];
	[view1 release];
	[view2 release];
	[infoItem release];
	[cancelMsgItem release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    isBannerAnimating = YES;
    loadFirstBanner = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
    [self performSelector:@selector(animateBanner) withObject:nil afterDelay:ANIMATE_BANNER_AFTER_DELAY];

	[[NSUserDefaults standardUserDefaults] setInteger:23 forKey:@"page"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	[self getAnswers];
}

- (void) viewWillDisappear:(BOOL)animated  
{
    isBannerAnimating = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBanner) object:nil];    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    loadFirstBanner = YES;
    isInfoVisible = NO;

	[self.view setBackgroundColor:[UIColor clearColor]];
//	[self setTitle:[infoDict objectForKey:@"name"]];
    
	attachmentNumber = 0;
	containerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,367)];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [containerView setFrame:CGRectMake(0,0,320,448)];
    }
	[containerView setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:containerView];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicator setCenter:CGPointMake(160, 320)];
	[self.view addSubview:activityIndicator];
	
	transitioning = NO;
	
	UIButton *info = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[info addTarget:self action:@selector(loadInfoView) forControlEvents:UIControlEventTouchUpInside];
	
	infoItem = [[UIBarButtonItem alloc] initWithCustomView:info];
	[self.navigationItem setRightBarButtonItem:infoItem];
	
	cancelMsgItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(nextTransition)];
	
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


	[self loadView2];
	[self loadView1];
	
    [self prepareInfoView];

    [super viewDidLoad];
}

- (void) loadView1
{
	view1 = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,416)];
	[view1 setBackgroundColor:[UIColor clearColor]];
	[view1 setUserInteractionEnabled:YES];
	
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,300) style:UITableViewStylePlain];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [view1 setFrame:CGRectMake(0,0,320,448)];
        [myTable setFrame:CGRectMake(0,0,320,300 + 88)];
    }
	[myTable setDelegate:self];
	[myTable setDataSource:self];
	[myTable setBackgroundColor:[UIColor clearColor]];
	[myTable setSeparatorColor:[UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0]];
	[view1 addSubview:myTable];
	[myTable release];	
	
	UIImage *buttonImg = [UIImage imageNamed:@"reply_button.png"];
	UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake((320-buttonImg.size.width)/2,300,buttonImg.size.width,buttonImg.size.height)];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [add setFrame:CGRectMake((320-buttonImg.size.width)/2,300+88,buttonImg.size.width,buttonImg.size.height)];
    }

	[add setImage:buttonImg forState:UIControlStateNormal];
	[add addTarget:self action:@selector(nextTransition) forControlEvents:UIControlEventTouchUpInside];
	[view1 addSubview:add];
	[add release];
	
	[containerView addSubview:view1];	
}

- (void) loadView2
{
	view2 = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,416)];
	[view2 setBackgroundColor:[UIColor clearColor]];
	[view2 setUserInteractionEnabled:YES];
	[view2 setHidden:YES];
    if([[MyJewelerAppDelegate sharedInstance] isIPhone5])
    {
        [view2 setFrame:CGRectMake(0,0,320,448)];
    }
	answerTxtView = [[UITextView alloc] initWithFrame:CGRectMake(10,10,300, 150)];
	[answerTxtView setDelegate:self];
	[answerTxtView setTag:102];
	[answerTxtView setScrollsToTop:YES];
	[answerTxtView setEditable:YES];
	answerTxtView.layer.cornerRadius =7;
	[answerTxtView setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[answerTxtView setAutocorrectionType:UITextAutocorrectionTypeNo];
	[answerTxtView setKeyboardType:UIKeyboardTypeDefault];
	[answerTxtView setReturnKeyType:UIReturnKeySend];
	[answerTxtView setFont:[UIFont systemFontOfSize:14]];
	[answerTxtView setTextColor:[UIColor blackColor]];
	[view2 addSubview:answerTxtView];
	[answerTxtView release];	
	
	attachButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[attachButton setTitle:@"Attach file/photo" forState:UIControlStateNormal];
	attachButton.titleLabel.font = [UIFont systemFontOfSize:12];
	[attachButton addTarget:self action:@selector(attachFiles) forControlEvents:UIControlEventTouchUpInside];
	[attachButton setFrame:CGRectMake(10,170,100,20)];
	[view2 addSubview:attachButton];
	
	attachCount = [[UILabel alloc] init];		
	[attachCount setTag:111];
	[attachCount setFrame:CGRectMake(110,170,100,20)];
	[attachCount setFont:[UIFont systemFontOfSize:12]];
	[attachCount setText:@"0 Files attached"];
    [attachCount setTextAlignment:UITextAlignmentCenter];
	[attachCount setTextColor:[UIColor whiteColor]];
	[attachCount setBackgroundColor:[UIColor clearColor]];
	[view2 addSubview:attachCount];
	[attachCount release];
    
    UIButton *deleteAttachment = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[deleteAttachment setTitle:@"Delete" forState:UIControlStateNormal];
	deleteAttachment.titleLabel.font = [UIFont systemFontOfSize:12];
	[deleteAttachment addTarget:self action:@selector(deleteAttachment) forControlEvents:UIControlEventTouchUpInside];
	[deleteAttachment setFrame:CGRectMake(210,170,100,20)];
	[view2 addSubview:deleteAttachment];


	[containerView addSubview:view2];		
}

- (void) loadInfoView
{
	JewelerInfoVC *o = [[JewelerInfoVC alloc] init];
	[o setUserID:[infoDict objectForKey:@"fromid"]];
	[self.navigationController pushViewController:o animated:YES];
	[o release];
}

-(void)performTransition
{
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

	// First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 3/4 of a second
	transition.duration = 0.75;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	// Now to set the type of transition. Since we need to choose at random, we'll setup a couple of arrays to help us.
	NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
	NSString *subtypes[4] = {kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
	int rnd = random() % 4;
	transition.type = types[rnd];
	if(rnd < 3) // if we didn't pick the fade transition, then we need to set a subtype too
	{
		transition.subtype = subtypes[random() % 4];
	}
	
	// Finally, to avoid overlapping transitions we assign ourselves as the delegate for the animation and wait for the
	// -animationDidStop:finished: message. When it comes in, we will flag that we are no longer transitioning.
	transitioning = YES;
	transition.delegate = self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[containerView.layer addAnimation:transition forKey:nil];
	
	// Here we hide view1, and show view2, which will cause Core Animation to animate view1 away and view2 in.
	view1.hidden = YES;
	view2.hidden = NO;
	
	// And so that we will continue to swap between our two images, we swap the instance variables referencing them.
	UIView *tmp = view2;
	view2 = view1;
	view1 = tmp;
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	transitioning = NO;
}

-(void)nextTransition
{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
	if(transitioning)
	{
		transitioning = NO;
		[view1 setHidden:NO];
		[view2 setHidden:YES];
		[answerTxtView resignFirstResponder];
		[self.navigationItem setTitle:[infoDict objectForKey:@"name"]];
		[self.navigationItem setRightBarButtonItem:infoItem];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:containerView cache:YES];		
	}
	else 
	{
		transitioning = YES;
		[view1 setHidden:YES];
		[view2 setHidden:NO];		
		attachmentNumber = 0;
		[attachCount setText:@"0 Files attached"];
		[answerTxtView setText:nil];
		[answerTxtView becomeFirstResponder];
		[self.navigationItem setTitle:@"Reply"];
		[self.navigationItem setRightBarButtonItem:cancelMsgItem];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:containerView cache:YES];	
	}
	[UIView commitAnimations];
	
}

- (void) deleteAttachment
{
    attachmentNumber = attachmentNumber - 1;
    if(attachmentNumber < 0) attachmentNumber = 0;
    [attachCount setText:[NSString stringWithFormat:@"%d Files attached",attachmentNumber]];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return ((cellHeight[indexPath.row] > 70.0) ? cellHeight[indexPath.row] + 30.0 : 70.0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at1"] length] > 3) ||
		([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at2"] length] > 3)	||
		([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at3"] length] > 3)	||
		([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at4"] length] > 3)	||
		([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at5"] length] > 3)	)
	{
		AttachmentVC *o = [[AttachmentVC alloc] init];
		[o setTitle:@"Attachments"];
		
		NSMutableArray *arr = [[NSMutableArray alloc] init];
		if([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at1"] length] > 3)
		{ [arr addObject:[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at1"] ]; }
	
		if([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at2"] length] > 3)
		{ [arr addObject:[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at2"] ]; }
		
		if([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at3"] length] > 3)
		{ [arr addObject:[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at3"] ]; }
		
		if([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at4"] length] > 3)
		{ [arr addObject:[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at4"] ]; }
		
		if([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at5"] length] > 3)
		{ [arr addObject:[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at5"] ]; }
		
		[o setAttachmentArr:arr];
		[o setQid:[[answersArray objectAtIndex:indexPath.row] objectForKey:@"qid"]];
		[self.navigationController pushViewController:o animated:YES];
		[o release];
		[arr release];
	}
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [answersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"cellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(cell == nil)
	{
		cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];

		// for  Answers
		UILabel *answerLabel = [[UILabel alloc] init];		
		[answerLabel setTag:101];
		[answerLabel setFrame:CGRectMake(10,5,290,50)];
		[answerLabel setNumberOfLines:4];
		[answerLabel setFont:[UIFont systemFontOfSize:13]];
		[answerLabel setTextColor:[UIColor whiteColor]];
		[answerLabel setBackgroundColor:[UIColor clearColor]];
		[cell addSubview:answerLabel];
		[answerLabel release];
 
		// jeweler name
		UILabel *jeweler = [[UILabel alloc] init];		
		[jeweler setTag:102];
		[jeweler setFrame:CGRectMake(10,52,290,15)];
		[jeweler setFont:[UIFont boldSystemFontOfSize:12]];
		[jeweler setTextColor:[UIColor orangeColor]];
		[jeweler setTextAlignment:UITextAlignmentRight];
		[jeweler setBackgroundColor:[UIColor clearColor]];
		[cell addSubview:jeweler];
		[jeweler release];
		
		// attachment
		UILabel *attachment = [[UILabel alloc] init];		
		[attachment setTag:103];
		attachment.layer.cornerRadius = 5;
		[attachment setFrame:CGRectMake(10,52,100,15)];
		[attachment setFont:[UIFont systemFontOfSize:12]];
		[attachment setTextColor:[UIColor whiteColor]];
		[attachment setTextAlignment:UITextAlignmentCenter];
		[attachment setBackgroundColor:[UIColor colorWithRed:(63.0/255.0) green:(146.0/255.0) blue:(157.0/255.0) alpha:1.0]];
		[cell addSubview:attachment];
		[attachment release];	
		
	}
	
	CGSize	textSize = { 290.0, cellHeight[indexPath.row]-10 };
	
	// answer label
	UILabel *answerLabel = (UILabel*)[cell viewWithTag:101];
	
	NSMutableString	*msg = [[NSMutableString alloc] initWithString:[[answersArray objectAtIndex:indexPath.row] objectForKey:@"msg"]];
	[msg replaceOccurrencesOfString:@"_SQ_" withString:@"'" options:1 range:NSMakeRange(0, [msg length])];
	[msg replaceOccurrencesOfString:@"_DQ_" withString:@"\"" options:1 range:NSMakeRange(0, [msg length])];
	
	CGSize size = [msg sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
	//calculating the number of lines
	int lines  = [msg length] / 30;
	if([msg length]%30 > 1) {
		lines =lines+1;
	}
	[answerLabel setNumberOfLines:lines];
	[answerLabel setFrame:CGRectMake(10.0, 5.0, size.width, size.height+15)];
	[answerLabel setText:msg];
		
	// Jeweler name label
	float lHeight = answerLabel.frame.size.height;
	UILabel *jeweler = (UILabel*)[cell viewWithTag:102];
	[jeweler setFrame:CGRectMake(10,((lHeight > 70.0)? lHeight+10:52),290,15)];
	[jeweler setText:[[answersArray objectAtIndex:indexPath.row] objectForKey:@"name"]];

	UILabel *attachment = (UILabel*) [cell viewWithTag:103];
	if (([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at1"] length] > 3) ||
		([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at2"] length] > 3)	||
		([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at3"] length] > 3)	||
		([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at4"] length] > 3)	||
		([[[answersArray objectAtIndex:indexPath.row] objectForKey:@"at5"] length] > 3)	)
	{
		[attachment setBackgroundColor:[UIColor colorWithRed:(63.0/255.0) green:(146.0/255.0) blue:(157.0/255.0) alpha:1.0]];
		[attachment setText:@"Attachment"];
	}
	else 
	{
		[attachment setBackgroundColor:[UIColor clearColor]];
		[attachment setText:nil];
	}

	[msg release];
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	/// Calculate the table-height
	if ( [answersArray count] > 0) 
	{
		CGSize	textSize = { 290.0, 200.0 };		// width and height of text area
		for (int i = 0; i < [answersArray count]; i++) 
		{
			NSString *msg = [[answersArray objectAtIndex:i] objectForKey:@"msg"];
			CGSize size = [msg sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
			cellHeight[i] = MAX(size.height, 30.0);
		}
	}
    return 1;
}

-(void) tableViewScrollsToBottom 
{	
	if ([answersArray count] > 4) 
	{
		NSUInteger a[2];
		a[0] = 0;
		a[1] = [answersArray count]-1;	
		NSIndexPath *lastRow = [NSIndexPath indexPathWithIndexes:a length:2];		
		[myTable scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if ( [ text isEqualToString: @"\n" ] ) 
	{
		if ([[textView text] length] > 0)
		{
			[ textView resignFirstResponder ];
			[self performSelector:@selector(sendMessage) withObject:nil afterDelay:0.3];
		}
		else 
		{
			[self performSelector:@selector(nextTransition) withObject:nil afterDelay:0.3];
		}
		return NO;
	}
	return YES;
}
#pragma mark -

#pragma mark Attach Files
- (void) attachFiles
{
	UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Attach files from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gallery", @"Camera", nil];
	[alert showInView:self.view];
	[alert release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"buttonIndex - %d",buttonIndex);
	if(buttonIndex == 0){
		printf(" Images selected from Photo library \n");
		UIImagePickerController *imgPick = [[UIImagePickerController alloc] init];
		imgPick.delegate = self;
		imgPick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[self presentModalViewController:imgPick animated:YES];
		[[imgPick parentViewController] dismissModalViewControllerAnimated:YES];
		[imgPick release];
	}else if(buttonIndex == 1) {
		if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {			
			printf(" Images selected from Camera \n");
			UIImagePickerController *imgPick = [[UIImagePickerController alloc] init];
			imgPick.sourceType =  UIImagePickerControllerSourceTypeCamera;
			imgPick.delegate = self;
			//	imgPick.allowsImageEditing = YES;
			[self presentModalViewController:imgPick animated:YES];
			[[imgPick parentViewController] dismissModalViewControllerAnimated:YES];
			[imgPick release];
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"This feature is not available in this device" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	UIImage *croppedImage;
	switch ([picker sourceType])
    {
        case UIImagePickerControllerSourceTypePhotoLibrary:
			[[picker parentViewController] dismissModalViewControllerAnimated:YES];
			croppedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
			croppedImage = [croppedImage thumbnailImage:320 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationNone];
			break;
			
		case UIImagePickerControllerSourceTypeCamera: 
			[[picker parentViewController] dismissModalViewControllerAnimated:YES];
			croppedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
			croppedImage = [croppedImage thumbnailImage:320 transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationNone];
			break;
	}
	
	attachmentNumber = attachmentNumber +1;
	NSString *filename =[NSString stringWithFormat:@"%d.jpg",attachmentNumber];  //FIX HERE
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(croppedImage)];
	[imageData writeToFile:filePath atomically:YES];
	
	[attachCount setText:((attachmentNumber > 1)?[NSString stringWithFormat:@"%d Files attached",attachmentNumber]:[NSString stringWithFormat:@"1 File attached"])];
	
	if(attachmentNumber > 4)
	{
		[attachButton setEnabled:NO];
	}
	else 
	{
		[attachButton setEnabled:YES];
	}
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


#pragma mark SQLITE ACCESS 
- (void) getAnswers
{
	if(answersArray !=nil)
	{
		[answersArray removeAllObjects];
		[answersArray release];
	}
	
	answersArray = [[NSMutableArray alloc] init];
	
	MySQLite *o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	[o readDb:[NSString stringWithFormat:@"Select * from qatable where qid = '%@' and fromid ='%@' order by date_time",[infoDict objectForKey:@"qid"],[infoDict objectForKey:@"fromid"]]];
	while([o hasNextRow])
	{
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setObject:[o getColumn:0 type:@"text"] forKey:@"qid"];
		[dict setObject:[o getColumn:1 type:@"text"] forKey:@"fromid"];
		[dict setObject:[o getColumn:2 type:@"text"] forKey:@"name"];
		[dict setObject:[o getColumn:3 type:@"text"] forKey:@"toid"];
		[dict setObject:[o getColumn:4 type:@"text"] forKey:@"date_time"];
		[dict setObject:[o getColumn:5 type:@"text"] forKey:@"type"];
		[dict setObject:[o getColumn:6 type:@"text"] forKey:@"msg"];
		[dict setObject:[o getColumn:7 type:@"text"] forKey:@"qcount"];
		[dict setObject:[o getColumn:8 type:@"text"] forKey:@"at1"];
		[dict setObject:[o getColumn:9 type:@"text"] forKey:@"at2"];
		[dict setObject:[o getColumn:10 type:@"text"] forKey:@"at3"];
		[dict setObject:[o getColumn:11 type:@"text"] forKey:@"at4"];
		[dict setObject:[o getColumn:12 type:@"text"] forKey:@"at5"];
		[answersArray addObject:dict];
		[dict release];		
	}
	[o closeDb];
	[o release];
	[myTable reloadData];[myTable reloadData];[myTable reloadData];
	
	//----------- reset the qcount
	o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	[o readDb:[NSString stringWithFormat:@"update qatable set qcount = 0 where qid = '%@'",[infoDict objectForKey:@"qid"]]];
	[o hasNextRow];
	[o closeDb];
	[o release];
	//-----------
	
	//---------- reset count in question table
	o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	[o readDb:[NSString stringWithFormat:@"select count(*) from qatable where qcount > 0 and qid = '%@'",[infoDict objectForKey:@"qid"]]];
	int count;
	if([o hasNextRow]) count = [[o getColumn:0 type:@"text"] intValue];
	else count = 0;
	[o closeDb];
	[o release];
	
	if(count == 0)
	{
		o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
		[o openDb];
		[o readDb:[NSString stringWithFormat:@"update questions set qcount=0 where id = '%@'",[infoDict objectForKey:@"qid"]]];
		[o hasNextRow];
		[o closeDb];
		[o release];		
	}
	//------------
	
	[self performSelector:@selector(tableViewScrollsToBottom) withObject:nil afterDelay:0.5];
}

- (void) saveAnswer:(NSString*) rowid dateTime:(NSString*)dateTime
{
	NSMutableString *answer = [[NSMutableString alloc] initWithString:[answerTxtView text]];
	[answer	replaceOccurrencesOfString:@"'" withString:@"_SQ_" options:1 range:NSMakeRange(0, [answer length])];
	[answer	replaceOccurrencesOfString:@"\"" withString:@"_DQ_" options:1 range:NSMakeRange(0, [answer length])];
	
//	MyJewelerAppDelegate *appDelegate = (MyJewelerAppDelegate*) [[UIApplication sharedApplication] delegate];  // type = 0 means Question, type = 1 means Answers
	MySQLite *o = [[MySQLite alloc] initWithSQLFile:@"MyJeweler.sqlite"];
	[o openDb];
	NSMutableString *query = [[NSMutableString	 alloc] initWithString:@"insert into qatable (qid, fromid, name, toid, date_time, type, msg, qcount, at1, at2, at3, at4, at5) "];
	if(attachmentNumber > 0)
	{
		NSString *at1 = @"NA"; NSString *at2 = @"NA"; NSString *at3 = @"NA"; NSString *at4 = @"NA"; NSString *at5 = @"NA";
		for (int i = 0 ; i < attachmentNumber ; i++)
		{
			if(i == 0) at1 = [NSString stringWithFormat:@"%@_1.jpg",rowid];
			else if(i == 1) at2 = [NSString stringWithFormat:@"%@_2.jpg",rowid];
			else if(i == 2) at3 = [NSString stringWithFormat:@"%@_3.jpg",rowid];
			else if(i == 3) at4 = [NSString stringWithFormat:@"%@_4.jpg",rowid];
			else if(i == 4) at5 = [NSString stringWithFormat:@"%@_5.jpg",rowid];
		}
		[query appendFormat:@"values ('%@','%@', 'Me', '%@','%@', 0,'%@', 0, '%@', '%@', '%@', '%@', '%@')",[infoDict objectForKey:@"qid"],[infoDict objectForKey:@"fromid"],[infoDict objectForKey:@"toid"],dateTime, answer,at1,at2,at3,at4,at5];
	}
	else 
	{
		[query appendFormat:@"values ('%@','%@', 'Me', '%@','%@', 0,'%@', 0, 0, 0, 0, 0, 0)",[infoDict objectForKey:@"qid"],[infoDict objectForKey:@"fromid"],[infoDict objectForKey:@"toid"],dateTime, answer];
	}
//	NSLog(@"query - %@",query);
	[o readDb:query];
	[o hasNextRow];
	[o closeDb];
	[o release];
	
	[query release];
	[answer release];
	
	[self getAnswers];
}

- (NSString*) getServerTime
{
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/getDateTime.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req start];
	return [req responseString];
}
#pragma mark -

#pragma mark DownloaderDelegate

- (void) refershDetailedAnswersVC
{
	//[self getAnswers];
	NSLog(@"need to refershDetailedAnswersVC");
}

#pragma mark -


#pragma mark ASI SUPPORT 
- (void) sendMessage
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[activityIndicator startAnimating];
	
	MyJewelerAppDelegate *appDelegate = (MyJewelerAppDelegate*) [[UIApplication sharedApplication] delegate];
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/sendMessage.php",URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:@"0" forKey:@"option"];
	[req setPostValue:[infoDict objectForKey:@"qid"] forKey:@"qid"];
	[req setPostValue:[infoDict objectForKey:@"toid"] forKey:@"fromid"];  // fromid and toid interchanged
	[req setPostValue:[infoDict objectForKey:@"fromid"] forKey:@"toid"];
	[req setPostValue:[appDelegate getDate:3] forKey:@"date_time"];
	[req setPostValue:@"0" forKey:@"type"];
	[req setPostValue:[answerTxtView text] forKey:@"msg"];
	[req setPostValue:@"0" forKey:@"hasAttachment"];

	if(attachmentNumber > 0)
	{
		NSString *filePath1,*filePath2,*filePath3,*filePath4,*filePath5;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *photoString = nil;
		
		for(int i = 0 ; i< attachmentNumber ; i++) {		
			photoString = [NSString stringWithFormat:@"%d.jpg",i+1];
			if(i == 0) {
				filePath1 = [documentsDirectory stringByAppendingPathComponent:photoString];
				filePath1 = [filePath1 stringByReplacingOccurrencesOfString:@"/.jpg" withString:@".jpg"];
				[req setFile:filePath1 forKey:@"photo1"];
			}
			if(i == 1) {
				filePath2 = [documentsDirectory stringByAppendingPathComponent:photoString];
				filePath2 = [filePath2 stringByReplacingOccurrencesOfString:@"/.jpg" withString:@".jpg"];
				printf("\n %d]: Image FilePath = %s\n",i+1,[filePath2 UTF8String]);
				[req setFile:filePath2 forKey:@"photo2"];
			}if(i == 2) {
				filePath3 = [documentsDirectory stringByAppendingPathComponent:photoString];
				filePath3 = [filePath3 stringByReplacingOccurrencesOfString:@"/.jpg" withString:@".jpg"];
				printf("\n %d]: Image FilePath = %s\n",i+1,[filePath3 UTF8String]);
				[req setFile:filePath3 forKey:@"photo3"];
			}if(i == 3) {				
				filePath4 = [documentsDirectory stringByAppendingPathComponent:photoString];
				filePath4 = [filePath4 stringByReplacingOccurrencesOfString:@"/.jpg" withString:@".jpg"];
				printf("\n %d]: Image FilePath = %s\n",i+1,[filePath4 UTF8String]);
				[req setFile:filePath4 forKey:@"photo4"];
			}if(i == 4) {
				filePath5 = [documentsDirectory stringByAppendingPathComponent:photoString];
				filePath5 = [filePath5 stringByReplacingOccurrencesOfString:@"/.jpg" withString:@".jpg"];
				printf("\n %d]: Image FilePath = %s\n",i+1,[filePath5 UTF8String]);
				[req setFile:filePath5 forKey:@"photo5"];
			}
		}
		[req setPostValue:@"1" forKey:@"hasAttachment"];
		[req setPostValue:[NSString stringWithFormat:@"%d",attachmentNumber] forKey:@"attachcount"];
	}
	
	[req setDelegate:self];
	[req startAsynchronous];
	NSError *error = [req error];
	if (!error) 
	{
		//NSLog(@"response -",[req responseString]);
	}
	[req release];
	[url release];	
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activityIndicator stopAnimating];
	NSLog(@"reply response - %@",[request responseString]);
	NSString *date_time = [self getServerTime];
	[self saveAnswer:[request responseString] dateTime:date_time];
	[self performSelector:@selector(nextTransition) withObject:nil afterDelay:0.3];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activityIndicator stopAnimating];
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
