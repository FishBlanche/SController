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
	public class CustomSocket extends EventDispatcher
	{
		private var _socket:Socket;
		 private var _recvStr:String;
		 private var _myByte:ByteArray=new ByteArray();
		 private var _dataTypeflag:int;
	 
		 private var _firstSegflag:Boolean=true;
	    private var _picTotalLen:uint=0;
	 
		public function CustomSocket()
		{
			socket=new Socket();
			socket.addEventListener(Event.CLOSE, closeHandler,false,0,true);
			socket.addEventListener(Event.CONNECT, connectHandler,false,0,true);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler,false,0,true);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler,false,0,true);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler,false,0,true);
		}

		 

		public function get picTotalLen():uint
		{
			return _picTotalLen;
		}

		public function set picTotalLen(value:uint):void
		{
			_picTotalLen = value;
		}

		 public function get firstSegflag():Boolean
		 {
			 return _firstSegflag;
		 }

		 public function set firstSegflag(value:Boolean):void
		 {
			 _firstSegflag = value;
		 }

		 public function get dataTypeflag():int
		 {
			 return _dataTypeflag;
		 }

		 public function set dataTypeflag(value:int):void
		 {
			 _dataTypeflag = value;
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
			trace("connectHandler");
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
			
			
			
			if(this._dataTypeflag==3||this._dataTypeflag==7)
			{
				
				if(firstSegflag)
				{
				//	trace("myByte 1\n"+myByte+"\n");
				 //	 trace("myByte"+myByte[0]+","+myByte[1]+","+myByte[2]+","+myByte[3]+","+myByte[4]+","+myByte[5]+","+myByte[6]+","+myByte[7]);	 
					firstSegflag=false;//the first segment of the picture contains the total length of the picture
					var tempBY:ByteArray=new ByteArray;
					myByte.readBytes(tempBY,0,8);
			 		tempBY.endian=Endian.LITTLE_ENDIAN;
				//	trace("myByte"+myByte[0]+","+myByte[1]+","+myByte[2]+","+myByte[3]+","+myByte[4]+","+myByte[5]+","+myByte[6]+","+myByte[7]);	 
				//	trace("tempBY\n"+tempBY+"\n");
			//	     trace("tempBY"+tempBY[0]+","+tempBY[1]+","+tempBY[2]+","+tempBY[3]+","+tempBY[4]+","+tempBY[5]+","+tempBY[6]+","+tempBY[7]);	 
				
			   //     trace("readDouble():"+tempBY.readUnsignedInt());
		 		    this.picTotalLen=tempBY.readUnsignedInt();
			    	 var m:uint=tempBY.readUnsignedInt();
			 	//   trace("this.picTotalLen m"+this.picTotalLen+","+m);
					if(myByte.length-8==this.picTotalLen)
					{
						dispatchEvent(new Event("_newComingData"));
				
					}
					break;
				}
				else
				{
				//	 trace("myByte 0\n"+myByte.length+"\n");
					if(myByte.length-8==this.picTotalLen)
					{
						  
						dispatchEvent(new Event("_newComingData"));
					}
					break;
				}
			}
			else
			{
				myByte.position=0;
				var a:String=	myByte.readUTFBytes(myByte.length); 
				myByte.position=myByte.length; 
		 
				if(myByte[myByte.length-1]==49)
				{
					dataTypeflag=1;
				 
					dispatchEvent(new Event("_newComingData"));
					break;
				}
				else if(myByte[myByte.length-1]==50)
				{
					dataTypeflag=2;
				 
					dispatchEvent(new Event("_newComingData"));
					break;
				}
				else if(myByte[myByte.length-1]==51)
				{
					dataTypeflag=4;
					dispatchEvent(new Event("_newComingData"));
			 
					break;
				}
				else if(myByte[myByte.length-1]==54)
				{//54 ==6
					dataTypeflag=6;
					dispatchEvent(new Event("_newComingData"));
					
					break;
				}
				 
				else
				{
					break;
				}
			}
			
		 	
		}
	 	
		}

	}
}