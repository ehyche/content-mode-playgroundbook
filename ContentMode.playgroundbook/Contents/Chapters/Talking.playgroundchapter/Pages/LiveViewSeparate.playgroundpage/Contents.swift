/*:
 
 # Live View in LiveView.swift

 In this example, we put ContentModeViewController in LiveView.swift, which makes it run in a separate process.

 */

import PlaygroundSupport

func say(_ message: String) {
    let page = PlaygroundPage.current
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy {
        proxy.send(.string(message))
    }
}

say(/*#-editable-code */"<#Knock, knock!#>"/*#-end-editable-code*/)
