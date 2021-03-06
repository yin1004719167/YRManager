//
//  NSDate+HMProjectKit.m
//  HotelManager
//
//  Created by xun on 16/7/20.
//  Copyright © 2016年 xun. All rights reserved.
//

#import "NSDate+HMProjectKit.h"

@implementation NSDate (HMProjectKit)

#pragma mark - private method

+ (NSArray *)monthBegainAndEnd:(NSString *)date
{
    NSArray *dateArr = [date componentsSeparatedByString:@"-"];
    if (dateArr.count < 2)
    {
        return nil;
    }
    NSMutableArray *reArr = [NSMutableArray new];
    NSInteger year = [dateArr[0] integerValue];
    NSInteger month = [dateArr[1] integerValue];
    
    NSString *lastDate;
    [reArr addObject:[NSString stringWithFormat:@"%@-01",date]];
    
    switch (month)
    {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            lastDate = @"31";
            break;
        case 2:
            if (year%400 == 0 || year%4 == 0)
            {
                lastDate = @"29";
            }
            else
            {
                lastDate = @"28";
            }
            break;
        case 4: case 6: case 9: case 11:
            lastDate = @"30";
            break;
    }
    [reArr addObject:[NSString stringWithFormat:@"%@-%@",date,lastDate]];
    return reArr;
}

- (NSDate *)leadDay:(NSInteger)day
{
    NSDateComponents *componets = [NSDateComponents new];
    
    componets.day = day;
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    return [calendar dateByAddingComponents:componets toDate:self options:0];
}

- (NSDate *)leadMonth:(NSInteger)month{
    NSDateComponents *componets = [NSDateComponents new];
    
    componets.month = month;
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    return [calendar dateByAddingComponents:componets toDate:self options:0];
}

- (NSDate *)leadYear:(NSInteger)year {
    NSDateComponents *componets = [NSDateComponents new];
    
    componets.year = year;
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    return [calendar dateByAddingComponents:componets toDate:self options:0];
}

+ (NSString *)dateWithLeadDay:(NSInteger)day dateString:(NSString *)dateStr formatterString:(NSString *)formatterStr
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:formatterStr];
    
    NSDate *date = [formatter dateFromString:dateStr];
    if ([formatterStr containsString:@"d"]) {
        return [formatter stringFromDate:[date leadDay:day]];
    } else if ([formatterStr containsString:@"M"]) {
        return [formatter stringFromDate:[date leadMonth:day]];
    }else {
        return [formatter stringFromDate:[date leadYear:day]];
    }
}

+ (NSArray *)calendarDateWithYear:(int)year month:(int)month
{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];       //日历
    
    NSDate *monthBeginDate = [self firstDayDateWithMonth:month year:year];
    
    //月初周几
    int week = (int)[calendar component:NSCalendarUnitWeekday fromDate:monthBeginDate];
    
    if (week == 1)
    {
        week = 7;
    }
    else
    {
        week --;
    }
    int _month = (int)[calendar component:NSCalendarUnitMonth fromDate:monthBeginDate];
    
    int maxShowDay = 35;
    
    switch (_month)
    {
            //月大
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            /*  如果月初为周五周六
             ———————————————————
             |日 一 二 三 四 五 六|
             |              1  2|
             |                 9|
             |                16|
             |                23|
             |                30|
             |31                |
             -------------------
             则需要6行才能显示完全
             */
            if (week > 4 && week < 7)
            {
                maxShowDay = 42;
            }
            break;
            //月小
        case 4:
        case 6:
        case 9:
        case 11:
            /*
             如果月初为周六
             ———————————————————
             |日 一 二 三 四 五 六|
             |                 1|
             |                 8|
             |                15|
             |                22|
             |                29|
             |30                |
             -------------------
             则需要6行才能显示完全
             */
            if (week == 6)
            {
                maxShowDay = 42;
            }
            break;
        default:
            if (week == 7 &&
                (year % 4 != 0 ||
                 (year % 100 == 0 && year % 400 != 0)))
            {
                maxShowDay = 28;
            }
            
            break;
    }
    
    NSMutableArray *dateArr = [NSMutableArray new];
    
    int leadDay = 0;
    
    if (week != 7)
    {
        leadDay = -week;
    }
    
    for (int i = 0; i < maxShowDay; i++)
    {
        [dateArr addObject:[monthBeginDate leadDay:leadDay + i]];
    }
    return dateArr;
}

