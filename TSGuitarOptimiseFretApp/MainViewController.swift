//
//  MainViewController.swift
//  TSGuitarOptimiseFretApp
//
//  Created by nttr on 2017/09/06.
//  Copyright © 2017年 nttr. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // ピッカービュー
    @IBOutlet var tonePickerView : UIPickerView!
    @IBOutlet var stringFretFingerPickerView : UIPickerView!
    
    // 回転角
    var rotationAngle : CGFloat!
    
    // 音階
    var toneIds : [Int] = []
    var toneNames : [String] = ["高ミ", "高シ", "高シ", "高ファ", "高ミ", "高ミ"]
    
    // 弦
    var stringIds : [Int] = []
    var stringNames : [String] = ["2", "1", "1", "2", "2", "2"]
    
    // フレット
    var fretIds : [Int] = []
    var fretNames : [String] = ["5", "7", "7", "7", "5", "5"]
    
    // 指
    var fingerIds : [Int] = []
    var fingerNames : [String] = ["人", "小", "小", "薬", "人", "人"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rotationAngle = -90 * (.pi / 180)
        
        var y = tonePickerView.frame.origin.y
        tonePickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        tonePickerView.frame = CGRect(x: -100, y: y, width: view.frame.width + 200, height: 100)
        
        tonePickerView.tag = 0
        
        y = stringFretFingerPickerView.frame.origin.y
        stringFretFingerPickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        stringFretFingerPickerView.frame = CGRect(x: -100, y: y, width: view.frame.width + 200, height: 100)
        
        
        stringFretFingerPickerView.tag = 1
        
        tonePickerView.dataSource = self
        tonePickerView.delegate = self
        
        stringFretFingerPickerView.dataSource = self
        stringFretFingerPickerView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // pickerViewで表示する列数を定義する
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        var tmpNumRows = 0
        
        switch(pickerView.tag) {
            
        case 0:
            tmpNumRows = 1
            
        case 1:
            tmpNumRows = 3
            
        default:
            break
        }
        
        return 1
    }
    
    // pickerViewで表示する行数を定義する
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var tmpCount : Int = 0
        
        switch (pickerView.tag) {
            
        case 0 :
            tmpCount = toneNames.count
            
        case 1:
            tmpCount = stringNames.count
            
        default:
            break
        }
        
        return tmpCount
    }
    
    // pickerViewで表示する文字列を定義する
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        var tmpStr : String = ""
        
        switch (pickerView.tag) {
            
        case 0:
            tmpStr = toneNames[row]
            
        case 1:
            tmpStr = stringNames[row]
            
        default:
            break
        }
        
        return tmpStr
    }
    
    // pickerViewが選択された時の処理を定義する
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch (pickerView.tag) {
            
        case 0:
            
            // はじめに表示する項目を指定
            stringFretFingerPickerView.selectRow(row, inComponent: 0, animated: true)
            
        case 1:
            
            // はじめに表示する項目を指定
            tonePickerView.selectRow(row, inComponent: 0, animated: true)
            
        default:
            break
            
        }
        
        // selectedToneIds[pickerView.tag] = row
    }

    
}
