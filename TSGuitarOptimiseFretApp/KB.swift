//
//  KB.swift
//  TSGuitarOptimiseFretApp
//
//  Created by nttr on 2017/08/08.
//  Copyright © 2017年 nttr. All rights reserved.
//

import Foundation

// 共通変数・メソッド（Knowledge Base）を用意するクラス
class KB {
    
    /*------- 音符種別 -------*/
    
    static let MUSIC_NOTE_PITCHES_ID_C = 0
    static let MUSIC_NOTE_PITCHES_ID_D = 1
    static let MUSIC_NOTE_PITCHES_ID_E = 2
    static let MUSIC_NOTE_PITCHES_ID_F = 3
    static let MUSIC_NOTE_PITCHES_ID_G = 4
    static let MUSIC_NOTE_PITCHES_ID_A = 5
    static let MUSIC_NOTE_PITCHES_ID_B = 6
    
    static let MUSIC_NOTE_PITCHES_NAMES : [String] = [
        "ド",
        "レ",
        "ミ",
        "ファ",
        "ソ",
        "ラ",
        "シ"
    ]
    
    static let MUSIC_NOTE_PITCHES_NAMEENS : [String] = [
        "C",
        "D",
        "E",
        "F",
        "G",
        "A",
        "B"
    ]
    
    static let MUSIC_NOTE_PITCHES_TONES : [Int] = [
        0,
        2,
        4,
        5,
        7,
        9,
        11
    ]

    static let MUSIC_NOTE_ACCIDENTAL_ID_NORMAL = 0
    static let MUSIC_NOTE_ACCIDENTAL_ID_FLAT = 1
    static let MUSIC_NOTE_ACCIDENTAL_ID_SHARP = 2
    
    static let MUSIC_NOTE_ACCIDENTAL_NAMES : [String] = [
        "",
        "♭",
        "♯"
    ]
    
    static let MUSIC_NOTE_ACCIDENTAL_NAMEENS : [String] = [
        "",
        "flat",
        "sharp"
    ]
    
    static let MUSIC_NOTE_ACCIDENTAL_TONES : [Int] = [
        0,
        -1,
        1
    ]
    
    static let MUSIC_NOTE_OCTAVES_ID_LOW = 0
    static let MUSIC_NOTE_OCTAVES_ID_MIDDLE = 1
    static let MUSIC_NOTE_OCTAVES_ID_HIGH = 2
    static let MUSIC_NOTE_OCTAVES_ID_HIGHHIGH = 3
    
    static let MUSIC_NOTE_OCTAVES_NAMES : [String] = [
        "低",
        "",
        "高",
        "高高"
    ]
    
    static let MUSIC_NOTE_OCTAVES_NAMEENS : [String] = [
        "low",
        "middle",
        "high",
        "highhigh"
    ]
    
    static let MUSIC_NOTE_OCTAVES_TONES : [Int] = [
        0,
        12,
        24,
        36,
        ]
    
    // 音階値を取得する
    // （低ドを0として、1音階ごとに1増加させる）
    // @param octaveId オクターブID
    // @param pitchId 音名ID
    // @param accidentalId 変音記号ID
    static func getTone (ocvaveId : Int, pitchId : Int, accidentalId : Int) -> Int {
        
        return MUSIC_NOTE_OCTAVES_TONES[ocvaveId] + MUSIC_NOTE_PITCHES_TONES[pitchId] + MUSIC_NOTE_ACCIDENTAL_TONES[accidentalId]
    }
    
    // オクターブIDを取得する
    // @param tone 音階値
    // @return オクターブID
    static func getOctaveId (tone : Int) -> Int {
        
        var tmpId : Int = MUSIC_NOTE_OCTAVES_TONES.count - 1
        for i in 0 ..< (MUSIC_NOTE_OCTAVES_TONES.count - 1) {
            
            if(MUSIC_NOTE_OCTAVES_TONES[i] <= tone && tone < MUSIC_NOTE_OCTAVES_TONES[i + 1]){
                
                tmpId = i
                break
            }
        }
        return tmpId
    }
    
