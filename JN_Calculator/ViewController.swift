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
        if numberString.count == 9 { return }
        
        if operationBtnTag != nil {
            for btnItem in OperationBtns {
                if btnItem.tag == operationBtnTag {
                    numberCalcString += (btnItem.titleLabel?.text as! String)
                    onUnselectedBtn(sender: btnItem)
                    numberString.removeAll()
                    break
                }
            }
        }
//
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
            numberCalcString.removeAll()
        }
        
        fstNumber = 0
        secNumber = nil
    }
    
    // Clicked (Add, Min, Multi, Div)Btn
    @objc fileprivate func onOperationBtnClicked(sender: UIButton) {
        guard let btn = sender as? UIButton else { return }

        print("fstNumber: \(fstNumber)")
        print("secNumber: \(secNumber)")
        if secNumber == nil {
            secNumber = Decimal(string: self.numberString)
        }
        else {
            switch operationBtnTag {
            case 1:
                // Add
                fstNumber = fstNumber + secNumber!
                secNumber = nil
                numberString.removeAll()
                numberString = "\(fstNumber)"
                break
            case 2:
                // Miner
                fstNumber = fstNumber - secNumber!
                secNumber = nil
                numberString.removeAll()
                numberString = "\(fstNumber)"
                break
            case 3:
                // Multi
                fstNumber = fstNumber * secNumber!
                secNumber = nil
                numberString.removeAll()
                numberString = "\(fstNumber)"
                break
            case 4:
                // Division
                fstNumber = fstNumber / secNumber!
                secNumber = nil
                numberString.removeAll()
                numberString = "\(fstNumber)"
                break
            default:
                break
            }
        }

        if operationBtnTag != nil {
            if operationBtnTag != btn.tag {
                for btnItem in OperationBtns {
                    if btnItem.tag == operationBtnTag {
                        onUnselectedBtn(sender: btnItem)
                        break
                    }
                }
            }
        }
        onSelectedBtn(sender: btn)
        print("fstNumber: \(fstNumber)")
        print("secNumber: \(secNumber)")
    }
    
    // Clicked SumBtn
    @objc fileprivate func onSumBtnClicked(_sender: UIButton)
    {
        
    }
    
    // Selected Btn's Status
    func onSelectedBtn(sender: UIButton) {
        sender.backgroundColor = .white
        sender.titleLabel!.textColor = .red
        operationBtnTag = sender.tag
    }
    
    // Unselected Btn's Status
    func onUnselectedBtn(sender: UIButton) {
        sender.backgroundColor = .systemOrange
        sender.titleLabel!.textColor = .black
        operationBtnTag = nil
    }
}
