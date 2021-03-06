//
//  HMImageFile.m
//  HotelManager-Pad
//
//  Created by Seven on 2016/12/14.
//  Copyright © 2016年 塞米酒店. All rights reserved.
//

#import "HMImageFile.h"

@implementation HMImageFile

+ (NSArray *)imagePathFromServerWithResult:(NSDictionary *)result{
    
    NSMutableArray *imagePaths = [NSMutableArray array];
    if (result) {
        for (NSInteger i = 0; i < [result count]; i++) {
            NSString *imagePath = result[[NSString stringWithFormat:@"files[%ld].type",(long)i]];
            [imagePaths addObject:imagePath];
        }
    }
    return imagePaths;
}

@end
