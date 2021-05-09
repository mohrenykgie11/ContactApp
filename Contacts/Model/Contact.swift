//
//  Contact.swift
//  Contacts
//
//  Created by Morenikeji on 5/9/21.
//

import Foundation
import UIKit


@objc class Contact : NSObject {
    @objc var name: String!
    @objc var phone: String!
    
    init(name: String, phone: String) {
        self.name = name
        self.phone = phone
        
    }
}
