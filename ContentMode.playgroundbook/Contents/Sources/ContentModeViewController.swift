
import UIKit
import PlaygroundSupport

public class ContentModeViewController: UIViewController, PlaygroundLiveViewSafeAreaContainer {

    public var imageContentMode: UIViewContentMode {
        didSet {
            imageView.contentMode = imageContentMode
            updateContentModeMessage(contentMode: imageContentMode)
            view.setNeedsLayout()
        }
    }
    public var imageName: String {
        didSet {
            imageView.image = UIImage(named: imageName)
            view.setNeedsLayout()
        }
    }
    public var imageClips: Bool {
        didSet {
            imageView.clipsToBounds = imageClips
            view.setNeedsLayout()
        }
    }

    public var imageView: UIImageView = UIImageView(frame: .zero)

    private(set) var containerView: UIView = UIView(frame: .zero)
    private(set) var sliderX: UISlider = UISlider(frame: .zero)
    private(set) var sliderY: UISlider = UISlider(frame: .zero)
    private(set) var widthNameLabel: UILabel = UILabel(frame: .zero)
    private(set) var widthValueLabel: UILabel = UILabel(frame: .zero)
    private(set) var heightNameLabel: UILabel = UILabel(frame: .zero)
    private(set) var heightValueLabel: UILabel = UILabel(frame: .zero)
    private(set) var messageLabel: UILabel = UILabel(frame: .zero)
    private let fontSize: CGFloat = 18.0
    private(set) var imageWidthConstraint = NSLayoutConstraint()
    private(set) var imageHeightConstraint = NSLayoutConstraint()
    private let initialImageSize = CGSize(width: 256.0, height: 256.0)
    private(set) var lastContainerViewSize: CGSize = .zero

