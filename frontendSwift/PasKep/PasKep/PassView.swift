import SwiftUI

struct PassView: View {
    var card: Card // Recebe o Card com os dados
    
    @State private var isPasswordVisible = false // Estado para controlar visibilidade da senha

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

            HStack {
                Button(action: {
                    // Lógica para excluir a senha
                    print("Excluir senha")
                }) {
                    Text("Excluir Senha")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 20)
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    PassView(card: Card(id: 1, titulo: "Card 1", descricao: "Descrição do Card 1", senha: "Senha123", urlImagem: "https://picsum.photos/500"))
}
