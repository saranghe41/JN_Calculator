//
//  ViewController.swift
//  JN_Calculator
//
//  Created by 김지은 on 2021/09/16.
//

import UIKit

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
    var numbersCalcHistory = Array<Dictionary<String,Decimal>>()
    var numbersCalcTemp: String = ""
    var calcData: Decimal = 0.0
    var calcResult: Decimal?
    var operationBtnTag: Int = 0
    
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
        print("check1")
        if 0 < operationBtnTag && operationBtnTag < 5 {
            for btnItem in OperationBtns {
                if btnItem.tag == operationBtnTag {
                    numbersCalcTemp += (btnItem.titleLabel?.text as! String)
                    onUnselectedBtn(sender: btnItem)
                    numberString.removeAll()
                    calcResult = nil
                    break
                }
            }
        }
        print("check1")
        print(numberString.first)
        if numberString.first == "0" { numberString.removeFirst() }
        numberString.append(inputString)
    }
    
    // Clciked ClearBtn
    @objc fileprivate func onClearBtnClicked(sender: UIButton) {
        guard let btnGubun = sender.titleLabel?.text else { return }
        
        if btnGubun == "C" {
            numberString.removeAll()
            numberString.append("0")
        }
        else {
            numbersCalcTemp.removeAll()
        }
        
        calcData = 0
        calcResult = nil
        
        for btnItem in OperationBtns {
            onUnselectedBtn(sender: btnItem)
            operationBtnTag = 0
        }
    }
    
    // Clicked (Add, Min, Multi, Div)Btn
    @objc fileprivate func onOperationBtnClicked(sender: UIButton) {
        if calcData == 0 {
            calcData = Decimal(string: numberString)!
        }
        else {
            if calcResult == nil {
                let result = onCalculatedValue(tag: operationBtnTag, fstData: calcData, secData: Decimal(string:numberString)!) as! Decimal
                calcResult = result
                calcData = result
                numberString = String(describing: result)
            }
            else {
                for btnItem in OperationBtns {
                    onUnselectedBtn(sender: btnItem)
                }
            }
        }
        onSelectedBtn(sender: sender)
    }
    
    // Clicked SumBtn
    @objc fileprivate func onSumBtnClicked(_sender: UIButton)
    {
        numbersCalcTemp += String(describing: calcData)
        calcResult = onCalculatedValue(tag: operationBtnTag, fstData: calcData, secData: Decimal(string:numberString)!) as! Decimal
        numberString.removeAll()
        numberString.append(String(describing: calcResult))
        numbersCalcHistory.append([numbersCalcTemp:calcResult!])
        
        // 초기화
        calcData = 0
        calcResult = nil
        operationBtnTag = 0
        numbersCalcTemp = ""
    }
    
    // Selected Btn's Status
    func onSelectedBtn(sender: UIButton) {
        sender.backgroundColor = .white
        sender.titleLabel!.tintColor = .systemOrange
        operationBtnTag = sender.tag
    }
    
    // Unselected Btn's Status
    func onUnselectedBtn(sender: UIButton) {
        sender.backgroundColor = .systemOrange
        sender.titleLabel!.tintColor = .black
    }
    
    func onCalculatedValue(tag: Int, fstData: Decimal, secData: Decimal) -> Decimal {
        var valueData: Decimal = 0.0
        print("secData: \(secData)")
        if let aoTag = tag as? Int {
            switch aoTag {
            case 1:
                // Add
                valueData = fstData + secData
                print("Tag:1")
                break
            case 2:
                // Miner
                valueData = fstData - secData
                print("Tag:2")
                break
            case 3:
                // Multi
                valueData = fstData * secData
                print("Tag:3")
                break
            case 4:
                // Division
                valueData = fstData / secData
                print("Tag:4")
                break
            default:
                break
            }
        }
        return valueData
    }
}
