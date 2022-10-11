//
//  GetPremiumController.swift
//  VoiceTranslator
//
//  Created by apple on 15.09.2022.
//

import UIKit

class GetPremiumController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var closeImage: UIImageView!
    //MARK: - Live cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setingGesture()
    }
    //MARK: - helpers funcs
    private func setingGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        closeImage.isUserInteractionEnabled = true
        closeImage.addGestureRecognizer(tap)
    }
    //MARK: - selector func
    @objc private func handleTap() {
        print("DEBAG: close..")
        navigationController?.popToRootViewController(animated: true)
    }
    //MARK: - action button
    @IBAction func getPremiunTapped(_ sender: UIButton) {
        print("DEBAG: tap get premium...")
    }
}
