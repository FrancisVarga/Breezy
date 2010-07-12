package breezy
{
	public class BaseHandler
	{
		import com.adobe.serialization.json.JSON;
		
		import flash.net.Socket;
		import flash.xml.XMLDocument;
		import flash.xml.XMLNode;
		import flash.utils.ByteArray;
		
		import mx.rpc.xml.SimpleXMLEncoder;
		
		import breezy.Mustache;
		
		private var request:Object;
		private var response:Object = new Object();
		private var socket:Socket;
		
		public function BaseHandler(request:Object, socket:Socket){
			this.request = request;
			this.socket = socket;
			this.response.code = "200 OK";
		}
		
		public function write(data:Object, binary:Boolean=false):void{
			socket.writeUTFBytes("HTTP/1.1 "+this.response.code+"\r\n");
			socket.writeUTFBytes("Content-Type: " + this.response.contentType + "\r\n\r\n");
			if(binary){
				this.socket.writeBytes(ByteArray(data));
			}
			else{
				this.socket.writeUTFBytes(String(data));
			}
			this.socket.flush();
			this.finish();
		}
		
		public function set contentType(t:String):void{
			this.response.contentType = t;
		}
		
		public function set body(b:Object):void{
			this.response.body = b;
			this.response.contentLength = b.length;
		}
		
		public function get body():Object{
			return this.response.body;
		}
		
		/**
		 * Serialize view object to XML string.
		 */
		public function to_xml(obj:Object):String{
			var qName:QName = new QName("response");
			var xmlDocument:XMLDocument = new XMLDocument();
			var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
			var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(obj, qName, xmlDocument);
			var xml:XML = new XML(xmlDocument.toString());
			return xml;
		}
		
		/**
		 * Serialize a view object to json.
		 */
		public function to_json(obj:Object):String{
			return JSON.encode(obj);
		}
		
		/**
		 * Default render call.
		 */
		public function render(tpl:String, obj:Object):void{
			var format:Object = this.get_argument('view', 'json');
			var output:String = "";
			switch(format.toString()){
				case 'html':
					this.contentType = "text/html";
					output = new Mustache().to_html(tpl, obj);
					break;
				case 'json':
					this.contentType = "application/json";
					output = this.to_json(obj);
					break;
				case 'xml':
					this.contentType = "text/xml";
					output = this.to_xml(obj);
					break;
			}
			this.body = output;
			this.write(this.body);
		}
		
		/**
		 * Get a query string argument.
		 * 
		 * @todo(lucas) Support POST.
		 */
		public function get_argument(name:String, def:Object=null):Object{
			if(Object(this.request.parameters).hasOwnProperty(name)){
				return this.request.parameters[name];
			} 
			return def;
		}
		
		public function notFound():void{
			this.socket.writeUTFBytes("HTTP/1.1 404 Not Found\r\n");
			this.socket.writeUTFBytes("Content-Type: text/html; charset=UTF-8\r\n\r\n");
			this.socket.writeUTFBytes("<html><body><h1>Page Not Found</h1></body></html>");
			this.socket.flush();
			this.finish();
		}
		
		private function finish():void{
			this.socket.close();
		}
		
	}
}