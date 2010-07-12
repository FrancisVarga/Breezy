package breezy
{
	public class HttpServer
	{
		import breezy.Mime;
		
		import flash.events.Event;
		import flash.events.ProgressEvent;
		import flash.events.ServerSocketConnectEvent;
		import flash.net.ServerSocket;
		import flash.net.Socket;
		import flash.utils.ByteArray;
		
		import mx.controls.Alert;
		import mx.utils.ObjectUtil;
		
		public var port:Number;
		private var server:ServerSocket;
		
		private var application:Application;
		
		public function HttpServer(application:Application){
			this.application = application;
		}
		
		public function listen(port:Number=8991):void{
			this.port = port;
			this.server = new ServerSocket();
			this.server.addEventListener(Event.CONNECT, socketConnectHandler);
			this.server.addEventListener(Event.CLOSE,socketCloseHandler);
			this.server.bind(this.port);
			this.server.listen();
			this.log("Listening on port " + String(this.port) + "...\n");
		}
		private function socketConnectHandler(event:*):void{
			var socket:Socket = event.socket;
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		}
		
		private function log(what:Object):void{
			trace(what.toString());
		}
		
		private function socketDataHandler(event:ProgressEvent):void{
			try{
				var socket:Socket = event.target as Socket;
				var bytes:ByteArray = new ByteArray();
				socket.readBytes(bytes);
				var request:String = "" + bytes;
				this.log(request);
				
				var details:Object = this.parse_path(request.split("\n")[0]);
				
				var filePath:String = request.substring(4, request.indexOf("HTTP/") - 1);
				var controller:Object = this.application.__call__(details, socket);
				if(!controller){
					var c:BaseHandler = new BaseHandler(details, socket);
					c.notFound();
				}
			}
			catch (error:Error){
				Alert.show(error.message, "Error");
			}
		}
		protected function socketCloseHandler(e:Event):void{
			this.log("Socket Closed");
		}
		
		public function parse_path(url:String):Object{
			var path:String;
			var parameters:Object;
			var method:String;
			url = url.replace(" HTTP/1.1", "");
			
			var reg:RegExp = /(?P<method>(GET|POST|DELETE|PUT+)) ((?P<path>[^?]*))?((?P<parameters>.*))?/x;
			var results:Array = reg.exec(url);
			path = results.path;
			method = results.method;
			
			var paramsStr:String = results.parameters;
			if(paramsStr!=""){
				parameters = null;
				parameters = new Object();
				if(paramsStr.charAt(0) == "?"){
					paramsStr = paramsStr.substring(1);
				}
				var params:Array = paramsStr.split("&");
				for each(var paramStr:String in params){
					var param:Array = paramStr.split("=");
					parameters[param[0]] = param[1];
				}                               
			}
			return {method: method, path: path, parameters:parameters};
		}
	}
}