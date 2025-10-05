# Expense Tracker 💰

A Flutter mobile application to help users track and manage their daily expenses with easy-to-read charts and transaction lists.

---

## ✨ Features

- Add expenses
- Track spending by categories
- View recent transactions
- Visualize spending patterns with interactive charts
- Clean and responsive UI

---

## 🖼️ Screenshots

| Home | statistics | create expense | add category | profile |
|------|-------|------|-------|-------|
|<img width="1080" height="2400" alt="Screenshot_1759669903" src="https://github.com/user-attachments/assets/d79aa1a3-cd20-4c51-a495-890f029c0a57" />|<img width="1080" height="2400" alt="Screenshot_1759669951" src="https://github.com/user-attachments/assets/fdf3b571-8dd0-4867-a639-842bf2a1be4b" />|<img width="1080" height="2400" alt="Screenshot_1759670044" src="https://github.com/user-attachments/assets/efe487b9-025e-4acf-964d-a438eb7ce275" />|<img width="1080" height="2400" alt="Screenshot_1759670019" src="https://github.com/user-attachments/assets/12bb96ea-84e1-4699-938d-a80819538425" />|<img width="1080" height="2400" alt="Screenshot_1759669892" src="https://github.com/user-attachments/assets/8926f1ce-4724-4386-8884-b43f0fb6a82d" />|

---

## Getting Started 🚀

### Prerequisites

- Flutter SDK >= 3.0.0  
- Dart >= 3.0.0  
- Android Studio or VS Code  

### Installation

1. Clone the repository:

bash
git clone https://github.com/Sarahelkholy/expense_tracker.git
Navigate into the project directory:

bash
Copy code
cd expense_tracker
Install dependencies:

bash
Copy code
flutter pub get
Run the app:

bash
Copy code
flutter run

## 🛠️ Project Structure
```
lib/
├── screens/
│   ├── add_expense/  
│   │   ├── blocs/  
│   │   │   ├── create_category_bloc/               
│   │   │   ├── create_expense_bloc/ 
│   │   │   └── get_categories_bloc/      
│   │   └── presentation/  
│   │       ├── widgets/               
│   │       ├── add_expense_screen.dart
│   │       └── create_category.dart   
│   ├── home/  
│   │   ├── blocs/  
│   │   │   └── get_expense_bloc/      
│   │   └── presentation/  
│   │       ├── widgets/               
│   │       ├── home_screen.dart
│   │       └── main_screen.dart           
│   ├── profile/  
│   │   ├── blocs/  
│   │   │   └── user_bloc/      
│   │   └── presentation/  
│   │       └── profile_screen.dart          
│   └── stats/  
│       └── presentation/  
│           ├── widgets/               
│           └── stats_screen.dart                 
│
├── app_view.dart
├── app.dart
├── simple_bloc_observer.dart
└── main.dart

packages/
├── expense_repository/
│   ├── lib/               
│   │   ├── src/  
│   │   │   ├── entities/               
│   │   │   ├── models/ 
│   │   │   ├── firebaser_expense_repository.dart              
│   │   │   └── expense_repo.dart 
│   │   └── expense_repository.dart   
│   │
│   └── pubspec.yaml              
│
└── user_repository/
     ├── lib/               
     │    ├── src/  
     │    │   ├── entities/               
     │    │   ├── models/ 
     │    │   ├── firebaser_user_repository.dart              
     │    │   └── user_repo.dart 
     │    └── user_repository.dart   
     │
     └── pubspec.yaml        
```
## Dependencies 📦

flutter_screenutil – for responsive UI

fl_chart – for charting

expense_repository – for handling expense data

cloud_firestore 

bloc – for state management

## Usage
Launch the app on your device/emulator.

Add a new expense by entering the amount, category, and date.

View the expense chart to track spending patterns over the week.
