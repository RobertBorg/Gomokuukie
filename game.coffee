global = @
class @Game
	@direction: [{x:0, y:1},{x:1, y:1},{x:1, y:0}, {x:1, y:-1}]

	constructor: (@args)-> 
		self = @
		if @args?.numCookies?
			board = for y in [0...8]
				for x in [0...8]
					{x:x, y:y, value:0}
			global.Games.insert({user: Meteor.userId(), freeTurns: 0, score: 0, numCookies: 0, numCookieTypes: @args.numCookies, character: Session.get("selectedCharacter"), board: board}, (err, id)->
				unless err?
					global.Session.set("activeGame",id)
					for i in [0...3]
						self.putNewCookie()
			)
			console.log "new game inserted"

	#to and from is {x, y}
	move: (from, to)->
		#todo add sanity checks
		#todo check legality
		game = global.Games.findOne({_id: global.Session.get("activeGame")})
		game.board[to.y][to.x].value = game.board[from.y][from.x].value
		game.board[from.y][from.x].value = 0
		global.Games.update({_id: global.Session.get("activeGame") }, {$set: {board: game.board}})
		removed = @findAndRemove(to) if @constructor.isTherePath from, to
		if removed > 0
			scoreToGain = 5 + (removed - 5) * 3
			global.Games.update({_id: global.Session.get("activeGame") }, {$inc: {freeTurns: 1, score: scoreToGain} } ) if removed > 0
			experience = Meteor.user().experience
			unless experience?
				experience = {}
			unless experience[Session.get "selectedCharacter"]?
				experience[Session.get "selectedCharacter"] = 0
			experience[Session.get "selectedCharacter"] += scoreToGain
			global.Meteor.users.update(
				_id: Meteor.userId()
			,
				$set:
					experience: experience
			)
		if game.freeTurns == 0
			for i in [0...3]
				cookie;
				if (cookie = @putNewCookie()) == undefined
					alert "game over!"
					global.Games.update({_id: global.Session.get("activeGame") }, {$set: {gameOver: true} })
				removed = @findAndRemove(cookie)
				if removed > 0
					scoreToGain = 5 + (removed - 5) * 3
					global.Games.update({_id: global.Session.get("activeGame") }, {$inc: {freeTurns: 1, score: scoreToGain} })
					experience = Meteor.user().experience
					experience[Session.get "selectedCharacter"] += scoreToGain
					global.Meteor.users.update(
						_id: Meteor.userId()
					,
						$set:
							experience: experience
					)
		else
			global.Games.update({_id: global.Session.get("activeGame") }, {$inc: {freeTurns: -1}})


	findAndRemove: (start)->
		#check for 5 in row!
		game = global.Games.findOne({_id: global.Session.get("activeGame")})
		start = game.board[start.y][start.x]
		toTotalDelete = []
		totalScore = 0;
		for i in [0...4]
			#find end
			atLeastFive = false
			toDelete = []
			dir = @constructor.direction[i]
			count = 1
			cx = start.x
			cy = start.y
			nx = cx + dir.x
			ny = cy + dir.y
			if 0 <= nx < 8 && 0 <= ny < 8 && game.board[ny][nx].value == start.value
				loop
					cx = nx
					cy = ny
					nx += dir.x
					ny += dir.y
					break unless 0 <= nx < 8 && 0 <= ny < 8 && game.board[ny][nx].value == start.value
			#go in oposite direction and count
			nx = cx - dir.x
			ny = cy - dir.y
			if nx < 8 && nx >= 0 && ny < 8 && ny >= 0 && game.board[ny][nx].value == start.value
				toInsert = {x:cx, y:cy};
				toDelete.push toInsert unless _.contains toDelete, toInsert
				loop
					cx = nx
					cy = ny
					toInsert = {x:cx, y:cy}
					toDelete.push toInsert unless _.contains toDelete, toInsert
					++count
					nx -= dir.x
					ny -= dir.y
					break unless nx < 8 && nx >= 0 && ny < 8 && ny >= 0 && game.board[ny][nx].value == start.value
			#if over 5, remove all
			if count >= 5
				atLeastFive = true
				toTotalDelete = toTotalDelete.concat toTotalDelete, toDelete		
		removed = 0
		if toTotalDelete.length >= 5
			removed = toTotalDelete.length
			game.board[node.y][node.x].value = 0 for node in toTotalDelete
			global.Games.update({_id: global.Session.get("activeGame") }, {$set: {board: game.board}, $inc: {numCookies: -removed}})
		removed

	putNewCookie: ->
		game = global.Games.findOne({_id: global.Session.get("activeGame")});
		if game.numCookies < 64
			loop
				x = _.random 0, 7
				y = _.random 0, 7
				if game.board[y][x].value == 0
				    game.board[y][x].value = _.random 1, game.numCookieTypes
				    global.Games.update({_id: global.Session.get("activeGame") }, {$set: {board: game.board}, $inc: {numCookies: 1}})
				    if game.numCookies == 63
				    	return undefined
				    else
				    	return game.board[y][x]
		else
			undefined

	

	#to and from is {x, y}
	@isTherePath: (from, to)-> 
		return true
		gameBoard = Session.get "gameBoard"

		calcH = (node)->
			absX = Math.abs(node.x - to.x);
			absY = Math.abs(node.y - to.y);
			Math.sqrt absX*absX + absY*absY 
		
		addNodesToOpenList = (node)->

		openList = new PriorityQueue (a, b)-> 
			b.F - a.F;

