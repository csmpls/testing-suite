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

//
//  client POST responses
//
test('posting good data -> 201', function(t) {
	t.plan(1)
	client.post(
		'/post/test',
		goodData,
		function(error, response, body) {
			t.equal(response.statusCode, 201)
		}
	)
})

test('posting data to no channel -> 400 + BadRequestError', function(t) {
	t.plan(2)
	client.post(
		'/post/',
		goodData,
		function(error, response, body) {
			t.equal(body.code, 'BadRequestError')
			t.equal(response.statusCode, 400)
		}
	)
})

test('posting bad data -> 422 + UnprocessableEntityError', function(t) {
	t.plan(6)
	// 1. poorly-formed data
	client.post(
		'/post/test',
		badData,
		function(error, response, body) {
			t.equal(body.code, 'UnprocessableEntityError')
			t.equal(response.statusCode, 422)
		}
	)
	// 2. null data
	client.post(
		'/post/test', 
		null,
		function(error, response, body) {
			t.equal(body.code, 'UnprocessableEntityError')
			t.equal(response.statusCode, 422)
		}
	)
	// 3. empty data
	client.post(
		'/post/test', 
		{},
		function(error, response, body) {
			t.equal(body.code, 'UnprocessableEntityError')
			t.equal(response.statusCode, 422)
		}
	)
})
