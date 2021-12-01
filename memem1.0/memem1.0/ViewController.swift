//
//  ViewController.swift
//  memem1.0
//
//  Created by Manish raj(MR) on 02/12/21.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate, UITextFieldDelegate{


    @IBOutlet weak var ImagePickerView: UIBarButtonItem!
    
    @IBOutlet weak var pickAnImageFromCamera: UIBarButtonItem!
    
    
    @IBOutlet weak var TopText: UITextField!
    
    
    @IBOutlet weak var BottomText: UITextField!
    
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    @IBOutlet weak var toolBar: UIBarButtonItem!
    
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var cancleButton: UIBarButtonItem!
    
    var memeImage: UIImage?
    
    var editMode:Bool = false
        
    var originalViewHight:CGFloat = 0
    
    var imagePicker = UIImagePickerController()
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3
        
    ]
    
    struct Meme {

        let topText: String
        let bottomText: String
        let originalImage: UIImage
        let memedImage: UIImage
    }
    
    func save() {
            // Create the meme
        _ = Meme(topText: TopText.text!, bottomText: BottomText.text!, originalImage: ImagePickerView.image!, memedImage: generateMemedImage())
        
    }
    
    
    func generateMemedImage() -> UIImage {
        
        toolbar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolbar.isHidden = false

        return memedImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            ImagePickerView.image = image
            picker.dismiss(animated: true, completion: nil)
            
        
        }
        
        dismiss(animated: true, completion: nil)
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        func subscribeToKeyboardNotifications() {

               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
               
               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        }

        super.viewWillAppear(animated)
        
        
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        func unsubscribeFromKeyboardNotifications() {

               NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
               
               NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }

        super.viewWillDisappear(animated)
        
    }
    
       
    @objc func keyboardWillShow(_ notification:Notification) {
           
               if TopText.isFirstResponder == false {
           
                view.frame.origin.y = -getKeyboardHeight(notification)
       
               }
           
    }
       
    @objc func keyboardWillHide(_ notification:NSNotification) {
           
           if BottomText.isFirstResponder{
               
               view.frame.origin.y = 0
               
           }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

           let userInfo = notification.userInfo
           let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
           return keyboardSize.cgRectValue.height
    }
       
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           
           return textField.resignFirstResponder()
       
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        func setupTextField(Textfield textField: UITextField, defaultText: String) {
              
              textField.textAlignment = .center
          
              textField.autocapitalizationType = .allCharacters
              
              textField.text = defaultText
              
              textField.defaultTextAttributes = memeTextAttributes
              
              textField.delegate = self
              
          }
        setupTextField(Textfield: TopText, defaultText: "TOP")
        setupTextField(Textfield: BottomText, defaultText: "BOTTOM")
      
        pickAnImageFromCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Do any additional setup after loading the view.
    }
    
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        imagePicker.delegate = self
        _ = UIImagePickerController()
        let pickerController = UIImagePickerController()
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func Albums(_ sender: Any) {
        presentPickerViewController(source: .photoLibrary)
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentPickerViewController(source: .camera)
    }
    
    @IBAction func shareButton(_ sender: Any) {
        
        let memed = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memed], applicationActivities: nil)
        self.present(controller, animated: true, completion:nil )
        controller.completionWithItemsHandler = { (activity, success, items, error) in
            if(success) {
                self.save()
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        shareButton.isEnabled = false
        ImagePickerView.image = nil
        TopText.text = "TOP"
        BottomText.text = "BOTTOM"
    }
    
}
