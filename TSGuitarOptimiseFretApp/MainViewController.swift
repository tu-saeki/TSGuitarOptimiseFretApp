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
    
    // ピッカビューの回転角
    var rotationAngle : CGFloat!

    // 入力された音階
    var toneIds : [Int] = []
    var toneNames : [String] = []
    
    // 検索された弦
    var stringIds : [Int] = []
    var stringNames : [String] = []
    
    // フレット
    var fretIds : [Int] = []
    var fretNames : [String] = []
    
    // 指
    var fingerIds : [Int] = []
    var fingerNames : [String] = []
    
    // 各種制御フラグ
    var screenStateId : Int = KB.SCREEN_STATE_ID_ONLY_TONES_VISIBLE
    var tonesSelectedId : Int = 0
    var resultsSelectedId : Int = 0
    var lastChangedSelectedId : Int = KB.PICKERVIEW_TONE_TAG
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ピッカービューを初期化する
        initPickerView()

        // ピッカービューの同期を取る
        syncPickerView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*------- ピッカービュに関する処理　-------*/
    
    // ピッカービューを初期化する
    func initPickerView () {
        
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
    
    // pickerViewで表示する列数を定義する
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        var tmpNumRows = 0
        
        switch(pickerView.tag) {
            
        case KB.PICKERVIEW_TONE_TAG:
            tmpNumRows = 1
            
        case KB.PICKERVIEW_STRINGFRETFINGER_TAG:
            tmpNumRows = 3
            
        default:
            break
        }
        
        return tmpNumRows
    }
    
    // pickerViewで表示する行数を定義する
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var tmpCount : Int = 0
        
        switch (pickerView.tag) {
            
        case KB.PICKERVIEW_TONE_TAG :
            tmpCount = toneNames.count
            
        case KB.PICKERVIEW_STRINGFRETFINGER_TAG:
            
            switch (component) {
                
            // 弦
            case 0:
                tmpCount = stringNames.count
                
            // フレット
            case 1:
                tmpCount = fretNames.count
                
            // 指
            case 2:
                tmpCount = fingerNames.count
                
            default:
                break
            }
            
        default:
            break
        }
        
        return tmpCount
    }
    
    // pickerViewで表示する文字列を定義する
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        var tmpStr : String = ""
        
        switch (pickerView.tag) {
            
        case KB.PICKERVIEW_TONE_TAG:

            tmpStr = toneNames[row]
            
        case KB.PICKERVIEW_STRINGFRETFINGER_TAG:
            
            switch(component) {
                
            // 弦
            case 0:
                tmpStr = stringNames[row]
                
            // フレット
            case 1:
                tmpStr = fretNames[row]
                
            // 指
            case 2:
                tmpStr = fingerNames[row]
                
            default:
                break
            }
            
        default:
            break
        }
        
        return tmpStr
    }
    
    // pickerViewが選択された時の処理を定義する
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // 選択状態のIDを更新する
        switch (pickerView.tag) {
            
        case KB.PICKERVIEW_TONE_TAG:
        
            tonesSelectedId = row
            lastChangedSelectedId = pickerView.tag
            
        case KB.PICKERVIEW_STRINGFRETFINGER_TAG:
            
            resultsSelectedId = row
            lastChangedSelectedId = pickerView.tag
            
        default:
            break
        }

        // 必要があれば、PickerViewの選択IDを同期する
        syncPickerView()
        
        // （直接同期する場合）反対側のPickerViewの同期を取る
