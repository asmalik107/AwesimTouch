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

@objc(KeychainManager)
class KeychainManager : NSObject{
  
  @objc func test() {
    
    let removeSuccessful: Bool = KeychainWrapper.standard.removeAllKeys()
    print("REMOVE SUCCESSFUL", removeSuccessful);
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
    
    /*let saveSuccessful: Bool = KeychainWrapper.standard.set(password, forKey: key, withAccessibility:.whenPasscodeSetThisDeviceOnly )
    print("SAVE _SUCCESSFUL", saveSuccessful);*/
  }
  
  @objc func getItem(_ key:String, callback:@escaping RCTResponseSenderBlock) {
    let keychain = Keychain()
    
    DispatchQueue.global().async {
      do {
        let password = try keychain
          .authenticationPrompt("Authenticate to login to server")
          .get(key)
        
        print("GET_ITEM: \(String(describing: password))")
        
        callback([NSNull(), password!]);
      } catch let error {
        print(error)
        
        callback([RCTMakeError("Failed to get Item from Keychain", error, ["key": key]), NSNull()]);
      }
    }
    
    /*let retrievedString: String! = KeychainWrapper.standard.string(forKey: key, withAccessibility:.whenPasscodeSetThisDeviceOnly )
    print("GET ITEM", retrievedString);
    
    return retrievedString ?? ""*/
  }
  
  @objc func delete(_ key:String, callback:RCTResponseSenderBlock) {
    /*let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: key, withAccessibility:.whenPasscodeSetThisDeviceOnly )
    print("REMOVE ITEM", removeSuccessful);*/
    
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
