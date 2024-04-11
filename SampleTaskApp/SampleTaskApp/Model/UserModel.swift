//
//  UserModel.swift
//  SampleTaskApp
//
//  Created by Pravin's Mac M1 on 10/04/24.
//

import Foundation

// MARK: - Student Attendance Response
struct UserResponse: Codable {
    var _id: String?
    var name: String?
    var email: String?
    var mobile: String?
    var gender: String?
}

//"_id": "66157c27b6787603e855c7ba",
//"name": "S Rahman",
//"email": "rahman@crud.com",
//"mobile": "9500089898",
//"gender": "Male"
