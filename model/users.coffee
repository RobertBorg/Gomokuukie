if Meteor.isClient
	Deps.autorun( ->
		Meteor.subscribe "userData"
	)
	@Accounts?.ui?.config(
		###
		requestPermissions:
			facebook: ['user_likes'],
			github: ['user', 'repo']
		,
		requestOfflineToken: 
			google: true
		,
		###
		passwordSignupFields: 'USERNAME_ONLY'
	)

if Meteor.isServer
	Meteor.users.allow(
		update: (userId, doc, fieldNames, modifier) ->
			true
	)
	Meteor.publish("userData", ->
		Meteor.users.find(
			_id: this.userId
		,
			fields: 
				experience: 1
		)
	)
	