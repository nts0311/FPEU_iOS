//
//  SheetContentViewController.swift
//  CoreUIKit
//
//
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
//import CoreUtilsKit
public class SheetContentViewController: UIViewController {
    
    public private(set) var childViewController: UIViewController
    
    private var options: SheetOptions
    private (set) var size: CGFloat = 0
    private (set) var preferredHeight: CGFloat
    
    public var contentBackgroundColor: UIColor? {
        get { childContainerView.backgroundColor }
        set { childContainerView.backgroundColor = newValue }
    }
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            updateCornerRadius()
        }
    }
    
    public var gripSize: CGSize = CGSize(width: 50, height: 6) {
        didSet {
            gripSizeConstraints.forEach({ $0.isActive = false })
            Constraints(for: self.gripView) {
                gripSizeConstraints = $0.size.set(gripSize)
            }
            gripView.layer.cornerRadius = gripSize.height / 2
        }
    }
    
    public var gripColor: UIColor? {
        get { return gripView.backgroundColor }
        set { gripView.backgroundColor = newValue }
    }
    
    public var pullBarBackgroundColor: UIColor? {
        get { return pullBarView.backgroundColor }
        set { pullBarView.backgroundColor = newValue }
    }
    public var treatPullBarAsClear: Bool = VDSBottomSheetVC.treatPullBarAsClear {
        didSet {
            if isViewLoaded {
                updateCornerRadius()
            }
        }
    }
    
    weak var delegate: SheetContentViewDelegate?
    
    public var contentView = UIView()
    private var contentTopConstraint: NSLayoutConstraint?
    private var contentBottomConstraint: NSLayoutConstraint?
    private var navigationHeightConstraint: NSLayoutConstraint?
    private var gripSizeConstraints: [NSLayoutConstraint] = []
    public var childContainerView = UIView()
    public var pullBarView = UIView()
    public var gripView = UIView()
    
    public init(childViewController: UIViewController, options: SheetOptions) {
        self.options = options
        self.childViewController = childViewController
        self.preferredHeight = 0
        super.init(nibName: nil, bundle: nil)
        
        if options.setIntrensicHeightOnNavigationControllers, let navigationController = self.childViewController as? UINavigationController {
            navigationController.delegate = self
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentView()
        setupChildContainerView()
        setupPullBarView()
        setupChildViewController()
        updatePreferredHeight()
        updateCornerRadius()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.performWithoutAnimation {
            view.layoutIfNeeded()
        }
        updatePreferredHeight()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updatePreferredHeight()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateAfterLayout()
        if #available(iOS 11.0, *) {
        } else {
            if treatPullBarAsClear {
                childContainerView.layer.mask = HelperFunction.getTwoEdgesRoundCornerLayer(view: childContainerView, cornerRadius: cornerRadius)
            } else {
                contentView.layer.mask = HelperFunction.getTwoEdgesRoundCornerLayer(view: contentView, cornerRadius: cornerRadius)
            }
        }
    }
    
    func updateAfterLayout() {
        size = childViewController.view.bounds.height
        //updatePreferredHeight()
    }
    
    func adjustForKeyboard(height: CGFloat) {
        updateChildViewControllerBottomConstraint(adjustment: -height)
    }
    
    private func updateCornerRadius() {
        if #available(iOS 11.0, *) {
            contentView.layer.cornerRadius = treatPullBarAsClear ? 0 : cornerRadius
            childContainerView.layer.cornerRadius = treatPullBarAsClear ? cornerRadius : 0
        }
    }
    
    private func updateNavigationControllerHeight() {
        // UINavigationControllers don't set intrensic size, this is a workaround to fix that
        guard options.setIntrensicHeightOnNavigationControllers, let navigationController = childViewController as? UINavigationController else {
            return
        }
        navigationHeightConstraint?.isActive = false
        contentTopConstraint?.isActive = false
        
        if let viewController = navigationController.visibleViewController {
           let size = viewController.view.systemLayoutSizeFitting(CGSize(width: view.bounds.width, height: 0))
        
            if navigationHeightConstraint == nil {
                navigationHeightConstraint = navigationController.view.heightAnchor.constraint(equalToConstant: size.height)
            } else {
                navigationHeightConstraint?.constant = size.height
            }
        }
        navigationHeightConstraint?.isActive = true
        contentTopConstraint?.isActive = true
    }
    
    func updatePreferredHeight() {
        updateNavigationControllerHeight()
        let width = view.bounds.width > 0 ? view.bounds.width : UIScreen.main.bounds.width
        let oldPreferredHeight = preferredHeight
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = width
        
        contentTopConstraint?.isActive = false
        UIView.performWithoutAnimation {
            contentView.layoutSubviews()
        }
        
        preferredHeight = contentView.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow).height
        contentTopConstraint?.isActive = true
        UIView.performWithoutAnimation {
            contentView.layoutSubviews()
        }
        
        delegate?.preferredHeightChanged(oldHeight: oldPreferredHeight, newSize: preferredHeight)
    }
    
    private func updateChildViewControllerBottomConstraint(adjustment: CGFloat) {
        contentBottomConstraint?.constant = adjustment
    }
    
    private func setupChildViewController() {
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        childContainerView.addSubview(childViewController.view)
        Constraints(for: childViewController.view) { view in
            view.left.pinToSuperview()
            view.right.pinToSuperview()
            contentBottomConstraint = view.bottom.pinToSuperview()
                view.top.pinToSuperview()
        }
        if options.shouldExtendBackground, options.pullBarHeight > 0 {
            if #available(iOS 11.0, *) {
                childViewController.additionalSafeAreaInsets = UIEdgeInsets(top: options.pullBarHeight, left: 0, bottom: 0, right: 0)
            } else {
                // Fallback on earlier versions
            }
        }
        
        childViewController.didMove(toParent: self)
        
        childContainerView.layer.masksToBounds = true
        if #available(iOS 11.0, *) {
            childContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }

    private func setupContentView() {
        view.addSubview(contentView)
        Constraints(for: contentView) {
            $0.left.pinToSuperview()
            $0.right.pinToSuperview()
            $0.bottom.pinToSuperview()
            contentTopConstraint = $0.top.pinToSuperview()
        }
        
        contentView.layer.masksToBounds = true
        if #available(iOS 11.0, *) {
            contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    private func setupChildContainerView() {
        contentView.addSubview(childContainerView)
        
        Constraints(for: childContainerView) { view in
            
            if options.shouldExtendBackground {
                view.top.pinToSuperview()
            } else {
                view.top.pinToSuperview(inset: options.pullBarHeight)
            }
            view.left.pinToSuperview()
            view.right.pinToSuperview()
            view.bottom.pinToSuperview()
        }
    }
    
    private func setupPullBarView() {
        // If they didn't specify pull bar options, they don't want a pull bar
        guard options.pullBarHeight > 0 else {
            return
        }
        let pullBarView = self.pullBarView
        pullBarView.isUserInteractionEnabled = true
        pullBarView.backgroundColor = pullBarBackgroundColor
        contentView.addSubview(pullBarView)
        Constraints(for: pullBarView) {
            $0.top.pinToSuperview()
            $0.left.pinToSuperview()
            $0.right.pinToSuperview()
            $0.height.set(options.pullBarHeight)
        }
        self.pullBarView = pullBarView
        
        let gripView = self.gripView
        gripView.backgroundColor = gripColor
        gripView.layer.cornerRadius = gripSize.height / 2
        gripView.layer.masksToBounds = true
        pullBarView.addSubview(gripView)
        gripSizeConstraints.forEach({ $0.isActive = false })
        Constraints(for: gripView) {
            $0.centerY.alignWithSuperview()
            $0.centerX.alignWithSuperview()
            gripSizeConstraints = $0.size.set(gripSize)
        }
        
        pullBarView.isAccessibilityElement = true
        pullBarView.accessibilityIdentifier = "pull-bar"
        // This will be overriden whenever the sizes property is changed on VDSBottomSheetVC
//        pullBarView.accessibilityLabel = Localize.dismissPresentation.localized
        pullBarView.accessibilityTraits = [.button]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pullBarTapped))
        pullBarView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func pullBarTapped(_ gesture: UITapGestureRecognizer) {
        delegate?.pullBarTapped()
    }
}

extension SheetContentViewController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.view.endEditing(true)
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationHeightConstraint?.isActive = true
        updatePreferredHeight()
    }
}

#endif // os(iOS) || os(tvOS) || os(watchOS)
