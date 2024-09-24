//
//  HomeScreenHelper.swift
//  ZStore
//
//  Created by Manikandan on 24/09/24.
//

import UIKit

class HomeScreenHelper{
    
   static func setUpSearchController() -> UISearchController{
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.showsCancelButton = false
        return searchController
    }
}
