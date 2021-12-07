//
//  Company.swift
//  AvitoTest
//
//  Created by Антон Кочетков on 05.12.2021.
//

import Foundation

struct ParseModel: Codable {
    let company: Company
}

struct Company: Codable {
    let name: String
    let employees: [Employee]
}

struct Employee: Codable {
    let name, phoneNumber: String
    let skills: [String]

    enum CodingKeys: String, CodingKey {
        case name
        case phoneNumber = "phone_number"
        case skills
    }
}
