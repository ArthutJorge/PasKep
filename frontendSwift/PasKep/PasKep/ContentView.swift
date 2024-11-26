import SwiftUI

struct ContentView: View { // 'home'
    
    @State private var senhas: [Senha] = []  // lista das senhas daquele usuario
    var username: String  // username passado como parametro por outras telas

    @State private var goToLoginPage = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Button(action: {
                            goToLoginPage = true
                        }) {
                            Text("Sair")   //sair, voltar para o login
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                        
                        Text("Olá, \(username)")  // boas vindas para o usuario
                            .font(.headline)
                            .padding(.trailing)
                    }
                    .padding()

                    //  lista todas as senhas em formato de Card. Struct Card
                    List(senhas) { senha in
                        NavigationLink(destination: PassView(card: Card(id: senha.id, titulo: senha.titulo, descricao: senha.descricao, username: senha.username, senha: senha.senha, urlImagem: senha.urlImagem), username: username)) {
                        //ao clicar em um card, levar para PassView
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(senha.titulo) // titulo da senha
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Text(senha.descricao)  //descricao da senha
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                //imagem da senha
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
                    
                    Spacer() 
                }
                
                // botao flutuante fixo no canto direito inferior para criar nova senha
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
                    .navigationBarBackButtonHidden(true) 
            }
            .onAppear {
                fetchSenhas()
            }
        }
    }
    
    // obter todas as senhas do usuario
    func fetchSenhas() {
        guard let url = URL(string: "http://localhost:3000/usuarios/\(username)/senhas") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"   //requisição GET
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro ao buscar senhas: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let fetchedSenhas = try decoder.decode([Senha].self, from: data)
                
                // ao obter as senhas, preencher o vetor de senhas 
                DispatchQueue.main.async {
                    senhas = fetchedSenhas
                }
            } catch {
                print("Erro ao decodificar as senhas: \(error.localizedDescription)")
            }
        }.resume()
    }
}

// struct para representar uma senha
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
