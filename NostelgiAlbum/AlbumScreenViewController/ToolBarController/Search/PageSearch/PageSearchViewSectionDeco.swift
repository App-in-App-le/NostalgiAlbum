import UIKit

class PageSearchSectionDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageSearchSectionDecorationView {
    func configure() {
        backgroundColor = UIColor.white
    }
}
