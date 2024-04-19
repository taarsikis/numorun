//
//  UserViewModel.swift
//  Numo test1
//
//  Created by Тасік on 13.04.2024.
//
import SwiftUI
import Foundation
import Firebase

class UserViewModel: ObservableObject {
    @AppStorage("uid") var userID: String = ""
    @Published var users = [User]()
    private var db = Firestore.firestore()
    
