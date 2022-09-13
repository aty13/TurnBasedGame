/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An extension for turn-based games that handles match data that the game sends between players.
*/

import Foundation
import GameKit
import SwiftUI

// MARK: Game Data Objects

// A message that one player sends to another.
struct Message: Identifiable {
    var id = UUID()
    var content: String
    var playerName: String
    var isLocalPlayer: Bool = false
}

// A participant object with their items.
struct Participant: Identifiable {
    var id = UUID()
    var player: GKPlayer
    var avatar = Image(systemName: "person")
    var items = 50
}

extension TurnBasedGame {
    
    // MARK: Archiving Game Data
    
    /// Returns a data representation of the game data that you pass between players.
    ///
    /// - Returns: An archive of a property list with key-value pairs that represent the match state.
    func archiveMatchData() -> Data? {
        // The property list keys are [
        //    "score": count,
        //    [local player's identifier]: myItems,
        //    [opponent's identifier]: opponentItems ]
        var gamePropertyList: [String: Any] = [:]
        
        // Add the score.
        gamePropertyList["score"] = String(describing: count)
        
        // Include the local player's items.
        if let localParticipant = self.localParticipant {
            gamePropertyList[localParticipant.player.displayName] = String(describing: localParticipant.items)
        }
        
        // Include the opponent items when an opponent joins the match.
        if let opponent = self.opponent {
            gamePropertyList[opponent.player.displayName] = String(describing: opponent.items)
        }

        // Archive the property list and return the Data object.
        do {
            let gameData = try PropertyListSerialization.data(fromPropertyList: gamePropertyList,
                                                              format: PropertyListSerialization.PropertyListFormat.binary,
                                                              options: 0)
            return gameData
        } catch {
            print("Error: \(error.localizedDescription).")
            return nil
        }
    }
    
    /// Sets the match state to the provided game data.
    ///
    /// Unarchives a property list representation of the game data with key-value pairs that represent the match state.
    /// - Parameter matchData: A data representation of the match state that another game instance creates using the `archiveMatchData()` method.
    func unarchiveMatchData(matchData: Data) {
        do {
            // Convert the Data object to a property list.
            if let gamePropertyList: [String: Any] =
                try PropertyListSerialization.propertyList(from: matchData, format: nil) as? [String: Any] {
                
                // Restore the score from the property list.
                if let countString: String = gamePropertyList["score"] as? String {
                    count = Int(countString)!
                }

                // Restore the local player's items.
                if let items: String = gamePropertyList[self.localParticipant!.player.displayName] as? String {
                    self.localParticipant?.items = Int(items)!
                }

                // Restore the opponent's items.
                if let opponentItems: String = gamePropertyList[self.opponent!.player.displayName] as? String {
                    self.opponent?.items = Int(opponentItems)!
                }
            }
        } catch {
            print("Error: \(error.localizedDescription).")
        }
    }
}
