//
//  KeychainManager.swift
//  AwesimTouch
//
//  Created by Asim Malik on 11/05/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

@objc(KeychainManager)
class KeychainManager : NSObject{
  
  @objc func test() {
    
    let removeSuccessful: Bool = KeychainWrapper.standard.removeAllKeys()
    print("REMOVE SUCCESSFUL", removeSuccessful);
    
    /*let saveSuccessful: Bool = KeychainWrapper.standard.set("Some String", forKey: "myKey")
    print("SAVE SUCCESSFUL", saveSuccessful);
    
    let retrievedString: String! = KeychainWrapper.standard.string(forKey: "myKey")
    print("%@", retrievedString);
 */
  }
  
  @objc func save(_ key:String, password:String){
    let saveSuccessful: Bool = KeychainWrapper.standard.set(password, forKey: key, withAccessibility:.whenPasscodeSetThisDeviceOnly )
    print("SAVE _SUCCESSFUL", saveSuccessful);
  }
  
  @objc func getItem(_ key:String) -> String {
    let retrievedString: String! = KeychainWrapper.standard.string(forKey: key, withAccessibility:.whenPasscodeSetThisDeviceOnly )
    print("GET ITEM", retrievedString);
    
    return retrievedString ?? ""
  }
  
  @objc func delete(_ key:String) {
    let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: key, withAccessibility:.whenPasscodeSetThisDeviceOnly )
    print("REMOVE ITEM", removeSuccessful);
  }
}
