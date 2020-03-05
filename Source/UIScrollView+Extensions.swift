import UIKit

public protocol P_ScrollViewHeaderFooter: NSObject {
 
    func setManualControl(height: CGFloat) -> RefreshView
    
    func setAutoControl(height: CGFloat) -> RefreshView
    
}
extension P_ScrollViewHeaderFooter {
    
    public func setManualControl(height: CGFloat = 44) -> RefreshView {
        setManualControl(height: height)
    }
    
    public func setAutoControl(height: CGFloat = 44) -> RefreshView {
        setAutoControl(height: height)
    }
    
}


class ScrollViewHeader<Base: UIScrollView>: NSObject, P_ScrollViewHeaderFooter {

    private let base: Base
    
    init(base: Base) {
        self.base = base
    }
    
    func setManualControl(height: CGFloat = 44) -> RefreshView {
        let view = ManualHeaderView(height: height)
        base.insertSubview(view, at: 0)
        return view
    }
    
    func setAutoControl(height: CGFloat = 44) -> RefreshView {
        let view = AutoHeaderView(height: height)
        base.insertSubview(view, at: 0)
        return view
    }
    
}

class ScrollViewFooter<Base: UIScrollView>: NSObject, P_ScrollViewHeaderFooter {
    
    private let base: Base
    
    init(base: Base) {
        self.base = base
    }
    
    func setManualControl(height: CGFloat = 44) -> RefreshView {
        let view = ManualFooterView(height: height)
        base.insertSubview(view, at: 0)
        return view
    }
    
    func setAutoControl(height: CGFloat = 44) -> RefreshView {
        let view = AutoFooterView(height: height)
        base.insertSubview(view, at: 0)
        return view
    }
    
}


public protocol CustomIndicatorCompatible: UIScrollView { }
extension UIScrollView: CustomIndicatorCompatible { }
extension CustomIndicatorCompatible {
    
    public var header: P_ScrollViewHeaderFooter { ScrollViewHeader(base: self) }
    
    public var footer: P_ScrollViewHeaderFooter { ScrollViewFooter(base: self) }
    
}


//import RxSwift
//import RxCocoa
//extension Reactive where Base: RefreshView {
//
//    var isRefreshing: Binder<Bool> {
//        Binder(self.base) { refreshView, isRefereshing in
//            if isRefereshing {
//                refreshView.beginRefreshing()
//            } else {
//                refreshView.endRefreshing()
//            }
//        }
//    }
//
//}
