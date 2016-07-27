//
//  AppDelegate.swift
//  wifiwarn
//
//  Created by Cole Mickens on 7/26/16.
//  Copyright © 2016 Cole Mickens. All rights reserved.
//

import Cocoa
import CoreWLAN

// TODO: Some icons that don't suck

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let statusItem: NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
    let popover: NSPopover = NSPopover()
    let warnList: Set<String> = ["MickensHotspot"]
    
    var wifiInterface: CWInterface = CWWiFiClient.sharedWiFiClient().interface()!
    
    var ssidObserver: NSObjectProtocol!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        let secondsBetweenChecks: NSTimeInterval = 10
        
        let _ = NSTimer.scheduledTimerWithTimeInterval(
            secondsBetweenChecks,
            target: self,
            selector: #selector(checkWifiNetwork),
            userInfo: nil,
            repeats: true)
        
        // TODO: Make the wifi events actually work
        registerForWifiChangeEvents()
        
        checkWifiNetwork()
        
        popover.contentViewController = WifiViewController(nibName: "WifiViewController", bundle: nil)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func registerForWifiChangeEvents() {
        self.ssidObserver = NSNotificationCenter.defaultCenter().addObserverForName(
            CWSSIDDidChangeNotification,
            object: nil, queue: nil,
            usingBlock: ssidChanged)
        
        print("registered for events")
    }
    
    func ssidChanged(notification: NSNotification) {
        print("wifi change event received")
        
        checkWifiNetwork()
    }
    
    func checkWifiNetwork() {
        print("checking the wifi ssid")
        
        if let ssid = self.wifiInterface.ssid() {
            print("ssid = ", ssid)
            if warnList.contains(ssid) {
                self.setButtonIcon(false)
            } else {
                self.setButtonIcon(true)
            }
        }
    }
    
    func setButtonIcon(good: Bool) {
        print("showing icon: ", good ? "good" : "bad")
        
        if let button = self.statusItem.button {
            button.image = good ? NSImage(named: "goodwifi") : NSImage(named: "badwifi")
            // button.action = #selector(togglePopover)
        }
    }
    
    /*
    
     // TODO: implement a UI to allow the user to change which networks warn
     
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            self.popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        self.popover.performClose(sender)
    }

    
    func togglePopover(sender: AnyObject?) {
        if self.popover.shown {
            self.closePopover(sender)
        } else {
            self.showPopover(sender)
        }
    }
    */
}

