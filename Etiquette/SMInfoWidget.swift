//
//  SMInfoWidget.swift
//  Etiquette
//
//  Created by Sarah Mautsch on 02.03.19.
//  Copyright © 2019 Sarah Mautsch. All rights reserved.
//

import UIKit

class SMInfoWidget: UIView {
    
    let titleLabel = AALabel()
    let valueLabel = AALabel()
    
    private let contentStack = UIStackView()

    init() {
        super.init(frame: CGRect.zero)
        
        self.backgroundColor = UIColor.appropriateGreen.withAlphaComponent(0.08)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        
        contentStack.axis = .vertical
        contentStack.spacing = 6
        contentStack.alignment = .center
        
        self.addSubview(contentStack)
        
        contentStack.snp.makeConstraints { make in
            let insets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            make.pinAllEdges(withInsets: insets, respectingSafeAreaLayoutGuidesOfView: nil)
        }
        
        titleLabel.text = "Title"
        titleLabel.textColor = UIColor.appropriateGreen
        titleLabel.font = UIFont.ceraFont(ofSize: 9, Weight: .medium).fontWithSlashedZero()
        
        titleLabel.sizeToFit()
        
        contentStack.addArrangedSubview(titleLabel)
   
        
        valueLabel.text = "Value"
        valueLabel.textColor = UIColor.appropriateGreen
        valueLabel.font = UIFont.ceraFont(ofSize: 18, Weight: .medium).fontWithSlashedZero()

        valueLabel.sizeToFit()
        
        contentStack.addArrangedSubview(valueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
