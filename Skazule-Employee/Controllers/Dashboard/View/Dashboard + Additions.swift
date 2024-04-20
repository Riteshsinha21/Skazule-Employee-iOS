//
//  Dashboard + Additions.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 5/5/23.
//

import Foundation
import UIKit
import SwiftyJSON
import DropDown


extension DashboardVC{
    func intetegrateStartBreakApi(){
        var fullUrl = ""
        
//        isBreakStart == KStart ? ( fullUrl = BASE_URL + PROJECT_URL.END_BREAK) : (fullUrl = BASE_URL + PROJECT_URL.START_BREAK)
        isBreakStart == KStart ? ( fullUrl = BASE_URL + PROJECT_URL.START_BREAK) : (fullUrl = BASE_URL + PROJECT_URL.END_BREAK)
        
        
        //        let fullUrl = BASE_URL + PROJECT_URL.START_BREAK
        let employeeId = String(getEmployeeId())
        let companyId = String(getCompanyId())
        
        let param:[String:String] = [ "employee_id":employeeId,"company_id":companyId]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModelStartBreak?.requestStartBreakApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                var startBreakResponse = StartBreakResponse()
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(StartBreakResponse.self, from: jsonData!)
                    print(responseData)
                    startBreakResponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processStartBreakResponse(receivedData: startBreakResponse)
                //                strongSelf.processCheckOutResponse(receivedData: receivedData)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    func processStartBreakResponse(receivedData:StartBreakResponse){
        let message = receivedData.message
        if receivedData.status == 1{
            //                self.isBreakStart = true
            //                isBreakStart = !isBreakStart
            //                breakButton.setTitle("Break 1 End", for: .normal)
            self.integrateDashboardApi()
            //                showAlert(title: "Message", message: message,viewController: self, okButtonTapped: {
            //                })
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }else{
            let message = receivedData.message
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}
//MARK: Integrate Check In Api
extension DashboardVC{
    func integrateCheckInApi(shiftId:String? = nil){
        
        let fullUrl = BASE_URL + PROJECT_URL.CHECK_IN
        let employeeId = String(getEmployeeId())
        let companyId = String(getCompanyId())
        let shiftIdStr = shiftId ?? "0"
        
        var param:[String:String] = [:]
        if shiftId == nil{
            param = [ "employee_id":employeeId,"company_id":companyId]
        }else{
            param = [ "employee_id":employeeId,"company_id":companyId,"shift_id":shiftIdStr]
        }
        
        //        let param:[String:String] = [ "employee_id":employeeId,"company_id":companyId,"shift_id":shiftIdStr]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModelClockIn?.requestClockInApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                var clockInResponse = ClockInResponse()
                var shiftAvailabilityResponse = ShiftAvailabilityResponse()
                
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    if receivedData["status"] == 1{
                        let responseData = try JSONDecoder().decode(ClockInResponse.self, from: jsonData!)
                        clockInResponse = responseData
                        print(responseData)
                    }else{
                        let responseData = try JSONDecoder().decode(ShiftAvailabilityResponse.self, from: jsonData!)
                        shiftAvailabilityResponse = responseData
                        print(responseData)
                    }
                    //                 print(responseData)
                    //                 clockInResponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                receivedData["status"] == 1 ? strongSelf.processClockInResponse(receivedData: clockInResponse) : strongSelf.processShiftAvailabilityResponse(receivedData: shiftAvailabilityResponse)
                
                //                strongSelf.processClockInResponse(receivedData: receivedData)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    func processShiftAvailabilityResponse(receivedData: ShiftAvailabilityResponse){
        let message = receivedData.message
        if receivedData.status == 0{
            guard let shiftArray = receivedData.data else{return}
            
            //            let checkInStr = gmtToLocal(dateStr: check_in)
            //            let checkOutStr = gmtToLocal(dateStr: check_out)
            //            let timeIntervalStr = "\(shift_name)(\(checkInStr ?? "-") - \(checkOutStr ?? "-"))"
            
            
            dropDownData.removeAll()
            
            if shiftArray.count != 0{
                for item in shiftArray ?? []{
                    let checkInStr = gmtToLocal(dateStr: item.checkIn ?? "")
                    let checkOutStr = gmtToLocal(dateStr: item.checkOut ?? "")
                    let shiftName = item.shiftName ?? ""
                    let timeIntervalStr = "\(shiftName) (\(checkInStr ?? "-") - \(checkOutStr ?? "-"))"
                    dropDownData.append(timeIntervalStr)
                }
                setUpDropDown(shiftData: shiftArray)
            }else{
                UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
            }
        }else{
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
    
    func setUpDropDown(shiftData:[ShiftAvailabilityData]){
        
        DropDown.appearance().selectionBackgroundColor = UIColor.clear
        dropDown.backgroundColor = UIColor.white
        dropDown.bottomOffset = CGPoint(x: 0, y: clockInButton.bounds.height)
        dropDown.anchorView = clockInButton
        dropDown.dataSource = dropDownData
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index:Int,item:String) in
            print("Selected item: \(item) at index: \(index)")
            
            if let shiftId = shiftData[index].id{
                integrateCheckInApi(shiftId: "\(shiftId)")
            }
        }
    }
    
    func processClockInResponse(receivedData:ClockInResponse){
        let message = receivedData.message
        if receivedData.status == 1{
            
            self.shiftId = receivedData.data?[0].shiftID ?? 0
            
            //          self.shiftId = receivedData.data?.shiftID
            self.integrateDashboardApi()
            //                showAlert(title: "Message", message: message,viewController: self, okButtonTapped: {
            //                })
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }else{
            let message = receivedData.message
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
}
//MARK: Integrate Check Out Api
extension DashboardVC{
    func integrateCheckOutApi(){
        
        let fullUrl = BASE_URL + PROJECT_URL.CHECK_OUT
        let employeeId = String(getEmployeeId())
        let companyId = String(getCompanyId())
        let shiftId = "\(String(describing: self.shiftId))"
        
        let param:[String:String] = [ "employee_id":employeeId,"company_id":companyId,"shift_id":shiftId]
        
        print(param)
        if Reachability.isConnectedToNetwork() {
            // showProgressOnView(appDelegateInstance.window!)
            showProgressOnView(self.view)
            self.viewModelClockOut?.requestClockOutApi(apiName: fullUrl, param: param, completion: {[weak self] (receivedData) in
                print(receivedData)
                hideAllProgressOnView(self!.view)
                var clockOutResponse = ClockOutResponse()
                do{
                    let jsonData = self?.getDataFrom(JSON: receivedData)
                    print(String(data: jsonData!, encoding: .utf8)!)
                    let responseData = try JSONDecoder().decode(ClockOutResponse.self, from: jsonData!)
                    print(responseData)
                    clockOutResponse = responseData
                }catch let error{
                    print(error.localizedDescription)
                }
                guard let strongSelf = self else { return }
                
                strongSelf.processCheckOutResponse(receivedData: clockOutResponse)
                //                strongSelf.processCheckOutResponse(receivedData: receivedData)
            })
        }else{
            showLostInternetConnectivityAlert()
        }
    }
    func processCheckOutResponse(receivedData:ClockOutResponse){
        let message = receivedData.message
        if receivedData.status == 1{
            self.isCheckOut = true
            self.isCheckIn = false
            resetData()
            //                self.integrateDashboardApi()
            //                showAlert(title: "Message", message: message,viewController: self, okButtonTapped: {
            //                })
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }else{
            let message = receivedData.message
            UIAlertController.showInfoAlertWithTitle("Message", message: message, buttonTitle: "Okay")
        }
    }
    func resetData(){
        // ******** Resete data to zero  *************
        isCheckIn = false
        self.checkInLabel.text = "Check In : 0"
        self.checkOutLabel.text =  "Check Out : 0"
        self.breakHoursLabel.text = "Break Hours : 0"
        isBreakStart = KStart
    }
}
