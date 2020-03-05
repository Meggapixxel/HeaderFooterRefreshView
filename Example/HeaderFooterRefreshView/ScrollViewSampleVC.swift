//
//  ScrollViewSampleVC.swift
//  ScrollView_RefreshView
//
//  Created by Vadim Zhydenko on 04.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import UIKit
import HeaderFooterRefreshView

class ScrollViewSampleVC: UIViewController, P_SampleVC {
    
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
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private lazy var headerView = headerConfig(scrollView)
    private lazy var footerView = footerConfig(scrollView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        stackView.axis = .vertical
        
        headerView.addTarget(self, action: #selector(headerRefresh), for: .valueChanged)
        footerView.addTarget(self, action: #selector(footerRefresh), for: .valueChanged)
        
        insert(subviewsCount: 20)
    }
    
    private func insert(subviewsCount: Int) {
        for _ in 0..<subviewsCount {
            let label = ScrollViewSampleVC.createView()
            label.text = String(Int.random(in: 0...100))
            self.stackView.addArrangedSubview(label)
        }
    }
    
    @objc private func headerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.headerView.endRefreshing {
                self.stackView.arrangedSubviews.forEach { subview in
                    self.stackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
                self.insert(subviewsCount: 20)
            }
        }
    }

    @objc private func footerRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let completion: () -> () = {
                self.insert(subviewsCount: Int.random(in: 20...50))
            }
            if self.stackView.arrangedSubviews.count > 100 {
                self.footerView.endRefreshingWithNoMoreData(completion)
            } else {
                self.footerView.endRefreshing(completion)
            }
        }
    }
    
    private static func createView() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return label
    }
    
}
