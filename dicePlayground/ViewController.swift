//
//  ViewController.swift
//  dicePlayground
//
//  Created by 江庸冊 on 2021/10/22.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    //diceImages
    
    @IBOutlet var dicesImages: [UIImageView]!
    //Lable
    @IBOutlet weak var pointsUILabel: UILabel!
    @IBOutlet weak var chipsUILabel: UILabel!
    @IBOutlet weak var stakeUILabel: UILabel!
    //TextView
    @IBOutlet weak var statusUITextView: UITextView!
    //button
    @IBOutlet weak var startButton: UIButton!
    //UISegmentedControl
    @IBOutlet weak var gambleUISegmentedControl: UISegmentedControl!
    //UIStepper
    @IBOutlet weak var gambleUIStepper: UIStepper!
    
    let imageNames = ["1","2","3","4","5","6"]
    var player: AVAudioPlayer?
    var money = 1000
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusUITextView.layoutManager.allowsNonContiguousLayout = false
    }
    
//@IBAction startButton
//優先判斷賭金是否足夠支付下注金額
    @IBAction func startButtonChange(_ sender: UIButton) {
        if Int(gambleUIStepper.value) > money {
            self.statusUITextView.text = String("You Need to Top UP ! ! ! \n") + self.statusUITextView.text
        }else{
            //每次按下按鈕時都先把總合歸零，並開始跑骰子聲
            var diceSum = 0
            self.playSound(name:"dice_shake")
            //時間間隔起算
            let diceTime: TimeInterval = 1.42
            DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + diceTime)
                {
            //跑隨機骰子及計算總和
                    for i in 0...5{
                        let diceNum = Int.random(in: 1...6)
                        diceSum += diceNum
                        self.dicesImages[i].image = UIImage(named: self.imageNames[diceNum-1])
                    }
                    //將總和顯示在畫面上
                    self.pointsUILabel.text = String(diceSum)
                    //開始判斷大小21點情形
                    switch diceSum{
                    case 6...20:
                        if self.gambleUISegmentedControl.selectedSegmentIndex == 0 {
                            self.win(odds:2)
                        }else{
                            self.lose()
                        }
                    case 22...36:
                        if self.gambleUISegmentedControl.selectedSegmentIndex == 2 {
                            self.win(odds:5)
                        }else{
                            self.lose()
                        }
                    default:
                        if self.gambleUISegmentedControl.selectedSegmentIndex == 1 {
                            self.win(odds:10)
                        }else{
                            self.lose()
                        }
                    }
                    self.startButton.isEnabled = true
        }
    }
}
    //@IBAction Top UP Button
    @IBAction func addMoneyPressed(_ sender: UIButton) {
        money += 1000
        moneyUpdate()
        playSound(name: "cash")
        self.statusUITextView.text += String("\nTop UP 1000$ succeed ！！！")
        showTextBotton()
    }
    //@IBAction Stepper
    @IBAction func moneyStepperPressed(_ sender: UIStepper) {
        gambleMoneyUpdate()
    }
    func showTextBotton() {
        statusUITextView.scrollRangeToVisible(NSRange(location: .max, length:0))
    }
    func gambleMoneyUpdate(){
        stakeUILabel.text =  String(format: "%.f", gambleUIStepper.value) + "$"
    }
    func moneyUpdate(){
        chipsUILabel.text = String(money)+"$"
    }
    //播放各種音效
    func playSound(name:String){
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
            self.player = try? AVAudioPlayer(contentsOf: url)
            self.player?.play()
        }
    }
    func win(odds:Double){
        self.playSound(name: "win")
        let gamoney = Int(odds * self.gambleUIStepper.value)
        self.money += gamoney
        self.moneyUpdate()
        self.statusUITextView.text += String("\n You Win\(gamoney)$，Your Chips\(self.money)$")
        showTextBotton()
    }
    func lose(){
        self.playSound(name: "lose")
        let gamoney = Int(self.gambleUIStepper.value)
        self.money -= gamoney
        self.moneyUpdate()
        self.statusUITextView.text += String("\n You Lose\(gamoney)$，Your Chips\(self.money)$")
        showTextBotton()
    }
    //override 這段看不懂
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        //賭金是否足夠支付下注金額
        if Int(gambleUIStepper.value) > money{
            self.statusUITextView.text = String("You need to Top UP ! ! ! \n") + self.statusUITextView.text
        }else{
            //按下按鈕時先把總合歸零
            var diceSum = 0
            self.playSound(name: "dice_shake")
            
            //跑隨機骰子及計算總和
            for i in 0...5 {
                let diceNum = Int.random(in: 1...6)
                diceSum += diceNum
                self.dicesImages[i].image = UIImage(named: self.imageNames[diceNum-1])
            }
            //將總和顯示在畫面上
            self.pointsUILabel.text = String(diceSum) + "points"
            //開始判斷大小21點情形
            switch diceSum {
            case 6...20:
                if self.gambleUISegmentedControl.selectedSegmentIndex == 0 {
                    self.win(odds: 2)
                }else{
                    self.lose()
                }
            case 22...36:
                if self.gambleUISegmentedControl.selectedSegmentIndex == 2 {
                    self.win(odds: 2)
                }else{
                    self.lose()
                }
            default :
                if self.gambleUISegmentedControl.selectedSegmentIndex == 1 {
                    self.win(odds: 10)
                }else{
                    self.lose()
                }
            }
            self.startButton.isEnabled = true
        }
    }
}
