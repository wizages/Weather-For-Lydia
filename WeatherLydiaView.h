//
//  WeatherContentView.h
//  Weather
//
//  Created by wizage on @@BUILD_DATE@@.
//  Copyright (c) wizage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface WeatherLydiaView : UIView
- (void)handleActionForIconTap;
@end

@interface CPLDPresentationWindow : NSObject

+(id)sharedWindow;
-(void)tearDownAnimated:(bool)arg1;

@end

@interface DayForecast : NSObject
@property (nonatomic, copy) NSString* high;                             //@synthesize high=_high - In the implementation block
@property (nonatomic, copy) NSString* low;                              //@synthesize low=_low - In the implementation block               //@synthesize icon=_icon - In the implementation block
@property (assign, nonatomic) unsigned long long dayOfWeek;              //@synthesize dayOfWeek=_dayOfWeek - In the implementation block
@property (assign, nonatomic) unsigned long long dayNumber;    
@end

@interface HourlyForecast : NSObject 
@property (nonatomic,copy) NSString * time;                             //@synthesize time=_time - In the implementation block
@property (assign,nonatomic) long long hourIndex;                       //@synthesize hourIndex=_hourIndex - In the implementation block
@property (nonatomic,copy) NSString * detail;                           //@synthesize detail=_detail - In the implementation block
@end

@interface City : NSObject
@property (nonatomic, retain) NSArray* dayForecasts;
@property (nonatomic, retain) NSArray* hourlyForecasts;
@property(nonatomic) unsigned long long conditionCode;
-(void)update;
- (id)temperature;
- (id)updateTime;
@property(copy, nonatomic) NSString *name;
@end

@interface WeatherPreferences : NSObject
+ (id)sharedPreferences;
- (id)localWeatherCity;
- (void)setLocalWeatherEnabled:(BOOL)arg1;
- (BOOL)isCelsius;
@end

@interface WeatherLocationManager
+ (id)sharedWeatherLocationManager;
- (void)setLocationTrackingActive:(BOOL)arg1;
- (void)setLocationTrackingReady:(BOOL)arg1 activelyTracking:(BOOL)arg2;
-(void)setLocationTrackingReady:(BOOL)arg1 activelyTracking:(BOOL)arg2 watchKitExtension:(id)arg3;
- (void)setDelegate:(id)arg1;
- (id)location;
- (BOOL)locationTrackingIsReady;
@end

@interface LocationUpdater
+ (id)sharedLocationUpdater;
- (void)updateWeatherForLocation:(id)arg1 city:(id)arg2;
- (void)handleCompletionForCity:(id)arg1 withUpdateDetail:(unsigned long long)arg2;
- (void)setWeatherBadge:(id)value;
@end

@implementation UIImage (Colored)

- (UIImage *)changeImageColor:(UIColor *)color {
    UIImage *img = self;
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContextWithOptions(img.size, NO, [UIScreen mainScreen].scale);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

@end
