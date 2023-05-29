import UIKit
import RealmSwift

class InfoTableCell: UITableViewCell {
    // MARK: - Properties
    let realm = try! Realm()
    var cellTitle: UILabel! = nil
    var cellDescription: UILabel! = nil
    
    // MARK: - Methods
    func setSubviews(title: String, description: String, font: String) {
        cellTitle = UILabel()
        cellTitle.text = title
        cellTitle.font = UIFont(name: font, size: 15)
        contentView.addSubview(cellTitle)
        
        cellDescription = UILabel()
        cellDescription.text = description
        cellDescription.textColor = .systemGray
        cellDescription.textAlignment = .right
        cellDescription.font = UIFont(name: font, size: 15)
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
