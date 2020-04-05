//
//  ViewController.swift
//  MemeApp
//
//  Created by Artem Osipov on 02/04/2020.
//  Copyright © 2020 Artem Osipov. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let topLineLabel = "TOP LINE"
    let bottomLineLabel = "BOTTOM LINE"
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -2.0,
    ]
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        prepareTextView(textField: topText, defaultText: topLineLabel)
        prepareTextView(textField: bottomText, defaultText: bottomLineLabel)
        
        clear()
    }
    
    func prepareTextView(textField: UITextField, defaultText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self
        textField.text = defaultText
    }

    @IBAction func pickImageTapped(_ sender: Any) {
        pickImage(with: .photoLibrary)
    }
    
    @IBAction func takeImageTapped(_ sender: Any) {
        pickImage(with: .camera)
    }
    
    
    func pickImage(with sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picture.image = image
            shareButton.isEnabled = true
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func generateMemedImage() -> UIImage {
        toolbar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        toolbar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        return memedImage
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        let image = generateMemedImage()
        let shareActivity = UIActivityViewController.init(activityItems: [image], applicationActivities: nil)
        shareActivity.completionWithItemsHandler = { activity, success, items, error in
            if (success) {
                
                let meme = Meme(topText: self.topText.text!, bottomText: self.bottomText.text!, originalImage: self.picture.image!, memedImage: image)
                let object = UIApplication.shared.delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(meme)
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        present(shareActivity, animated: true, completion: nil)
    }
    
    func clear() {
        topText.text = topLineLabel
        bottomText.text = bottomLineLabel
        picture.image = nil
        shareButton.isEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.tag == 0 && textField.text == topLineLabel) {
            textField.text = ""
        }
        
        if (textField.tag == 1 && textField.text == bottomLineLabel) {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = "\(textField.text! as NSString)\(string.uppercased())"
        return false
    }

    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomText.isFirstResponder) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if (bottomText.isFirstResponder) {
            view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
}

