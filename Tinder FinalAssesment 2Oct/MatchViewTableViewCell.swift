//
//  MatchViewTableViewCell.swift
//  
//
//  Created by RaymondOoi on 03/10/2017.
//

import UIKit

class MatchViewTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dislikeBtnTaapped: UIButton!
    
    @IBOutlet weak var likeBtnTapped: UIButton!
    
    @IBOutlet weak var UserImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var agelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
