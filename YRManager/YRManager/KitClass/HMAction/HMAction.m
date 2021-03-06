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
//  HMAction.m
//  HotelManager-Pad
//
//  Created by xun on 17/1/20.
//  Copyright © 2017年 塞米酒店. All rights reserved.
//

#import "HMAction.h"

@interface HMAction ()

@property (nonatomic, copy) void (^ActionBlock)(void);

@end

@implementation HMAction

+ (instancetype)action:(void (^)(void))action
             withTitle:(NSString *)title
           actionStyle:(HMActionStyle)actionStyle
{
    HMAction *_action = [HMAction buttonWithType:UIButtonTypeCustom];
    
    _action.ActionBlock = action;
    
    [_action setTitle:title forState:UIControlStateNormal];
    _action.titleLabel.font = kFont(18);
    _action.layer.cornerRadius = 5.f;
    _action.clipsToBounds = YES;
    
    if (actionStyle == HMActionStyleGreenBackground)
    {
        _action.backgroundColor = kGreenColor;
    }
    else if (actionStyle == HMActionStyleGreenBorder)
    {
        [_action setTitleColor:kGreenColor forState:UIControlStateNormal];
        _action.layer.borderWidth = 1.f;
        _action.layer.borderColor = kGreenColor.CGColor;
    }
    
    [_action addTarget:_action action:@selector(executeBlock) forControlEvents:UIControlEventTouchUpInside];
    return _action;
}

- (void)executeBlock
{
    !_ActionBlock ? : _ActionBlock();
}

@end
