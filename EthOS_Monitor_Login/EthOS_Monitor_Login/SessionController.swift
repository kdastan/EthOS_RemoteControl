//
//  SessionController.swift
//  EthOSRemoteLogin
//
//  Created by Bradley GIlmore on 9/13/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import Foundation
import NMSSH

class SessionController: NSObject, NMSSHChannelDelegate {
    
    static let shared = SessionController()
    
    var session: NMSSHSession?
    var channel: NMSSHChannel?
    weak var delegate:CommandsViewController?
    weak var segueDelegate:MinersMainViewController?
    
    //MARK: - Connection Start / End
    
    func startConnection(ip: String) {
        //FIXME: - This is going to have to take into account the ipaddress, username, and password for each specific rig
        self.session = NMSSHSession(host: ip, andUsername: "ethos")!
        guard let session = session else { NSLog("Session is Nil"); return }
        session.connect()
        if session.isConnected == true {
            session.authenticate(byPassword: "live")
            if session.isAuthorized == true {
                print("works")
                
                self.channel = NMSSHChannel.init(session: session)!
                guard let channel = channel else { NSLog("Channel Is Nil"); return }
                channel.delegate = self
                channel.requestPty = true
                
                try? channel.startShell()
                
                Timer.scheduledTimer(withTimeInterval: 15.0, repeats: false, block: { (_) in
                    
                    self.sendCommand(command: " ")
                })
            }
        } else if session.isConnected == false {
            segueDelegate?.showNoConnection()
        }
    }
    
    func endConnection() {
        self.session = nil
    }
    
    //MARK: - Send Commands
    
    func sendCommand(command: String) {
        guard let channel = self.channel else { NSLog("Channel Is Nil"); return }
        try? channel.write("\(command)\n")
        print("Command Exucuting")
    }
    
    //MARK: - NMSSH Channel Deleaget Methods
    
    func channel(_ channel: NMSSHChannel!, didReadData message: String!) {
        print("Reading Data: \(message!)")
        delegate?.updateViews(message: message)
        if message.contains("Welcome to ethOS") {
            DispatchQueue.main.async {
                
                self.segueDelegate?.performSegue()
            }
        }
    }
    
    func channel(_ channel: NMSSHChannel!, didReadRawError error: Data!) {
        print("Error \(error)")
    }
    
    func channel(_ channel: NMSSHChannel!, didReadError error: String!) {
        print("Error \(error)")
    }
    
    func channelShellDidClose(_ channel: NMSSHChannel!) {
        print("Shell Did Close Called")
    }
    
}

protocol segueDelegate: class {
    func performSegue()
    func showNoConnection()
}

protocol CommandsViewControllerDelegate: class {
    func updateViews(message: String)
}

