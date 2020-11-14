//
//  Model.swift
//  TestApp
//
//  Created by Данил Казаков on 13.11.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import Foundation

struct Repo: Codable {
    var total_count: Int?
    var items: [Items]
}

struct Items: Codable {
    var owner: Owner
    var name: String?
    var created_at: String?
}

struct Owner: Codable {
    var repos_url: String?
    var login: String?
    var type: String?
    var avatar_url: String?
}
