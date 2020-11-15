//
//  MainPageViewController.swift
//  TestApp
//
//  Created by Данил Казаков on 12.11.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, UISearchBarDelegate {
    
    let refreshControl: UIRefreshControl = {
        let myRefreshControl = UIRefreshControl()
        myRefreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return myRefreshControl
    }()
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    @IBOutlet weak var tableViewOutlet: UITableView!
    var userRepository: Repository?
    var gitUser: String?
    var enteredSearchBarText: String?
    var pageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIServise.shared.getData(gitUser: enteredSearchBarText ?? "github") { repos in
            self.userRepository = repos
            DispatchQueue.main.async {
                self.tableViewOutlet.reloadData()
            }
        }
        setupUIElements()
    }
    
    private func setupUIElements() {
        searchBarOutlet.endEditing(true)
        searchBarOutlet.delegate = self
        tableViewOutlet.refreshControl = refreshControl
        self.tableViewOutlet.keyboardDismissMode = .onDrag
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        APIServise.shared.getData(gitUser: enteredSearchBarText ?? "github") { repos in
            self.userRepository = repos
            DispatchQueue.main.async {
                self.tableViewOutlet.reloadData()
            }
        }
        sender.endRefreshing()
    }
    
    //MARK: Footer View
    private func createActivityIndicator() -> UIView {
        let footerView = UIView (frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.center = footerView.center
        
        activityIndicator.startAnimating()
        return footerView
    }
    
    //MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        enteredSearchBarText = searchText
        APIServise.shared.getData(gitUser: enteredSearchBarText ?? "github") { repos in
            self.userRepository = repos
            DispatchQueue.main.async {
                self.tableViewOutlet.reloadData()
            }
        }
        tableViewOutlet.reloadData()
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
    
    //MARK: Filter Button
    @IBAction func filtrateBarButtonAction(_ sender: Any) {
        let actionSheet =  UIAlertController(title: "To sort by name?", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Sort", style: UIAlertAction.Style.default, handler: { (ACTION :UIAlertAction!)in
            APIServise.shared.getData(gitUser: self.enteredSearchBarText!, accountSort: true) { Repo in
                self.userRepository = Repo
                DispatchQueue.main.async {
                    self.tableViewOutlet.reloadData()
                }
            }
        }))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: Scroll View Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableViewOutlet.contentSize.height-100-scrollView.frame.size.height) {
            guard !APIServise.shared.isPaginating else { return }
            self.tableViewOutlet.tableFooterView = createActivityIndicator()
            APIServise.shared.getData(pagination: true, pageCount: pageCount, gitUser: "") { (repos) in
                self.pageCount = self.pageCount + 1
                self.userRepository?.items.append(contentsOf: repos.items)
                DispatchQueue.main.async {
                    self.tableViewOutlet.reloadData()
                    self.tableViewOutlet.tableFooterView = nil
                }
            }
        }
    }
}
