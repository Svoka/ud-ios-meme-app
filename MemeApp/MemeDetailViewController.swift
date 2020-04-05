//
//  MemeDetailViewController.swift
//  MemeApp
//
//  Created by Artem Osipov on 05/04/2020.
//  Copyright © 2020 Artem Osipov. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = meme.memedImage
    }

}
