//
//  PhotosCollectionViewController.swift
//  PhotoViewer
//
//  Created by Admin on 15/05/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

import UIKit

protocol classReloadDataDelegate: class {
    func ReloadSectionForIndex(indexPath:IndexPath,withImportFlag:Bool,withNwtwork:String)
}

final class PhotosCollectionViewController: UIViewController{
    
    // MARK:Properties
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    //For Implementing Pagination
    var currentPageCount : Int = 0
    var totalNoOfPages : Int = 0
    var limitValue : Int = 50
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "ViewerCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    fileprivate var searches = [FlickrSearchResults]()
    fileprivate var imagesArray = [FlickrPhoto]()
    fileprivate let flickr = Flickr()
    fileprivate let itemsPerRow: CGFloat = 3
    var importFlag : Bool = false
    
    override func viewDidLoad() {
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout // casting is required because UICollectionViewLayout doesn't offer header pin. Its feature of UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        currentPageCount = 0;
        showLoadingView()
        loadingIndicator.stopAnimating()
        loadingLabel.text = "Please click on import button.."
        //callGetFlickerPhotosAPI()
    }
    
   
}
    
extension PhotosCollectionViewController{
    
    func callGetFlickerPhotosAPI(){
        
        if imagesArray.count > 0{
            self.setLoadingLabelTitleForNetwork(title: "Flicker")
        }else{
            self.setLoadingLabelTitleForNetwork(title: ".")
        }
        
        flickr.searchFlickrForTerm(limitValue, currentPageCount: currentPageCount) {
            results, error in
            
            
            if let error = error {
                // 2
                print("Error searching : \(error)")
                return
            }
            
            if let results = results {
                // 3
                print("Found \(results.searchResults.count) matching \(results.totalNoOfPages)")
                self.searches.insert(results, at: self.searches.endIndex)
                self.imagesArray = self.imagesArray + results.searchResults
                self.totalNoOfPages = results.totalNoOfPages
                self.hideLoadingView()
                
                // 4
                self.collectionView?.reloadData()
            }
        }
    }
    
    func showLoadingView(){
        self.loadingView.isHidden = false
        self.loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
       // loadingLabel.text = "Importing Photos...."
        //self.collectionView.isUserInteractionEnabled = false
    }
    
    func hideLoadingView(){
        self.loadingView.isHidden = true
        if loadingIndicator.isAnimating{
            loadingIndicator.stopAnimating()
            self.collectionView.isUserInteractionEnabled = true
        }
    }
    
    func setLoadingLabelTitleForNetwork(title : String){
        self.loadingLabel.text = "Importing photos from \(title).."
    }
    
}

// MARK: - Private
private extension PhotosCollectionViewController {
    func photoForIndexPath(indexPath: IndexPath) -> FlickrPhoto {
        return searches[(indexPath as NSIndexPath).section].searchResults[(indexPath as IndexPath).row]
    }
}

extension PhotosCollectionViewController : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            if (totalNoOfPages == -1 || currentPageCount < totalNoOfPages) {
                currentPageCount = currentPageCount + 1
                showLoadingView()
                callGetFlickerPhotosAPI()
            }
        }
    }
}


// MARK: - UICollectionViewDataSource
extension PhotosCollectionViewController : UICollectionViewDataSource{
    //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as! PhotoViewCollectionViewCell
        //2
        let flickrPhoto = imagesArray[indexPath.row]
        cell.backgroundColor = UIColor.white
        //3
        cell.imageView.image = flickrPhoto.thumbnail
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "PhotoViewerHeaderView",
                                                                             for: indexPath) as! PhotoViewerHeaderCollectionReusableView
            headerView.delegate = self
            headerView.isImportClicked = importFlag
            
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath){
        
        if indexPath.row == searches[indexPath.section].searchResults.count - 1 {
            if (totalNoOfPages == -1 || currentPageCount < totalNoOfPages) {
                currentPageCount = currentPageCount + 1
                showLoadingView()
                callGetFlickerPhotosAPI()
            }
            
            
        }
    }
}

extension PhotosCollectionViewController : UICollectionViewDelegate{
    
     func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool{
        print("shouldSelectItemAt called")
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        
        print("did select row called")

        let flickrPhoto = imagesArray[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsViewController
        detailsViewController.detailsImage = flickrPhoto.thumbnail!
        self.navigationController?.pushViewController(detailsViewController, animated: true)

    }
}

extension PhotosCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // collectionView.collectionViewLayout
        let myheader : PhotoViewerHeaderCollectionReusableView  = PhotoViewerHeaderCollectionReusableView() as UICollectionReusableView as! PhotoViewerHeaderCollectionReusableView
        myheader.isImportClicked = importFlag
        return CGSize(width: collectionView.frame.size.width, height: CGFloat(myheader.calculateHeaderHeight()))
    }
    
}

// MARK: - classReloadDataDelegate
extension PhotosCollectionViewController : classReloadDataDelegate {
    func ReloadSectionForIndex(indexPath: IndexPath,withImportFlag:Bool,withNwtwork:String) {
        importFlag = withImportFlag
         self.setLoadingLabelTitleForNetwork(title: withNwtwork)
       
    
        switch (withNwtwork) {
        case "Instagram":
           handleInstagramClick()
            
        case "Flicker":
           handleFlickerClick()
            
        case "Pintrest":
           handlePintrestClick()
            
        case "":
            handleImportClick()
            
            
        default:
            break
        }
    }
    
    func handleImportClick(){
       // self.imagesArray.removeAll()
        collectionView?.reloadData()
    }
    
    func handleInstagramClick(){
        self.imagesArray.removeAll()
        collectionView?.reloadData()
        let alert = Util.sharedInstance.shoWAlert()
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleFlickerClick(){
        self.imagesArray.removeAll()
        showLoadingView()
        callGetFlickerPhotosAPI()
        collectionView?.reloadData()
    }
    
    func handlePintrestClick(){
        self.imagesArray.removeAll()
        collectionView?.reloadData()
        let alert = Util.sharedInstance.shoWAlert()
        self.present(alert, animated: true, completion: nil)
    }
    
    
}






