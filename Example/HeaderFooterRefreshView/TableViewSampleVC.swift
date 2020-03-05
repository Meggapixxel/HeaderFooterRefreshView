//
//  TableViewSampleVC.swift
//  ScrollView_RefreshView
//
//  Created by Vadim Zhydenko on 04.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import UIKit
import HeaderFooterRefreshView

class TableViewSampleVC: UITableViewController, P_SampleVC {

    private let headerConfig: (UIScrollView) -> (RefreshView)
    private let footerConfig: (UIScrollView) -> (RefreshView)
    
    required init(headerConfig: @escaping (UIScrollView) -> (RefreshView), footerConfig: @escaping (UIScrollView) -> (RefreshView)) {
        self.headerConfig = headerConfig
        self.footerConfig = footerConfig
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var headerView = headerConfig(tableView)
    private lazy var footerView = footerConfig(tableView)
    private var testData = [0: 20]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView.addTarget(self, action: #selector(headerRefresh), for: .valueChanged)
        footerView.addTarget(self, action: #selector(footerRefresh), for: .valueChanged)
    }
    
    @objc private func headerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.headerView.endRefreshing {
                self.testData = [0: 20]
                self.tableView.reloadData()
            }
        }
    }

    @objc private func footerRefresh() {
        let sectionToInsert = testData.count
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let completion: () -> () = {
                self.testData[sectionToInsert] = Int.random(in: 20...50)
                self.tableView.insertSections(IndexSet(integer: sectionToInsert), with: .automatic)
            }
            if sectionToInsert == 4 {
                self.footerView.endRefreshingWithNoMoreData(completion)
            } else {
                self.footerView.endRefreshing(completion)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        testData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        testData[section] ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = indexPath.description
        return cell
    }

}

