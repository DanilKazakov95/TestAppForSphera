//
//  Repo.swift
//  TestApp
//
//  Created by Данил Казаков on 13.11.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import Foundation

struct UserRepo: Codable {
    var updated_at: String?
    var forks_count: Int
    var name: String?
    var language: String?
}

struct UserInfo: Codable {
    var location: String?
}
