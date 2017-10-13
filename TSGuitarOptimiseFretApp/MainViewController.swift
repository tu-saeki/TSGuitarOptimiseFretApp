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
    
    // ラベル
    @IBOutlet var stringLabel : UILabel!
    @IBOutlet var fretLabel : UILabel!
    @IBOutlet var fingerLabel : UILabel!
    @IBOutlet var toneLabel : UILabel!
    @IBOutlet var howtoLabel : UILabel!
    @IBOutlet var howtoLabelImageView : UIImageView!
    @IBOutlet var resultPattern1Button : UIButton!
    @IBOutlet var resultPattern2Button : UIButton!
    @IBOutlet var resultPattern3Button : UIButton!
    @IBOutlet var resultPattern4Button : UIButton!
    @IBOutlet var resultPattern5Button : UIButton!
    
    // ボタン
    @IBOutlet var prevButton : UIButton!
    @IBOutlet var nextButton : UIButton!
    @IBOutlet var editButton : UIButton!
    @IBOutlet var deleteButton : UIButton!
    @IBOutlet var searchButton : UIButton!
    
    // フレットビュー
    @IBOutlet var stringId0Label : UILabel!
    @IBOutlet var stringId1Label : UILabel!
    @IBOutlet var stringId2Label : UILabel!
    @IBOutlet var stringId3Label : UILabel!
    @IBOutlet var stringId4Label : UILabel!
    @IBOutlet var stringId5Label : UILabel!
    @IBOutlet var fretId0Label : UILabel!
    @IBOutlet var fretId1Label : UILabel!
    @IBOutlet var fretId2Label : UILabel!
    @IBOutlet var openStringId0Label : UILabel!
    @IBOutlet var openStringId1Label : UILabel!
    @IBOutlet var openStringId2Label : UILabel!
    @IBOutlet var openStringId3Label : UILabel!
    @IBOutlet var openStringId4Label : UILabel!
    @IBOutlet var openStringId5Label : UILabel!
    @IBOutlet var fret00ImageView : UIImageView!
    @IBOutlet var fret01ImageView : UIImageView!
    @IBOutlet var fret02ImageView : UIImageView!
    @IBOutlet var fret10ImageView : UIImageView!
    @IBOutlet var fret11ImageView : UIImageView!
    @IBOutlet var fret12ImageView : UIImageView!
    @IBOutlet var fret20ImageView : UIImageView!
    @IBOutlet var fret21ImageView : UIImageView!
    @IBOutlet var fret22ImageView : UIImageView!
    @IBOutlet var fret30ImageView : UIImageView!
    @IBOutlet var fret31ImageView : UIImageView!
    @IBOutlet var fret32ImageView : UIImageView!
    @IBOutlet var fret40ImageView : UIImageView!
    @IBOutlet var fret41ImageView : UIImageView!
    @IBOutlet var fret42ImageView : UIImageView!
    @IBOutlet var fret50ImageView : UIImageView!
    @IBOutlet var fret51ImageView : UIImageView!
    @IBOutlet var fret52ImageView : UIImageView!
    @IBOutlet var fretFretLabel : UILabel!
    @IBOutlet var fretStringLabel : UILabel!
    
    // バックグラウンド関連
    @IBOutlet var tonesBgImageView : UIImageView!
    @IBOutlet var tonesTitleBgImageView : UIImageView!
    @IBOutlet var resultBgImageView : UIImageView!
    @IBOutlet var resultTitleBgImageView : UIImageView!
    @IBOutlet var fretBgImageView : UIImageView!

    // 入力された音階
    var toneIds : [Int] = []
    var toneNames : [String] = []
    
    // 検索された弦
    var stringIds : [[Int]] = []
    var stringNames : [String] = []
    
    // フレット
    var fretIds : [[Int]] = []
    var fretNames : [String] = []
    
    // 指
    var fingerIds : [[Int]] = []
    var fingerNames : [String] = []
    
    // 各種制御フラグ
    var screenStateId : Int = KB.SCREEN_STATE_ID_ONLY_TONES_VISIBLE
    var tonesSelectedId : Int = 0
    var resultsSelectedId : Int = 0
    var lastChangedSelectedId : Int = KB.PICKERVIEW_TONE_TAG
    var resultPatternSelectedId : Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ピッカービューを初期化する
        initPickerView()

        // 名称ラベル領域を初期化する
        initTitleLabelViews ()
        
        // ピッカービューの同期を取る
        syncPickerView()
        
        // ボタンを描画する
        syncButtonView()
        
        // フレットイメージを描画する
        initFretView()
        
        // 背景色を描画する
        initBgImageViews()
        
        // 運指画面を描画する
        initResultPatterViews ()
        
