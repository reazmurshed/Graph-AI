import SwiftUI
import SwiftData
import Foundation

@Model
final class AnalysisRecord: Identifiable {
    let id: UUID
    let imageData: Data
    let analysis: GraphAnalysis
    let date: Date
    
    init(imageData: Data, analysis: GraphAnalysis) throws {
        self.id = UUID()
        self.imageData = imageData
        self.analysis = analysis
        self.date = Date()
    }
    
    static func filterOldRecords(_ records: [AnalysisRecord]) -> [AnalysisRecord] {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return records.filter { $0.date >= sevenDaysAgo }
    }
} 