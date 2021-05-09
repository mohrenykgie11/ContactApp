//
//  ContactCell.swift
//  Contacts
//
//  Created by Morenikeji on 5/8/21.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phoneNo: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
