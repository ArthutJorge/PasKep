import SwiftUI

struct ContentView: View {
    
    @State private var senhas: [Senha] = []  // Lista de senhas do usuário
    var username: String  // Nome do usuário

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
                        
                        Text("Olá, \(username)")  // Exibe o nome de usuário
                            .font(.headline)
                            .padding(.trailing)
                    }
                    .padding()

                    // Exibe as senhas, se houver
                    List(senhas) { senha in
                        NavigationLink(destination: PassView(card: Card(id: senha.id, titulo: senha.titulo, descricao: senha.descricao, username: senha.username, senha: senha.senha, urlImagem: senha.urlImagem), username: username)) {

                            HStack {
                                VStack(alignment: .leading) {
                                    Text(senha.titulo)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text(senha.descricao)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                AsyncImage(url: URL(string: senha.urlImagem)) { image in
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
                        NavigationLink(destination: AddPassView(username: username)) {
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
            .onAppear {
                fetchSenhas()
            }
        }
    }
    
    // Função para fazer o fetch das senhas do usuário
    func fetchSenhas() {
        guard let url = URL(string: "http://localhost:3000/usuarios/\(username)/senhas") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro ao buscar senhas: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let fetchedSenhas = try decoder.decode([Senha].self, from: data)
                
                // Atualiza a lista de senhas no principal thread
                DispatchQueue.main.async {
                    senhas = fetchedSenhas
                }
            } catch {
                print("Erro ao decodificar as senhas: \(error.localizedDescription)")
            }
        }.resume()
    }
}

// Modelo para representar uma senha
struct Senha: Identifiable, Decodable {
    var id: String
    var titulo: String
    var descricao: String
    var senha: String
    var username: String
    var urlImagem: String
}

#Preview {
    ContentView(username: "Username")
}
