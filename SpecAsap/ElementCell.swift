//
//  ElementCell.swift
//  SpecAsap
//
//  Created by David Cheli on 11/13/16.
//  Copyright © 2016 David Cheli. All rights reserved.
//

import UIKit

protocol ElementCellDelegate {
    
    func viewTapped(_ cell: ElementCell)
}

class ElementCell: UITableViewCell {
    
    @IBOutlet weak var elementName: UILabel!
    
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var elementId: UILabel!
    var delegate: ElementCellDelegate?
    
    @IBAction func viewTapped(_ sender: AnyObject) {
        delegate?.viewTapped(self)
    }
}
