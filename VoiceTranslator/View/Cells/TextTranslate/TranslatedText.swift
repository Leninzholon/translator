//
//  TranslatedText.swift
//  VoiceTranslator
//
//  Created by apple on 15.09.2022.
//

import UIKit

protocol TranslatedTextProtocol: AnyObject {
    func shareTranslateText(text: String)
    func copyTextInBuffer(text: String)
    func readingText(trenslatedTextField: UITextView)
}

class TranslatedText: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate: TranslatedTextProtocol?
    @IBOutlet weak var voiceButton: UIButton!
    static let identifier = "TranslatedText"
    
    @IBOutlet weak var mainTranslatedView: UIView!
    @IBOutlet weak var trenslatedTextField: UITextView!
    //MARK: - Live cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        mainTranslatedView.makeShadow()
        
    }
    func configureCell(text: String, secondLanguage: LanguageStuck) {
//        secondLanguage.isUseVoice == true ? voiceButton.setImage(UIImage(named: "blue microfon icon"), for: .normal) : voiceButton.setImage(UIImage(systemName: "nosign"), for: .normal)
        voiceButton.isHidden = secondLanguage.isUseVoice == true ? false : true
        trenslatedTextField.text = text
    }
    //MARK: - helper func
    static func nib() -> UINib {
        return UINib(nibName: "TranslatedText", bundle: nil)
    }
    //MARK: - action
    
    @IBAction func voiceTapped(_ sender: UIButton) {
        if sender.image(for: .normal) == UIImage(systemName: "nosign") { return }
        delegate?.readingText(trenslatedTextField: trenslatedTextField)
       
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
        guard let text =   trenslatedTextField.text else {
            return
        }
        delegate?.shareTranslateText(text: text)
    }
    
    @IBAction func copyButtonPressed(_ sender: UIButton) {
        guard let text =   trenslatedTextField.text else {
            return
        }
        delegate?.copyTextInBuffer(text: text)
    }
}
