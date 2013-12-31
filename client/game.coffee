global=@
Template.game.events(
	'click button#newGame': ->
		#template data, if any, is available in 'this'
		Session.set "numCookies", parseInt $('input#numCookies').val()
		Session.set "selectedCharacter", $('select').val()
		Session.set "gameStarted", true
	'click td.gameboard-col': (event, template)->
		#template data, if any, is available in 'this'
		selected = Session.get "selected"
		node = $(event.srcElement)
		game = global.Games.findOne({_id: global.Session.get("activeGame")})
		clicked = game.board[node.data('y')][node.data('x')]
		if selected != undefined
			if selected.x == clicked.x && selected.y == clicked.y
				Session.set "selected", undefined
			else
				if clicked.value == 0
					self.game.move selected, clicked
					Session.set "selected", undefined
				else
					console.log "tried to place on non-empty"
		else 
			if @value != 0
				Session.set "selected", {x:clicked.x, y:clicked.y}
	'click button#create-new-game' : (event, template)->
		Session.set "activeGame", undefined
		Session.set "gameStarted", false
		Session.set "selected", undefined
)

Template.characterSelection.events(
	'click .character': (event, template) ->
		node = $(event.srcElement)
		Session.set "selectedCharacter", node.data('id')

)
Template.gameBoard.created = ->
		if Session.get("activeGame")?
			self.game  = new Game()	
		else
			self.game  = new Game {numCookies: Session.get("numCookies")}

Template.gameBoard.destroyed = ->
	self.game = undefined
	console.log "destroyed gameboard"

Template.gameBoardCell.getPathForCookie = ->
	if 1 <= @value <= 9
		"images/Mumms/" + cookies[@value - 1].src
	else
		""

Template.gameBoardCell.isSelected = ->
	selected = Session.get "selected"
	selected? && this.x == selected.x && this.y == selected.y			  

Template.gameBoard.getGame = ->
	global.Games.findOne({_id: Session.get("activeGame")})

Template.gameBoard.getCharacter = ->
	global.Characters.findOne({_id: @character})

Template.game.gameStarted = ->
	Session.get "gameStarted"

Template.character.notGameStarted = ->
	!Session.get "gameStarted"

Template.newGame.getNumCookies = ->
	Session.get "numCookies"

Template.characterSelection.getCharacters = ->
	global.Characters.find()

Template.character.selected = ->
		@_id == Session.get "selectedCharacter"

Template.character.getExperience = ->
	experience = Meteor.user().experience
	if experience?[@_id]?
		experience?[@_id]
	else
		0

Template.characterSelection.getExperience = ->
	experience = Meteor.user().experience
	if experience?[@_id]?
		experience?[@_id]
	else
		0

Template.characterSelection.rendered = ->
	$("select").imagepicker({show_label:true})
