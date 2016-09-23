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
    // MARK: Game Center Achievements
    
    var loadedAchievements = [GKAchievement]()
    
    /*Create a function that will load the progress for achievements from game center. */
    func gcLoadAchievements() {
        GKAchievement.loadAchievementsWithCompletionHandler({ (loadedAchievements, error:NSError?) -> Void in
            if error != nil{
                print(error)
            }
        })
    }
    /* Take the string literal of an achievement in as an argument, and use that to populate an
     achievement report, updating said achievement to 100 percent, appending it to a GKAchievement array,
     then reporting it to Game Center. Also, enable the standard notification banner. */
    func reportAchievement(achievement: String) {
        var gameAchievement = [GKAchievement]()
        let report = GKAchievement.init(identifier: achievement)
        report.showsCompletionBanner = true
        report.percentComplete = 100.0
        gameAchievement.append(report)
        GKAchievement.reportAchievements(gameAchievement, withCompletionHandler: nil)
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    var powerUpCount: Int = 0
    //Retrieve the power up count from the defaults
    func getPUDefault() {
        if (defaults.objectForKey("powerUps") != nil) {
            powerUpCount = defaults.integerForKey("powerUps")
        }
    }
    //Save the power up count to device defaults
    func powerUpSave() {
        defaults.setObject(powerUpCount, forKey: "powerUps")
    }
    
    
}
