//
//  ReclamaViewCell.swift
//  VoiceTranslator
//
//  Created by apple on 16.09.2022.
//

import UIKit

class ReclamaViewCell: UICollectionViewCell {
//MARK: - Properties
    static let identifier = "ReclamaViewCell"
    
//MARK: - livecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//MARK: - Helpers func
    
    static func nib() -> UINib{
        return UINib(nibName: "ReclamaViewCell", bundle: nil)
    }
}
