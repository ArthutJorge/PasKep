import Foundation

struct Card: Identifiable, Codable {
    var id: Int
    var titulo: String
    var descricao: String
    var username: String
    var senha: String
    var urlImagem: String
}
