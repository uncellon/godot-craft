@tool

class_name ItemIcon
extends TextureRect

################################################################################
# Exports                                                                      #
################################################################################

@export var icon_size: int = 256:
	set(new_icon_size):
		icon_size = new_icon_size
		set_size(Vector2(icon_size, icon_size))
		draw()

@export var item_id = ItemsDatabase.Id.AIR:
	set(new_item_id):
		item_id = new_item_id
		draw()

@export var item_material: Material:
	set(new_item_material):
		item_material = new_item_material
		draw()

################################################################################
# Overridden built-in methods                                                  #
################################################################################

func _ready() -> void:
	draw()

################################################################################
# Custom methods                                                               #
################################################################################

func draw() -> void:
	# Some extra if-logic to determine how to draw item
	# ...

	for n in get_children():
		remove_child(n)

	if item_material == null:
		return
	_draw_block_icon()

func _clear() -> void:
	for n in get_children():
		remove_child(n)

# 2D item
func _draw_item_icon() -> void:
	pass

# 3D item or block in other words
func _draw_block_icon() -> void:
	_clear()

	# Light
	var directional_light_3d = DirectionalLight3D.new()
	directional_light_3d.rotation_degrees = Vector3(-30.0, 97.5, 180)
	directional_light_3d.name = "DirectionalLight3D"
	add_child(directional_light_3d)
	#directional_light_3d.set_owner(EditorInterface.get_edited_scene_root())

	# SubViewport
	var subviewport: SubViewport = SubViewport.new()
	subviewport.name = "SubViewport"
	subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	subviewport.transparent_bg = true
	subviewport.size = Vector2i(icon_size, icon_size)
	add_child(subviewport)
	#subviewport.set_owner(EditorInterface.get_edited_scene_root())

	# Camera
	var camera3d = Camera3D.new()
	camera3d.name = "Camera3D"
	camera3d.size = 1.6
	camera3d.position = Vector3(1.0, 1.15, -1.0)
	camera3d.rotation_degrees = Vector3(-25.0, 135.0, 0)
	camera3d.projection = Camera3D.ProjectionType.PROJECTION_ORTHOGONAL
	subviewport.add_child(camera3d)
	#camera3d.set_owner(EditorInterface.get_edited_scene_root())

	# Mesh
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.set_material(item_material)

	# Top face
	var texture_slice = ItemsDatabase.get_texture_indices(item_id)[ItemsDatabase.Side.TOP] + \
		material.get_shader_parameter("texture_array").get_texture_slice_offset(item_id)
	_draw_face(surface_tool, Block.TOP_FACE, texture_slice)

	# Bottom face
	texture_slice = ItemsDatabase.get_texture_indices(item_id)[ItemsDatabase.Side.BOTTOM] + \
		material.get_shader_parameter("texture_array").get_texture_slice_offset(item_id)
	_draw_face(surface_tool, Block.BOTTOM_FACE, texture_slice)

	# Left face
	texture_slice = ItemsDatabase.get_texture_indices(item_id)[ItemsDatabase.Side.LEFT] + \
		material.get_shader_parameter("texture_array").get_texture_slice_offset(item_id)
	_draw_face(surface_tool, Block.LEFT_FACE, texture_slice)

	# Right face
	texture_slice = ItemsDatabase.get_texture_indices(item_id)[ItemsDatabase.Side.RIGHT] + \
		material.get_shader_parameter("texture_array").get_texture_slice_offset(item_id)
	_draw_face(surface_tool, Block.RIGHT_FACE, texture_slice)

	# Front face
	texture_slice = ItemsDatabase.get_texture_indices(item_id)[ItemsDatabase.Side.FRONT] + \
		material.get_shader_parameter("texture_array").get_texture_slice_offset(item_id)
	_draw_face(surface_tool, Block.FRONT_FACE, texture_slice)

	# Back face
	texture_slice = ItemsDatabase.get_texture_indices(item_id)[ItemsDatabase.Side.BACK] + \
		material.get_shader_parameter("texture_array").get_texture_slice_offset(item_id)
	_draw_face(surface_tool, Block.BACK_FACE, texture_slice)

	var mesh_instance_3d = MeshInstance3D.new()
	mesh_instance_3d.name = "MeshInstance3D"
	mesh_instance_3d.mesh = surface_tool.commit()
	mesh_instance_3d.position.x = -0.5
	mesh_instance_3d.position.z = -0.5
	add_child(mesh_instance_3d)
	#mesh_instance_3d.set_owner(EditorInterface.get_edited_scene_root())

	# Render image
	await RenderingServer.frame_post_draw
	var image = subviewport.get_texture().get_image()

	_clear()

	texture = ImageTexture.create_from_image(image)

func _draw_face(st: SurfaceTool, face: Array, texture_slice: float) -> void:
	# A -- D
	# | \  | Drawing order
	# |  \ |
	# B -- C

	var a: Vector3 = Block.VERTICES[face[0]]
	var b: Vector3 = Block.VERTICES[face[1]]
	var c: Vector3 = Block.VERTICES[face[2]]
	var d: Vector3 = Block.VERTICES[face[3]]

	var uv_a = Vector2(0.0, 0.0)
	var uv_b = Vector2(0.0, 1.0)
	var uv_c = Vector2(1.0, 1.0)
	var uv_d = Vector2(1.0, 0.0)

	var side_a = b - a
	var side_b = a - c
	var normal = side_a.cross(side_b)

	st.add_triangle_fan([a, b, c], [uv_a, uv_b, uv_c], [], [Vector2(texture_slice, 0.0)], [normal])
	st.add_triangle_fan([a, c, d], [uv_a, uv_c, uv_d], [], [Vector2(texture_slice, 0.0)], [normal])
