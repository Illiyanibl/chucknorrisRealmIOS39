//
//  ProjectExtension.swift
//  HWRealm_BlinovIOS39
//
//  Created by Illya Blinov on 15.02.24.
//

import UIKit

protocol AlertsDelegate: AnyObject {
    func callAlert(description: String, title: String)
}

extension UIViewController {
    func callAlert(description: String, title: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "Ok", style: .default) { _ in }
        alert.addAction(actionOk)
        present(alert, animated: true)
    }
}
