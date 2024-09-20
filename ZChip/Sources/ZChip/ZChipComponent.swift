//
//  File.swift
//  
//
//  Created by Manikandan on 20/09/24.
//

import Foundation
import UIKit

public protocol ZChipComponentDelegate : AnyObject{
    func didChangeHeight(size : CGSize)
    func didSelectNewItem(item : Tag)
}

public class ZChipComponent : UIView
{
    
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    public weak var delegate : ZChipComponentDelegate?
    static let nibName = "ZChipComponent"
    var viewModel : ZChipComponentViewModel?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        onLoad()
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        onLoad()
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle.module
        let nib = UINib(nibName: ZChipComponent.nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    private func onLoad(){
        setUpCollectionView()
        registerCells()
        addContentChangeObserver()
    }
        
    func addContentChangeObserver(){
        self.tagCollectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    public override  func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newSize = change?[.newKey] as? CGSize {
                print("CollectionView Size -> \(newSize)")
                self.delegate?.didChangeHeight(size: newSize)
            }
        }
    }
    
    private func setUpCollectionView(){
        let alignedFlowLayout =  AlignedCollectionViewFlowLayout()
        alignedFlowLayout.horizontalAlignment = .left
        alignedFlowLayout.minimumLineSpacing = 5
        self.tagCollectionView.collectionViewLayout = alignedFlowLayout
    }
    
    private func registerCells(){
        let bundle = Bundle.module
        self.tagCollectionView.registerCollectionViewCell(collectionCell: TagCell(),bundle: bundle)
    }
    
    public func config(viewModel : ZChipComponentViewModel){
        self.viewModel = viewModel
        self.tagCollectionView.dataSource = self
        self.tagCollectionView.delegate = self
    }
    
    public func updateTags(tags : [Tag]){
        self.viewModel?.tags = tags
        self.tagCollectionView.reloadData()
    }
        
}

extension ZChipComponent : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let _viewModel = viewModel{
                if let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagCell{
                    tagCell.config(model: _viewModel.createViewModel(index: indexPath.row))
                    return tagCell
                }
        }
        return UICollectionViewCell()
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.tags.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let _viewModel = viewModel{
            let font = UIFont.systemFont(ofSize: 15)
            let tagValue = _viewModel.getTagValue(index: indexPath.row)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = (tagValue as NSString).size(withAttributes: fontAttributes)
            return CGSize(width: size.width + 20, height: 40)
        }
        return CGSize()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let _viewModel = viewModel{
            let item = _viewModel.tags[indexPath.row]

            if let currentSelectedItem = _viewModel.tags.filter({$0.isSelected == true}).first{
                if currentSelectedItem.id == item.id{
                    return
                }
            }
            self.delegate?.didSelectNewItem(item: item)
        }
        
        self.viewModel?.updateTags(indexPath.row)
        self.tagCollectionView.reloadData()
    }
}
