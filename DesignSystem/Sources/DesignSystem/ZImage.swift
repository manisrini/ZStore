//
//  SwiftUIView.swift
//  
//
//  Created by Manikandan on 21/09/24.
//

import UIKit
import SDWebImage

public class ZImageView : UIImageView{
        
    public func loadImage(url : String){
        
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_imageTransition = .flipFromTop
        
        if let url = URL(string: url){
            let placeholderImage = UIImage(named: "thumbnail",in: .module,compatibleWith: nil)
            self.sd_setImage(with: url) { image, error, type, url in
                if error != nil{
                    self.image = placeholderImage
                }
            }
        }
    }
}
