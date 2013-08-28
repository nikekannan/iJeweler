    //
//  RegisterVC.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 28/01/11.
//  Copyright 2011 Deemag Infotech Pvt Ltd. All rights reserved.
//

#import "RegisterVC.h"
#import	"Constants.h"

@implementation RegisterVC

@synthesize nameStr;
@synthesize shopStr;
@synthesize emailStr;
@synthesize phoneStr;
@synthesize addrsStr;
@synthesize streetStr;
@synthesize cityStr;
@synthesize stateStr;
@synthesize zipStr;


static int keyboardTag;
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	isKeyBoardUp = NO;
	[self setTitle:@"Registration"];
	[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:41.0/255.0 green:32.0/255.0 blue:23.0/255.0 alpha:1.0]];
	[self setAddrsStr:[[NSUserDefaults standardUserDefaults] objectForKey:@"myaddrs"]];
	UIImage *logo = [UIImage imageNamed:@"logo.png"];
	UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 40)];
	[logoView setImage:logo];
	[self.navigationItem setTitleView:logoView];
	[logoView release];
	[self loadDefaultLogo];
	[self loadTable];	
	[self loadActivityIndicator];
    [super viewDidLoad];
}

- (void) loadTable
{
	myTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0,320,410) style:UITableViewStyleGrouped];
	[myTable setDelegate:self];
	[myTable setDataSource:self];
    [myTable setBackgroundView:nil];
	[myTable setBackgroundColor:[UIColor clearColor]];
	[myTable setSeparatorColor:[UIColor colorWithRed:124.0/255.0 green:99.0/255.0 blue:69.0/255.0 alpha:1.0]];
	[self.view addSubview:myTable];
	[myTable release];	
}

- (void) loadDefaultLogo
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *savedFile = [documentsDirectory stringByAppendingPathComponent:@"logo.png"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:savedFile]) { 	}
	else 
	{
		NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageNamed:@"diamond.png"])];
		[imageData writeToFile:savedFile atomically:YES];
	}
}

- (void) loadActivityIndicator
{
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityIndicator setCenter:CGPointMake(160,200)];
	[self.view addSubview:activityIndicator];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if( indexPath.section == 0 && indexPath.row == 0 )
	{
		return 80.0;
	}
	return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(indexPath.section == 2)
	{
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		//[self resignAllResponders];
	
		if( ((VERSION == 0) || (VERSION == 1)) && ([nameStr length] > 0) && ([shopStr length] > 0) && ([phoneStr length] > 0) && ( ([streetStr length] > 0) || ([cityStr length] > 0) || ([stateStr length] > 0) || ([zipStr length] > 0) ) )
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment Terms & Condition" message:@"\n\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Agreed",nil];
			
			UITextView *v = [[UITextView alloc] initWithFrame:CGRectMake(15,45,255,220)];
			//[v setBackgroundColor:[UIColor clearColor]];
			[v setEditable:NO];
			[v setUserInteractionEnabled:YES];
			[v.layer setCornerRadius:7.0];
			[v setFont:[UIFont systemFontOfSize:15]];
			[v setDataDetectorTypes:UIDataDetectorTypeAll];
			//[v setTextAlignment:UITextAlignmentCenter];
			if (VERSION == 1)
			{
				[v setText:@"iJeweler is a mobile application from GlobalOfficeX Network OR goXnetwork (the Service). This app is free for consumers but BUSINESSES are charged a monthly subscription fees. The subscription fees applicable to jewelers for use of the service is $10.99 per month. Please click on the following link www.goxnetwork.com/paypal.php to sign up. For your convenience we have already pre- programmed this section with the subscription fees, account details, amount to be charged, billing cycle and currency. You can use a credit card or your existing Paypal account. For our full and detailed terms and conditions please click here."];
			}
			[v setTextColor:[UIColor blackColor]];
			[alert addSubview:v];
			[v release];			
			
			[alert show];
			[alert setTag:999];
			[alert release];
			
			[self performSelector:@selector(resignAllResponders) withObject:nil afterDelay:0.3];
		}
		else if( VERSION == 2 && ([nameStr length] > 0) /*&& ([phoneStr length] > 0) && ([emailStr length] > 0) && ( ([streetStr length] > 0) || ([cityStr length] > 0) || ([stateStr length] > 0) || ([zipStr length] > 0) )*/ )
		{
			[self submit];			
			[self performSelector:@selector(resignAllResponders) withObject:nil afterDelay:0.3];
		}
		else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All fields are required" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if( (VERSION == 0) || (VERSION == 1) )
	{
		if(section == 0) return 2;
		else if (section == 1) return 5;		
	}
	else if (VERSION == 2)
	{
		if(section == 0) return 1;
		else if (section == 1) return 1;		
	}
	return 1;
