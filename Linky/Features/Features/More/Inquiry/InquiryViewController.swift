//
//  InquiryViewController.swift
//  Features
//
//  Created by chuchu on 11/7/23.
//

import UIKit
import PhotosUI

import Core

import SnapKit
import Then
import RxSwift
import RxRelay

final class InquiryViewController: UIViewController {
    var inquiryView: InquiryView!
    
    let viewModel = InquiryViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let inquiryView = InquiryView(viewModel: viewModel)
        
        self.inquiryView = inquiryView
        self.view = inquiryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configureNavigationButton()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .code8
        navigationController?.navigationBar.backgroundColor = .code8
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code8
    }
    
    private func bind() {
        viewModel.output?.canSubmit
            .map { $0 ? UIColor.main: UIColor.code5 }
            .drive(onNext: setRightButtonTitleColor)
            .disposed(by: disposeBag)
        
        viewModel.output?.currentCategory
            .drive(onNext: inquiryView.setCategoryTitle)
            .disposed(by: disposeBag)
        
        viewModel.output?.toastMessage
            .drive(onNext: UIApplication.shared.makeToast)
            .disposed(by: disposeBag)
        
        viewModel.output?.openSubmitAlert
            .drive(onNext: openSubmitAlert)
            .disposed(by: disposeBag)
        
        viewModel.output?.dismiss
            .drive { [weak self] _ in self?.navigationController?.popViewController(animated: true) }
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationButton() {
        let rightButton = makeRightItem()
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton().then {
            $0.setTitle(I18N.submit, for: .normal)
            $0.setTitleColor(.code5, for: .normal)
            $0.titleLabel?.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
        }
        
        rightButton.rx.tap
            .do(onNext: endEditing)
            .bind(to: viewModel.input.submitButtonTap)
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: rightButton)
    }
    
    private func setRightButtonTitleColor(color: UIColor?) {
        let rightButton = navigationItem.rightBarButtonItems?.first?.customView as? UIButton
        
        rightButton?.setTitleColor(color, for: .normal)
    }
    
    private func endEditing() {
        inquiryView.inquiryTextView.resignFirstResponder()
    }
    
    private func openSubmitAlert() {
        let title = I18N.submitAlertTitle
        presentAlertController(
            title: title,
            options: (title: I18N.cancel, style: .cancel), (title: I18N.submit, style: .default)) {
                if $0 == I18N.submit { self.viewModel.input.submitInquiry.onNext(()) }
            }
    }
}
