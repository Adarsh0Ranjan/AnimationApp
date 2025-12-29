//
//  ContentView.swift
//  EditorialListAssingment
//
//  Created by Adarsh Ranjan on 24/12/25.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Layout Constants
    private let subtotalTopPadding: CGFloat = 24
    private let subtotalBottomPadding: CGFloat = 24
    private let collapsedTopPadding: CGFloat = 16
    private let subtotalTextHeight: CGFloat = 18
    private let animationDuration: Double = 0.8

    // MARK: - Computed Properties
    private var initialSpacerHeight: CGFloat {
        subtotalTopPadding + subtotalBottomPadding + subtotalTextHeight
    }

    private var slideDistance: CGFloat {
        initialSpacerHeight - collapsedTopPadding
    }

    // MARK: - State
    @State private var isOrderPlaced = false
    @State private var showOnlyCheckmark = false

    // MARK: - Body
    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.95, blue: 0.95)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Footer section
                VStack(spacing: 0) {
                    // Divider - stays in place
                    Rectangle()
                        .fill(Color.black.opacity(0.1))
                        .frame(height: 1)

                    ZStack(alignment: .top) {
                        // Subtotal row - will slide down off screen
                        HStack {
                            Text("Subtotal")
                                .font(.system(size: 18, weight: .regular))
                                .foregroundColor(Color.black.opacity(0.6))

                            Spacer()

                            Text("$2,636")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color.black.opacity(0.6))
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, subtotalTopPadding)
                        .padding(.bottom, subtotalBottomPadding)
                        .offset(y: isOrderPlaced ? slideDistance : 0)
                    }
                    .frame(height: isOrderPlaced ? collapsedTopPadding : initialSpacerHeight)
                    .clipped() // Hide overflow when subtotal slides down

                    // Place Order button with animation
                    Button {
                        withAnimation(.easeInOut(duration: animationDuration)) {
                            isOrderPlaced = true
                        }

                        // Phase 3: Show only checkmark after a delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                showOnlyCheckmark = true
                            }
                        }
                    } label: {
                        GeometryReader { geometry in
                            ZStack {
                                // Old content: Black background + "Place Order" sliding out to right
                                HStack(spacing: 8) {
                                    Text("Place Order")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                .frame(width: geometry.size.width, height: 44)
                                .background(Color.black)
                                .offset(x: isOrderPlaced ? geometry.size.width : 0)

                                // New content: White background + "Order placed" + icon sliding in from left
                                HStack(spacing: 8) {
                                    if !showOnlyCheckmark {
                                        Text("Order placed")
                                            .font(.system(size: 16, weight: .medium))
                                            .opacity(showOnlyCheckmark ? 0 : 1)
                                    }

                                    Image(systemName: "checkmark.circle")
                                        .font(.system(size: 18, weight: .regular))
                                }
                                //                                .foregroundColor(Color.black.opacity(0.6))
                                .frame(width: geometry.size.width, height: 44)
                                .background(Color.white)
                                .overlay {
                                    Rectangle()
                                        .stroke(Color.black, lineWidth: 1)
                                }
                                .offset(x: isOrderPlaced ? 0 : -geometry.size.width)
                            }
                            .clipped() // Clip the sliding content
                        }
                        .frame(height: 44)
                    }
                    .buttonStyle(.plain)
                    //                    .disabled(isOrderPlaced)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
