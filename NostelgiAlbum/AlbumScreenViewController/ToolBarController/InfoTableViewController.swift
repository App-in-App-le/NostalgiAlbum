import UIKit
import RealmSwift

class InfoTableViewController: UIViewController {
    // MARK: - Properties
    var tableView: UITableView! = nil
    var tableCons: [NSLayoutConstraint]! = nil
    var index : Int!
    
    
    // MARK: - Model
    let realm = try! Realm()
    // Section Header
    var section1_cellTitle: [String] = ["이름", "생성 날짜"]
    var section2_cellTitle: [String] = ["사진", "페이지"]
    // Cell Description
    var section1_cellDescription: [String]! = nil
    var section2_cellDescription: [String]! = nil
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        loadData()
        setTableView()
        setTableViewHeader()
        setThemeColor()
    }
    

    // MARK: - Methods
    func loadData() {
        // 정보 불러오기
        let albumCoverData = realm.objects(albumCover.self).filter("id = \(index!)")
        let albumsInfoData = realm.objects(albumsInfo.self).filter("id = \(index!)")
        // Album Info
        let albumTitle = albumCoverData.first!.albumName
        let dateOfCreation = albumsInfoData.first!.dateOfCreation
        // Picture Info
        let numberOfPicture = albumsInfoData.first!.numberOfPictures
        let numberOfPage = numberOfPicture / 2 + 1
        
        section1_cellDescription = [albumTitle, dateOfCreation]
        section2_cellDescription = ["\(numberOfPicture)장", "\(numberOfPage)쪽"]
    }
    
    func setTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableCons = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(tableCons)
        
        tableView.dataSource = self
    }
    
    func setTableViewHeader() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: header.frame.height))
        label.text = "앨범 정보"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: header.bounds.height * 2, height: header.bounds.height))
        button.setTitle(" 앨범", for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial", size: 15)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        header.addSubview(label)
        header.addSubview(button)
        tableView.tableHeaderView = header
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension InfoTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section
        {
        case 0:
            return 2
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = InfoTableCell()
        cell.backgroundColor = .white
        
        switch indexPath.section {
        case 0:
            cell.setSubviews(title: section1_cellTitle[indexPath.item], description: section1_cellDescription[indexPath.item])
        case 1:
            cell.setSubviews(title: section2_cellTitle[indexPath.item], description: section2_cellDescription[indexPath.item])
        default:
            print("Error Occur")
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section
        {
        case 0:
            return "앨범 정보"
        case 1:
            return "사진 정보"
        default:
            return nil
        }
    }
    
}