    // オクターブIDと音名IDを取得する
    // @param tone 音階値
    // @param accidentalId 変音記号ID（♯と♭基準のどちらで取るか）
    // @return [オクターブID, 音名ID]
    static func getOctavePitchId (tone : Int, accidentalId : Int) -> [Int] {
        
        // オクターブIDを取得する
        let octaveId = getOctaveId(tone: tone)
        
        // オクターブ分の音階値を減算した音階値を求める
        let tmpTone = tone - MUSIC_NOTE_OCTAVES_TONES[octaveId]
        
        var tmpId : Int = MUSIC_NOTE_PITCHES_TONES.count - 1
        for i in 0 ..< (MUSIC_NOTE_PITCHES_TONES.count - 1) {
            
            if(accidentalId ==  MUSIC_NOTE_ACCIDENTAL_ID_SHARP) {
                if(MUSIC_NOTE_PITCHES_TONES[i] <= tmpTone && tmpTone < MUSIC_NOTE_PITCHES_TONES[i + 1]){
                    
                    tmpId = i
                    break
                }
            }
            else if (accidentalId == MUSIC_NOTE_ACCIDENTAL_ID_FLAT){
                if(tmpTone <= MUSIC_NOTE_PITCHES_TONES[i]) {
                    
                    tmpId = i
                    break
                }
            }
        }
        
        let tmpIds : [Int] = [octaveId, tmpId]
        
        return tmpIds
    }
    
    // オクターブIDと音名ID、変音記号IDを取得する
    // @param tone 音階値
    // @param accidentalId 変音記号ID（♯と♭基準のどちらで取るか）
    // @return [オクターブID, 音名ID, 変音記号ID]
    static func getOctavePitchAccidentalId (tone : Int, accidentalId : Int) -> [Int] {
        
        // オクターブIDと音名IDを取得する
        let octavePitchId = getOctavePitchId(tone: tone, accidentalId: accidentalId)
        
        let normalTone = getTone(ocvaveId: octavePitchId[0], pitchId: octavePitchId[1], accidentalId: MUSIC_NOTE_ACCIDENTAL_ID_NORMAL)
        
        for i in 0 ..< MUSIC_NOTE_ACCIDENTAL_TONES.count {
            
            if(normalTone + MUSIC_NOTE_ACCIDENTAL_TONES[i] == tone){
                
                return [octavePitchId[0], octavePitchId[1], i]
            }
        }
        return [octavePitchId[0], octavePitchId[1], 0]
    }
    
    // オクターブIDと音名ID、変音記号IDから音階名称を取得する
    // @param octaveId オクターブID
    // @param pitchId 音名ID
    // @param accidentalId 変音記号ID
    // @return 音階名称
    static func getToneName (octaveId : Int, pitchId : Int, accidentalId : Int) -> String{
        
        return MUSIC_NOTE_OCTAVES_NAMES[octaveId] + MUSIC_NOTE_PITCHES_NAMES[pitchId] + MUSIC_NOTE_ACCIDENTAL_NAMES[accidentalId]
    }
    
    // 音階値から音階名称を取得する
    // @param tone 音階値
    // @param accidentalId 変音記号ID
    // @return 音階名称
    static func getToneName (tone : Int, accidentalId : Int) -> String {
        
        let tmpIds : [Int] = getOctavePitchAccidentalId(tone: tone, accidentalId: accidentalId)
        return getToneName(octaveId: tmpIds[0], pitchId: tmpIds[1], accidentalId: tmpIds[2])
    }

    
    /*------- ギター関連 -------*/
    
    static let MUSIC_GUITAR_FRET_NOT_PRESSING_IMAGEPATH : String = "fret_not_pressing.png"
    static let MUSIC_GUITAR_FRET_PRESSING_IMAGEPATH : String = "fret_pressing.png"
    
