//
//  DetailerRepositoryTableViewCell.swift
//  TestApp
//
//  Created by Данил Казаков on 13.11.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import UIKit

class DetailerRepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var forkCount: UILabel!
    @IBOutlet weak var expandButtonOutlet: UIButton!
    
    var itemFromUserInfo: UserRepo? {
        didSet {
            lastUpdate.text = "Updated At: \((itemFromUserInfo?.updated_at)!)"
            repoName.text = "Name: \((itemFromUserInfo?.name)!)"
            forkCount.text = "Forks count: \(itemFromUserInfo!.forks_count)"
            language.text = "Language: \(itemFromUserInfo?.language ?? "The language is not specified")"
        }
    }
}
