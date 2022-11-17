//
//  InfoToolTableViewCell.swift
//  NostelgiAlbum
//
//  Created by 전민구 on 2022/11/17.
//

import UIKit

class InfoToolTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configure(_ labelInfo: [String]){
        titleLabel.text = labelInfo[0]
        contentLabel.text = labelInfo[1]
    }
}
