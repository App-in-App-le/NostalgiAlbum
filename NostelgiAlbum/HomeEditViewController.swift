//
//  HomeEditViewController.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/12/01.
//

import UIKit
import RealmSwift

class HomeEditViewController: UIViewController {
    
    let picker = UIImagePickerController()
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    var collectionViewInHome : UICollectionView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        picker.delegate = self
        coverImage.image = UIImage(systemName: "photo")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @IBAction func saveAlbum(_ sender: Any) {
        // save album info in realm DB
        let realm = try! Realm()
        
        // make new albumCover
        let newAlbumCover = albumCover()
        newAlbumCover.incrementIndex()
        newAlbumCover.albumName = albumName.text!
        newAlbumCover.coverImageName = "\(newAlbumCover.id).png"
        
        if albumName.text == "" {
            let textAlert = UIAlertController(title: "빈 제목", message: "제목을 입력해주세요", preferredStyle: UIAlertController.Style.alert)
            present(textAlert, animated: true){
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                textAlert.view.superview?.isUserInteractionEnabled = true
                textAlert.view.superview?.addGestureRecognizer(tap)
            }
            return
        }
        
        if coverImage.image == UIImage(systemName: "photo"){
            let imageAlert = UIAlertController(title: "빈 이미지", message: "이미지를 선택해주세요", preferredStyle: UIAlertController.Style.alert)
            present(imageAlert, animated: true){
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                imageAlert.view.superview?.isUserInteractionEnabled = true
                imageAlert.view.superview?.addGestureRecognizer(tap)
            }
            return
        }
        
        // save albumCover in DB
        try! realm.write
        {
            realm.add(newAlbumCover)
        }
        
        // document에 해당 이미지를 저장
        saveImageToDocumentDirectory(imageName: newAlbumCover.coverImageName, image: coverImage.image!)
        
        // collection view에 새로운 정보가 저장됬으므로 다시 그려줘야한다.
        // Home Screen에 있는 collectionView의 data를 relaod
        collectionViewInHome.reloadData()
        
        // 띄워놨던 modal을 dismiss
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addImage(_ sender: Any) {
        //        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //        let library = UIAlertAction(title: "사진 앨범", style: .default){(action) in self.openLibrary()}
        //        let camera = UIAlertAction(title: "카매라", style: .default){(action) in self.openCamera()}
        //        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        //        alert.addAction(library)
        //        alert.addAction(camera)
        //        alert.addAction(cancel)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let Blue = UIAlertAction(title: "파란색", style: .default){
            (action) in self.setCoverImage(color: "Blue")
        }
        let Brown = UIAlertAction(title: "갈색", style: .default){
            (action) in self.setCoverImage(color: "Brown")
        }
        let Green = UIAlertAction(title: "녹색", style: .default){
            (action) in self.setCoverImage(color: "Green")
        }
        let Pupple = UIAlertAction(title: "보라색", style: .default){
            (action) in self.setCoverImage(color: "Pupple")
        }
        let Red = UIAlertAction(title: "빨간색", style: .default){
            (action) in self.setCoverImage(color: "Red")
        }
        let Turquoise = UIAlertAction(title: "청록색", style: .default){
            (action) in self.setCoverImage(color: "Turquoise")
        }
        alert.addAction(Blue)
        alert.addAction(Brown)
        alert.addAction(Green)
        alert.addAction(Pupple)
        alert.addAction(Red)
        alert.addAction(Turquoise)
        
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
    
    func setCoverImage(color: String){
        if color == "Blue"{
            coverImage.image = UIImage(named: "Blue")
        }
        else if color == "Brown"{
            coverImage.image = UIImage(named: "Brown")
        }
        else if color == "Green"{
            coverImage.image = UIImage(named: "Green")
        }
        else if color == "Pupple"{
            coverImage.image = UIImage(named: "Pupple")
        }
        else if color == "Red"{
            coverImage.image = UIImage(named: "Red")
        }
        else if color == "Turquoise"{
            coverImage.image = UIImage(named: "Turquoise")
        }
        else{
            coverImage.image = nil
            return
        }
    }
    
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
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

func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
    // 1. 이미지를 저장할 경로를 설정해줘야함 - 도큐먼트 폴더,File 관련된건 Filemanager가 관리함(싱글톤 패턴)
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
    
    // 2. 이미지 파일 이름 & 최종 경로 설정
    let imageURL = documentDirectory.appendingPathComponent(imageName)
    
    
    let changedImage = fixOrientation(image: image)
    
    // 3. 이미지 압축(image.pngData())
    // 압축할거면 jpegData로~(0~1 사이 값)
    guard let data = changedImage.pngData() else {
        print("압축이 실패했습니다.")
        return
    }
    
    // 4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기하는 경우
    // 4-1. 이미지 경로 여부 확인
    if FileManager.default.fileExists(atPath: imageURL.path) {
        // 4-2. 이미지가 존재한다면 기존 경로에 있는 이미지 삭제
        do {
            try FileManager.default.removeItem(at: imageURL)
            print("이미지 삭제 완료")
        } catch {
            print("이미지를 삭제하지 못했습니다.")
        }
    }
    
    // 5. 이미지를 도큐먼트에 저장
    // 파일을 저장하는 등의 행위는 조심스러워야하기 때문에 do try catch 문을 사용
    do {
        try data.write(to: imageURL)
        print("이미지 저장완료")
    } catch {
        print("이미지를 저장하지 못했습니다.")
    }
}


