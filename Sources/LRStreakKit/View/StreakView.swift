//
//  StreakView.swift
//  LRStreakKit
//
//  Copyright © 2024 Luke Roberts. All rights reserved.

import SwiftUI

/// A customisable view displaying the current streak
public struct StreakView: View {

    // MARK: State

    @EnvironmentObject private var streak: StreakManager
    @State private var animation = false

    // MARK: Environment
    @Environment(\.colorScheme) private var color

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
        backgroundColor: Color? = nil,
        animateOnAppear: Bool = true,
        font: Font = .system(size: 18, weight: .bold, design: .rounded),
        imageHeight: CGFloat = 24
    ) {
        self.streakColor = streakColor
        self.noStreakColor = noStreakColor
        self.animateOnAppear = animateOnAppear
        self.font = font
        self.imageHeight = imageHeight
        if let backgroundColor {
            self.backgroundColor = backgroundColor
        } else {
            self.backgroundColor = Color(.streakBackground)
        }
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
                .if(color == .light) {
                    $0.shadow(color: .gray.opacity(0.4), radius: 2, y: 2)
                }
        )
        .onAppear {
            if streak.hasCompletedStreak() && animateOnAppear {
                Task {
                    try? await Task.sleep(nanoseconds: 5_000_000)
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
        .preferredColorScheme(.light)
}

extension View {
    @ViewBuilder func `if`<Content: View>(
        _ condition: Bool, transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
