import UIKit
import RealmSwift

class FontSettingTableViewCell: UITableViewCell {
    // MARK: - Properties
    let realm = try! Realm()
    var cellTitle: UILabel! = nil
    var cellDescription: UILabel! = nil
    
    // MARK: - Methods
    func setSubviews(title: String, titleFont: String, descriptionFont: String) {
        cellTitle = UILabel()
        cellTitle.text = title
        cellTitle.font = UIFont(name: titleFont, size: 15)
        contentView.addSubview(cellTitle)
        
        cellDescription = UILabel()
        cellDescription.text = "안녕하세요 반가워요 :)"
        cellDescription.textColor = .systemGray
        cellDescription.textAlignment = .right
        cellDescription.font = UIFont(name: descriptionFont, size: 15)
        contentView.addSubview(cellDescription)
        
        cellTitle.translatesAutoresizingMaskIntoConstraints = false
        cellDescription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cellTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cellTitle.widthAnchor.constraint(equalToConstant: contentView.bounds.width / 3),
            
            cellDescription.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellDescription.leadingAnchor.constraint(equalTo: cellTitle.trailingAnchor),
            cellDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
        ])
    }
}
