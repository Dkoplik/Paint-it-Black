@tool
class_name LevelsResource
extends Resource

## Пути к игровым уровням. Также массив задаёт порядок этих уровней.
@export var levels: PackedStringArray
## Сцена главного меню.
@export var main_menu: PackedScene
## Дефолтная сцена. Используется, если отсутствует иная сцена для загрузки.
@export var default_scene: PackedScene
## Экран (сцена) загрузки.
@export var loading_sceen: PackedScene
@export var fading_screen: PackedScene
