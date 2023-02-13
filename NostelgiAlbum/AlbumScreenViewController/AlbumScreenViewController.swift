import UIKit
import RealmSwift

class AlbumScreenViewController: UIViewController {
    
    @IBOutlet weak var pageNumLabel: UILabel!
    let realm = try! Realm()
    var pageNum : Int = 0
    var coverIndex : Int = 0
    // tool-bar item
    
    // collectionView setting
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        pageNumLabel.text = "[ \(pageNum + 1) 페이지 ]"
        toolbarItems = makeToolbarItems()
        navigationController?.toolbar.tintColor = UIColor.label
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(popToHome))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(AlbumScreenViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(AlbumScreenViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }
    
    // Set toolBar
    private func makeToolbarItems() -> [UIBarButtonItem]{
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(AlbumScreenViewController.searchButton))
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(AlbumScreenViewController.shareButton))
        let settingButton = UIBarButtonItem(image: UIImage(systemName: "gearshape")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: nil)
        let informationButton = UIBarButtonItem(image: UIImage(systemName: "info.square")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(AlbumScreenViewController.infoButton))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        return [searchButton, flexibleSpace, shareButton, flexibleSpace, settingButton, flexibleSpace, informationButton]
    }
    
    // 한 손가락으로 swipe 할 때 실행할 메서드
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
        // 제스처가 존재하는 경우
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            let data = realm.objects(album.self).filter("index = \(coverIndex)")
            
            if (pageNum >= 0) && (pageNum < (data.count / 2) + 1){
                switch swipeGesture.direction{
                case UISwipeGestureRecognizer.Direction.right :
                    if pageNum != 0 {
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        break
                    }
                case UISwipeGestureRecognizer.Direction.left :
                    if pageNum < data.count / 2{
                        guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else{ return }
                        pushVC.pageNum = pageNum + 1
                        pushVC.coverIndex = coverIndex
                        self.navigationController?.pushViewController(pushVC, animated: true)
                    }
                    else{
                        break
                    }
                default:
                    break
                }
            }
        }
    }
    
    @objc func popToHome(){
        self.navigationController?.popToRootViewController(animated: false)
    }

    @objc func didLongPressView(_ gesture: customLongPressGesture) {
        let editPicAlert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "사진 삭제", style: .default){(action) in self.deletePicture(gesture.picture)}
        delete.setValue(UIColor.red, forKey: "titleTextColor")
        editPicAlert.addAction(delete)
        
        self.present(editPicAlert, animated: true){
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
            editPicAlert.view.superview?.isUserInteractionEnabled = true
            editPicAlert.view.superview?.addGestureRecognizer(tap)
        }
    }
    
    class customLongPressGesture : UILongPressGestureRecognizer{
        var picture : album!
    }
    private func deletePicture(_ picture : album) {
        let pictures = realm.objects(album.self).filter("index = \(picture.index)")
        let picturesInfo = realm.objects(albumsInfo.self).filter("id = \(picture.index)")
        let num = picture.perAlbumIndex
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
        let filePath = "\(picture.AlbumTitle)/\(picture.AlbumTitle)_\(picture.perAlbumIndex).png"
        let pictureDirectory = documentDirectory.appending(path: filePath)
        print("picture",pictureDirectory)
        if FileManager.default.fileExists(atPath: pictureDirectory.path) {
            do {
                try FileManager.default.removeItem(at: pictureDirectory)
            } catch {
                print("사진을 삭제하지 못했습니다.")
            }
        }
        try! realm.write{
            realm.delete(picture)
            if pictures.first != nil {
                picturesInfo.first!.setNumberOfPictures(pictures.first!.index)
            } else {
                picturesInfo.first!.numberOfPictures = 0
            }
        }
        if num <= pictures.count {
            for index in num...pictures.count {
                print("num : ",index)
                try! realm.write{
                    pictures[index-1].perAlbumIndex -= 1
                }
                
                let updatePath = "\(pictures[index-1].AlbumTitle)/\(pictures[index-1].AlbumTitle)_\(index).png"
                let originPath = "\(pictures[index-1].AlbumTitle)/\(pictures[index-1].AlbumTitle)_\(index + 1).png"
                let originDirectory = documentDirectory.appending(path: originPath)
                let updateDirectory = documentDirectory.appending(path: updatePath)
                print("originDir:",originDirectory)
                print("updateDir:",updateDirectory)
                do {
                    try FileManager.default.moveItem(atPath: originDirectory.path(), toPath: updateDirectory.path())
                } catch {
                    print("경로가 없습니다.")
                }
            }
        }
        
        collectionView.reloadData()
    }
    @objc private func didTappedOutside(_ sender: UITapGestureRecognizer){
        self.dismiss(animated: true, completion: nil)
    }
}

// DataSource, Delegate에 대한 extension을 정의
extension AlbumScreenViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = realm.objects(album.self).filter("index = \(coverIndex)")
        let coverData = realm.objects(albumCover.self).filter("id = \(coverIndex)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumScreenCollectionViewCell", for: indexPath) as! AlbumScreenCollectionViewCell
        var picture: album
        var pictureCover: albumCover
        pictureCover = coverData.first!
        cell.albumSVC = self
        cell.albumCoverInfo = pictureCover
        if (indexPath.item + pageNum * 2) < data.count {
            picture = data[indexPath.item + pageNum * 2]
            cell.configure(picture)
            cell.albumInfo = picture
            let LongPressGestureRecognizer = customLongPressGesture(target: self, action: #selector(didLongPressView(_:)))
            LongPressGestureRecognizer.picture = picture
            cell.pictureImgButton.addGestureRecognizer(LongPressGestureRecognizer)
        } else {
            cell.albuminit()
            if (indexPath.item + pageNum * 2) > data.count {
                cell.pictureImgButton.isHidden = true
            }
        }
        return cell
    }
}

// layout에 관한 extension을 정의
extension AlbumScreenViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 2)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
