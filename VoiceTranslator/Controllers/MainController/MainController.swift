//
//  ViewController.swift
//  VoiceTranslator
//
//  Created by apple on 13.09.2022.
//

import UIKit
import Vision
import GoogleMobileAds


class MainController: UIViewController {
    
    //MARK: - Parameters
    
    
    //menu point
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var rateUsLabel: UILabel!
    @IBOutlet weak var shareAppLabel: UILabel!
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var privatePollicyLabel: UILabel!
    
    @IBOutlet weak var menuchangeConstraint: NSLayoutConstraint!
    var isMenu = false
    
    var textFromImage: String?
    //main
    //menu
    @IBOutlet weak var premiumButton: UIView!
    @IBOutlet weak var lounchView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var swichPremium: UISwitch!
    @IBOutlet weak var premiumView: UIView!
    
    @IBOutlet weak var underMenu: UIView!
    
    @IBOutlet weak var textTranslateView: UIView!
    @IBOutlet weak var imageTranslatorView: UIView!
    @IBOutlet weak var cameraTranslatorView: UIView!
    @IBOutlet weak var voiceChatView: UIView!
    
    @IBOutlet weak var bannerMenuView: GADBannerView!
    @IBOutlet weak var bannerView: GADBannerView!
    //MARK: - Life cycle
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTimerForLonch()
        makeBgForMenu()
        settingGestereOnMenu()
        setGesture()
        setingForSwicher()
        makeShadowForView()
        loadAds()
    }
    //MARK: - selector
    // transitions menu
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let x = translation.x
        
        switch gesture.state {
        case .changed:
            
            if self.menuchangeConstraint.constant < 0 {
                self.menuchangeConstraint.constant = x - 300
                self.view.layoutIfNeeded()
            }
        case .ended:
            if translation.x > menuView.frame.width / 2 && !isMenu{
                isMenu = true
                movingForMenu(whatIsPosition: true)
                self.underMenu.isHidden = false
            } else if x < 0 {
                isMenu = false
                movingForMenu(whatIsPosition: false)
                self.underMenu.isHidden = true
                    }
            else if   x > 0 && isMenu {
            return
            }
            else {
                movingForMenu(whatIsPosition: false)
            }
        @unknown default:
            break
        }
    }

    @objc private func handleTapDismiss() {
        if isMenu {
            moveMenu()
        }
    }
    //  loading whene start app
    @objc private func handleHitenLounchView() {
        UIView.animate(withDuration: 0.5) {
            self.lounchView.alpha = 0.5
        } completion: { _ in
            self.lounchView.isHidden = true
        }
    }
    @objc private func handleMoveMenu() {
        moveMenu()
    }
    
    @objc private func handleTextTranslate() {
        let storybourd = Storyboards.textStoryboard
        let secondViewController = storybourd.instantiateViewController(withIdentifier: Controllers.text) as! TextTranslateController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    @objc private func handleVoiceChat() {
        let storybourd = Storyboards.voiceStoryboard
        let secondViewController = storybourd.instantiateViewController(withIdentifier: Controllers.voice) as! VoiceChatViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    @objc private func handleCameraTranslator() {
        self.choseImagePiker(source: .camera)
    }
    @objc private func handleImageTranslator() {
        self.choseImagePiker(source: .savedPhotosAlbum)
    }
    // transitions with menu
    @objc private func handleTransitionToPremium() {
        let storybourd = Storyboards.premiumStoryboard
        let secondViewController = storybourd.instantiateViewController(withIdentifier: Controllers.premium) as! GetPremiumController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    // transitions with top navigation bar
    @objc private func handleGetPremium() {
        moveMenu()
        handleTransitionToPremium()
    }
    //MARK: - helpers funcs
    fileprivate func loadAds() {
        bannerMenuView.rootViewController = self
        bannerMenuView.adUnitID = Constants.shared.openKey
        bannerMenuView.load(GADRequest())
        bannerView.rootViewController = self
        bannerView.adUnitID = Constants.shared.openKey
        bannerView.load(GADRequest())
    }
    
    fileprivate func makeBgForMenu() {
        underMenu.isHidden = true
    }
    fileprivate func setTimerForLonch() -> Timer {
        return Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(handleHitenLounchView), userInfo: nil, repeats: false)
    }
    fileprivate func makeShadowForView() {
        textTranslateView.makeShadow()
        voiceChatView.makeShadow()
        cameraTranslatorView.makeShadow()
        imageTranslatorView.makeShadow()
    }
    private func movingForMenu(whatIsPosition: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.menuchangeConstraint.constant = whatIsPosition ?  0 : -300
            self.view.layoutIfNeeded()
            self.underMenu.isHidden = !whatIsPosition
        
        }
    }
    private func setGesture() {
        addGesturePan(selector: #selector(handlePanGesture), view: view)
        addGesture(selector: #selector(handleShowHistory), view: historyLabel)
        addGesture(selector:  #selector(handleRateUs), view: rateUsLabel)
        addGesture(selector: #selector(handleSareApp), view: shareAppLabel)
        addGesture(selector: #selector(handleContactUs), view: contactUsLabel)
        addGesture(selector:  #selector(handlePrivacyPolicy), view: privatePollicyLabel)
        addGesture(selector:  #selector(handleTransitionToPremium), view: premiumView)
        addGesture(selector:  #selector(handleGetPremium), view: premiumButton)
    }
    fileprivate func setingForSwicher() {
        swichPremium.isOn = false
        swichPremium.isUserInteractionEnabled = false
    }
    //MARK: - action funcs
    
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        moveMenu()
    }
    //MARK: - helpers func
    // menu
    fileprivate func settingGestereOnMenu() {
        addGesture(selector: #selector(handleTextTranslate), view: textTranslateView)
        addGesture(selector: #selector(handleVoiceChat), view: voiceChatView)
        addGesture(selector: #selector(handleCameraTranslator), view: cameraTranslatorView)
        addGesture(selector: #selector(handleImageTranslator), view: imageTranslatorView)
        addGesture(selector: #selector(handleTapDismiss), view: underMenu)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleMoveMenu))
        swipe.direction = .left
        menuView.addGestureRecognizer(swipe)
    }
    private func moveMenu() {
        isMenu = !isMenu
        UIView.animate(withDuration: 0.5) {
            if self.isMenu {
                //                self.menuView.frame.origin.x = 0
                self.menuchangeConstraint.constant = 0
                self.view.layoutIfNeeded()
                
                self.underMenu.isHidden = false
            } else {
                //                self.menuView.frame.origin.x -= 300
                self.menuchangeConstraint.constant = -300
                self.view.layoutIfNeeded()
                self.underMenu.isHidden = true
                
            }
        }
    }
    
}
//MARK: - extention imagePiker

extension MainController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func choseImagePiker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePiker = UIImagePickerController()
            imagePiker.delegate = self
            imagePiker.allowsEditing = true
            imagePiker.sourceType = source
            imagePiker.allowsEditing = true
            imagePiker.modalPresentationStyle = .fullScreen
            present(imagePiker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        recognizeText(image: image)
        let secondStoryBoard = UIStoryboard(name: "TextTranslateScreen", bundle: nil)
        let secondViewController = secondStoryBoard.instantiateViewController(withIdentifier: "TextTranslateController") as! TextTranslateController
        secondViewController.textFromImage = textFromImage
        secondViewController.isImageRecognit = false
        secondViewController.isDetectedText = true
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
        dismiss(animated: true)
    }
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else { return }
        
        let hendler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest{ [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation ], error == nil else {  return  }
            let text =  observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ",  ")
            print(text)
            self?.textFromImage = text
        }
        request.recognitionLanguages = [ "zh-Hans", "zh-Hant"]
        request.usesLanguageCorrection = true
        do{
            try hendler.perform([request])
        } catch{
            print(error)
        }
    }
}


//MARK: - navigation menu
extension MainController {
    @objc private func handleShowHistory() {
        moveMenu()
        let storybourd = Storyboards.historyStoryboard
        let secondViewController = storybourd.instantiateViewController(withIdentifier: Controllers.history) as! HistoryController
        UIView.animate(withDuration: 0.5, delay: 0.5) {
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }
    @objc private func handleRateUs() {
        print("DEBAG: RateUs app..")
        moveMenu()
    }
    @objc private func handleSareApp() {
        moveMenu()
        self.presentShareView(text: "url SmartTranslator app")
    }
    @objc private func handleContactUs() {
        print("DEBAG: ContactUs app..")
        moveMenu()
    }
    @objc private func handlePrivacyPolicy() {
        print("DEBAG: PrivacyPolicy app..")
        moveMenu()
    }
}

