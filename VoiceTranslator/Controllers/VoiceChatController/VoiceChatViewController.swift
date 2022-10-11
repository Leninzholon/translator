//
//  VoiceChatViewController.swift
//  VoiceTranslator
//
//  Created by apple on 17.09.2022.
//

import UIKit
import Speech
import AVKit
import SwiftyTranslate
import GoogleMobileAds



class VoiceChatViewController: UIViewController {
    //MARK: - Properties
    var isShowSearch = false
    var id: isSide?
    var isActiveRightMicro = false
    var firstLanguage: LanguageStuck = DataManager.shared.getDefaultLanguage()
    var secondLanguage: LanguageStuck = DataManager.shared.getCurrentLanguage()
    let countries = DataManager.shared.sortCountriesByMicro().sorted{$0.countryName < $1.countryName}
    var filterCountries = [LanguageStuck]()
    var languages : LanguageStuck?
    var translateText: String?
    var stringText: String = ""
    var isSide = true
    var swichTranslate = true
    
    //MARK: - array for text for translate
    
    var  textForTranslate = [TranslatedModel]()
    //------------------------------------------------------------------------------
    // MARK: -
    // MARK: - Variables speech recognizer
    //------------------------------------------------------------------------------
    
    lazy var speechRecognizer =
    SFSpeechRecognizer(locale: Locale(identifier: firstLanguage.localShortLanguage))
    
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()
    
    
    //MARK: - @IBOutlet
    @IBOutlet weak var enterLanguageSpeechLabel: UILabel!
    
    @IBOutlet weak var supSearchDismissView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //navigation view
    
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var premiumSwicher: UISwitch!
    @IBOutlet weak var premiumView: UIView!
    
    
    // bottom view
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var swichView: UIImageView!
    
    @IBOutlet weak var leftMicroButton: UIButton!
    @IBOutlet weak var rightMicroButton: UIButton!
    
    @IBOutlet weak var moveSearchLeft: UIImageView!
    @IBOutlet weak var moveSearchRight: UIImageView!
    
    @IBOutlet weak var rightLenguageView: UIView!
    @IBOutlet weak var leftLeanguageView: UIView!
    @IBOutlet weak var leftFlag: UIImageView!
    @IBOutlet weak var leftLanguage: UILabel!
    @IBOutlet weak var rightFlag: UIImageView!
    @IBOutlet weak var rightLanguage: UILabel!
    
    //label if collection is empty
    
    @IBOutlet weak var ifEmpryChats: UIStackView!
    // speech view
    
    @IBOutlet weak var speechView: UIView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // - cell collection view
        
        collectionView.register(QuestionCell.nib(), forCellWithReuseIdentifier: QuestionCell.identifier)
        collectionView.register(RespondCell.nib(), forCellWithReuseIdentifier: RespondCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // - cell table view
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryCell.nib(), forCellReuseIdentifier: CountryCell.identifier)
        
