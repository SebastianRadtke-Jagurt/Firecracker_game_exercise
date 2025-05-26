# Firecracker
Small game made in Godot, for a game jam, as an exercise.

## What's the game about?

It is a minimalistic 2D fighting game where you control a swordsman and fight just a few waves of enemies.  

I really wanted to learn and apply techniques from [Game Programming Patterns](https://gameprogrammingpatterns.com) book,  
so I was late with my game jam application but decided to "finish" the prototype anyways.

You can play the game [here](https://sebasfealunn.itch.io/firecracker) or download the repo and build the game in [Godot 4.2.2](https://godotengine.org/download/archive/).

## What about the book?
I have read about half of the [Game Programming Patterns](https://gameprogrammingpatterns.com) book by the time I decided to make this project and I found some techniques it contains to be extremely useful. I have 2 year commercial experience in C# and Unity but I find my coding to be manageable at best. The book describes patterns that would have made my work a lot easier and code clearer so I've decided to make exercise projects for patterns I find most beneficial.

## What patterns did I apply, how and for what?
Patterns I decided to prioritize are (unsurprisingly) [State](https://gameprogrammingpatterns.com/state.html) for handling character behavior and [Command](https://gameprogrammingpatterns.com/command.html) for handling inputs.

State pattern allowed me to write behaviors that are shareable between different characters. For example I wrote moving state that reads input from its character and then transforms its position accordingly.

With Command pattern I made custom inputs that work the same regardless if states receiving them are on the player character or AI driven NPC. This allowed me to share the same states between all characters without much trouble.

In order to explain my implementation of State and Command patterns I will need to explain how my "characters" work.

### What is a character?
In context of my game a character is a script which stores data, initiates behaviors it is linked to (such as states and AI) and relays communication between said behaviors. Character is a base class from which child classes such as "Player" or "Enemy/Grunt" inherit from. These child classes then register their own states and inputs individually.

### So what are states and when they come into play?
They are basically actions any character can perform such as moving, attacking etc.  
States have general and unique set of behaviors which are executed when character enters them, during the time of persisting in them and when character exits them. They also have an array of possible transitions to different states that are triggered by character's inputs.  

Simplest example would be "Moving" state. When entering the state as a result of a character input, the character starts playing a moving animation. When state persists it reads character's movement input and modifies character's movement vector accordingly. Otherwise when the state doesn't read any movement input, the state exits itself and the character enters an idle state instead.

This provides more clean and organized control over characters through transitions while also maintaining great flexibility of behaviors.
