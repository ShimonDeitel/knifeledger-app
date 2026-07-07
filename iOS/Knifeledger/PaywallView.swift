import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(Theme.accent)
                .padding(.top, 32)

            Text("Knifeledger Pro")
                .font(Theme.titleFont)
                .foregroundStyle(Theme.textPrimary)

            Text("Sharpening reminders and maintenance history export")
                .font(Theme.bodyFont)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.textPrimary.opacity(0.85))
                .padding(.horizontal, 32)

            Spacer()

            Button(action: {
                isPurchasing = true
                Task {
                    await purchaseManager.purchase()
                    isPurchasing = false
                    if purchaseManager.isPurchased { dismiss() }
                }
            }) {
                if isPurchasing {
                    ProgressView().tint(.white)
                } else if let product = purchaseManager.product {
                    Text("Unlock — \(product.displayPrice)")
                        .fontWeight(.semibold)
                } else {
                    Text("Unlock Pro")
                        .fontWeight(.semibold)
                }
            }
            .accessibilityIdentifier("paywallPurchaseButton")
            .buttonStyle(.borderedProminent)
            .tint(Theme.accent)
            .padding(.horizontal, 32)

            Button("Restore Purchases") {
                Task { await purchaseManager.restore() }
            }
            .accessibilityIdentifier("restorePurchasesButton")
            .font(.footnote)
            .foregroundStyle(Theme.textPrimary.opacity(0.7))

            Button("Not Now") { dismiss() }
                .accessibilityIdentifier("paywallDismissButton")
                .font(.footnote)
                .foregroundStyle(Theme.textPrimary.opacity(0.5))
                .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.background.ignoresSafeArea())
    }
}
