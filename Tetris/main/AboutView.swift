import SwiftUI
import MapKit

struct Marker: Identifiable {
    let id = UUID()
    var marker: MapMarker
}

let universityCoordinate = CLLocationCoordinate2D(latitude: 55.754070, longitude: 37.648446)

struct AboutView: View {
    var authors = ["Zheliba Egor", "Pasiletskiy Daniil", "Khabibulina Alsu", "Shubin Nikita", "Troitskiy Maxim"]
    
    @State var showingShareSheet = false
    @State var showCopiedMessage = false
    
    let markers = [Marker(marker: MapMarker(coordinate: universityCoordinate, tint: .blue))]
    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: universityCoordinate, latitudinalMeters: 250, longitudinalMeters: 250)), annotationItems: markers) { marker in
                marker.marker
            }
                .frame(height: 300)
                .cornerRadius(10)
            
            Text(String(localized: "Welcome to Tetris AR App"))
                .padding(32)
            
            Spacer()
            
            Text(String(localized: "This app implements the Tetris game in an AR space."))
            
            Spacer()
            
            Text(String(localized: "Authors (HSE Students):"))
            
            ForEach(authors, id: \.self) { author in
                Text(author)
            }
            
            EmailCopyView(email: "andrey3kmmr.2500@mail.ru", showCopiedMessage: $showCopiedMessage)
                .padding()
            Spacer()
            
            HStack {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .frame(width: 21, height: 29)
                    .padding(.leading, 2)
                Button("Share") {
                    showingShareSheet = true
                }
                .sheet(isPresented: $showingShareSheet) {
                    ActivityView(activityItems: [URL(string: "https://gitlab.com/dmalex/tetris-ar-game")!])
                }
            }
        }
    }
}

#Preview {
    AboutView()
}
