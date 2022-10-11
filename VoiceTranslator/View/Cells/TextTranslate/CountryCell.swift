//
//  CountryCell.swift
//  VoiceTranslator
//
//  Created by apple on 16.09.2022.
//

import UIKit

class CountryCell: UITableViewCell {

    //MARK: - Properties
        static let identifier = "CountryCell"
        
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    //MARK: - livecycle
        override func awakeFromNib() {
            super.awakeFromNib()

        }
    func congigureCell(with model: LanguageStuck){
        countryName.text = model.countryName
        flagImage.image = UIImage(named: "\(model.flagName)")
    }
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

        }
        
    //MARK: - helpers func
        static func nib() -> UINib {
            return UINib(nibName: "CountryCell", bundle: nil)
        }
}
    

