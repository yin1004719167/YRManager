 //
//  UILabel+NSMutableAttributedString.m
//  GoFun
//
//  Created by xun on 16/4/11.
//  Copyright © 2016年 xun. All rights reserved.
//

#import "UILabel+NSMutableAttributedString.h"
#import <CoreText/CoreText.h>

@implementation UILabel (NSMutableAttributedString)

- (void)setAttributedStringWithSubString:(NSString *)subString color:(UIColor *)color font:(UIFont *)font
{
    if (!self.text || !self.text.length)
    {
        return;
    }
    if ([subString isKindOfClass:[NSNull class]] || (!subString) || (!subString.length))
    {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
    if (font)
    {
        
        [dict setValue:font forKey:NSFontAttributeName];
        [dict setValue:@0 forKey:NSBaselineOffsetAttributeName];
    }
    if (color)
    {
        [dict setValue:color forKey:NSForegroundColorAttributeName];
    }

    [self.attributedString addAttributes:dict range:[self.text rangeOfString:subString]];
    [self setAttributedText:self.attributedString];
    
    //if(kCurrentDeviceSystem >= 11.0){[self sizeToFit];}
}

- (void)setAttributedStringWithSubString:(NSString *)subString font:(UIFont *)font
{
    [self setAttributedStringWithSubString:subString color:nil font:font];
}

- (void)setAttributedStringWithSubString:(NSString *)subString color:(UIColor *)color
{
    [self setAttributedStringWithSubString:subString color:color font:nil];
}

- (void)setLineSpace:(CGFloat)lineSpace
{
    [self setLineSpace:lineSpace paragraphSpace:lineSpace];
}

- (void)setLineSpace:(CGFloat)lineSpace paragraphSpace:(CGFloat)paragraphSpace
{
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineSpacing = lineSpace / 2;
    paragraphStyle.paragraphSpacing = paragraphSpace / 2;
    
    [self.attributedString addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, self.text.length)];
    
    [self setAttributedText:self.attributedString];
}

- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr font:(UIFont *)font
{
    for(NSString *subString in subStringArr)
    {
        [self setAttributedStringWithSubString:subString font:font];
    }
}

- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr color:(UIColor *)color
{
    for(NSString *subString in subStringArr)
    {
        [self setAttributedStringWithSubString:subString color:color];
    }
}

- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr font:(UIFont *)font color:(UIColor *)color
{
    for(NSString *subString in subStringArr)
    {
        [self setAttributedStringWithSubString:subString color:color font:font];
    }
}

- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr fonts:(NSArray *)fontArr
{
    int max = (int)(subStringArr.count > fontArr.count ? subStringArr.count : fontArr.count);
    for (int i = 0; i < max; i++)
    {
        [self setAttributedStringWithSubString:subStringArr[i] font:fontArr[i]];
    }
}

- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr colors:(NSArray *)colorArr
{
    int max = (int)(subStringArr.count > colorArr.count ? subStringArr.count : colorArr.count);
    for (int i = 0; i < max; i++)
    {
        [self setAttributedStringWithSubString:subStringArr[i] color:colorArr[i]];
    }
}

- (void)setAttributedStringWithSubStrings:(NSArray *)subStringArr fonts:(NSArray *)fontArr colors:(NSArray *)colorArr
{
    [self setAttributedStringWithSubStrings:subStringArr fonts:fontArr];
    [self setAttributedStringWithSubStrings:subStringArr colors:colorArr];
}

- (void)addMiddleLineWithSubString:(NSString *)subString
{
    [self addMiddleLineWithSubString:subString options:0];
}

- (void)addMiddleLineWithSubString:(NSString *)subString
                           options:(NSStringCompareOptions)options
{
    if(!subString || !subString.length)
    {
        return;
    }
    
    [self.attributedString setAttributes:@{NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:[self.text rangeOfString:subString options:options]];
    [self setAttributedText:self.attributedString];
}

- (void)setWordSpace:(CGFloat)space
{
    [self.attributedString addAttributes:@{(id)kCTKernAttributeName:@(space)} range:NSMakeRange(0, self.text.length)];
}

- (void)setAllSameSubString:(NSString *)substring color:(UIColor *)color
{
    if(![self.attributedText.string isEqualToString:self.text])
    {
        [self setAttributedText:nil];
    }
    
    NSArray *substrRangeArr = [self getSubstringRanegdArr:substring];
    
    for (NSValue *value in substrRangeArr)
    {
        [self.attributedString addAttributes:@{NSForegroundColorAttributeName:color} range:value.rangeValue];
    }
}

- (void)setAllSameSubString:(NSString *)substring font:(UIFont *)font
{
    if(![self.attributedText.string isEqualToString:self.text])
    {
        [self setAttributedText:nil];
    }
    
    NSArray *substrRangeArr = [self getSubstringRanegdArr:substring];
    
    for (NSValue *value in substrRangeArr)
    {
        [self.attributedString addAttributes:@{NSFontAttributeName:font} range:value.rangeValue];
    }
}

#pragma mark - private method

- (NSArray *)getSubstringRanegdArr:(NSString *)substring
{
    NSMutableArray *arr = [NSMutableArray new];
    
    NSRange range = [self.text rangeOfString:substring];
    
    while (range.location != NSNotFound)
    {
        [arr addObject:[NSValue valueWithRange:range]];
        range = [self.text rangeOfString:substring options:NSRegularExpressionSearch range:NSMakeRange(range.location + range.length, self.text.length - range.location - range.length)];
    }
    
    return arr;
}


- (NSMutableAttributedString *)attributedString
{
    if (!self.attributedText || ![self.text isEqualToString:self.attributedText.string])
    {
        self.attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    }
    return (id)self.attributedText;
}

@end
