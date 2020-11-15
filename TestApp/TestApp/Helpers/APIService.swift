//
//  APIService.swift
//  TestApp
//
//  Created by Данил Казаков on 12.11.2020.
//  Copyright © 2020 Danil Moguchiy. All rights reserved.
//

import Foundation

class APIServise {
    
    static let shared = APIServise()
    var sortText: String = ""
    var isPaginating = false
    
    func getData(pagination: Bool = false, pageCount: Int = 0, gitUser: String = "all", accountSort: Bool = false, completion: @escaping(Repository) -> Void) {
        
        if accountSort == true {
            sortText = "&sort=login"
        } else {
            sortText = ""
        }
        
        if pagination {
            self.isPaginating = true
        }
        
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(gitUser)?page=\(pageCount)&per_page=25\(sortText)") else {return}
        
        URLSession.shared.dataTask(with: url) {data, response, error in
            if let data = data {
                do {
                    let res = try JSONDecoder().decode(Repository.self, from: data)
                    completion(res)
                } catch let error {
                    print(error)
                }
            }
            if pagination {
                self.isPaginating = false
            }
        }.resume()
    }
}
