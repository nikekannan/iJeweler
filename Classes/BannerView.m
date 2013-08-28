//
//  BannerView.m
//  MyJeweler
//
//  Created by Nikesh Kannan on 21/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BannerView.h"
#import "Constants.h"

@implementation BannerView

@synthesize weblink;
@synthesize uid;
@synthesize activeDownload;
@synthesize imageConnection;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    [self setUserInteractionEnabled:YES];
    [self prepareView];
    return self;
}



- (id)initWithFrame:(CGRect)frame 
               userid:(NSString*)userid
               link:(NSString*)link
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    [self setUid:userid];
    [self setWeblink:link];
    [self setUserInteractionEnabled:YES];
    [self setBackgroundColor:[UIColor clearColor]];
    [self prepareView];
    return self;
}

- (void) prepareView
{    
//    // website link
    UIButton *link = [[UIButton alloc] initWithFrame:CGRectMake(0,0,260,60)];
    [link addTarget:self.superview action:@selector(bannerClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:link];
    [link release];

    // info icon
    UIButton *info = [[UIButton alloc] init];
    [info setImage:[UIImage imageNamed:@"info_button.png"] forState:UIControlStateNormal];
    [info setFrame:CGRectMake(280,7,20,20)];
    [info addTarget:self.superview action:@selector(animateInfoView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:info];
    [info release];

    // ask a question
    UIButton *askQtn = [[UIButton alloc] initWithFrame:CGRectMake(260,30,60,28)];
    [askQtn setFrame:CGRectMake(260,30,60,28)];
    [askQtn setTag:[self.uid intValue]];
    [askQtn setImage:[UIImage imageNamed:@"askqtn_button.png"] forState:UIControlStateNormal];
    [askQtn addTarget:self.superview action:@selector(bannerAskaQuestionClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:askQtn];
    [askQtn release];
    
//    [self startDownload];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:[NSString stringWithFormat:@"%@/images/banners/%@.jpg",URL,self.uid]]] delegate:self];
    self.imageConnection = conn;
    [conn release];
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    CGSize itemSize = CGSizeMake(kBannerWidth, kBannerHeight);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    [self setImage:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    
    self.activeDownload = nil;
    [image release];
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    // call our delegate and tell it that our icon is ready for display
}


- (void)dealloc
{
    [uid release];
    [weblink release];
    [activeDownload release];    
    [imageConnection cancel];
    [imageConnection release];
    [super dealloc];
}

@end
