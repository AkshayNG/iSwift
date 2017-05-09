//
//  ANGCalendarView.swift
//  Self Drive
//
//  Created by Amol Bapat on 12/01/17.
//  Copyright © 2017 Olive. All rights reserved.
//

import UIKit

@objc protocol ANGCalendarDelegate
{
    @objc optional func didSelectDate(calendar:ANGCalendarView, date:Date)
}

class ANGCalendarView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    // MARK: Properties
    
    var delegate:ANGCalendarDelegate?
    var selectedDate:Date? = nil
    var minDate:Date? = nil
    var maxDate:Date? = nil
    
    enum Theme
    {
        case plain
        case dark
        case standard
    }
    
    var theme = Theme.plain
    var themeColor = UIColor.lightGray
    var headerTitleColor:UIColor? = nil
    
    // MARK: Colors
    
    private var headerBgColor:UIColor = UIColor()
    private var headerTextColor:UIColor = UIColor()
    
    private var weekBgColor:UIColor = UIColor()
    private var weekTextColor:UIColor = UIColor()
    
    private var selectedBgColor:UIColor = UIColor()
    private var selectedTextColor:UIColor = UIColor()
    
    private var datesBgColor:UIColor = UIColor()
    private var datesTextColor:UIColor = UIColor()
    
    private var disabledBgColor:UIColor = UIColor()
    private var disabledTextColor:UIColor = UIColor()
    
    private var calBgColor:UIColor = UIColor()
    
    
    // MARK: Private vars
    
    let reuseID = "dayCellId"
    private var selectedIndexPath:IndexPath? = nil
    private var circular = true
    
    private var currentDate:Date = Date()
    private var thisDay:Int = 0
    private var thisMonth:Int = 0
    private var thisYear:Int = 0
    private var displayingMonth:Int = 0
    private var displayingYear:Int = 0
    
    //weekday of 1st day
    private var startIndex:Int = 0
    
    //last day of month
    private var lastDay:Int = 0
    
    private var finalDates = NSMutableArray()
    private var nonSelectableDatesIndexes = NSMutableArray()
    
    private var loadFlag = false
    
    private var cellWd:CGFloat = 0.0
    private var cellHt:CGFloat = 0.0
    
    // MARK: Private UI
    private var titleLabel:UILabel = UILabel()
    private var collectionV:UICollectionView? = nil
    
    
    
    // MARK: Initialization
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.frame =  frame
        
        calendarLoaded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        calendarLoaded()
    }
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        if(!loadFlag)
        {
            calendarLoaded()
        }
        
        self.configureColors()
        
        headerView()
        weekView()
        
        configureCalendarView()
        reloadCalendarView()
    }
    

    func calendarLoaded()
    {
        if(self.backgroundColor == nil)
        {
            self.backgroundColor = UIColor.white
        }
        
        thisDay = currentDate.day()
        thisMonth = currentDate.month()
        thisYear = currentDate.year()
        
        displayingMonth = currentDate.month()
        displayingYear = currentDate.year()
        
        finalDates = NSMutableArray.init(capacity: 35)
        nonSelectableDatesIndexes = NSMutableArray.init(capacity: 7)
        
        if(self.selectedDate != nil)
        {
            currentDate = self.selectedDate!
        }
        
        loadFlag = true
    }
    
    func configureColors()
    {
        switch theme
        {
            case .plain:
                headerBgColor = themeColor
                headerTextColor = UIColor.white
                weekBgColor = themeColor
                weekTextColor = UIColor.white
                selectedBgColor = themeColor
                selectedTextColor = UIColor.white
                datesBgColor = UIColor.white
                datesTextColor = UIColor.black
                disabledBgColor = UIColor.white
                disabledTextColor = UIColor.white
                calBgColor = UIColor.white
                circular = true
                break
            
            case .dark:
                headerBgColor = themeColor
                headerTextColor = UIColor.white
                weekBgColor = themeColor
                weekTextColor = UIColor.white
                selectedBgColor = themeColor
                selectedTextColor = UIColor.white
                datesBgColor = themeColor.withAlphaComponent(0.5)
                datesTextColor = UIColor.white
                disabledBgColor = themeColor.withAlphaComponent(0.5)
                disabledTextColor = themeColor.withAlphaComponent(0.5)
                calBgColor = UIColor.white
                circular = false
                break
            
            case .standard:
                headerBgColor = themeColor
                headerTextColor = UIColor.white
                weekBgColor = themeColor.withAlphaComponent(0.5)
                weekTextColor = UIColor.black
                selectedBgColor = themeColor.withAlphaComponent(0.75)
                selectedTextColor = UIColor.white
                datesBgColor = UIColor.white
                datesTextColor = UIColor.black
                disabledBgColor = UIColor.white
                disabledTextColor = UIColor.black.withAlphaComponent(0.5)
                calBgColor = themeColor
                circular = true
                break
        }
    }
    
    
    // MARK: Design
    
    func headerView()
    {
        titleLabel.frame = CGRect(x:50, y:0, width:self.frame.size.width - 100, height:50)
        titleLabel.backgroundColor = headerBgColor
        titleLabel.textColor = headerTitleColor != nil ? headerTitleColor : headerTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 30.0)
        titleLabel.textAlignment = .center
        self.addSubview(titleLabel)
        
        let prevBtn = UIButton.init(type: .custom)
        prevBtn.frame = CGRect(x:0, y:0, width:50, height:50)
        prevBtn.backgroundColor = headerBgColor
        prevBtn.setTitleColor(headerTextColor, for: .normal)
        prevBtn.setTitle("<", for: .normal)
        prevBtn.titleLabel?.font = UIFont.init(name: "EuphemiaUCAS", size: 30.0)
        prevBtn.addTarget(self, action: #selector(prevClicked), for: .touchUpInside)
        self.addSubview(prevBtn)
        
        
        let nextBtn = UIButton.init(type: .custom)
        nextBtn.frame = CGRect(x:50 + titleLabel.frame.size.width, y:0, width:50, height:50)
        nextBtn.backgroundColor = headerBgColor
        nextBtn.setTitleColor(headerTextColor, for: .normal)
        nextBtn.setTitle(">", for: .normal)
        nextBtn.titleLabel?.font = UIFont.init(name: "EuphemiaUCAS", size: 30.0)
        nextBtn.addTarget(self, action: #selector(nextClicked), for: .touchUpInside)
        self.addSubview(nextBtn)
    }
    
    func weekView()
    {
        let selfWidth = self.frame.size.width
        
        let weekV = UIView.init(frame:CGRect(x:0, y:50, width:selfWidth, height:40))
        weekV.backgroundColor = self.weekBgColor
        self.addSubview(weekV)
        
        let xFactor = selfWidth/7
        
        for i in 0...6
        {
            let weekLbl = UILabel.init(frame: CGRect(x: CGFloat(i) * xFactor, y:0, width:xFactor, height:weekV.frame.size.height))
            weekLbl.textColor = self.weekTextColor
            weekLbl.textAlignment = .center
            weekLbl.font = UIFont.systemFont(ofSize: 15.0)
            
            switch i
            {
                case 0:
                    weekLbl.text = "Sun"
                    break
                
                case 1:
                    weekLbl.text = "Mon"
                    break
                    
                case 2:
                    weekLbl.text = "Tue"
                    break
                    
                case 3:
                    weekLbl.text = "Wed"
                    break
                    
                case 4:
                    weekLbl.text = "Thu"
                    break
                    
                case 5:
                    weekLbl.text = "Fri"
                    break
                    
                case 6:
                    weekLbl.text = "Sat"
                    break
                
                default:
                    break
            }
            
            weekV.addSubview(weekLbl)
            
        }
    }
    
    
    func configureCalendarView()
    {
        cellWd = self.frame.size.width / 7.0
        cellHt = floor(cellWd) - 0.5
        
        //print("Screen Scale *** \(UIScreen.main.scale) **")
        
        let layout = UICollectionViewFlowLayout.init()
        layout.minimumLineSpacing = 1.0 //1.0/UIScreen.main.scale
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = .zero
        
        collectionV = UICollectionView.init(frame: CGRect(x: 0, y:90, width:self.frame.size.width, height:cellHt * 5 + 3.5), collectionViewLayout: layout)
        collectionV?.backgroundColor = self.backgroundColor
        collectionV?.isScrollEnabled = false
        collectionV?.register(DayCell.classForCoder(), forCellWithReuseIdentifier:reuseID)
        collectionV?.dataSource = self;
        collectionV?.delegate = self;
        collectionV?.backgroundColor = calBgColor
        
        let layer = CALayer()
        layer.backgroundColor = calBgColor.cgColor
        layer.frame = CGRect(x: 0, y:(collectionV?.frame.size.height)! - 1.0, width:(collectionV?.frame.size.width)!, height:1.0)
        collectionV?.layer.addSublayer(layer)
        
        self.addSubview(collectionV!)
    }
    
   
    
    func reloadCalendarView()
    {
        //print(currentDate)
        titleLabel.text = currentDate.string(format:"MMM yyyy")
        
        lastDay = currentDate.totalDays()
        
        for i in 1...7
        {
            self.datesForWeekDay(weekDayNum: i, monthNum: displayingMonth, yearNum: displayingYear)
            //print(startIndex)
        }
        
        finalDates.removeAllObjects()
        nonSelectableDatesIndexes.removeAllObjects()
        
        var count:Int = 1
        var index:Int = 0
        
        for i in 1...35
        {
            if(i < startIndex)
            {
                finalDates.add(" ")
            }
            else
            {
                if(count <= lastDay)
                {
                    finalDates.add(String.init(format: "%d", count))
                    count += 1
                    if(i == 35 && count <= lastDay)
                    {
                        for j in count...lastDay
                        {
                            //print("\(j) ... \(count) ...\(lastDay) ... \(index) ...")
                            finalDates.replaceObject(at: index, with: String.init(format: "%d", j))
                            index += 1
                        }
                        
                    }
                }
                else
                {
                    finalDates.add(" ")
                }
            }
        }
        
        //print(finalDates)
        collectionV?.reloadData()
    }
    
    // MARK: Collection View
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! DayCell
        
        cell.makeCircular = circular
        
        cell.backgroundColor = UIColor.white
        
        cell.numberLbl.text = String(describing: finalDates.object(at: indexPath.item))
        cell.numberLbl.backgroundColor = datesBgColor
        cell.numberLbl.textColor = datesTextColor
        
        if(selectedDate != nil)
        {
            if let number = Int(cell.numberLbl.text!)
            {
                let selected = getDate(day: number, month: displayingMonth, year: displayingYear)
                
                if(selected == selectedDate)
                {
                    cell.numberLbl.backgroundColor = selectedBgColor
                    cell.numberLbl.textColor = selectedTextColor
                }
            }
        }
        
        if(cell.numberLbl.text == " ")
        {
            cell.isUserInteractionEnabled = false
        }
        else
        {
            cell.isUserInteractionEnabled = true
            
            if(minDate != nil || maxDate != nil)
            {
                enableDisableCell(cell: cell)
            }
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width:cellWd, height:cellHt) //- Double(1.0/UIScreen.main.scale)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath) as! DayCell
        
        cell.numberLbl.backgroundColor = selectedBgColor
        cell.numberLbl.textColor = selectedTextColor
        
        if(selectedIndexPath != nil && indexPath != selectedIndexPath)
        {
            let cell2 = collectionView.cellForItem(at: selectedIndexPath!) as! DayCell
            cell2.numberLbl.backgroundColor = datesBgColor
            cell2.numberLbl.textColor = datesTextColor
            selectedIndexPath = indexPath
        }
        
        selectedIndexPath = indexPath
       
        if let number = Int(cell.numberLbl.text!)
        {
            selectedDate = getDate(day: number, month: displayingMonth, year: displayingYear)
            self.delegate?.didSelectDate!(calendar: self, date: selectedDate!)
        }
    }
    
    func enableDisableCell(cell:DayCell)
    {
        if let number = Int(cell.numberLbl.text!)
        {
            let date = getDate(day: number, month: displayingMonth, year: displayingYear)
            
//            print("********** " + cell.numberLbl.text!)
//            print(date)
//            print(minDate!)
//            print(maxDate)
            
            
            if(minDate != nil)
            {
                if (!(Calendar.current.isDate(date, inSameDayAs: minDate!)))
                {
                    if(date.compare(minDate!) == .orderedAscending)
                    {
                        cell.numberLbl.textColor = cell.numberLbl.textColor.withAlphaComponent(0.25)
                        cell.isUserInteractionEnabled = false
                    }
                }
            }
            
            if(maxDate != nil)
            {
                if(date.compare(maxDate!) == .orderedDescending)
                {
                    cell.numberLbl.textColor = cell.numberLbl.textColor.withAlphaComponent(0.25)
                    cell.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    //MARK: Actions
    
    func prevClicked()
    {
        if(displayingMonth == 1)
        {
            displayingMonth = 12
            displayingYear -= 1
        }
        else
        {
            displayingMonth -= 1
        }
      
        currentDate = getDate(day: 1, month: displayingMonth, year: displayingYear)
        
        reloadCalendarView()
        
    }
    
    func nextClicked()
    {
        if(displayingMonth == 12)
        {
            displayingMonth = 1
            displayingYear += 1
        }
        else
        {
            displayingMonth += 1
        }
        
        currentDate = getDate(day: 1, month: displayingMonth, year: displayingYear)
        
        reloadCalendarView()
    }

    
    // MARK: Date Functions
    
    private func datesForWeekDay(weekDayNum:Int, monthNum:Int, yearNum:Int)
    {
        let date = self.getDate(day: 1, month: monthNum, year: yearNum)
        
        let comps:DateComponents = Calendar.current.dateComponents([.year,.month,.day, .weekday], from: date)
        
        let firstWeekDayNum = comps.weekday
        
        var day = weekDayNum - firstWeekDayNum!
        
        if(day < 0)
        {
            day += 7
        }
        
        day += 1
        
        repeat
        {
            if(day == 1)
            {
                startIndex = weekDayNum
            }
            day += 7
        }
            
        while(day <= lastDay)
    }
    
    private func getDate(day:Int, month:Int, year:Int) -> Date
    {
        var dateComps = DateComponents.init()
        dateComps.day = day
        dateComps.month = month
        dateComps.year = year
        //dateComps.timeZone = NSTimeZone.local
        dateComps.timeZone = NSTimeZone(abbreviation: "GMT") as? TimeZone
        return NSCalendar.current.date(from: dateComps)!
        
    }
   
}
