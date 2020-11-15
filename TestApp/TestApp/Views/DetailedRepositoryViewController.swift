//
//  DetailedRepositoryViewController.swift
//  TestApp
//
//  Created by Данил Казаков on 13.11.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class DetailedRepositoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var avatarImageOutlet: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLoginLabel: UILabel!
    @IBOutlet weak var detailedTableView: UITableView!
    @IBOutlet weak var publishedAtLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var selectedRepository: String?
    var userRepoData: [UserRepo]?
    var userData: Items?
    var userInfo: UserInfo?
    
    var selectedIndex = -1
    var isCollapced = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataRepo { repos in
            self.userRepoData = repos
        }
        
        getUserData { location in
            self.userInfo = location
            DispatchQueue.main.async {
                self.locationLabel.text = self.userInfo?.location
            }
        }
        
        setupUIElements()
    }
    
//MARK: Setup UI
    private func setupUIElements() {
        view.backgroundColor = .systemBackground
        
        detailedTableView.estimatedRowHeight = 136
        detailedTableView.rowHeight = UITableView.automaticDimension
        
        userNameLabel.text = userData?.name
        userLoginLabel.text = userData?.owner.login
        publishedAtLabel.text = userData?.created_at
        avatarImageOutlet.downloaded(from: (userData?.owner.avatar_url)!)
    }
    
//Fetch Data Methods
    func getDataRepo(completion: @escaping([UserRepo]) -> Void) {
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
    
    func getUserData(completion: @escaping(UserInfo) -> Void) {
        guard let url = URL(string: "https://api.github.com/users/\(userData!.owner.login!)") else {return}
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode(UserInfo.self, from: data)
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
//MARK: Expand Cell Action
    @objc private func expandTapped(_ sender: UIButton){
        if self.isCollapced == false {
            self.isCollapced = true
        } else {
            self.isCollapced = false
        }
        let chosenCell = detailedTableView.indexPathsForVisibleRows
        selectedIndex = sender.tag
        detailedTableView.reloadRows(at: chosenCell!, with: .automatic)
    }
//MARK: Table View Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userRepositoryForTable = userRepoData else {
            return 0
        }
        return userRepositoryForTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailedTableView.dequeueReusableCell(withIdentifier: "detailedCell", for: indexPath) as! DetailerRepositoryTableViewCell
        cell.itemFromUserInfo = userRepoData![indexPath.row]
        cell.expandButtonOutlet.tag = indexPath.row
        cell.expandButtonOutlet.addTarget(self, action: #selector(expandTapped(_:)), for: .touchDown)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedIndex == indexPath.row && isCollapced == true {
            return 168
        } else {
            return 75
        }
    }
}
