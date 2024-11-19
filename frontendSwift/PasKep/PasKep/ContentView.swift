import SwiftUI

struct ContentView: View {
    
    // Lista de cards com dados de teste
    @State private var cards: [Card] = [
        Card(id: 1, titulo: "Card 1", descricao: "Descrição do Card 1", senha: "Senha123", urlImagem: "https://picsum.photos/500"),
        Card(id: 2, titulo: "Card 2222", descricao: "Descrição do Card 22222", senha: "22222222", urlImagem: "https://picsum.photos/500"),
        Card(id: 3, titulo: "Card 3", descricao: "Descrição do Card 2", senha: "Senh2a456", urlImagem: "https://picsum.photos/500"),
        Card(id: 4, titulo: "Card 4", descricao: "Descrição do Card 2", senha: "Senh4a456", urlImagem: "https://picsum.photos/500"),
        Card(id: 5, titulo: "Card 5", descricao: "Descrição do Card 3", senha: "Senh3a789", urlImagem: "https://picsum.photos/500")
    ]
    
    
    
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
                        
                        Text("Olá, Username")
                            .font(.headline)
                            .padding(.trailing)
                    }
                    .padding()

                    // Exibe os cards, se houver
                    List(cards) { card in
                        NavigationLink(destination: PassView(card: card)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(card.titulo)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text(card.descricao)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                AsyncImage(url: URL(string: card.urlImagem)) { image in
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
                        NavigationLink(destination: AddPassView()) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.blue)
                                .padding()
                        }
                    }
                }

            }
            .navigationDestination(isPresented: $goToLoginPage) {
                LoginView()
                    .navigationBarBackButtonHidden(true) // Remove o botão de back da tela de login
            }
        }
    }
}

#Preview {
    ContentView()
}
