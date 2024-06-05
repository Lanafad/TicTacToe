//
//  CustomViews.swift
//  XO
//
//  Created by lana alfaadhel on 06/06/2024.
//

import SwiftUI


struct Tile: View {
    @StateObject var viewModel : GameViewModel
    @State var i : Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 100, height: 100)
                .foregroundStyle(viewModel.tileColor(for: i))
                .animation(Animation.easeIn(duration: 0.2))
            
            Image(systemName: viewModel.moves[i]?.indicator ?? "")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.text)
            
        }
    }
}

struct PlayerCard: View {
    @StateObject var viewModel : GameViewModel
    @State var text : Text
    @State var isHuman : Bool
    
    var body: some View {
        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 20, bottomTrailing: 20))
            .frame(width: 100, height: 60)
            .foregroundStyle(
                isHuman ?
                RadialGradient(colors: viewModel.computerTurn ? [.tiles] : [.xTile, .tiles], center: .center, startRadius: 10, endRadius: 60)
                :
                    RadialGradient(colors: viewModel.computerTurn ? [.oTile, .tiles] : [.tiles], center: .center, startRadius: 10, endRadius: 60)
                
                
            )
            .animation(Animation.easeOut(duration: 0.3))
            .overlay {
                text
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(.text)
            }
    }
}

struct HeaderView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(height: 100)
                .foregroundStyle(.tiles)
            
            Text("Tic Tac Toe")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundStyle(.text)
        }
    }
}
