extends Node

const GAME_STATE_NEW = 1
const GAME_STATE_PLAYING = 2
const GAME_STATE_WON = 3
const GAME_STATE_LOST = 4
const GAME_STATE_UNLOCKED = 5

var player_object: Node2D = null

var state: int = GAME_STATE_NEW
