//
//  ViewController.swift
//  ItunesApiPractice
//
//  Created by BoTingDing on 2018/7/7.
//  Copyright © 2018年 BoTingDing. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewController: UIViewController {
    
    //local var
    var searchResults = [ItunesData]()
    var cache = NSCache<AnyObject, AnyObject>()
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()

    @IBOutlet weak var customTableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        searchBar.placeholder = "Search Apple Music"
        customTableView.dataSource = self
        customTableView.delegate = self
        customTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        
    }
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }


}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Dimiss the keyboard
        dismissKeyboard()
        
        searchResults.removeAll()
        
        guard let text = searchBar.text else {
            return
        }
        
        Download().requestWithURL(searchText: text) { [weak self] result in
            DispatchQueue.main.async {
                self?.searchResults = result
                self?.customTableView.reloadData()
            }
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomTableViewCell.self))  as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.artistLabel.text = searchResults[indexPath.row].artistName
        cell.titleLabel.text = searchResults[indexPath.row].trackName
        cell.collectionNameLabel.text = searchResults[indexPath.row].collectionName
        if let image = cache.object(forKey: searchResults[indexPath.row].artworkUrl60 as AnyObject) {
            cell.artworkUrl60UIImage.image = image as? UIImage
        } else {
        DispatchQueue.global().async {
            let data = NSData(contentsOf: URL(string: self.searchResults[indexPath.row].artworkUrl60!)!)
            DispatchQueue.main.async {
                cell.artworkUrl60UIImage.image = UIImage(data: data! as Data)
                self.cache.setObject(UIImage(data: data! as Data)!, forKey: self.searchResults[indexPath.row].artworkUrl60 as AnyObject)
            }
        }
        }
        cell.separatorInset = .zero

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       guard let urlString = searchResults[indexPath.row].previewUrl , let url = URL(string: urlString) else {
        return
        }
            let tunePlayerViewController = AVPlayerViewController()
            tunePlayerViewController.player = AVPlayer(url: url)
            tunePlayerViewController.player?.play()
            present(tunePlayerViewController, animated: true, completion: nil)
        
    }
    
}

