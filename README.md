# My Game

## How to checkout the game
1. Extract the DragonRuby version you want to use somewhere
2. Delete original `mygame` folder (or alternatively rename it into `mygame-template` if you want to keep the files around)
3. Clone your game (this repository) via git
4. Copy the DragonRuby engine into your game repository (don't forget the hidden `.dragonruby` folder)

## How to update the DragonRuby version
1. Execute following command in your repository
   ```sh
   git clean -f -x -d
   ```
   This will recursively delete all unknown & ignored files in your repository (i.e. the engine).

   Be aware that this might also delete all other ignored files in your repository (like maybe save games) - so if you want
   to keep anything make sure that you backup those files first
2. Copy the new version of the DragonRuby engine into your game repository (don't forget the hidden `.dragonruby` folder)
