//
//  Utilities.swift
//  SampleTaskApp
//
//  Created by Pravin's Mac M1 on 10/04/24.
//

import Foundation
import UIKit

class Common {
    
    static func showAlertWithOkCancel(title: String?, message: String?, okTitle: String = "OK", cancelTitle: String? = nil, okHandler: (() -> Void)? = nil, cancelHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
            okHandler?()
        }
        alertController.addAction(okAction)
        
        // Check if cancelTitle and cancelHandler are provided before adding the cancel action
        if let cancelTitle = cancelTitle, let cancelHandler = cancelHandler {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelHandler()
            }
            alertController.addAction(cancelAction)
        }
        
        presentAlertController(alertController)
    }
    
    static func showAlertWithoutCancelButton(title: String?, message: String?, okTitle: String = "OK", okHandler: (() -> Void)? = nil) {
        showAlertWithOkCancel(title: title, message: message, okTitle: okTitle, cancelTitle: "", okHandler: okHandler, cancelHandler: nil)
    }
    
    static func showAlert(title: String?, message: String?, okTitle: String = "OK") {
        showAlertWithOkCancel(title: title, message: message, okTitle: okTitle)
    }
    
    
    static func presentAlertController(_ alertController: UIAlertController) {
        // Present the alert controller from the topmost view controller
        if var topController = UIApplication.shared.windows.first?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(alertController, animated: true, completion: nil)
        }
    }
}

class StyleUtility {

    static func applyTextFieldStyle(to textField: UITextField, placeholder: String, cornerRadius: CGFloat? = nil) {
        textField.placeholder = placeholder
        textField.tintColor = .darkGray
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1.0
        
        if let radius = cornerRadius {
            textField.layer.cornerRadius = radius
            textField.clipsToBounds = true
        }
    }
    
}


//MARK: - Validate Email and Phone -
class Validation: NSObject {
    
    // Validate Email
    class func isValidEmail(value: String) -> Bool {
        
        print("validate emilId: \(value)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: value)
        return result
    }
    
    // Validate Phone Number
    class func isValidPhoneNo(value: String) -> Bool {
        let PHONE_REGEX = "^[0-9]{10}$" //"^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    //Validate Password
    class func isValidPassword(value: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}$"
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let result = passwordTest.evaluate(with: value)
        
        return result
    }
    
}

// common class for - remove empty space of header and footer
class ConfigurableTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableViewSectionHeaderFooter()
    }

    func configureTableViewSectionHeaderFooter() {
        tableView.delegate = self
    }
}

// remove empty space of header and footer on static table view controller
extension ConfigurableTableViewController {
    // MARK: - TableView Section Header/Footer Configuration
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : UITableView.automaticDimension
    }
}

extension UITableView {
    // MARK: - TableView empty data Configuration
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold) // Set system font with weight
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    // Restore empty image
    func restoreMessage() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
}

