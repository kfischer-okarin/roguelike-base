# My Game

## How to checkout the game
1. Extract the DragonRuby version you want to use somewhere
2. Delete original `mygame` folder (or alternatively rename it into `mygame-template` if you want to keep the files around)
3. Clone your game (this repository) via git
4. Copy the DragonRuby engine into your game repository (don't forget the hidden `.dragonruby` folder)

## TODO
- Render Map
  - Read Map portion and render completely
  - Only render when updated - store in render target
    - Keep visible map
- Entities
  - Components
    - Container ?
    - Location
      - EntityStore#entities_at_location
  - Map is an Container
  - Object attributes - automatically wrapped in object
    - Polymorphic attributes (class depending on :type key - define via hash)
- Game System
  - Entities emit actions
    - Store in history?
  - World reacts to actions

- Wall Merging
- Separate Map Generation into phases
  - Visualize minimap after each phase
  - UI with parameter settings
  -
