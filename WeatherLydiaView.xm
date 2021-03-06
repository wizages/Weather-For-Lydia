//
//  WeatherContentView.m
//  Weather
//
//  Created by wizage on @@BUILD_DATE@@.
//  Copyright (c) wizage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherLydiaView.h"

static NSDictionary *preferences;

@implementation WeatherLydiaView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        WeatherPreferences* prefs = [objc_getClass("WeatherPreferences") sharedPreferences];
	    City* city = [prefs localWeatherCity];
	    if (!prefs) {
	        HBLogError(@"User did not have location services enabled for Weather.app");
	        return self;
	    }
	    if([[NSDate date] compare:[[city updateTime] dateByAddingTimeInterval:1800]] == NSOrderedDescending)
    	{
		    WeatherLocationManager *weatherLocationManager = [objc_getClass("WeatherLocationManager") sharedWeatherLocationManager];

			CLLocationManager *locationManager = [[CLLocationManager alloc]init];
			[weatherLocationManager setDelegate:locationManager];

			if(![weatherLocationManager locationTrackingIsReady]) {
				[weatherLocationManager setLocationTrackingReady:YES activelyTracking:NO watchKitExtension:nil];
			}
		
			[[objc_getClass("WeatherPreferences") sharedPreferences] setLocalWeatherEnabled:YES];
			[weatherLocationManager setLocationTrackingActive:YES];

			[[objc_getClass("TWCLocationUpdater") sharedLocationUpdater] updateWeatherForLocation:[weatherLocationManager location] city:city];

			[weatherLocationManager setLocationTrackingActive:NO];
			[locationManager release];
		}

    	[city update];
		NSArray* hours = city.hourlyForecasts;
	    HourlyForecast *hourly;
	    UIBlurEffect *blurEffect;
	    if(![[preferences objectForKey:@"darkView"] boolValue] || [preferences objectForKey:@"darkView"] == nil)
	    {
	    	blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
	    	HBLogDebug(@"Light");
	    } else
	    {
	    	blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	    }
	    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
	    UIVibrancyEffect *vibrance = [UIVibrancyEffect effectForBlurEffect:blurEffect];
	    UIVisualEffectView *vibranceView = [[UIVisualEffectView alloc] initWithEffect:vibrance];
	    if ([[preferences objectForKey:@"blurEnabled"] boolValue] || [preferences objectForKey:@"blurEnabled"] == nil)
	    {
	    	blurView.frame = self.frame;
	    	vibranceView.frame = blurView.frame;
	    }

	    UILabel *location = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.size.height*.1 ,self.frame.size.width, self.frame.size.height*.2)];
	    location.text = [city name];
	    location.font = [location.font fontWithSize: 32];
	    location.textAlignment = NSTextAlignmentCenter;
	    location.textColor = [UIColor whiteColor];
	    location.adjustsFontSizeToFitWidth = true;
	    location.minimumFontSize = 12;

	    UILabel *currentTemp  = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.origin.x+5, self.frame.size.height*.8, self.frame.size.width, self.frame.size.height*.2)];
	    hourly = hours[0];
	   	currentTemp.textAlignment = NSTextAlignmentCenter;
	    currentTemp.textColor = [UIColor whiteColor];
	    if (hourly.detail == nil)
	    {
	    	location.text = @"Error";
	    	currentTemp.text = @"Please enable location services.";
	    	[self addSubview:location];
	    	[self addSubview:currentTemp];
	    	return self;
	    }
	    if(![[preferences objectForKey:@"isCel"] boolValue] || [preferences objectForKey:@"isCel"] == nil)
	    {
	    	currentTemp.text = [NSString stringWithFormat:@"%.0f°", ([hourly.detail floatValue]*9/5 + 32)];
	    }
	    else
	    {
	    	currentTemp.text = [NSString stringWithFormat:@"%.0f°", [hourly.detail floatValue]];
	    }
	    //currentTemp.text = [NSString stringWithFormat:@"%.0f°", ([hourly.detail floatValue]*9/5 + 32)];
	    currentTemp.font = [currentTemp.font fontWithSize: 24];

	    long currCode = [city conditionCode];
		NSString *result = @"";

		NSString *fileLocation = @"/var/mobile/Library/Lydia/Views/com.apple.weather/Assets/";
	    UIImage *image = nil;
		switch(currCode)
		{
			case 0:
	            result = @"";
	            break;
	        case 1:
	        case 2:
	        case 3:
	        case 4:
	        case 37:
	        case 38:
	        case 39:
	        case 45:
	        case 47:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Storm.png", fileLocation]];
	            break;
	        case 5:
	        case 15:
	        case 16:
	        case 6:
	        case 7:
	        case 18:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Snow.png", fileLocation]];
	            break;
	        case 8:
	        case 10:
	        case 9:
	        case 11:
	        case 12:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Rain.png", fileLocation]];
	            break;
	        case 13:
	        case 14:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Snow.png", fileLocation]];
	            break;
	        case 17:
	        case 35:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Rain.png", fileLocation]];
	            break;
	        case 19:
	        case 20:
	        case 21:
	        case 22:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Fog.png",fileLocation]];
	            break;
	        case 23:
	        case 24:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Wind.png",fileLocation]];
	            break;
	        case 25:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Sun.png", fileLocation]];
	            break;
	        case 26:
	        case 27:
	        case 28:
	        case 29:
	        case 30:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Cloud.png", fileLocation]];
	            break;
	        case 31:
	        case 32:
	        case 33:
	        case 34:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Sun.png", fileLocation]];
	            break;
	        case 36:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Hot.png", fileLocation]];
	            break;
	        case 40:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Rain.png", fileLocation]];
	            break;
	        case 41:
	        case 42:
	        case 43:
	        case 46:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Snow.png", fileLocation]];
	            break;
	        case 44:
	            image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Cloud.png", fileLocation]];
	            break;
	        case 3200:
	        default:
	            result = @"";
	            break;
		}
		if(![[preferences objectForKey:@"colored"] boolValue] && [preferences objectForKey:@"colored"] != nil){
        	image = [image changeImageColor:[UIColor whiteColor]];
		}
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = CGRectMake(self.frame.origin.x, self.frame.size.height*.3, self.frame.size.width, self.frame.size.height*.5);
		imageView.contentMode = UIViewContentModeScaleAspectFit;

		if ([[preferences objectForKey:@"blurEnabled"] boolValue] || [preferences objectForKey:@"blurEnabled"] == nil)
	    {
	    	[vibranceView.contentView addSubview:location];
	    	[vibranceView.contentView addSubview:currentTemp];
	    	[blurView.contentView addSubview:vibranceView];
	    	[self addSubview:blurView];
	    }
	    else
	    {
	    	[self addSubview:location];
	    	[self addSubview:currentTemp];
	    }
	    [self addSubview:imageView];
	}

    return self;
}

