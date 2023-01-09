import UIKit
import RealmSwift

class HomeEditViewController: UIViewController {
    
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var coverImage: UIImageView!
    var collectionViewInHome : UICollectionView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
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
        
        if coverImage.image == UIImage(named: "Blue"){
            newAlbumCover.coverImageName = "Blue"
        }
        else if coverImage.image == UIImage(named: "Brown"){
            newAlbumCover.coverImageName = "Brown"
        }
        else if coverImage.image == UIImage(named: "Green"){
            newAlbumCover.coverImageName = "Green"
        }
        else if coverImage.image == UIImage(named: "Pupple"){
            newAlbumCover.coverImageName = "Pupple"
        }
        else if coverImage.image == UIImage(named: "Red"){
            newAlbumCover.coverImageName = "Red"
        }
        else if coverImage.image == UIImage(named: "Turquoise"){
            newAlbumCover.coverImageName = "Turquoise"
        }
        else{
            print("error!")
            return
        }
        
        // 해당 앨범 정보를 DB에 저장
        let newAlbumsInfo = albumsInfo()
        newAlbumsInfo.incrementIndex()
        newAlbumsInfo.setDateOfCreation()
        newAlbumsInfo.setNumberOfPictures(newAlbumsInfo.id - 1)
        
        // 앨범 커버 정보와 앨범 정보(앨범 생성 시간, 앨범의 사진 개수)를 저장
        try! realm.write
        {
            realm.add(newAlbumCover)
            realm.add(newAlbumsInfo)
        }
        
        // document 폴더 안에 각 앨범에 관한 폴더를 만들어줘야 한다.
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        
        let dirPath = documentDirectory.appendingPathComponent(albumName.text!)
        
        if !FileManager.default.fileExists(atPath: dirPath.path){
            do{
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch{
                NSLog("Couldn't create document directory") // print와 비슷한 출력 함수
            }
        }
        
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
        
        present(alert, animated: true){
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(tap)
        }
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

