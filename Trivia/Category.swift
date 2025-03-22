//
//  Category.swift
//  Trivia
//
//  Created by Faizan Khan on 3/21/25.
//
// Category.swift
import Foundation

struct Category {
    let id: Int
    let name: String
    
    // Define the categories array as static
    static let categories: [Category] = [
        Category(id: 9, name: "General Knowledge"),
        Category(id: 10, name: "Entertainment: Books"),
        Category(id: 11, name: "Entertainment: Film"),
        Category(id: 12, name: "Entertainment: Music"),
        Category(id: 13, name: "Entertainment: Musicals & Theatres"),
        Category(id: 14, name: "Entertainment: Television"),
        Category(id: 15, name: "Entertainment: Video Games"),
        Category(id: 16, name: "Entertainment: Board Games"),
        Category(id: 17, name: "Science & Nature"),
        Category(id: 18, name: "Science: Computers"),
        Category(id: 19, name: "Science: Mathematics"),
        Category(id: 20, name: "Mythology"),
        Category(id: 21, name: "Sports"),
        Category(id: 22, name: "Geography"),
        Category(id: 23, name: "History"),
        Category(id: 24, name: "Politics"),
        Category(id: 25, name: "Art"),
        Category(id: 26, name: "Celebrities"),
        Category(id: 27, name: "Animals"),
        Category(id: 28, name: "Vehicles"),
        Category(id: 29, name: "Entertainment: Comics"),
        Category(id: 30, name: "Science: Gadgets"),
        Category(id: 31, name: "Entertainment: Japanese Anime & Manga"),
        Category(id: 32, name: "Entertainment: Cartoon & Animations")
    ]
}
