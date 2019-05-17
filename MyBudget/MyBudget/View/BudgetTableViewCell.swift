//
//  BudgetTableViewCell.swift
//  MyBudget
//
//  Created by Zeyuan Cai on 2019/04/12
//  Copyright © 2019 Zeyuan Cai. All rights reserved.
//

import UIKit

class BudgetTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var BGView: UIView!
    @IBOutlet weak var expenseLaebl: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var remakLabel: UILabel!
    @IBOutlet weak var typeIMG: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
