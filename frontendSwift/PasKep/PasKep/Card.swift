import Foundation

struct Card: Identifiable, Codable {   //struct do Card de senha
    var id: String
    var titulo: String
    var descricao: String
    var username: String
    var senha: String
    var urlImagem: String
}
