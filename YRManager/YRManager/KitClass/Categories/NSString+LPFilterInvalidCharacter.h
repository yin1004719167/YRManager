//
//  NSString+LPFilterInvalidCharacter.h
//  Lodger-Pad
//
//  Created by xun on 10/6/16.
//  Copyright © 2016 xun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LPFilterInvalidCharacter)

- (BOOL)isPureNumberString;

- (BOOL)isValiadPhoneNumber;

//判断是否为整形：
- (BOOL)isPureInteger;

//判断是否为浮点形：
- (BOOL)isPureFloat;
@end
