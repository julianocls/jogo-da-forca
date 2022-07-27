//
//  ViewController.swift
//  DesafioPontosChave
//
//  Created by Juliano Santos on 17/7/22.
//

import UIKit

class ViewController: UIViewController {
    
    var listPalavras = [Palavra]()
    var listPalavrasUsadas = [Palavra]()
    var letrasUsadas = [String]()
    
    var score = 0 {
        didSet {
            pontuacaoLabel.text = "Pontuação: \(score)"
        }
    }
    
    var tentativas = 0 {
        didSet {
            tentativaLabel.text = "N. Tentativa: \(tentativas)"
        }
    }
    
    var palavraAtual = ""
    var palavraCifrada = ""

    @IBOutlet weak var tentativaLabel: UILabel!
    @IBOutlet weak var pontuacaoLabel: UILabel!
    @IBOutlet weak var palavraLabel: UILabel!
    @IBOutlet weak var dicaLabel: UILabel!
    
    @IBOutlet weak var iniciarGameBtn: UIButton!
    @IBOutlet weak var digitarLetraBtn: UIButton!
    @IBOutlet weak var informarPalavraBtn: UIButton!
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        digitarLetraBtn.isHidden = true
        informarPalavraBtn.isHidden = true

        loadData()
    }

    fileprivate func loadData() {
        if let palavrasUrl = Bundle.main.url(forResource: "palavras", withExtension: "txt") {
            if let palavras = try? String(contentsOf: palavrasUrl) {
                let allWords = palavras.components(separatedBy: "\n")
                for line in allWords {
                    if !line.isEmpty {
                        let word = line.description.components(separatedBy: "|")
                        let palavra = word[0].trimmingCharacters(in: .whitespaces)
                        let dica = word[1].trimmingCharacters(in: .whitespaces)
                        
                        listPalavras.insert(Palavra(palavra: palavra, dica: dica), at: 0)
                    }
                }
            }
        }
    }

    @IBAction func iniciarGame(_ sender: UIButton) {
        
        iniciarGameBtn.isHidden = true
        digitarLetraBtn.isHidden = false
        informarPalavraBtn.isHidden = false
        letrasUsadas = [String]()

        self.loadStartGame()
    }
    
    func loadStartGame() {
        if listPalavras.count > 0 {
            let elementNumber = Int.random(in: 0..<listPalavras.count)
            let palavra = listPalavras.remove(at: elementNumber)
            palavraAtual = palavra.getPalavra()
            palavraCifrada = ""
            for _ in palavraAtual {
                palavraCifrada += "?"
            }
            
            palavraLabel.text = palavraCifrada
            dicaLabel.text = palavra.getDica()
            tentativas = Int(Double(palavraAtual.count) * 0.60)
            tentativaLabel.text = "N. Tentativa: \(tentativas)"
        } else {
            let ac = UIAlertController(title: "Fim de Jogo!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func DigitarLetra(_ sender: UIButton) {
        let ac = UIAlertController(title: "Informe a letra", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let letra = ac?.textFields?[0].text else { return }
            self?.submit(letra)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @IBAction func informarPalavra(_ sender: UIButton) {
        let ac = UIAlertController(title: "Informe a palavra", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let text = ac?.textFields?[0].text else { return }
            self?.submitPalavra(text)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
   
    func submit(_ letra: String) {
        self.palavraCifrada = ""
        self.letrasUsadas.insert(letra.lowercased(), at: 0)
        tentativas -= 1

        for i in palavraAtual {
            if self.letrasUsadas.contains(i.lowercased()) {
                self.palavraCifrada += String(i)
            } else {
                self.palavraCifrada += "?"
            }
        }
        
        self.palavraLabel.text = self.palavraCifrada
        verificaTentativas()
    }
    
    func submitPalavra(_ text: String) {
        tentativas -= 1

        if self.palavraAtual.lowercased() == text.lowercased() {
            self.palavraLabel.text = palavraAtual
            score += 1
            self.loadStartGame()
        } else {
            verificaTentativas()
        }
    }
    
    func verificaTentativas() {
        if tentativas == 0 {
            let ac = UIAlertController(title: "Tentativas Esgotadas!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Jogar novamente", style: .default))
            present(ac, animated: true)
            self.loadStartGame()
        }
    }
}

