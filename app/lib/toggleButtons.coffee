$ = require 'jquery'
Bacon = require 'baconjs'
Bacon$ = require 'bacon.jquery'
baconmodel = require 'bacon.model'

# takes two buttons
# sets them up such that click button1 toggles between button2 and vice versa
# returns a merged stream of the two click streams, mapped to (button1val, button2val)
toggleButtons = ($button1, button1val, $button2, button2val) ->

	# hide button 2
	$button2.hide()

	button1Stream = $button1.asEventStream('click')
		.map(button1val)

	# side effects: hide button1 sow button2
	button1Stream
		.onValue(() -> 
			# hide start button
			$button1.hide()
			# show stop button
			$button2.show())

	button2Stream = $button2.asEventStream('click')
		.map(button2val)

	# side effects: hide button2 sow button1
	button2Stream
		.onValue(() -> 
			$button2.hide()
			$button1.show())

	mergedStream = button1Stream.merge(button2Stream)

module.exports = toggleButtons