//        switch (pickerView.tag) {
//            
//        case 0:
//            
//            // はじめに表示する項目を指定
//            stringFretFingerPickerView.selectRow(row, inComponent: 0, animated: true)
//            
//        case 1:
//            
//            // はじめに表示する項目を指定
//            tonePickerView.selectRow(row, inComponent: 0, animated: true)
//            
//        default:
//            break
//            
//        }
    }
    
    // PickerViewの選択IDの同期を取る
    func syncPickerView () {

        switch (screenStateId) {
            
        // 音階値入力画面のみが表示されている場合
        case KB.SCREEN_STATE_ID_ONLY_TONES_VISIBLE :
            
            // 音階PickerView側の表示を反映する
            initToneText()
            tonePickerView.reloadAllComponents()
            
            if(toneIds.count > 0){
                
                tonePickerView.selectRow(tonesSelectedId, inComponent: 0, animated: true)
            }
            
            // 結果PickerView側を非表示にする
            stringFretFingerPickerView.isHidden = true
            print("is hidden 1")
            
        // 結果画面と音階値入力画面が同期されている場合
        case KB.SCREEN_STATE_ID_TONES_RESULTS_SYNCHRONIZED:
            
            // 選択IDを同期する
            switch (lastChangedSelectedId) {
                
            case KB.PICKERVIEW_TONE_TAG:
                
                resultsSelectedId = tonesSelectedId
                
            case KB.PICKERVIEW_STRINGFRETFINGER_TAG:
                
                tonesSelectedId = resultsSelectedId
                
            default:
                break
            }
            
            // PickerViewの内容を同期する
            initToneText()
            tonePickerView.reloadAllComponents()
            
            if(toneIds.count > 0){
                
                tonePickerView.selectRow(tonesSelectedId, inComponent: 0, animated: true)
            }
            
            initStringText()
            initFretText()
            initFingerText()
            
            if(stringIds.count > 0 && fretIds.count > 0 && fingerIds.count > 0){
                
                stringFretFingerPickerView.selectRow(resultsSelectedId, inComponent: 0, animated: true)
            }
            
            // 結果PickerView側を表示にする
            stringFretFingerPickerView.isHidden = false
                        print("is not hidden 2")
            
        // 結果画面と音階値入力画面が同期されていない場合
        case KB.SCREEN_STATE_ID_TONES_RESULTS_ASYNCHRONIZED:
            
            // 最後に変更された側のPickerViewを同期する
            switch(lastChangedSelectedId) {
                
            case KB.PICKERVIEW_TONE_TAG:
                
                initToneText()
                tonePickerView.reloadAllComponents()
                
                if(toneIds.count > 0){
                    
                    tonePickerView.selectRow(tonesSelectedId, inComponent: 0, animated: true)
                }
                
            case KB.PICKERVIEW_STRINGFRETFINGER_TAG:
                
                initStringText()
                initFretText()
                initFingerText()
                
                if(stringIds.count > 0 && fretIds.count > 0 && fingerIds.count > 0){
                    
                    stringFretFingerPickerView.selectRow(resultsSelectedId, inComponent: 0, animated: true)
                }
                
            default:
                break
            }
            
            // 結果PickerView側を表示にする
            stringFretFingerPickerView.isHidden = false
                                    print("is not hidden 3")
            
        default:
            break
        }
    }
    
    
    /*------- 表示テキストに関する処理　-------*/
    
    // 音階値用のテキストを生成する
    func initToneText () {
        
        toneNames.removeAll()
        
        for i in 0 ..< toneIds.count {
            
            toneNames.append(KB.getToneName(tone: toneIds[i], accidentalId: KB.getMusicNoteAccidentalId()))
        }
    }
    
    // 弦用のテキストを生成する
    func initStringText () {
        
        stringNames.removeAll()
        
        for i in 0 ..< stringIds.count {
            
            stringNames.append(KB.MUSIC_GUITAR_STRINGS_NAMES[i])
        }
    }
    
    // フレット用のテキストを生成する
    func initFretText () {
        
        fretNames.removeAll()
        
        for i in 0 ..< fretIds.count {

            // 解放弦の場合
            if(fretIds[i] <= 0) {
                
                fretNames.append("解放")
            }
            else {
                
                fretNames.append(String(fretIds[i]))
            }
        }
    }
    
    // 指用のテキストを生成する
    func initFingerText () {
        
        fingerNames.removeAll()
        
        for i in 0 ..< fingerIds.count {
            
            // 解放弦の場合
            if(fingerIds[i] <= 0){
                
                fingerNames.append("-")
            }
            // それ以外の場合
            else {
                
                fingerNames.append(String(fingerIds[i]))
            }
        }
    }
    
    /*------- 各種ボタンに関する処理　-------*/
    
    // 編集ボタンが押された時の処理
    @IBAction func onEditButtonPushed () {
        
        // ギターの最高音・最低音を取得する
        let minMaxToneIds = KB.getMinMaxToneIds()

        // 音選択ダイアログを取得する
        let alert = UIAlertController(title: "音の選択", message: "", preferredStyle: .alert)
        
        // ボタンを設置する
        for i in minMaxToneIds[0] ..< minMaxToneIds[1] + 1 {
            
            let tmpAction = UIAlertAction(title: KB.getToneName(tone: i, accidentalId: KB.getMusicNoteAccidentalId()), style: .default, handler: { (action) in
                
                // 音が既に入力されていた場合
                if(self.toneIds.count > 0){
                    
                    // 音を変更する
                    self.toneIds[self.tonesSelectedId] = i
                    self.lastChangedSelectedId = KB.PICKERVIEW_TONE_TAG
                }
                // 1音も入力されていない状態の場合
                else {
                    
                    // 音を追加する
                    self.toneIds.append(i)
                    
                    // PickerViewの選択IDを更新する
                    self.tonesSelectedId = self.toneIds.count - 1
                    self.lastChangedSelectedId = KB.PICKERVIEW_TONE_TAG
                }
                
                // 表示モードを非同期に切り替える
                if(self.screenStateId != KB.SCREEN_STATE_ID_ONLY_TONES_VISIBLE){
                    
                    self.screenStateId = KB.SCREEN_STATE_ID_TONES_RESULTS_ASYNCHRONIZED
                }
                
                // PickerViewの同期を取る
                self.syncPickerView()
                
                // ダイアログを閉じる
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(tmpAction)
        }
        
        // ダイアログを表示する
        self.present(alert, animated: true, completion: nil)
    }
    
    // 戻るボタンが押された時の処理
    @IBAction func onPrevButtonPushed () {
        
        // 選択IDを一つ戻す
        if(tonesSelectedId > 0){
            
            tonesSelectedId = tonesSelectedId - 1
            lastChangedSelectedId = KB.PICKERVIEW_TONE_TAG
            
            // PickerViewの同期を取る
            syncPickerView()
        }
        // それ以外の場合、アラートを表示する
        else {
            
            // ダイアログを取得する
            let alert = UIAlertController(title: "エラー", message: "これ以上戻れません。", preferredStyle: .alert)
            
            // アクションを追加する
            let tmpAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                // ダイアログを閉じる
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(tmpAction)
            
            // ダイアログを表示する
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // 進むボタンが押された時の処理
    @IBAction func onNextButtonPushed () {
        
        // 配列の範囲内の場合、次に進める
        if(tonesSelectedId < toneIds.count - 1) {
            
            tonesSelectedId = tonesSelectedId + 1
            lastChangedSelectedId = KB.PICKERVIEW_TONE_TAG
            
            // PickerViewの同期を取る
            syncPickerView()
        }
        // 配列の範囲外の場合、音を追加する
        else {
            
            // ギターの最高音・最低音を取得する
            let minMaxToneIds = KB.getMinMaxToneIds()
            
            // 音選択ダイアログを取得する
            let alert = UIAlertController(title: "音の追加", message: "", preferredStyle: .alert)
            
            // ボタンを設置する
            for i in minMaxToneIds[0] ..< minMaxToneIds[1] + 1 {
                
                let tmpAction = UIAlertAction(title: KB.getToneName(tone: i, accidentalId: KB.getMusicNoteAccidentalId()), style: .default, handler: { (action) in
                    
                    // 音を追加する
                    self.toneIds.append(i)
                    
                    // 表示モードを非同期に切り替える
                    if(self.screenStateId != KB.SCREEN_STATE_ID_ONLY_TONES_VISIBLE){
                        
                        self.screenStateId = KB.SCREEN_STATE_ID_TONES_RESULTS_ASYNCHRONIZED
                    }
                    
                    // PickerViewの選択IDを更新する
                    self.tonesSelectedId = self.toneIds.count - 1
                    self.lastChangedSelectedId = KB.PICKERVIEW_TONE_TAG
                    
                    // PickerViewの同期を取る
                    self.syncPickerView()
                    
                    // ダイアログを閉じる
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(tmpAction)
            }
            
            // ダイアログを表示する
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // 削除ボタンが押された時の処理
    @IBAction func onDeleteButtonPushed () {
        
        // 対象の配列要素が存在する場合、音を削除する
        if(toneIds.count > 0 && 0 <= tonesSelectedId && tonesSelectedId < toneIds.count) {
            
            // 音を削除する
            toneIds.remove(at: tonesSelectedId)
            
            // 表示モードを非同期に切り替える
            if(self.screenStateId != KB.SCREEN_STATE_ID_ONLY_TONES_VISIBLE){
                
                self.screenStateId = KB.SCREEN_STATE_ID_TONES_RESULTS_ASYNCHRONIZED
            }
            
            // PickerViewの同期を取る
            tonesSelectedId = tonesSelectedId - 1
            lastChangedSelectedId = KB.PICKERVIEW_TONE_TAG
            
            syncPickerView()
        }
        // それ以外の場合、アラートを表示する
        else {
            
            // ダイアログを取得する
            let alert = UIAlertController(title: "削除エラー", message: "削除できません。", preferredStyle: .alert)
            
            // アクションを追加する
            let tmpAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                // ダイアログを閉じる
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(tmpAction)
            
            // ダイアログを表示する
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // 検索ボタンが押された時の処理
    @IBAction func onSearchButtonPushed () {
        
        // 音が未入力だった場合には、処理を行わない
        if(toneIds.count <= 1) {
            
            // ダイアログを取得する
            let alert = UIAlertController(title: "検索エラー", message: "音を2音以上入力してください。", preferredStyle: .alert)
            
            // アクションを追加する
            let tmpAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                // ダイアログを閉じる
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(tmpAction)
            
            // ダイアログを表示する
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // 検索時間の記録を開始する
        let startTime = Date().timeIntervalSince1970
        
        // 検索結果を取得する
        var tmpStringFretFingerIds : [[Int]] = []
        tmpStringFretFingerIds = KB.getOptimiseStringIdFretIdFingerIds(tones: toneIds, numSearch: 100)

        // 検索所要時間を算出する
        let procTime = Date().timeIntervalSince1970 - startTime
        let sec = Int(procTime)
        let msec = Int((procTime - Double(sec)) * 100)
        let procTimeStr : String = NSString(format: "%02d:%02d.%02d", sec / 60, sec % 60, msec) as String!
        
        // これまでの検索結果を破棄する
        stringIds.removeAll()
        fretIds.removeAll()
        fingerIds.removeAll()
        
        // フィールド変数に結果を格納する
        for i in 0 ..< tmpStringFretFingerIds.count {
            
            stringIds.append(tmpStringFretFingerIds[i][0])
            fretIds.append(tmpStringFretFingerIds[i][1])
            fingerIds.append(tmpStringFretFingerIds[i][2])
        }
        
        // ダイアログを表示する
        let alert = UIAlertController(title: "検索成功", message: "検索が完了しました！ /n検索回数：" + String(100) + ", 計算時間：" + procTimeStr, preferredStyle: .alert)
        let tmpAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            // ダイアログを閉じる
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(tmpAction)
        self.present(alert, animated: true, completion: nil)
        
        // 表示モードを同期状態に切り替える
        screenStateId = KB.SCREEN_STATE_ID_TONES_RESULTS_SYNCHRONIZED
        
        // PickerViewの同期を取る
        syncPickerView()
    }
    
}
