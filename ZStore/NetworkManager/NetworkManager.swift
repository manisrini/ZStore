//
//  NetworkManager.swift
//  ZStore
//
//  Created by Manikandan on 20/09/24.
//

import Foundation

class NetworkManager{
    
    static let shared = NetworkManager()
    
    func getData(urlStr : String,completion : @escaping(Data?,String?) -> Void){
        if let url = URL(string: urlStr){
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error == nil{
                    completion(data,nil)
                }else{
                    completion(nil, error?.localizedDescription)
                }
            }.resume()
        }
    }
    
}
