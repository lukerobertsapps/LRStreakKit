//
//  StreakView.swift
//  LRStreakKit
//
//  Created by Luke Roberts on 12/11/2024.
//

import SwiftUI

/// A customisable view displaying the current streak
public struct StreakView: View {

    // MARK: State

    @EnvironmentObject private var streak: StreakManager
    @State private var animation = false

    // MARK: Customisation

    private let streakColor: Color
    private let noStreakColor: Color
    private let backgroundColor: Color
    private let animateOnAppear: Bool
    private let font: Font
    private let imageHeight: CGFloat
    
    /// Creates the view
    /// - Parameters:
    ///   - streakColor: The tint color of the view when the streak has been continued
    ///   - noStreakColor: The tint color of the view when the streak hasn't been continued yet
    ///   - backgroundColor: The background color of the view
    ///   - animateOnAppear: Whether the view should animate when appearing and the streak has continued
    ///   - font: The font to use for the text
    ///   - imageHeight: The height of the image
    public init(
        streakColor: Color = .orange,
        noStreakColor: Color = .gray,
        backgroundColor: Color = Color(.systemBackground),
        animateOnAppear: Bool = true,
        font: Font = .system(size: 18, weight: .bold, design: .rounded),
        imageHeight: CGFloat = 24
    ) {
        self.streakColor = streakColor
        self.noStreakColor = noStreakColor
        self.backgroundColor = backgroundColor
        self.animateOnAppear = animateOnAppear
        self.font = font
        self.imageHeight = imageHeight
    }

    public var body: some View {
        HStack {
            Text("\(streak.getStreakLength())")
                .font(font)
            image
        }
        .foregroundStyle(streak.hasCompletedStreak() ? streakColor : noStreakColor)
        .padding(12)
        .background(
            backgroundColor
                .clipShape(.rect(cornerRadius: 12))
                .shadow(color: .gray.opacity(0.6), radius: 2, y: 2)
        )
        .onAppear {
            if streak.hasCompletedStreak() && animateOnAppear {
                withAnimation {
                    animation.toggle()
                }
            }
        }
#if DEBUG
        .onTapGesture {
            withAnimation {
                animation.toggle()
            }
        }
#endif
    }

    @ViewBuilder private var image: some View {
        if #available(iOS 17.0, *) {
            Image(systemName: "flame.circle.fill")
                .resizable()
                .frame(width: imageHeight, height: imageHeight)
                .symbolRenderingMode(.hierarchical)
                .symbolEffect(.bounce, options: .speed(0.8), value: animation)
        } else {
            Image(systemName: "flame.circle.fill")
                .resizable()
                .frame(width: imageHeight, height: imageHeight)
                .symbolRenderingMode(.hierarchical)
        }
    }
}

#Preview {
    StreakView()
        .environmentObject(StreakManager())
}
