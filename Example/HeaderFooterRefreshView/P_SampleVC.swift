//
//  P_SampleVC.swift
//  ScrollView_RefreshView
//
//  Created by Vadim Zhydenko on 04.03.2020.
//  Copyright © 2020 Vadim Zhydenko. All rights reserved.
//

import UIKit
import HeaderFooterRefreshView

protocol P_SampleVC: UIViewController {
    
    init(headerConfig: @escaping (UIScrollView) -> (RefreshView), footerConfig: @escaping (UIScrollView) -> (RefreshView))
    
}
