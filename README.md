# DIPLOMA2023
Fitness Trainer Companion App by Martin Bernat

## App Description
This application is for teams of fitness trainers or individuals,  designed to handle multiple clients and create customized fitness plans, food protocols, skinfold measurements and progres photo albums. Developed primarily for iPad (iOS), the app is built using SwiftUI and Firebase Firestore for the database.

## Project Description
The project started user research. Analysis of existing solutions, literature and focus group.
On the focus group (fitness trainers) were then conducted qualitative analysis with numerous interviews.
Based on the analysis were created functional requirements for the app.
Design of the app started by Lofi Prototype and later a Hifi prototype done in Figma. 
After successful design of the app, structural diagrams were made as a bridge between design and development
Based on these diagrams was then the app developed and tested. 






Figma Hifi prototype:

https://github.com/matobernat/DIPLOMA2023/assets/36670189/9ba6bef6-0aa1-4a0a-9b2a-5eaf0b5ef46b


Final app:

https://github.com/matobernat/DIPLOMA2023/assets/36670189/79c89204-ca9a-4d9b-9b62-3905806a65d1






## Try the app online for yourself!

1. Go to [appetize.io ](https://appetize.io)
2. if you already have an account, you can use public key to the app: enok2mm5lp4le456rtcsutsppa


3. Otherwise you can use my account
4. appetioze.io Login: martinbernat13@gmail.com password: Martinbernat13
5. Go to Diploma_2023 app
6. set the device to any iPad
7. set iOS to iOS 16.0 and higher
8. Ideally set orientation to Landscape
9. Play The App
10. To access already created data, use my app account.
11. Email: matobernat@gmail.com password: matobernat
12. Now you should be able to use the app.
13. You can list trhough Client and their respective data or other sections of the app.






## Setup & Installation
To set up and run this project, follow the steps below:

1. Clone the repository. You can do this by running the following command in your terminal:
2. git clone https://github.com/matobernat/DIPLOMA2023.git
4. Install Xcode. You need Xcode to build and run the project. You can download it from the [Apple Developer Site](https://developer.apple.com/xcode/) or from the Mac App Store.
5. Open the project. Open the .xcodeproj or .xcworkspace file in Xcode.

## Running The Project
To run the project after setting it up:

1. Select the target. In Xcode, select the iPad simulator as your target device from the device drop-down.
2. Run the project. Click the "Play" button or press Cmd+R to build and run the project. Xcode will start the iPad simulator and run your app.

## Firebase Configuration
This project uses Firebase Firestore for database operations. To set up Firebase:

1. Create a Firebase project. Go to the Firebase console, click "Add project," and follow the instructions to create a new project.
2. Enable Firestore and Authentication. In your Firebase project, enable Firestore for storing data and Firebase Authentication for email/password authentication.


4. Set up Firestore rules and indexes. After enabling Firestore, go to the Firestore database section in your Firebase project.

    * For Rules: Navigate to the "Rules" tab and set up your security rules. These are the rules:
    
      ```
      rules_version = '2';
      service cloud.firestore {
        match /databases/{database}/documents {
           //Default rule for most collections
           match /{collection}/{document} {
             allow read, write: if request.auth != null && request.auth.uid == resource.data.accountID;
           }
          // Special rule for accounts collection
          match /accounts/{id} {
            allow read, write: if request.auth != null && request.auth.uid == resource.data.id;
          }
        }
      }
      ```
    
    
   * For Indexes: Navigate to the "Indexes" tab and set up your indexes. You can specify the fields to index, and whether they should be ascending or descending. It's important to note that creating composite indexes in Firestore can take a few minutes.
   
   ![Alt Text](https://github.com/matobernat/DIPLOMA2023/assets/36670189/94df7e68-57fd-47f6-9a37-b528d034ebc2)
   https://github.com/matobernat/DIPLOMA2023/assets/36670189/94df7e68-57fd-47f6-9a37-b528d034ebc2
   
    

These rules and indexes are necessary for your application to function properly, and that they should be set up correctly.




4. Add an iOS app to the project. Click the iOS icon to add an iOS app to your Firebase project. Enter your app's bundle ID. Follow the instructions to download the GoogleService-Info.plist file.
5. Add GoogleService-Info.plist to your project. Drag the GoogleService-Info.plist file into the root of your Xcode project and add it to all targets.
6. Install Firebase SDK. [Follow the Firebase iOS SDK setup instructions](https://firebase.google.com/docs/ios/setup) to install the SDK.
License & Attribution



## Future Scope
Future development can incorporate features like meal plans, tracking body measurements, and progress albums as it was meanted and its already started in a codebase. 

## License & Attribution
As this is a diploma thesis project, there are no licensing rights associated with the use of the project's codebase. However, any use of the code should appropriately reference this repository and the author.
