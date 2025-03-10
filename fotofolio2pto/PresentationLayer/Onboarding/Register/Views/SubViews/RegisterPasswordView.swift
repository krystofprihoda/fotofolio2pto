import SwiftUI

struct RegisterPasswordView: View {
    var firstPassword: Binding<String>
    var firstPasswordError: String
    var isFirstPasswordHidden: Bool
    var onToggleFirstPasswordVisibility: () -> Void
    var secondPassword: Binding<String>
    var secondPasswordError: String
    var isSecondPasswordHidden: Bool
    var onToggleSecondPasswordVisibility: () -> Void
    var passwordsVerified: Bool
    var showSkeleton: Bool
    var onFirstPasswordChanged: () -> Void
    var onSecondPasswordChanged: () -> Void
    var onBackTap: () -> Void
    var onNextTap: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                if isFirstPasswordHidden {
                    SecureField(L.Onboarding.password, text: firstPassword)
                } else {
                    TextField(L.Onboarding.password, text: firstPassword)
                }
                Button(action: onToggleFirstPasswordVisibility) {
                    Image(systemName: isFirstPasswordHidden ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .font(.body)
            .frame(height: Constants.Dimens.textFieldHeight)
            .padding()
            .background(.textFieldBackground)
            .cornerRadius(Constants.Dimens.radiusXSmall)
            .onChange(of: firstPassword.wrappedValue) { _ in
                onFirstPasswordChanged()
            }
            .overlay(
                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                    .stroke(.mainAccent, lineWidth: 1)
                    .opacity(firstPasswordError.isEmpty ? 0 : 1)
            )
            
            if !firstPasswordError.isEmpty {
                Text(firstPasswordError)
                    .font(.footnote)
                    .foregroundColor(.mainAccent)
            }
            
            HStack {
                if isSecondPasswordHidden {
                    SecureField(L.Onboarding.confirmPassword, text: secondPassword)
                } else {
                    TextField(L.Onboarding.confirmPassword, text: secondPassword)
                }
                Button(action: onToggleSecondPasswordVisibility) {
                    Image(systemName: isSecondPasswordHidden ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .font(.body)
            .frame(height: Constants.Dimens.textFieldHeight)
            .padding()
            .background(.textFieldBackground)
            .cornerRadius(Constants.Dimens.radiusXSmall)
            .onChange(of: secondPassword.wrappedValue) { _ in
                onSecondPasswordChanged()
            }
            .overlay(
                RoundedRectangle(cornerRadius: Constants.Dimens.radiusXSmall)
                    .stroke(.mainAccent, lineWidth: 1)
                    .opacity(secondPasswordError.isEmpty ? 0 : 1)
            )
            
            if !secondPasswordError.isEmpty {
                Text(secondPasswordError)
                    .font(.footnote)
                    .foregroundColor(.mainAccent)
            }
            
            HStack {
                Button(action: onBackTap, label: {
                    Text(L.Onboarding.goBack)
                        .font(.body)
                        .frame(height: Constants.Dimens.textFieldHeight)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                        .background(.mainAccent)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                })
                
                Button(action: onNextTap, label: {
                    Text(L.Onboarding.next)
                        .font(.body)
                        .frame(height: Constants.Dimens.textFieldHeight)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                        .background(.mainAccent)
                        .cornerRadius(Constants.Dimens.radiusXSmall)
                })
                .disabled(!passwordsVerified)
                .skeleton(showSkeleton)
            }
        }
        .animation(.default, value: firstPasswordError)
        .animation(.default, value: secondPasswordError)
    }
}
