import SwiftUI
import SwiftData

struct PreviewContainer {
    let container: ModelContainer
    
    init(_ types: [any PersistentModel.Type]) {
        let schema = Schema(types)
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            container = try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Could not create preview container: \(error)")
        }
    }
} 