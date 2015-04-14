$ = require 'jquery'
Bacon = require 'baconjs'
Bacon$ = require 'bacon.jquery'
baconmodel = require 'bacon.model'
randomString = require 'make-random-string'
setupIndraTimeClock = require './lib/setupIndraTimeClock.coffee'
toggleButtons = require './lib/toggleButtons.coffee'

# config vars
fetchTimeInterval = 3000
timeServerURL = 'http://indra.webfactional.com'
postDataInterval = 1000
dataCollectionServerURL = 'http://indra.webfactional.com/pm2app'

interval = (delay, fn) -> setInterval(fn, delay)
generateRandomId = -> randomString(4, 'abcdefghijklmnopqrstuvwxyz1234567890')
getPostData = (userId) -> {id: userId}

postData = (data) ->
	console.log 'im posting'
	$.ajax({
		type: 'POST'
		url: dataCollectionServerURL
		data: JSON.stringify(data)
		contentType: 'application/json; charset=utf-8'
		dataType: 'application/json'
		success: () -> console.log 'ok'
		})

# TODO start/stop button
init = -> 

	# show a clock thats synced with indra time
	setupIndraTimeClock(fetchTimeInterval, timeServerURL)

	# generate our id
	id = generateRandomId()
	# put the id in the view
	$('#userId').html('your id: ' + id)
	# initialize post counter at 0
	postRequestCount = 0
	# the interval we start/stop to post data
	postRequestInterval = null

	# when start button is pressed, hide it + show stop button
	# when stop button is pressed, hide it + show start button
	$startButton = $('#startButton')
	$stopButton = $('#stopButton')
	startStopStream = toggleButtons($startButton, 'start', $stopButton, 'stop')

	startStopStream
		.filter((v)->if v == 'start' then v)
		.onValue(() ->
			postRequestInterval = interval(postDataInterval, () ->
				# post data to the server
				postData(getPostData(id))
				# update the post counter
				postRequestCount+=1
				$('#postRequestCount').html(postRequestCount))
			console.log 'trying to start interval', postRequestInterval)

	startStopStream
		.filter((v)->if v == 'stop' then v)
		.onValue(() -> clearInterval(postRequestInterval))

	console.log 'launched'

# launch the app
$(document).ready(() ->
	init() )
