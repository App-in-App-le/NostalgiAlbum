import UIKit
import RealmSwift

class InfoToolViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    let realm = try! Realm()
    var index : Int!
    // 현재 앨범 명, 앨범 생성 날짜 표시 가능
    var albumInfo: [[String]] = []
    // 현재 총 사진 수, 총 페이지 수 표시 가능
    var pictureInfo: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        self.view.backgroundColor = .systemGray6
        tableView.backgroundColor = .systemGray6
        // 정보 불러오기
        // Album Info .
        let albumCoverData = realm.objects(albumCover.self).filter("id = \(index!)")
        let albumsInfoData = realm.objects(albumsInfo.self).filter("id = \(index!)")
        let albumTitle = albumCoverData.first!.albumName
        let dateOfCreation = albumsInfoData.first!.dateOfCreation
        // Picture Info .
        let numberOfPicture = albumsInfoData.first!.numberOfPictures
        let numberOfPage = numberOfPicture / 2 + 1
        albumInfo.append(["앨범 명", albumTitle])
        albumInfo.append(["앨범 생성 날짜", dateOfCreation])
        pictureInfo.append(["사진", "\(String(numberOfPicture)) 장"])
        pictureInfo.append(["페이지", "\(String(numberOfPage)) 쪽"])
    }
}

extension InfoToolViewController: UITableViewDataSource{
    // 섹션의 개수를 정함
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 한 섹션에 몇개의 row를 넣을 것인지
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 2
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    // reuseable cell을 반환
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfoToolTableViewCell", for: indexPath) as? InfoToolTableViewCell else {
            return UITableViewCell()
        }
        let info:[String] = indexPath.section == 0 ? self.albumInfo[indexPath.row] : self.pictureInfo[indexPath.row]
        cell.configure(info)
        return cell
    }
    
    // table header를 정함
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return "Album Info"
        case 1:
            return "Picture Info"
        default:
            return ""
        }
    }
}
