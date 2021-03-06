//
//  \\      //     ||          ||     ||\        ||
//   \\    //      ||          ||     ||\\       ||
//    \\  //       ||          ||     || \\      ||
//     \\//        ||          ||     ||  \\     ||
//      /\         ||          ||     ||   \\    ||
//     //\\        ||          ||     ||    \\   ||
//    //  \\       ||          ||     ||     \\  ||
//   //    \\      ||          ||     ||      \\ ||
//  //      \\      \\        //      ||       \\||
// //        \\      \\======//       ||        \||
//
//
//  HMAction.h
//  HotelManager-Pad
//
//  Created by xun on 17/1/20.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    HMActionStyleNone,
    HMActionStyleGreenBackground,
    HMActionStyleGreenBorder
    
}HMActionStyle;

@interface HMAction : UIButton

+ (instancetype)action:(void (^)(void))action
             withTitle:(NSString *)title
           actionStyle:(HMActionStyle)actionStyle;

@end
