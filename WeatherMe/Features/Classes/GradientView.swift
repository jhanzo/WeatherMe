//
//  GradientView.swift
//  WeatherMe
//
//  Created by Jessy Hanzo on 05/04/2019.
//  Copyright © 2019 jho. All rights reserved.
//

import Foundation
import MessageUI

// Add a class for adding gradient view features
// @IBDesignable lets having @IBInspectable properties mapped with storyboard
// thus every update in storyboard concerning these properties will be automatically rendered
// In Storyboard when an UIView inherited from GradientView, two properties are available for top and bottom colors
// NB: don't forget to use clearColor for UIView backgroundColor if needed
@IBDesignable open class GradientView: UIView {
    //add this property to storyboard
    @IBInspectable open var topColor: UIColor? {
        didSet {
            configureView()
        }
    }
    //add this property to storyboard
    @IBInspectable open var bottomColor: UIColor? {
        didSet {
            configureView()
        }
    }

    override open class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureView()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    open override func tintColorDidChange() {
        super.tintColorDidChange()
        configureView()
    }

    func configureView() {
        let layer = self.layer as! CAGradientLayer//swiftlint:disable:this force_cast
        let locations = [ 0.0, 1.0 ]
        layer.locations = locations as [NSNumber]?
        let color1 = topColor ?? self.tintColor as UIColor
        let color2 = bottomColor ?? UIColor.black as UIColor
        let colors: [AnyObject] = [ color1.cgColor, color2.cgColor ]
        layer.colors = colors
    }
}
