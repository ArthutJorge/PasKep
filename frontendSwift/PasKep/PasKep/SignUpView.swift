import SwiftUI

struct SignUpView: View {  //pagina de cadastro
    
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Cadastro")  //titulo
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                TextField("Username", text: $username)  //username
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                SecureField("Senha", text: $password) //senha
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                SecureField("Confirmar Senha", text: $confirmPassword)  //confirmar senha
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                // botao par criar nova conta
                Button(action: {
                    // verifica se as senhas digitadas sao iguais
                    if password != confirmPassword {
                        alertMessage = "As senhas não coincidem."
                        showAlert = true
                    } else if username.isEmpty || password.isEmpty {
                        alertMessage = "Preencha todos os campos."
                        showAlert = true
                    } else {
                        createUser()
                    }
                }) {
                    Text("Criar conta")  //botao
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 20)
                }
                
                // se ja tiver uma conta, mandar para pagina de login
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
                    .navigationBarBackButtonHidden(true) 
            }
        }
    }
    
    // criar nova conta/user
    func createUser() {
        // url 
        guard let url = URL(string: "http://localhost:3000/usuarios") else {
            alertMessage = "URL inválida."
            showAlert = true
            return
        }
        
        // corpo da requisição
        let userData = [
            "username": username,
            "senha": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userData, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch {
            alertMessage = "Erro ao codificar os dados."
            showAlert = true
            return
        }
        
        // enviar requisicao
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                alertMessage = "Erro de rede: \(error.localizedDescription)"
                showAlert = true
                return
            }
            
            // verificando a resposta
            if let data = data {
                do {
                    // decodificando a resposta
                    if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let id = responseJSON["id"] as? String {
                        DispatchQueue.main.async {
                            // sucesso no cadastro
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

