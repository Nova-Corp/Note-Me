//
//  ViewController.swift
//  Note-Me
//
//  Created by ADMIN on 03/07/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import UIKit

class TakeNotesViewController: UIViewController {

    @IBOutlet weak var saveButtonItem: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet weak var notesTitleTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var heightAnchorForSaveButton: NSLayoutConstraint!

    @IBOutlet weak var markerCollectionView: UICollectionView!

    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tagAndTimeHolderStackView: UIStackView!
    var optionsArray = [
        "Tag",
        "Date",
        "Time",
        "Export"
        ] {
        didSet {
            markerCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        notesTitleTextField.delegate = self
        notesTextView.delegate = self

        // Configure CollectionView
        markerCollectionView.delegate = self
        markerCollectionView.dataSource = self

        let markerCollectionViewCellNib = UINib(nibName: MarkerCollectionViewCell.identifier, bundle: nil)
        markerCollectionView.register(markerCollectionViewCellNib, forCellWithReuseIdentifier: MarkerCollectionViewCell.identifier)

        saveButtonItem.addTargetForAction(self, action: #selector(didTappedSaveButton))
        saveButton.addTarget(self, action: #selector(didTappedSaveButton), for: .touchUpInside)
    }
    @objc func didTappedSaveButton() {
        saveEveryIntervel()
    }
}

extension TakeNotesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        optionsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarkerCollectionViewCell.identifier,
                                                            for: indexPath) as? MarkerCollectionViewCell
            else { return UICollectionViewCell() }
        cell.buttonTitleLabel.text = optionsArray[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != optionsArray.count - 1 {
            optionsArray.remove(at: indexPath.item)
        }

    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemCount = CGFloat(optionsArray.count)
        let width = UIScreen.main.bounds.width - 24 - (10 * (itemCount - 1))
        return CGSize(width: width / itemCount, height: 40)
    }

}

extension TakeNotesViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        enableSaveButtonWithAnimation()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
//        enableSaveButtonWithAnimation()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        // Save every 30 seconds
//        saveEveryIntervel(on: 30)
    }

    func textViewDidChange(_ textView: UITextView) {
        enableSaveButtonWithAnimation()
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        enableSaveButtonWithAnimation()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // Save every 30 seconds
//        saveEveryIntervel(on: 30)
    }

    private func saveEveryIntervel(on second: Int = 0) {
        DispatchQueue.main.async {[weak self] in
            // Save to coredata

            self?.disableSaveButtonWithAnimation()
        }
    }

    private func enableSaveButtonWithAnimation() {

        UIView.animate(withDuration: 0.25) {[weak self] in
            self?.heightAnchorForSaveButton.constant = 56
            self?.saveButton.isHidden = false
            self?.saveButton.layoutIfNeeded()
        }
    }

    private func disableSaveButtonWithAnimation() {
        UIView.animate(withDuration: 0.25) {[weak self] in
            self?.heightAnchorForSaveButton.constant = 0
            self?.saveButton.isHidden = true
            self?.saveButton.layoutIfNeeded()
        }
    }
}

extension UIBarButtonItem {
    func addTargetForAction(_ target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
}
