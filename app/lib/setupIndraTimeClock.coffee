$ = require 'jquery'
Bacon = require 'baconjs'
Bacon$ = require 'bacon.jquery'
baconmodel = require 'bacon.model'
moment = require 'moment'

timediff = (one, the_other) -> moment(the_other).diff(one)
getServerTime = (timeDiff) -> moment(new Date()).utc().add(timeDiff)
showClock = (time) -> $('#clock').html(moment(time).format('MMMM Do YYYY, H:mm:ss:SSS'))

setupIndraTimeClock = (fetchTimeInterval, timeServerURL) ->

	# a timediff var that mutates everytime we fetch time from the timeserver
	timeDiff = 0

	# fetch the server's time on an interval
	serverTimeResults = Bacon.interval(fetchTimeInterval)
		.map(() -> return {url:timeServerURL})
		.ajax()

	# on each response from the timeserver
	# set the diff between the servers time and ours
	serverTimeResults
		.map((t)-> timediff(moment(t), moment(new Date())))
		.onValue((t) -> timeDiff = t)

	# show a clock that updates every 300ms
	Bacon.interval(300).onValue( () -> 
		showClock(getServerTime(timeDiff)))

module.exports = setupIndraTimeClock