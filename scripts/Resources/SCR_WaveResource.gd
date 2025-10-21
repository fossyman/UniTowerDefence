extends Resource
class_name Wave

@export var Enemies:Array[PackedScene]
@export var SpawnOrder:Array[int]

@export var EnemyCapacity = 10

var NextEnemyIDX = 0
var NextSpawnOrder = 0

func GetNextEnemy() -> PackedScene:
	if SpawnOrder.is_empty():
		var enemy = Enemies[NextEnemyIDX]
		NextEnemyIDX+=1
		NextEnemyIDX = wrap(NextEnemyIDX,0,Enemies.size())
		return enemy
	var enemy = Enemies[SpawnOrder[NextSpawnOrder]]
	NextSpawnOrder+=1
	return enemy
