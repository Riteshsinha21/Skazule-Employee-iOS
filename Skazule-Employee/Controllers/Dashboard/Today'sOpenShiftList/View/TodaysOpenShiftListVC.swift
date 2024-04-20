//
//  TodaysOpenShiftListVC.swift
//  Skazule-Employee
//
//  Created by Anita Singh on 9/27/23.
//

import UIKit

class TodaysOpenShiftListVC: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: VAriable
//    var todayOpenShiftArr       = [TodayOpenShiftDataStruct]()
//    var todayOpenShiftDetailArr = [OpenScheduleDataStruct]()
    
      var todaysOpenShiftArr = [OpenShift]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureTableView()
    }
    
    //MARK: Private functions
    private func configureNavigationBar(){
        self.customNavigationBar.titleLabel.text = "Today's Open Shift"
        customNavigationBar.customRightBarButton.isHidden = true
    }
    private func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TodaysOpenShiftTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TodaysOpenShiftTableViewCell")
    }
}
//MARK: Table View Delegate and Data Source
extension TodaysOpenShiftListVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.todaysOpenShiftArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodaysOpenShiftTableViewCell", for: indexPath) as? TodaysOpenShiftTableViewCell else{return UITableViewCell()}
        let info = self.todaysOpenShiftArr[indexPath.row ]
        cell.selectionStyle = .none
        cell.configureCell(info: info, index: indexPath.row)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let info = self.todaysOpenShiftArr[indexPath.row]
        let vc = ViewOpenShiftVC()
        let openShift = OpenSchedule.init(nubmerOfOpening: info.nubmerOfOpening, scheduleID: info.scheduleID, checkOut: info.checkOut, colorCode: info.colorCode, note: info.note, nubmerOfAssignedOpening: info.nubmerOfAssignedOpening, checkIn: info.checkIn, restOpening: 0, date: info.date, shiftName: info.shiftName, breakDuration: info.breakDuration, position: info.position,tags: info.tags)
 //       print(info)
        vc.info = openShift
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        100
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        UITableView.automaticDimension
    }
}
