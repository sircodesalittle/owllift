//
//  setRepControl.swift
//  OwlLift
//
//  Created by Alex Dykstra on 2/12/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit

class setRepControl: UIView {

    var sets: Int?
    var reps: Int?
    var setRepButtons = [UIButton]()
    var spacing = 5
    let filledCircleImage = UIImage(named: "filledCircle")
    let emptyCircleImage = UIImage(named: "emptyCircle")
    
    var repsCompleted = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    override func layoutSubviews() {
        if setRepButtons.count < sets {
            for _ in 0..<sets! {
                let button = UIButton()
                button.setBackgroundImage(emptyCircleImage, forState: .Normal)
                
                button.setBackgroundImage(filledCircleImage, forState: .Selected)
                button.setTitleColor(UIColor.whiteColor(), forState: .Selected)
                button.setTitle("", forState: .Selected)
                
                button.addTarget(self, action: "setRepButtonTapped:", forControlEvents: .TouchDown)
                button.adjustsImageWhenHighlighted = false
                setRepButtons += [button]
                addSubview(button)
            }
        }
        // Set the button's width and height to a square the size of the frame's height.
        let buttonSize = Int(frame.size.height * (3/5))
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        // Offset each button's origin by the length of the button plus some spacing.
        for (index, button) in setRepButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + 5))
            button.frame = buttonFrame
        }
        
        //updateButtonSelectionStates()
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + spacing) * sets!
        
        return CGSize(width: width, height: buttonSize)
    }
    
    func setRepButtonTapped(button: UIButton) {
        button.selected = true
        if repsCompleted > 0 {
            button.titleLabel?.text = String(repsCompleted)
        }
    }
    
//    func updateButtonSelectionStates() {
//        for button in setRepButtons {
//            // If the index of a button is less than the rating, that button shouldn't be selected.
//            button.selected = index
//        }
//    }

}
