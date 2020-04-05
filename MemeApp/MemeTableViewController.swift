//
//  MemeTableViewController.swift
//  MemeApp
//
//  Created by Artem Osipov on 05/04/2020.
//  Copyright © 2020 Artem Osipov. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell")!
        let meme = memes[indexPath.row]
        
        cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)

    }
    
    @IBAction func addMemeTapped(_ sender: Any) {
        let detailController = storyboard?.instantiateViewController(withIdentifier: "EditMemeViewController") as! EditMemeViewController
        navigationController?.pushViewController(detailController, animated: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
    }
}