- (UIColor *)presentationBackgroundColor {	
	HBLogDebug(@"dictionary: %@", preferences);
	if ([[preferences objectForKey:@"blurEnabled"] boolValue] || [preferences objectForKey:@"blurEnabled"] == nil)
    	return [UIColor clearColor];
    else
    {
    	if(![[preferences objectForKey:@"darkView"] boolValue] || [preferences objectForKey:@"darkView"] == nil)
	    {
	    	return [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.2];
	    } else
	    {
	    	return [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.2];
	    }
    }
}

- (void)handleActionForIconTap  {
	// Do whatever you want to happen when the icon below the custom view is tapped.

	// You may or may not want to close the Lydia interface when the user taps on the icon
	// that is completly up to your descrition to do as you like.
	[[NSClassFromString(@"CPLDPresentationWindow") sharedWindow] tearDownAnimated:YES];
}

@end
 
static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	[preferences release];
	CFStringRef appID = CFSTR("com.wizages.weather");
	CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	if (!keyList) {
		HBLogDebug(@"There's been an error getting the key list!");
		return;
	}
	preferences = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
	if (!preferences) {
		HBLogDebug(@"There's been an error getting the preferences dictionary!");
	}
	CFRelease(keyList);
}

%ctor{
	PreferencesChangedCallback(NULL,NULL,NULL,NULL,NULL);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)PreferencesChangedCallback, CFSTR("com.wizages.weather.settings"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}