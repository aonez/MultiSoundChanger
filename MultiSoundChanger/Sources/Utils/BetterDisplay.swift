//
//  BetterDisplay.swift
//  MultiSoundChanger
//
//  Created by aone on 29.11.24.
//  Copyright © 2021 Dmitry Medyuho. All rights reserved.
//

import Foundation

enum BetterDisplay {
    private static let executablePath = "/Applications/BetterDisplay.app/Contents/MacOS/BetterDisplay"
    
    private static func isInstalled() -> Bool {
        FileManager.default.fileExists(atPath: BetterDisplay.executablePath)
    }
    
    ///
    /// While there's DistributedNotificationCenter based integration available by using CLIinstead
    /// we assure the command will execute even if BetterDisplay wasn't already running.
    ///
    @discardableResult
    static private func set(_ parameter: String, value: String, deviceName: String) -> String? {
        if BetterDisplay.isInstalled() {
            let bdCmd = "\(BetterDisplay.executablePath) set -n=\"\(deviceName)\" -\(parameter)=\(value)"
            Logger.debug("Executing BetterDisplay command: \(bdCmd)")
            return Runner.shell(bdCmd)
        }
        return nil
    }
    
    @discardableResult
    static func setVolume(_ volume: Float, deviceName: String) -> String? {
        return BetterDisplay.set("volume", value: String(volume), deviceName: deviceName)
    }
    
    @discardableResult
    static func mute(_ mute: Bool, deviceName: String) -> String? {
        return BetterDisplay.set("mute", value: mute ? "on" : "off", deviceName: deviceName)
    }
}