    static let MUSIC_GUITAR_STRINGS_DEFAULT_BASE_TONES : [Int] = [
        4,
        9,
        14,
        19,
        23,
        28
    ]
    
    static let MUSIC_GUITAR_STRINGS_DEFAULT_NUM_FRETS : [Int] = [
        12,
        12,
        12,
        12,
        12,
        12
    ]
    
    static let MUSIC_GUITAR_STRINGS_NAMES : [String] = [
        "6",
        "5",
        "4",
        "3",
        "2",
        "1"
    ]
    
    // 弦IDとフレットIDから音階値を取得する
    // @param stringId 弦ID
    // @param fretId フレットID
    // @return 音階値
    static func getToneFromStringIdFretId (stringId : Int, fretId : Int) -> Int{
        
        return getMusicGuitarStringsBaseTone(index: stringId) + fretId
        //        return MUSIC_GUITAR_STRINGS_DEFAULT_BASE_TONES[stringId] + fretId
    }
    
    // 音階値と弦IDから、フレットIDを取得する
    // @param tone 音階値
    // @param stringId 弦ID
    // @return フレットID（見つからない場合には、-1を返す）
    static func getFretIdFromToneStringId (tone : Int, stringId : Int) -> Int {
        
        let fretId = tone - getMusicGuitarStringsBaseTone(index: stringId)
        //        let fretId = tone - MUSIC_GUITAR_STRINGS_DEFAULT_BASE_TONES[stringId]
        if(0 <= fretId && fretId <= MUSIC_GUITAR_STRINGS_DEFAULT_NUM_FRETS[stringId]){
            
            return fretId
        }
        return -1
    }
    
    // 音階値から、各弦のフレットIDの一覧を取得する
    // @param tone 音階値
    // @return [6弦のフレットID, 5弦のフレットID, ... , 1弦のフレットID]（該当フレットが無い弦は-1を返す）
    static func getFretIdsFromTone (tone : Int) -> [Int] {
        
        var tmpIds : [Int] = []
        
        for i in 0 ..< MUSIC_GUITAR_STRINGS_DEFAULT_NUM_FRETS.count {
            
            tmpIds.append(getFretIdFromToneStringId(tone: tone, stringId: i))
        }
        return tmpIds
    }
    
    // 弦IDから、音階値の最大・最小値を取得する
    // @param stringId 弦ID
    // @return [最小値, 最大値]
    static func getMinMaxTonesFromStringId (stringId : Int) -> [Int] {
        
        let tmpIds : [Int] = [getMusicGuitarStringsBaseTone(index: stringId), getMusicGuitarStringsBaseTone(index: stringId) + MUSIC_GUITAR_STRINGS_DEFAULT_NUM_FRETS[stringId]]
        //        let tmpIds : [Int] = [MUSIC_GUITAR_STRINGS_DEFAULT_BASE_TONES[stringId], MUSIC_GUITAR_STRINGS_DEFAULT_BASE_TONES[stringId] + MUSIC_GUITAR_STRINGS_DEFAULT_NUM_FRETS[stringId]]
        
        return tmpIds
    }
    
    // ギターの音階値の最大・最小値を取得する
    // @return [最小値, 最大値]
    static func getMinMaxToneIds () -> [Int] {
        
        var minId : Int = -1
        var maxId : Int = -1
        
        for i in 0 ..< MUSIC_GUITAR_STRINGS_NAMES.count {
            
            let tmpIds = getMinMaxTonesFromStringId(stringId: i)
            if(maxId == -1) {
                
                minId = tmpIds[0]
                maxId = tmpIds[1]
                continue
            }
            
            if(minId > tmpIds[0]) {
                
                minId = tmpIds[0]
            }
            if(maxId < tmpIds[1]) {
                
                maxId = tmpIds[1]
            }
        }
        
        let tmpIds : [Int] = [minId, maxId]
        return tmpIds
    }
    
    
    /*------- 運指データ　-------*/
    
