import UIKit


public protocol P_ScrollViewHeaderFooter: NSObject {
 
    func setControl(height: CGFloat) -> RefreshView
    
    func setAutoControl(height: CGFloat) -> RefreshView
    
}
extension P_ScrollViewHeaderFooter {
    
    public func setControl(height: CGFloat = 44) -> RefreshView {
        setControl(height: height)
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
    
    func setControl(height: CGFloat = 44) -> RefreshView {
        let view = HeaderView(height: height)
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
    
    func setControl(height: CGFloat = 44) -> RefreshView {
        let view = FooterView(height: height)
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
