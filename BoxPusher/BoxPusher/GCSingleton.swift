//
//  GCSingleton.swift
//  BoxPusher
//
//  Created by Levi Hand on 9/16/16.
//  Copyright © 2016 Levi Hand. All rights reserved.
//

import Foundation
import GameKit

//Global scope score variable
var score = 0

class GCSingleton {
    // Intitializing a static, shared instance of this class
    static let sharedInstance = GCSingleton()
    // Initializing variables
    var enabled: Bool! // If the user has GameCenter enabled
    var leaderBoard: String! // Leaderboard ID
    // Create a function that takes the current score as an integer to save the high score
    func saveHS(playerScore: Int) {
        //Perform a check to ensure that the player has been authenticated. If not, throw an error.
        if GKLocalPlayer.localPlayer().authenticated {
            let scoreGK = GKScore(leaderboardIdentifier: leaderBoard)
            scoreGK.value = Int64(playerScore)
            let scoreArray: [GKScore] = [scoreGK]
            GKScore.reportScores(scoreArray, withCompletionHandler: {error -> Void in
                if error != nil {
                    print(error)
                }
            })
        }
    }
}
