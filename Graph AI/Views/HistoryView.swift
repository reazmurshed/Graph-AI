import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \AnalysisRecord.date, order: .reverse) private var records: [AnalysisRecord]
    @State private var selectedRecord: AnalysisRecord?
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var filteredRecords: [AnalysisRecord] {
        AnalysisRecord.filterOldRecords(records)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(filteredRecords) { record in
                    HistoryCard(record: record)
                        .onTapGesture {
                            selectedRecord = record
                        }
                        .rotationEffect(.degrees(Double.random(in: -5...5)))
                        .padding(5)
                }
            }
            .padding()
        }
        .background(Color(hex: "1A1A1A"))
        .navigationTitle("History")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(Color.green)
                }
                .padding(.trailing, 8)
                .padding(.top, 8)
            }
        }
        .sheet(item: $selectedRecord) { record in
            if let image = UIImage(data: record.imageData) {
                AnalysisResultView(
                    analysis: record.analysis,
                    image: image,
                    onBack: { selectedRecord = nil }
                )
            }
        }
    }
    
    private func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(records[index])
        }
        try? modelContext.save()
    }
}

struct HistoryCard: View {
    let record: AnalysisRecord
    @Environment(\.modelContext) private var modelContext
    @State private var rotation = Double.random(in: -5...5)
    
    var body: some View {
        if let image = UIImage(data: record.imageData) {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 160)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 0, z: 1))
                    .animation(.spring(dampingFraction: 0.6), value: rotation)
                
                // Botón de eliminar
                Button(action: {
                    modelContext.delete(record)
                    try? modelContext.save()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 22))
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                .padding(8)
            }
        }
    }
}

#Preview {
    NavigationView {
        HistoryView()
    }
    .modelContainer(PreviewContainer([AnalysisRecord.self]).container)
} 