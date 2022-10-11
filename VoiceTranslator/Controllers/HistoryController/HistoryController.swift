//
//  HistoryController.swift
//  VoiceTranslator
//
//  Created by apple on 17.09.2022.
//

import UIKit
import GoogleMobileAds


class HistoryController: UIViewController {
    //MARK: - Properties
    var historyArray = [TranslatedModel]()
    @IBOutlet weak var collectionView: UICollectionView!
    //pemiumView
    @IBOutlet weak var premiumView: UIView!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var ifHistoriIsEmpty: UILabel!
    @IBOutlet weak var premiunSwicher: UISwitch!
    
    @IBOutlet weak var bannerView: GADBannerView!
    //MARK: - Livecycle
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(HistoryCell.nib(), forCellWithReuseIdentifier: HistoryCell.identifier)
        collectionView.register(ReclamaHistoryCell.nib(), forCellWithReuseIdentifier: ReclamaHistoryCell.identifier)
        loadData()
        setingGesture()
        setingForSwicher()
        loadAds()
        collectionView.delegate = self
        collectionView.dataSource = self
        print("DEBAG: ", historyArray)
    }
    //MARK: - action
    @IBAction func mainTrushTapped(_ sender: Any) {
        print("Trush..tapped")
        StorageManager.shared.deleteAll()
        historyArray  = StorageManager.shared.load()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    @IBAction func beckButtonTaped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    //MARK: - helper func
    fileprivate func loadAds() {
        bannerView.rootViewController = self
        bannerView.adUnitID = Constants.shared.openKey
        bannerView.load(GADRequest())
    }
    private func setingGesture() {
        let premiumViewTap = UITapGestureRecognizer(target: self, action: #selector(handleToPremium))
        premiumView.isUserInteractionEnabled = true
        premiumView.addGestureRecognizer(premiumViewTap)
    }
    fileprivate func loadData() {
        historyArray = StorageManager.shared.load()
    }
    fileprivate func setingForSwicher() {
        premiunSwicher.isOn = false
        premiunSwicher.isUserInteractionEnabled = false
    }
    //MARK: selector func
    @objc private func handleToPremium() {
        let storybourd = Storyboards.premiumStoryboard
        let secondViewController = storybourd.instantiateViewController(withIdentifier: Controllers.premium) as! GetPremiumController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
}

extension HistoryController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if historyArray.count == 0 {
            ifHistoriIsEmpty.isHidden = false
        } else {
            ifHistoriIsEmpty.isHidden = true
        }
        return historyArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row == 1 {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReclamaHistoryCell.identifier, for: indexPath) as? ReclamaHistoryCell else { return UICollectionViewCell() }
//            return cell
//        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else { return UICollectionViewCell() }
        cell.delegate = self
        let historyItem = historyArray[indexPath.item]
        cell.configureCell(wit: historyItem)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 200)
    }
}

//MARK: - delete one items

extension HistoryController: HistoryCellDelegate {
    func deleteItem(cell: UICollectionViewCell) {
        guard let index = collectionView.indexPath(for: cell) else { return }
        StorageManager.shared.delete(at: index.item)
        historyArray = StorageManager.shared.load()
        collectionView.reloadData()
    }
    
    
}
