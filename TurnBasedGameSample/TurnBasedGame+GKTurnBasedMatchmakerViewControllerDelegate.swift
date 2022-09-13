/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An extension for turn-based games that handles turn-based matchmaker view controller delegate callbacks.
*/

import Foundation
import GameKit
import SwiftUI

extension TurnBasedGame: GKTurnBasedMatchmakerViewControllerDelegate {
    
    /// Dismisses the view controller when either player cancels matchmaking.
    func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
        viewController.dismiss(animated: true)
        
        // Remove the game view.
        resetGame()
    }
    
    /// Handles an error during the matchmaking process and dismisses the view controller.
    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription).")
        viewController.dismiss(animated: true)
        
        // Remove the game view.
        resetGame()
    }
    
    /// Dismisses the view controller when the local player starts a match.
    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController,
                                           didFind match: GKTurnBasedMatch) {
        // Dismiss the view controller.
        viewController.dismiss(animated: true)
    }
}

