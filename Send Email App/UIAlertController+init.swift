//
//  UIAlertController+init.swift
//  Send Email App
//
//  Created by Александр Алгашев on 16/02/2019.
//  Copyright © 2019 Александр Алгашев. All rights reserved.
//

import UIKit

extension UIAlertController {
    convenience init(title: String, message: String) {
        self.init(title: title, message: message, preferredStyle: .alert)
        self.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            print("The \"\(title)\" alert occured.")
        }))
    }
}
