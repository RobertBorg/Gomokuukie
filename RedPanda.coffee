global=@

if Meteor.isClient
	Session.setDefault "startCookies", 3
	Session.setDefault "numCookies", 8
	global.cookies = [{src:"chokladkaka.png"},
	              {src:"Prinsess.png"},
	              {src:"lussebulle.png"},
	              {src:"syltkaka.png"}
	              {src:"macaron.png"},
	              {src:"muffin.png"},
	              {src:"kanelbulle.png"},
	              {src:"dammsugare.png"},
	              ];