//
//  ViewController.swift
//  pokedex
//
//  Created by Jeet Parte on 16/06/17.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    internal var pokemon = [Pokemon]()
    internal var filteredPokemon = [Pokemon]()
    internal var inSearchMode = false
    internal var musicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        parsePokemonCSV()
        playAudio()
    }
    
    func playAudio() {
        let pathToAudioFile = Bundle.main.path(forResource: "pokemon center", ofType: "mp3")
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: pathToAudioFile!))
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func parsePokemonCSV() {
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            for row in rows {
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                let pokemon = Pokemon(name: name, pokedexID: pokeID)
                self.pokemon.append(pokemon)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPokemonDetailSegue" {
            if let destination = segue.destination as? PokemonDetailViewController {
                if let pokemon = sender as? Pokemon {
                    destination.pokemon = pokemon
                }
            }
        }
    }
}

//MARK: - IBActions
extension ViewController {
    @IBAction func musicToggleButtonPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1
        }
    }
}


//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPokemon.count : pokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokecell", for: indexPath) as? PokeCell {
            let pokemon: Pokemon
            if inSearchMode {
                pokemon = filteredPokemon[indexPath.row]
            } else {
                pokemon = self.pokemon[indexPath.row]
            }
            cell.configureCell(from: pokemon)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

//MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //display pokemon-detail-VC
        let selectedPokemon: Pokemon!
        selectedPokemon = inSearchMode ? filteredPokemon[indexPath.row] : pokemon[indexPath.row]
        performSegue(withIdentifier: "showPokemonDetailSegue", sender: selectedPokemon)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
}

//MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            inSearchMode = false
            view.endEditing(true)
        } else {
            inSearchMode = true
            let lowercasedSearchText = searchText.lowercased()
            filteredPokemon = pokemon.filter({$0.name.range(of: lowercasedSearchText) != nil})
        }
        collectionView.reloadData()
    }
}