    public init(mode: UIViewContentMode, name: String, clips: Bool) {
        self.imageContentMode = mode
        self.imageName = name
        self.imageClips = clips
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.lightGray
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 4.0

        sliderX.translatesAutoresizingMaskIntoConstraints = false
        sliderX.minimumValue = 0.0
        sliderX.maximumValue = 100.0
        sliderX.value = sliderX.maximumValue
        sliderX.addTarget(self, action: #selector(self.sliderXChanged), for: [.valueChanged])
        sliderY.translatesAutoresizingMaskIntoConstraints = false
        sliderY.minimumValue = 0.0
        sliderY.maximumValue = 100.0
        sliderY.value = sliderY.maximumValue
        sliderY.addTarget(self, action: #selector(self.sliderYChanged), for: [.valueChanged])

        widthNameLabel.textColor = UIColor.black
        widthNameLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        widthNameLabel.text = "Width"
        widthNameLabel.translatesAutoresizingMaskIntoConstraints = false

        widthValueLabel.textColor = UIColor.black
        widthValueLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        widthValueLabel.translatesAutoresizingMaskIntoConstraints = false
        widthValueLabel.textAlignment = .right
        widthValueLabel.text = "320.0"

        heightNameLabel.textColor = UIColor.black
        heightNameLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        heightNameLabel.text = "Height"
        heightNameLabel.translatesAutoresizingMaskIntoConstraints = false

        heightValueLabel.textColor = UIColor.black
        heightValueLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        heightValueLabel.translatesAutoresizingMaskIntoConstraints = false
        heightValueLabel.textAlignment = .right
        heightValueLabel.text = "240.0"

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = imageContentMode
        imageView.backgroundColor = UIColor.darkGray
        imageView.clipsToBounds = imageClips
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 2.0

        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        messageLabel.textColor = UIColor.black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 1
        updateContentModeMessage(contentMode: imageView.contentMode)

        view.addSubview(containerView)
        view.addSubview(sliderX)
        view.addSubview(sliderY)
        view.addSubview(widthNameLabel)
        view.addSubview(widthValueLabel)
        view.addSubview(heightNameLabel)
        view.addSubview(heightValueLabel)
        view.addSubview(imageView)
        view.addSubview(messageLabel)

        view.addLayoutGuide(self.liveViewSafeAreaGuide)

        // Set up contraints
        let views = ["container": containerView, "sliderX": sliderX, "sliderY": sliderY,
                     "widthName": widthNameLabel, "widthValue": widthValueLabel,
                     "heightName": heightNameLabel, "heightValue": heightValueLabel,
                     "image": imageView, "message": messageLabel]
        let metrics = ["margin": 40.0, "marginBottom": 20.0, "sliderGap": 10.0]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(margin)-[message]-(margin)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: metrics,
                                                           views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(margin)-[container]-(margin)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: metrics,
                                                           views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(margin)-[widthName]-(sliderGap)-[sliderX]-(sliderGap)-[widthValue]-(margin)-|",
                                                           options: [.alignAllCenterY],
                                                           metrics: metrics,
                                                           views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(margin)-[heightName(==widthName)]-(sliderGap)-[sliderY]-(sliderGap)-[heightValue(==widthValue)]-(margin)-|",
                                                           options: [.alignAllCenterY],
                                                           metrics: metrics,
                                                           views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[message]-(marginBottom)-[container]-(marginBottom)-[sliderX]-(marginBottom)-[sliderY]",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: metrics,
                                                           views: views))
        view.addConstraint(NSLayoutConstraint(item: imageView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: containerView,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: imageView,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: containerView,
                                              attribute: .centerY,
                                              multiplier: 1.0,
                                              constant: 0.0))

        // Set up the layout guides
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.liveViewSafeAreaGuide.leadingAnchor, constant: 0.0),
            containerView.trailingAnchor.constraint(equalTo: self.liveViewSafeAreaGuide.trailingAnchor, constant: 0.0),
            messageLabel.topAnchor.constraint(equalTo: self.liveViewSafeAreaGuide.topAnchor, constant: 10.0),
            sliderY.bottomAnchor.constraint(equalTo: self.liveViewSafeAreaGuide.bottomAnchor, constant: 10.0)
        ])

        imageWidthConstraint = NSLayoutConstraint(item: imageView,
                                                  attribute: .width,
                                                  relatedBy: .equal,
                                                  toItem: nil,
                                                  attribute: .notAnAttribute,
                                                  multiplier: 1.0,
                                                  constant: initialImageSize.width)
        imageView.addConstraint(imageWidthConstraint)

        imageHeightConstraint = NSLayoutConstraint(item: imageView,
                                                   attribute: .height,
                                                   relatedBy: .equal,
                                                   toItem: nil,
                                                   attribute: .notAnAttribute,
                                                   multiplier: 1.0,
                                                   constant: initialImageSize.height)
        imageView.addConstraint(imageHeightConstraint)


    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        NSLog("viewDidAppear(animated:\(animated))")

    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        NSLog("viewDidLayoutSubviews")

        let containerViewSize = containerView.frame.size
        if containerViewSize != lastContainerViewSize {
            containerViewSizeChanged(to: containerViewSize, from: lastContainerViewSize)
            lastContainerViewSize = containerViewSize
        }
    }

    @objc public func sliderXChanged() {
        updateWidth()
    }

    @objc public func sliderYChanged() {
        updateHeight()
    }

    public func updateWidth() {
        imageWidthConstraint.constant = CGFloat(sliderX.value)
        widthValueLabel.text = String(format: "%.1f", sliderX.value)
    }

    public func updateHeight() {
        imageHeightConstraint.constant = CGFloat(sliderY.value)
        heightValueLabel.text = String(format: "%.1f", sliderY.value)
    }

    public func containerViewSizeChanged(to newSize: CGSize, from oldSize: CGSize) {

        // Compute scale values in range [0.0,1.0]
        let currentScaleX = sliderX.value / sliderX.maximumValue
        let currentScaleY = sliderY.value / sliderY.maximumValue
        // Now assign new maximums
        sliderX.maximumValue = Float(newSize.width)
        sliderY.maximumValue = Float(newSize.height)
        // Recompute the values based on the next maximum
        sliderX.value = currentScaleX * sliderX.maximumValue
        sliderY.value = currentScaleY * sliderY.maximumValue

        updateWidth()
        updateHeight()
    }

    public func updateContentModeMessage(contentMode: UIViewContentMode) {
        let contentModeStr = stringForContentMode(mode: contentMode)
        let message = "contentMode = \(contentModeStr)"
        messageLabel.text = message
    }

    public func updateMessage(message: String) {
        messageLabel.text = message
    }

    public func handleMessage(dictionary: [String: PlaygroundValue]) {
        if case let .integer(number)? = dictionary["contentMode"] {
            if let newContentMode = UIViewContentMode(rawValue: number) {
                self.imageContentMode = newContentMode
            }
        }
        if case let .string(text)? = dictionary["imageName"] {
            self.imageName = text
        }
    }

    public func stringForContentMode(mode: UIViewContentMode) -> String {
        var str = ""

        switch mode {
            case .scaleToFill:
                str = "scaleToFill"
            case .scaleAspectFit:
                str = "scaleAspectFit"
            case .scaleAspectFill:
                str = "scaleAspectFill"
            case .redraw:
                str = "redraw"
            case .center:
                str = "center"
            case .top:
                str = "top"
            case .bottom:
                str = "bottom"
            case .left:
                str = "left"
            case .right:
                str = "right"
            case .topLeft:
                str = "topLeft"
            case .topRight:
                str = "topRight"
            case .bottomLeft:
                str = "bottomLeft"
            case .bottomRight:
                str = "bottomRight"
        }

        return str
    }


}

extension ContentModeViewController: PlaygroundLiveViewMessageHandler {

    public func liveViewMessageConnectionOpened() {
//        NSLog("liveViewMessageConnectionOpened()")
    }

    public func liveViewMessageConnectionClosed() {
//        NSLog("liveViewMessageConnectionClosed()")
    }

    public func receive(_ message: PlaygroundValue) {
//        NSLog("receive(message: \(message))")

        switch message {
            case let .array(theArray):
                updateMessage(message: "You sent me the array \(theArray)!")
            case let .boolean(boolean):
                updateMessage(message: "You sent me the boolean \(boolean)!")
            case let .data(theData):
                updateMessage(message: "You sent me the data \(theData)!")
            case let .date(date):
                updateMessage(message: "You sent me the date \(date)")
            case let .dictionary(dictionary):
                handleMessage(dictionary: dictionary)
            case let .floatingPoint(number):
                updateMessage(message: "You sent me the floatingPoint \(number)!")
            case let .integer(number):
                updateMessage(message: "You sent me the integer \(number)!")
            case let .string(text):
                updateMessage(message: "You sent me the string \(text)!")
        }
    }
}

