//
//  TipViewController.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit

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
        let activityVC = UIActivityViewController(activityItems: [URL(string: "https://www.google.com/")!], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = tipView.shareButton
        
        present(activityVC, animated: true)
    }
}
