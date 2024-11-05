import SwiftUI

struct ContentView: View {
    
    // Lista de cards
    @State private var cards: [Card] = []
    @State private var goToLoginPage = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    
                    HStack {
                        Button(action: {
                            goToLoginPage = true
                        }) {
                            Text("Sair")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        Text("Hello World")
                            .font(.headline)
                            .padding(.trailing)
                    }
                    .padding()

                    // Exibe os cards, se houver
                    List(cards) { card in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(card.Titulo)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text(card.descricao)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            AsyncImage(url: URL(string: card.UrlImagem)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.top, 10)
                    
                    Spacer() // Para garantir que o botão flutuante fique no fundo
                }
                
                // Botão flutuante no canto inferior direito
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            // Ação para o botão "+"
                            print("Botão + pressionado")
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                }
            }
            .onAppear {
                // Quando a view aparecer, buscar os dados da API
                fetchCards()
            }
            
            .navigationDestination(isPresented: $goToLoginPage) {
                LoginView()
                    .navigationBarBackButtonHidden(true) // Remove o botão de back da tela de login
            }
        }
    }
    
    
    func fetchCards() {
        guard let url = URL(string: "http://localhost:3000/dados") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erro ao buscar dados: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let fetchedCards = try decoder.decode([Card].self, from: data)
                
                DispatchQueue.main.async {
                    self.cards = fetchedCards
                }
                
            } catch {
                print("Erro ao decodificar os dados: \(error)")
            }
        }.resume()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

#Preview {
    ContentView()
}
