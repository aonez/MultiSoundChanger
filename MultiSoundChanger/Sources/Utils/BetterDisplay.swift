//
//  BetterDisplay.swift
//  MultiSoundChanger
//
//  Created by aone on 29.11.24.
//  Copyright © 2021 Dmitry Medyuho. All rights reserved.
//

import AppKit

enum BetterDisplay {
    private static let executablePath = "/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay"
    private static let requestNotificationName = NSNotification.Name("com.betterdisplay.BetterDisplay.request")
    
    private struct IntegrationNotificationRequestData: Codable {
        var uuid: String?
        var commands: [String] = []
        var parameters: [String: String?] = [:]
    }

    private static let isInstalled: Bool = FileManager.default.fileExists(atPath: executablePath)
    
    private static func set(_ parameter: String, value: String, deviceName: String) {
        if !isInstalled {
            return
        }
        let data = IntegrationNotificationRequestData(uuid: UUID().uuidString, commands: ["n", "set"], parameters: [deviceName: "", parameter: value])
        do {
            let encodedData = try JSONEncoder().encode(data)
            if let encodedDataString = String(data: encodedData, encoding: .utf8) {
                DistributedNotificationCenter.default().postNotificationName(requestNotificationName, object: encodedDataString, userInfo: nil, deliverImmediately: true)
            }
        } catch {}
    }
    
    static func setVolume(_ volume: Float, deviceName: String) {
        set("volume", value: String(volume), deviceName: deviceName)
    }
    
    static func mute(_ mute: Bool, deviceName: String) {
        set("mute", value: mute ? "on" : "off", deviceName: deviceName)
    }
}
