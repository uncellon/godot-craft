@tool
class_name FlatChunkGenerator
extends AbstractChunkGenerator

################################################################################
# Methods                                                                      #
################################################################################

func get_block_id(block_pos: Vector3i) -> ItemsDatabase.Id:
	if block_pos.y < 1:
		return ItemsDatabase.Id.GRASS
	return ItemsDatabase.Id.AIR
