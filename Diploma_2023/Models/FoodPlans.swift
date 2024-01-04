//
//  FoodPlans.swift
//  Diploma_2023
//
//  Created by Martin Bernát on 19/10/2023.
//

import Foundation


enum PDFmonkeyStatus: String, Codable {
    case Draft
    case Pending // this stuatus should be passed to POST request body
    case Generating // POST req. retrieve status
    case Success    // GET req. retrieve status
    case Failrue
    
    // Computed property to get the string representation of the enum value
    var stringValue: String {
        return self.rawValue
    }
    
}

struct FoodPlan: IdentifiableItem, Identifiable, Hashable, Encodable, Decodable  {
    
    
    var id = UUID().uuidString // fireBase UID
    var dataType = DataType.foodPlan
    var title: String
    var subTitle: String
    var categoryIDs: [String]
    var placeholderName = "FoodPlansPlaceholder"
    var dateOfCreation: Date
    var accountID: String
    var profileID: String
    var clientID: String?
    
    
    // PDF MONKEY ESSENTIAL IDs
    var apiKey: String
    var pdfMonkeyTemplateID: String // This is the ID of a PDF Monkey template this plan is derived from
    
    var inputData: FoodPlanData // This is the JSON data for PDFMonkey
    
    var firestoreDownloadURL: String? // This will be the link to the PDF in Firebase Storage once generated
    
    var pdfMonkeyDownloadURL: String? // This will be the link to the PDF in Firebase Storage once generated
    
    var documentID: String? // This is documentID retrieved from pdfMonkey
    
    
    var status: PDFmonkeyStatus?


    // probably not used
    var pdfData: Data? // This will hold the raw bytes of the PDF if you decide to cache it within the app

}



// CRUD FoodPlans functions
extension FoodPlan{
    
    // copy plan + add new ID
    func duplicate() -> FoodPlan{
        var copy = self
        copy.id = UUID().uuidString
        return copy
    }
    
    func associateWithClient(clientID: String) -> FoodPlan{
        var copy = self
        copy.id = UUID().uuidString
        copy.clientID = clientID
        return copy
    }
    
    
    
}











// SUPPORTIVE FUNCTIONS
extension FoodPlan {
    
    // Example method to generate the complete JSON for the document request
    func getDocumentJSON() -> [String: Any] {
        // Assuming a certain structure for PDFMonkey
        var documentJSON: [String: Any] = [
            "data_type": self.dataType.rawValue, // Assuming DataType is an enum with raw values
            "title": self.title,
            "sub_title": self.subTitle,
            // ... other attributes ...
            "input_data": self.inputData
        ]
        
        // You can adjust this structure based on the exact requirements of PDFMonkey
        return documentJSON
    }
    
    static func convertJSONStringToFoodPlanData(_ jsonString: String) -> FoodPlanData? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("convertJSONStringToFoodPlanData: first ERROR")
            return nil
        }
        
        do {
            let foodPlanData = try JSONDecoder().decode(FoodPlanData.self, from: jsonData)
            return foodPlanData
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
    
    static func convertFoodPlanDataToJSONString(_ foodPlanData: FoodPlanData) -> String? {
        do {
            let jsonData = try JSONEncoder().encode(foodPlanData)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error encoding object to JSON: \(error)")
            return nil
        }
    }


    
}





// request FACTORY FUNCTIONS
extension FoodPlan{
    
    static func createRequestBody(forTemplate templateID: String, withData jsonData: Data) -> Data? {
        
        let bodyDict: [String: Any] = [
            "document_template_id": templateID,
            "payload": String(data: jsonData, encoding: .utf8) ?? ""
        ]
        
        let bodyData = try? JSONSerialization.data(withJSONObject: bodyDict, options: [])
        return bodyData
    }

    
    static func createRequestBody(forTemplate templateID: String, withJSONString jsonString: String) -> Data? {
        if let jsonData = jsonString.data(using: .utf8) {
            let bodyDict: [String: Any] = [
                "document": [
                    "document_template_id": templateID,
                    "status": "pending",
                    "payload": String(data: jsonData, encoding: .utf8) ?? "",
                    "meta": [
                        "_filename": "my-test-document.pdf"
                        // other meta information if needed
                    ]
                ]
            ]
            let bodyData = try? JSONSerialization.data(withJSONObject: bodyDict, options: [])
            return bodyData
        }
        return nil
    }
}







// HARDCODED DATA FOR OG PLANS
extension FoodPlan{
    static let apiKey = "vzAExYeQ7_Q_fxmYT9zdzdB8VcARhYi_"
    static let template1_ID = "7BA34BB8-8256-4F0D-A3E3-61739E9FFEB0" //FODPLAN05
    static let template2_ID = "F0391EBC-3D5A-42E0-BD00-51ABA8F5BC7C" //FODPLAN05-imageless

    

