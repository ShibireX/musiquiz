# MusiQuiz - Test Your Music Knowledge

## Description
The MusiQuiz IOS application utilizes the Spotify API in order to build quizzes from artists and songs. There are multiple quiz categories (based on e.g. genre) and two types of quizzes: 

### Artist Quiz
The quiz will display pictures of artists and for each question provide four alternatives for artist names. The goal is to get as many artists right as possible.

### Song Quiz
The quiz will play a song and provide four alternatives for song names. The goal is to get as many songs right as possible.

A quiz score is calculated based on when the user gets a question right, as well as the time elapsed before the user presses the correct option. For gamification purposes, each quiz and quiz type holds high scores which update and persist between app sessions, providing a fun motivation for the user.

## Demonstration
A visual demonstration of the application in action is available at: https://www.youtube.com/watch?v=-LdOlLU9EDc

## Dependencies
- Spotify Web API
- Combine
- KeyChainAccess

## Limitations
Worth noting is that the application currently needs CodeAuthorizationFlow authorization to be able to work as intended with the artist specials quizzes. This is due to the fact that the audio previews sourced from the Spotify API often only exist within this authorization scope (for unclear reasons). Taking this into account, developers that want to examine or further expand the application will have to undergo several steps to enable development in their own environment. For development, I recommend reading the Swift library documentation for the Spotify Web API: https://github.com/Peter-Schorn/SpotifyAPI