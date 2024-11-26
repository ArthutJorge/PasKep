import SwiftUI

struct PassView: View {   // pagina para ver as informacoes da senha
    var card: Card  // passando o card da senha, com suas informcoes
    var username: String
    
    @State private var isPasswordVisible = false 
    @State private var isLoading = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text(card.titulo)  //titulo da senha
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            //imagem da senha
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
             
            Text(card.descricao)  //descricao da senha
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 10)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Username:")  //username da senha
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text(card.username)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding(.top, 10)
                
                HStack {
                    // 'espiar' a senha
                    Text(isPasswordVisible ? card.senha : "********")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    Button(action: {
                        isPasswordVisible.toggle() 
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.blue)
                            .padding(.leading, 10)
                    }
                }
            }

            HStack {
                Button(action: {   //botao para deletar a senha
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

    //deletar a senha
   private func deletePassword() {
        guard let url = URL(string: "http://localhost:3000/usuarios/\(username)/senhas/\(card.id)") else { return }
        isLoading = true

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE" //requisicao tipo Delete

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                isLoading = false

                if let error = error {
                    print("Erro: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    // ao excluir, voltar para pagina 'anterior'
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