+ (NSDate *)firstDayDateWithMonth:(int)month year:(int)year
{
    int tempYear, tempMonth;
    
    tempYear = year;
    tempMonth = month;
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyyMM"];
    
    int dateNum = [[dateFormatter stringFromDate:[NSDate newDate]] intValue];
    
    if (year == 0)
    {
        tempYear = dateNum / 100;
    }
    if (month == 0)
    {
        tempMonth = dateNum % 100;
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%d%02d01", tempYear, tempMonth];
    
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    
    return [dateFormatter dateFromString:dateStr];
}

//获取星期
+(NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}

//计算时间差值
+ (NSString *)getSubtractValue:(NSDate *)dateOne second:(NSDate *)dateTwo
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:dateOne];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:dateTwo];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return [NSString stringWithFormat:@"%ld",(long)dayComponents.day];
}

//获取当前日期
+(NSString *)getCurrentDateWithFormat:(NSString *)format
{
    NSDate *senddate = [NSDate newDate];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:format];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    
    return locationString;
}

//获取明天日期
+ (NSString *)getTomorrowDateWithFormat:(NSString *)format
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate newDate]];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:format];
    return [dateday stringFromDate:beginningOfWeek];
}

//将字符串日期转成 MM月dd日格式
+(NSString *)dateWithIntoDate:(NSString *)intoDate leaveDate:(NSString *) leaveDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *intoDateStr = @"";
    NSString *leaveDateStr = @"";
    NSString *intoDays = [NSDate getSubtractValue:[dateFormatter dateFromString:intoDate] second:[dateFormatter dateFromString:leaveDate]];
    
    NSArray *arr = [intoDate componentsSeparatedByString:NSLocalizedString(@"-", nil)];
    if(arr.count > 2){
        intoDateStr = [NSString stringWithFormat:@"%@月%@日",arr[1],arr[2]];
    }
    
    NSArray *arr2 = [leaveDate componentsSeparatedByString:NSLocalizedString(@"-", nil)];
    if(arr.count > 2){
        leaveDateStr = [NSString stringWithFormat:@"%@月%@日",arr2[1],arr2[2]];
    }
    return [NSString stringWithFormat:@"%@-%@ %@晚",intoDateStr,leaveDateStr,intoDays];
}

