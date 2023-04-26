//
//  Features.swift
//  Home
//
//  Created by chuchu on 2023/04/25.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa
import Core


public final class RootViewController: UITabBarController {
    let firstVc = UINavigationController(rootViewController: TimelineViewController())
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
        fontCheck()
        
        commonInit()
    }
    
    private func commonInit() {
        
    }
    
    func fontCheck() {
        

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
        setNavigationBar()
        self.view.backgroundColor = .blue
        
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
        let testItem = UIBarButtonItem(customView: label)
        UIView.animate(withDuration: 0.3) {
            self.navigationItem.leftBarButtonItem = leftIsEmpty ? testItem : nil
//            self.navigationItem.leftBarButtonItem?.customView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            let testVC = UIViewController()
            testVC.view.backgroundColor = .black
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchBar.delegate = self
            searchController.searchBar.placeholder = "검색어를 입력해 주세요."
            self.navigationItem.searchController = leftIsEmpty ? searchController : nil
        }
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
    func setNavigationBar() {
        configureNavigationTitle()
        configureNavigationButton()
    }
    
    func configureNavigationTitle() {
        self.title = "태그"
    }
    
    func configureNavigationButton() {
        let item = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(test))
        self.navigationItem.leftBarButtonItem = item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = nil
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
