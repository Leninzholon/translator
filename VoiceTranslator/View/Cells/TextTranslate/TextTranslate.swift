//
//  TextTranslate.swift
//  VoiceTranslator
//
//  Created by apple on 15.09.2022.
//


import UIKit

protocol TextTranslateProtocol: AnyObject {
    func isSearchLeft()
    func isSearchRight()
    func swichLanguege(swichLeft: LanguageStuck, swichRight: LanguageStuck)

}
class TextTranslate: UICollectionViewCell {
    var swichRight: LanguageStuck?
    var swichLeft: LanguageStuck?
    
    //MARK: - Properties
    weak var delegate: TextTranslateProtocol?
    @IBOutlet weak var rightMainView: UIView!
    @IBOutlet weak var leftMainView: UIView!
    @IBOutlet weak var swichImage: UIImageView!
    @IBOutlet weak var searchLeftView: UIImageView!
    @IBOutlet weak var leftCountry: UILabel!
    @IBOutlet weak var leftFlag: UIImageView!
    @IBOutlet weak var searchRightView: UIImageView!
    @IBOutlet weak var rightCountry: UILabel!
    @IBOutlet weak var rightFlag: UIImageView!
    static let identifier = "TextTranslate"
    //MARK: - Live cycle
    fileprivate func addShadow() {
        rightMainView.makeShadow()
        leftMainView.makeShadow()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        addShadow()
        setGesture()
    }
    //MARK: - helper func
    static func nib() -> UINib {
        return UINib(nibName: "TextTranslate", bundle: nil)
    }
    func configureCell(firstLanguage: LanguageStuck, secondLanguage: LanguageStuck) {
        print("DEBAG: configureCell")
        
       checkSide(language: firstLanguage)
       checkSide(language: secondLanguage)
    }
    private func checkSide(language: LanguageStuck) {
        if language.id == .right {
            swichLeft = language
            rightFlag.image = UIImage(named: "\(language.flagName)")
            rightCountry.text = language.countryName
        }
        if language.id == .left {
            swichRight = language
            leftFlag.image = UIImage(named: language.flagName)
            leftCountry.text = language.countryName
        }
    }
    private func setGesture() {
        let tapLeft = UITapGestureRecognizer(target: self, action: #selector(handleLeftSerch))
        let tapRight = UITapGestureRecognizer(target: self, action: #selector(handleRightSerch))
        leftMainView.addGestureRecognizer(tapLeft)
        leftMainView.isUserInteractionEnabled = true
        rightMainView.addGestureRecognizer(tapRight)
        rightMainView.isUserInteractionEnabled = true
        let swichTap = UITapGestureRecognizer(target: self, action: #selector(handleSwichLanguage))
        swichImage.isUserInteractionEnabled = true

        swichImage.addGestureRecognizer(swichTap)
    }
    
    //MARK: - selector
    @objc private func handleLeftSerch() {
        delegate?.isSearchLeft()
    }
    @objc private func handleRightSerch() {
        delegate?.isSearchRight()
    }
    @objc private func handleSwichLanguage() {
        let firstId = swichLeft?.id
        let secondId = swichRight?.id
        swichRight?.id = firstId
        swichLeft?.id = secondId
        guard let swichRight = swichRight else { return }
        guard let swichLeft = swichLeft else { return }
        delegate?.swichLanguege(swichLeft: swichLeft, swichRight: swichRight)

    }

    
}



