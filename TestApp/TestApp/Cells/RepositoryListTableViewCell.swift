//
//  RepositoryListTableViewCell.swift
//  TestApp
//
//  Created by Данил Казаков on 13.11.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import UIKit

class RepositoryListTableViewCell: UITableViewCell {

    @IBOutlet var avatarImage: UIImageView!
    @IBOutlet var loginLabel: UILabel!
    @IBOutlet var userTypeLabel: UILabel!
    
    var item: Items! {
        didSet {
            loginLabel.text = "Login: \(item.owner.login!)"
            userTypeLabel.text = "User Type: \(item.owner.type!)"
            avatarImage.downloaded(from: item.owner.avatar_url!)
        }
    }
    
}
