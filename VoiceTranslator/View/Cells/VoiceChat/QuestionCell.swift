//
//  QuestionCell.swift
//  VoiceTranslator
//
//  Created by apple on 16.09.2022.
//

import UIKit

protocol QuestionCellProtocol: AnyObject {
    func resetTextForTranslate()
}

class QuestionCell: UICollectionViewCell {
    weak var delegate: QuestionCellProtocol?
    var subWidthAncher: NSLayoutConstraint?
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var subWidthConstraint: NSLayoutConstraint!
    static let identifier = "QuestionCell"
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.layer.cornerCurve = .continuous
        bgView.clipsToBounds = true
        bgView.makeShadow()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subWidthAncher?.isActive = true
        subWidthConstraint.isActive = true
        subWidthAncher = subWidthConstraint
    }
    func configureCell(with model: TranslatedModel) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        let attributedText = NSMutableAttributedString(string: model.questionText, attributes: [ .font: UIFont.systemFont(ofSize: 14, weight: .light),  .paragraphStyle: paragraph])
        let stringRespond = model.respondText

        attributedText.append(NSAttributedString(string:  "\n\n\(stringRespond)", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold),  .paragraphStyle: paragraph]))
        textView.attributedText = attributedText
        delegate?.resetTextForTranslate()
    }
    static func nib() -> UINib{
        return UINib(nibName: "QuestionCell", bundle: nil)
    }
    
}
