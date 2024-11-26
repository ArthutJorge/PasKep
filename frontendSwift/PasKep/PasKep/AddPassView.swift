import SwiftUI

struct AddPassView: View { // pagina para criar uma nova senha
    @State private var titulo = ""  // variaveis dos inputs, atributos da senha
    @State private var descricao = ""
    @State private var urlImagem = ""
    @State private var senha = ""
    @State private var confirmarSenha = ""
    @State private var siteUsername = ""
    @State private var showAlert = false
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    
    var username: String  // recebe o nome de usuário
    @Environment(\.dismiss) var dismiss  // usado para voltar para a tela anterior

    var body: some View {  //view principal
        NavigationStack {
            VStack {
                TextField("Título", text: $titulo) //titulo senha
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                TextField("Descrição", text: $descricao)   //descricao da senha
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                TextField("URL da Imagem", text: $urlImagem)   //url da imagem da senha
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                TextField("Username", text: $siteUsername)   //username da senha
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 10)

                HStack {
                    if isPasswordVisible { // espiar a senha
                        TextField("Senha", text: $senha)   //senha em si
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
                
                
                HStack {
                    if isConfirmPasswordVisible {
                        TextField("Confirmar Senha", text: $confirmarSenha)  // confirmar Senha
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
                
                Button(action: {
                    validateAndCreatePassword()   //ao clicar no botao de criar senha, chamar funcao
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
    
    func validateAndCreatePassword() {   //se todos os dados foram preenchidos
        if titulo.isEmpty || descricao.isEmpty || senha.isEmpty || confirmarSenha.isEmpty || siteUsername.isEmpty {
            showAlert = true
        } else if senha != confirmarSenha {
            showAlert = true
        } else {
            if urlImagem.isEmpty {
                urlImagem = "https://picsum.photos/500"   //coloca uma imagem aleatoria se nao escolher uma
            }
            createPassword()
        }
    }

    func createPassword() {
        let url = URL(string: "http://localhost:3000/usuarios/\(username)/senhas")!  // url do backend

        var request = URLRequest(url: url)
        request.httpMethod = "POST"  //solicitacao post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [   //parametros da nova senha
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

                // caso sucesso, voltar para a contentView
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

