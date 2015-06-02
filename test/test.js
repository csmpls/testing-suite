var test = require('tape');
var request = require('request-json');
var config = require('../config.js')
 
var client = request.createClient(config.collectionServerURL)

var goodData = {
  user: 'me',
  device: 'neurosky',
  data: {nice:'yep'}
}

var badData = {
	device: 'neurosky',
	data: {nice:'no its not'}
}

test('posting good data', function(t) {
	t.plan(2)
	client.post(
		'/',
		goodData,
		function(error, response, body) {
			t.equal(error, null)
			t.equal(response.statusCode, 200)
		}
	)
})

test('posting bad data', function(t) {
	t.plan(1)
	client.post(
		'/',
		badData,
		function(error, response, body) {
			t.equal(response.statusCode, 422)
		}
	)
})