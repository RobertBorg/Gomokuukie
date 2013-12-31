Router.configure
	layoutTemplate: 'layout'
	autoRender: false

Router.map ->
	###
	The route's name is "home"
	The route's template is also "home"
	The default action will render the home template
	###
	@route 'game',
		path: '/'

	@route 'highscore',
		path: '/highscore'