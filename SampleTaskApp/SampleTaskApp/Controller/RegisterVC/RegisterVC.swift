//
//  RegisterVC.swift
//  SampleTaskApp
//
//  Created by Suhel's Mac M1 on 11/04/24.
//

import UIKit
import CoreData

class RegisterVC: ConfigurableTableViewController {

    var userResponse : UserResponse?
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaultUI()
    }

    @IBAction func usersDidTap(_ sender: UIButton) {
        performSegue(withIdentifier: "showUsers", sender: nil)
    }
    
    
    @IBAction func registerDidTap(_ sender: UIButton) {
        if isValidAllFields() {
            submitUserDetails()
        }
    }
    
    func defaultUI() {
        StyleUtility.applyTextFieldStyle(to: nameTF, placeholder: "", cornerRadius: 25)
        StyleUtility.applyTextFieldStyle(to: emailTF, placeholder: "", cornerRadius: 25)
        StyleUtility.applyTextFieldStyle(to: mobileTF, placeholder: "", cornerRadius: 25)
        
        registerButton.layer.cornerRadius = 25
        registerButton.clipsToBounds = true
    }
   
}

extension RegisterVC {
    
    func submitUserDetails() {
        guard let name = nameTF.text, let email = emailTF.text, let mobile = mobileTF.text else { return }
        
        let gender = genderSwitch.isOn ? "Male" : "Female"
        
        let param: [String: Any] = ["name": name,
                                     "email": email,
                                     "mobile": mobile,
                                     "gender": gender]
        
        let url = "https://crudcrud.com/api/1f2f74b058c749aebd14a8607dcd6e5a/register"
        
        NetworkManager.apiCall(serviceName: url, apiType: .post, param: param) { (response, data, error) in
            if let httpResponse = response {
                if httpResponse.statusCode == 201 {
                    guard let responseData = data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let userResponse = try decoder.decode(UserResponse.self, from: responseData)
                        
                        // Save the response to CoreData
                        CoreDataHelper.shared.saveUserResponse(userResponse)
                        
                        // Show success alert
                        Common.showAlertWithOkCancel(title: "Success!", message: "User details were successfully registered.", okHandler: {
                            // Clear the fields for the next registration
                            self.clearTextFields()
                            self.resignFirstResponder()
                        })
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                } else {
                    Common.showAlert(title: "Error", message: "An error occurred. Please try again later.")
                }
            }
        }
    }
    
    func clearTextFields() {
        nameTF.text = ""
        emailTF.text = ""
        mobileTF.text = ""
    }
}

extension RegisterVC {
    
    func isValidAllFields() -> Bool {
            if nameTF.text == "" {
                Common.showAlert(title: "Empty Field", message: "Please enter your name.")
                return false
            } else if emailTF.text == "" {
                Common.showAlert(title: "Empty Field", message: "Please enter your email address.")
                return false
            } else if mobileTF.text == "" {
                Common.showAlert(title: "Empty Field", message: "Please enter your mobile number.")
                return false
            } else if !Validation.isValidEmail(value: emailTF.text!) {
                Common.showAlert(title: "Invalid Email", message: "Please enter a valid email address!")
                return false
            } else if !Validation.isValidPhoneNo(value: mobileTF.text!) {
                Common.showAlert(title: "Invalid Email", message: "Please enter a valid phone number!")
                return false
            } else {
                print("Textfield Validation Success.")
                return true
            }
        }
}

// MARK: - CoreDataHelper

class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SampleTaskAppModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveUserResponse(_ userResponse: UserResponse) {
        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: context) else {
            print("Entity description for 'User' not found.")
            return
        }
        
        let newUser = NSManagedObject(entity: entity, insertInto: context)
        newUser.setValue(userResponse.name, forKeyPath: "name")
        newUser.setValue(userResponse.email, forKeyPath: "email")
        newUser.setValue(userResponse.mobile, forKeyPath: "mobile")
        newUser.setValue(userResponse.gender, forKeyPath: "gender")
        newUser.setValue(userResponse._id, forKeyPath: "id")
        
        do {
            try context.save()
            print("User response saved to CoreData.")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
