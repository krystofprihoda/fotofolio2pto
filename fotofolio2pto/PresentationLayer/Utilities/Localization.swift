//
//  Localization.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 03.03.2025.
//

public struct L {
    public enum Onboarding {
        public static let username = "Uživatelské jméno"
        public static let password = "Heslo"
        public static let signIn = "Přihlášení."
        public static let registrationAlternative = "nebo registrace zde"
        public static let signInAction = "Přihlásit se"
    }
    
    public enum Feed {
        public static let title = "Feed"
        public static let noFilterResults = "Filtrování neodpovídá žádný výsledek."
        public static let sort = "Seřadit"
        public static let sortByDate = "Podle data"
        public static let soryByRating = "Podle hodnocení"
        public static let filter = "Filtrovat"
        public static let filterPortfolios = "Filtrovat portfolia"
        public static let weddingExample = "např. svatba"
        public static let add = "Přidat"
    }
    
    public enum Selection {
        public static let title = "Výběr"
        public static let emptySelection = "Ve svém výběru nemáte žádná portfolia."
        public static let removeAll = "Odstranit vše"
        public static let remove = "Odstranit"
        public static let typeMessage = "Napsat zprávu"
        public static let outOf5 = " z 5"
        public static let noRating = "Bez hodnocení"
        public static let profileDescriptionError = "Profilový popis se nepodařilo nahrát, zkuste to znovu."
        public static let removeAllFromSelection = "Odstranit všechna portfolia z výběru?"
        public static let removePortfolioFromSelection = "Odstranit portfolio z výběru?"
        public static let cancel = "Zrušit"
    }
    
    public enum Search {
        public static let title = "Vyhledávání"
        public static let search = "Hledat"
        public static let searchBy = "Vyhledávat podle"
    }
    
    public enum Messages {
        public static let title = "Zprávy"
        public static let noMessages = "Žádné zprávy."
        public static let youFormat = "Vy:"
        public static let search = "Hledat"
        public static let newChat = "Nový chat"
        public static let send = "Odeslat"
        public static let prefill = "..."
        public static let chatTitle = "Chat"
    }
    
    public enum Profile {
        public static let title = "Profil"
        public static let editProfile = "Upravit profil"
        public static let signOut = "Odhlásit se"
        public static let editTitle = "Úprava profilu"
        public static let save = "Uložit"
        public static let cancel = "Zrušit"
        public static let weddingExample = "např. svatba"
        public static let portraitsExample = "např. Portréty"
        public static let add = "Přidat"
        public static let yearsOfExperience = "Počet let zkušeností:"
        public static let yearsOfExperiencePrefill = "3"
        public static let description = "Profilový popis:"
        public static let activePlace = "Místo působení:"
        public static let usernameError = "Uživatelské jméno se nepodařilo načíst..."
        public static let nameError = "Jméno se nepodařilo načíst..."
        public static let titleName = "Název"
        public static let photography = "Fotografie"
        public static let shortDescription = "Popis"
        public static let maxNumberOfTags = "Tagy (max. 5)"
        public static let createNew = "Vytvořit"
        public static let newPortfolioTitle = "Nové portfolio"
    }
}
