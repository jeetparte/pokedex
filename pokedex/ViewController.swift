//
//  ViewController.swift
//  pokedex
//
//  Created by Jeet Parte on 16/06/17.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var pokemon = [Pokemon]()
    private var filteredPokemon = [Pokemon]()
    private var inSearchMode = false
    private var musicPlayer: AVAudioPlayer!
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
    
    @IBAction func musicToggleButtonPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
            
        } else {
            musicPlayer.play()
            sender.alpha = 1
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //display pokemon-detail-VC
        let selectedPokemon: Pokemon!
        selectedPokemon = inSearchMode ? filteredPokemon[indexPath.row] : pokemon[indexPath.row]
        performSegue(withIdentifier: "showPokemonDetailSegue", sender: selectedPokemon)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
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

