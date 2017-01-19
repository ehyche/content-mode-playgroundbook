/*:
 
 # Live View in LiveView.swift

 In this example, we put ContentModeViewController in LiveView.swift, which makes it run in a separate process.

 */

import UIKit
import PlaygroundSupport

class ContentModeViewControllerProxy : NSObject {

    var imageContentMode: UIViewContentMode = .scaleAspectFit {
        didSet {
            sendContentMode()
        }
    }

    var imageName: String = "tall.jpg" {
        didSet {
            sendImageName()
        }
    }

    var imageClips: Bool = false {
        didSet {
            sendImageClips()
        }
    }

    private func sendMessageToProxy(messageValue: PlaygroundValue) {
        if let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy {
            proxy.send(messageValue)
        }
    }

    private func sendContentMode() {
        let contentModeValue = PlaygroundValue.integer(imageContentMode.rawValue)
        let contentModeDictionary = ["contentMode": contentModeValue]
        let contentModePlaygroundValue = PlaygroundValue.dictionary(contentModeDictionary)
        sendMessageToProxy(messageValue: contentModePlaygroundValue)
    }

    private func sendImageName() {
        let contentModeValue = PlaygroundValue.string(imageName)
        let contentModeDictionary = ["imageName": contentModeValue]
        let contentModePlaygroundValue = PlaygroundValue.dictionary(contentModeDictionary)
        sendMessageToProxy(messageValue: contentModePlaygroundValue)
    }

    private func sendImageClips() {
        let contentModeValue = PlaygroundValue.boolean(imageClips)
        let contentModeDictionary = ["clips": contentModeValue]
        let contentModePlaygroundValue = PlaygroundValue.dictionary(contentModeDictionary)
        sendMessageToProxy(messageValue: contentModePlaygroundValue)
    }

}

let controllerProxy = ContentModeViewControllerProxy()

controllerProxy.imageName = /*#-editable-code*/"tall.jpg"/*#-end-editable-code*/

controllerProxy.imageContentMode = /*#-editable-code*/.scaleToFill/*#-end-editable-code*/

controllerProxy.imageClips = /*#-editable-code*/false/*#-end-editable-code*/

