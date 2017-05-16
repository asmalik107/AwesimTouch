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
  
  @objc func save(_ key:String, password:String, resolve:@escaping RCTPromiseResolveBlock, reject:@escaping RCTPromiseRejectBlock){
    let keychain = Keychain()
    DispatchQueue.global().async {
    do {
      try keychain
        .accessibility(.whenPasscodeSetThisDeviceOnly, authenticationPolicy: .userPresence)
        .set(password, key: key)
      
      resolve(true)
    }
    catch let error {
      print(error)
      reject("SAVE FAILED", "", error)
    }
    }
    
    /*let saveSuccessful: Bool = KeychainWrapper.standard.set(password, forKey: key, withAccessibility:.whenPasscodeSetThisDeviceOnly )
    print("SAVE _SUCCESSFUL", saveSuccessful);*/
  }
  
  @objc func getItem(_ key:String, resolve:@escaping RCTPromiseResolveBlock, reject:@escaping RCTPromiseRejectBlock) {
    let keychain = Keychain()
    
    DispatchQueue.global().async {
      do {
        let password = try keychain
          .authenticationPrompt("Authenticate to login to server")
          .get(key)
        
        print("GET_ITEM: \(String(describing: password))")
        resolve(password)
      } catch let error {
        print(error)
        
        reject("GET FAILED", "", error)
      }
    }
    
    /*let retrievedString: String! = KeychainWrapper.standard.string(forKey: key, withAccessibility:.whenPasscodeSetThisDeviceOnly )
    print("GET ITEM", retrievedString);
    
    return retrievedString ?? ""*/
  }
  
  @objc func delete(_ key:String, resolve:RCTPromiseResolveBlock, reject:RCTPromiseRejectBlock) {
    /*let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: key, withAccessibility:.whenPasscodeSetThisDeviceOnly )
    print("REMOVE ITEM", removeSuccessful);*/
    
    let keychain = Keychain()
    resolve(true)
    do {
      try keychain.remove(key)
    } catch let error {
      print(error)
      
      reject("DELETE FAILED", "", error)
    }
  }
}