        // - for func
        setGesture()
        setupSpeech()
        speechView.isHidden = true
        setupSearchView()
        loadData()
        settingForSwitcher()
        setupShadow()
//        loadAds()
    }
    
    //MARK: - helpers func
    fileprivate func loadAds() {
        bannerView.rootViewController = self
        bannerView.adUnitID = Constants.shared.openKey
        bannerView.load(GADRequest())
    }
    fileprivate func setupShadow() {
        rightLenguageView.makeShadow()
        leftLeanguageView.makeShadow()
    }
    fileprivate func setupSearchView() {
        searchTextField.delegate = self
        searchText(searchText: "")
    }

    fileprivate func settingForSwitcher() {
        premiumSwicher.isOn = false
        premiumSwicher.isUserInteractionEnabled = false
    }
    
    fileprivate func loadData() {
        textForTranslate = StorageManager.shared.load()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    private func setLanguage(flag: UIImageView, label: UILabel, laguage: LanguageStuck) {
        flag.image = UIImage(named: laguage.flagName)
        label.text = laguage.countryName
        
    }
    
    private func moveSearchView() {
        isShowSearch.toggle()
        isShowSearch ? moveElements(isShowSearch: isShowSearch) : moveElements(isShowSearch: isShowSearch)        
    }
    private func moveElements(isShowSearch: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
        self.tableView.isHidden = !isShowSearch
        self.searchView.isHidden =  !isShowSearch
        self.supSearchDismissView.isHidden =  !isShowSearch
        }
    }
    private func setGesture() {
        addGesture(selector:  #selector(handleShowSearchLeft), view: leftLeanguageView)
        addGesture(selector: #selector(handleShowSearchRiht), view: rightLenguageView)
        addGesture(selector: #selector(handleDismissSpeechView), view: speechView)
        addGesture(selector:  #selector(handleSwichLanguage), view: swichView)
        addGesture(selector: #selector(handleToPremium), view: premiumView)
        addGesture(selector: #selector(handleSearchViewDismiss), view: supSearchDismissView)
    }
    private func setLanguageInterface() {
        leftFlag.image = UIImage(named: firstLanguage.flagName)
        rightFlag.image = UIImage(named: secondLanguage.flagName)
        leftLanguage.text = firstLanguage.countryName
        rightLanguage.text = secondLanguage.countryName
    }

    
    private func howLongCell(textRes: String, textQues: String) -> CGFloat{
        var text = ""
        if estimateFrameForText(textRes).width > estimateFrameForText(textQues).width {
            text = textRes
        }  else {
            text = textQues
        }
        let  width = estimateFrameForText(text).width + 40
        return width
    }

    fileprivate func setingRecording() {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
        } else {
            self.startRecording()
        }
    }
    
    private func microSpeechAction() {
        speechView.isHidden = false
        setingRecording()
    }
    //MARK: - action func
    
    @IBAction func deleteHistiryButton(_ sender: UIButton) {
        StorageManager.shared.deleteAll()
        textForTranslate = StorageManager.shared.load()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    @IBAction func leftMicro(_ sender: UIButton) {
        isActiveRightMicro = true
        id = .left
        
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: firstLanguage.localShortLanguage))
        
        isSide = false
        microSpeechAction()
    }
    @IBAction func rightMicro(_ sender: UIButton) {
        isActiveRightMicro = false
        isSide = true
        id = .right
        
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: secondLanguage.localShortLanguage))
        microSpeechAction()
        
    }
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    //MARK: - func selector
    @objc private func handleSearchViewDismiss() {
        moveSearchView()
    }
    @objc private func handleToPremium() {
        let secondStoryBoard = Storyboards.premiumStoryboard
        let secondViewController = secondStoryBoard.instantiateViewController(withIdentifier: Controllers.premium) as! GetPremiumController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    @objc private func handleSwichLanguage() {
        if id == .left {
            id = .right
        } else {
            id = .left
        }
        let swichLanguage = firstLanguage
        firstLanguage = secondLanguage
        secondLanguage = swichLanguage
        speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: firstLanguage.localShortLanguage))
        setLanguageInterface()
        
    }
  
    
    @objc private func handleDismissSpeechView() {
        chekStatusRecognizer()
        speechView.isHidden = true
        if id == .left {
            
            getingText(text: stringText, from: firstLanguage, to: secondLanguage)
        } else {
            getingText(text: stringText, from: secondLanguage, to: firstLanguage)
            
        }
    }
    @objc private func handleShowSearchLeft() {
        id = .left
        moveSearchView()
    }
    @objc private func handleShowSearchRiht() {
        id = .right
        moveSearchView()
    }
}

//MARK: - extentions
//MARK: - collection view

extension VoiceChatViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ifEmpryChats.isHidden =  textForTranslate.isEmpty ? false :  true
        return textForTranslate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch textForTranslate[indexPath.item].whatIsSide{
        case .left:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestionCell.identifier, for: indexPath) as? QuestionCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.configureCell(with: textForTranslate[indexPath.item])
            let textRes = textForTranslate[indexPath.item].respondText
            let textQues = textForTranslate[indexPath.item].questionText
            let width = howLongCell(textRes: textRes, textQues: textQues)
            cell.subWidthAncher?.constant = width
            return cell
        case .right:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RespondCell.identifier, for: indexPath) as? RespondCell else { return UICollectionViewCell() }
            cell.delegate = self
            cell.configureCell(with: textForTranslate[indexPath.item])
            let textRes = textForTranslate[indexPath.item].respondText
            let textQues = textForTranslate[indexPath.item].questionText
            let  width = howLongCell(textRes: textRes, textQues: textQues)
            cell.subWidthAncher?.constant = width
            return cell
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let text = textForTranslate[indexPath.item].respondText
        height = estimateFrameForText(text).height * 2 + 60
        return CGSize(width: view.frame.width, height: height)
    }
}

