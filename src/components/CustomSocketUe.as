 package components
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import utility.MyEvent;
	public class CustomSocketUe extends EventDispatcher
	{
		private var _socket:Socket;
		private var _recvStr:String;
		private var _myByte:ByteArray=new ByteArray();
	 
		
		public function CustomSocketUe()
		{
			socket=new Socket();
			socket.addEventListener(Event.CLOSE, closeHandler,false,0,true);
			socket.addEventListener(Event.CONNECT, connectHandler,false,0,true);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false,0,true);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler,false,0,true);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler,false,0,true);
		}
		
		
	 
		 
		public function get myByte():ByteArray
		{
			return _myByte;
		}
		
		public function set myByte(value:ByteArray):void
		{
			_myByte = value;
		}
		
		public function get recvStr():String
		{
			return _recvStr;
		}
		
		public function set recvStr(value:String):void
		{
			_recvStr = value;
		}
		
		public function get socket():Socket
		{
			return _socket;
		}
		
		public function set socket(value:Socket):void
		{
			_socket = value;
		}
		
		private function closeHandler(event:Event):void {
			//trace("closeHandler: " + event);
		}
		
		private function connectHandler(event:Event):void {
			trace("connectHandler ue");
			dispatchEvent(new Event("_connectHandler"));
		}
		public function sendRequest(command:String):void {
			socket.writeUTFBytes(command);
			socket.flush();
		}
		private function ioErrorHandler(event:IOErrorEvent):void {
			//		trace("ioErrorHandler: " + event);
			trace("ioErrorHandler:"+event);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			//	trace("securityErrorHandler: " + event);
			trace("securityErrorHandler:");
		}
		private function socketDataHandler(event:ProgressEvent):void {
			//	trace("socketDataHandler: " + event);
			//	trace("readResponse()");
			readResponse();
		}
		
		private function readResponse():void
		{
			
			while(true)
			{
				
				socket.readBytes(myByte,myByte.length,socket.bytesAvailable);
				
				    myByte.position=0;
					var a:String=	myByte.readUTFBytes(myByte.length); 
					myByte.position=myByte.length; 
					
				   
						var evt:MyEvent=new MyEvent("_newComingData",false,false,a);
						myByte.clear();
						dispatchEvent(evt);
						break;
				 
			}
			
		}
		
	}
}