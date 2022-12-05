//
//  HomeEditViewController.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/12/01.
//

import UIKit

class HomeEditViewController: UIViewController {
    
    let picker = UIImagePickerController()
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        picker.delegate = self
    }
    
    @IBAction func saveAlbum(_ sender: Any) {
        // save album info in realm DB
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addImage(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진 앨범", style: .default){(action) in self.openLibrary()}
        let camera = UIAlertAction(title: "카매라", style: .default){(action) in self.openCamera()}
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera(){
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
}

extension HomeEditViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                    coverImage.image = image
                }
        dismiss(animated: true, completion: nil)
    }
}
