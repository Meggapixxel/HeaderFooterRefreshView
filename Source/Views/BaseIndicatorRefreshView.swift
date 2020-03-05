//
//  BaseIndicatorRefreshView.swift
//  HeaderFooterRefreshView
//
//  Created by Vadim Zhydenko on 05.03.2020.
//

import UIKit

public class BaseIndicatorRefreshView: RefreshView {
    
    let indicator: UIActivityIndicatorView

    override init(height: CGFloat) {
        if #available(iOS 13, *) {
            self.indicator = UIActivityIndicatorView(style: .medium)
        } else {
            self.indicator = UIActivityIndicatorView(style: .whiteLarge)
        }
        super.init(height: height)
        addSubview(indicator)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        indicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

    override func didUpdateState(_ isRefreshing: Bool) {
        isRefreshing ? indicator.startAnimating() : indicator.stopAnimating()
    }
    
    override func didUpdateProgress(_ progress: CGFloat) {
        
    }
    
}
