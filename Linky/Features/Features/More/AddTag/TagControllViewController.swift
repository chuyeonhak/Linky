//
//  TagControlViewController.swift
//  Features
//
//  Created by chuchu on 2023/06/16.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class TagControlViewController: UIViewController {
    var tagControllView: TagControlView!
    let disposeBag = DisposeBag()
    let type: TagManageType!
    var tagData: TagData?
    
    let vibrator = UINotificationFeedbackGenerator().then {
        $0.prepare()
    }
    
    init(type: TagManageType, tagData: TagData? = nil) {
        self.type = type
        self.tagData = tagData
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let tagControllView = TagControlView(type: type, tagData: tagData)
        
        self.tagControllView = tagControllView
        self.view = tagControllView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationButton()
        
        tagControllView.canComplete
            .distinctUntilChanged()
            .bind { [weak self] in self?.setRightButton(textIsEmpty: !$0) }
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationButton() {
        let rightItem = makeRightItem()
        
        navigationItem.rightBarButtonItem = rightItem
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton()
        
        rightButton.setTitle("완료", for: .normal)
        rightButton.setTitleColor(.code5, for: .normal)
        rightButton.titleLabel?.font = FontManager.shared.pretendard(weight: .medium, size: 14)
        
        rightButton.rx.tap
            .withLatestFrom(tagControllView.canComplete) { $1 }
            .filter { $0 }
            .withUnretainedOnly(self)
            .bind { $0.type == .edit ? $0.editTag(): $0.saveTag() }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: rightButton)
    }
    
    private func setRightButton(textIsEmpty: Bool) {
        let fontWeight: FontManager.Weight = textIsEmpty ? .medium : .semiBold
        let font = FontManager.shared.pretendard(weight: fontWeight, size: 14)
        let color: UIColor? = textIsEmpty ? .code5: .main
        let button = navigationItem.rightBarButtonItem?.customView as? UIButton
        
        button?.setTitleColor(color, for: .normal)
        button?.titleLabel?.font = font
    }
    
    private func saveTag() {
        guard let tagText = tagControllView.lineTextField.text,
        !tagText.isEmpty && tagText.count > 1 else { return }
        
        guard !UserDefaultsManager.shared.tagList.contains(where: { $0.title == tagText })
        else {
            sameTagError()
            return
        }
        
        let tag = TagData(title: tagText, creationDate: Date())
        var copyArr = UserDefaultsManager.shared.tagList
        
        copyArr.append(tag)
        UserDefaultsManager.shared.tagList = copyArr
        
        navigationController?.popViewController(animated: true)
    }
    
    private func editTag() {
        guard var tagData,
              let tagText = tagControllView.lineTextField.text,
              case let tagList = UserDefaultsManager.shared.tagList,
              let firstIndex = tagList.firstIndex(where: { $0.tagNo == tagData.tagNo }),
              tagList.indices ~= firstIndex
        else { return }
        
        guard !UserDefaultsManager.shared.tagList.contains(where: { $0.title == tagText })
        else {
            sameTagError()
            return
        }
        tagData.title = tagText
        
        UserDefaultsManager.shared.tagList[firstIndex] = tagData
        navigationController?.popViewController(animated: true)
    }
    
    private func sameTagError() {
        tagControllView.subtitleLabel.shakeAnimation()
        tagControllView.subtitleLabel.text = "동일한 이름의 태그가 있습니다."
        tagControllView.subtitleLabel.textColor = .error
        
        vibrator.notificationOccurred(.error)
    }
}

