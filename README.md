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

With Command pattern I made custom inputs that work the same regardless if character receiving them is player character or AI driven NPC. This allowed me to share the same states between all characters without much trouble.

