@import <Foundation/CPObject.j>


@implementation Framerate : CPObject {

	int _lastTime;
	Array _rates;
	int _size;
	int _currentIndex;
}

- (id)init {
	self = [super init];
	
	if (self) {
		_lastTime = new Date().getTime();
		_size = 25;
		_currentIndex = 0;
		_rates = [];
		
		for (var i = 0; i < _size; i++) {
			_rates[i] = 0;
		}
	}
	
	return self;
}

- (void)tick {
	
	var timestamp = new Date().getTime();
	var rate = 1. /(timestamp - _lastTime);
	_lastTime = timestamp;
	
	_rates[_currentIndex++] = rate;
	if (_currentIndex == _size) {
		_currentIndex = 0;
	}
	
}

- (int)fps {
	var sum = 0;
	
	for (var i = 0; i < _size; i++) {
		sum += _rates[i];
	}
	
	return parseInt(1000. * sum / _size);
}


@end
