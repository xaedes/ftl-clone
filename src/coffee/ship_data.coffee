define(["assets"], (Assets) ->
	ships = ["kestral","kestral_2","boss_1"]
	ship_data = {}
	for ship in ships
		ship_data[ship] = Assets.json("data/ships/"+ship+".json", "ships."+ship)

	return ship_data
)