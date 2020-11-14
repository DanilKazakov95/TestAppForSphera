//
//  DetailerRepositoryTableViewCell.swift
//  TestApp
//
//  Created by Данил Казаков on 13.11.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import UIKit

class DetailerRepositoryTableViewCell: UITableViewCell {
    @IBOutlet var repoName: UILabel!
    @IBOutlet var language: UILabel!
    @IBOutlet var lastUpdate: UILabel!
    @IBOutlet var forkCount: UILabel!
    
//    var item: Repo? {
//           didSet {
//            //repoName.text = item?.language
////            lastUpdate.text = item?.items
////            forkCount.text = "\(item?.name)"
//            //language.text = item?.language
//           }
//       }
    
    var expanded = false
    @IBAction func expand(_ sender: Any) {
        expanded = !expanded
        lastUpdate.isHidden = expanded
        forkCount.isHidden = expanded
    }
    
    var itemFromUserInfo: UserRepo? {
        didSet {
            expanded = false
            lastUpdate.text = itemFromUserInfo?.updated_at
            repoName.text = itemFromUserInfo?.name
            forkCount.text = "Forks count: \(itemFromUserInfo!.forks_count)"
            language.text = itemFromUserInfo?.language ?? "The language is not specified"
            
            
        }
    }
   
}
