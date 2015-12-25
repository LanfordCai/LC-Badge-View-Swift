//
//  ViewController.swift
//  LCBadgeView
//
//  Created by Cai Linfeng on 12/24/15.
//  Copyright © 2015 GavinFlying. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var textField: UITextField!

    var badgeView: LCBadgeView!

    override func viewDidLoad() {
        super.viewDidLoad()

        badgeView = LCBadgeView(frame: CGRectMake(0, 0, 24, 24), shiftDirection: .Left, cornerRadius: 24 * 0.5)
        badgeView.center = CGPoint(x: testView.bounds.width, y: 0)
        badgeView.text = "1"
        testView.addSubview(badgeView)

        badgeView.font = UIFont.systemFontOfSize(15)
        badgeView.shiftDirection = .Left
        badgeView.textColor = UIColor.whiteColor()
        badgeView.badgeBackgroundColor = UIColor.redColor()
        badgeView.borderColor = UIColor.whiteColor()
        badgeView.borderWidth = 0.0
        badgeView.maxWidth = 100.0
        badgeView.paddingFactor = 0.5

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Font 有问题
    @IBAction func fontChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            badgeView.font = UIFont.systemFontOfSize(15)
        case 1:
            badgeView.font = UIFont.systemFontOfSize(20)
        default:
            badgeView.font = UIFont.boldSystemFontOfSize(15)
        }
    }

    @IBAction func cornerRadiusChanged(sender: UISlider) {
        badgeView.cornerRadius = badgeView.bounds.height * CGFloat(sender.value)
    }

    @IBAction func shiftDirectionChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            badgeView.shiftDirection = .Left
        case 1:
            badgeView.shiftDirection = .Justify
        default:
            badgeView.shiftDirection = .Right
        }
    }

    @IBAction func textColorChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            badgeView.textColor = UIColor.whiteColor()
        case 1:
            badgeView.textColor = UIColor.greenColor()
        default:
            badgeView.textColor = UIColor.yellowColor()
        }
    }

    @IBAction func badgeBackgroundColorChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            badgeView.badgeBackgroundColor = UIColor.redColor()
        case 1:
            badgeView.badgeBackgroundColor = UIColor.blueColor()
        default:
            badgeView.badgeBackgroundColor = UIColor.blackColor()
        }
    }

    @IBAction func borderColorChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            badgeView.borderColor = UIColor.whiteColor()
        case 1:
            badgeView.borderColor = UIColor.blackColor()
        default:
            badgeView.borderColor = UIColor.yellowColor()
        }
    }

    @IBAction func hidesWhenZeroChanged(sender: UISwitch) {
        badgeView.hideWhenZero = sender.on
    }

    @IBAction func maxWidthChanged(sender: UISlider) {
        badgeView.maxWidth = CGFloat(sender.value)
    }

    @IBAction func borderWidthChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            badgeView.borderWidth = 0.0
        case 1:
            badgeView.borderWidth = 2.0
        default:
            badgeView.borderWidth = 4.0
        }
    }

    @IBAction func paddingFactorChanged(sender: UISlider) {
        badgeView.paddingFactor = CGFloat(sender.value + 0.5)
    }

}

extension ViewController: UITextFieldDelegate {

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        badgeView.text = textField.text
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        print("text \(textField.text)")
    }
}


