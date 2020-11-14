//
//  MainPageViewController.swift
//  TestApp
//
//  Created by Данил Казаков on 12.11.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    let refreshControl: UIRefreshControl = {
        let myRefreshControl = UIRefreshControl()
        myRefreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return myRefreshControl
    }()
    
    @IBOutlet var searchBarOutlet: UISearchBar!
    @IBOutlet weak var tableViewOutlet: UITableView!
    var userRepository: Repo?
    var gitUser: String?
    var pageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIServise.shared.getData(pageCount: pageCount, gitUser: "octocat") { repos in
            self.userRepository = repos
            print(self.userRepository?.items)
            DispatchQueue.main.async {
                self.tableViewOutlet.reloadData()
            }
        }
        tableViewOutlet.refreshControl = refreshControl
        
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        APIServise.shared.getData(pageCount: pageCount, gitUser: "octocat") { repos in
            self.userRepository = repos
            DispatchQueue.main.async {
                self.tableViewOutlet.reloadData()
            }
        }
        print(searchBarOutlet.text)
        sender.endRefreshing()
    }
    
    private func createActivityIndicator() -> UIView {
        let footerView = UIView (frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = footerView.center
        
        activityIndicator.startAnimating()
        return footerView
    }
    
//MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let userRepositoryForTable = userRepository?.items else {
            return 0
        }
        return userRepositoryForTable.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as! RepositoryListTableViewCell
        
        let item = userRepository?.items[indexPath.item]
            cell.item = item

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userRepositoryRow = userRepository?.items[indexPath.row]
        let nextVC = self.storyboard?.instantiateViewController(identifier: "DetailedRepositoryViewController") as! DetailedRepositoryViewController
        nextVC.selectedRepository = userRepositoryRow?.owner.repos_url
        nextVC.userData = userRepository?.items[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
     
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableViewOutlet.contentSize.height - 100 - scrollView.frame.size.height) {
            guard !APIServise.shared.isPaginating else { return }
            print(APIServise.shared.isPaginating)
            self.tableViewOutlet.tableFooterView = createActivityIndicator()
            APIServise.shared.getData(pagination: true, pageCount: pageCount, gitUser: "") { (repos) in
                DispatchQueue.main.async {
                    self.tableViewOutlet.tableFooterView = nil
                }
                self.pageCount = self.pageCount + 1
                self.userRepository?.items.append(contentsOf: repos.items)
                    DispatchQueue.main.async {
                        self.tableViewOutlet.reloadData()
                    }
            }
        }
    }
}
