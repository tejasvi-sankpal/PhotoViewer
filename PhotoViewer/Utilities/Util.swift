//
//  Util.swift
//  PhotoViewer
//
//  Created by Admin on 25/05/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class Util: NSObject {
    static let sharedInstance = Util()
    private override init() {}
}

extension Util {
    func shoWAlert() -> UIAlertController{
        let alert = UIAlertController(title: "Message", message: "This feature is coming soon...", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
}
