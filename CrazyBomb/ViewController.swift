//
//  ViewController.swift
//  CrazyBomb
//
//  Created by kobe on 2017/11/12.
//  Copyright © 2017年 kobe. All rights reserved.
//

import UIKit
import GameKit

class ViewController: UIViewController {

    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var redBombButton: UIButton!
    @IBOutlet weak var laughImageView: UIImageView!
    
    var timer = Timer()
    var answer:Int!
    let laughImage = ["LongPaul","CanNotLose"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        answer = generateRandomAnswer()
        print("answer = \(answer)")
    }

    func generateRandomAnswer() -> Int {
        let randomDistribution = GKRandomDistribution(lowestValue: 1, highestValue: 99)
        
        let answerNumber = randomDistribution.nextInt()
        print("random answer = \(answerNumber)");
        return answerNumber
    }
    
    func whoLaugh() -> String {
        let randomDistribution = GKRandomDistribution(lowestValue: 0, highestValue: laughImage.count - 1)
        let index = randomDistribution.nextInt()
        print("laugh index = \(index)")
        return laughImage[index]
    }
    
    @IBAction func clickRedBombButton(_ sender: UIButton) {
        if let guessNumber = sender.title(for: .normal) {
            let intGuessNumber = Int(guessNumber)!
            let startNumber = Int(startLabel.text!)!
            let endNumber = Int(endLabel.text!)!
            if intGuessNumber == answer {
                print("opps... bomb...")
                //redBombButton.setTitle(nil, for: .normal)
                laughImageView.image = UIImage(named: whoLaugh())
                laughImageView.isHidden = false
                return
            }
            else if intGuessNumber < startNumber || intGuessNumber > endNumber {
                print("sorry... out of range")
                if timer.isValid{
                    print("timer is running, stop it")
                    timer.invalidate()
                }
                //yellow color to tip user, out of range.
                startLabel.backgroundColor = UIColor.yellow
                endLabel.backgroundColor = UIColor.yellow
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(restoreRangeLabelBackground)), userInfo: nil, repeats: false)
                
                clearGuessNumber()
                return
            }
            
            if intGuessNumber > answer {
                endLabel.text = guessNumber
            }
            else {
                startLabel.text = guessNumber
            }
            clearGuessNumber()
        }
    }
    
    @objc func restoreRangeLabelBackground()
    {
        startLabel.backgroundColor = UIColor.white
        endLabel.backgroundColor = UIColor.white
    }
   
    @IBAction func clickNumberButton(_ sender: UIButton) {
        var count = 0
        var number:String!
        if let title = redBombButton.title(for: .normal)
        {
            count = title.characters.count
            if count >= 2
            {
                print("opps...guess number max count is 2.")
                return
            }
             print("count=\(count), title=\(title)")
            number = title + sender.title(for: .normal)!
        }
        else
        {
            number = sender.title(for: .normal)!
        }
        print("guess = \(number)")
        redBombButton.setTitle(number, for: .normal)
    }
    
    @IBAction func clickClearButton(_ sender: UIButton)
    {
        clearGuessNumber()
    }
    
    func clearGuessNumber()
    {
        redBombButton.setTitle(nil, for: .normal)
    }
    
    @IBAction func clickResetButton(_ sender: UIButton)
    {
        resetGame()
    }
    
    func resetGame()
    {
        startLabel.text = "1"
        endLabel.text = "99"
        laughImageView.isHidden = true
        clearGuessNumber()
        answer = generateRandomAnswer()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

