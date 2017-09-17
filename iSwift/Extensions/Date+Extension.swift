//
//  Date+Extension.swift
//  All List
//
//  Created by Amol Bapat on 15/12/16.
//  Copyright © 2016 Olive. All rights reserved.
//

import Foundation

/*
Year

y       2008        Year, no padding
yy      08          Year, two digits (padding with a zero if necessary)
yyyy	2008        Year, minimum of four digits (padding with zeros if necessary)

Quarter

Q       4               The quarter of the year. Use QQ if you want zero padding.
QQQ     Q4              Quarter including "Q"
QQQQ	4th quarter     Quarter spelled out

Month

M       12          The numeric month of the year. A single M will use '1' for January.
MM      12          The numeric month of the year. A double M will use '01' for January.
MMM     Dec         The shorthand name of the month
MMMM	December	Full name of the month
MMMMM	D           Narrow name of the month

Day

d       14                          The day of the month. A single d will use 1 for January 1st.
dd      14                          The day of the month. A double d will use 01 for January 1st.
F       3rd Tuesday in December     The day of week in the month
E       Tues                        The day of week in the month
EEEE	Tuesday                     The full name of the day
EEEEE	T                           The narrow day of week

Hour

h       4       The 12-hour hour.
hh      04      The 12-hour hour padding with a zero if there is only 1 digit
H       16      The 24-hour hour.
HH      16      The 24-hour hour padding with a zero if there is only 1 digit.
a       PM      AM / PM for 12-hour time formats

Minute

m       9       The minute, with no padding for zeroes.
mm      09      The minute with zero padding.

Second

s       8       The seconds, with no padding for zeroes.
ss      08      The seconds with zero padding.

Time Zone

zzz     CST	The 3 letter name of the time zone. Falls back to GMT-08:00 (hour offset) if the name is not known.
zzzz	Central Standard Time	The expanded time zone name, falls back to GMT-08:00 (hour offset) if name is not known.
zzzz	CST-06:00	Time zone with abbreviation and offset
Z       -0600	RFC 822 GMT format. Can also match a literal Z for Zulu (UTC) time.
ZZZZZ	-06:00	ISO 8601 time zone format
*/



extension Date
{
    func string(format:String) -> String?
    {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = NSTimeZone.local
        return formatter.string(from: self)
    }
    
    func weekDay() -> String?
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.timeZone = NSTimeZone.local
        return formatter.string(from: self)
    }
}





/*
 + (NSInteger)dayFromDate:(NSDate*)date
 {
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"dd"];
 NSString *day = [dateFormatter stringFromDate:date];
 
 return [day integerValue];
 }
 
 + (NSInteger)weekFromDate:(NSDate*)date
 {
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"c"];
 NSString *week = [dateFormatter stringFromDate:date];
 
 return [week integerValue];
 }
 
 + (NSInteger)monthFromDate:(NSDate*)date
 {
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"MM"];
 NSString *month = [dateFormatter stringFromDate:date];
 
 return [month integerValue];
 }
 
 + (NSInteger)yearFromDate:(NSDate*)date
 {
 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 [dateFormatter setDateFormat:@"yyyy"];
 NSString *year = [dateFormatter stringFromDate:date];
 
 return [year integerValue];
 }
 

 + (NSUInteger) numberOfDaysWithDate:(NSDate *)date
 {
 NSRange days = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
 inUnit:NSCalendarUnitMonth
 forDate:date];
 return days.length;
 }
 
 
 +(NSUInteger)lastDayOfMonth:(NSUInteger)month inYear:(NSUInteger)year
 {
 NSString *dateStr = [NSString stringWithFormat:@"01-%lu-%lu",(unsigned long)month,(unsigned long)year];
 NSDate *date = [CommonUtility dateFromString:dateStr withFormat:@"dd-MM-yyyy"];
 NSCalendar *cal = [NSCalendar currentCalendar];
 NSRange range = [cal rangeOfUnit:NSDayCalendarUnit
 inUnit:NSMonthCalendarUnit
 forDate:date];
 NSUInteger numberOfDaysInMonth = range.length;
 
 return numberOfDaysInMonth;
 }
 */
