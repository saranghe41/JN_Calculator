//
//  HistoryViewController.swift
//  JN_Calculator
//
//  Created by 김지은 on 2021/09/24.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var TableViewMain: UITableView!
    
    var historyArry: Array<String>?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let history = historyArry {
            return history.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "CellType", for: indexPath) as! CellType
        
        if let history = historyArry {
            if let rowData = history[indexPath.row] as? String {
                cell.LabelMain.text = rowData
            }
        }
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableViewMain.dataSource = self
        TableViewMain.delegate = self
    }
}