+(NSString *)dateWithDate:(NSDate *)intoDate leaveDate:(NSDate *) leaveDate
{
    NSString *intoDays = [NSDate getSubtractValue:intoDate second:leaveDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日"];
    return [NSString stringWithFormat:@"%@-%@ %@晚",[dateFormatter stringFromDate:intoDate],[dateFormatter stringFromDate:leaveDate],intoDays];
}

+ (NSString *)daysIntervalWithIntoDate:(NSString *)intoDate leaveDate:(NSString *)leaveDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    intoDate = [NSDate commonFormaterDateString:intoDate];
    leaveDate = [NSDate commonFormaterDateString:leaveDate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *intoDays = [NSDate getSubtractValue:[dateFormatter dateFromString:intoDate] second:[dateFormatter dateFromString:leaveDate]];
    
    return [NSString stringWithFormat:@"%@晚",intoDays];
}

+ (NSString *)commonFormaterDateString:(NSString *)dateString{
 
    if ([dateString containsString:@":"]) {
     NSRange range = [dateString rangeOfString:@"-" options:NSBackwardsSearch];
        
     return  [dateString substringWithRange:NSMakeRange(0, range.location + 3)];
        
    };
    return dateString;
}

//将字符串日期格式 MM月dd日 星期  12月12日 周三
+(NSString *)dateWithDate:(NSString *)intoDate
{
    NSString *intoDateStr = @"";
    NSArray *arr = [intoDate componentsSeparatedByString:NSLocalizedString(@"-", nil)];
    if(arr.count > 2){
        intoDateStr = [NSString stringWithFormat:@"%@月%@日",arr[1],arr[2]];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *cuttentDate = [dateFormatter dateFromString:intoDate];
    
    if([cuttentDate isToday])
    {
        intoDateStr = [intoDateStr stringByAppendingString:@"  今天"];
    }
    else
    {
        intoDateStr = [NSString stringWithFormat:@"%@  %@",intoDateStr,[NSDate weekdayStringFromDate:cuttentDate]];
    }
    
    return intoDateStr;
}

+ (NSString *)timeStringWithTimeInterval:(NSString *)timeInterval
{
    //时间戳是10位的,如果是服务器传回的，请除以1000后传过来，ios系统默认是10位的
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval.longLongValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    //今天
    if ([date isToday]) {
        
        formatter.dateFormat = @"HH:mm";
        
        return [formatter stringFromDate:date];
    }else{
        
        //昨天
        if ([date isYesterday]) {
            
            formatter.dateFormat = @"昨天HH:mm";
            return [formatter stringFromDate:date];
            
            //一周内 [date weekdayStringFromDate]
        }else if ([date isSameWeek]){
            
            formatter.dateFormat = [NSString stringWithFormat:@"%@%@",[NSDate weekdayStringFromDate:date],@"HH:mm"];
            return [formatter stringFromDate:date];
            
            //直接显示年月日
        }else{
            
            formatter.dateFormat = @"yy-MM-dd  HH:mm";
            return [formatter stringFromDate:date];
        }
    }
    return nil;
}

+ (NSString *)timeStringWithTimeInterval2:(NSString *)timeInterval
{
    //时间戳是10位的,如果是服务器传回的，请除以1000后传过来，ios系统默认是10位的
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval.longLongValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    //今天
    if ([date isToday]) {
        
        formatter.dateFormat = @"HH:mm";
        
        return [formatter stringFromDate:date];
    }else{
        
        //昨天
        if ([date isYesterday]) {
            
            formatter.dateFormat = @"昨天";
            return [formatter stringFromDate:date];
            
            //一周内 [date weekdayStringFromDate]
        }else if ([date isSameWeek]){
            
            formatter.dateFormat = [NSString stringWithFormat:@"%@",[NSDate weekdayStringFromDate:date]];
            return [formatter stringFromDate:date];
            
            //直接显示年月日
        }else{
            
            formatter.dateFormat = @"MM-dd";
            return [formatter stringFromDate:date];
        }
    }
    return nil;
}

+ (NSComparisonResult)compareDate:(NSDate *)date1
                         withDate:(NSDate *)date2
                  byCalendarUnits:(NSCalendarUnit)unit
{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components1 = [calendar components:unit fromDate:date1];
    
    NSDateComponents *components2 = [calendar components:unit fromDate:date2];
    
    //  比较年份
    if (components1.year > components2.year)
    {
        return NSOrderedDescending ;
    }
    else if (components1.year < components2.year)
    {
        return NSOrderedAscending;
    }
    
    //  月份比较
    if (components1.month > components2.month)
    {
        return NSOrderedDescending;
    }
    else if (components1.month < components2.month)
    {
        return NSOrderedAscending;
    }
    
    if (components1.day > components2.day)
    {
        return NSOrderedDescending;
    }
    else if (components1.day < components2.day)
    {
        return NSOrderedAscending;
    }
    
    if (components1.hour > components2.hour)
    {
        return NSOrderedDescending;
    }
    else if (components1.hour < components2.hour)
    {
        return NSOrderedAscending;
    }
    
    if (components1.minute > components2.minute)
    {
        return NSOrderedDescending;
    }
    else if (components1.minute < components2.minute)
    {
        return NSOrderedAscending;
    }
    
    if (components1.second > components2.second)
    {
        return NSOrderedDescending;
    }
    else if (components1.second < components2.second)
    {
        return NSOrderedAscending;
    }
    
    return NSOrderedSame;
}

- (NSComparisonResult)compareWithDate:(NSDate *)date1
                      byCalendarUnits:(NSCalendarUnit)unit
{
    return [NSDate compareDate:self withDate:date1 byCalendarUnits:unit];
}

//判断是否为今天
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate newDate]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return
    
    (selfCmps.year == nowCmps.year) &&
    
    (selfCmps.month == nowCmps.month) &&
    
    (selfCmps.day == nowCmps.day);
}

//是否为昨天
- (BOOL)isYesterday
{
    //2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    //2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    //获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.day == 1;
}

//是否在同一周
- (BOOL)isSameWeek
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear ;
    
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

//判断是否为当月
- (BOOL)isMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate newDate]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return
    
    (selfCmps.year == nowCmps.year) &&
    
    (selfCmps.month == nowCmps.month);
}

//格式化
- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

@end
