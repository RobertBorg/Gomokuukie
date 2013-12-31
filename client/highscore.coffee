global = @
if Meteor.isClient
	Template.highscore.getHighscore = ->
		highscore = global.Games.find({gameOver: true}, {sort:{score: -1}, limit: 20})
		if highscore.count() > 0
			highscore
		else
			undefined
	Template.highscore.getPersonalHighscore = ->
		highscore = global.Games.find({gameOver: true, user: Meteor.userId()} , {sort: {score: -1}, limit: 20})
		if highscore.count() > 0
			highscore
		else
			undefined
	Template.highscoreRow.getUserName = ->
		if @user?
			user = Meteor.users.findOne({_id:@user})
			if user?.username?
				user.username
			else
				user.profile?.name
		else
			"-unknown-"
	Template.highscoreRow.rendered = ->
		$(@firstNode).text("#{this.firstNode.parentElement.rowIndex}")