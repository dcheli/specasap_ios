//
//  ProductCell.swift
//  SpecAsap
//
//  Created by David Cheli on 12/3/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import UIKit

protocol ProductCellDelegate {
    
    func viewTapped(_ cell: ProductCell)
}


class ProductCell: UITableViewCell {
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var title: UILabel!

    var delegate: ProductCellDelegate?
    
    @IBAction func viewTapped(_ sender: AnyObject) {
        delegate?.viewTapped(self)
    }
}
