//
//  OnboardingScreen.swift
//  MoePay
//
//  Created by Sahil Karwasrsa on 06/07/26.
//

import SwiftUI

struct OnboardingScreen: View {
    @State private var viewModel = OnboardingViewModel()
    @Environment(AuthCoordinator.self) private var authCoordinator
    
    var body: some View {
        GeometryReader { geometry in
            let steps = viewModel.state.steps
            ZStack {
                Image(.onboardingEllipse)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .top
                    )
                    .ignoresSafeArea(edges: .top)

                VStack(spacing: 0) {

                    TabView(
                        selection: Binding(
                            get: {
                                viewModel.state.currentStep
                            },
                            set: {
                                viewModel.onAction(actions: .pageChange($0))
                            }
                        )
                    ) {
                        ForEach(Array(steps.enumerated()), id: \.offset) {
                            index,
                            step in
                            VStack(spacing: 0) {
                                VerticalSpacer(
                                    height: geometry.size.height * 0.2
                                )

                                Image(step.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 260)

                                VerticalSpacer(height: 64)

                                Text(step.title)
                                    .font(.system(size: 22, weight: .bold))
                                    .multilineTextAlignment(.center)

                                VerticalSpacer(height: 16)

                                Text(step.description)
                                    .font(.system(size: 15))
                                    .multilineTextAlignment(.center)

                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut, value: viewModel.state.currentStep)

                    PageIndicator(
                        total: steps.count,
                        current: viewModel.state.currentStep
                    )

                    VerticalSpacer(height: 36)

                    let buttonTitle: String =
                        if viewModel.state.currentStep == steps.count - 1 {
                            "Get Started"
                        } else { "Next" }

                    let buttonAction: () -> Void = {
                        if viewModel.state.currentStep == steps.count - 1 {
                            authCoordinator.push(.login)
                        } else {
                            viewModel.onAction(actions: .nextTap)
                        }
                    }

                    PrimaryButton(
                        title: buttonTitle,
                        action: buttonAction,
                        isLoading: false,
                        isEnabled: true
                    )
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
