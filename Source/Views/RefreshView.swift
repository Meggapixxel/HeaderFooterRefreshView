import UIKit

extension RefreshView {
    
    enum RefreshingState: Equatable {
        
        case inactive, idle, interaction(CGFloat), refreshing
        
        var value: CGFloat {
            switch self {
            case .inactive: return 0
            case .idle: return 0
            case .refreshing: return 1
            case .interaction(let value): return value
            }
        }
        
        var isRefreshing: Bool {
            switch self {
            case .refreshing: return true
            default: return false
            }
        }
        
        var canRefreshing: Bool {
            switch self {
            case .inactive: return false
            default: return true
            }
        }
        
        var canBeginRefreshing: Bool {
            switch self {
            case .idle, .interaction: return true
            default: return false
            }
        }
        
        var isNeedRefreshing: Bool {
            switch self {
            case .interaction(let value): return value == 1
            default: return false
            }
        }
        
        var description: String { String(reflecting: self) }
        
        static func idleOrInteraction(validate value: CGFloat) -> RefreshingState {
            let newValue = min(1, max(0, value))
            if newValue == 0 {
                return .idle
            } else {
                return .interaction(newValue)
            }
        }
        
        static func == (lhs: RefreshingState, rhs: RefreshingState) -> Bool {
            switch (lhs, rhs) {
            case (.inactive, .inactive): return true
            case (.idle, .idle): return true
            case (.refreshing, .refreshing): return true
            case (.interaction(let lhsValue), .interaction(let rhsValue)): return lhsValue == rhsValue
            default: return false
            }
        }
        
    }
    
}

public class RefreshView: UIControl {
    
    var refreshingState = RefreshingState.idle {
        didSet {
            switch refreshingState {
            case .inactive: break
            case .idle, .refreshing:
                didUpdateProgress(refreshingState.value)
                didUpdateState(refreshingState.isRefreshing)
            case .interaction(let value):
                didUpdateProgress(value)
            }
        }
    }
    
    let height: CGFloat
    
    
    var scrollView: UIScrollView? { superview as? UIScrollView }

    init(height: CGFloat) {
        self.height = height
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    func didUpdateState(_ isRefreshing: Bool) {
        fatalError("\(#function) has not been implemented")
    }

    func didUpdateProgress(_ progress: CGFloat) {
        fatalError("\(#function) has not been implemented")
    }
    
    func estimatedFrame(in scrollView: UIScrollView) -> CGRect {
        fatalError("\(#function) not implemented")
    }

    private var keyValueObservations: [NSKeyValueObservation]?

    override final public func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            clearObserver()
        } else {
            guard let scrollView = scrollView else { return }
            keyValueObservations = setupObserver(scrollView)
        }
    }

    override final public func willMove(toSuperview newSuperview: UIView?) {
        guard let scrollView = newSuperview as? UIScrollView else { return }
        keyValueObservations = setupObserver(scrollView)
    }

    private func setupObserver(_ scrollView: UIScrollView) -> [NSKeyValueObservation] {
        weak var weakSelf: RefreshView! = self
        
        let offsetToken = scrollView.observe(\.contentOffset) { scrollView, _ in
            weakSelf.scrollViewDidScroll(scrollView)
        }
        let stateToken = scrollView.observe(\.panGestureRecognizer.state) { scrollView, _ in
            guard scrollView.panGestureRecognizer.state == .ended else { return }
            weakSelf.scrollViewDidEndDragging(scrollView)
        }
        let sizeToken = scrollView.observe(\.contentSize) { scrollView, _ in
            weakSelf.frame = weakSelf.estimatedFrame(in: scrollView)
            weakSelf.alpha = weakSelf.refreshingState.value
        }
        return [offsetToken, stateToken, sizeToken]
    }

    private func clearObserver() {
        keyValueObservations?.forEach { $0.invalidate() }
        keyValueObservations = nil
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        fatalError("\(#function) has not been implemented")
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView) {
        fatalError("\(#function) has not been implemented")
    }

    
    final func beginRefreshing(_ completion: (() -> ())? = nil) {
        precondition(scrollView != nil, "RefreshView not added to view hierarchy")
        
        guard let scrollView = scrollView, !refreshingState.isRefreshing else { return }
        refreshingState = .refreshing
        animate(animation: {
            self.alpha = 1
            self.beginRefreshingAnimation(scrollView)
        }) {
            self.alpha = 1
            completion?()
            self.sendActions(for: .valueChanged)
        }
    }
    
    func beginRefreshingAnimation(_ scrollView: UIScrollView) {
        fatalError("\(#function) has not been implemented")
    }

    
    final public func endRefreshing(_ completion: (() -> ())? = nil) {
        guard let scrollView = scrollView, refreshingState.isRefreshing else { return completion?() ?? {}() }
        animate(animation: {
            self.alpha = 0
            self.endRefreshingAnimation(scrollView)
        }) {
            self.alpha = 0
            self.refreshingState = .idle
            completion?()
        }
    }
    
    final public func endRefreshingWithNoMoreData(_ completion: (() -> ())? = nil) {
        guard let scrollView = scrollView, refreshingState.isRefreshing else { return completion?() ?? {}() }
        animate(animation: {
            self.alpha = 0
            self.endRefreshingAnimation(scrollView)
        }) {
            self.alpha = 0
            self.refreshingState = .inactive
            completion?()
        }
    }
    
    func endRefreshingAnimation(_ scrollView: UIScrollView) {
        fatalError("\(#function) has not been implemented")
    }
    
    final func resetNoMoreData() {
        refreshingState = .idle
    }
    
}

private extension RefreshView {
    
    func animate(animation: @escaping () -> (), completion: @escaping () -> ()) {
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 0.3,
                animations: animation,
                completion: { _ in completion() }
            )
        }
    }
    
}

extension UIScrollView {
    
    var contentInsetTop: CGFloat {
        if #available(iOS 11.0, *) {
            return contentInset.top + adjustedContentInset.top
        } else {
            return contentInset.top
        }
    }

    var contentInsetBottom: CGFloat {
        if #available(iOS 11.0, *) {
            return contentInset.bottom + adjustedContentInset.bottom
        } else {
            return contentInset.bottom
        }
    }
    
}
