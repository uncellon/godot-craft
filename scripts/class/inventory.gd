class_name Inventory
extends RefCounted

################################################################################
# Constants                                                                    #
################################################################################

const CAPACITY = 45

################################################################################
# Members                                                                      #
################################################################################

var _stacks: Dictionary

################################################################################
# Custom methods                                                               #
################################################################################

func get_stack_at(index: int):
    if _stacks.has(index):
        return _stacks[index]
    return null

func set_stack_at(index: int, stack: Stack):
    if index < 0 or index > CAPACITY:
        push_error("Index must be between 0 and CAPACITY")
    _stacks[index] = stack