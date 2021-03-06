//
//  UIApplication+LPOpenURL.m
//  Lodger-Pad
//
//  Created by xun on 10/11/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import "UIApplication+LPOpenURL.h"

@implementation UIApplication (LPOpenURL)

+ (void)openURL:(NSString *)url
{
#ifdef __IPHONE_10_0
    if (kCurrentDeviceSystem >= 10.0)
    {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
//            
//        }];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
#else
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
#endif
}

@end
