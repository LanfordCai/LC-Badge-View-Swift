//
//  LCBadgeView.swift
//  LCBadgeView
//
//  Created by Cai Linfeng on 12/24/15.
//  Copyright © 2015 GavinFlying. All rights reserved.
//

import UIKit

class LCBadgeView: UIView {

    enum BadgeShiftDirectionType {
        case Left
        case Justify
        case Right
    }

    // The badgeView's shift direction while text in it changed
    var shiftDirection: BadgeShiftDirectionType = .Left {
        didSet {
            setupBadgeFrame()
        }
    }

    enum BadgeTextOverflowType {
        case N, Points, Nines, NinesPlus

        func overflowTag(charCount: Int) -> String {
            switch self {
            case N:
                return "N"
            case Points:
                return "..."
            case Nines:
                var nines = ""
                for _ in 1..<charCount {
                    nines += "9"
                }
                return nines
            case NinesPlus:
                var ninesPlus = ""
                for _ in 1..<charCount {
                    ninesPlus += "9"
                }
                ninesPlus += "+"
                return ninesPlus
            }
        }
    }

    var overflowType: BadgeTextOverflowType = .NinesPlus {
        didSet {
            setupBadgeFrame()
        }
    }

    var text: String? {
        didSet {
            textLayer?.string = text
            hideBadgeWhenZero()
        }
    }

    var textColor: UIColor = UIColor.whiteColor() {
        didSet {
            textLayer?.foregroundColor = textColor.CGColor
        }
    }

    var font: UIFont = UIFont.systemFontOfSize(14) {

        didSet {
            if font.lineHeight > frame.height {
                print("Font lineheight larger than badgeView's height")
                font = oldValue
            }

            textLayer?.font = font.fontName
            textLayer?.fontSize = font.pointSize
        }
    }

    // The padding between text and border of badgeView is fontSize * paddingFactor
    var paddingFactor: CGFloat = 0.4 {
        didSet {
            setupBadgeFrame()
        }
    }

    var cornerRadius: CGFloat? {
        didSet {
            badgePath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius ?? bounds.height * 0.5)
            backgroundLayer?.path = badgePath!.CGPath
            borderLayer?.path = badgePath!.CGPath
        }
    }

    var badgeBackgroundColor: UIColor = UIColor.redColor() {
        didSet {
            backgroundLayer?.fillColor = badgeBackgroundColor.CGColor
        }
    }

    var borderColor: UIColor = UIColor.blackColor() {
        didSet {
            borderLayer?.strokeColor = borderColor.CGColor
        }
    }

    var borderWidth: CGFloat = 0.0 {
        didSet {
            borderLayer?.lineWidth = borderWidth
        }
    }

    var maxCharsCount: Int = 2

    var hideWhenZero = true

    private var textLayer: CATextLayer?
    private var backgroundLayer: CAShapeLayer?
    private var borderLayer: CAShapeLayer?
    private var badgePath: UIBezierPath?

    private var minWidth: CGFloat = 24.0

    private var anchorLeftX: CGFloat?
    private var anchorMiddleX: CGFloat?
    private var anchorRightX: CGFloat?


    // MARK: Life-Cycle Methods

    override func awakeFromNib() {
        super.awakeFromNib()
        configurations()
    }

    init(frame: CGRect, shiftDirection: BadgeShiftDirectionType, cornerRadius: CGFloat) {
        self.shiftDirection = shiftDirection
        super.init(frame: frame)
        configurations()
        self.cornerRadius = cornerRadius
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configurations()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupBadgeFrame()
    }


    // MARK: Private Methods

    private func configurations() {

        backgroundColor = UIColor.clearColor()
        userInteractionEnabled = false
        clipsToBounds = false

        // Create textLayer
        textLayer = CATextLayer()
        textLayer?.foregroundColor = textColor.CGColor
        textLayer?.font = font.fontName
        textLayer?.fontSize = font.pointSize ?? 14.0
        textLayer?.alignmentMode = kCAAlignmentCenter
        textLayer?.contentsScale = UIScreen.mainScreen().scale

        // Create backgroundLayer
        backgroundLayer = CAShapeLayer()
        backgroundLayer?.contentsScale = UIScreen.mainScreen().scale

        // Create boarderLyaer 
        borderLayer = CAShapeLayer()
        borderLayer?.strokeColor = borderColor.CGColor
        borderLayer?.fillColor = UIColor.clearColor().CGColor
        borderLayer?.lineWidth = borderWidth
        borderLayer?.contentsScale = UIScreen.mainScreen().scale

        layer.addSublayer(backgroundLayer!)
        layer.addSublayer(borderLayer!)
        layer.addSublayer(textLayer!)
    }

    private func setupBadgeFrame() {

        anchorLeftX = anchorLeftX ?? frame.origin.x
        anchorMiddleX = anchorMiddleX ?? frame.origin.x + 0.5 * bounds.width
        anchorRightX = anchorRightX ?? frame.origin.x + bounds.width

        minWidth = bounds.height != 0 ? bounds.height : 24.0

        if text?.characters.count > maxCharsCount {
            text = overflowType.overflowTag((text?.characters.count)!)
        }

        var tempFrame = frame
        let textWidth = sizeForText(text).width
        tempFrame.size.width = textWidth < minWidth ? minWidth : textWidth

        switch shiftDirection {
        case .Left:
            tempFrame.origin.x = anchorRightX! - tempFrame.size.width
        case .Justify:
            tempFrame.origin.x = anchorMiddleX! - tempFrame.size.width * 0.5
        case .Right:
            tempFrame.origin.x = anchorLeftX!
        }

        frame = tempFrame

        let textFrame = CGRect(x: 0, y: (bounds.height - font.lineHeight) * 0.5, width: bounds.width, height: font.lineHeight)
        textLayer?.frame = textFrame

        badgePath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius ?? bounds.height * 0.5)
        backgroundLayer?.frame = bounds
        backgroundLayer?.fillColor = badgeBackgroundColor.CGColor
        backgroundLayer?.path = badgePath!.CGPath

        borderLayer?.frame = bounds
        borderLayer?.path = badgePath!.CGPath
    }

    private func sizeForText(text: String?) -> CGSize {
        guard let text = text as NSString? else  {
            return CGSize(width: 0.0, height: 0.0)
        }

        let widthPadding: CGFloat = font.pointSize * paddingFactor
        let attrDict = [NSFontAttributeName: font]
        var textSize = text.sizeWithAttributes(attrDict)

        textSize.width += widthPadding * 2.0

        return textSize
    }

    private func hideBadgeWhenZero() {
        self.hidden = text == "0" && hideWhenZero
    }
}
