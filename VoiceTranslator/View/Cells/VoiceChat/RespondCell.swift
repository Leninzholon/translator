//
//  RespondCell.swift
//  VoiceTranslator
//
//  Created by apple on 16.09.2022.
//

import UIKit

protocol RespondCellDelegate: AnyObject {
    func resetTextFromTranslate()
}


class RespondCell: UICollectionViewCell {
    static let identifier = "RespondCell"
    var width: CGFloat?
    weak var delegate: RespondCellDelegate?
    var subWidthAncher: NSLayoutConstraint?
    @IBOutlet weak var subViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var textView: UITextView!
    override func layoutSubviews() {
        super.layoutSubviews()
        subView.layer.cornerCurve = .continuous
        subView.clipsToBounds = true
        subView.makeShadow()
       
        

    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subWidthAncher?.isActive = true
        subViewConstraint.isActive = true
        subWidthAncher = subViewConstraint
    }
  
    
   
    func configureCell(with model: TranslatedModel) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .right
        let attributedText = NSMutableAttributedString(string: model.questionText, attributes: [ .font: UIFont.systemFont(ofSize: 14, weight: .light),  .paragraphStyle: paragraph])
        let stringRespond = model.respondText

        attributedText.append(NSAttributedString(string:  "\n\n\(stringRespond)", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .bold),  .paragraphStyle: paragraph]))
        textView.attributedText = attributedText
        delegate?.resetTextFromTranslate()
    }
    static func nib() -> UINib{
        return UINib(nibName: "RespondCell", bundle: nil)
    }
}
