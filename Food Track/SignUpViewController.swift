//
//  SignUpViewController.swift
//  Food Track
//
//  Created by Hernan Hernandez on 3/29/22.
//

import UIKit
import AlamofireImage
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameSignUpField: UITextField!
    @IBOutlet weak var passwordSignUpField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func OnSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = nameSignUpField.text
        user.password = passwordSignUpField.text

        // other fields can be set just like with PFObject
        // user["profileImg"] = profileImgView
        let imageData = profileImgView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        user["image"] = file
        
        user.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("error!")
            }
        }
        
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "SignUpSegue", sender: nil)
            } else {
                print ("error: \(error?.localizedDescription)")
            }
        }
            
    }
    
    
    @IBAction func onProfileImgButton(_ sender: Any) {
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
        profileImgView.image = scaledImage.circleMask
        
        dismiss(animated: true, completion: nil)
    }
}
extension UIImage {
    var circleMask: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: .init(origin: .init(x: 0, y: 0), size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
}
*/
