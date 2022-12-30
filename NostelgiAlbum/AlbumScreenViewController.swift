//
//  AlbumScreenViewController.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/10/31.
//

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
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: nil)
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
    @objc func infoButton(){
        guard let infoVC = self.storyboard?.instantiateViewController(identifier: "InfoToolViewController") as? InfoToolViewController else { return }
        infoVC.modalTransitionStyle = .crossDissolve
        infoVC.modalPresentationStyle = .overCurrentContext
        self.present(infoVC, animated: true, completion: nil)
    }
    @objc func searchButton(){
        guard let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchToolViewController") as? SearchToolViewController else {return}
        searchVC.modalPresentationStyle = .overCurrentContext
        searchVC.delegate = self
        self.present(searchVC, animated: false)
    }
    @objc func popToHome(){
        self.navigationController?.popToRootViewController(animated: false)
    }
}

// DataSource, Delegate에 대한 extension을 정의
extension AlbumScreenViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = realm.objects(album.self).filter("index = \(coverIndex)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumScreenCollectionViewCell", for: indexPath) as! AlbumScreenCollectionViewCell
        
        var picture: album
        cell.albumSVC = self
        if (indexPath.item + pageNum * 2) < data.count {
            picture = data[indexPath.item + pageNum * 2]
            cell.configure(picture)
            cell.albumInfo = picture
        } else {
            cell.albuminit()
        }
        return cell
    }
}

// layout에 관한 extension을 정의
extension AlbumScreenViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 357)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension AlbumScreenViewController: DisDelegate{
    func delegateString(text: String) {
        let data = realm.objects(album.self).filter("index = \(coverIndex)")
        var num : Int = 0
        var checkcount : Int = pageNum
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        
        if let result = data.firstIndex(where: {$0.ImageName == text}){
            guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else{ return }
            if(result/2 == checkcount){
                print("currentPage")
            }
            else if(result/2 > checkcount){
                while checkcount < result/2 {
                    checkcount = checkcount + 1
                    pushVC.pageNum = checkcount
                    self.navigationController?.pushViewController(pushVC, animated: false)
                }
            }
            else {
                while checkcount >= result/2 {
                    checkcount = checkcount - 1
                    //pushVC.pageNum = pageNum
                    //self.navigationController?.popViewController(animated: false)
                    num = num + 1
                }
                
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - num], animated: false)
            }
        }
        else {
            print("none")
        }
    }
}
