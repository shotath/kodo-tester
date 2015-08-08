//
//  SearchImageViewController.swift
//  kodo-tester
//
//  Created by shota_th on 2015/08/02.
//  Copyright (c) 2015年 s.kurihara. All rights reserved.
//

import UIKit

private let apiKey = "AIzaSyCjnGfQwbUj-Pj_u4mL_84XsAzXf_lMZ7o"
private let engineId = "006497348249681104348:zd_5usc7i70"

class SearchImageViewController: UIViewController, UISearchBarDelegate, UIScrollViewDelegate {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private var foundImages = [UIImage]()
    private var displayedImagesCount: Int = 0
    private var isFetchingSources: Bool = false
    private var isImageDownloading: Bool = false
    private var lastFetchedIndex: Int = 0
    private var selectedImage: UIImage? = nil
    
    // MARK: - Life cycles
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ImageSelectionViewController {
            vc.selectedImage = selectedImage
        }
    }
    
    // MARK: - Button action
    
    func imageDidTouchUpInside(sender: UIView) {
        selectedImage = foundImages[sender.tag]
        navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Search bar delegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
        delay(1.0, { [weak self] () -> () in
            if let strongSelf = self {
                strongSelf.resetSearchResult()
                let urls = strongSelf.fetchImageSources(searchBar.text)
                let images = strongSelf.downloadImagesWithUrls(urls)
                strongSelf.foundImages += images
                strongSelf.showImages(images)
            }
        })
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.bounds.height {
            scrollViewDidScrollToBottom(scrollView)
        }
    }
    
    private func scrollViewDidScrollToBottom(scrollView: UIScrollView) {
        if isFetchingSources || isImageDownloading || searchBar.text == "" { return }
        let urls = fetchImageSources(searchBar.text)
        let images = downloadImagesWithUrls(urls)
        foundImages += images
        showImages(images)
    }
    
    // MARK: - Private methods
    
    /**
    入力単語で画像を検索し、その結果のURLのリストを返す
    Google Custom Search Engine を使用
    検索結果は10個
    
    :param: query 検索単語
    :returns: urlのリスト
    */
    private func fetchImageSources(query: String) -> [String] {
        isFetchingSources = true
        let fromIndex = lastFetchedIndex + 1
        lastFetchedIndex += 10
        var result = [String]()

        if let encodedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            let json = JSON(url: "https://www.googleapis.com/customsearch/v1?key=\(apiKey)&cx=\(engineId)&q=\(encodedQuery)&start=\(fromIndex)")
            for (i, item) in json["items"] {
                if let src = item["pagemap"]["cse_image"][0]["src"].asString {
                    result.append(src)
                }
            }
        }
        
        isFetchingSources = false
        return result
    }
    
    private func downloadImagesWithUrls(urls: [String]) -> [UIImage] {
        isImageDownloading = true
        var images = [UIImage]()
        
        for urlString in urls {
            let url = NSURL(string: urlString)
            var err: NSError?
            var imageData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
            if let imageData = imageData,
               let image = UIImage(data: imageData) {
                images.append(image)
            }
        }
        
        isImageDownloading = false
        return images
    }
    
    private func showImages(images: [UIImage]) {
        let sideMargin: CGFloat = 16
        let imageMargin: CGFloat = 8
        let imageWidth = (UIScreen.mainScreen().bounds.width - (sideMargin * 2 + imageMargin)) / 2
        for (i, image) in enumerate(images) {
            let index = displayedImagesCount + i
            let imageView = UIImageView(image: image)
            let isLeft = Double(index) % 2 == 0
            let rowIndex = Int(Double(index) / 2)
            let x: CGFloat = isLeft ? 16 : sideMargin + imageWidth + imageMargin
            let y: CGFloat = CGFloat(rowIndex) * (imageWidth + imageMargin)
            
            imageView.frame = CGRectMake(x, y, imageWidth, imageWidth)
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            
            let button = UIButton()
            button.frame = imageView.frame
            button.addTarget(self, action: "imageDidTouchUpInside:", forControlEvents: .TouchUpInside)
            button.tag = index

            scrollView.addSubview(imageView)
            scrollView.addSubview(button)
            scrollView.contentSize.height = imageWidth + y + sideMargin
        }
        displayedImagesCount += count(images)
    }
    
    private func resetSearchResult() {
        displayedImagesCount = 0
        lastFetchedIndex = 0
        for subView in scrollView.subviews {
            if let subView = subView as? UIView {
                subView.removeFromSuperview()
            }
        }
        scrollView.contentSize = scrollView.bounds.size
        scrollView.contentOffset = CGPointMake(0, 0)
    }
}
