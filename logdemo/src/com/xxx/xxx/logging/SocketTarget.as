package com.xxx.xxx.logging
{
	import flash.net.Socket;
	
	import mx.logging.AbstractTarget;
	import mx.logging.LogEvent;
	
	public class SocketTarget extends AbstractTarget
	{
		private var _host:String;
		private var _port:int;
		private var _socket:Socket;
		
		public function SocketTarget(host:String, port:int)
		{
			super();
			
			_host = host;
			_port = port;
			_socket = new Socket(host,port);
		}
		
		override public function logEvent(event:LogEvent):void
		{
			_socket.writeUTFBytes(event.message);
			_socket.flush();
		}
	}
}