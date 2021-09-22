//
//  ViewController.swift
//  JN_Calculator
//
//  Created by 김지은 on 2021/09/16.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    @IBOutlet weak var LabelMain: UILabel!
    @IBOutlet var NumberBtns: [cornerButton]!
    @IBOutlet weak var ClearBtn: cornerButton!
    @IBOutlet var OperationBtns: [cornerButton]!
    @IBOutlet weak var SumBtn: cornerButton!
    
    var numberString = "0" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.LabelMain.text = self.numberString
            }
        }
    }
    var numbersCalcHistory = Array<Dictionary<String,Decimal>>() // 계산이력
    var numbersCalcTemp: String = "" // Dictionary의 String 연산 변수
    var calcData: Decimal = 0.0
    var toUsedBtn: UIButton? // 사칙연산해야할 Btn
    var clearFlag = false //
    var valueChkFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Add Btn 0 ~ 9 event
        for btnItem in NumberBtns {
            btnItem.addTarget(self, action: #selector(onNumberBtnClicked(sender:)), for: .touchUpInside)
        }
        
        // Add ClearBtn event
        ClearBtn.addTarget(self, action: #selector(onClearBtnClicked(sender:)), for: .touchUpInside)
        
        // (Add, Min, Multi, Div)Btn event 명시
        for btnItem in OperationBtns {
            btnItem.addTarget(self, action: #selector(onOperationBtnClicked(sender:)), for: .touchUpInside)
        }
        
        // Add SumBtn event
        SumBtn.addTarget(self, action: #selector(onSumBtnClicked(_sender:)), for: .touchUpInside)
    }
    
    // Clicked Btn 0 ~ 9
    @objc fileprivate func onNumberBtnClicked(sender: UIButton) {
        guard let inputString = sender.titleLabel?.text else { return }
        if numberString.count == 9 { return }
        
        if clearFlag {
            if let btn = toUsedBtn {
                onUnselectedBtn(sender: btn)
                numberString.removeAll()
            }
        }
        
        if numberString.first == "0" { numberString.removeFirst() }
        numberString.append(inputString)
    }
    
    // Clicked ClearBtn
    @objc fileprivate func onClearBtnClicked(sender: UIButton) {
        guard let btnGubun = sender.titleLabel?.text else { return }
        
        if btnGubun == "C" {
            onSelectedClear()
        }
        else {
            onSelectedAllClear()
        }
    }
    
    // Clicked (Add, Min, Multi, Div)Btn
    @objc fileprivate func onOperationBtnClicked(sender: UIButton) {
        guard let decData = Decimal(string: numberString) else { return }
        
        if !valueChkFlag {
            calcData = decData
            valueChkFlag = true
            numbersCalcTemp += String(describing: calcData)
        }
        else {
            if let btn = toUsedBtn {
                if clearFlag {
                    onUnselectedBtn(sender: btn)
                }
                else {
                    let result = onCalculatedValue(btnItem: btn, fstData: calcData, secData: decData)
                    calcData = result
                    numberString = String(describing: calcData)
                }
            }
        }
        onSelectedBtn(sender: sender)
    }
    
    // Clicked SumBtn
    @objc fileprivate func onSumBtnClicked(_sender: UIButton)
    {
        guard let decData = Decimal(string: numberString) else { return }
        
        if valueChkFlag {
            if !clearFlag {
                if let btn = toUsedBtn {
                    calcData = onCalculatedValue(btnItem: btn, fstData: calcData, secData: decData)
                }
            }
        }
        else {
            calcData = decData
            numbersCalcTemp += String(describing: calcData)
        }
        
        numbersCalcHistory.append([numbersCalcTemp:calcData])
        
        let result = calcData
        
        // clear
        onSelectedAllClear()
        
        // View Labeltext
        numberString.removeAll()
        numberString.append(String(describing: result))
        
        print(numbersCalcHistory)
        
    }
    
    // Selected Btn's Status
    func onSelectedBtn(sender: UIButton) {
        sender.backgroundColor = .white
        sender.titleLabel!.tintColor = .systemOrange
        toUsedBtn = sender
        clearFlag = true
        
    }
    
    // Unselected Btn's Status
    func onUnselectedBtn(sender: UIButton) {
        sender.backgroundColor = .systemOrange
        sender.titleLabel!.tintColor = .black
        clearFlag = false
    }
    
    
    func onSelectedClear() {
        numberString.removeAll()
        numberString.append("0")
        if let btn = toUsedBtn {
            onUnselectedBtn(sender: btn)
        }
    }
    
    func onSelectedAllClear() {
        onSelectedClear()
        calcData = 0
        valueChkFlag = false
        numbersCalcTemp = ""
    }
    
    func onCalculatedValue(btnItem: UIButton, fstData: Decimal, secData: Decimal) -> Decimal {
        var valueData: Decimal = 0.0
        
        if let tag = btnItem.tag as? Int {
            switch tag {
            case 1:
                // Add
                valueData = fstData + secData
                numbersCalcTemp += "➕\(String(describing: secData))"
                break
            case 2:
                // Miner
                valueData = fstData - secData
                numbersCalcTemp += "➖\(String(describing: secData))"
                break
            case 3:
                // Multi
                valueData = fstData * secData
                numbersCalcTemp += "✖️\(String(describing: secData))"
                break
            case 4:
                // Division
                valueData = fstData / secData
                numbersCalcTemp += "➗\(String(describing: secData))"
                break
            default:
                break
            }
        }
        return valueData
    }
}
