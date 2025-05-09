# 📸 Fotofolio: Fotograf 🤝🏻 Zákazník

**Fotofolio** je mobilní aplikace pro iOS, která přímočaře propojuje fotografy s potenciálními zákazníky.

---

## ✨ Funkce

- 📷 **Tvorba fotografického portfolia** (pouze pro registrované fotografy)
- 🔍 **Vyhledávání** podle jména nebo polohy
- 🗨️ **Integrovaný chat** mezi uživateli
- ⭐ **Hodnocení profilů**
- ❤️ **Ukládání oblíbených portfolií**
- 📱 **Přehledné uživatelské rozhraní** rozdělené do 5 záložek (feed, výběr, vyhledávání, zprávy, profil)

---

## 🧱 Architektura

### Klientská část (iOS)
- **Jazyk:** Swift
- **Views:** SwiftUI
- **Navigace:** UIKit
- **Architektura:** MVI + Clean Architecture
- **Ukládání dat:** Firebase Firestore + Cloud Storage
- **Autentizace:** Firebase Auth
- **Síťová vrstva:** Komunikace s REST API

### Serverová část (Ktor)
- **Jazyk:** Kotlin
- **Framework:** Ktor
- **Databáze:** Firestore
- **Storage:** Cloud Storage
- **REST API:** zdokumentované v `documentation.yaml`
- **Hosting:** Railway

---

## 📚 REST API

Serverová část poskytuje dobře strukturované REST API pro komunikaci mezi klientem a backendem. Dokumentace je dostupná ve formátu OpenAPI v souboru `server/.../documentation.yaml`.

---

## 🧪 Uživatelské testování

Aplikace testována dvěma skupinami uživatelů:
- 3 testeři – fotografové
- 3 testeři – zákazníci

---

## 🛠️ Spuštění

### iOS

1. Otevři `fotofolio2pto.xcodeproj` v Xcode
3. Sestav a spusť na simulátoru nebo fyzickém zařízení

### Backend

```bash
cd server
./gradlew run
```

> Ujisti se, že jsou správně nastavené Firebase proměnné a `application.conf`.

AI GENERATED README | Projekt vytvořil [Kryštof Příhoda].
