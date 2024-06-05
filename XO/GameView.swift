//
//  GameView.swift
//  Labeeb
//
//  Created by lana alfaadhel on 13/05/2024.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                
                HeaderView()
                
                Spacer()
                
                LazyVGrid(columns: viewModel.gameGrid, spacing: 10) {
                    ForEach(0..<9){ i in
                        Tile(viewModel: viewModel, i: i)
                            .onTapGesture {viewModel.processPlayerMove(for: i)}
                    }
                }
                
                Spacer()
                
                HStack {
                    PlayerCard(viewModel: viewModel, text: Text("You"), isHuman: true)
                    
                    Spacer()
                    
                    PlayerCard(viewModel: viewModel, text: Text("AI"), isHuman: false)
                }
                .padding()
                
                Spacer()
                
            }
            .disabled(viewModel.isBoardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.resetButtonText, action: {
                    viewModel.resetGame()
                }))
                
            }
            
        }
        
    }
    
}












#Preview {
    GameView()
}

