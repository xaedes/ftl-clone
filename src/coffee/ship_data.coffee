define(["assets"], (Assets) ->
	ship_data = 
		kestral: Assets.json("data/ships/kestral.json", "ships.kestral")
		kestral_2: Assets.json("data/ships/kestral_2.json", "ships.kestral_2")
)