//
//  TipViewController.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit
import LinkPresentation

import Core

import SnapKit
import Then
import RxSwift

final class TipViewController: UIViewController {
    var tipView: TipView!
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let tipView = TipView()
        
        self.tipView = tipView
        self.view = tipView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cocoaBind()
    }
    
    private func cocoaBind() {
        tipView.shareButton.rx.tap
            .bind { [weak self] in
                self?.shareExample()
            }
            .disposed(by: disposeBag)
    }
    
    private func shareExample() {
        let item = CustomActivityItem()
        let activityVC = UIActivityViewController(activityItems: [item],
                                                  applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = tipView.shareButton
        
        present(activityVC, animated: true)
    }
}

class CustomActivityItem: NSObject, UIActivityItemSource {
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        ""
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        
        metadata.title = "Linky"
        
        return metadata
    }
}
