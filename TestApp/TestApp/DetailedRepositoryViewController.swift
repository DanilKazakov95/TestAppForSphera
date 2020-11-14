//
//  DetailedRepositoryViewController.swift
//  TestApp
//
//  Created by Данил Казаков on 13.11.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import UIKit

class DetailedRepositoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet var avatarImageOutlet: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userLoginLabel: UILabel!
    @IBOutlet var detailedTableView: UITableView!
    @IBOutlet var publishedAtLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    var selectedRepository: String?
    var userRepoData: [UserRepo]?
    var userData: Items?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataRepo(gitUser: "octocat") { repos in
            self.userRepoData = repos
        }
//        detailedTableView.rowHeight = UITableView.automaticDimension
        userNameLabel.text = userData?.name
        userLoginLabel.text = userData?.owner.login
        publishedAtLabel.text = userData?.created_at
        avatarImageOutlet.downloaded(from: (userData?.owner.avatar_url)!)
    }
    
    func getDataRepo(gitUser: String, completion: @escaping([UserRepo]) -> Void) {
        guard let url = URL(string: "\(selectedRepository!)") else {return}
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode([UserRepo].self, from: data)
                    completion(res)
                    DispatchQueue.main.async {
                        self.detailedTableView.reloadData()
                    }
                } catch let error {
                    print(error)
                }
            }
        }.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userRepositoryForTable = userRepoData else {
            return 0
        }
        return userRepositoryForTable.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = detailedTableView.dequeueReusableCell(withIdentifier: "detailedCell", for: indexPath) as! DetailerRepositoryTableViewCell

        cell.itemFromUserInfo = userRepoData![indexPath.row]
         
        return cell
     }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//       
//    }
//    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
}
