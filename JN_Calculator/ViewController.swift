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
    @IBOutlet var arithOperationBtns: [cornerButton]!
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
    var fstNumber: Decimal?
    var secNumber: Decimal?
    var arithOperation: String = ""
    
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
        for btnItem in arithOperationBtns {
            btnItem.addTarget(self, action: #selector(onArithOperationBtnClicked(sender:)), for: .touchUpInside)
        }
        
        // Add SumBtn event
        SumBtn.addTarget(self, action: #selector(onSumBtnClicked(_sender:)), for: .touchUpInside)
    }
    
    // Clicked Btn 0 ~ 9
    @objc fileprivate func onNumberBtnClicked(sender: UIButton) {
        guard let inputString = sender.titleLabel?.text else { return }
        
        var flag = false
        for btnItem in arithOperationBtns {
            if btnItem.isSelected {
                flag = true
            }
        }
        
        // Selected arithOperationBtn
        if flag {
            numberString.removeAll()
        }
        
        numberString.append(inputString)
    }
    
    // Clciked ClearBtn
    @objc fileprivate func onClearBtnClicked(sender: UIButton) {
        guard let inputString = sender.titleLabel?.text else { return }
        
        if inputString == "C" {
            numberString.removeAll()
        }
        else if inputString == "AC" {
            numberCalcString.removeAll()
        }
    }
    
    // Clicked (Add, Min, Multi, Div)Btn
    @objc fileprivate func onArithOperationBtnClicked(sender: UIButton) {
        guard let arithOper = sender.titleLabel?.text else { return }
        
        // Selected Btn
        for btnItem in arithOperationBtns {
            btnItem.isSelected = false
        }
        sender.isSelected = true
        
        switch arithOper {
        case "+":
            arithOperation.removeAll()
            arithOperation.append("+")
            break
        case "﹣":
            arithOperation.removeAll()
            arithOperation.append("-")
            break
        case "×":
            arithOperation.removeAll()
            arithOperation.append("*")
            break
        case "÷":
            arithOperation.removeAll()
            arithOperation.append("/")
            break
        default:
            break
        }
        
        arithOperation.removeAll()
        arithOperation.append(arithOper)
    }
    
    // Clicked SumBtn
    @objc fileprivate func onSumBtnClicked(_sender: UIButton)
    {
        
    }
}

