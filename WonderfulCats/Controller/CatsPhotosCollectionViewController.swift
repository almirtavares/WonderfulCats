//
//  CatsPhotosCollectionViewController.swift
//  WonderfulCats
//
//  Created by Almir Tavares on 11/06/20.
//  Copyright © 2020 DevVenture. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CatCell"

class CatsPhotosCollectionViewController: UICollectionViewController {

    var catLinks: [String] = []
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        let screenWidth = UIScreen.main.bounds.size.width-24
        if let collec = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collec.estimatedItemSize = CGSize(width: Int(screenWidth/3), height: Int(screenWidth/3) )
        }
        
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: Int(screenWidth*0.9), height: Int(screenWidth*0.9))
        self.activityIndicator.color = .white
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(self.activityIndicator)
        
        // Auto layout
        let horizontalConstraint = self.activityIndicator
            .centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let verticalConstraint = self.activityIndicator
            .centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])
        
        
        self.activityIndicator.startAnimating()
        loadCats()
    }
    
    private func loadCats() {
        
        CatAPI.loadCats { [weak self] (result) in
            guard let self = self else { return }
            switch result {
                case .success(let catLinks):
                    self.catLinks = catLinks
                    DispatchQueue.main.sync {
                        self.collectionView.reloadData()
                    }
                    print(catLinks.count)
                case .failure(let apiError):
                    print("ERROR:", apiError)
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return catLinks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let url = NSURL(string: self.catLinks[indexPath.row])
            if let imageData:NSData = NSData(contentsOf: url! as URL) {

                DispatchQueue.main.async {
                    
                    let imageView = UIImageView(
                        frame: CGRect(x:0, y:0, width:cell.frame.size.width, height:cell.frame.size.height)
                    )
                    
                    let image = UIImage(data: imageData as Data)
                    imageView.image = image
                    
                    cell.addSubview(imageView)
                    self.activityIndicator.stopAnimating()
                }
                
            }
        }
        
        return cell
    }

}
