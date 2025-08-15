class_name Stack
extends RefCounted

################################################################################
# Members                                                                      #
################################################################################

var _id: int
var _count: int

################################################################################
# Custom methods                                                               #
################################################################################

func get_item_id():
    return _id

func set_item_id(id: int):
    _id = id

func get_item_count():
    return _count

func set_item_count(count: int):
    _count = count
