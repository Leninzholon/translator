//
//  TextTranslateController.swift
//  VoiceTranslator
//
//  Created by apple on 15.09.2022.
//

import UIKit
import Speech
import AVKit
import AVFoundation
import SwiftyTranslate
import GoogleMobileAds

class TextTranslateController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var alertView: AlertLanguageRecognizer!
    lazy var speechRecognizer = SFSpeechRecognizer(locale:
                                                    Locale(identifier: firstLanguage.id == .left ? firstLanguage.localShortLanguage : secondLanguage.localShortLanguage))
    
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask         : SFSpeechRecognitionTask?
    let audioEngine             = AVAudioEngine()
    var firstLanguage: LanguageStuck = DataManager.shared.getDefaultLanguage(){
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
            }
        }
    }
     var secondLanguage: LanguageStuck = DataManager.shared.getCurrentLanguage()
    var id: isSide?
    var isDetectedText = false
    var isShowSearch = false
    var isShowSpeech = false
    var languages : LanguageStuck?
    var translateText: String?

    let countries =  DataManager.shared.allCountry.sorted{$0.countryName < $1.countryName}
    var filterCountries = [LanguageStuck]()
    var stringText = ""
    {
        didSet {
            if isDetectedText == true {
                self.isDetectedText = false
                if let lenguage = DataManager.shared.detectedLanguage(for: stringText){
                    firstLanguage = DataManager.shared.detetectedLanguageForInit(localLanguage: lenguage )
                    firstLanguage.id = .left
                }
            }
        }
    }
    var textFromImage: String? {
        didSet {
            guard let textFromImage = textFromImage  else {
                return
            }
            stringText = textFromImage
        }
    }
    var isImageRecognit = true
    // @IBOutlet
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var premiumSwicher: UISwitch!
    @IBOutlet weak var speechView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var supSearchDismiss: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //ads
    @IBOutlet weak var bannerView: GADBannerView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    //MARK: - Live cycle

    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: - cell collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TextTranslate.nib(), forCellWithReuseIdentifier: TextTranslate.identifier)
        collectionView.register(EnterTextField.nib(), forCellWithReuseIdentifier: EnterTextField.identifier)
        collectionView.register(TranslatedText.nib(), forCellWithReuseIdentifier: TranslatedText.identifier)
        collectionView.register(ReclamaViewCell.nib(), forCellWithReuseIdentifier: ReclamaViewCell.identifier)
        //MARK: - cell table view
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryCell.nib(), forCellReuseIdentifier: CountryCell.identifier)
        setupUI()
    }
  
  


    //MARK: - action func
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    //MARK: - helpers func
    fileprivate func setupUI() {
        setupSpeech()
        setGesture()
        sepupSpeechView()
        setingForSwicher()
        setupSearchView()
        setIdSide()
        setupApert()
    }
    fileprivate func sepupSpeechView() {
        speechView.isHidden = true
    }
    
    fileprivate func setupApert() {
        //        loadAds()
        //        alertView.delegate = self
        alertView.isHidden = true
    }
    fileprivate func setIdSide() {
        firstLanguage.id = .left
        secondLanguage.id = .right
    }
    fileprivate func loadAds() {
        bannerView.rootViewController = self
        bannerView.adUnitID = Constants.shared.openKey
        bannerView.load(GADRequest())
    }
    fileprivate func setupSearchView() {
        searchTextField.delegate = self
        searchText(searchText: "")
    }
    
    fileprivate func setingForSwicher() {
        premiumSwicher.isOn = false
        premiumSwicher.isUserInteractionEnabled = false
    }
    private func moveSearchView() {
        isShowSearch.toggle()
        isShowSearch ? moveElements(isShowSearch: isShowSearch) : moveElements(isShowSearch: isShowSearch)
    }
    private func moveElements(isShowSearch: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
        self.tableView.isHidden = !isShowSearch
        self.searchView.isHidden =  !isShowSearch
        self.supSearchDismiss.isHidden =  !isShowSearch
        }
    }
    func moveSpeech() {
        if isShowSpeech {
            speechView.isHidden = true
        }
    }
    private func setGesture() {
        addGesture(selector: #selector(handleMoveSearch), view: supSearchDismiss)
        addGesture(selector: #selector(handleTapPremium), view: premiumView)
        addGesture(selector: #selector(handleMoveSpeechView), view: speechView)
    }
    fileprivate func resetingRecording() {
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
        } else {
            self.startRecording()
        }
    }
    private func microSpeechAction() {
        speechView.isHidden = false
        resetingRecording()
    }

    //MARK: - selector func
    @objc private func handleTapPremium() {
        let storybourd = Storyboards.premiumStoryboard
        let secondViewController = storybourd.instantiateViewController(withIdentifier: Controllers.premium) as! GetPremiumController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    @objc private func handleMoveSpeechView() {
        speechView.isHidden = false
        isShowSpeech = true
        moveSpeech()
        collectionView.reloadData()        
        microSpeechAction()
    }
    @objc private func handleMoveSearch() {
        moveSearchView()
    }
}

//MARK: - collection view

extension TextTranslateController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextTranslate.identifier, for: indexPath)  as? TextTranslate else { return UICollectionViewCell() }
                cell.delegate = self
                cell.configureCell(firstLanguage: firstLanguage, secondLanguage: secondLanguage)
                
                return cell
            case 1:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EnterTextField.identifier, for: indexPath) as? EnterTextField else { return UICollectionViewCell()}
                cell.delegate = self
