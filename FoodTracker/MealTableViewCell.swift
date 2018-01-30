//
//  MealTableViewCell.swift
//  FoodTracker
//
//  Created by Yuhei Kikuchi on 2018/01/13.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        LogUtil.traceFunc()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        LogUtil.traceFunc(params: ["selected":selected,
                                   "animated":animated])

        // Configure the view for the selected state
    }

}
