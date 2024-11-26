import SwiftUI

struct LoginView: View {    //pagina de login
    
    @State private var username = ""   //atributos da pagina
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false
    @State private var showSignUp = false // mostrar a tela de cadastro? sim/nao

    var body: some View {
        NavigationStack {
            VStack {
                Text("Login")  //titulo
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                TextField("Username", text: $username)   //username
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                SecureField("Senha", text: $password)   //credencial para entrar, senha
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                Button(action: {
                    login()
                }) {
                    Text("Entrar")   // botao para entrar
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 20)
                }
                
                // se nao tiver uma conta, levar para a tela de Cadastro/SignUp
                NavigationLink("Não tem uma conta? Crie uma", destination: SignUpView())
                    .padding(.top, 20)
                    .foregroundColor(.blue)
                
                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Erro"), message: Text("Username ou senha inválidos!"), dismissButton: .default(Text("OK")))
            }
            .padding()
            
            .navigationDestination(isPresented: $isLoggedIn) {
                ContentView(username: username)
                   .navigationBarBackButtonHidden(true)
           }
        }
    }
    
    //funcao de login, para verificar as credenciais
    func login() {
        guard let url = URL(string: "http://localhost:3000/login") else { return }
        
        // corpo da requisicao com os parametros
        let parameters = [
            "username": username,
            "senha": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //requisicao POST
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erro ao tentar fazer login: \(error)") 
                DispatchQueue.main.async {
                    showAlert = true
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                // decodifica a resposta
                let decoder = JSONDecoder()
                let loginResponse = try decoder.decode(LoginResponse.self, from: data)
                
                if loginResponse.message == "Login bem-sucedido!" {
                    // se o login for bem sucedido, muda a variavel de login
                    DispatchQueue.main.async {
                        isLoggedIn = true
                    }
                } else {
                    DispatchQueue.main.async {
                        showAlert = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    showAlert = true
                }
            }
        }.resume()
    }
}

struct LoginResponse: Decodable {
    let message: String
}

#Preview {
    LoginView()
}

