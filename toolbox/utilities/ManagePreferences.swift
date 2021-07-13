//
//  ManagePreferences.swift
//  toolbox
//
//  Created by Cesar Guasca on 12/07/21.
//

import Foundation
import UIKit

class ManagerPreferences{
    static let shared:ManagerPreferences = ManagerPreferences()
    //Token
    open func writeToken(_ str: String){
        let defaults = UserDefaults.standard
        defaults.set(str, forKey: "token")
    }
    //Token
    open func readingToken() -> String {
        let defaults = UserDefaults.standard
        let str = defaults.string(forKey: "token")
        return str ?? ""
    }
    //Date
    open func writeExpirationDate(_ dt: Double){
        let defaults = UserDefaults.standard
        defaults.set(dt, forKey: "dateExpiration")
    }
    //Date
    open func readingeExpirationDate() -> Double {
        let defaults = UserDefaults.standard
        let dbl = defaults.double(forKey: "dateExpiration")
        return dbl
    }
    //Is login
    open func writeIsLogin(_ b: Bool){
        let defaults = UserDefaults.standard
        defaults.set(b, forKey: "isLogin")
    }
    //Is Login
    open func readingeIsLogin() -> Bool {
        let defaults = UserDefaults.standard
        let bolreturn = defaults.bool(forKey: "isLogin")
        return bolreturn
    }
}