    static let MUSIC_GUITAR_FINGERS_ID_NONE = 0
    static let MUSIC_GUITAR_FINGERS_ID_FATHER = 1
    static let MUSIC_GUITAR_FINGERS_ID_MOTHER = 2
    static let MUSIC_GUITAR_FINGERS_ID_BROTHER = 3
    static let MUSIC_GUITAR_FINGERS_ID_SISTER = 4
    static let MUSIC_GUITAR_FINGERS_ID_KIDS = 5
    
    static let MUSIC_GUITAR_FINGERS_ID_NAMES = [
        "",
        "親",
        "人差",
        "中",
        "薬",
        "小"
    ]
    
    static let MUSIC_GUITAR_FINGERS_ID_NAMEENS = [
        "",
        "father",
        "mother",
        "brother",
        "sister",
        "kids"
    ]
    
    
    
    // ギター単指の位置コストを算出する
    // @param stringId 弦ID
    // @param fretId フレットID
    // @param fingerId 指ID
    // @return コスト
    static func calcGuitarSingleFingerPositionCost (stringId : Int, fretId : Int, fingerId : Int) -> Int {
        
        return (6 - stringId) * fretId + fingerId
    }
    
    // 2つのギター単指間の運動コストを算出する
    // @param beforeStringId 移動前の弦ID
    // @param beforeFretId 移動前のフレットID
    // @param beforeFingerId 移動前の指ID
    // @param afterStringId 移動後の弦ID
    // @param afterFretId 移動後のフレットID
    // @param afterFingerId 移動後の指ID
    // @return コスト
    static func calcGuitarSingleFingersMovingCost (beforeStringId : Int, beforeFretId : Int, beforeFingerId : Int, afterStringId : Int, afterFretId : Int, afterFingerId : Int) -> Int {
        
        var tmpCost : Int = 0
        
        // ルール1：移動前後の弦とフレットと指が同じ場合、コストを0とする
        if(beforeStringId == afterStringId && beforeFretId == afterFretId && beforeFingerId == afterFingerId){
            
            return tmpCost
        }
        
        // ルール2：移動前または移動後が開放弦の場合、コストを1とする
        if(beforeFretId == 0 || afterFretId == 0){
            
            tmpCost = 1
            return tmpCost
        }
        
        // ルール3：前後の指が異なる場合、動的にコストを計算する
        var tmpBaseFretId = 0
        if(beforeFingerId == MUSIC_GUITAR_FINGERS_ID_MOTHER && afterFingerId == MUSIC_GUITAR_FINGERS_ID_BROTHER){
            
            tmpBaseFretId = beforeFretId + 1
            tmpCost += abs(afterFretId - tmpBaseFretId) + 1
        }
        else if(beforeFingerId == MUSIC_GUITAR_FINGERS_ID_MOTHER && afterFingerId == MUSIC_GUITAR_FINGERS_ID_SISTER){
            
            tmpBaseFretId = beforeFretId + 2
            tmpCost += abs(afterFretId - tmpBaseFretId) + 1
        }
        else if(beforeFingerId == MUSIC_GUITAR_FINGERS_ID_MOTHER && afterFingerId == MUSIC_GUITAR_FINGERS_ID_KIDS){
            
            tmpBaseFretId = beforeFretId + 3
            tmpCost += abs(afterFretId - tmpBaseFretId) + 1
        }
        else if(beforeFingerId == MUSIC_GUITAR_FINGERS_ID_BROTHER && afterFingerId == MUSIC_GUITAR_FINGERS_ID_SISTER){
            
            tmpBaseFretId = beforeFretId + 1
            tmpCost += abs(afterFretId - tmpBaseFretId) + 1
        }
        
        // ルール4：前後の指が同じ場合、動的にコストを決定する
        if(beforeFingerId == afterFingerId && beforeFingerId != MUSIC_GUITAR_FINGERS_ID_NONE){

            let subStringId = abs(beforeStringId - afterStringId)
            let subFretId = abs(beforeFretId - afterFretId)
            
            // (1)前後で弾く弦が同じとき
            if(subStringId == 0){
                
                // (1-1)隣接したフレットでの移動の場合、コストを2とする
                if(beforeFretId > 0 && afterFretId > 0 && subFretId == 1){
                    
                    tmpCost = 2
                }
                // (1-2)隣接していないフレットでの移動の場合、コストを動的に追加する
                else if(beforeFretId > 0 && afterFretId > 0 && subFretId != 1){
                    
                    tmpCost += subFretId + 3
                }
            }
            // (2)前後で弾く弦が異なる場合
            else{
                
                tmpCost += subStringId * subStringId + subFretId * subFretId
            }
        }
        
        return tmpCost
    }
    
