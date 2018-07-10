//
//  CustomTableViewCell.swift
//  ItunesApiPractice
//
//  Created by BoTingDing on 2018/7/7.
//  Copyright © 2018年 BoTingDing. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var artworkUrl60UIImage: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        artworkUrl60UIImage.layer.cornerRadius = 4.0
        artworkUrl60UIImage.layer.borderWidth = 1.0
        artworkUrl60UIImage.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 0.9).cgColor
        artworkUrl60UIImage.contentMode = .scaleAspectFit
        artworkUrl60UIImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//extension UIImageView {
//    open override func draw(_ rect: CGRect) {
//        self.layer.cornerRadius = 4.0
//        self.layer.borderWidth = 1.0
//        self.layer.borderColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 0.9).cgColor
//        self.layer.masksToBounds = true
//
//    }
//
//}
