//
//  ViewController.swift
//  scan reader
//
//  Created by Henry G. Glenn on 10/14/21.
//

import UIKit
import Vision

@available(iOS 13.0, *)
class ViewController: UIViewController,
                      UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate
{
    
    // Initalize variables
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var scanButton: UIButton!

    @IBOutlet weak var selectionLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is ScanViewController {
            let scanView = segue.destination as? ScanViewController
            scanView?.textForOutputBox = getTextFrom(image: imageView.image)
        }
    }
    
    @IBAction func openCameraButton(sender: AnyObject)
    {
        // If possible access the iPhone's camera and allow the user to take a photo
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    /**
     * The purpose of this method it to execute the entailing commands when "Photo Button" is pressed
     */
    @IBAction func openPhotoLibraryButton(sender: AnyObject)
    {
        // If possible access the iPhone's photo library and allow the user to select a photo
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        // If the item selected by the user is an image then...
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageView.image = image
            imageFound(state: true)
        }
        // if the item selected by the user is not an image then...
        else
        {
            // Errors will be thrown here
            imageFound(state: false)
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imageFound(state: Bool)
    {
        if state == true
        {
            selectionLabel.isHidden = true
            scanButton.isEnabled = true
            scanButton.alpha = 1
        }
        else if state == false
        {
            selectionLabel.isHidden = false
            scanButton.isEnabled = false
            scanButton.alpha = 0.5
        }
    }
    
    func getTextFrom(image: UIImage?) -> String
    {
        var finalText = ""
        guard let cgImage = image?.cgImage else { return ""}
        
        // Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else { return }
            
            var text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: " ")
            //self.recognizedText = text
            text = text.replacingOccurrences(of: "--", with: "-")
            text = text.replacingOccurrences(of: "- ", with: "-")
            text = text.replacingOccurrences(of: " -", with: "-")
            finalText = text.replacingOccurrences(of: "-", with: "- ")
        }
        
        // Process request
        do
        {
            try handler.perform([request])
        }
        catch
        {
            print(error)
        }
        return finalText
    }
}

