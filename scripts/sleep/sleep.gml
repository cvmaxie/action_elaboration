//sleep (milliseconds)

//store the time RIGHT NOW when we called the function
var start_time = get_timer()/1000;
var time_elapsed = 0;
while (time_elapsed < argument0){ //while current time is less than desired total time
	var time_now = get_timer()/1000;
	time_elapsed = time_now - start_time;
	
}