//
//  ChartsViewController.swift
//  MyBudget
//
//  Created by Zeyuan Cai on 2019/04/12.
//  Copyright © 2019 Zeyuan Cai. All rights reserved.
//

import UIKit
import Charts
import RealmSwift
class ChartsViewController: DemoBaseViewController {

    var type : Int = 0
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet var chartView: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.type = 0
        // Do any additional setup after loading the view.
        self.title = "Pie Chart"
        
       
        self.setup(pieChartView: chartView)
        
        chartView.delegate = self
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        //        chartView.legend = l
        
        // entry label styling
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
    
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        // Do any additional setup after loading the view.
        
        updateChartData()
    }
    @IBAction func changeValue(_ sender: Any) {
        updateChartData()
    }
  
    @IBAction func change(_ sender: Any) {
        let vc = LineChart2ViewController.init(nibName: "LineChart2ViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        if segmented.selectedSegmentIndex == 0 {
            self.setDataCount(2, range: 100)
        }else{
            self.setDataCount(5, range: 100)
        }
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        
        let realm = try! Realm()
        let budgets = realm.objects(Budget.self)
        let array = NSMutableArray()
        for data in budgets {
            if data.username == UserDefaults.standard.object(forKey: "username") as? String {
                array.add(data)
            }
        }
        if(array.count == 0){
            return
        }
        if count == 2 {
            var Income = 0.00
            var Expense = 0.00
            
            for index in 0...array.count-1 {
                let budget = budgets[index]
                let price = (budget.priceStr! as NSString).doubleValue
                if(budget.typeInt == "0"){
                    Expense += price
                }else{
                    Income += price
                }
            }
            
            let entries = (0..<count).map { (i) -> PieChartDataEntry in
                // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
                if(i == 0){
                    return PieChartDataEntry(value: Income,
                                             label: "Income",
                                             icon: nil)
                }else{
                    return PieChartDataEntry(value: Expense,
                                             label: "Expense",
                                             icon: nil)
                }
            }
            let set = PieChartDataSet(values: entries, label: "My Record")
            set.drawIconsEnabled = false
            set.sliceSpace = 2
            
            
            set.colors = ChartColorTemplates.joyful()
                + ChartColorTemplates.colorful()
                + ChartColorTemplates.liberty()
                + ChartColorTemplates.pastel()
                + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
            
            let data = PieChartData(dataSet: set)
            
            let pFormatter = NumberFormatter()
            pFormatter.numberStyle = .percent
            pFormatter.maximumFractionDigits = 1
            pFormatter.multiplier = 1
            pFormatter.percentSymbol = " %"
            data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
            
            data.setValueFont(.systemFont(ofSize: 11, weight: .light))
            data.setValueTextColor(.white)
            
            chartView.data = data
            chartView.highlightValues(nil)
        }else{
           var food = 0.00
           var travel = 0.00
           var shopping = 0.00
           var traffic = 0.00
           var other = 0.00
        
            for index in 0...array.count-1 {
            let budget = budgets[index]
                let price = (budget.priceStr! as NSString).doubleValue
                if(budget.expenseStr == "Food"){
                    food += price
                }else if(budget.expenseStr == "Travel"){
                    travel += price
                }else if(budget.expenseStr == "Shopping"){
                    shopping += price
                }else if(budget.expenseStr == "Transportation"){
                    traffic += price
                }else{
                    other += price
                }
                
                let entries = (0..<count).map { (i) -> PieChartDataEntry in
                    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
                    if(i == 0){
                        return PieChartDataEntry(value: food,
                                                 label: "Food",
                                                 icon: nil)
                    }else if(i == 1){
                        return PieChartDataEntry(value: travel,
                                                 label: "Travel",
                                                 icon: nil)
                    }else if(i == 2){
                        return PieChartDataEntry(value: shopping,
                                                 label: "Shopping",
                                                 icon: nil)
                    }else if(i == 3){
                        return PieChartDataEntry(value: traffic,
                                                 label: "Transportation",
                                                 icon: nil)
                    }else{
                        return PieChartDataEntry(value: other,
                                                 label: "Other",
                                                 icon: nil)
                    }
                }
                let set = PieChartDataSet(values: entries, label: "My Record")
                set.drawIconsEnabled = false
                set.sliceSpace = 5
                
                
                set.colors = ChartColorTemplates.joyful()
                    + ChartColorTemplates.colorful()
                    + ChartColorTemplates.liberty()
                    + ChartColorTemplates.pastel()
                    + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
                
                let data = PieChartData(dataSet: set)
                let pFormatter = NumberFormatter()
                pFormatter.numberStyle = .percent
                pFormatter.maximumFractionDigits = 1
                pFormatter.multiplier = 1
                pFormatter.percentSymbol = " %"
                data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
                
                data.setValueFont(.systemFont(ofSize: 11, weight: .light))
                data.setValueTextColor(.white)
                
                chartView.data = data
                chartView.highlightValues(nil)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   
}
