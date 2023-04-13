import UIKit

class ContentsCells : UICollectionViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "contents-cell-reuse-identifier"
    let button = PageButton()
    let title = UILabel()
    let contents = UILabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContentsCells {
    // MARK: - Methods
    // Button Configure
    func configure() {
        labelConfigure()
        button.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(button)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray2.cgColor
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset/2.0)
        ])

    }
    // Label Configure
    func labelConfigure() {
        title.translatesAutoresizingMaskIntoConstraints = false
        contents.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        contents.numberOfLines = 0
        button.addSubview(title)
        button.addSubview(contents)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            title.topAnchor.constraint(equalTo: button.topAnchor, constant: CGFloat(5)),
            
            contents.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            contents.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            contents.topAnchor.constraint(equalTo: title.bottomAnchor, constant: CGFloat(9)),
            contents.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: CGFloat(1))
        ])
    }
}