    // static JSON template 05
    static let template3_InputData = """
{
  "titles":{
    "page1": "SKINFOLD PROTOCOL",
    "page2": "Způsob stravování pro danou fázi na základěstanovených cílů:",
    "page3": "STRAVOVÁNÍ",
    "page4": "Bílkoviny",
    "page6": "Sacharidy",
    "page7": "Tuky",
    "page8": "Vzorový stravovací den podle protokolu:",
    "page9": "SUPLEMENTACE"
  },
    "subtitles":{
    "page2": "Hlavní body pro splnění fáze 1 :",
    "page4": "Hlavní body pro splnění fáze 1 :",
    "page8": "NIKDY NEJÍME STEJNÝ DEN POŘÁD DOKOLA"
  },
  "subsubtitles":{
    "page4_2": "Intra Workout shake - v tréninku pokaždé",
    "page4_3": "Post workout - 10-30 min po tréninku pokaždé",
    "page5_2": "Příklad zjednodušené - Rotation Diet u Bílkovin:"
  },

  "bulletpoints": {
    "page2_1": [
      " Eliminace co nejvíce zánětlivých potravin: začít - Lepek, Mléčné výrobky, Kravská syrovátka: cyklace 3 dny v týdnu střídavě",
      " Nastavení kompletní přeměny v postupech level I stravování - změna snídaně",
      "    Pravidelně vkládat potraviny do konkrétních jídel denně z přílohy potraviny",
      "    Kontrolovat svojí dietu i během víkendu tak, aby nedošlo k žádnému navýšení kalorického nadbytku a zároveň udržení bílkovin",
      "    Upravená cyklace sacharidů v pokračující druhé fázi",
      "    Zvýšit příjem bílkovin",
      "    Frekvence stravování 4+1 (Snídaně 1, Peri-workout, Post-workout, Oběd, Večeře)",
      "    3x volné jídla týdně",
      "    5 dnů zapisovat své stravování do kalorických tabulek - je nutné vědět hrubý přehled o svých přijatých kaloriích",
      "    Během této fáze se snažíme maximálně pochopit kalorie přijaté a naučit se s nimi pracovat podle protokolu: Například kolik obsahuje porce brambor sacharidů apod"
    ],
    "page4_1": [
      "Nastavit na: 2 g na 1kg tělesné váhy",
      "140 g / den"
    ],
    "page4_2": [
      "14g EAA",
      "1g himalájské soli"
    ],
    "page4_3": [
      "10g glutaminu",
      "1g himalájské soli",
      "40g Whey",
      "1g magnesium citrate"
    ],
    "page4_4": [
      "2x denně - jídlo s masem (Zinek, Kreatin, Aminokyseliny)",
      "Eliminace vepřového masa (Toxiny) vyjímka: Divočina, Kvalitní vepřová panenka 2x v týdnu",
      "Rotation diet: Vzhledem k zjištění na základě měření nedokomalé stravování pro výkonnost. (Oprava mikrobiomu střev) Je důležité pravidelně točit druhy bílkovin v tvém případě může vypadat dieta takto:"
    ],
    "page5_1": [
      "Pokud máš maso z BIO chovu - výborná investice pro výkonnosti a zdraví lifestyle: lehce dostupné na farma čunát se kterou spolupracujeme - při odběru masa z farmy lze mít každý den červené maso například u večeře. Je nutné si u červeného masa dávat pozor na příjem tuků ve stravě, které si často klienti neuvědomují a přejdou tak do KALORICKÉHO NADBYTKU tuků",
      "Pokud máš maso z velkoobchodu - Pravidelná rotace každé 2 dny druhu masa"
    ],
    "page5_2": [
      "Pondělí - Hovězí / Hovězí / Hovězí",
      "Úterý - Hovězí / Hovězí / Hovězí",
      "Středa - Kuře / Kuře / Kuře",
      "Čtvrtek - Ryba / Ryba / Ryba",
      "Pátek - Hovězí / Hovězí / Hovězí",
      "Sobota - Hovězí"
    ],
    "page5_3": [
      "Zapisuj si 3 dny do kalorických tabulek pro kontrolu nad stravováním"
    ],
    "page6_1": [
      "Při fázi 1 se u sacharidů soustředíme na jejich přijmutí ve správný čas",
      "Pro fázi 1 - Odstraníme všechny sacharidy ze snídaně a oběda",
      "Základní nastavení pro náš den bude: 1 příloha za den k večeři + 150g libovolného ovoce po večeři",
      "Poměr bude maximálně: 80 g za den: Příloha večeře + Svačina v podobě ovoce po večeři",
      "První forma sacharidů během dne = Večeře"
    ],
    "page6_2": [
      "Žádné sacharidy nikdy před tréninkem ani k snídani (Motivace - Drive v tréninku + krevní cukr)",
      "Vnitřní pozorování funkce mikrobiomu a krevního cukru: Pokud v tobě nějaký druh sacharidů zůstává déle než 2 hodiny (Pocit naplnění, nevhodné trávení, nafouknuté břicho a podobné symptomy - zvol jiný příjem sacharidů - Příklad: Rýže nevhodná vyměň za Brambory): Jednoduše nejíme to po čem se necítíme DOBŘE",
      "Zapisuj první 5 dnů do kalorických tabulek pro kontrolu nad stravováním"
    ],
    "page7_1": [
      "0,7g na 1kg tělesné váhy",
      "Zapisovat 5 dnů do kalorických tabulek",
      "50g Den",
      "Největší porce tuků přijímáme vždy u snídaně - v některých případech téměř polovina pro celý den",
      "Hlavní zdroje jsou: Červené maso, Ořechy, Oleje, Avokádo",
      "Tuky jsou zejména důležité pravidelně vyrovnávat jejich hodnoty: Omega 3-6-9",
      "V našem stravování chceme mít celé spektrum OMEGA 3-6-9 to znamená začne se využívat často také: Ryba, Avokádo, Máslo, Kokosový olej",
      "Tuky se starají i funkci neurotransmiterů a sekrece hormonů, doplňujeme je pravidelně. (viz. postupy)",
      "Ořechy vždy loupané a nevyužívat nikdy arašídy",
      "Tučné jídla jako je hovězí steak, nebo ořechy, avokádo jsou extrémně zdravé potraviny pro naše tělo, ale také nástrahy dietingu proto je nutné s nimi umět manipulovat a pracovat a co víc také je korigovat. Vždy obsahují velké porce kalorií, které tak můžou zvýšit tvůj kalorický příjem a zastavit tak snižování tělesného tuku. Opět doporučuji 3 dny si zapisovat do kalorických tabulek"
    ],
    "page10_1": [
      "MAGNESIUM (Peak Sleep): 3 tablety před spaním",
      "EAA/Electrolyte complex (Myprotein - YPSI): Peri - Workout",
      "Inositol (Myprotein): 10g před spaním",
      "VITAMIN D3/K2 (YPSI NEBO NOW) : 1 pipeta se snídaní / 3000 ui snídaně ",
      "Multikomplex (YPSI): 3x2 tablety s jídlem",
      "Glutamine (Optimal/Myprotein): Ráno + PWO"
    ]
  },
  
  "bulletpointsDoubled": {
    "page8_1": [
      {
        "regular": "Peri-Workout: 14g EAA + 1g himalájské soli",
        "centered": "40g tuků, 50g Bílkovin"
      },
      {
        "regular": "Post-Workout: 40g whey + 10g Glutamine + 1g potassium citrate",
        "centered": "40g tuků, 90g Bílkovin"
      },
      {
        "regular": "Post - Workout: 40g whey + 10g Glutamine + 1g potassium citrate",
        "centered": "40g tuků, 90g Bílkovin"
      },
      {
        "regular": "Oběd: 200g kuřecí plátky nebo ryba + 0,3 lžíce extra virgin olivového oleje + Zelená zelenina (Neomezeně)",
        "centered": "45g tuků, 120g bílkovin"
      },
      {
        "regular": "Večeře: 150g Candáta + 1 porce brambor + 0,3 lžíce makadamového oleje + Zelená zelenina neomezeně",
        "centered": "50 g tuků , 122 g bílkovin, 35 g sacharidů"
      },
      {
        "regular": "Svačina po jídle: 14g EAA + 150g domácích borůvek + 200ml pomerančový džus + 60g ovesné bezlepkové kaše",
        "centered": "50 g tuků, 142g bílkovin, 80 g sacharidů"
      }
    ]
  }
}
"""
    
}



