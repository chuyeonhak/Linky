//
//  Features.swift
//  Home
//
//  Created by chuchu on 2023/04/25.
//

import UIKit

import Core

import Then
import SnapKit
import RxSwift
import RxCocoa


public final class RootViewController: UITabBarController {
    let firstVc = UINavigationController(rootViewController: TimelineViewController())
    
    var customTabBar: CustomTabBar!
//    let customTabBar = CustomTabBar()
    public override func viewDidLoad() {
        super.viewDidLoad()

//        let secondVc = TestViewController()
//        let thirdVc = TestViewController()
        
//        secondVc.view.backgroundColor = .green
//        thirdVc.view.backgroundColor = .blue
        
        setViewControllers([
            firstVc,
//            secondVc,
//            thirdVc
        ], animated: false)
        self.tabBar.isHidden = true
        commonInit()
    }
    
    private func commonInit() {
        
    }
    
    private func setTabbar() {
        self.customTabBar = CustomTabBar()
        view.addSubview(customTabBar)
        customTabBar.snp.makeConstraints {
            let bottomInset = UIApplication.shared.safeAreaInset.bottom
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(bottomInset + 78)
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        setTabbar()
    }
}

final class TimelineNavigationController: UINavigationController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationBar.barTintColor = .red
        self.navigationBar.isTranslucent = false
        
        let cancle = UIBarButtonItem(systemItem: .cancel)
        self.navigationItem.leftBarButtonItem = cancle
        navigationItem.title = "hello"
        print(#function)
        
        
    }
}

final class TimelineViewController: UIViewController {
    let testButton = UIButton().then {
        $0.backgroundColor = .red
    }
    
    lazy var listTableView = UITableView().then {
        $0.register(TestCell.self, forCellReuseIdentifier: TestCell.identifier)
        $0.delegate = self
        $0.dataSource = self
    }
    
    let baseArr: [String] = ["아이폰", "아이맥", "아이패드", "애플워치", "맥북", "맥프로"]
    
    lazy var targetArr: [String] = baseArr
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.barTintColor = .red
//        self.navigationController?.navigationBar.backgroundColor = .red
        configureNavigationButton()
        self.view.backgroundColor = UIColor(named: "MainColor")
        
        view.addSubview(testButton)
        view.addSubview(listTableView)
        
        testButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        listTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(testButton.snp.top)
        }
        
        testButton.rx.tap
            .bind { [weak self] in
                self?.naviTest()
            }
            .disposed(by: disposeBag)
    }
    
    private func naviTest() {
        let item = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(test))
        
        let leftIsEmpty = navigationItem.leftBarButtonItem == nil
        let label = UILabel().then {
            $0.text = "test"
        }
        
//        let testItem = UIBarButtonItem(customView: label)
        let testItem = makeLeftItem()
        self.navigationItem.leftBarButtonItem = leftIsEmpty ? testItem : nil
        print(testItem.customView!.frame)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "검색어를 입력해 주세요."
        self.navigationItem.searchController = leftIsEmpty ? searchController : nil
    }
}

extension TimelineViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        targetArr = searchText.isEmpty ? baseArr : baseArr.filter { $0.contains(searchText) }
        listTableView.reloadData()
        print("text", searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        targetArr = baseArr
        listTableView.reloadData()
    }
}

extension TimelineViewController: UITableViewDelegate {
    
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        targetArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TestCell.identifier,
            for: indexPath) as? TestCell else { return UITableViewCell() }
        
        cell.configure(model: targetArr[indexPath.row])
        
        return cell
    }
    
    
}

final class TestCell: UITableViewCell {
    static let identifier = description()
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        contentView.addSubview(label)
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bind() { }
    
    func configure(model: String) {
        label.text = model
    }
}

private extension TimelineViewController {
    
    func configureNavigationButton() {
//        navigationController?.navigationBar.isTranslucent = false
        let leftItem = makeLeftItem()
        let rightItem = makeRightItem()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func makeLeftItem() -> UIBarButtonItem {
        let leftButton = UIButton()
        
        leftButton.setImage(UIImage(named: "icoLogo"), for: .normal)
        leftButton.setTitle(" LINKY", for: .normal)
        leftButton.titleLabel?.font = FontManager.shared.pretendard(weight: .medium, size: 18)
        leftButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 6)
        
        leftButton.rx.tap
            .bind {
                print("wow")
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: leftButton)
    }
    
    @objc func leftTapped() {
        print("wow")
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton()
        
        rightButton.setImage(UIImage(named: "icoArrowBottom"), for: .normal)
        rightButton.setTitle("전체", for: .normal)
        rightButton.setTitleColor(.black, for: .normal)
        rightButton.titleLabel?.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
        rightButton.semanticContentAttribute = .forceRightToLeft
//        rightButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 6)
        
//        let rightView = UIView()
//
//        let downImageView = UIImageView(image: UIImage(named: "icoArrowBottom"))
//        let rightTitleLabel = UILabel().then {
//            $0.text = "전체"
//            $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
//        }
//
//        [downImageView, rightTitleLabel].forEach(rightView.addSubview(_:))
//
//        downImageView.snp.makeConstraints {
//            $0.trailing.equalToSuperview()
//            $0.centerY.equalToSuperview()
//            $0.size.equalTo(20)
//        }
//
//        rightTitleLabel.snp.makeConstraints {
//            $0.trailing.equalTo(downImageView.snp.leading)
//            $0.centerY.equalToSuperview()
//        }
//
//        let rightTapped = UITapGestureRecognizer()
//
//        rightView.addGestureRecognizer(rightTapped)
//
//        rightTapped.rx.event
//            .bind { _ in
//                print("wow")
//            }.disposed(by: disposeBag)
        
        rightButton.rx.tap
            .bind { print("rightButtonTapped") }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: rightButton)
    }
    
    @objc
    func test() {
        print("test")
    }
}


enum Features {
    case timeLine
    case tag
    case moreView
    case add
    
    var selectedIndex: Int {
        switch self {
        case .timeLine: return 0
        case .tag: return 1
        case .moreView: return 2
        case .add: return -1
        }
    }
}
