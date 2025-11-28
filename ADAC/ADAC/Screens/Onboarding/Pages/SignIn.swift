// Licensed under the Any Distance Source-Available License
//
//  SignIn.swift
//  ADAC
//
//  Created by Daniel Kuntz on 4/14/23.
//

import SwiftUI
import AuthenticationServices

/// Onboarding screen that shows a title, subtitle, and Sign In With Apple button
struct SignIn: View {
    var model: OnboardingViewModel

    let screenName = "AC Onboarding - Sign In"

    var body: some View {
        VStack(spacing: 6) {
            OnboardingTitleAndSubtitle(model: model)
                .padding(.bottom, 12)

            SignInWithAppleButton { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                do {
                    let auth = try result.get()
                    model.authorizationController(didCompleteWithAuthorization: auth)
                } catch {
                    print(error.localizedDescription)
                    // SHOW ERROR TOAST
                }
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: 55)
            .cornerRadius(10, style: .continuous)
            .shadow(color: .black.opacity(0.4), radius: 12)
            .padding(.bottom, 20)

            #if DEBUG
            MockModeButton()
                .padding(.bottom, 12)
            #endif

            PrivacyAndTerms(topText: "By signing in you agree to our")
        }
        .padding([.leading, .trailing], 25)
        .onAppear {
            Analytics.logEvent(screenName, screenName, .screenViewed)
        }
    }
}

#if DEBUG
/// A button that enables mock mode and bypasses authentication (DEBUG only)
struct MockModeButton: View {
    var body: some View {
        Button {
            MockMode.shared.enable()
            UIApplication.shared.transitionToTabBar()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "theatermasks.fill")
                Text("Demo Mode")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white.opacity(0.9))
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.orange.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.orange.opacity(0.6), lineWidth: 1)
                    )
            )
        }
    }
}
#endif

struct SignIn_Previews: PreviewProvider {
    static var model: OnboardingViewModel {
        let model = OnboardingViewModel()
        model.state = .signIn
        return model
    }

    static var previews: some View {
        SignIn(model: model)
    }
}