// MUTATING FUNCTIONS
extension FoodPlan {
    
    func setStatus(status: PDFmonkeyStatus) -> FoodPlan{
        var copy = self
        copy.status = status
        return copy
    }
    
    func setDocumentID(documentID: String) -> FoodPlan{
        var copy = self
        copy.documentID = documentID
        return copy
    }
    
    func setFirebaseUrl(url: String) -> FoodPlan{
        var copy = self
        copy.firestoreDownloadURL = url
        return copy
    }
    
    func setFoodPlanData(inputData: FoodPlanData) -> FoodPlan{
        var copy = self
        copy.inputData = inputData
        return copy
    }
    
}


// MARK: JSON STRUCTURES -

// JSON INPUT
struct FoodPlanData: Codable, Hashable {
    var titles: [String: String]?
    var subtitles: [String: String]?
    var subsubtitles: [String: String]?
    var bulletpoints: [String: [String]]?
    var bulletpointsDoubled: [String: [BulletPairs]]?

    struct BulletPairs: Codable, Hashable {
        var regular: String
        var centered: String
    }
}


// UI structure
struct UnifiedPage: Hashable {
    var name: String
    var title: String?
    var subtitle: String?
//    var subsubtitles: [String]?
    
    var bulletGroups: [BulletGroup]?

