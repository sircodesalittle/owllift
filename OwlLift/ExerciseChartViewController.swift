//
//  ExerciseChartViewController.swift
//  OwlLift
//
//  Created by Alex Dykstra on 4/6/16.
//  Copyright © 2016 Alex Dykstra. All rights reserved.
//

import UIKit
import Charts

class ExerciseChartViewController: UIViewController {

    @IBOutlet weak var lineChart: LineChartView!
    var exerciseArray = [HistoricalExercise]()
    var months: [String]!
    var dateStrings: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = exerciseArray[0].exercise.name
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        var weights = [Double]()
        dateStrings = [String]()
        
        for exercise in exerciseArray {
            dateStrings.append(dateFormatter.stringFromDate(exercise.date))
            weights.append(Double(exercise.exercise.weight))
        }
        
        setChart(dateStrings, values: weights)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        lineChart.noDataText = "No Chart Data"
        lineChart.backgroundColor = UIColor.darkGrayColor()
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: nil)
        lineChartDataSet.setCircleColor(UIColor.lightGrayColor())
        
        lineChartDataSet.setColor(UIColor(red: 255/255, green: 190/255, blue: 0/255, alpha: 1))
        lineChart.xAxis.labelTextColor = UIColor.whiteColor()
        lineChart.xAxis.labelPosition = .Bottom
        lineChart.descriptionText = ""
        lineChart.scaleYEnabled = false
        
        // Make the axis labels have no decimal.
        lineChart.leftAxis.valueFormatter = NSNumberFormatter()
        lineChart.leftAxis.valueFormatter?.minimumFractionDigits = 0
        lineChart.rightAxis.valueFormatter = NSNumberFormatter()
        lineChart.rightAxis.valueFormatter?.minimumFractionDigits = 0
        
        
        
        lineChart.leftAxis.labelTextColor = UIColor.whiteColor()
        lineChart.rightAxis.labelTextColor = UIColor.whiteColor()
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartData.setValueTextColor(UIColor.whiteColor())
        
        // Format the data label to no decimal.
        lineChartData.setValueFormatter(lineChart.leftAxis.valueFormatter)
        
        lineChart.data = lineChartData
        
        // Turn off the legend
        lineChart.legend.enabled = false
        
        //lineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
