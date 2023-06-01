//
//  TestViewController.swift
//  Features
//
//  Created by chuchu on 2023/05/17.
//

import UIKit
import Core

import RxSwift


final class TestViewController: UIViewController {
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
        self.view.backgroundColor = .main
        
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

extension TestViewController: UISearchBarDelegate {
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

extension TestViewController: UITableViewDelegate {
    
}

extension TestViewController: UITableViewDataSource {
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

private extension TestViewController {
    
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
        leftButton.setTitleColor(.code3, for: .normal)
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