    struct BulletGroup: Hashable {
        var subsubtitle: String?
        var bullets: [String]?
    }
}


// JSON CONVERSION to UI struct
func processFoodPlanData(data: FoodPlanData) -> [UnifiedPage] {
    var pagesDict = [String: UnifiedPage]()

    // Process titles
    data.titles?.forEach { key, title in
        pagesDict[key, default: UnifiedPage(name: key)].title = title
    }
    
    // Process subtitles
    data.subtitles?.forEach { key, subtitle in
        pagesDict[key, default: UnifiedPage(name: key)].subtitle = subtitle
    }

    // Helper function to extract page name from the key
    func getPageName(from key: String) -> String {
        let components = key.split(separator: "_")
        return String(components.first ?? "")
    }
    
    // Process 'bulletpoints'
    data.bulletpoints?.forEach { key, bullets in
        let pageName = getPageName(from: key)
        let subsubtitle = data.subsubtitles?[key]
        let group = UnifiedPage.BulletGroup(subsubtitle: subsubtitle, bullets: bullets)
        // Ensure bulletGroups is initialized
        if pagesDict[pageName]?.bulletGroups == nil {
            pagesDict[pageName, default: UnifiedPage(name: pageName)].bulletGroups = []
        }
        pagesDict[pageName]?.bulletGroups?.append(group)
    }

    // Process 'bulletpointsDoubled'
    data.bulletpointsDoubled?.forEach { key, bulletPairs in
        let pageName = getPageName(from: key)
        let subsubtitle = data.subsubtitles?[key]
        let bullets = bulletPairs.flatMap { [$0.regular, $0.centered] }
        let group = UnifiedPage.BulletGroup(subsubtitle: subsubtitle, bullets: bullets)
        // Ensure bulletGroups is initialized
        if pagesDict[pageName]?.bulletGroups == nil {
            pagesDict[pageName, default: UnifiedPage(name: pageName)].bulletGroups = []
        }
        pagesDict[pageName]?.bulletGroups?.append(group)
    }


    // Convert the dictionary back to an array and sort by the numerical value of the page name
    let pages = pagesDict.values.sorted(by: {
        guard let number1 = Int($0.name.filter { "0"..."9" ~= $0 }),
              let number2 = Int($1.name.filter { "0"..."9" ~= $0 }) else {
            return false
        }
        return number1 < number2
    })

    return pages
}







func backToOriginalFormat(pages: [UnifiedPage]) -> FoodPlanData {
    
    var titles = [String: String]()
    var subtitles = [String: String]()
    var subsubtitles = [String: String]()
    var bulletpoints = [String: [String]]()
    var bulletpointsDoubled = [String: [FoodPlanData.BulletPairs]]()
    
    let doubleBulletKeys: Set<String> = ["page8_1"]
    

    pages.forEach { page in
        if let title = page.title {
            titles[page.name] = title
        }
        if let subtitle = page.subtitle {
            subtitles[page.name] = subtitle
        }
        page.bulletGroups?.enumerated().forEach { index, group in
            let keySuffix = "_\(index+1)"
            let key = "\(page.name)\(keySuffix)"
            if let subsubtitle = group.subsubtitle {
                subsubtitles[key] = subsubtitle
            }
            // Check if the key is known to be a doubled bulletpoint key
            if doubleBulletKeys.contains(key), let bullets = group.bullets {
                var bulletPairs: [FoodPlanData.BulletPairs] = []
                for i in stride(from: 0, to: bullets.count, by: 2) {
                    let regular = i < bullets.count ? bullets[i] : ""
                    let centered = i+1 < bullets.count ? bullets[i+1] : ""
                    bulletPairs.append(FoodPlanData.BulletPairs(regular: regular, centered: centered))
                }
                bulletpointsDoubled[key] = bulletPairs
            } else {
                // Regular bullets
                bulletpoints[key] = group.bullets
            }
        }
    }

    return FoodPlanData(
        titles: titles.isEmpty ? nil : titles,
        subtitles: subtitles.isEmpty ? nil : subtitles,
        subsubtitles: subsubtitles.isEmpty ? nil : subsubtitles,
        bulletpoints: bulletpoints.isEmpty ? nil : bulletpoints,
        bulletpointsDoubled: bulletpointsDoubled.isEmpty ? nil : bulletpointsDoubled
    )
}
