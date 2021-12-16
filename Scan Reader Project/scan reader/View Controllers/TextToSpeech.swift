//
//  TextToSpeech.swift
//  scan reader
//
//  Created by Henry G. Glenn on 10/27/21.
//

import UIKit
import AVFoundation

class TextToSpeech: NSObject
{
    var synthesizer = AVSpeechSynthesizer()
    let voice = AVSpeechSynthesisVoice(language: "en-GB")
    var utterance = AVSpeechUtterance(string: "")
    var rate:Float = 0.50
    var pitch:Float = 1.0
    var playButton = UIButton()
    var textView = UITextView()
    var currentGroup = 0
    var textIndex:Int = 0

    init(playButton: UIButton, textView: UITextView)
    {
        self.playButton = playButton
        self.textView = textView
        super.init()
        self.synthesizer.delegate = self
    }
    
    func read(text: String)
    {
        // Create an utterance.
        let utterance = AVSpeechUtterance(string: text)

        // Configure the utterance.
        utterance.rate = rate
        utterance.pitchMultiplier = pitch
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 1
        utterance.voice = voice
        
        self.utterance = utterance
    }
    
    func new()
    {
        self.synthesizer = AVSpeechSynthesizer()
        self.synthesizer.delegate = self
    }
    
    func play()
    {
        if synthesizer.isSpeaking == false
        {
            synthesizer.speak(self.utterance)
        }
        else if synthesizer.isPaused == true
        {
            let attributedText = NSMutableAttributedString(attributedString: textView.attributedText!)
            
            attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.yellow, range: NSMakeRange(textIndex - (utterance.speechString.components(separatedBy: " ")[currentGroup - 1]).count, (utterance.speechString.components(separatedBy: " ")[currentGroup - 1]).count))

            textView.attributedText = attributedText
            synthesizer.continueSpeaking()
        }
        //textView.isEditable = false
        //textView.isSelectable = false
    }
    
    func pause()
    {
        if synthesizer.isPaused == false
        {
            synthesizer.pauseSpeaking(at: AVSpeechBoundary.immediate)
        }
        clear()
        //textView.isEditable = true
        //textView.isSelectable = true
    }
    
    func stop()
    {
        if synthesizer.isSpeaking == true
        {
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            currentGroup = 0
        }
        reset()
        
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText!)
        
        attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: NSMakeRange(0, textView.text.count))

        textView.attributedText = attributedText
        
        //textView.isEditable = true
        //textView.isSelectable = true
    }
    
    func pitch(value: Float)
    {
        self.pitch = value
    }
    
    func rate(value: Float)
    {
        self.rate = value
    }
    
    func reset()
    {
        currentGroup = 0
        textIndex = 0
    }
    
    func clear()
    {
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText!)
        
        attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: NSMakeRange(0, textView.text.count))
        textView.attributedText = attributedText
        //textView.isEditable = true
        //textView.isSelectable = true
    }
}

extension TextToSpeech: AVSpeechSynthesizerDelegate
{
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance)
    {
        playButton.isSelected = false
        currentGroup = 0
        textIndex = 0
        clear()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString: NSRange, utterance: AVSpeechUtterance)
    {
        // Modify some of the attributes of the attributed string.
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText!)
        
        attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: NSMakeRange(0, textView.text.count))
        
        currentGroup += 1
        if currentGroup != 1
        {
            textIndex += (utterance.speechString.components(separatedBy: " ")[currentGroup - 1]).count + 1
        }
        else
        {
            textIndex += (utterance.speechString.components(separatedBy: " ")[currentGroup - 1]).count
        }

        // Add highlight.
        attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.yellow, range: NSMakeRange(textIndex - (utterance.speechString.components(separatedBy: " ")[currentGroup - 1]).count, (utterance.speechString.components(separatedBy: " ")[currentGroup - 1]).count))

        textView.attributedText = attributedText    
    }
}
