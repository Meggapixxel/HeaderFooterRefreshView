//
//  CollectionViewSampleVC.swift
//  ScrollView_RefreshView
//
//  Created by Vadim Zhydenko on 04.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import UIKit
import HeaderFooterRefreshView

class CollectionViewSampleVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, P_SampleVC {
    
    private let headerConfig: (UIScrollView) -> (RefreshView)
    private let footerConfig: (UIScrollView) -> (RefreshView)
    
    required init(headerConfig: @escaping (UIScrollView) -> (RefreshView), footerConfig: @escaping (UIScrollView) -> (RefreshView)) {
        self.headerConfig = headerConfig
        self.footerConfig = footerConfig
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var headerView = headerConfig(collectionView)
    private lazy var footerView = footerConfig(collectionView)
    private var testData = [0: 20]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }
        
        headerView.addTarget(self, action: #selector(headerRefresh), for: .valueChanged)
        footerView.addTarget(self, action: #selector(footerRefresh), for: .valueChanged)
        
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    @objc private func headerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.headerView.endRefreshing {
                self.testData = [0: 20]
                self.collectionView.reloadData()
            }
        }
    }

    @objc private func footerRefresh() {
        let sectionToInsert = testData.count
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let completion: () -> () = {
                self.testData[sectionToInsert] = Int.random(in: 20...50)
                self.collectionView.insertSections(IndexSet(integer: sectionToInsert))
            }
            if sectionToInsert == 4 {
                self.footerView.endRefreshingWithNoMoreData(completion)
            } else {
                self.footerView.endRefreshing(completion)
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        testData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        testData[section] ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.label.text = indexPath.description
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width / 2
        return CGSize(width: size, height: size)
    }
    
    class Cell: UICollectionViewCell {
        
        let label = UILabel()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupSubviews()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupSubviews()
        }
        
        private func setupSubviews() {
            
            if #available(iOS 13.0, *) {
                backgroundColor = .systemBackground
            } else {
                backgroundColor = .white
            }
            
            label.textAlignment = .center
            
            contentView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        }
        
    }
    
}
