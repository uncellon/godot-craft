extends Control

################################################################################
# Exports                                                                      #
################################################################################

@export var player: Player
@export var chunk_material: Material # Material used to preview blocks

################################################################################
# Members                                                                      #
################################################################################

var hotbar_selected_index: int = 0
var hotbar_step: int = 0
var hotbar_start_x: float = 0

################################################################################
# On-ready variables                                                           #
################################################################################

@onready var hotbar_texture_rect: TextureRect = $HotbarTextureRect
@onready var hotbar_selection_texture_rect: TextureRect = $HotbarSelectionTextureRect

################################################################################
# Overridden built-in methods                                                  #
################################################################################

func _ready() -> void:
	hotbar_step = int(hotbar_texture_rect.size.x / player.HOTBAR_CAPACITY)
	hotbar_start_x = hotbar_selection_texture_rect.position.x - (player.HOTBAR_CAPACITY - 1) / 2.0 * hotbar_step
	player.hotbar_selected_index_changed.connect(_set_hotbar_selected_index)
	_set_hotbar_selected_index(player.hotbar_selected_item_index)

	_draw_hotbar()

func _process(_delta: float) -> void:
	pass

################################################################################
# Methods                                                                      #
################################################################################

func _set_hotbar_selected_index(value: int):
	hotbar_selection_texture_rect.position.x = hotbar_start_x + hotbar_step * value

func _draw_hotbar():
	for i in range(Inventory.CAPACITY - 9, Inventory.CAPACITY):
		var stack = player.inventory.get_stack_at(i)
		if stack == null:
			continue
