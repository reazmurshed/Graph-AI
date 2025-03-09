//
//  PaywallHelper.swift
//  Graph AI
//
//  Created by Reaz Sumon on 7/3/25.
//

import UIKit
import RevenueCat


struct RevenueCat {
    static let api_key = "appl_uTZHllaprVGQjDuaDZrlEEhrdbb"
    static let entitlement = "Essential-Access-AppStore"
    static let offer_id = "autismhealth-offering"
}

class PaywallHelper {
    static var shared = PaywallHelper()
    var isRestoreOngoing: Bool = false
    var paywallId: String?
    
    @Published var allPackages: [Package]?
    @Published var isSubscribed: Bool = false
    @Published var selectedPackage: Package?

    // MARK: - Initialization
    private init() {
        configureRevenueCat()
    }

    func configureRevenueCat() {
        Purchases.configure(withAPIKey: RevenueCat.api_key)
    }
    
    /// Fetch available subscriptions
    func fetchProductPackages() {
        Purchases.shared.getOfferings { [weak self] offerings, error in
            guard let self else {
                return
            }
            if let offerings = offerings {
                if let currentOffering = offerings.current {
                    allPackages = currentOffering.availablePackages
                
                    print("✅ Available Packes: \(allPackages)")

                    for package in currentOffering.availablePackages {
                        print("📦 Package: \(package.storeProduct.localizedTitle) - \(package.storeProduct.price)")
                        
                        if let subscriptionPeriod = package.storeProduct.subscriptionPeriod {
                            
                            if subscriptionPeriod.unit == .year {
                                selectedPackage = package
                            }
                        }
                    }
                } else {
                    print("⚠️ No available offerings found.")
                }
            } else {
                print("Error fetching offerings: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    /// Purchase the selected subscription
    func purchase(package: Package, completion: @escaping (Bool) -> Void) {
        Purchases.shared.purchase(package: package) { (transaction, purchaserInfo, error, userCancelled) in
            if let error = error {
                print("Purchase failed: \(error.localizedDescription)")
                completion(false)
            } else {
                self.isSubscribed = purchaserInfo?.entitlements.active.isEmpty == false
                completion(self.isSubscribed)
            }
        }
    }
    
    /// Check subscription status when the app launches
    func checkSubscriptionStatus(completion: @escaping (Bool) -> Void) {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if let customerInfo = customerInfo {
                self.isSubscribed = customerInfo.entitlements.active.isEmpty == false
                completion(self.isSubscribed)
            } else {
                completion(false)
            }
        }
    }
    
    /// Restore subscription
    func restorePurchases(completion: @escaping (Bool) -> Void) {
        isRestoreOngoing = true
        Purchases.shared.restorePurchases { customerInfo, error in
            //... check customerInfo to see if entitlement is now active
            if let customerInfo = customerInfo {
                // Unlock that great "pro" content
                self.isSubscribed = customerInfo.entitlements.active.isEmpty == false
                completion(self.isSubscribed)
            } else {
                completion(false)
            }
            self.isRestoreOngoing = false
        }
    }
}
