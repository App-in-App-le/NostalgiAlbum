import UIKit

class ContentsCells : UICollectionViewCell {
    // MARK: - Properties
    static let reuseIdentifier = "contents-cell-reuse-identifier"
    let button = PageButton()
    let title = UILabel()
    let contents = VerticalAlignLabel()
//    let contents = UILabel()
    let titleText = UILabel()
    let contentsText = UILabel()
    var index: Int!
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
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset/2.0),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: inset/2.0),
            button.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.95)
        ])
        button.layer.cornerRadius = 8
        title.layer.cornerRadius = 5
        contents.layer.cornerRadius = 7
        title.clipsToBounds = true
        contents.clipsToBounds = true
        title.textColor = .black
        contents.textColor = .black
        setThemeColor()
    }
    // Label Configure
    func labelConfigure() {
        titleText.text = "제목"
        contentsText.text = "내용"
        titleText.translatesAutoresizingMaskIntoConstraints = false
        contentsText.translatesAutoresizingMaskIntoConstraints = false
        titleText.textColor = .black
        contentsText.textColor = .black
//        titleText.backgroundColor = .white
//        contentsText.backgroundColor = .white
        titleText.layer.cornerRadius = 10
        titleText.clipsToBounds = true
        contentsText.layer.cornerRadius = 10
        contentsText.clipsToBounds = true
        title.translatesAutoresizingMaskIntoConstraints = false
        contents.translatesAutoresizingMaskIntoConstraints = false
        title.numberOfLines = 0
        contents.numberOfLines = 0
        title.textAlignment = .center
        contents.verticalAlignment = .top
//        contents.textAlignment = .left
        titleText.textAlignment = .center
        contentsText.textAlignment = .center
        button.addSubview(title)
        button.addSubview(titleText)
        button.addSubview(contents)
        button.addSubview(contentsText)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: CGFloat(5)),
            title.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -CGFloat(5)),
            title.topAnchor.constraint(equalTo: titleText.bottomAnchor, constant: CGFloat(5)),
            title.bottomAnchor.constraint(equalTo: contentsText.topAnchor, constant: -CGFloat(12)),
            title.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.15),
            
            titleText.topAnchor.constraint(equalTo: button.topAnchor, constant: CGFloat(7)),
            titleText.bottomAnchor.constraint(equalTo: title.topAnchor, constant: -CGFloat(1)),
            titleText.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.3),
            titleText.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.1),
            titleText.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            
            contents.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: CGFloat(5)),
            contents.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -CGFloat(5)),
            contents.topAnchor.constraint(equalTo: contentsText.bottomAnchor, constant: CGFloat(5)),
            contents.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -CGFloat(0)),
            contents.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.5),
            
            contentsText.topAnchor.constraint(equalTo: title.bottomAnchor, constant: CGFloat(20)),
            contentsText.bottomAnchor.constraint(equalTo: contents.topAnchor, constant: -CGFloat(1)),
            contentsText.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 0.3),
            contentsText.heightAnchor.constraint(equalTo: button.heightAnchor, multiplier: 0.1),
            contentsText.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        ])

    }
}
