const keys = require('./keys');
const redis = require('redis');

const redisClient = redis.createClient({
  host: keys.redisHost,
  port: keys.redisPort,
  retry_strategy: () => 1000
});
const sub = redisClient.duplicate();

function fib(index) {
  if (index < 2) return 1;
  //  return fib(index - 1) + fib(index - 2);
    var v1, v2, sum, ctr;
    v1 = 1;
    v2 = 1;
    for (ctr = 1; ctr < index; ctr++) {
	if (ctr % 2 == 1) v1 += v2;
	else v2 += v1;
    }
    sum = v1 > v2 ? v1 : v2;
    return sum;
}

sub.on('message', (channel, message) => {
  redisClient.hset('values', message, fib(parseInt(message)));
});
sub.subscribe('insert');
