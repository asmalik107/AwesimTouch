//
//  KeychainManagerBridge.m
//  AwesimTouch
//
//  Created by Asim Malik on 11/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(KeychainManager, NSObject)

  RCT_EXTERN_METHOD(test)

  RCT_EXTERN_METHOD(isAvailable: callback:(RCTResponseSenderBlock) callback)

  RCT_EXTERN_METHOD(save: (NSString*) key password:(NSString*) password callback:(RCTResponseSenderBlock) callback)

  RCT_EXTERN_METHOD(getItem: (NSString*) key callback:(RCTResponseSenderBlock) callback)

  RCT_EXTERN_METHOD(delete: (NSString*) key callback:(RCTResponseSenderBlock) callback)

@end
