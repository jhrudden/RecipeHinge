# Recipe Hinge

Recipe Hinge is an diverse recipe finding application. The goal of Recipe Hinge is to allow users to discover new recipes and try that they may have never even heard of.

As of current, Recipe Hinge is able to transform a User's food interests into lists of Recipes that they may swipe through. The app does this by prompting User's with food questionaires, in order ot find their interests, then create recipes in accordance with those responses.

![Alt text](/assets/dashboard.png)
![Alt text](https://media.giphy.com/media/yoqZQJIZisfbY46Vs2/giphy.gif)

![Alt text](https://media.giphy.com/media/mf2IV436o9VNrSSTsO/giphy.gif)
![Alt text](https://media.giphy.com/media/BqtmRLxsvAablwq12o/giphy.gif)

# Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Project Architecture

The majority of this project's architecture has been inspired by the CLEAN Architecture.

**Entities/Data models** exists within <code>./models</code>

**Infrastructure** exists within <code>./infrastructure</code>

**Business Logic** exists within <code>./bloc</code>

**UI/Presentation** exists within <code>./presentation</code>

For state management in this project, I decided to use BLoC Design Pattern. This is mostly because I found this design pattern both readable and scalable. All Business Logic Components can be found in my <code>./bloc</code> directory.

# Pitfalls of Current Implementation

1. Questions aren't linked

   **Explanation:** Questions the Recipe Hinge ask its users are not at all connected. Meaning they are randomly pulled from the database. Structuring how questions are stored and pulled from the database may be more productive, because it would all for the app to ask questions based off users past responses. This would allow for more specific tags to be connected to the users and specialized array of recipes for the user to process.

2. Users aren't able to add Recipes to Recipe haul

3. Users aren't able to add Questions to question haul

4. No use for recipes information, once the user has liked a recipe

   **Explanation:** Originally, I had planned to add functionality to support being able to add recipes to a cook list for a week. This would also add all ingrediantes to a shopping list for the week. This list could then be added to a pdf or shared via email.
