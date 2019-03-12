//
//  ViewController.swift
//  Etiquette
//
//  Created by Sarah Mautsch on 02.03.19.
//  Copyright © 2019 Sarah Mautsch. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    var mainStack = UIStackView()
    
    let navigationView = UIView()
    let controlsView = UIView()
    let instructionView = UIView()
    let infoView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        self.view.addSubview(mainStack)
        
        mainStack.snp.makeConstraints { make in
            make.pinAllEdgesToSuperView()
        }
        
        navigationView.backgroundColor = .appropriateGreen
        
        controlsView.backgroundColor = .white
        
        mainStack.addArrangedSubview(navigationView)
        mainStack.addArrangedSubview(controlsView)
        
        let controlsStack = UIStackView()
        controlsView.addSubview(controlsStack)
        
        controlsStack.axis = .vertical
        controlsStack.spacing = 6
        controlsStack.snp.makeConstraints { make in
            make.pinAllEdges(withInsets: UIEdgeInsets(top: 12, left: 24, bottom: 0, right: 0), respectingSafeAreaLayoutGuidesOfView: nil)
        }
        
        
        //INSTRUCTION
        
        instructionView.backgroundColor = .white
        
        controlsStack.addArrangedSubview(instructionView)
        
        
        let instructionStack = UIStackView()
        
        instructionStack.axis = .vertical
        instructionStack.alignment = .leading
        instructionStack.spacing = 12
        instructionView.addSubview(instructionStack)
        
        instructionStack.snp.makeConstraints { make in
            make.pinAllEdges(withInsets: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0), respectingSafeAreaLayoutGuidesOfView: nil)
        }
        
        
        let nextStack = UIStackView()
        nextStack.axis = .horizontal
        nextStack.distribution = .equalSpacing
        nextStack.spacing = 6
        instructionStack.addArrangedSubview(nextStack)
        
        let iconContainer = AAView()
        iconContainer.cornerRadius = Float.infinity
        iconContainer.tintColor = UIColor.appropriateGreen
        let smallArrow = UIImageView()
        smallArrow.image = UIImage(named: "small-arrow")?.withRenderingMode(.alwaysTemplate)
        iconContainer.contentView.addSubview(smallArrow)
        
        smallArrow.snp.makeConstraints { make in
            make.pinAllEdgesToSuperView()
        }
     
        let nextLabel = AALabel()
        nextLabel.text = "next up:"
        nextLabel.font = UIFont.ceraFont(ofSize: 18, Weight: .bold)
        nextLabel.transform = CGAffineTransform(translationX: 0, y: 1)
        nextLabel.textColor = UIColor.appropriateGreen.withAlphaComponent(0.5)
        nextLabel.uppercased = true
        
        let metersLabel = AALabel()
        metersLabel.text = "in 2000 meters"
        metersLabel.font = UIFont.ceraFont(ofSize: 18, Weight: .bold)
        metersLabel.transform = CGAffineTransform(translationX: 0, y: 1)
        metersLabel.textColor = UIColor.appropriateGreen
        metersLabel.uppercased = true
        
        nextStack.addArrangedSubview(iconContainer)
        nextStack.addArrangedSubview(nextLabel)
        nextStack.addArrangedSubview(metersLabel)
        
        let goalLabel = AALabel()
        goalLabel.text = "Isländische Straße"
        goalLabel.font = UIFont.ceraFont(ofSize: 28, Weight: .regular)
        goalLabel.textColor = .appropriateGreen
        goalLabel.sizeToFit()
        
        instructionStack.addArrangedSubview(goalLabel)
        
        
        //DIVIDER LINE
        
        let divider = UIView()
        divider.backgroundColor = UIColor.appropriateGreen.withAlphaComponent(0.25)
        
        controlsStack.addArrangedSubview(divider)
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        //INFO
        
        infoView.backgroundColor = .white
        controlsStack.addArrangedSubview(infoView)
        
        
        let infoStack = UIStackView()
        
        infoStack.axis = .horizontal
        infoStack.alignment = .center
        infoStack.distribution = .fillEqually
        infoStack.spacing = 6
        
        infoView.addSubview(infoStack)
        
        infoStack.snp.makeConstraints { make in
            make.pinAllEdges(withInsets: UIEdgeInsets(top: 6, left: 0, bottom: 12, right: 24), respectingSafeAreaLayoutGuidesOfView: infoView)
        }
        
        
        let timeWidget = SMInfoWidget()
        timeWidget.titleLabel.text = "ARRIVAL"
        timeWidget.valueLabel.text = "01:46"
        infoStack.addArrangedSubview(timeWidget)
        
        let distanceWidget = SMInfoWidget()
        distanceWidget.titleLabel.text = "KM"
        distanceWidget.valueLabel.text = "175"
        infoStack.addArrangedSubview(distanceWidget)
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
