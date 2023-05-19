import UIKit
import Mantis

extension AlbumEditViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                self.openCropVC(image: image)
            }
        }
    }
}

extension AlbumEditViewController: CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
        if cropInfo.cropSize.width > cropInfo.cropSize.height {
            if isHeightLonger == true {
                width = UIScreen.main.bounds.width - 40
                let remainder = Int(width!) % 4
                if remainder != 0 {
                    width = width! - CGFloat(remainder)
                }
                height = width! / 4 * 3
                NSLayoutConstraint.deactivate(consArray!)
                newConsArray = [
                    saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
                    saveButton.heightAnchor.constraint(equalToConstant: 30),
                    saveButton.widthAnchor.constraint(equalToConstant: 50),
                    
                    dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
                    
                    editPicture.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 50),
                    editPicture.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    editPicture.widthAnchor.constraint(equalToConstant: width),
                    editPicture.heightAnchor.constraint(equalToConstant: height),
                    
                    editName.topAnchor.constraint(equalTo: editPicture.bottomAnchor, constant: 10),
                    editName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    editName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    editName.heightAnchor.constraint(equalToConstant: 35),
                    
                    editText.topAnchor.constraint(equalTo: editName.bottomAnchor, constant: 10),
                    editText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    editText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    editText.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60)
                ]
                NSLayoutConstraint.activate(newConsArray)
                isHeightLonger = false
            }
        } else {
            if isHeightLonger == false {
                width = UIScreen.main.bounds.width - 30
                let remainder = Int(width) % 3
                if remainder != 0 {
                    width = width! - CGFloat(remainder)
                }
                height = width! / 3 * 4
                NSLayoutConstraint.deactivate(newConsArray)
                NSLayoutConstraint.activate(consArray)
                isHeightLonger = true
            }
        }
        
        self.editPicture.setImage(cropped.resize(newWidth: width, newHeight: height, byScale: false), for: .normal)
        self.editPicture.setTitle("", for: .normal)
        cropViewController.dismiss(animated: true)
    }
    
    func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    private func openCropVC(image: UIImage) {
        var config = Mantis.Config()
        config.ratioOptions = [.custom]
        config.addCustomRatio(byVerticalWidth: 3, andVerticalHeight: 4)
        config.addCustomRatio(byVerticalWidth: 4, andVerticalHeight: 3)
        config.presetFixedRatioType = .canUseMultiplePresetFixedRatio(defaultRatio: 3 / 4)
        let cropViewController = Mantis.cropViewController(image: image, config: config)
        cropViewController.delegate = self
        cropViewController.modalPresentationStyle = .fullScreen
        self.present(cropViewController, animated: true)
    }
}
