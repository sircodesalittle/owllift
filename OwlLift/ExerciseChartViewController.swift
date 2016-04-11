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
    // Array of exercises passed by the selected cell.
    var exerciseArray = [HistoricalExercise]()
    // Array of strings representing the instances of the completed exercise.
    var dateStrings: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title of the navigation bar.
        navigationItem.title = exerciseArray[0].exercise.name
        
        // Our date formatter -> example: 04/12.
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        // Our array for holding the weights that correspond to a completed exercise.
        var weights = [Double]()
        // Initialize our array.
        dateStrings = [String]()
        
        // Compile the two arrays for our data sources.
        for exercise in exerciseArray {
            dateStrings.append(dateFormatter.stringFromDate(exercise.date))
            weights.append(Double(exercise.exercise.weight))
        }
        
        // Compile & setup the chart.
        setChart(dateStrings, values: weights)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Sets up the chart with our passed in exercise from the tableview.
    func setChart(dataPoints: [String], values: [Double]) {
        
        // Initialize our array for the chart data.
        var dataEntries: [ChartDataEntry] = []
        
        // What appears on the screen when there is no data.
        lineChart.noDataText = "No Chart Data"
        // Set the background color for the chart.
        lineChart.backgroundColor = UIColor.darkGrayColor()
        
        // Compile the data for passing to the chart.
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        // Set the LineChartDataSet.
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: nil)
        
        // Set the color of the data points.
        lineChartDataSet.setCircleColor(UIColor.lightGrayColor())
        
        // The color for the lines connecting the data points.
        lineChartDataSet.setColor(UIColor(red: 255/255, green: 190/255, blue: 0/255, alpha: 1))
        
        // Various chart layout and design.
        lineChart.xAxis.labelTextColor = UIColor.whiteColor()
        lineChart.xAxis.labelPosition = .Bottom
        lineChart.descriptionText = ""
        lineChart.leftAxis.labelTextColor = UIColor.whiteColor()
        lineChart.rightAxis.labelTextColor = UIColor.whiteColor()
        
        // Do not allow panning on the Y axis.
        lineChart.scaleYEnabled = false
        
        // Make the axis labels have no decimal.
        lineChart.leftAxis.valueFormatter = NSNumberFormatter()
        lineChart.leftAxis.valueFormatter?.minimumFractionDigits = 0
        lineChart.rightAxis.valueFormatter = NSNumberFormatter()
        lineChart.rightAxis.valueFormatter?.minimumFractionDigits = 0
        
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        lineChartData.setValueTextColor(UIColor.whiteColor())
        
        // Format the data label to no decimal.
        lineChartData.setValueFormatter(lineChart.leftAxis.valueFormatter)
        
        lineChart.data = lineChartData
        
        // Turn off the legend
        lineChart.legend.enabled = false
        
        // If we ever want to add animation to the data appearing.
        //lineChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
}
