//
//  UsersVC.swift
//  SampleTaskApp
//
//  Created by Pravin's Mac M1 on 10/04/24.
//

import UIKit
import CoreData

class UsersVC: UITableViewController {
    
    var userResponses: [UserResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsers()
    }
    
    
}

extension UsersVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userResponses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTVCell", for: indexPath) as! UserTVCell
        
        let user = userResponses[indexPath.row]
        
        cell.nameLabel.text = user.name
        cell.emailLabel.text = user.email
        cell.phoneLabel.text = user.mobile
        cell.genderLabel.text = user.gender
        
        return cell
    }
}

//MARK: - Retrive saved data from CoreData
extension UsersVC {
    
    func getUsers() {
        let container = CoreDataHelper.shared.persistentContainer
        let managedContext = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "id") as? String ?? ""
                let name = data.value(forKey: "name") as? String ?? ""
                let email = data.value(forKey: "email") as? String ?? ""
                let mobile = data.value(forKey: "mobile") as? String ?? ""
                let gender = data.value(forKey: "gender") as? String ?? ""
                
                
                let userResponse = UserResponse(_id: id, name: name, email: email, mobile: mobile, gender: gender)
                userResponses.append(userResponse)
            }
            tableView.reloadData()
        } catch {
            print("Failed to fetch user responses: \(error)")
        }
    }
    
}
