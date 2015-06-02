var test = require('tape');
var request = require('request-json');
var config = require('../config.js')
var _ = require('lodash')
 
// json REST client
var client = request.createClient(config.collectionServerURL)

// couchdb
var cradle = require('cradle')
// connect to couch
db = new(cradle.Connection)(config.dbHost, config.dbPort)
  .database(config.dbName)

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
			t.equal(201, response.statusCode)
		}
	)
})

test('posting data to no channel -> 400 + BadRequestError', function(t) {
	t.plan(2)
	client.post(
		'/post/',
		goodData,
		function(error, response, body) {
			t.equal('BadRequestError', body.code)
			t.equal(400, response.statusCode)
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
			t.equal('UnprocessableEntityError', body.code)
			t.equal(422, response.statusCode)
		}
	)
	// 2. null data
	client.post(
		'/post/test', 
		null,
		function(error, response, body) {
			t.equal('UnprocessableEntityError', body.code)
			t.equal(422, response.statusCode)
		}
	)
	// 3. empty data
	client.post(
		'/post/test', 
		{},
		function(error, response, body) {
			t.equal('UnprocessableEntityError', body.code)
			t.equal(422, response.statusCode)
		}
	)
})


// 
// couch DB tests
// 
test('db should exist', function (t) {
	t.plan(2)
	db.exists(function (err, exists) {
		t.equal(null, err)
		t.equal(true, exists)
	})
})

test('should be able to retreive a post within 100ms of HTTP response', function (t) {
	t.plan(2)

	var msResponse = 100

	var channelName = JSON.stringify(new Date())

	var myData = {
		user: 'me',
		device: 'neurosky',
		data: {data:'garbage'}
	}

	// post data to made up channel name
	client.post(
		'/post/' + channelName,
		myData,
		function (err, res, body) {
			t.equal(201, res.statusCode)
			// query by made up channelName
			setTimeout(function() {
				db.view('posts/byChannel', { key: channelName }, function (err, docs) {
					// see if our data === queryed data
					t.deepEquals(_.first(docs).value, myData)
				})
			}, msResponse)
		}
	)
})
