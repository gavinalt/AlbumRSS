# AlbumRSS
A Simple iOS App with Unit Tests Demonstrating Programmatic UI and MVVM Structure

## Table of Contents:
1. Features
2. Possible Improments
3. Important Notes

## 1. Features:
* There are two screens built in this application:
1. Album List Screen: You will see a list of albums on this screen. Each item in the list is a table cell and tapping on any one of them will bring you to the second screen displaying the detailed info about that album.
2. Album Detail Screen: This screen displays the detailed info of the album you selected from the list. Click on the button at the buttom of the screen will either open this album in iTunes Store or Safari. This screen has been optimized for both portrait and landscape orientation.
* This app downloads JSON data from iTunes RSS and parses it to display a list of 100 albums.
* This app complys with the MVVM Design Pattern.
* On the backend, this application uses URLSession to deal with all the network tasks and promptly caches the photos downloaded in the LocalCache. It uses JSON decoder to parse the JSON data downloaded.

## 2. Possible Improments:
* Add some visual indication while the album cover is being downloaded on the Album Detail Screen.

## 3. Important Notes:
* The RSS Feed URL is supplied by the [iTunes RSS Generator](https://rss.itunes.apple.com/en-us)
