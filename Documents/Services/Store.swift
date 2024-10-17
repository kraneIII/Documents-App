//
//  Store.swift
//  Documents
//
//  Created by Ковалев Никита on 09.10.2024.
//

import Foundation
import KeychainSwift

protocol PasswordManager {
    func checkPassword(password: String) -> Bool
    func savePassword(password: String)
    func reloadPassword(password: String)
    func startPassword() -> Bool
}

final class PasswordManagerService: PasswordManager {
    
    let keychain = KeychainSwift()
    
    func checkPassword(password: String) -> Bool {
        let enteredPassword = keychain.get("password")
        if enteredPassword != nil {
            return true
        }
            return false
    }
    
    func savePassword(password: String) {
        keychain.set(password, forKey: "password")
    }
    
    func reloadPassword(password: String) {
        keychain.delete("password")
        keychain.set(password, forKey: "password")
    }
    
    func startPassword() -> Bool {
        if keychain.get("password") != nil {
            return true
        }
            return false
    }
    }
    
    
    
    

