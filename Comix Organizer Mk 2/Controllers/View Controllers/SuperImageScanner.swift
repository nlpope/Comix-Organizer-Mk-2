//
//  SuperImageScanner.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 5/19/24.
//

import UIKit
import CoreML
import Vision

class SuperImageScanner: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var pickedImage: UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            guard let convertedCIImage = CIImage(image: userPickedImage) else {
                fatalError("Cannot convert to CIImage")
            }
            
            detect(image: convertedCIImage)
            
            imageView.image = userPickedImage
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        if #available(iOS 17.0, *) {
            guard let model = try? VNCoreMLModel(for: SuperImageClassifier().model) else {
                fatalError("Cannot import model")
            }
            
            let request = VNCoreMLRequest(model: model) { (request, error) in
                //stopped here - finish later
            }

        } else {
            // Fallback on earlier versions
        }
        
    }
}
