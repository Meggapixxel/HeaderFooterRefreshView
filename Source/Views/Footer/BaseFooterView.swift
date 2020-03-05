//
//  BaseFooterView.swift
//  HeaderFooterRefreshView
//
//  Created by Vadim Zhydenko on 05.03.2020.
//

import UIKit

public class BaseFooterView: BaseIndicatorRefreshView {
    
    override func beginRefreshingAnimation(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = self.height + scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInsetBottom
        scrollView.contentInset.bottom += self.height
    }
    
    override func endRefreshingAnimation(_ scrollView: UIScrollView) {
        scrollView.contentInset.bottom -= self.height
    }
    
    override func estimatedFrame(in scrollView: UIScrollView) -> CGRect {
        CGRect(x: 0, y: scrollView.contentSize.height, width: scrollView.bounds.width, height: height)
    }
    
}
