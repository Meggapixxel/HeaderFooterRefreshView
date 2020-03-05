//
//  SelectionVC.swift
//  ScrollView_RefreshView
//
//  Created by Vadim Zhydenko on 27.02.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import UIKit
import HeaderFooterRefreshView

class SelectionVC: UITableViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "UITableView"
        case 1: return "UICollectionView"
        case 2: return "UIScrollView"
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        switch indexPath.row {
        case 0:
            cell.leftLabel.text = "H: Manual"
            cell.rightLabel.text = "Manual :F"
        case 1:
            cell.leftLabel.text = "H: Manual"
            cell.rightLabel.text = "Auto :F"
        case 2:
            cell.leftLabel.text = "H: Auto"
            cell.rightLabel.text = "Manual :F"
        case 3:
            cell.leftLabel.text = "H: Auto"
            cell.rightLabel.text = "Auto :F"
        default: fatalError()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let typeVC = typeSampleVC(section: indexPath.section)
        let vc = configSampleVC(row: indexPath.row, typeVC: typeVC)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private class Cell: UITableViewCell {
        
        let leftLabel = UILabel()
        let rightLabel = UILabel()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupSubviews()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupSubviews()
        }
        
        private func setupSubviews() {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            
            contentView.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            
            stackView.addArrangedSubview(leftLabel)
            stackView.addArrangedSubview(rightLabel)
        }
        
    }
    
}

private extension SelectionVC {
    
    func headerControl(_ scrollView: UIScrollView) -> RefreshView {
        scrollView.header.setManualControl()
    }
    
    func headerAutoControl(_ scrollView: UIScrollView) -> RefreshView {
        scrollView.header.setAutoControl()
    }
    
    func footerControl(_ scrollView: UIScrollView) -> RefreshView {
        scrollView.footer.setManualControl()
    }
    
    func footerAutoControl(_ scrollView: UIScrollView) -> RefreshView {
        scrollView.footer.setAutoControl()
    }
    
    func typeSampleVC(section: Int) -> P_SampleVC.Type {
        switch section {
        case 0: return TableViewSampleVC.self
        case 1: return CollectionViewSampleVC.self
        case 2: return ScrollViewSampleVC.self
        default: fatalError()
        }
    }
    
    func configSampleVC(row: Int, typeVC: P_SampleVC.Type) -> P_SampleVC {
        switch row {
        case 0: return typeVC.init(headerConfig: headerControl, footerConfig: footerControl)
        case 1: return typeVC.init(headerConfig: headerControl, footerConfig: footerAutoControl)
        case 2: return typeVC.init(headerConfig: headerAutoControl, footerConfig: footerControl )
        case 3: return typeVC.init(headerConfig: headerAutoControl, footerConfig: footerAutoControl)
        default: fatalError()
        }
    }
    
}
