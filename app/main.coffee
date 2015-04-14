$ = require 'jquery'
Bacon = require 'baconjs'
Bacon$ = require 'bacon.jquery'
baconmodel = require 'bacon.model'

setupIndraTimeClock = require './lib/setupIndraTimeClock.coffee'

fetchTimeInterval = 3000
timeServerURL = 'http://indra.webfactional.com'

postDataInterval = 1000
dataCollectionServerURL = 'http://indra.webfactional.com/collector'

postData = (data) ->
	$.ajax({
		type: 'POST'
		url: dataCollectionServerURL
		data: JSON.stringify(data)
		contentType: 'application/json; charset=utf-8'
		dataType: 'application/json'
		success: () -> console.log 'ok'
		})

init = -> 
	# show a clock thats synced with indra time
	setupIndraTimeClock(fetchTimeInterval, timeServerURL)

	# post something every n ms
	# TODO: post time
	Bacon.interval(500)
		.onValue(() -> postData({id:'s0m3h4sh'}))

	console.log 'launched'

# launch the app
$(document).ready(() ->
	init() )
