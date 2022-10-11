//
//  HistoryCell.swift
//  VoiceTranslator
//
//  Created by apple on 17.09.2022.
//

import UIKit

protocol HistoryCellDelegate: AnyObject {
    func deleteItem(cell: UICollectionViewCell)
}

class HistoryCell: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate: HistoryCellDelegate?
    
    @IBOutlet weak var questionLanguage: UILabel!
    @IBOutlet weak var questionText: UILabel!
    
    @IBOutlet weak var respondText: UILabel!
    @IBOutlet weak var respondLanguage: UILabel!
    
    static let identifier = "HistoryCell"
    //MARK: - Livecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //MARK: - helpers func
    func configureCell(wit model: TranslatedModel) {
        questionLanguage.text = model.questinLanguage
        questionText.text = model.questionText
        respondLanguage.text = model.responseLanguege
        respondText.text = model.respondText
    }
    static func nib() -> UINib {
        return UINib(nibName: "HistoryCell", bundle: nil)
    }
    
    //MARK: - action func
    @IBAction func trushTapped(_ sender: UIButton) {
        delegate?.deleteItem(cell: self)
    }
    
}
