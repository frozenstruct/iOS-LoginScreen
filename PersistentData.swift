//
//  LoginsDataModel.swift
//  AVSoftTest
//
//  Created by Dmitry Aksyonov on 29.02.2020.
//  Copyright © 2020 Dmitry Aksyonov. All rights reserved.
//

import Foundation

class PersistentData {
    static let shared = PersistentData()
    
    private let eMailKey = "LoginsDataModel.eMailKey"
    private let passwordKey = "LoginsDataModel.passwordKey"
    
    var eMail: String {
        get { return UserDefaults.standard.string(forKey: eMailKey) ?? "null" }
        set { UserDefaults.standard.setValue(newValue, forKey: eMailKey) }
    }
    var password: String {
        get { return UserDefaults.standard.string(forKey: passwordKey) ?? "null" }
        set { UserDefaults.standard.setValue(newValue, forKey: passwordKey) }
    }
}
