//
//  EmployeeCell.swift
//  AvitoTest
//
//  Created by Антон Кочетков on 06.12.2021.
//

import UIKit

class EmployeeCell: UICollectionViewCell {

    static let identifier = "EmployeeCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "EmployeeCell", bundle: nil)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var skillsLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(name: String, phone: String, skills: String) {
        nameLabel.text = name
        phoneLabel.text = phone
        skillsLabel.text = skills
    }
}
