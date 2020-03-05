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
    
    fileprivate(set) var refreshingState = RefreshingState.idle {
        didSet {
            print(refreshingState.description)
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
            UIView.animate(withDuration: 0.3, animations: {
                animation()
            }, completion: { _ in
                completion()
            })
        }
    }
    
}

private extension UIScrollView {
    
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


public class BaseHeaderView: BaseIndicatorRefreshView {
    
    override func beginRefreshingAnimation(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = -height - scrollView.contentInsetTop
        scrollView.contentInset.top += height
    }
    
    override func endRefreshingAnimation(_ scrollView: UIScrollView) {
        scrollView.contentInset.top -= height
    }
    
    override func estimatedFrame(in scrollView: UIScrollView) -> CGRect {
        CGRect(x: 0, y: -height, width: scrollView.bounds.width, height: height)
    }
    
}
public class AutoHeaderView: BaseHeaderView {
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView) {
        guard !refreshingState.isRefreshing && refreshingState.canRefreshing else { return }
        let contentOffsetY = scrollView.contentOffset.y + scrollView.contentInsetTop
        guard contentOffsetY < 0 && -contentOffsetY >= height else { return }
        beginRefreshing()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !refreshingState.isRefreshing && refreshingState.canRefreshing else { return }
        let contentOffsetY = scrollView.contentOffset.y + scrollView.contentInsetTop
        guard contentOffsetY < 0 && -contentOffsetY >= height else { return }
        beginRefreshing()
    }
    
}
public class HeaderView: BaseHeaderView {
    
    private lazy var arrowLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 8))
        path.addLine(to: CGPoint(x: 0, y: -8))
        path.move(to: CGPoint(x: 0, y: 8))
        path.addLine(to: CGPoint(x: 5.66, y: 2.34))
        path.move(to: CGPoint(x: 0, y: 8))
        path.addLine(to: CGPoint(x: -5.66, y: 2.34))

        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.systemGray.cgColor
        layer.lineWidth = 2
        layer.lineCap = .round
        return layer
    }()
    
    override init(height: CGFloat) {
        super.init(height: height)
        layer.addSublayer(arrowLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        arrowLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView) {
        guard refreshingState.isNeedRefreshing && refreshingState.canRefreshing else { return }
        beginRefreshing()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard refreshingState.canBeginRefreshing else { return }
        let value = -(scrollView.contentOffset.y + scrollView.contentInsetTop) / height
        let newRefreshingState = RefreshingState.idleOrInteraction(validate: value)
        guard newRefreshingState != refreshingState else { return }
        refreshingState = newRefreshingState
        alpha = newRefreshingState.value
    }
    
    override func didUpdateState(_ isRefreshing: Bool) {
        super.didUpdateState(isRefreshing)
        arrowLayer.isHidden = isRefreshing
    }

    override func didUpdateProgress(_ progress: CGFloat) {
        let rotation = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
        arrowLayer.transform = progress == 1 ? rotation : CATransform3DIdentity
    }
    
}


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
public class AutoFooterView: BaseFooterView {
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView) {
        guard !refreshingState.isRefreshing,
            scrollView.contentSize.height > scrollView.bounds.height,
            scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInsetBottom
            else { return }
        beginRefreshing()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !refreshingState.isRefreshing,
            scrollView.contentSize.height > scrollView.bounds.height,
            scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInsetBottom
            else { return }
        beginRefreshing()
    }
    
}
public class FooterView: BaseFooterView {
    
    private lazy var arrowLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 8))
        path.addLine(to: CGPoint(x: 0, y: -8))
        path.move(to: CGPoint(x: 0, y: 8))
        path.addLine(to: CGPoint(x: 5.66, y: 2.34))
        path.move(to: CGPoint(x: 0, y: 8))
        path.addLine(to: CGPoint(x: -5.66, y: 2.34))

        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.systemGray.cgColor
        layer.lineWidth = 2
        layer.lineCap = .round
        return layer
    }()
    
    override init(height: CGFloat) {
        super.init(height: height)
        layer.addSublayer(arrowLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        arrowLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView) {
        guard refreshingState.isNeedRefreshing else { return }
        beginRefreshing()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard refreshingState.canBeginRefreshing else { return }
        guard scrollView.contentSize.height > scrollView.bounds.height else { return }
        let value = (scrollView.contentOffset.y + scrollView.bounds.height - scrollView.contentSize.height - scrollView.contentInsetBottom) / height
        let newRefreshingState = RefreshingState.idleOrInteraction(validate: value)
        guard newRefreshingState != refreshingState else { return }
        refreshingState = newRefreshingState
        alpha = newRefreshingState.value
    }
    
    override func didUpdateState(_ isRefreshing: Bool) {
        super.didUpdateState(isRefreshing)
        arrowLayer.isHidden = isRefreshing
    }

    override func didUpdateProgress(_ progress: CGFloat) {
        let rotation = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)
        arrowLayer.transform = progress == 1 ? CATransform3DIdentity : rotation
    }
    
}
