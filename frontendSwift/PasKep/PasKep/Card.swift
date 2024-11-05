

import Foundation

struct Card: Codable, Identifiable {
    var Id: Int
    var Titulo: String
    var descricao: String
    var UrlImagem: String
    var Senha: String
    var usernameUsuario: String
    
    var id: Int { return Id }
}