//                if stringText != "" || firstLanguage.isUseMicro == false {
                    cell.cellConfigure(text: stringText, firstLanguage: firstLanguage)
//                }
                return cell
            default:
                return UICollectionViewCell()
            }
        } else {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TranslatedText.identifier, for: indexPath)  as? TranslatedText else { return UICollectionViewCell() }
            cell.delegate = self
//            guard let translatedText = translateText else { return cell}
            cell.configureCell(text: translateText ?? "", secondLanguage: secondLanguage)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return .init(width: view.frame.size.width, height: 80)
            case 1:
                return .init(width: view.frame.size.width, height: 300)
            default:
                return .init(width: view.frame.size.width, height: 300)
                
            }
        } else {
            return .init(width: view.frame.size.width, height: 230)
        }
    }
}
//MARK: - uitableview
extension TextTranslateController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if id == firstLanguage.id && isImageRecognit == false {
            return  DataManager.shared.recognizeContry.count
        } else {
            return  filterCountries.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.identifier, for: indexPath) as? CountryCell else { return UITableViewCell() }
        if id == firstLanguage.id && isImageRecognit == false  {
            cell.congigureCell(with: DataManager.shared.recognizeContry[indexPath.row])
            
        } else {
            cell.congigureCell(with: filterCountries[indexPath.row])
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if id == firstLanguage.id {
            firstLanguage = isImageRecognit ? filterCountries[indexPath.row] : DataManager.shared.recognizeContry[indexPath.row]
            firstLanguage.id = id

        } else {
            secondLanguage = filterCountries[indexPath.row]
            secondLanguage.id = id
            translateText = ""
        }
        moveSearchView()
        collectionView.reloadData()
    }
}

//MARK: - Speech recogniser
extension TextTranslateController : SFSpeechRecognizerDelegate {
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
        }
    }
    func startRecording() {
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
}

//MARK: - extension Protocol
//MARK: - TextTranslateProtocol
extension TextTranslateController: TextTranslateProtocol {
    
    func isSearchLeft() {
        id = .left
        moveSearchView()
    }
    func isSearchRight() {
        id = .right
        moveSearchView()
    }
    
    func swichLanguege(swichLeft: LanguageStuck, swichRight: LanguageStuck) {
        firstLanguage = swichRight
        secondLanguage = swichLeft
        collectionView.reloadData()
    }
}
//MARK: - EnterTextFieldProtocol

extension TextTranslateController: EnterTextFieldProtocol {
 
    
    func ifTextIsChange(textView: String) {
        stringText = textView
    }
    func isMicroSpeech(button: UIButton) {
        self.isDetectedText = false
        speechRecognizer = SFSpeechRecognizer(locale:
                                                Locale(identifier: firstLanguage.id == .left ? firstLanguage.localShortLanguage : secondLanguage.localShortLanguage))
        microSpeechAction()
    }
    func emtyCell() {
        translateText = ""
        stringText = ""
        collectionView.reloadData()
    }
    
    func getingText(text: String) {
        SwiftyTranslate.translate(text: text, from:  firstLanguage.id == .left ? firstLanguage.shortName : secondLanguage.shortName, to: firstLanguage.id == .right ? firstLanguage.shortName : secondLanguage.shortName ) { result in
            switch result {
            case .success(let translation):
                print("Translated: \(translation.translated)")
                self.translateText = translation.translated
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
//MARK: - TranslatedTextProtocol

extension TextTranslateController: TranslatedTextProtocol {
    
    func readingText(trenslatedTextField: UITextView) {
        guard let string = trenslatedTextField.text else { return }
        let utterance = AVSpeechUtterance(string: string)
    
        utterance.voice = AVSpeechSynthesisVoice(language: firstLanguage.id == .right ? firstLanguage.localShortLanguage :  secondLanguage.localShortLanguage)

        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    
    func copyTextInBuffer(text: String) {
        UIPasteboard.general.string = text
        getAlert(message: "Text copied")
        
    }
    
    func shareTranslateText(text: String) {
        self.presentShareView(text: text)
    }
}
//MARK: - search view


extension TextTranslateController: UITextFieldDelegate {
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

//MARK: - extention for alert

extension TextTranslateController: AlertLanguageRecognizerDelegate {
    func okDismiss() {
        alertView.isHidden = true
    }
    //MARK: - alert
}