    // 一連のギター単指の運指総コストを算出する
    // @param stringIdFretIdFingerIds [[弦ID, フレットID, 指ID], ...]
    // @return コスト
    static func calcGuitarSingleFingersTotalCost(stringIdFretIdFingerIds : [[Int]]) -> Int {
        
        // ギター単指数が0の場合、コストを0とする
        if(stringIdFretIdFingerIds.count == 0){
            
            return 0
        }
            
        // 位置コストと運動コストを加算して、総コストを計算する
        var tmpCost = 0
        for i in 0 ..< stringIdFretIdFingerIds.count {
            
            let currentIds = stringIdFretIdFingerIds[i]
            
            // 位置コストを加算する
            tmpCost += calcGuitarSingleFingerPositionCost(stringId: currentIds[0], fretId: currentIds[1], fingerId: currentIds[2])
            
            // 運動コストを加算する
            if(i > 0) {
                
                let beforeIds = stringIdFretIdFingerIds[i - 1]
                
                tmpCost += calcGuitarSingleFingersMovingCost(beforeStringId: beforeIds[0], beforeFretId: beforeIds[1], beforeFingerId: beforeIds[2], afterStringId: currentIds[0], afterFretId: currentIds[1], afterFingerId: currentIds[2])
            }
        }
        return tmpCost
    }
    
    // 音階値から、運指コストが最小となる運指を取得する
    // @param tones [音階値]
    // @param numSearch 計算回数
    // @return [[弦ID, フレットID, 指ID] ... ]
    static func getOptimiseStringIdFretIdFingerIds(tones : [Int], numSearch : Int) -> [[Int]] {
        
        var tmpNumSearch :Int = 0
        var minCost : Int = -1
        var minIds : [[Int]] = []
        
        // 規定計算回数分だけ繰り返す
        while(true){
            
            //　規定計算回数だけ実施済みの場合には、ループを抜ける
            if(numSearch <= tmpNumSearch){
                
                break
            }
            
            // 音を適当に当てはめる
            
            
        }
        return minIds
    }
    
    

    /*------- ユーザデータ　------*/

    // UserDefaultsの変音記号種別のキー
    static let USERDEFAULTS_KEY_MUSIC_NOTE_ACCIDENTAL_ID : String = "music_note_accidental_id"
    
    // ユーザ設定の変音記号IDを取得する
    // @return 変音記号ID
    static func getMusicNoteAccidentalId () -> Int {
        
        let ud = UserDefaults.standard
        if(ud.object(forKey: USERDEFAULTS_KEY_MUSIC_NOTE_ACCIDENTAL_ID) == nil){
            
            saveMusicNoteAccidentalId(accidentalId: KB.MUSIC_NOTE_ACCIDENTAL_ID_SHARP)
        }
        
        var accidentalId : Int = ud.integer(forKey: USERDEFAULTS_KEY_MUSIC_NOTE_ACCIDENTAL_ID)
        
        // ♯と♭以外の場合、♯をデフォルトとする
        if(accidentalId != MUSIC_NOTE_ACCIDENTAL_ID_SHARP && accidentalId != MUSIC_NOTE_ACCIDENTAL_ID_FLAT){
            
            accidentalId = MUSIC_NOTE_ACCIDENTAL_ID_SHARP
            saveMusicNoteAccidentalId(accidentalId: accidentalId)
        }
        return accidentalId
    }
    
