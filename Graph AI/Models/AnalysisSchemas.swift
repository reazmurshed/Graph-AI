import SwiftData
import Foundation

enum AnalysisSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] = [
        AnalysisRecord.self
    ]
    
    @Model
    final class AnalysisRecord {
        let id: UUID
        let imageData: Data
        let analysis: GraphAnalysis
        let date: Date
        
        init(id: UUID, imageData: Data, analysis: GraphAnalysis, date: Date) {
            self.id = id
            self.imageData = imageData
            self.analysis = analysis
            self.date = date
        }
    }
}

enum AnalysisSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    
    static var models: [any PersistentModel.Type] = [
        AnalysisRecord.self
    ]
    
    @Model
    final class AnalysisRecord {
        let id: UUID
        let imageData: Data
        let analysis: GraphAnalysis
        let date: Date
        
        init(id: UUID, imageData: Data, analysis: GraphAnalysis, date: Date) {
            self.id = id
            self.imageData = imageData
            self.analysis = analysis
            self.date = date
        }
    }
} 