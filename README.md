# Pokédex 

![Pokédex Logo](https://bulbapedia.bulbagarden.net/wiki/File:Pokédex_logo.png)

## About

**An iOS app that displays information about over 700 Pokémon. Made using the [Pokéapi](http://pokeapi.co/about/) API.**

A *Pokédex* is an encylopedia containing information about all Pokémon in the [Pokémon][3] world.
 
This Pokédex app features a searchable collection of Pokémons. Details about a Pokémon show up on selection.  

Nostalgic Pokémon music plays in the background.

## Purpose

This project was for my learning purposes. It is now **archived**.

## Details (how the app works)

Pokémon names and IDs are stored in a CSV file. The names, along with images, are displayed in a grid format using a [UICollectionView][1]. The collection is searchable via a [UISearchBar][2].

When a Pokémon is selected in the grid, its ID is used to query the Pokéapi API for detailed information about it. This information is returned in JSON format. After being parsed, it is presented in a new screen in the app's UI.

The app also plays the [Pokémon Center](https://www.youtube.com/watch?v=sblFkwwFnQU) song in the background. The song can be toggled on / off (the toggle button is in the top right of the screen).

## Demo

[![Demo Pokédex App alpha](https://media.giphy.com/media/xUPGcEZbHc9pAup5n2/giphy.gif)](https://giphy.com/gifs/ios-pokmon-pokdex-xUPGcEZbHc9pAup5n2/)  

[1]: https://developer.apple.com/documentation/uikit/uicollectionview
[2]: https://developer.apple.com/documentation/uikit/uisearchbar
[3]: https://en.wikipedia.org/wiki/Pokémon