    // ユーザ設定の変音記号IDを保存する
    // @param accidentalId 変音記号ID
    static func saveMusicNoteAccidentalId (accidentalId : Int) {
        
        let ud = UserDefaults.standard
        ud.set(accidentalId, forKey: USERDEFAULTS_KEY_MUSIC_NOTE_ACCIDENTAL_ID)
        
        ud.synchronize()
    }
    
    // ユーザ設定の変音記号IDを削除する
    static func removeMusicNoteAccidentalId () {
        
        let ud = UserDefaults.standard
        ud.removeObject(forKey: USERDEFAULTS_KEY_MUSIC_NOTE_ACCIDENTAL_ID)
    }
    
    // UserDefaultsの各弦の音階値のキー
    static let USERDEFAULTS_KEY_MUSIC_GUITAR_STRINGS_BASE_TONE = "music_guitar_string_id"
    
    // ユーザ設定の各弦の音階値のキーを取得する
    // @param index 弦ID
    // @return キー
    static func getUserDefaultsMusicGuitarStringsBaseTone (index : Int) -> String {
        
        return USERDEFAULTS_KEY_MUSIC_GUITAR_STRINGS_BASE_TONE + "_" + String(index)
    }
    
    // 各弦の音階値を取得する
    // @param index 弦ID
    // @return 音階値
    static func getMusicGuitarStringsBaseTone (index : Int) -> Int {
        
        let ud = UserDefaults.standard;
        if(ud.object(forKey: getUserDefaultsMusicGuitarStringsBaseTone(index: index)) == nil){
            
            saveMusicGuitarStringsBaseTone(index: index,
                                           tone: KB.MUSIC_GUITAR_STRINGS_DEFAULT_BASE_TONES[index])
        }
        return ud.integer(forKey: getUserDefaultsMusicGuitarStringsBaseTone(index: index))
    }
    
    // 各弦の音階値を取得する
    // @returm [音階値]
    static func getMusicGuitarStringsBaseTones () -> [Int] {
        
        var tmpTones : [Int] = []
        
        for i in 0 ..< MUSIC_GUITAR_STRINGS_DEFAULT_BASE_TONES.count {
            
            tmpTones.append(getMusicGuitarStringsBaseTone(index: i))
        }
        return tmpTones
    }
    
    // 各弦の音階値を保存する
    // @param index 弦ID
    // @param tone 音階値
    static func saveMusicGuitarStringsBaseTone (index : Int, tone : Int) {
        
        let ud = UserDefaults.standard
        ud.set(tone, forKey: getUserDefaultsMusicGuitarStringsBaseTone(index: index))
        
        ud.synchronize()
    }
    
    // 各弦の音階値を削除する
    // @param index 弦ID
    static func removeMusicGuitarStringsBaseTone (index : Int) {
        
        let ud = UserDefaults.standard
        ud.removeObject(forKey: getUserDefaultsMusicGuitarStringsBaseTone(index: index))
    }
    
    // 各弦の音階値を削除する
    static func removeMusicGuitarStringsBaseTones () {
        
        for i in 0 ..< MUSIC_GUITAR_STRINGS_DEFAULT_BASE_TONES.count {
            
            removeMusicGuitarStringsBaseTone(index: i)
        }
    }

    // UserDefaultのデータを全消去する
    static func clearUserDefaultsData () {
        
        removeMusicNoteAccidentalId()
        removeMusicGuitarStringsBaseTones()
    }
}