//MARK: - uitableview
extension VoiceChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCountries.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.identifier, for: indexPath) as? CountryCell else { return UITableViewCell() }
        let country = filterCountries[indexPath.row]
        cell.congigureCell(with: country)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        languages = filterCountries[indexPath.row]
        guard let languages = languages else {
            return
        }
        if id == .left {
            setLanguage(flag: leftFlag, label: leftLanguage, laguage: languages)
            firstLanguage = languages
        }
        if id == .right {
            setLanguage(flag: rightFlag, label: rightLanguage, laguage: languages)
            secondLanguage = languages
        }
        moveSearchView()
    }
}

//------------------------------------------------------------------------------
// MARK: - extension
//MARK: - SFSpeechRecognizerDelegate Methods
//------------------------------------------------------------------------------

extension VoiceChatViewController: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            self.leftMicroButton.isEnabled = true
        } else {
            self.leftMicroButton.isEnabled = false
        }
    }
    //------------------------------------------------------------------------------
    // MARK: -
    // MARK: - Custom Methods
    //------------------------------------------------------------------------------
    
    func setupSpeech() {
        speechView.isHidden = false
        self.speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            @unknown default:
                break
            }
            
            OperationQueue.main.addOperation() {
                self.leftMicroButton.isEnabled = isButtonEnabled
            }
        }
    }
    func startRecording() {
        
        // Clear all previous session data and cancel task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                let text = result?.bestTranscription.formattedString
                guard let text = text else { return }
                self.stringText = text
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.speechView.isHidden = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        self.audioEngine.prepare()
        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
    fileprivate func chekStatusRecognizer() {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
        } else {
            self.startRecording()
        }
    }
}


//MARK: - Translate text

extension VoiceChatViewController {
    func getingText(text: String , from firstLanguage: LanguageStuck, to secondLanguage: LanguageStuck) {
        let hostoryArray = StorageManager.shared.load()
        if let questionText = hostoryArray.last?.questionText, text == questionText {
                return
        }
        SwiftyTranslate.translate(text: text, from: firstLanguage.shortName, to: secondLanguage.shortName) { result in
            switch result {
            case .success(let translation):
                self.translateText = translation.translated
                guard let translateText = self.translateText else { return }
                if self.isSide {
                    let textTranslate = TranslatedModel(questinLanguage: firstLanguage.countryName, questionText: text, responseLanguege: secondLanguage.countryName, respondText: translateText, whatIsSide: .right)
                    StorageManager.shared.save(translated: textTranslate)
                    self.textForTranslate = StorageManager.shared.load()
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    
                }
                else {
                    let textTranslate = TranslatedModel(questinLanguage: firstLanguage.countryName, questionText: text, responseLanguege: secondLanguage.countryName, respondText: translateText, whatIsSide: .left)
                    StorageManager.shared.save(translated: textTranslate)
                    self.textForTranslate = StorageManager.shared.load()
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.getAlert(message: error.localizedDescription)
                }
                print("Error: \(error)")
            }
        }
    }
}

//MARK: - extentions search view


extension VoiceChatViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        searchText(searchText: newString)
        return true
    }
    func searchText(searchText: String) {
        if searchText.isEmpty {
            filterCountries = countries
        } else {
            self.filterCountries = self.countries.filter({ county in
                return county.countryName.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
}

//MARK: - extentions seting cell

extension VoiceChatViewController: QuestionCellProtocol {
    func resetTextForTranslate() {
        self.stringText = ""


    }
}
extension VoiceChatViewController: RespondCellDelegate {
    func resetTextFromTranslate() {
        self.stringText = ""

    }
}
