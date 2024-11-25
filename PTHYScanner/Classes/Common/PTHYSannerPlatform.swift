
import Foundation

struct PTHYSannerPlatform {
    static let isSimulator: Bool = {
        #if swift(>=4.1)
          #if targetEnvironment(simulator)
            return true
          #else
            return false
          #endif
        #else
        #if targetEnvironment(simulator)
            return true
          #else
            return false
          #endif
        #endif
    }()
}
