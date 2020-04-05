//
//  MemeCollectionViewController.swift
//  MemeApp
//
//  Created by Artem Osipov on 05/04/2020.
//  Copyright © 2020 Artem Osipov. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let addController = storyboard?.instantiateViewController(withIdentifier: "EditMemeViewController") as! EditMemeViewController
        navigationController?.pushViewController(addController, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
    }
    

    

}
