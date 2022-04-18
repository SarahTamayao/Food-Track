//
//  AddTruckViewController.swift
//  Food Track
//
//  Created by Hernan Hernandez on 4/17/22.
//

import UIKit
import AlamofireImage
import Parse

class AddTruckViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var truckImgView: UIImageView!
    @IBOutlet weak var truckNameField: UITextField!
    @IBOutlet weak var foodTypeField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func truckSubmitButton(_ sender: Any) {
        let truck = PFObject(className: "Trucks")
        
        truck["Name"] = truckNameField.text!
        truck["Type"] = foodTypeField.text!
        truck["Description"] = descriptionField.text!
        truck["owner"] = PFUser.current()!
        
        let imageData = truckImgView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        truck["image"] = file
        
        truck.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("error!")
            }
        }
    }
    
    
    @IBAction func onTruckImgButton(_ sender: Any) {
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
        let scaledImage = image.af_imageAspectScaled(toFit: size)
        
        //profileImgView.image = scaledImage
        truckImgView.image = scaledImage
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
