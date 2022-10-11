//
//  Extentions.swift
//  VoiceTranslator
//
//  Created by apple on 19.09.2022.
//

import UIKit


extension UIViewController {
    func presentShareView(text: String) {
       let shareSheetVC = UIActivityViewController(activityItems: [
       text
       ], applicationActivities: nil)
        present(shareSheetVC, animated: true)
    }
}
extension UIViewController {
     func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 300, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 18, weight: .bold)]), context: nil)
    }
    
    
    fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }
    fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
        return input.rawValue
    }
}
extension UIViewController {
    func addGesture(selector: Selector?, view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: selector)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    func addGesturePan(selector: Selector?, view: UIView) {
        let tap = UIPanGestureRecognizer(target: self, action: selector)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
}

extension UIViewController {
    func getAlert(message: String) {
        let ac = UIAlertController( title: nil, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okey", style: .default)
        ac.addAction(ok)
        present(ac, animated: true)
    }
    func showAlert(){
        
        let alert = UIAlertController(title: "no Internet", message: "This App Requires wifi/internet connection!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}


extension UIView {
    func makeShadow() {
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0.5, height: 3.0)
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
    }
   
}

extension String {
    func firstWord() -> String? {
        return self.components(separatedBy: ", ").first
    }
}


class Storyboards {
    static let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let premiumStoryboard: UIStoryboard = UIStoryboard(name: "PremiumScreen", bundle: nil)
    static let textStoryboard: UIStoryboard = UIStoryboard(name: "TextTranslateScreen", bundle: nil)
    static let voiceStoryboard: UIStoryboard = UIStoryboard(name: "VoiceTransateScreen", bundle: nil)
    static let historyStoryboard: UIStoryboard = UIStoryboard(name: "HistoryScreen", bundle: nil)
}
class Controllers {
    static let main = "MainController"
    static let history = "HistoryController"
    static let text = "TextTranslateController"
    static let voice = "VoiceChatViewController"
    static let premium = "GetPremiumController"
}

