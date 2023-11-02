//
//  SynchronizationGuideViewController.swift
//  Features
//
//  Created by chuchu on 2023/08/11.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class SynchronizationGuideViewController: UIViewController {
    var synchronizationGuideView: SynchronizationGuideView!
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let synchronizationGuideView = SynchronizationGuideView()
        
        self.synchronizationGuideView = synchronizationGuideView
        self.view = synchronizationGuideView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cocoaBind()
    }
    
    private func cocoaBind() {
    }
    
}
