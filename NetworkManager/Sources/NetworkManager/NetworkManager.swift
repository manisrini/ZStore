// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public class NetworkManager{
    
    public static let shared = NetworkManager()
    
    public func getData(urlStr : String,completion : @escaping(Data?,String?) -> Void){
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
