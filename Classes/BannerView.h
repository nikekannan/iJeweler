//
//  BannerView.h
//  MyJeweler
//
//  Created by Nikesh Kannan on 21/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BannerView : UIImageView 
{
    NSString        *weblink;
    NSString        *uid;
    
    NSMutableData   *activeDownload;
    NSURLConnection *imageConnection;

}

//@property (nonatomic, retain) UIImage *backImage;
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *weblink;

@property (nonatomic, retain) NSMutableData *activeDownload;
@property (nonatomic, retain) NSURLConnection *imageConnection;

- (id)initWithFrame:(CGRect)frame 
             userid:(NSString*)userid
               link:(NSString*)link;

- (void) prepareView;
- (void)startDownload;
- (void)cancelDownload;

@end



