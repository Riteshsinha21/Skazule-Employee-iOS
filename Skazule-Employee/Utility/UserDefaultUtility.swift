//
//  UserDefaultUtility.swift
//  Skazule-Employee
//
//  Created by Ashish Nimbria on 4/5/23.
//

import Foundation

//MARK: Get Device Token
func getDeviceToken() -> String {
    if let deviceToken = UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN) as? String {
        return deviceToken
    }
    return "abc"
}

func saveLoginToken(token: String){
    UserDefaults.standard.set(token, forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN)
}
func getLoginToken() -> String{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.LOGIN_TOKEN) as? String ?? "abc"
}
func saveFCMKey(fcmKey: String){
    UserDefaults.standard.set(fcmKey, forKey: USER_DEFAULTS_KEYS.FCM_KEY)
}
func getFCMKey() -> String{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.FCM_KEY) as? String ?? ""
}
func saveIsLogin(isLogin: Bool){
    UserDefaults.standard.set(isLogin, forKey: USER_DEFAULTS_KEYS.IS_LOGIN)
}
func getIsLogin() -> Bool{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.IS_LOGIN) as? Bool ?? false
}
func saveIsRememberUser(isRememberUser: Bool){
    UserDefaults.standard.set(isRememberUser, forKey: USER_DEFAULTS_KEYS.IS_REMEMBER_USER)
}
func getIsRememberUser() -> Bool{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.IS_REMEMBER_USER) as? Bool ?? false
}

func saveEmployeeEmail(employeeEmail: String){
    UserDefaults.standard.set(employeeEmail, forKey: USER_DEFAULTS_KEYS.EMPLOYEE_EMAIL)
}
func getEmployeeEmail() -> String{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_EMAIL) as? String ?? ""
}
func saveEmployeePassword(employeePassword: String){
    UserDefaults.standard.set(employeePassword, forKey: USER_DEFAULTS_KEYS.EMPLOYEE_PASSWORD)
}
func getEmployeePassword() -> String{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_PASSWORD) as? String ?? ""
}
func saveCompanyId(companyId: Int){
    UserDefaults.standard.set(companyId, forKey: USER_DEFAULTS_KEYS.COMPANY_ID)
}
func getCompanyId() -> Int{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COMPANY_ID) as? Int ?? 0
}
func saveEmployeeId(employeeId: Int){
    UserDefaults.standard.set(employeeId, forKey: USER_DEFAULTS_KEYS.EMPLOYEE_ID)
}
func saveUserId(userId: Int)
{
    UserDefaults.standard.set(userId, forKey: USER_DEFAULTS_KEYS.USER_ID)
}
func saveRoleId(roleId: Int){
    UserDefaults.standard.set(roleId, forKey: USER_DEFAULTS_KEYS.ROLE_ID)
}
func saveFirebaseUserId(userId: String){
    UserDefaults.standard.set(userId, forKey: USER_DEFAULTS_KEYS.EMPLOYEE_FIREBASE_ID)
}

func getUserId() -> Int{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.USER_ID) as? Int ?? 0
}
func getRoleId() -> Int{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.ROLE_ID) as? Int ?? 0
}
func getEmployeeId() -> Int{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_ID) as? Int ?? 0
}
func getFirebaseUserId() -> String{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_FIREBASE_ID) as? String ?? ""
}

func saveIndustryId(industryId: Int){
    UserDefaults.standard.set(industryId, forKey: USER_DEFAULTS_KEYS.INDUSTRY_ID)
}
func getIndustryId() -> Int{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.INDUSTRY_ID) as? Int ?? 0
}

func getEmail() -> String{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.EMAIL) as? String ?? ""
}

func saveCCode(cCode: String){
    UserDefaults.standard.set(cCode, forKey: USER_DEFAULTS_KEYS.C_CODE)
}
func getCCode() -> String{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.C_CODE) as? String ?? ""
}
func saveMobileNo(mobileNo: String){
    UserDefaults.standard.set(mobileNo, forKey: USER_DEFAULTS_KEYS.MOBILE_NO)
}
func getMobileNo() -> String{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.MOBILE_NO) as? String ?? ""
}
func saveCompanyName(companyName: String){
    UserDefaults.standard.set(companyName, forKey: USER_DEFAULTS_KEYS.COMPANY_NAME)
}
func getCompanyName() -> String{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.COMPANY_NAME) as? String ?? ""
}

func saveEmployeeName(employeeName: String){
    UserDefaults.standard.set(employeeName, forKey: USER_DEFAULTS_KEYS.EMPLOYEE_NAME)
}
func getEmployeeName() -> String{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_NAME) as? String ?? ""
}

func saveEmployeeProfilePic(employeeProfilePic: String){
    UserDefaults.standard.set(employeeProfilePic, forKey: USER_DEFAULTS_KEYS.EMPLOYEE_PROFILE_PIC)
}
func getEmployeeProfilePic() -> String{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.EMPLOYEE_PROFILE_PIC) as? String ?? ""
}
func saveEmployeeCheckIn(employeeCheckIn:String){
    UserDefaults.standard.setValue(employeeCheckIn, forKey: USER_DEFAULTS_KEYS.CHECK_IN)
}
func getEmployeeCheckIn() -> String{
    return UserDefaults.standard.value(forKey: USER_DEFAULTS_KEYS.CHECK_IN) as? String ?? ""
}
