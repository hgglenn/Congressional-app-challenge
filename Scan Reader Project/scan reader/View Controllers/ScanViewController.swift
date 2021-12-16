//
//  scanViewController.swift
//  scan reader
//
//  Created by Henry G. Glenn on 10/24/21.
//

import UIKit
import AVFoundation

@available(iOS 13.0, *)
class ScanViewController: ViewController
{
@IBOutlet weak var outputTextBox: UITextView!
    
    @IBOutlet weak var playButtonOutlet: UIButton!
    
    var textForOutputBox = ""
    
    var keyboardHeight:CGFloat = 0
    
    lazy var player = TextToSpeech(playButton: playButtonOutlet, textView: outputTextBox)
    
    override func viewDidLoad()
    {
        // Do any additional setup after loading the view
        outputTextBox.insertText(textForOutputBox)
    }
    
    @IBOutlet weak var rateSliderOutlet: UISlider!
    
    @IBAction func rateSlider(_ sender: Any)
    {
        player.rate(value: rateSliderOutlet.value)
        player.stop()
        playButtonOutlet.isSelected = false
        player.new()
    }
    
    @IBOutlet weak var pitchSliderOutlet: UISlider!
    
    @IBAction func pitchSlider(_ sender: Any)
    {
        player.pitch(value: pitchSliderOutlet.value)
        player.stop()
        playButtonOutlet.isSelected = false
        player.new()
    }
    
    @IBAction func stopButton(_ sender: Any)
    {
        player.stop()
        playButtonOutlet.isSelected = false
    }
    
    
    @IBAction func playButton(_ sender: Any)
    {
        playButtonOutlet.isSelected.toggle()
        if textForOutputBox != outputTextBox.text
        {
            player.stop()
            textForOutputBox = outputTextBox.text
            player.new()
            
            if playButtonOutlet.isSelected == true
            {
                player.read(text: textForOutputBox)
                player.play()
            }
        }
        else if player.synthesizer.isSpeaking == false
        {
            player.read(text: textForOutputBox)
            player.play()
        }
        else if player.synthesizer.isPaused == false
        {
            player.pause()
        }
        else if player.synthesizer.isPaused == true
        {
            player.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)

        if self.isMovingFromParent
        {
            player.stop()
        }
    }
}
