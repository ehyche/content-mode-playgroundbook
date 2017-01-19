/*:
 # Live View in Contents.swift
 
 In this page, we access the ContentModeViewController directly in the same process as Contents.swift. The big advantage of doing it this way is that we can access ContentModeViewController directly.access
 
 Try setting the "mode" variable below, and notice the autocomplete choices.
 
 Then try setting the image name to either "tall.jpg", "square.jpg", or "wide.jpg"
 
 Then set clips to either true or false (and again, note the autocomplete choices)

 */

import UIKit
import PlaygroundSupport

// Now set the .contentMode
let mode: UIViewContentMode = /*#-editable-code*/.scaleToFill/*#-end-editable-code*/

// Now set the imageView
let name: String = /*#-editable-code*/"tall.jpg"/*#-end-editable-code*/

// Now set whether the image clips or not
let clips: Bool = /*#-editable-code*/false/*#-end-editable-code*/

// Create the ContentModeViewController
let controller = ContentModeViewController(mode: mode, name: name, clips: clips)

// Set it into the liveView of the current page
PlaygroundPage.current.liveView = controller

