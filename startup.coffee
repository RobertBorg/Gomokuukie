global = @
if Meteor.isServer
	Meteor.startup ->
		if @Characters.find().count() == 0
			@Characters.insert(
				name: "BearCake"
				portrait: "bjoernkakan.png"
			)
			@Characters.insert(
				name: "The Doc"
				portrait: "inverteradedoktorn.png"
			)
			@Characters.insert(
				name: "Kultingen"
				portrait: "Kultingen.png"
			)
			@Characters.insert(
				name: "The Mask"
				portrait: "mask.png"
			)
			@Characters.insert(
				name: "Monster"
				portrait: "monster.png"
			)
			@Characters.insert(
				name: "Totoro"
				portrait: "totorpo.png"
			)
			@Characters.insert(
				name: "Tounge"
				portrait: "tungan.png"
			)