//
//  CompletedTableViewCell.swift
//  chocolate-factory-threads
//
//  Created by Dinod Tharinda on 2026-04-30.
//

import UIKit

class CompletedTableViewCell: UITableViewCell, AppTableViewCell {

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelPersonName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initialize(_ model: String?) {
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
