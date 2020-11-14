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
    var isPaginating = false
    
    func getData(pagination: Bool = false, pageCount: Int, gitUser: String, completion: @escaping(Repo) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 2)) {
             print(pagination)
                   if pagination {
                    self.isPaginating = true
                   }
                   print(pagination)
                   guard let url = URL(string: "https://api.github.com/search/repositories?q=github?page=\(pageCount)&per_page=25") else {return}
                   print(url)
                   URLSession.shared.dataTask(with: url) {data, response, error in
                       if let data = data {
                           do {
                               let res = try JSONDecoder().decode(Repo.self, from: data)
                               completion(res)
                           } catch let error {
                               print(error)
                           }
                       }
                   }.resume()
                   
                   if pagination {
                    self.isPaginating = false
                   }
            print(pagination)
                   
               }
        }
    
}
