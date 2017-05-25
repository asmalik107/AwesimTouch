//
//  KeychainManager.swift
//  AwesimTouch
//
//  Created by Asim Malik on 11/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import KeychainAccess
import LocalAuthentication

@objc(KeychainManager)
class KeychainManager : NSObject{
  
  @objc func test() {
    
    let removeSuccessful: Bool = KeychainWrapper.standard.removeAllKeys()
    print("REMOVE SUCCESSFUL", removeSuccessful);
  }
  
  @objc func isAvailable(_ callback:@escaping RCTResponseSenderBlock) {
    let context = LAContext()
    
    var error: NSError?
    
    if context.canEvaluatePolicy(
      LAPolicy.deviceOwnerAuthentication,
      error: &error) {
      // TouchID is available on the device
      callback([NSNull(), true]);
    } else {
      // TouchID is not available on the device
      // No scanner or user has not set up TouchID
      switch error!.code{
        
      case LAError.Code.touchIDNotEnrolled.rawValue:
        print("TouchID is not enrolled",
                   error!.localizedDescription)
        
      case LAError.Code.passcodeNotSet.rawValue:
        print("A passcode has not been set",
                   error!.localizedDescription)
        
      default:
        print("TouchID not available",
                   error!.localizedDescription)
        
      }
      print(error!)
      callback([RCTMakeError("TouchId not supported", error, nil), NSNull()]);
    }
  }
  
  @objc func save(_ key:String, password:String, callback:@escaping RCTResponseSenderBlock){
    let keychain = Keychain()
    DispatchQueue.global().async {
      do {
        try keychain
          .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
          .set(password, key: key)
      
        callback([NSNull(), true]);
      }
      catch let error {
        print(error)
        callback([error, NSNull()]);
      }
    }
  }
  
  @objc func getItem(_ key:String, callback:@escaping RCTResponseSenderBlock) {
    let keychain = Keychain()
    
    DispatchQueue.global().async {
      do {
        let password = try keychain
          .authenticationPrompt("Authenticate to login to server")
          .get(key)
        
        print("GET_ITEM: \(String(describing: password))")
        
        
        if let optionalValue = password {
                callback([NSNull(), optionalValue]);
        }else {
           callback([NSNull(), ""]);
        }
        

      } catch let error {
        print("GET_ITEM_ERROR", error, error.localizedDescription, type(of: error))
        
        if error is Status {
          let errStatus = error as? Status;
          print("Movie: \(errStatus!.rawValue)")
        }
        
        switch error {
        case Status.userCanceled:
          print("User canceled")
        default:
          print("Where the skies are blue")
        }
        
        callback([RCTMakeError("Failed to get Item from Keychain", error, ["key": key, "description": error.localizedDescription]), NSNull()]);
      }
    }
  }
  
  @objc func delete(_ key:String, callback:RCTResponseSenderBlock) {
    
    let keychain = Keychain()
    
    callback([NSNull(), true]);
    do {
      try keychain.remove(key)
    } catch let error {
      print(error)
      
      callback([error, NSNull()]);
    }
  }
}
