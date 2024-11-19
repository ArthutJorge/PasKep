import SwiftUI

struct AddPassView: View {
    
    @State private var titulo = ""
    @State private var descricao = ""
    @State private var urlImagem = ""
    @State private var senha = ""
    @State private var confirmarSenha = ""
    @State private var showAlert = false
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false

    var body: some View {
        NavigationStack {
            VStack {
                // Título
                TextField("Título", text: $titulo)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                // Descrição
                TextField("Descrição", text: $descricao)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                // URL da Imagem
                TextField("URL da Imagem", text: $urlImagem)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 10)
                
                // Senha
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
        // Verifica se os campos estão preenchidos corretamente
        if titulo.isEmpty || descricao.isEmpty || urlImagem.isEmpty || senha.isEmpty || confirmarSenha.isEmpty {
            showAlert = true
        } else if senha != confirmarSenha {
            // Verifica se as senhas são iguais
            showAlert = true
        } else {
            // A senha foi criada corretamente
            print("Senha criada com sucesso!")
            // Aqui você pode adicionar a lógica para salvar a senha ou navegar para outra tela
        }
    }
}

#Preview {
    AddPassView()
}