//        let tmpSystemCorrect : [[Int]] = [[5, 0, 0], [5, 7, 3], [5, 7, 3], [5, 2, 2], [5, 0, 0], [5, 0, 0]]
//        let tmpUserCorrect : [[Int]] = [[5, 0, 0], [5, 7, 3], [5, 7, 3], [4, 7, 2], [5, 0, 0], [5, 0, 0]]
//        
//        let tmpSystemCorrectCost : Int = KB.calcGuitarSingleFingersTotalCost(stringIdFretIdFingerIds: tmpSystemCorrect)
//        let tmpUserCorrectCost : Int = KB.calcGuitarSingleFingersTotalCost(stringIdFretIdFingerIds: tmpUserCorrect)
//        
//        print(String(tmpSystemCorrectCost) + " / " + String(tmpUserCorrectCost))
        
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
        tonePickerView.frame = CGRect(x: 0, y: y, width: view.frame.width + 100, height: 100)
        
        tonePickerView.tag = 0
        
        y = stringFretFingerPickerView.frame.origin.y
        stringFretFingerPickerView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        stringFretFingerPickerView.frame = CGRect(x: 0, y: y, width: view.frame.width + 100, height: 100)
        
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
            tmpNumRows = 1
            
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
            
        case KB.PICKERVIEW_TONE_TAG:

            tmpStr = toneNames[row]
            
        case KB.PICKERVIEW_STRINGFRETFINGER_TAG:
            tmpStr = stringNames[row] + "." + fretNames[row] + "." + fingerNames[row]
            
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
        
        // ボタンを再描画する
        syncButtonView()
        
        // フレットイメージを描画する
        initFretView()
        
        // 背景色を描画する
        initBgImageViews()
        
        // 運指画面を描画する
        initResultPatterViews ()
        
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
            
            // ラベルを非表示にする
            stringLabel.isHidden = true
            fretLabel.isHidden = true
            fingerLabel.isHidden = true
            
            // 説明ラベルを表示にする
            howtoLabel.isHidden = false
            howtoLabelImageView.isHidden = false
            
            
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
            stringFretFingerPickerView.reloadAllComponents()
            
            if(stringIds.count > 0 && fretIds.count > 0 && fingerIds.count > 0){
                
                stringFretFingerPickerView.selectRow(resultsSelectedId, inComponent: 0, animated: true)
            }
            
            // 結果PickerView側を表示にする
            stringFretFingerPickerView.isHidden = false
            
            // ラベルを表示にする
            stringLabel.isHidden = false
            fretLabel.isHidden = false
            fingerLabel.isHidden = false
            
            // 説明ラベルを非表示にする
            howtoLabel.isHidden = true
            howtoLabelImageView.isHidden = true
            
           
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
                stringFretFingerPickerView.reloadAllComponents()
                
                if(stringIds[resultPatternSelectedId].count > 0 && fretIds[resultPatternSelectedId].count > 0 && fingerIds[resultPatternSelectedId].count > 0){
                    
                    stringFretFingerPickerView.selectRow(resultsSelectedId, inComponent: 0, animated: true)
                }
                
            default:
                break
            }
            
            // 結果PickerView側を表示にする
            stringFretFingerPickerView.isHidden = false
            
            // ラベルを表示にする
            stringLabel.isHidden = false
            fretLabel.isHidden = false
            fingerLabel.isHidden = false
            
            // 説明ラベルを非表示にする
            howtoLabel.isHidden = true
            howtoLabelImageView.isHidden = true
            
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
        
        if(stringIds.count <= resultPatternSelectedId){
            
            return
        }
        
        stringNames.removeAll()
        for i in 0 ..< stringIds[resultPatternSelectedId].count {
            
            stringNames.append(KB.MUSIC_GUITAR_STRINGS_NAMES[stringIds[resultPatternSelectedId][i]])
        }
    }
    
    // フレット用のテキストを生成する
    func initFretText () {
        
        if(fretIds.count <= resultPatternSelectedId){
            
            return
        }
        
        fretNames.removeAll()
        
        for i in 0 ..< fretIds[resultPatternSelectedId].count {

            // 解放弦の場合
            if(fretIds[resultPatternSelectedId][i] <= 0) {
                
                fretNames.append("-")
            }
            else {
                
                fretNames.append(String(fretIds[resultPatternSelectedId][i]))
            }
        }
    }
    
    // 指用のテキストを生成する
    func initFingerText () {
        
        if(fingerIds.count <= resultPatternSelectedId){
            
            return
        }
        
        fingerNames.removeAll()
        
        for i in 0 ..< fingerIds[resultPatternSelectedId].count {
            
            // 解放弦の場合
            if(fingerIds[resultPatternSelectedId][i] <= 0){
                
                fingerNames.append("-")
            }
            // それ以外の場合
            else {
                
                fingerNames.append(KB.MUSIC_GUITAR_FINGERS_ID_NAMES[fingerIds[resultPatternSelectedId][i]])
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
        
        // キャンセルボタンを冒頭に追加する
        let tmpCancelAction = UIAlertAction(title: " - ", style: .default, handler: { (action) in
            
            // ダイアログを閉じる
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(tmpCancelAction)
        
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
                
                // ボタンを再描画する
                self.syncButtonView()
                
                // フレットイメージを描画する
                self.initFretView()
                
                // 背景色を描画する
                self.initBgImageViews()

                // 運指画面を描画する
                self.initResultPatterViews ()
                
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
            
            // ボタンを再描画する
            syncButtonView()
            
            // フレットイメージを描画する
            initFretView()
            
            // 背景色を描画する
            initBgImageViews()
            
            // 運指画面を描画する
            initResultPatterViews ()
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
            
            // ボタンを再描画する
            syncButtonView()
            
            // フレットイメージを描画する
            initFretView()
            
            // 背景色を描画する
            initBgImageViews()
            
            // 運指画面を描画する
            initResultPatterViews ()
        }
        // 配列の範囲外の場合、音を追加する
        else {
            
            // ギターの最高音・最低音を取得する
            let minMaxToneIds = KB.getMinMaxToneIds()
            
            // 音選択ダイアログを取得する
            let alert = UIAlertController(title: "音の追加", message: "", preferredStyle: .alert)
            
            // キャンセルボタンを冒頭に追加する
            let tmpCancelAction = UIAlertAction(title: " - ", style: .default, handler: { (action) in
                
                // ダイアログを閉じる
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(tmpCancelAction)
            
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
                    
                    // ボタンを再描画する
                    self.syncButtonView()
                    
                    // フレットイメージを描画する
                    self.initFretView()
                    
                    // 背景色を描画する
                    self.initBgImageViews()
                    
                    // 運指画面を描画する
                    self.initResultPatterViews ()
                    
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
            if(tonesSelectedId >= toneIds.count){
                
                tonesSelectedId = tonesSelectedId - 1
            }
            lastChangedSelectedId = KB.PICKERVIEW_TONE_TAG
            
            syncPickerView()
            
            // ボタンを再描画する
            syncButtonView()
            
            // フレットイメージを描画する
            initFretView()
            
            // 背景色を描画する
            initBgImageViews()
            
            // 運指画面を描画する
            initResultPatterViews ()
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
        var tmpStringFretFingerIds : [[[Int]]] = []
        tmpStringFretFingerIds = KB.getOptimiseStringIdFretIdFingerIds(tones: toneIds, numSearch: 100000, numPattern: 5)

        // 検索所要時間を算出する
        let procTime = Date().timeIntervalSince1970 - startTime
        let sec = Int(procTime)
        let msec = Int((procTime - Double(sec)) * 100)
        let procTimeStr : String = NSString(format: "%02d:%02d.%02d", sec / 60, sec % 60, msec) as String!
        
        // これまでの検索結果を破棄する
        stringIds.removeAll()
        fretIds.removeAll()
        fingerIds.removeAll()
        
        // 選択対象の音階値を一番最初に戻す
        resultsSelectedId = 0
        lastChangedSelectedId = KB.PICKERVIEW_STRINGFRETFINGER_TAG
        
        // 表示対象の運指パターンを最初にする
        resultPatternSelectedId = 0
        
        // フィールド変数に結果を格納する
        for i in 0 ..< tmpStringFretFingerIds.count {

            var tmpStringIds : [Int] = []
            var tmpFretIds : [Int] = []
            var tmpFingerIds : [Int] = []
            
            for j in 0 ..< tmpStringFretFingerIds[resultPatternSelectedId].count {
                
                tmpStringIds.append(tmpStringFretFingerIds[i][j][0])
                tmpFretIds.append(tmpStringFretFingerIds[i][j][1])
                tmpFingerIds.append(tmpStringFretFingerIds[i][j][2])
            }
            
            stringIds.append(tmpStringIds)
            fretIds.append(tmpFretIds)
            fingerIds.append(tmpFingerIds)
        }
        
        // ダイアログを表示する
        let alert = UIAlertController(title: "検索成功", message: "検索が完了しました！ \n検索回数：" + String(100000) + "\n計算時間：" + procTimeStr, preferredStyle: .alert)
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
        
        // ボタンを再描画する
        syncButtonView()
        
        // フレットイメージを描画する
        initFretView()
        
        // 背景色を描画する
        initBgImageViews()
        
        // 運指画面を描画する
        initResultPatterViews ()
    }
    
    // 入力状態によってボタン描画を反映する
    func syncButtonView (){
        
        var tmpPrevFlag : Bool = false
        var tmpNextFlag : Bool = false
        var tmpEditFlag : Bool = false
        var tmpDeleteFlag : Bool = false
        var tmpSearchFlag : Bool = false

        // ボタンが有効か無効かを判定する
        
        // 入力された音階値が0個の場合
        if(toneIds.count == 0){

            tmpEditFlag = true
            tmpNextFlag = true
        }
        // 入力された音階値が1個の場合
        else if(toneIds.count == 1){
            
            tmpEditFlag = true
            tmpNextFlag = true
            tmpDeleteFlag = true
        }
        // 入力された音階値が2個以上の場合
        else {
            
            // 一番最初に入力された音階値であった場合
            if(tonesSelectedId == 0) {
                
                tmpNextFlag = true
            }
            // 一番最後に入力された音階値であった場合
            else if(tonesSelectedId >= toneIds.count - 1) {
                
                tmpPrevFlag = true
                tmpNextFlag = true
            }
            // それ以外の場合
            else {
                
                tmpPrevFlag = true
                tmpNextFlag = true
            }
            
            tmpEditFlag = true
            tmpDeleteFlag = true
            tmpSearchFlag = true
        }
        
        // ボタンの有効・無効有無を設定する
        initButtonState(button: prevButton, isEnabled: tmpPrevFlag)
        initButtonState(button: nextButton, isEnabled: tmpNextFlag)
        initButtonState(button: editButton, isEnabled: tmpEditFlag)
        initButtonState(button: deleteButton, isEnabled: tmpDeleteFlag)
        initButtonState(button: searchButton, isEnabled: tmpSearchFlag)
    }
    
    // ボタンの有効有無を設定する
    // @param button ボタン
    // @param isEnabled 有効かの是非
    func initButtonState (button : UIButton, isEnabled : Bool) {
        
        if(isEnabled){

            button.setBackgroundImage(UIImage(named: KB.IMAGE_NAME_FELT_BACKGROUND_ORANGE), for: .normal)
            
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.darkGray.cgColor
            button.setTitleColor(UIColor.black, for: .normal)
        }
        else{

            button.setBackgroundImage(UIImage(named: KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            button.setTitleColor(UIColor.white, for: .normal)
        }
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
    }
    
    // 運指パターン1が押された時の処理
    @IBAction func onPattern1Pushed () {
        
        onPatternPushed(patternId : 1)
    }
    
    // 運指パターン2が押された時の処理
    @IBAction func onPattern2Pushed () {
        
        onPatternPushed(patternId : 2)
    }
    
    // 運指パターン3が押された時の処理
    @IBAction func onPattern3Pushed () {
        
        onPatternPushed(patternId : 3)
    }

    // 運指パターン4が押された時の処理
    @IBAction func onPattern4Pushed () {
        
        onPatternPushed(patternId : 4)
    }

    // 運指パターン5が押された時の処理
    @IBAction func onPattern5Pushed () {
        
        onPatternPushed(patternId : 5)
    }
    
    // 運指パターンが押された時の処理
    // @param patternId パターンID
    func onPatternPushed (patternId : Int) {
        
        // 選択IDを更新する
        if(patternId - 1 < stringIds.count){
            
            resultPatternSelectedId = patternId - 1
            lastChangedSelectedId = KB.PICKERVIEW_STRINGFRETFINGER_TAG

            // PickerViewの同期を取る
            syncPickerView()
            
            // ボタンを再描画する
            syncButtonView()
            
            // フレットイメージを描画する
            initFretView()
            
            // 背景色を描画する
            initBgImageViews()
            
            // 運指画面を描画する
            initResultPatterViews ()

        }
        // 押せない場合、ダイアログを表示する
        else {
            
            // ダイアログを表示する
            let alert = UIAlertController(title: "読み込みエラー", message: "運指結果を読み込めませんでした。", preferredStyle: .alert)
            let tmpAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                
                // ダイアログを閉じる
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(tmpAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*------- フレットビューに関する処理　-------*/

    // フレットのイメージをセットする
    func initFretView () {
        
        // 表示対象のフレットがない場合は、非表示にする
        if(screenStateId == KB.SCREEN_STATE_ID_ONLY_TONES_VISIBLE){
            
            setFretViewsHidden(isHidden: true)
            return
        }
        if(stringIds.count <= resultPatternSelectedId){
            
            setFretViewsHidden(isHidden: true)
            return
        }
        if(stringIds[resultPatternSelectedId].count == 0 || stringIds[resultPatternSelectedId].count <= resultsSelectedId){
            
            setFretViewsHidden(isHidden: true)
            return
        }
        
        // フレットビューを表示状態にする
        setFretViewsHidden(isHidden: false)
        
        // 表示対象の弦ID、フレットIDを取得する
        let currentStringId = stringIds[resultPatternSelectedId][resultsSelectedId]
        let currentFretId = fretIds[resultPatternSelectedId][resultsSelectedId]
        
        // フレット番号のラベルをセットする
        var midFretId : Int = currentFretId
        if(midFretId <= 1){
            
            midFretId = 2
        }
        else if(midFretId == KB.MUSIC_GUITAR_STRINGS_DEFAULT_NUM_FRETS[currentStringId]) {
            
            midFretId -= 1
        }
        fretId0Label.text = String(midFretId - 1)
        fretId1Label.text = String(midFretId)
        fretId2Label.text = String(midFretId + 1)
        
        // 使用の有無によって、弦番号のラベルに色付けする
        stringId0Label.textColor = (currentStringId == 0) ? UIColor.red : UIColor.black
        stringId1Label.textColor = (currentStringId == 1) ? UIColor.red : UIColor.black
        stringId2Label.textColor = (currentStringId == 2) ? UIColor.red : UIColor.black
        stringId3Label.textColor = (currentStringId == 3) ? UIColor.red : UIColor.black
        stringId4Label.textColor = (currentStringId == 4) ? UIColor.red : UIColor.black
        stringId5Label.textColor = (currentStringId == 5) ? UIColor.red : UIColor.black
        openStringId0Label.textColor = (currentStringId == 0) ? UIColor.red : UIColor.black
        openStringId1Label.textColor = (currentStringId == 1) ? UIColor.red : UIColor.black
        openStringId2Label.textColor = (currentStringId == 2) ? UIColor.red : UIColor.black
        openStringId3Label.textColor = (currentStringId == 3) ? UIColor.red : UIColor.black
        openStringId4Label.textColor = (currentStringId == 4) ? UIColor.red : UIColor.black
        openStringId5Label.textColor = (currentStringId == 5) ? UIColor.red : UIColor.black
        
        // 解放の有無によって、解放ラベルの内容をセットする
        openStringId0Label.text = (currentStringId == 0 && currentFretId == 0) ? "開放" : ""
        openStringId1Label.text = (currentStringId == 1 && currentFretId == 0) ? "開放" : ""
        openStringId2Label.text = (currentStringId == 2 && currentFretId == 0) ? "開放" : ""
        openStringId3Label.text = (currentStringId == 3 && currentFretId == 0) ? "開放" : ""
        openStringId4Label.text = (currentStringId == 4 && currentFretId == 0) ? "開放" : ""
        openStringId5Label.text = (currentStringId == 5 && currentFretId == 0) ? "開放" : ""
        
        // 各フレットに画像をセットする
        fret00ImageView.image = (currentStringId == 0 && currentFretId - (midFretId - 2) == 1) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret01ImageView.image = (currentStringId == 0 && currentFretId - (midFretId - 2) == 2) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret02ImageView.image = (currentStringId == 0 && currentFretId - (midFretId - 2) == 3) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret10ImageView.image = (currentStringId == 1 && currentFretId - (midFretId - 2) == 1) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret11ImageView.image = (currentStringId == 1 && currentFretId - (midFretId - 2) == 2) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret12ImageView.image = (currentStringId == 1 && currentFretId - (midFretId - 2) == 3) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret20ImageView.image = (currentStringId == 2 && currentFretId - (midFretId - 2) == 1) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret21ImageView.image = (currentStringId == 2 && currentFretId - (midFretId - 2) == 2) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret22ImageView.image = (currentStringId == 2 && currentFretId - (midFretId - 2) == 3) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret30ImageView.image = (currentStringId == 3 && currentFretId - (midFretId - 2) == 1) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret31ImageView.image = (currentStringId == 3 && currentFretId - (midFretId - 2) == 2) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret32ImageView.image = (currentStringId == 3 && currentFretId - (midFretId - 2) == 3) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret40ImageView.image = (currentStringId == 4 && currentFretId - (midFretId - 2) == 1) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret41ImageView.image = (currentStringId == 4 && currentFretId - (midFretId - 2) == 2) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret42ImageView.image = (currentStringId == 4 && currentFretId - (midFretId - 2) == 3) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret50ImageView.image = (currentStringId == 5 && currentFretId - (midFretId - 2) == 1) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret51ImageView.image = (currentStringId == 5 && currentFretId - (midFretId - 2) == 2) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
        fret52ImageView.image = (currentStringId == 5 && currentFretId - (midFretId - 2) == 3) ? UIImage(named: KB.MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH) : UIImage(named: KB.MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH)
    }
    
    // フレットビューの表示状態を切り替える
    // @param isHidden 表示の有無
    func setFretViewsHidden (isHidden : Bool) {
        
        stringId0Label.isHidden = isHidden
        stringId1Label.isHidden = isHidden
        stringId2Label.isHidden = isHidden
        stringId3Label.isHidden = isHidden
        stringId4Label.isHidden = isHidden
        stringId5Label.isHidden = isHidden
        openStringId0Label.isHidden = isHidden
        openStringId1Label.isHidden = isHidden
        openStringId2Label.isHidden = isHidden
        openStringId3Label.isHidden = isHidden
        openStringId4Label.isHidden = isHidden
        openStringId5Label.isHidden = isHidden
        fretId0Label.isHidden = isHidden
        fretId1Label.isHidden = isHidden
        fretId2Label.isHidden = isHidden
        fret00ImageView.isHidden = isHidden
        fret01ImageView.isHidden = isHidden
        fret02ImageView.isHidden = isHidden
        fret10ImageView.isHidden = isHidden
        fret11ImageView.isHidden = isHidden
        fret12ImageView.isHidden = isHidden
        fret20ImageView.isHidden = isHidden
        fret21ImageView.isHidden = isHidden
        fret22ImageView.isHidden = isHidden
        fret30ImageView.isHidden = isHidden
        fret31ImageView.isHidden = isHidden
        fret32ImageView.isHidden = isHidden
        fret40ImageView.isHidden = isHidden
        fret41ImageView.isHidden = isHidden
        fret42ImageView.isHidden = isHidden
        fret50ImageView.isHidden = isHidden
        fret51ImageView.isHidden = isHidden
        fret52ImageView.isHidden = isHidden
        fretFretLabel.isHidden = isHidden
        fretStringLabel.isHidden = isHidden
    }
    
    
    
    /*------- 運指パターン描画に関する処理 ------*/

    func initResultPatterViews () {

        // 運指のパターン数に応じて、色を変更
        switch(stringIds.count) {
            
        case 0:
            resultPattern1Button.isHidden = true
            resultPattern2Button.isHidden = true
            resultPattern3Button.isHidden = true
            resultPattern4Button.isHidden = true
            resultPattern5Button.isHidden = true
            
        case 1:
            resultPattern1Button.isHidden = false
            resultPattern2Button.isHidden = true
            resultPattern3Button.isHidden = true
            resultPattern4Button.isHidden = true
            resultPattern5Button.isHidden = true
            
            resultPattern1Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            
        case 2:
            resultPattern1Button.isHidden = false
            resultPattern2Button.isHidden = false
            resultPattern3Button.isHidden = true
            resultPattern4Button.isHidden = true
            resultPattern5Button.isHidden = true

            resultPattern1Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            resultPattern2Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            
        case 3:
            resultPattern1Button.isHidden = false
            resultPattern2Button.isHidden = false
            resultPattern3Button.isHidden = false
            resultPattern4Button.isHidden = true
            resultPattern5Button.isHidden = true

            resultPattern1Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            resultPattern2Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            resultPattern3Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
        
        case 4:
            resultPattern1Button.isHidden = false
            resultPattern2Button.isHidden = false
            resultPattern3Button.isHidden = false
            resultPattern4Button.isHidden = false
            resultPattern5Button.isHidden = true

            resultPattern1Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            resultPattern2Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            resultPattern3Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            resultPattern4Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            
        case 5:
            resultPattern1Button.isHidden = false
            resultPattern2Button.isHidden = false
            resultPattern3Button.isHidden = false
            resultPattern4Button.isHidden = false
            resultPattern5Button.isHidden = false

            resultPattern1Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            resultPattern2Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            resultPattern3Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            resultPattern4Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            resultPattern5Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_ORIGINAL), for: .normal)
            
        default:
            break
        }
        
        // 各ボタンに枠線などをつける
        resultPattern1Button.layer.borderWidth = 1
        resultPattern1Button.layer.borderColor = UIColor.darkGray.cgColor
        resultPattern1Button.setTitleColor(UIColor.darkGray, for: .normal)
        resultPattern1Button.layer.cornerRadius = 10
        resultPattern1Button.layer.masksToBounds = true
        
        resultPattern2Button.layer.borderWidth = 1
        resultPattern2Button.layer.borderColor = UIColor.darkGray.cgColor
        resultPattern2Button.setTitleColor(UIColor.darkGray, for: .normal)
        resultPattern2Button.layer.cornerRadius = 10
        resultPattern2Button.layer.masksToBounds = true
        
        resultPattern3Button.layer.borderWidth = 1
        resultPattern3Button.layer.borderColor = UIColor.darkGray.cgColor
        resultPattern3Button.setTitleColor(UIColor.darkGray, for: .normal)
        resultPattern3Button.layer.cornerRadius = 10
        resultPattern3Button.layer.masksToBounds = true
        
        resultPattern4Button.layer.borderWidth = 1
        resultPattern4Button.layer.borderColor = UIColor.darkGray.cgColor
        resultPattern4Button.setTitleColor(UIColor.darkGray, for: .normal)
        resultPattern4Button.layer.cornerRadius = 10
        resultPattern4Button.layer.masksToBounds = true
        
        resultPattern5Button.layer.borderWidth = 1
        resultPattern5Button.layer.borderColor = UIColor.darkGray.cgColor
        resultPattern5Button.setTitleColor(UIColor.darkGray, for: .normal)
        resultPattern5Button.layer.cornerRadius = 10
        resultPattern5Button.layer.masksToBounds = true

        
        // 現在選択中の運指パターンは色をつける
        switch(resultPatternSelectedId) {
            
        case 0:
            resultPattern1Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_GREEN), for: .normal)
            resultPattern1Button.layer.borderColor = UIColor.clear.cgColor
            resultPattern1Button.setTitleColor(UIColor.black, for: .normal)
            
        case 1:
            resultPattern2Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_GREEN), for: .normal)
            resultPattern2Button.layer.borderColor = UIColor.clear.cgColor
            resultPattern2Button.setTitleColor(UIColor.black, for: .normal)
            
        case 2:
            resultPattern3Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_GREEN), for: .normal)
            resultPattern3Button.layer.borderColor = UIColor.clear.cgColor
            resultPattern3Button.setTitleColor(UIColor.black, for: .normal)
            
        case 3:
            resultPattern4Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_GREEN), for: .normal)
            resultPattern4Button.layer.borderColor = UIColor.clear.cgColor
            resultPattern4Button.setTitleColor(UIColor.black, for: .normal)
            
        case 4:
            resultPattern5Button.setBackgroundImage(UIImage(named : KB.IMAGE_NAME_FELT_BACKGROUND_GREEN), for: .normal)
            resultPattern5Button.layer.borderColor = UIColor.clear.cgColor
            resultPattern5Button.setTitleColor(UIColor.black, for: .normal)
            
        default:
            break
        }
    }


    /*------- バックグラウンドに関する処理　-------*/
    
    // バックグランド背景色を調整する
    func initBgImageViews () {
        
        switch(lastChangedSelectedId) {
            
        // 最後に音階値を入力した場合
        case KB.PICKERVIEW_TONE_TAG:
            tonesBgImageView.image = UIImage(named: KB.IMAGE_NAME_FELT_BACKGROUND_YELLOW)
            tonesTitleBgImageView.image = UIImage(named: KB.IMAGE_NAME_FELT_BACKGROUND_YELLOW)
            resultBgImageView.image = UIImage(named: KB.IMAGE_NAME_FELT_BACKGROUND_BLUE)
            resultTitleBgImageView.image = UIImage(named: KB.IMAGE_NAME_FELT_BACKGROUND_BLUE)
            fretBgImageView.image = UIImage(named: KB.IMAGE_NAME_FELT_BACKGROUND_BLUE)
            
        // 最後に結果画面を操作した場合
        case KB.PICKERVIEW_STRINGFRETFINGER_TAG:
            tonesBgImageView.image = UIImage(named: KB.IMAGE_NAME_FELT_BACKGROUND_BLUE)
            tonesTitleBgImageView.image = UIImage(named: KB.IMAGE_NAME_FELT_BACKGROUND_BLUE)
            resultBgImageView.image = UIImage(named: KB.IMAGE_NAME_FELT_BACKGROUND_YELLOW)
            resultTitleBgImageView.image = UIImage(named: KB.IMAGE_NAME_FELT_BACKGROUND_YELLOW)
            fretBgImageView.image = UIImage(named: KB.IMAGE_NAME_FELT_BACKGROUND_YELLOW)
            
        default:
            break
        }
    }
    
    // タイトルラベル領域を初期化する
    func initTitleLabelViews () {
        
        // 名称ラベルを90度回転させる
        stringLabel.transform = CGAffineTransform(rotationAngle: rotationAngle)
        fretLabel.transform = CGAffineTransform(rotationAngle: rotationAngle)
        fingerLabel.transform = CGAffineTransform(rotationAngle: rotationAngle)
        toneLabel.transform = CGAffineTransform(rotationAngle: rotationAngle)

        // バックグラウンドに枠線をつける
        tonesBgImageView.layer.borderWidth = 1
        tonesBgImageView.layer.borderColor = UIColor.lightGray.cgColor
        tonesTitleBgImageView.layer.borderWidth = 1
        tonesTitleBgImageView.layer.borderColor = UIColor.lightGray.cgColor
        resultBgImageView.layer.borderWidth = 1
        resultBgImageView.layer.borderColor = UIColor.lightGray.cgColor
        resultTitleBgImageView.layer.borderWidth = 1
        resultTitleBgImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        // フレット領域を各丸にし、枠線をつける
        fretBgImageView.layer.cornerRadius = 10
        fretBgImageView.layer.masksToBounds = true
        fretBgImageView.layer.borderWidth = 1
        fretBgImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        // 冒頭説明テキストを15度回転させる
        howtoLabel.transform = CGAffineTransform(rotationAngle: rotationAngle / 6)
    }
}
