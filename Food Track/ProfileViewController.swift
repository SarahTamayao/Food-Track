//
//  ProfileViewController.swift
//  Food Track
//
//  Created by Rodrigo Andrade on 4/18/22.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let curr = PFUser.current()
        
        nameField.text = curr!.username
        
        let imageFile = curr!["image"]! as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        profileImg.af.setImage(withURL: url)
        
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 500, height: 500)
        let scaledImage = image.af.imageAspectScaled(toFit: size)
        
        //profileImgView.image = scaledImage
        profileImg.image = scaledImage.circleMask
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func updateData(_ sender: Any) {
        let user = PFUser.current()
        
        let imageData = profileImg.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        user?.setValue(nameField.text!, forKey: "username")
        user?.setObject(file!, forKey: "image")
        
        user?.saveInBackground{ (success, error) in
           if success {
               self.dismiss(animated: true, completion: nil)
               print("saved!")
           } else {
               print("error!")
           }
       }
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate else { return }
        
        delegate.window?.rootViewController = loginViewController
    }
}
