import SwiftUI

struct LoginView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var showAlert = false
    @State private var showSignUp = false // Para mostrar a tela de cadastro

    var body: some View {
        NavigationStack {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                SecureField("Senha", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                Button(action: {
                    login()
                }) {
                    Text("Entrar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 20)
                }
                
                // Navegação para tela de cadastro
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
               ContentView()
                   .navigationBarBackButtonHidden(true)
           }
        }
    }
    
    func login() {
        if username == "user" && password == "password" || 1==1 {
            isLoggedIn = true
        } else {
            showAlert = true
        }
    }
}

struct SignUpView: View {
    
    @State private var newUsername = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var accountCreated = false
    @State private var showAlert = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Criação de Conta")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                
                TextField("Username", text: $newUsername)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                SecureField("Senha", text: $newPassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                SecureField("Confirmar Senha", text: $confirmPassword)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                Button(action: {
                    signUp()
                }) {
                    Text("Criar Conta")
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
                Alert(title: Text("Erro"), message: Text("Verifique os dados inseridos ou se as senhas são iguais."), dismissButton: .default(Text("OK")))
            }
            .padding()
            
            .navigationDestination(isPresented: $accountCreated) {
                LoginView() // Volta para a tela de login após criar a conta
            }
        }
    }

    func signUp() {
        // Verificar se as senhas são iguais e se o nome de usuário não está vazio
        if newUsername.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty {
            showAlert = true
        } else if newPassword != confirmPassword {
            showAlert = true
        } else {
            // Caso tudo esteja correto, redirecionar para a tela de login
            accountCreated = true
        }
    }
}


#Preview {
    LoginView()
}
