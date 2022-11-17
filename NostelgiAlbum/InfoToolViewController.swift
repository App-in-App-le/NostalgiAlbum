//
//  InfoToolViewController.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/11/13.
//

import UIKit

class InfoToolViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let albumInfo: [[String]] = [["앨범 명", "first_album"], ["앨범 생성 날짜", "2022-10-10"], ["앨범 만든 사람", "Mr.Chop"],[ "앨범 단계", "Baby"]]
    let pictureInfo: [[String]] = [["총 사진 수", "10"], ["저장 가능한 사진 수", "10/50"], ["총 페이지 수", "5"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        self.view.backgroundColor = .systemGray6
        tableView.backgroundColor = .systemGray6
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension InfoToolViewController: UITableViewDataSource{
    // 한 섹션에 몇개의 row를 넣을 것인지
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 4
        case 1:
            return 3
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
    // 섹션의 개수를 정함
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
