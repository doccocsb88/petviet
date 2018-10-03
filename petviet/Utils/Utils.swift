//
//  Utils.swift
//  petviet
//
//  Created by Macintosh HD on 9/23/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
import Photos
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        var result: String = ""
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if seconds(from: date) > 0 { return "\(seconds(from: date))" }
        if days(from: date)    > 0 { result = result + " " + "\(days(from: date)) D" }
        if hours(from: date)   > 0 { result = result + " " + "\(hours(from: date)) H" }
        if minutes(from: date) > 0 { result = result + " " + "\(minutes(from: date)) M" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))" }
        return ""
    }
    func caculateTimeToNow() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        //        let stdate : String = "2018-06-02 10:11:12"
        //        let startDate = dateFormatter.date(from: stdate)!
        
        let differ = Date().millisecondsSince1970 -  self.millisecondsSince1970
        NSLog("differ : %ld", differ)
        let seconds = differ /  1000
        let mins = seconds / 60
        let hours = mins / 60
        let days = hours / 24
        let weaks = days / 7
        let months = weaks / 4
        let years = months / 12
        var timeString = ""
        if years > 0{
            timeString = "\(years) năm trước"
            
        }else if months > 0{
            timeString = "\(months) tháng trước"
            
        }else if weaks > 0{
           timeString = "\(weaks) tuần trước"
            
        }else if days > 0{
            timeString = "\(days) ngày trước"
            
        }else if hours > 0{
           timeString = "\(hours) giờ trước"
            
        }else if mins > 0{
            timeString = "\(mins) phút trước"
            
        }else if seconds > 0{
           timeString = "\(seconds) giây trước"
            
        }else {
            timeString = "Vừa xong"
        }
        
        return timeString
    }
}
extension PHAsset {
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
extension String{
    static func randomString(length : Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = Array(charSet)
        var s:String = ""
        for _ in 1...length {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }
    func verifyUrl () -> Bool {
        //Check for nil
            // create NSURL instance
        if let url = URL(string: self) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url)
        }
        
        return false
    }
    func getYoutubeId() ->String?{
        if self.contains("v=") {
            if self.contains("&"){
                let url = self.components(separatedBy: "&")[0]
                return url.components(separatedBy: "=")[1]
            }else{
                return self.components(separatedBy: "=")[1]
                
            }
        }
        return nil
    }
    
    func getYoutubeThumbnail() ->String?{
        if let youtubeId = self.getYoutubeId()  {
            let thumbnailPath = String(format: "https://img.youtube.com/vi/%@/mqdefault.jpg", youtubeId)
            return thumbnailPath
        }
        return nil
    }
}

class Utils{
    static func convertToJSON(_ dict:[String:Any]) ->String{
//        var error : NSError?
        
        let jsonData = try! JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        return jsonString
        
    }
    
    static func convertToDict(_ text:String) ->[String:Any]?{
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                print(json)
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return [:]
    }
}

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}

extension Float{
    func formattedNumber()->String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:self))
        return formattedNumber ?? ""
    }
}
