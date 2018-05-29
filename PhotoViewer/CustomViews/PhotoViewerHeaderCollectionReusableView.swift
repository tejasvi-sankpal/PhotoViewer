//
//  PhotoViewerHeaderCollectionReusableView.swift
//  PhotoViewer
//
//  Created by Admin on 18/05/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
let KEY_TABLEROW_HEIGHT = 44
let KEY_IMPORT_VIEW_HEIGHT = 50
let KEY_OFFSET_HEIGHT = 20

class PhotoViewerHeaderCollectionReusableView: UICollectionReusableView {
    
    let socialNetworksArray: [String] = ["Instagram", "Flicker", "Pintrest"]
    let socialNetworksIconsArray: [String] = ["insta", "flicker", "pintrest"]
    let cellReuseIdentifier = "DropDownCell"
    var isImportClicked : Bool?
    
    weak var delegate: classReloadDataDelegate?
    
    @IBOutlet weak var importView: UIView!
    @IBOutlet weak var dropdownView: UIView!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var dropdownViewHeightConstrainght: NSLayoutConstraint!
    @IBOutlet weak var dropDownTableview: UITableView!
    @IBOutlet weak var importBtn: UIButton!
    
    @IBAction func importButtonClicked(_ sender: UIButton) {
        
        if isImportClicked! {
            removeViewsFromStackView()
            isImportClicked = false
            delegate?.ReloadSectionForIndex(indexPath:IndexPath.init(row: 0, section: 0) ,withImportFlag:false, withNwtwork:"")
        }else{
            isImportClicked = true
            addViewsToStackView()
            delegate?.ReloadSectionForIndex(indexPath:IndexPath.init(row: 0, section: 0) ,withImportFlag:true, withNwtwork:"")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUIHeightAsPerContent()
        removeViewsFromStackView()
        self.heightAnchor.constraint(equalToConstant: CGFloat(calculateHeaderHeight()))
        headerStackView.updateConstraints()
        headerStackView.layoutIfNeeded()
        
        
        
        
    }
    
    func setUIHeightAsPerContent(){
        dropDownTableview.frame = CGRect(x: dropDownTableview.frame.origin.x, y: dropDownTableview.frame.origin.y, width: dropDownTableview.frame.size.width, height: (CGFloat(KEY_TABLEROW_HEIGHT * socialNetworksArray.count)))
        dropdownViewHeightConstrainght.constant = (CGFloat(KEY_TABLEROW_HEIGHT * socialNetworksArray.count))
    }
    
    func calculateHeaderHeight() -> Float {
        isImportClicked = isImportClicked ?? false
        if isImportClicked!{
            let dropdownViewHeight = KEY_TABLEROW_HEIGHT * socialNetworksArray.count
            let mainviewHeight = dropdownViewHeight + KEY_IMPORT_VIEW_HEIGHT + KEY_OFFSET_HEIGHT
            return Float(mainviewHeight)
        }else{
            return 70
        }
        
    }
    
    func removeViewsFromStackView(){
        headerStackView.removeArrangedSubview(dropdownView)
        dropdownView.isHidden = true
    }
    
    func addViewsToStackView(){
        
        // headerStackView.addArrangedSubview(dropdownView)
        headerStackView.insertArrangedSubview(dropdownView, at: 0)
        dropdownView.isHidden = false
    }
    
}
//MARK: UITableViewDataSource Protocol
extension PhotoViewerHeaderCollectionReusableView : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.socialNetworksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:dropdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell! as! dropdownTableViewCell
        
        // set the text from the data model
        cell.socialNetworkTitle.text = self.socialNetworksArray[indexPath.row]
        cell.logoImage.image = UIImage.init(named:self.socialNetworksIconsArray[indexPath.row])
        
        return cell
        
    }
    
}
//MARK: UITableViewDelegate Protocol
extension PhotoViewerHeaderCollectionReusableView : UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        removeViewsFromStackView()
        isImportClicked = false
        delegate?.ReloadSectionForIndex(indexPath:IndexPath.init(row: 0, section: 0) ,withImportFlag:false, withNwtwork:socialNetworksArray[indexPath.row])
    }
    
}
