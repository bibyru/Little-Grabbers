## 📔 Game Description
![Gif of Trash Grabbers gameplay](https://github.com/bibyru/bibyru/blob/main/Gifs/TrashGrabbers.gif)

**Trash Grabbers** is a game where players work cooperatively as trash grabbers in a corporation creatively named The Corporation. Players must use wits (and corporate tools) to finish their job quickly and efficiently!

Download game [here](https://github.com/bibyru/Little-Grabbers/releases/).

<br/>

## 🎮 Game Controls
This game uses Mouse and Keyboard for Player 1 and Joysticks for Player 2 to Player 4.

_**Any type of joystick can be used**, the following are labels on an **xbox joystick**._

| **Action** | **Keyboard** | **Joystick** |
| :- | :- | :- |
| Move | W, A, S, D | Left stick |
| Jump | M | A |
| Interact | J | X |
| Throw | I | Y |

<br/>

## 📝 Project Info
This project is currently being developed using Godot v4.2.2.
| **Role** | **Credit** | **Development Time** |
| :- | :- | :- |
| Project lead | bibyru (Ruby) | 8 days |
| Game designer | bibyru (Ruby) | 2 day |
| Visual designer | bibyru (Ruby) | 2 day |
| Game programmer | bibyru (Ruby) | 4 days |
| Level designer | bibyru (Ruby), Deo Manuel Gani, Darren Keane | 2 day |
| Game balancer | bibyru (Ruby), Deo Manuel Gani, Darren Keane | 1 day |

<br/>

## ⭐ Scripts and Features
| **Script** | **Description** |
| :- | :- |
| `ButtonColor.gd` | Script for ColorButton to change Garby (player avatar) color. |
| `ButtonOnOff.gd` | Script for ToggleButton to change to on or off color. |
| `ButtonQuit.gd` | Script for Button to exit game. |
| `ButtonShape.gd` | Script for OptionButton to change Garby shape. |
| `EntityBID.gd` | Script for BID to convert Garbage objects into Garbage Block objects. |
| `EntityFallCatcher.gd` | Script for Area3D to reposition objects that fell through the level. |
| `EntityFallDestroyer.gd` | Script for Area3D to destroy objects that fell through the level. |
| `EntityGarbage.gd` | Script for Garbage objects for self initialization. |
| `EntityGarbageBlock.gd` | Script for Garbage Block objects for self initialization. |
| `EntityLevels.gd` | Script for Level entities to initialize itself and FinishLevelUI. |
| `EntityMovingPlatform.gd` | Script for Moving Platform objects to move toward location points. |
| `EntityObject.gd` | Script for sandbox objects. |
| `EntityPlayer.gd` | Script for player movement, inputs, animations, and interactions. |
| `EntityPortal.gd` | Script for Portal entities to teleport players. |
| `EntityRecycler.gd` | Script for Recycler objects to give or subtract points accordingly. |
| `EntityStep.gd` | Script for Step objects for self initialization. |
| `Manager.gd` | Singleton script for game initialization and functions, such as changing levels and managing saves. |
| `MenuColor.gd` | Script for Panel to contain player customization options, such as color and shape. |
| `MenuMain.gd` | Script for the main menu buttons. |
| `MenuPause.gd` | Script for the pause menu buttons. |
| `Platform.gd` | Script for the in-game buttons on moving platforms. |
| `SpawnerItem.gd` | Script for an item spawner for self initialization. |
| `SpawnerPlayer.gd` | Script for a player spawner for self initialization and to spawn players accordingly. |
| `SpawnerRecycler.gd` | Script for a Recycler spawner to set Recycler type. |
| `UICustomize.gd` | Script to initialize ColorButton(s). |
| `UIFinishLevel.gd` | Script for Finish Level menu and its buttons. |
| `UIGame.gd` | Script for in-level UI, managing score and time. |
| `UILevelDisplay.gd` | Script for displaying levels in the main menu. |
| `UIPropWarning.gd` | Script for displaying warnings in-game. |
| `UITrashCans.gd` | Script for displaying Trash Cans obtained from score in a level. |
| `UITutorial.gd` | Script for displaying how-to-play-notes in the Tutorial level. |

<br/>

## 📁 File Description
```
├── TrashGrabbers
    ├── Output    # for testing game outputs (saves)
    ├── Prefabs   # for prefabs used in a level
        ├── Entities    # for all single objects, like BID machine, Recycler, or Garbage Block
        ├── Garbage     # for all garbage objects
        ├── Spawners    # for all object spawners
        ├── UI          # for all UI objects
    ├── Sauce     # for all game assets
        ├── GamePhotos  # stores level photos
        ├── Models      # stores all 3D assets
            ├── Decor         # stores decoration type assets
            ├── Garbages      # stores garbage models
            ├── Garbies       # stores Garby types
            ├── Places        # stores level meshes
            ├── Recyclers     # stores recycler and its materials
        ├── Sounds      # stores all sounds
        ├── Sprites     # stores all icons
        ├── Theme       # stores all UI assets
    ├── Scenes    # for game levels
    ├── Scripts   # for game scripts
    ├── godot-jolt_v0.12.0-stable  # godot addon folder: Godot Jolt v0.12
```

<br/>

## 💿 How to Open in Game Engine
1. Download all files.
2. Extract to **Folder A** (an empty folder).
3. Launch Godot v4.2.2.
4. Press **Import** and select `project.godot` in **Folder A**.

_To install Godot Jolt v0.12:_
1. Download Godot Jolt v0.12 [here](https://github.com/godot-jolt/godot-jolt/releases/tag/v0.12.0-stable).
2. Extract folder to **Folder A**.
3. Launch project in Godot v4.2.2.
4. Press **Project** -> **Project Settings**.
5. Press **3D** in the **Physics** tab.
6. Change **Physics Engine** to **GodotJolt**.
