//
//  EnterTextField.swift
//  VoiceTranslator
//
//  Created by apple on 15.09.2022.
//

import UIKit

protocol EnterTextFieldProtocol: AnyObject {
    func ifTextIsChange(textView: String)
    func getingText(text: String)
    func emtyCell()
    func isMicroSpeech(button: UIButton)
}

class EnterTextField: UICollectionViewCell, UITextViewDelegate {
    //MARK: - Properties
    weak var delegate: EnterTextFieldProtocol?
    @IBOutlet weak var microButton: UIButton!
    @IBOutlet weak var mainTextView: UIView!
    @IBOutlet weak var enterTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!
    static let identifier = "EnterTextField"
    
    //MARK: - Live cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        mainTextView.makeShadow()
        translateButton.makeShadow()
        backgroundColor = .clear
        enterTextView.text = "Enter you text here..."
        enterTextView.textColor = UIColor.lightGray
        enterTextView.delegate = self
    }

    //MARK: - helper func
    static func nib() -> UINib {
        return UINib(nibName: "EnterTextField", bundle: nil)
    }
    func cellConfigure(text: String, firstLanguage: LanguageStuck) {
        microButton.isHidden =
        firstLanguage.isUseMicro == false ? true : false
        if text == "" {
            enterTextView.text = "Enter you text here..."
            enterTextView.textColor = UIColor.lightGray
        } else {
            enterTextView.text = text
            enterTextView.textColor = UIColor.black
            delegate?.ifTextIsChange(textView: text)
        }
      
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        delegate?.ifTextIsChange(textView: text)
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if enterTextView.textColor == UIColor.lightGray {
            enterTextView.text = nil
            enterTextView.textColor = UIColor.black
        }
        delegate?.ifTextIsChange(textView: textView.text)
    }
    func textViewDidEndEditing(_ textView: UITextView) {

        if enterTextView.text.isEmpty {
            enterTextView.text = "Enter you text here..."
            enterTextView.textColor = UIColor.lightGray
        }
    }
    //MARK: - action
    @IBAction func microTapped(_ sender: UIButton) {
        delegate?.isMicroSpeech(button: sender)
    }
    
    @IBAction func deleteText(_ sender: UIButton) {
        enterTextView.text = ""
        delegate?.emtyCell()
    }
    @IBAction func translatePressed(_ sender: UIButton) {
        if enterTextView.text == "Enter you text here..." { return }
        guard let text = enterTextView.text else { return }
        delegate?.getingText(text: text)
    }
    
}
