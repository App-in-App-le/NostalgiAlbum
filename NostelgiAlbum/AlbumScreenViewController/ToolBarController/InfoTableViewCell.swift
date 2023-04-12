import UIKit

class InfoTableCell: UITableViewCell {
    // MARK: - Properties
    var cellTitle: UILabel! = nil
    var cellDescription: UILabel! = nil
    
    // MARK: - Methods
    func setSubviews(title: String, description: String) {
        cellTitle = UILabel()
        cellTitle.text = title
        contentView.addSubview(cellTitle)
        
        cellDescription = UILabel()
        cellDescription.text = description
        cellDescription.textColor = .systemGray
        cellDescription.textAlignment = .right
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
