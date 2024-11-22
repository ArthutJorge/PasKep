import SwiftUI

struct PassView: View {
    var card: Card 
    var username: String
    
    
    @State private var isPasswordVisible = false // Estado para controlar visibilidade da senha
    @State private var isLoading = false // Estado para indicar carregamento
    @Environment(\.dismiss) private var dismiss // Para fechar a tela

    var body: some View {
        VStack {
            Text(card.titulo)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            AsyncImage(url: URL(string: card.urlImagem)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(8)
            } placeholder: {
                ProgressView()
            }
            .padding(.top, 20)
            
            Text(card.descricao)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 10)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Username:")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text(card.username)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding(.top, 10)
                
                HStack {
                    // Exibe a senha oculta ou visível
                    Text(isPasswordVisible ? card.senha : "********")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    Button(action: {
                        isPasswordVisible.toggle() // Alterna a visibilidade da senha
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.blue)
                            .padding(.leading, 10)
                    }
                }
            }

            HStack {
                Button(action: {
                    deletePassword()
                }) {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Excluir Senha")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .disabled(isLoading)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding()
    }

   private func deletePassword() {
        guard let url = URL(string: "http://localhost:3000/usuarios/\(username)/senhas/\(card.id)") else { return }
        isLoading = true

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    print("Erro: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // Redireciona ao ContentView ao concluir
                    dismiss()
                } else {
                    print("Erro ao excluir senha.")
                }
            }
        }.resume()
    }
}

#Preview {
    PassView(
        card: Card(id: "1",titulo: "Card 1",descricao: "Descrição do Card 1",username: "site_user",senha: "Senha123",urlImagem: "https://picsum.photos/500"),
        username: "contaPaskepUser"
    )
}
