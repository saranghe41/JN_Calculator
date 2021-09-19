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
    
    var numberString = "" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.LabelMain.text = self.numberString
            }
        }
    }
    var numberHistory = Array<Dictionary<String,Decimal>>()
    var numberCalcString: String = ""
    var fstNumber: Decimal = 0.0
    var secNumber: Decimal?
    var operationBtnTag: Int?
    
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
        
        // Selected arithOperationBtn
        if operationBtnTag != nil {
            for btn in OperationBtns {
                if btn.tag == operationBtnTag {
                    btn.isSelected = false
                    btn.backgroundColor = .systemOrange
                    btn.titleLabel!.textColor = .black
                    operationBtnTag = nil
                    break
                }
            }
            numberString.removeAll()
            numberString.append("0")
        }
        
        if numberString.first == "0" { numberString.removeFirst() }
        numberString.append(inputString)
    }
    
    // Clciked ClearBtn
    @objc fileprivate func onClearBtnClicked(sender: UIButton) {
        if let inputString = sender.titleLabel?.text {
            numberString.removeAll()
            numberString.append("0")
        }
    }
    
    // Clicked (Add, Min, Multi, Div)Btn
    @objc fileprivate func onOperationBtnClicked(sender: UIButton) {
        let selectedOperationBtnTag = sender.tag

        if secNumber == nil {
            secNumber = Decimal(string: numberString)
        }
        else {
            switch operationBtnTag {
            case 1:
                // Add
                fstNumber = fstNumber + secNumber!
                secNumber = nil
                numberString.removeAll()
                break
            case 2:
                // Miner
                fstNumber = fstNumber - secNumber!
                secNumber = nil
                break
            case 3:
                // Multi
                fstNumber = fstNumber * secNumber!
                secNumber = nil
                break
            case 4:
                // Division
                fstNumber = fstNumber / secNumber!
                secNumber = nil
                break
            default:
                break
            }
        }

        if operationBtnTag != nil {
            if operationBtnTag != selectedOperationBtnTag {
                for btn in OperationBtns {
                    if btn.tag == operationBtnTag {
                        btn.isSelected = false
                        sender.backgroundColor = .systemOrange
                        sender.titleLabel!.textColor = .black
                        operationBtnTag = selectedOperationBtnTag
                        break
                    }
                }
            }
        }
        else {
            sender.isSelected = true
            sender.backgroundColor = .white
            sender.titleLabel!.textColor = .systemOrange
            operationBtnTag = selectedOperationBtnTag
        }
    }
    
    // Clicked SumBtn
    @objc fileprivate func onSumBtnClicked(_sender: UIButton)
    {
        
    }
}

