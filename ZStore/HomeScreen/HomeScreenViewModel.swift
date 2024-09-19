//
//  HomeScreenViewModek.swift
//  ZStore
//
//  Created by Manikandan on 19/09/24.
//

import Foundation

class HomeScreenViewModel{
    
    func fetchData(completion : @escaping() -> Void){
        let url = "https://raw.githubusercontent.com/princesolomon/zstore/main/data.json"
        
        NetworkManager.shared.getData(urlStr: url) { [weak self] data, error in
            guard let _data = data else{ return }
                    
            do{
                if let response = try JSONSerialization.jsonObject(with: _data, options: .fragmentsAllowed) as? [String:Any]{
                    completion()
                }
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
