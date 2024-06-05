//
//  Alert.swift
//  XO
//
//  Created by lana alfaadhel on 05/06/2024.
//

import SwiftUI


struct AlertItem : Identifiable {
    let id = UUID()
    let title : Text
    let message : Text
    let resetButtonText : Text
    }

struct AlertConext {
    static let humanWon = AlertItem(
        title: Text("Congrats!"),
        message: Text("You Have Defeated AI"),
        resetButtonText: Text("Play Again"))
        
    static let computerWon = AlertItem(
        title: Text("The AI Has won"),
        message: Text("You Can Beat It"),
        resetButtonText: Text("Play Again"))
    
    static let draw = AlertItem(
        title: Text("A Tie!"),
        message: Text("You Tied Places With The AI"),
        resetButtonText: Text("Rematch"))
    
    
    
}
