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
    
    var completedReps = [Int]()
    
    var setRepButtons = [UIButton]()
    var spacing = 5
    let filledCircleImage = UIImage(named: "filledCircle")
    let emptyCircleImage = UIImage(named: "emptyCircle")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        self.backgroundColor = UIColor.darkGrayColor()
        
        if setRepButtons.count < sets {
            for _ in 0..<sets! {
                let button = UIButton()
                button.setBackgroundImage(emptyCircleImage, forState: .Normal)
                button.setTitle(String(reps! + 1), forState: .Normal)
                button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                
                button.addTarget(self, action: #selector(setRepControl.setRepButtonTapped(_:)), forControlEvents: .TouchDown)
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
        
        setData()
    }
    
    func setData() {
        for (index, set) in completedReps.enumerate() {
            let currentButton = setRepButtons[index]
            if set > 0 {
                currentButton.setBackgroundImage(filledCircleImage, forState: .Normal)
                currentButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
                currentButton.setTitle(String(set), forState: .Normal)
            }
            else {
                currentButton.setBackgroundImage(emptyCircleImage, forState: .Normal)
                currentButton.setTitle(String(reps! + 1), forState: .Normal)
            }
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize + spacing) * sets!
        
        return CGSize(width: width, height: buttonSize)
    }
    
    func setRepButtonTapped(button: UIButton) {
        button.selected = true
        let currentValue = Int(button.titleLabel!.text!)
        if currentValue > 0 {
            button.setBackgroundImage(filledCircleImage, forState: .Normal)
            button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            button.setTitle(String(currentValue! - 1), forState: .Normal)
        }
        else {
            button.setBackgroundImage(emptyCircleImage, forState: .Normal)
            button.setTitle(String(reps! + 1), forState: .Normal)
        }
    }
    
    func returnData() -> Array<Int> {
        var repsCompleted: [Int] = []
        for button in setRepButtons {
            let completedValue = Int(button.titleLabel!.text!)
            if completedValue > reps! {
                repsCompleted.append(0)
            }
            else {
                repsCompleted.append(completedValue!)
            }
        }
        
        return repsCompleted
    }

}
