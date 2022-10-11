//
//  AlertLanguageRecognizer.swift
//  VoiceTranslator
//
//  Created by apple on 03.10.2022.
//

import UIKit

protocol AlertLanguageRecognizerDelegate: AnyObject {
    func okDismiss()
}

class AlertLanguageRecognizer: UIView {
    weak var delegate: AlertLanguageRecognizerDelegate?
    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupContentView()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 20
        
        contentView.makeShadow()

    }

    private func setupContentView() {
        Bundle.main.loadNibNamed(String(describing: AlertLanguageRecognizer.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    @IBAction func okTapped(_ sender: UIButton) {
        delegate?.okDismiss()
    }
}
