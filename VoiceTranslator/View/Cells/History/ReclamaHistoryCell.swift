//
//  ReclamaHistoryCell.swift
//  VoiceTranslator
//
//  Created by apple on 17.09.2022.
//

import UIKit

class ReclamaHistoryCell: UICollectionViewCell {
static let identifier = "ReclamaHistoryCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static func nib() -> UINib {
        return UINib(nibName: "ReclamaHistoryCell", bundle: nil)
    }
}
