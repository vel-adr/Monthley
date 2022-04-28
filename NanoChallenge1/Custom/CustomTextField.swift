//
//  CustomTextField.swift
//  NanoChallenge1
//
//  Created by Anselmus Pavel Adriska on 27/04/22.
//

import Foundation
import UIKit

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 8,
        left: 16,
        bottom: 8,
        right: 16
    )
    
    //Cara 1 nambahin bottom border (https://www.codegrepper.com/code-examples/swift/textfield+bottom+border+swift)
    private let defaultUnderlineColor = UIColor.lightGray
    private let bottomLine = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()

        borderStyle = .none
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = defaultUnderlineColor

        self.addSubview(bottomLine)
        bottomLine.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 1).isActive = true
        bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    public func setUnderlineColor(color: UIColor = .red) {
        bottomLine.backgroundColor = color
    }

    public func setDefaultUnderlineColor() {
        bottomLine.backgroundColor = defaultUnderlineColor
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    //Cara lain nambahin bottomBorder (https://stackoverflow.com/a/37853543)
//    override func draw(_ rect: CGRect) {
//        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
//        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
//        let path = UIBezierPath()
//
//        path.move(to: startingPoint)
//        path.addLine(to: endingPoint)
//        path.lineWidth = 2.0
//
//        tintColor.setStroke()
//
//        path.stroke()
//    }
}
