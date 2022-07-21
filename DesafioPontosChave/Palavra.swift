//
//  Palavra.swift
//  DesafioPontosChave
//
//  Created by Juliano Santos on 17/7/22.
//

import Foundation

struct Palavra {

    private var palavra: String
    private var dica: String
    
    init(palavra: String, dica: String) {
        self.palavra = palavra
        self.dica = dica
    }
    
    func getPalavra() -> String {
        return self.palavra
    }
    
    func getDica() -> String {
        return self.dica
    }

}
