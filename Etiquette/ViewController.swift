//
//  ViewController.swift
//  Etiquette
//
//  Created by Sarah Mautsch on 02.03.19.
//  Copyright © 2019 Sarah Mautsch. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import CoreAudio
import SwiftySound

class ViewController: UIViewController {

    var mainStack = UIStackView()
    
    let navigationView = UIView()
    let controlsView = UIView()
    let instructionView = UIView()
    let infoView = UIView()
    let indicator = UIImageView()
    var blinkingView = AAView()
    
    var recorder: AVAudioRecorder!
    var levelTimer = Timer()
    
    let LEVEL_THRESHOLD: Float = -10.0
    
    
    let strings = ["After 2 kilometres, turn left", "In 100 m turn right", "Now turn right"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainStack.axis = .vertical
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        self.view.addSubview(mainStack)
        
        mainStack.snp.makeConstraints { make in
            make.pinAllEdgesToSuperView()
        }
        
        navigationView.backgroundColor = UIColor(displayP3Red: 77/255, green: 198/255, blue: 153/255, alpha: 1)
        
        let grass = UIView()
        grass.backgroundColor = UIColor.appropriateGreen
        navigationView.addSubview(grass)
        grass.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.382)
            make.centerX.equalToSuperview()
        }
        
        let street = UIImageView()
        street.contentMode = .scaleAspectFit
        street.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        street.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        street.setContentHuggingPriority(.defaultLow, for: .horizontal)
        street.setContentHuggingPriority(.defaultLow, for: .vertical)
        street.image = UIImage(named: "street")
        grass.addSubview(street)
        street.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        let blendView = UIView()
        blendView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        navigationView.addSubview(blendView)
        blendView.snp.makeConstraints { make in
            make.pinAllEdgesToSuperView()
        }
        
        indicator.image = UIImage(named: "indicator")
        indicator.layer.zPosition = 100
        indicator.layer.transform = CATransform3DMakeRotation(6, 1, 0, 0)
        indicator.contentMode = .scaleAspectFit
        navigationView.addSubview(indicator)
        
        indicator.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(48)
            make.width.equalTo(48)
        }
        
        let hudContainer = UIView()
        navigationView.addSubview(hudContainer)
        hudContainer.snp.makeConstraints { make in
            make.top.equalTo(navigationView.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(indicator.snp.top).offset(-12)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        let hudStack = UIStackView()
        hudStack.axis = .vertical
        hudStack.alignment = .center
        hudStack.distribution = .fill
        
        let arrowView = AAView()
        arrowView.tintColor = .white
        arrowView.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        arrowView.cornerRadius = Float.infinity
        
        hudContainer.addSubview(arrowView)
        arrowView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(88)
            make.height.equalTo(88)
        }
        
        let arrowIcon = UIImageView()
        arrowIcon.image = UIImage(named: "large-arrow")
        arrowIcon.contentMode = .scaleAspectFit
        arrowView.contentView.addSubview(arrowIcon)
        arrowIcon.snp.makeConstraints { make in
            make.pinAllEdgesToSuperView()
        }
        
        
        
        blinkingView.contentView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        blinkingView.layer.zPosition = 100
        blinkingView.layer.transform = CATransform3DMakeRotation(6, 1, 0, 0)
        
        navigationView.insertSubview(blinkingView, belowSubview: indicator)
        blinkingView.isUserInteractionEnabled = false
        blinkingView.cornerRadius = Float.infinity
        blinkingView.snp.makeConstraints { make in
            make.center.equalTo(indicator)
            make.size.equalTo(indicator)
        }

        
        controlsView.backgroundColor = .white
        controlsView.setContentHuggingPriority(.required, for: .horizontal)
        controlsView.setContentHuggingPriority(.required, for: .vertical)

        
        mainStack.addArrangedSubview(navigationView)
        mainStack.addArrangedSubview(controlsView)
        
        let controlsStack = UIStackView()
        controlsView.addSubview(controlsStack)
        
        controlsStack.axis = .vertical
        controlsStack.alignment = .fill
        controlsStack.distribution = .fill
        controlsStack.setContentHuggingPriority(.required, for: .horizontal)
        controlsStack.setContentHuggingPriority(.required, for: .vertical)

        controlsStack.spacing = 6
        controlsStack.snp.makeConstraints { make in
            make.pinAllEdges(withInsets: UIEdgeInsets(top: 12, left: 24, bottom: 0, right: 0), respectingSafeAreaLayoutGuidesOfView: nil)
        }
        
        
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
        infoStack.alignment = .fill
        infoStack.distribution = .fillEqually
        infoStack.spacing = 6
        infoStack.setContentHuggingPriority(.required, for: .horizontal)
        infoStack.setContentHuggingPriority(.required, for: .vertical)

        
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
        
        
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")
        
        let recordSettings: [String: Any] = [
            AVFormatIDKey:              kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      2,
            AVEncoderBitRateKey:        12800,
            AVLinearPCMBitDepthKey:     16,
            AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            //            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: [])
            try audioSession.setActive(true)
            try recorder = AVAudioRecorder(url:url, settings: recordSettings)
            
        } catch {
            return
        }
        
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        recorder.record()
        
        levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
        
        var timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            
            self.readOutString()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.startAnimation()
    }
    
    func startAnimation () {
        UIView.animate(withDuration: 3, delay: 0, options: [UIView.AnimationOptions.repeat], animations: {
            
            self.blinkingView.alpha = 0
            
            self.blinkingView.snp.remakeConstraints { make in
                make.center.equalTo(self.indicator)
                make.height.equalTo(180)
                make.width.equalTo(180)
            }
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    var currentStringIndex = 0
    var currentLevelArray : [Float] = []
    var currentLevel : Float = 0
    
    func readOutString () {
        print("speak")
        
        var average = currentLevelArray.average
        
        print(average)
        
        if average < 0.3 {
            if currentStringIndex > strings.count - 1 {
                currentStringIndex = 0
            }
            
            let string = strings[currentStringIndex]
            let utterance = AVSpeechUtterance(string: string)
            utterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)

            do{
                try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
            } catch {
                print("error")
            }
            
            let synth = AVSpeechSynthesizer()
            synth.speak(utterance)
            
            currentStringIndex = currentStringIndex + 1
            
        } else {
            Sound.category = .playAndRecord
            Sound.play(file: "Alert 2.m4a")
        }
    }
    
    @objc func levelTimerCallback() {
        recorder.updateMeters()
        
        var average = currentLevelArray.average
        
        print(average)
        
        
        // Power at the moment
        var level = recorder.averagePower(forChannel: 0)
        // Average power
        var otherLevel = recorder.peakPower(forChannel: 0)
        level =      dBFS_convertTo_dB(dBFSValue: level)
        otherLevel = dBFS_convertTo_dB(dBFSValue: otherLevel)
        
        //        print("PW: \(otherLevel) AP: \(level)  ")
        
        currentLevelArray.insert(otherLevel, at: 0)
        if currentLevelArray.count - 1 > 100 {
            currentLevelArray.removeSubrange(ClosedRange(100...currentLevelArray.count - 1))
        }
    }

    
    func dBFS_convertTo_dB (dBFSValue: Float) -> Float {
        var level:Float = 0.0
        let peak_bottom:Float = -80.0 // dBFS -> -160..0   so it can be -80 or -60
        
        if dBFSValue < peak_bottom
        {
            level = 0.0
        }
        else if dBFSValue >= 0.0
        {
            level = 1.0
        }
        else
        {
            let root:Float              =   2.0
            let minAmp:Float            =   powf(10.0, 0.05 * peak_bottom)
            let inverseAmpRange:Float   =   1.0 / (1.0 - minAmp)
            let amp:Float               =   powf(10.0, 0.05 * dBFSValue)
            let adjAmp:Float            =   (amp - minAmp) * inverseAmpRange
            
            level = powf(adjAmp, 1.0 / root)
        }
        return level
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension Sequence where Self.Iterator.Element: Numeric {
    var sum: Self.Iterator.Element {
        return self.reduce(0, +)
    }
}

extension Collection where Element: BinaryFloatingPoint {
    var average: Element {
        return self.reduce(0, +) / Element((0 as IndexDistance).distance(to: self.count))
    }
}
