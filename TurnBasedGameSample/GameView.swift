/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The view that displays the game play interface.
*/

import SwiftUI

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var game: TurnBasedGame
    @State private var showMessages: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Display the game title.
            Text("Turn-Based Game")
                .font(.title)
            
            Form {
                Section("Game Data") {
                    HStack {
                        game.myAvatar
                            .resizable()
                            .frame(width: 35.0, height: 35.0)
                            .clipShape(Circle())
                        Spacer()
                        
                        Text(game.myName)
                            .lineLimit(2)
                        Spacer()
                        
                        Text("\(game.myItems)")
                            .lineLimit(2)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    .background(
                        .blue.opacity(game.myTurn ? 0.25 : 0),
                        in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                    
                    HStack {
                        game.opponentAvatar
                            .resizable()
                            .frame(width: 35.0, height: 35.0)
                            .clipShape(Circle())
                        Spacer()
                        
                        Text(game.opponentName)
                            .lineLimit(2)
                        Spacer()
                        
                        Text("\(game.opponentItems)")
                            .lineLimit(2)
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    .background(
                        .blue.opacity(game.myTurn ? 0 : 0.25),
                        in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                    
                    HStack {
                        Text("Count")
                            .lineLimit(2)
                        Spacer()
                        
                        Text("\(game.count)")
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    
                    if let matchMessage = game.matchMessage {
                        HStack {
                            Text("Match Message")
                                .lineLimit(2)
                            Spacer()
                            Text(matchMessage)
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    }
                }
                Section("Exchanges") {
                    // Send a request to exchange an item.
                    Button("Exchange Item") {
                        Task {
                            await game.exchangeItem()
                        }
                    }
                    .disabled(game.opponent == nil)
                    
                    // Send a text message that initiates an exchange of items.
                    Button("Message") {
                        withAnimation(.easeInOut(duration: 1)) {
                            showMessages = true
                        }
                    }
                    .buttonStyle(MessageButtonStyle())
                    .onTapGesture {
                        dismiss()
                    }
                }
                Section("Communications") {
                    // Send a reminder to take their turn.
                    Button("Send Reminder") {
                        Task {
                            await game.sendReminder()
                        }
                    }
                    .disabled(game.myTurn)
                }
                Section("Game Controls") {
                    Button("Take Turn") {
                        Task {
                            await game.takeTurn()
                        }
                    }
                    .disabled(!game.myTurn)
                    
                    Button("Forfeit") {
                        dismiss()
                        Task {
                            await game.forfeitMatch()
                        }
                    }
                    
                    Button("Back") {
                        game.quitGame()
                        dismiss()
                    }
                }
            }
        }
        // Display the text message view if it's enabled.
        .sheet(isPresented: $showMessages) {
            ChatView(game: game)
        }
    }
}

struct GameViewPreviews: PreviewProvider {
    static var previews: some View {
        GameView(game: TurnBasedGame())
    }
}

struct MessageButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: configuration.isPressed ? "bubble.left.fill" : "bubble.left")
                .imageScale(.medium)
        }
    }
}
