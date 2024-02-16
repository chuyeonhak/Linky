//
//  InquiryView.swift
//  Features
//
//  Created by chuchu on 11/7/23.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift
import Alamofire

final class InquiryView: UIView {
    let viewModel: InquiryViewModel!
    let disposeBag = DisposeBag()
    
    let categoryLabel = UILabel().then {
        $0.text = "카테고리"
        $0.textColor = .code3
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 13)
    }
    
    let categoryImageView = UIImageView(image: UIImage(named: "asterisk"))
    
    lazy var categorySelectButton = UIButton().then {
        $0.setTitle("문의 내용을 입력해 주세요.", for: .normal)
        $0.setTitleColor(.code4, for: .normal)
        $0.setImage(UIImage(named: "icoArrowBottom"), for: .normal)
        $0.titleLabel?.font = FontManager.shared.pretendard(weight: .medium, size: 16)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.contentHorizontalAlignment = .left
        $0.showsMenuAsPrimaryAction = true
        $0.menu = selectMenu()
    }
    
    let buttonLineView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let inquiryLabel = UILabel().then {
        $0.text = "문의내용"
        $0.textColor = .code3
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 13)
    }
    
    let inquiryImageView = UIImageView(image: UIImage(named: "asterisk"))
    
    let inquiryTextView = UITextView().then {
        $0.backgroundColor = .code7
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 16)
        $0.contentInset = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        $0.addCornerRadius(radius: 12)
        $0.addBorder(color: .clear)
        $0.addPlaceholder(text: "마음이 여린 개발자입니다.\n비속어는 개발자의 마음을 아프게 합니다.", color: .code4)
    }
    
    init(viewModel: InquiryViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addComponent()
        setConstraints()
        bind()
    }
    
    private func addComponent() {
        backgroundColor = .code8
        
        [categoryLabel,
         categoryImageView,
         categorySelectButton,
         buttonLineView,
         inquiryLabel,
         inquiryImageView,
         inquiryTextView].forEach(addSubview)
    }
    
    private func setConstraints() {
        categoryLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().inset(42)
        }
        
        categoryImageView.snp.makeConstraints {
            $0.top.equalTo(categoryLabel).inset(2)
            $0.leading.equalTo(categoryLabel.snp.trailing)
            $0.size.equalTo(7)
        }
        
        categorySelectButton.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(8)
            $0.leading.equalTo(categoryLabel)
            $0.trailing.equalToSuperview().inset(42)
            $0.height.equalTo(34)
        }
        
        buttonLineView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(categorySelectButton)
            $0.height.equalTo(1)
        }
        
        inquiryLabel.snp.makeConstraints {
            $0.top.equalTo(categorySelectButton.snp.bottom).offset(24)
            $0.leading.equalTo(categoryLabel)
        }
        
        inquiryImageView.snp.makeConstraints {
            $0.top.equalTo(inquiryLabel).inset(2)
            $0.leading.equalTo(inquiryLabel.snp.trailing)
            $0.size.equalTo(7)
        }
        
        inquiryTextView.snp.makeConstraints {
            $0.top.equalTo(inquiryLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(categorySelectButton)
            $0.height.equalTo(160)
        }
    }
    
    private func bind() {
        textViewBind()
        viewCocoaBind()
    }
    
    private func selectMenu() -> UIMenu {
        let children = [UIAction(title: InquiryViewModel.CategoryType.error.title,
                                 handler: { [weak self] _ in self?.selectCategory(.error) }),
                        UIAction(title: InquiryViewModel.CategoryType.want.title,
                                 handler: { [weak self] _ in self?.selectCategory(.want) }),
                        UIAction(title: InquiryViewModel.CategoryType.etc.title,
                                 handler: { [weak self] _ in self?.selectCategory(.etc) })]
        
        return UIMenu(options: .displayInline, children: children)
    }
    
    private func textViewBind() {
        guard let placeholder = inquiryTextView.placeholder else { return }
        
        inquiryTextView.rx.text
            .map { $0?.isEmpty == false }
            .bind(to: placeholder.rx.isHidden)
            .disposed(by: disposeBag)
        
        inquiryTextView.rx.text.orEmpty
            .bind(to: viewModel.input.inquiryDetails)
            .disposed(by: disposeBag)
    }
    
    private func viewCocoaBind() {
        let viewTapped = UITapGestureRecognizer()
        
        addGestureRecognizer(viewTapped)
        
        viewTapped.rx.event
            .asDriverOnErrorEmpty()
            .drive { [weak self] _ in self?.inquiryTextView.resignFirstResponder() }
            .disposed(by: disposeBag)
    }
    
    private func selectCategory(_ category: InquiryViewModel.CategoryType) {
        viewModel.input.categoryType.onNext(category)
    }
    
    func setCategoryTitle(category: InquiryViewModel.CategoryType) {
        let titleColor: UIColor? = category == .none ? .code4: .code2
        categorySelectButton.setTitle(category.title, for: .normal)
        categorySelectButton.setTitleColor(titleColor, for: .normal)
    }
}


public struct NetworkManager {
    static let shared = NetworkManager()
    @frozen
    enum API {
        case error(SlackMessageModel)
        case want(SlackMessageModel)
        case etc(SlackMessageModel)
        
        var urlString: String {
            switch self {
            case .error(_):
                "https://hooks.slack.com/services/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"
            case .want(_):
                "https://hooks.slack.com/services/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"
            case .etc(_):
                "https://hooks.slack.com/services/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"
            }
        }
        var url: URL { URL(string: urlString)! }
        
        var method: HTTPMethod {
            switch self {
            case .error(_), .want(_), .etc(_): .post
            }
        }
        
        var parameters: [String: Any] {
            switch self {
            case .error(let model), .want(let model), .etc(let model): model.json
            }
        }
        
        var encoder: ParameterEncoding {
            switch self {
            case .error(_), .want(_), .etc(_): JSONEncoding()
            }
        }
        
        var headers: HTTPHeaders { ["Content-Type": "application/json"] }
        
    }
    
    func request(api: API, completion: @escaping (AFDataResponse<Data?>) -> Void) {
        AF.request(api.url,
                   method: api.method,
                   parameters: api.parameters,
                   encoding: api.encoder,
                   headers: api.headers).response(completionHandler: completion)
    }
}
