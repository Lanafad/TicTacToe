//
//  GameViewModel.swift
//  XO
//
//  Created by lana alfaadhel on 05/06/2024.
//

import SwiftUI

final class GameViewModel : ObservableObject {
    
    //VARIABLES
    
    @Published var gameGrid = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Published var moves : [Move?] = Array(repeating: nil, count: 9)
    @Published var isBoardDisabled = false
    @Published var alertItem : AlertItem?
    @Published var computerTurn = false
    @Published var winningTiles : [Int] = []
    @Published var winner : Player?
    
    
    //FUNCTIONS
    func processPlayerMove(for i: Int) {
        if isSquarOccupied(in: moves, forIndex: i) { return }
        moves[i] = Move(player: .human, boardIndex: i)
        
        //Check For Win Or Draw Conditions
        
        if let winPosition = checkWinCondition(for: .human, in: moves) {
            winningTiles = winPosition
            winner = .human
            alertItem = AlertConext.humanWon
            return
        }
        
        if checkForDraw(in: moves){
            alertItem = AlertConext.draw
            return
        }
        
        isBoardDisabled = true
        computerTurn = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [self] in
            let computerPosition = determineComputerPosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isBoardDisabled = false
            computerTurn = false
            
            if let winPosition = checkWinCondition(for: .computer, in: moves) {
                winningTiles = winPosition
                winner = .computer
                alertItem = AlertConext.computerWon
                return
            }
            
            
            if checkForDraw(in: moves){
                alertItem = AlertConext.draw
                return
            }
            
        }
    }
    
    func isSquarOccupied(in moves: [Move?], forIndex index : Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determineComputerPosition(in moves: [Move?]) -> Int {
        
        // if AI can win then win
        let winPatterns : Set<Set<Int>> = [
            [0,1,2], [3,4,5], [6,7,8],
            [0,3,6], [1,4,7], [2,5,8],
            [0,4,8], [2,4,6]
        ]
        
        let computerMoves = moves.compactMap{ $0 }.filter{$0.player == .computer}
        let computerPosition = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPosition)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquarOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        
        
        // if AI can't win then block
        
        
        let humanrMoves = moves.compactMap{ $0 }.filter{$0.player == .human}
        let humanPosition = Set(humanrMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPosition)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquarOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        
        // if AI can't block then middle square
        
        if !isSquarOccupied(in: moves, forIndex: 4){
            return 4
        }
        
        
        
        // if AI can't take middle square then random
        var movePosition = Int.random(in: 0..<9)
        while isSquarOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
            
        }
        return movePosition
        
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> [Int]? {
        let winPatterns : Set<Set<Int>> = [
            [0,1,2], [3,4,5], [6,7,8],
            [0,3,6], [1,4,7], [2,5,8],
            [0,4,8], [2,4,6]
        ]
        
        let playerMoves = moves.compactMap{ $0 }.filter{$0.player == player}
        let playerPosition = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPosition){
            return Array(pattern)
        }
        
        return nil
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap {$0}.count == 9
    }
    
    func resetGame(){
        moves  = Array(repeating: nil, count: 9)
        winningTiles = []
        
    }
    
    func tileColor(for index: Int) -> Color {
        if winningTiles.contains(index) {
            return winner == .human ? Color.xTile : Color.oTile
        } else {
            return Color.tiles
        }
    }
    
    
    //ENUM / STRUCT
    enum Player {
        case human, computer
    }
    
    struct Move {
        let player : Player
        let boardIndex : Int
        
        var indicator : String {
            return player == .human ? "xmark" : "circle"
        }
    }
    
}
