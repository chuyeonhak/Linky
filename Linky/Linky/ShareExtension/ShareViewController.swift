//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by chuchu on 2023/08/01.
//  Copyright © 2023 com.chuchu. All rights reserved.
//

import UIKit
import LinkPresentation
import UniformTypeIdentifiers

import Core
import Features

import SnapKit
import Then
import RxSwift
import RxCocoa


class ShareViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let viewModel = AddLinkDetailViewModel()
    
    var metaData: MetaData!
    
    let headerView = UIView().then {
        $0.backgroundColor = .code8
    }
    
    let closeButton = UIButton().then {
        $0.setImage(UIImage(named: "icoXmark"), for: .normal)
    }
    
    let titleLabel = UILabel().then {
        $0.text = "링크 추가"
        $0.textColor = .code1
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 18)
    }
    
    let completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.main, for: .normal)
        $0.titleLabel?.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
    }
    
    lazy var addLinkDetailView = AddLinkDetailView(viewModel: viewModel,
                                                   metaData: MetaData(url: ""),
                                                   link: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
        findExtensionItemUrl()
        checkAuth()
    }
    
    private func commonInit() {
        addComponent()
        setConstraints()
        bind()
    }
    
    private func addComponent() {
        [headerView, addLinkDetailView].forEach(view.addSubview)
        
        [closeButton,
         titleLabel,
         completeButton].forEach(headerView.addSubview)
    }
    
    private func setConstraints() {
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
        
        addLinkDetailView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(12)
            $0.size.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(20)
            $0.centerX.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(45)
            $0.height.equalTo(36)
        }
    }
    
    private func bind() {
        viewModel.output?.deleteIndexPath
            .drive { [weak self] in self?.openDeleteAlert(indexPath: $0) }
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .bind { [weak self] _ in self?.saveLink() }
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .bind { [weak self] _ in self?.cancleRequest() }
            .disposed(by: disposeBag)
    }
    
    private func saveLink() {
        hasTagText()
        saveLink(metaData: metaData)
        cancleRequest()
    }
    
    private func cancleRequest() {
        extensionContext?.completeRequest(returningItems: nil)
    }
    
    private func findExtensionItemUrl() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = item.attachments else { return }
        
        for provider in attachments {
            checkProvider(provider: provider, type: .url)
            checkProvider(provider: provider, type: .plainText)
        }
    }
    
    private func checkProvider(provider: NSItemProvider?, type: UTType) {
        guard provider?.hasItemConformingToTypeIdentifier(type.identifier) != nil else { return }
        
        provider?.loadItem(forTypeIdentifier: type.identifier) { [weak self] object, error in
            if let url = object as? URL {
                self?.searchUrl(url: url)
            } else if let objectString = object as? String,
                      let urlString = self?.extractURLUsingURLComponents(from: objectString),
                      let url = URL(string: urlString) {
                self?.searchUrl(url: url)
            }
        }
    }
    
    private func extractURLUsingURLComponents(from text: String) -> String? {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        
        for word in words {
            if let url = URL(string: word), url.scheme != nil {
                return url.absoluteString
            }
        }
        
        return nil
    }
    
    private func searchUrl(url: URL) {
        DispatchQueue.main.async {
            self.getOpenGraph(url: url) { data in
                self.metaData = data
                self.addLinkDetailView.configMetaData(metaData: data)
                IndicatorManager.shared.stopAnimation()
            }
        }
    }
    
    private func hasTagText() {
        guard addLinkDetailView.tagLineTextField.text?.isEmpty == false else { return }
        
        addLinkDetailView.addTagList()
    }
    
    private func saveLink(metaData: MetaData) {
        var link = Link(url: metaData.url)
        var linkList = UserDefaultsManager.shared.linkList
        let tagList = zip(addLinkDetailView.selectedItems, UserDefaultsManager.shared.tagList)
            .filter(\.0)
            .map(\.1)
        
        link.linkMemo = addLinkDetailView.linkLineTextField.text ?? ""
        link.tagList = tagList
        link.content = metaData
        
        linkList.append(link)
        
        UserDefaultsManager.shared.linkList = linkList
    }
    
    private func getOpenGraph(url: URL,
                              completion: ((MetaData) -> Void)?) {
        IndicatorManager.shared.startAnimation(superView: view)
        
        let metadataProvider = LPMetadataProvider()
        
        metadataProvider.startFetchingMetadata(for: url) { data, error in
            if error != nil { completion?(MetaData(url: url.absoluteString)) }
            
            let noImageMetaData = MetaData(url: url.absoluteString,
                                           title: data?.title,
                                           subtitle: nil,
                                           imageData: nil)
            
            guard let imageProvider = data?.imageProvider else {
                completion?(noImageMetaData)
                return
            }
            
            imageProvider.loadObject(ofClass: UIImage.self) { image, error in
                if error != nil {
                    completion?(noImageMetaData)
                    return
                }
                
                guard let metaImage = image as? UIImage else {
                    completion?(noImageMetaData)
                    return
                }
                
                let metaData = MetaData(url: url.absoluteString,
                                        title: data?.title,
                                        imageData: metaImage.pngData())
                
                completion?(metaData)
            }
        }
    }
    
    private func openDeleteAlert(indexPath: IndexPath) {
        let tag = UserDefaultsManager.shared.tagList[safe: indexPath.row]
        let title = "\"\(tag?.title ?? "")\" 태그를 삭제할까요?"
        let message = "연결된 모든 링크에서 태그가 삭제됩니다."
        presentAlertController(
            title: title,
            message: message,
            options: (title: "취소", style: .default), (title: "삭제", style: .destructive)) {
                if $0 == "삭제" {
                    self.deleteTag(indexPath: indexPath)
                    UserDefaultsManager.shared.deleteTagInLink(tag: tag)
                }
            }
    }
    
    private func deleteTag(indexPath: IndexPath) {
        var tagList = UserDefaultsManager.shared.tagList
        
        addLinkDetailView.selectedItems.remove(at: indexPath.row)
        tagList.remove(at: indexPath.row)
        UserDefaultsManager.shared.tagList = tagList
        
        addLinkDetailView.tagCollectionView.deleteItems(at: [indexPath])
        addLinkDetailView.setCollectionViewHeight(isDeleted: true)
    }
    
    private func checkAuth() {
        if UserDefaultsManager.shared.usePassword {
            let lockScreenVc = LockScreenViewController(type: .normal)

            lockScreenVc.modalPresentationStyle = .overFullScreen

            self.present(lockScreenVc, animated: false)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if UserDefaultsManager.shared.useBiometricsAuth {
                    lockScreenVc.auth.execute()
                }
            }
        }
    }
}
