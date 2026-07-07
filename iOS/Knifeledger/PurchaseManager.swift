import Foundation
import StoreKit

@MainActor
final class PurchaseManager: ObservableObject {
    static let productId = "com.shimondeitel.knifecare.pro"

    @Published var isPurchased: Bool = false
    @Published var product: Product?

    private var updatesTask: Task<Void, Never>?

    init() {
        updatesTask = Task { [weak self] in
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    await self?.handle(transaction)
                }
            }
        }
        Task { await self.loadProduct() }
        Task { await self.refreshEntitlements() }
    }

    deinit {
        updatesTask?.cancel()
    }

    func loadProduct() async {
        do {
            let products = try await Product.products(for: [Self.productId])
            product = products.first
        } catch {
            print("Failed to load product: \(error)")
        }
    }

    func purchase() async {
        guard let product else { return }
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                if case .verified(let transaction) = verification {
                    await handle(transaction)
                }
            default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }

    func restore() async {
        try? await AppStore.sync()
        await refreshEntitlements()
    }

    private func handle(_ transaction: Transaction) async {
        isPurchased = true
        await transaction.finish()
    }

    private func refreshEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.productID == Self.productId {
                isPurchased = true
            }
        }
    }
}
