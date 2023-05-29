import UIKit
import Mantis
import AVFoundation
import Photos

extension AlbumEditViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            dismiss(animated: true) {
                self.openCropVC(image: image)
            }
        }
    }
    
    /**
     카메라 접근 권한 판별하는 함수
     */
    func cameraAuth() -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var hasPermission = false
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("권한 허용")
                hasPermission = true
            } else {
                print("권한 거부")
                hasPermission = false
            }
            
            semaphore.signal()
        }
        
        semaphore.wait()
        return hasPermission
    }
    
    /**
     앨범 접근 권한 판별하는 함수
     */
    func albumAuth() {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .notDetermined:
            print("not determined")
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized, .limited:
                    DispatchQueue.main.async {
                        self.openPhotoLibrary()
                    }
                case .denied:
                    DispatchQueue.main.async {
                        self.showAlertAuth("앨범")
                    }
                default:
                    print("error.")
                }
            }
        case .restricted:
            print("restricted")
        case .denied:
            DispatchQueue.main.async {
                self.showAlertAuth("앨범")
            }
        case .limited, .authorized:
            DispatchQueue.main.async {
                self.openPhotoLibrary()
            }
        default:
            print("error")
        }
    }
    
    /**
     권한을 거부했을 때 띄어주는 Alert 함수
     - Parameters:
     - type: 권한 종류
     */
    func showAlertAuth(_ type: String) {
        if let appName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String {
            let alertVC = UIAlertController(
                title: "설정",
                message: "\(appName)이(가) \(type) 접근 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?",
                preferredStyle: .alert
            )
            let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in
                self.dismiss(animated: true)
            }
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(confirmAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    /**
     아이폰에서 앨범에 접근하는 함수
     */
    func openPhotoLibrary() {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            self.picker.sourceType = .photoLibrary
            self.picker.modalPresentationStyle = .currentContext
            self.present(self.picker, animated: true, completion: nil)
        } else {
            print("앨범에 접근할 수 없습니다.")
        }
    }
    
    /**
     아이폰에서 카메라에 접근하는 함수
     */
    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            self.picker.sourceType = .camera
            self.picker.modalPresentationStyle = .currentContext
            self.present(self.picker, animated: true, completion: nil)
        } else {
            print("카메라에 접근할 수 없습니다.")
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
                    
                    dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
                    dismissButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
                    
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
