import SwiftUI

struct AddPassView: View {
    @State private var titulo = ""
    @State private var descricao = ""
    @State private var urlImagem = ""
    @State private var senha = ""
    @State private var confirmarSenha = ""
    @State private var siteUsername = ""
    @State private var showAlert = false
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    var username: String  // Recebe o nome de usuário
    @Environment(\.dismiss) var dismiss  // Usado para voltar à tela anterior

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Título", text: $titulo)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                TextField("Descrição", text: $descricao)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                TextField("URL da Imagem", text: $urlImagem)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                TextField("Username", text: $siteUsername)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 10)

                HStack {
                    if isPasswordVisible {
                        TextField("Senha", text: $senha)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.top, 10)
                    } else {
                        SecureField("Senha", text: $senha)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.top, 10)
                    }
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                
                // Confirmar Senha
                HStack {
                    if isConfirmPasswordVisible {
                        TextField("Confirmar Senha", text: $confirmarSenha)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.top, 10)
                    } else {
                        SecureField("Confirmar Senha", text: $confirmarSenha)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .padding(.top, 10)
                    }
                    Button(action: {
                        isConfirmPasswordVisible.toggle()
                    }) {
                        Image(systemName: isConfirmPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                
                // Botão Criar Senha
                Button(action: {
                    validateAndCreatePassword()
                }) {
                    Text("Criar Senha")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Erro"),
                    message: Text("Verifique os dados inseridos ou se as senhas são iguais."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .padding()
            .navigationTitle("Adicionar Senha")
            
        }
    }
    
    func validateAndCreatePassword() {
        if titulo.isEmpty || descricao.isEmpty || senha.isEmpty || confirmarSenha.isEmpty || siteUsername.isEmpty {
            showAlert = true
        } else if senha != confirmarSenha {
            showAlert = true
        } else {
            if urlImagem.isEmpty {
                urlImagem = "https://picsum.photos/500"
            }
            createPassword()
        }
    }

    func createPassword() {
        let url = URL(string: "http://localhost:3000/usuarios/\(username)/senhas")!  // Modifique para a URL do seu backend

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "titulo": titulo,
            "descricao": descricao,
            "senha": senha,
            "urlImagem": urlImagem,
            "username": siteUsername 
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Erro ao criar senha: \(error)")
                    DispatchQueue.main.async {
                        self.showAlert = true
                    }
                    return
                }

                // Caso a senha seja criada com sucesso, volta para a ContentView
                DispatchQueue.main.async {
                    self.dismiss()
                }
            }.resume()
        } catch {
            print("Erro ao criar JSON: \(error)")
        }
    }
}

#Preview {
    AddPassView(username: "Username")
}

