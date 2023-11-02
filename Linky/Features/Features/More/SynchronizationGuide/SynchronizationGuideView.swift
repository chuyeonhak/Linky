//
//  SynchronizationGuideView.swift
//  Features
//
//  Created by chuchu on 2023/08/11.
//

import UIKit
import CloudKit

import Core

import SnapKit
import Then
import RxSwift

final class SynchronizationGuideView: UIView {
    let disposeBag = DisposeBag()
    let buttonStackView = UIStackView().then {
        $0.distribution = .fillEqually
    }
    
    let saveButton = UIButton().then {
        $0.backgroundColor = .main
        $0.setTitle("저장하기", for: .normal)
    }
    
    let fetchButton = UIButton().then {
        $0.backgroundColor = .main
        $0.setTitle("가져오기", for: .normal)
    }
    
    let deleteButton = UIButton().then {
        $0.backgroundColor = .main
        $0.setTitle("삭제", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        backgroundColor = .code7
        
        addSubview(buttonStackView)
        
        [saveButton,
         fetchButton,
         deleteButton].forEach(buttonStackView.addArrangedSubview)
    }
    
    private func setConstraints() {
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bind() {
        saveButton.rx.tap
            .bind { [weak self] in self?.save() }
            .disposed(by: disposeBag)
        
        fetchButton.rx.tap
            .bind { [weak self] in self?.fetch() }
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind { [weak self] in self?.deleteAll() }
            .disposed(by: disposeBag)
    }
    
    private func save() {
        Task {
            do {
                try await saveAllLinks(UserDefaultsManager.shared.linkList)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func fetch() {
        CloudKitManager().fetchAll() { [weak self] result in
            switch result {
            case .success(let records):
                self?.fetchLink(records: records)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func deleteAll() {
        CloudKitManager().deleteAll()
    }
    
    private func saveLinkRecord(_ link: Link) async throws -> CKRecord {
        let record = try await link.linkToRecord()
        let result = try await CloudKitManager().save(record: record)
        return result
    }

    private func saveAllLinks(_ links: [Link]) async throws {
        try await withThrowingTaskGroup(of: CKRecord.self) { group in
            for link in links {
                group.addTask { [weak self] in
                    guard let self else { throw SomeError.selfIsNil }
                    return try await self.saveLinkRecord(link)
                }
            }
            
            for try await result in group {
                print("Saved: \(result)")
            }
        }
    }
    
    private func createLinkFromRecord(_ record: CKRecord) async throws -> Link? {
        return try await Link.createInstance(from: record)
    }

    private func createLinksFromRecords(_ records: [CKRecord]) async throws -> [Link] {
        var links: [Link] = []
        
        try await withThrowingTaskGroup(of: Link?.self) { group in
            for record in records {
                group.addTask { [weak self] in
                    guard let self else { throw SomeError.selfIsNil }
                    return try await self.createLinkFromRecord(record)
                }
            }
            
            for try await link in group {
                if let link = link {
                    links.append(link)
                }
            }
        }
        
        return links
    }
    
    private func fetchLink(records: [CKRecord]) {
        Task {
            do {
                let linkList = try await self.createLinksFromRecords(records),
                    sortedList = linkList.sorted { $0.createdAt < $1.createdAt }
                UserDefaultsManager.shared.linkList = sortedList
            }
        }
    }
}

extension SynchronizationGuideView {
    enum SomeError: Error {
        case selfIsNil
    }
}

