## Example:

    /**
     * Setup the routing and start the server.
     */
    var handlers:Array = [
		new Route(/\/api\/resolve\/(\w+)\/(\w+)\/?/, WebServer, 'resolve'),
		new Route(/\/api\/get_results\/(\[^\/]+)\/?/, WebServer, 'get_results'),
		new Route(/\/api\/stream\/(\[^\/]+)\/?/, WebServer, 'stream'),
	];
	var app:Application = new Application(handlers);
	var http_server:HttpServer = new HttpServer(app);
	http_server.listen(8888);
	
