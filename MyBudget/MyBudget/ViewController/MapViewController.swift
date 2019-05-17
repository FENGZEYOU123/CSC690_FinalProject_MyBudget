//
//  MapViewController.swift
//  MyBudget
//
//  Created by Zeyuan Cai on 2018/04/12.
//  Copyright © 2019 Zeyuan Cai. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
//代理,反向传值
protocol MapDelegate {
    func didDelegateText(text: String)
}
class MapViewController: UIViewController,MKMapViewDelegate {

     var delegate: MapDelegate?
    var address : String = ""
    @IBOutlet weak var mapView: MKMapView!
    
    lazy var locationM: CLLocationManager = {
        let locationM = CLLocationManager()
        if #available(iOS 8.0, *) {
            locationM.requestAlwaysAuthorization()
        }
        return locationM
        }()
    
    @IBAction func TouchDone(_ sender: Any) {
        if(address.count == 0){
            showAlertView(text: "Error, Please try it again.")
        }else{
            delegate?.didDelegateText(text: address)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置地图样式
        //        case Standard 标准
        //        case Satellite // 卫星
        //        case Hybrid // 混合(标准加卫星)
        //        @available(iOS 9.0, *)
        //        case SatelliteFlyover 3D立体卫星
        //        @available(iOS 9.0, *)
        //        case HybridFlyover 3D立体混合
        //          mapView.mapType = MKMapType.satellite
        mapView.mapType = MKMapType.standard
        
        // 设置地图的控制项
        //        mapView.scrollEnabled = false
        //        mapView.rotateEnabled = false
        //        mapView.zoomEnabled = false
        
        // 设置地图的显示项
        // 建筑物
        mapView.showsBuildings = true
        // 指南针
        if #available(iOS 9.0, *) {
            mapView.showsCompass = true
            // 比例尺
            mapView.showsScale = true
            // 交通状况
            mapView.showsTraffic = true
        }
        // poi兴趣点
        mapView.showsPointsOfInterest = true
        
        
        // 1. 显示用户位置
        _ = locationM
        mapView.showsUserLocation = true
        
        // 2. 用户的追踪模式
        //        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        mapView.delegate = self
    }
    
    // 当地图更新用户位置信息时调用
    // 蓝点: 大头针"视图"  大头针"数据模型"
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // MKUserLocation: 大头针数据模型
        // location : 者就是大头针的位置信息(经纬度)
        // heading: 设备朝向
        // title: 弹框标题
        // subtitle: 弹框子标题
        
        // 移动地图的中心,显示在当前用户所在的位置
        //        mapView.setCenter(userLocation.coordinate, animated: true)
        
        // 设置地图显示区域
        let center = (userLocation.coordinate)
        let span = MKCoordinateSpan(latitudeDelta: 0.0219952102009202, longitudeDelta: 0.0160932558432023)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        
        LonLatToCity()
    }
    
    //区域改变的时候调用
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta)
    }
    
    
    ///将经纬度转换为城市名
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locationM.location!) { (placemark, error) -> Void in
            
            if(error == nil)
            {
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                //Street Location
                let FormattedAddressLines: NSString = ((mark.addressDictionary! as NSDictionary).value(forKey: "FormattedAddressLines") as AnyObject).firstObject as! NSString
                //Exact Location
                let Name: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Name") as! NSString
                
                self.address = (FormattedAddressLines as String)+(Name as String)
                print(self.address)
            }
            else
            {
                print(error)
            }
        }
        
        
    }
    
    //显示警告框
    @objc func showAlertView( text:String) {
        let av = UIAlertController(title: "", message: text as String, preferredStyle: .alert)
        av.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(av, animated: true, completion: nil)
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