//	return ((VERSION == 1)?((section == 0)? 2 : ((section == 1)? 5 : 1)): ((section == 0)? 1 : ((section == 1)? 1 : 1)));
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if(section == 0)
	{
		UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,30)];
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,180,25)];	
		[titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
		[titleLabel setText:@"Registration"];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[v addSubview:titleLabel];
		[titleLabel release];
		return v;
	}
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *cellIdentifier = @"cellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
	[cell setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	if(indexPath.section == 0)
	{
		if(indexPath.row == 0)
		{
			UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(10,0, 80, 80)];
			[photoButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
			photoButton.layer.cornerRadius = 7;
			photoButton.clipsToBounds = YES;
			[photoButton setTag:100];
			///////////////////////////////////////// logo image ///////////////////////////////////////////////
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *savedFile = [documentsDirectory stringByAppendingPathComponent:@"logo.png"];
			UIImage *image ;
			if ([[NSFileManager defaultManager] fileExistsAtPath:savedFile]) {
				image = [[UIImage alloc] initWithContentsOfFile:savedFile];
			} else {
				image = [[UIImage alloc] initWithCGImage:[[UIImage imageNamed:@"diamond.png"] CGImage]];
			}
			[photoButton setImage:image forState:UIControlStateNormal];
			[cell addSubview:photoButton];
			[photoButton release];
			[image release];
			
			nameTxtField = [[UITextField alloc] initWithFrame:CGRectMake(100,25,150, 30)];
			[nameTxtField setDelegate:self];
			[nameTxtField setTag:102];
			[nameTxtField setPlaceholder:@"Your name"];
			[nameTxtField setText:nameStr];
			[nameTxtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
			[nameTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
			[nameTxtField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[nameTxtField setKeyboardType:UIKeyboardTypeDefault];
			[nameTxtField setFont:[UIFont boldSystemFontOfSize:16]];
			[nameTxtField setTextColor:[UIColor whiteColor]];
			[cell addSubview:nameTxtField];
			[nameTxtField release];
		}
		else if (indexPath.row == 1)
		{
			UILabel *titleLabel = [[UILabel alloc] init];		
			[titleLabel setTag:111];
			[titleLabel setFrame:CGRectMake(10,7,80,25)];
			[titleLabel setFont:[UIFont systemFontOfSize:16]];
			[titleLabel setTextColor:[UIColor grayColor]];
			[titleLabel setBackgroundColor:[UIColor clearColor]];
			[titleLabel setTextAlignment:UITextAlignmentRight];
			[cell addSubview:titleLabel];
			[titleLabel release];				
			
			shopTxtField = [[UITextField alloc] initWithFrame:CGRectMake(100,5,200, 30)];
			[shopTxtField setDelegate:self];
			[shopTxtField setTag:103];
			[shopTxtField setText:shopStr];
			[shopTxtField setPlaceholder:@"Shop name"];
			[shopTxtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
 			[shopTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
			[shopTxtField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[shopTxtField setKeyboardType:UIKeyboardTypeEmailAddress];
			[shopTxtField setFont:[UIFont systemFontOfSize:16]];
			[shopTxtField setTextColor:[UIColor whiteColor]];
			[cell addSubview:shopTxtField];
			[shopTxtField release];				
		}
	}
	else if(indexPath.section == 1)
	{
		// for  title
		UILabel *titleLabel = [[UILabel alloc] init];		
		[titleLabel setTag:112];
		[titleLabel setFrame:CGRectMake(10,7,80,25)];
		[titleLabel setFont:[UIFont systemFontOfSize:16]];
		[titleLabel setTextColor:[UIColor grayColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextAlignment:UITextAlignmentRight];
		[cell addSubview:titleLabel];
		[titleLabel release];
		
		if (indexPath.row == 0)
		{
			phoneTxtField = [[UITextField alloc] initWithFrame:CGRectMake(100,5,200, 30)];
			[phoneTxtField setDelegate:self];
			[phoneTxtField setTag:105];
			[phoneTxtField setText:phoneStr];
			[phoneTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
			[phoneTxtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
 			[phoneTxtField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[phoneTxtField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
			[phoneTxtField setFont:[UIFont systemFontOfSize:16]];
			[phoneTxtField setTextColor:[UIColor whiteColor]];
			[cell addSubview:phoneTxtField];
			[phoneTxtField release];
			if( (VERSION == 0) || (VERSION == 1) )	{
				[titleLabel setText:@"Phone:"];
			}		
			else if(VERSION == 2)	{
				[titleLabel setText:@"Email:"];
				[phoneTxtField setKeyboardType:UIKeyboardTypeEmailAddress];
			}		
		}
		else if (indexPath.row == 1)
		{
			streetTxtField = [[UITextField alloc] initWithFrame:CGRectMake(100,5,200, 30)];
			[streetTxtField setDelegate:self];
			[streetTxtField setTag:106];
			[streetTxtField setText:streetStr];
			[streetTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
			[streetTxtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
 			[streetTxtField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[streetTxtField setKeyboardType:UIKeyboardTypeDefault];
			[streetTxtField setFont:[UIFont systemFontOfSize:16]];
			[streetTxtField setTextColor:[UIColor whiteColor]];
			[cell addSubview:streetTxtField];
			[streetTxtField release];
			
//			addrsTxtView = [[UITextView alloc] initWithFrame:CGRectMake(90,0,220, 75)];
//			[addrsTxtView setBackgroundColor:[UIColor clearColor]];
//			[addrsTxtView setDelegate:self];
//			[addrsTxtView setText:addrsStr];
//			[addrsTxtView setTag:106];
//			[addrsTxtView setScrollsToTop:YES];
//			[addrsTxtView setKeyboardAppearance:UIKeyboardAppearanceAlert];
//			[addrsTxtView setAutocorrectionType:UITextAutocorrectionTypeNo];
//			[addrsTxtView setKeyboardType:UIKeyboardTypeDefault];
//			[addrsTxtView setFont:[UIFont systemFontOfSize:13]];
//			[addrsTxtView setTextColor:[UIColor whiteColor]];
//			[cell addSubview:addrsTxtView];
//			[addrsTxtView release];			
			[titleLabel setText:@"Street:"];
		}
		else if (indexPath.row == 2)
		{
			cityTxtField = [[UITextField alloc] initWithFrame:CGRectMake(100,5,200, 30)];
			[cityTxtField setDelegate:self];
			[cityTxtField setTag:107];
			[cityTxtField setText:cityStr];
			[cityTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
			[cityTxtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
 			[cityTxtField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[cityTxtField setKeyboardType:UIKeyboardTypeDefault];
			[cityTxtField setFont:[UIFont systemFontOfSize:16]];
			[cityTxtField setTextColor:[UIColor whiteColor]];
			[cell addSubview:cityTxtField];
			[cityTxtField release];
			
			[titleLabel setText:@"City:"];
		}
		else if (indexPath.row == 3)
		{
			stateTxtField = [[UITextField alloc] initWithFrame:CGRectMake(100,5,200, 30)];
			[stateTxtField setDelegate:self];
			[stateTxtField setTag:108];
			[stateTxtField setText:stateStr];
			[stateTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
			[stateTxtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
 			[stateTxtField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[stateTxtField setKeyboardType:UIKeyboardTypeDefault];
			[stateTxtField setFont:[UIFont systemFontOfSize:16]];
			[stateTxtField setTextColor:[UIColor whiteColor]];
			[cell addSubview:stateTxtField];
			[stateTxtField release];
			
			[titleLabel setText:@"State:"];
		}
		else if (indexPath.row == 4)
		{
			zipTxtField = [[UITextField alloc] initWithFrame:CGRectMake(100,5,200, 30)];
			[zipTxtField setDelegate:self];
			[zipTxtField setTag:109];
			[zipTxtField setText:zipStr];
			[zipTxtField setAutocorrectionType:UITextAutocorrectionTypeNo];
			[zipTxtField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
 			[zipTxtField setKeyboardAppearance:UIKeyboardAppearanceAlert];
			[zipTxtField setKeyboardType:UIKeyboardTypeDefault];
			[zipTxtField setFont:[UIFont systemFontOfSize:16]];
			[zipTxtField setTextColor:[UIColor whiteColor]];
			[cell addSubview:zipTxtField];
			[zipTxtField release];
			
			[titleLabel setText:@"Zip Code:"];
		}
	}
	else 
	{
		[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
		// for  title
		UILabel *titleLabel = [[UILabel alloc] init];		
		[titleLabel setTag:113];
		[titleLabel setFrame:CGRectMake(10,5,300,30)];
		[titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextAlignment:UITextAlignmentCenter];
		[titleLabel setText:@"Submit"];
		[cell addSubview:titleLabel];
		[titleLabel release];			
	}
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}
				 
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[myTable setFrame:CGRectMake(0, 0, 320, 200)];
	isKeyBoardUp =YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
	keyboardTag = [textField tag];
	//[myTable setFrame:CGRectMake(0, 0, 320, 416)];
	if([textField tag] == 102 && [[textField text] length] > 0)			{		[self setNameStr:[textField text]];		}
	else if ([textField tag] == 103 && [[textField text] length] > 0)	{		[self setShopStr:[textField text]];		}
	else if ([textField tag] == 104 && [[textField text] length] > 0)	{		[self setEmailStr:[textField text]];	}
	else if ([textField tag] == 105 && [[textField text] length] > 0)	{		[self setPhoneStr:[textField text]];	}	
	else if ([textField tag] == 106 && [[textField text] length] > 0)	{		[self setStreetStr:[textField text]];	}	
	else if ([textField tag] == 107 && [[textField text] length] > 0)	{		[self setCityStr:[textField text]];		}	
	else if ([textField tag] == 108 && [[textField text] length] > 0)	{		[self setStateStr:[textField text]];	}	
	else if ([textField tag] == 109 && [[textField text] length] > 0)	{		[self setZipStr:[textField text]];		}	
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	keyboardTag = [textField tag];
	isKeyBoardUp =NO;
	[myTable setFrame:CGRectMake(0, 0, 320, 416)];
	[textField resignFirstResponder];
	if([textField tag] == 102 && [[textField text] length] > 0)			{		[self setNameStr:[textField text]];		}
	else if ([textField tag] == 103 && [[textField text] length] > 0)	{		[self setShopStr:[textField text]];		}
	else if ([textField tag] == 104 && [[textField text] length] > 0)	{		[self setEmailStr:[textField text]];	}
	else if ([textField tag] == 105 && [[textField text] length] > 0)	{		[self setPhoneStr:[textField text]];	}	
	else if ([textField tag] == 106 && [[textField text] length] > 0)	{		[self setStreetStr:[textField text]];	}	
	else if ([textField tag] == 107 && [[textField text] length] > 0)	{		[self setCityStr:[textField text]];		}	
	else if ([textField tag] == 108 && [[textField text] length] > 0)	{		[self setStateStr:[textField text]];	}	
	else if ([textField tag] == 109 && [[textField text] length] > 0)	{		[self setZipStr:[textField text]];		}	
	
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	keyboardTag = [textField tag];
	if([textField tag] == 102 && [[textField text] length] > 0)			{		[self setNameStr:[textField text]];		}
	else if ([textField tag] == 103 && [[textField text] length] > 0)	{		[self setShopStr:[textField text]];		}
	else if ([textField tag] == 104 && [[textField text] length] > 0)	{		[self setEmailStr:[textField text]];	}
	else if ([textField tag] == 105 && [[textField text] length] > 0)	{		[self setPhoneStr:[textField text]];	}	
	else if ([textField tag] == 106 && [[textField text] length] > 0)	{		[self setStreetStr:[textField text]];	}	
	else if ([textField tag] == 107 && [[textField text] length] > 0)	{		[self setCityStr:[textField text]];		}	
	else if ([textField tag] == 108 && [[textField text] length] > 0)	{		[self setStateStr:[textField text]];	}	
	else if ([textField tag] == 109 && [[textField text] length] > 0)	{		[self setZipStr:[textField text]];		}	
	
	return YES;
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
	keyboardTag = [textView tag];
	isKeyBoardUp =YES;
	[myTable setFrame:CGRectMake(0, 0, 320, 200)];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:1];
	[myTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	isKeyBoardUp =NO;
	[myTable setFrame:CGRectMake(0, 0, 320, 416)];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
{
	if ( [ text isEqualToString: @"\n" ] ) {
		isKeyBoardUp =NO;
		[ textView resignFirstResponder ];
		[self setAddrsStr:[textView text]];
		return NO;
	}
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
	[self setAddrsStr:[textView text]];
}

- (void) resignAllResponders
{
	
	if(keyboardTag == 102)	[nameTxtField resignFirstResponder];
	if((VERSION == 0 || VERSION == 1) && keyboardTag == 103)
	{
		[shopTxtField resignFirstResponder];
	}
	if(keyboardTag == 104)	[emailTxtField resignFirstResponder];
	if(keyboardTag == 105)	[phoneTxtField resignFirstResponder];
	if(keyboardTag == 106)	[streetTxtField resignFirstResponder];
	if(keyboardTag == 107)	[cityTxtField resignFirstResponder];
	if(keyboardTag == 108)	[stateTxtField resignFirstResponder];
	if(keyboardTag == 109)	[zipTxtField resignFirstResponder];
	[myTable setFrame:CGRectMake(0, 0, 320, 416)];
}

- (void) addPhoto
{
	UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"Attach files from" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Gallery", @"Camera", nil];
	[alert showInView:self.view];
	[alert setOpaque:YES];
	[alert release];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 1 && [alertView tag] == 999)
	{
		[self submit];
	}
}
#pragma mark UIActionSheetDelegate
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

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	UIImage *croppedImage;
	switch ([picker sourceType]) {
			
        case UIImagePickerControllerSourceTypePhotoLibrary:
			[[picker parentViewController] dismissModalViewControllerAnimated:YES];
			croppedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
			croppedImage = [croppedImage thumbnailImage:70 transparentBorder:0 cornerRadius:7 interpolationQuality:kCGInterpolationNone];
			break;
			
		case UIImagePickerControllerSourceTypeCamera: 
			[[picker parentViewController] dismissModalViewControllerAnimated:YES];
			croppedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
			croppedImage = [croppedImage thumbnailImage:70 transparentBorder:0 cornerRadius:7 interpolationQuality:kCGInterpolationNone];
			break;
	}
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"logo.png"];
	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(croppedImage)];
	[imageData writeToFile:filePath atomically:YES];
	[myTable reloadData];
}

#pragma mark -

#pragma mark ASI Support
- (void) submit
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[activityIndicator startAnimating];
	
	NSMutableString *address = [[NSMutableString alloc] init];
	if([streetStr length] > 0)	{ [address appendFormat:@"%@, ",streetStr];	}
	if([cityStr length] > 0)	{ [address appendFormat:@"%@, ",cityStr];	}
	if([stateStr length] > 0)	{ [address appendFormat:@"%@, ",stateStr];	}
	if([zipStr length] > 0)		{ [address appendFormat:@"%@",zipStr];	}
	
	NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@/register.php", URL]];
	ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:url];
	[req setPostValue:@"1" forKey:@"option"]; 
	[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"myid"] forKey:@"uid"]; 
	[req setPostValue:nameStr forKey:@"name"];
	[req setPostValue:phoneStr forKey:@"phone"];
	if((VERSION == 0) || (VERSION == 1)) [req setPostValue:@"NA" forKey:@"email"];
	else if(VERSION == 2)
	{
		[req setPostValue:phoneStr forKey:@"email"];
		[req setPostValue:@"NA" forKey:@"phone"];
	}
	[req setPostValue:address forKey:@"address"];
	[req setPostValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
	[req setPostValue:[NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"mylat"]] forKey:@"lat"];
	[req setPostValue:[NSString stringWithFormat:@"%f",[[NSUserDefaults standardUserDefaults] floatForKey:@"mylng"]] forKey:@"lng"];
	if((VERSION == 0) || (VERSION == 1)) {	[req setPostValue:shopStr forKey:@"shopname"]; }
	else {	[req setPostValue:@"NA" forKey:@"shopname"]; }
	[req setDelegate:self];
	[req startAsynchronous];
	NSError *error = [req error];
	if (!error) {
		//NSLog(@"response -",[req responseString]);
	}
	[req release];
	[url release];		
	[address release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSLog(@"registration response  - %@",[request responseString]);
	if([[request responseString] isEqualToString:@"SUCCESS"])
	{
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"REGISTERED"];
	}
	else 
	{
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"REGISTERED"];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activityIndicator stopAnimating];
	
	[self performSelector:@selector(goBack) withObject:nil afterDelay:0.5];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"error - %@\n",error);
	UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Network error" message:@"Check your network settings" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[activityIndicator stopAnimating];
}

- (void) goBack
{
	[self.navigationController popViewControllerAnimated:YES];
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


- (void)dealloc 
{
	[nameStr release];
	[shopStr release];
	[emailStr release];
	[phoneStr release];
	[addrsStr release];
	[streetStr release];
	[cityStr release];
	[stateStr release];
	[zipStr release];	
	[activityIndicator release];
    [super dealloc];
}


@end
