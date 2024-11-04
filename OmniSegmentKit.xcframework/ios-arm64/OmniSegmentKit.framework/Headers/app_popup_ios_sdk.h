//
//  app_popup_ios_sdk.h
//  app-popup-ios-sdk
//
//  Created by 劉聖龍 on 2023/12/7.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

//! Project version number for app_popup_ios_sdk.
FOUNDATION_EXPORT double app_popup_ios_sdkVersionNumber;

//! Project version string for app_popup_ios_sdk.
FOUNDATION_EXPORT const unsigned char app_popup_ios_sdkVersionString[];

NS_ASSUME_NONNULL_BEGIN

@interface WKWebViewConfiguration (OmniSegment)
- (void)addOmniSegmentContentController API_AVAILABLE(ios(13.0));
@end

NS_ASSUME_NONNULL_END
