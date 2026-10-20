extends Node

signal score_changed(score: int)
signal kick_count_changed(kick_count: int)
signal hit(position:Vector2,ball:Ball)

#signal player_died()
#signal distance_changed(distance: float)
#signal survival_time_changed(time: float)

var score: int = 0
var kick_count: int = 0


func _reset():
	score = 0
	kick_count = 0

func add_score(amount: int):
	score += amount
	score_changed.emit(score)
	
func add_kick(amount: int):
	kick_count += amount
	kick_count_changed.emit(kick_count)
	
func emit_ball_hit(position:Vector2,ball: Ball):
	hit.emit(position,ball)
	
