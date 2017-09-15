//
//  MinerController.swift
//  EthOS_Monitor_Login
//
//  Created by Bradley GIlmore on 9/15/17.
//  Copyright © 2017 Bradley Gilmore. All rights reserved.
//

import Foundation

class MinerController {
    
    //MARK: - Properties
    
    static let shared = MinerController()
    
    var miners: [Miner] = []
    
    func createMiners(dictionary: [String: Any]) {
        
        for (key, value) in dictionary {
            
            let minerInfo = dictionary[key] as? [String: Any]
            
            guard let newMiner = Miner(dictionary: minerInfo!) else { NSLog("Miner Is Nil during Creation"); return }
            miners.append(newMiner)
        }

        
        print("done")
    }
    
}