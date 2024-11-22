import SwiftUI

struct SignUpView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Cadastro")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                // Campo de username
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                // Campo de senha
                SecureField("Senha", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                // Campo de confirmação de senha
                SecureField("Confirmar Senha", text: $confirmPassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                // Botão para criar conta
                Button(action: {
                    // Verificar se as senhas são iguais e se o username não está vazio
                    if password != confirmPassword {
                        alertMessage = "As senhas não coincidem."
                        showAlert = true
                    } else if username.isEmpty || password.isEmpty {
                        alertMessage = "Preencha todos os campos."
                        showAlert = true
                    } else {
                        // Chamar a função para criar o usuário
                        createUser()
                    }
                }) {
                    Text("Criar conta")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 20)
                }
                
                // Link para login se já tiver uma conta
                NavigationLink("Já tem uma conta?", destination: LoginView())
                    .padding(.top, 20)
                    .foregroundColor(.blue)
                
                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Erro"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .padding()
            
            .navigationDestination(isPresented: $isLoggedIn) {
                LoginView()
                    .navigationBarBackButtonHidden(true) // Remove o botão de back da tela de login
            }
        }
    }
    
    // Função para criar um novo usuário
    func createUser() {
        // URL para a API de criação de usuário
        guard let url = URL(string: "http://localhost:3000/usuarios") else {
            alertMessage = "URL inválida."
            showAlert = true
            return
        }
        
        // Dados para enviar no corpo da requisição
        let userData = [
            "username": username,
            "senha": password
        ]
        
        // Criação da requisição
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Codificando os dados para JSON
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch {
            alertMessage = "Erro ao codificar os dados."
            showAlert = true
            return
        }
        
        // Enviando a requisição
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                alertMessage = "Erro de rede: \(error.localizedDescription)"
                showAlert = true
                return
            }
            
            // Verificando a resposta da API
            if let data = data {
                do {
                    // Tentando decodificar a resposta
                    if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let id = responseJSON["id"] as? String {
                        DispatchQueue.main.async {
                            // Sucesso: usuário criado, vamos navegar para a tela principal
                            isLoggedIn = true
                        }
                    } else {
                        alertMessage = "Erro ao criar usuário. Tente novamente."
                        showAlert = true
                    }
                } catch {
                    alertMessage = "Erro ao processar a resposta da API."
                    showAlert = true
                }
            }
        }.resume()
    }
}

#Preview {
    SignUpView()
}

