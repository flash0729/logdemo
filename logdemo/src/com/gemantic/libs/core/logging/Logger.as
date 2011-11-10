/**
 *  AIR处理日志记录的包。
 *  
 *  @author zwzhou
 */
package com.gemantic.libs.core.logging
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	
	/**
	 *  在日志记录中使用的记录程序。
	 */
	public final class Logger
	{
		private static var loggers:Dictionary = new Dictionary();
		
		private static var _level:int = int.MAX_VALUE;
		
		/**
		 *  提供对此目标的当前设置级别的访问。
		 *  有效值包括：
		 *    <ul>
		 *      <li><code>mx.logging.LogEventLevel.FATAL (1000)</code> 
		 *      指示负面影响严重且最终会导致应用程序失败的事件。</li>
		 *
		 *      <li><code>mx.logging.LogEventLevel.ERROR (8)</code> 
		 *      指示可能仍然允许应用程序继续运行的错误事件。</li>
		 *
		 *      <li><code>mx.logging.LogEventLevel.WARN (6)</code>
		 *      指示会对应用程序运行造成损害的事件</li>
		 *
		 *      <li><code>mx.logging.LogEventLevel.INFO (4)</code>
		 *      指示在粗粒度级别重点介绍应用程序运行情况的信息性消息。</li>
		 *
		 *      <li><code>mx.logging.LogEventLevel.DEBUG (2)</code>
		 *      指示对调试应用程序大有帮助的细粒度级别的信息性消息。</li>
		 *
		 *      <li><code>mx.logging.LogEventLevel.ALL (0)</code> 
		 *      旨在强制目标处理所有消息。</li>
		 *    </ul>
		 *  
		 */
		public static function get level():int
		{
			return _level;
		}
		
		/**
		 *  @private
		 */
		public static function set level(value:int):void
		{
			_level = value;
		}
		
		private var category:String = "";
		
		
		/**
		 *  The separator string to use between fields (the default is " ")
		 */
		private var fieldSeparator:String = " ";
		
		/**
		 *  Indicates if the category should added to the trace(the default is true).
		 */
		private var includeCategory:Boolean;
		
		/**
		 *  Indicates if the date should be added to the trace(the default is true).
		 */
		private var includeDate:Boolean;
		
		/**
		 *  Indicates if the level for the event should added to the trace(the default is true).
		 */
		private var includeLevel:Boolean;
		
		/**
		 *  Indicates if the time should be added to the trace(the default is true).
		 */
		private var includeTime:Boolean;
		
		/**
		 *  构造函数。
		 *
		 *  @param category 日志类别。
		 */
		public function Logger(category:String)
		{
			this.category = category;
			
			includeTime = true;
			includeDate = true;
			includeCategory = true;
			includeLevel = true;
		}
		
		/**
		 *  根据category获取一个日志记录实例。
		 *
		 *  @param category 日志类别。
		 * 
		 *  @return category类别名的日志记录实例。
		 */
		public static function getLogger(category:String):Logger
		{
			if (!loggers[category]) {
				return new Logger(category);
			}
			return loggers[category];
		}
		
		/**
		 *  使用<code>mx.logging.LogEventLevel.DEBUG</code>级别记录指定的数据。 
		 *  <code>mx.logging.LogEventLevel.DEBUG</code> 指示对调试应用程序大有帮助的细粒度级别的信息性消息。
		 *  
		 *  @param message 要记录的信息。
		 *  此字符串可以包含 {x} 形式的特殊标记字符，其中 x 是从零开始的索引，
		 *  将由在该索引位置找到的附加参数取代（如果已指定）。
		 *
		 *  @param rest 可以在字符串参数中的每个“{x}”位置处作为替代内容的附加参数，其中 x 是
		 *  指定值的 Array 中一个从零开始的整数索引值。
		 * 
		 */
		public function debug(message:String, ... rest):void
		{
			var message:String = format(LogEventLevel.DEBUG,message,rest);
			
			log(LogEventLevel.DEBUG,message);
		}
		
		/**
		 *  使用<code>mx.logging.LogEventLevel.INFO</code>级别记录指定的数据。 
		 *  <code>mx.logging.LogEventLevel.INFO</code> 指示在粗粒度级别重点介绍应用程序运行情况的信息性消息。
		 *  
		 *  @param message 要记录的信息。
		 *  此字符串可以包含 {x} 形式的特殊标记字符，其中 x 是从零开始的索引，
		 *  将由在该索引位置找到的附加参数取代（如果已指定）。
		 *
		 *  @param rest 可以在字符串参数中的每个“{x}”位置处作为替代内容的附加参数，其中 x 是
		 *  指定值的 Array 中一个从零开始的整数索引值。
		 * 
		 */
		public function info(message:String, ... rest):void
		{
			var message:String = format(LogEventLevel.INFO,message,rest);
			
			log(LogEventLevel.INFO,message);
		}
		
		/**
		 *  使用<code>mx.logging.LogEventLevel.WARN</code>级别记录指定的数据。 
		 *  <code>mx.logging.LogEventLevel.WARN</code> 指示会对应用程序运行造成损害的事件。 
		 *
		 *  @param message 要记录的信息。
		 *  此字符串可以包含 {x} 形式的特殊标记字符，其中 x 是从零开始的索引，
		 *  将由在该索引位置找到的附加参数取代（如果已指定）。
		 *
		 *  @param rest 可以在字符串参数中的每个“{x}”位置处作为替代内容的附加参数，其中 x 是
		 *  指定值的 Array 中一个从零开始的整数索引值。
		 * 
		 */
		public function warn(message:String, ... rest):void
		{
			var message:String = format(LogEventLevel.WARN,message,rest);
			
			log(LogEventLevel.WARN,message);
		}
		
		/**
		 *  使用<code>mx.logging.LogEventLevel.ERROR</code>级别记录指定的数据。 
		 *  <code>mx.logging.LogEventLevel.ERROR</code> 指示可能仍然允许应用程序继续运行的错误事件。
		 *  
		 *  @param message 要记录的信息。
		 *  此字符串可以包含 {x} 形式的特殊标记字符，其中 x 是从零开始的索引，
		 *  将由在该索引位置找到的附加参数取代（如果已指定）。
		 *
		 *  @param rest 可以在字符串参数中的每个“{x}”位置处作为替代内容的附加参数，其中 x 是
		 *  指定值的 Array 中一个从零开始的整数索引值。
		 * 
		 */
		public function error(message:String, ... rest):void
		{
			var message:String = format(LogEventLevel.ERROR,message,rest);
			
			log(LogEventLevel.ERROR,message);
		}
		
		/**
		 *  使用<code>mx.logging.LogEventLevel.FATAL</code>级别记录指定的数据。 
		 *  <code>mx.logging.LogEventLevel.FATAL</code> 指示负面影响严重且最终会导致应用程序失败的事件 。
		 *  
		 *  @param message 要记录的信息。
		 *  此字符串可以包含 {x} 形式的特殊标记字符，其中 x 是从零开始的索引，
		 *  将由在该索引位置找到的附加参数取代（如果已指定）。
		 *
		 *  @param rest 可以在字符串参数中的每个“{x}”位置处作为替代内容的附加参数，其中 x 是
		 *  指定值的 Array 中一个从零开始的整数索引值。
		 * 
		 */
		public function fatal(message:String, ... rest):void
		{
			var message:String = format(LogEventLevel.FATAL,message,rest);
			
			log(LogEventLevel.FATAL,message);
		}
		
		private function log(logLevel:int, message:String):void
		{
			if (!isLoggable(logLevel))
			{
				return;
			}
			
			try
			{
				var logFilePath:String = File.applicationStorageDirectory.resolvePath( "Logs\\" + new Date().toLocaleDateString() + ".log" ).nativePath;
				var file:File = new File(logFilePath);
				var fs:FileStream = new FileStream();
				fs.open(file, FileMode.APPEND);
				fs.writeUTFBytes(message + File.lineEnding);
				fs.close();
			}catch(e:Error){}			
		}
		
		/**
		 *  清除所有日志。
		 */
		public static function clear():Boolean
		{
			try
			{
				var logFilePath:String = File.applicationStorageDirectory.resolvePath( "Logs\\").nativePath;
				var file:File = new File(logFilePath);
				if (file.exists)
				{
					file.deleteDirectory(true);
				}
			}
			catch(e:Error)
			{
				return false;
			}
			
			return true;
		}
		
		private function isLoggable(logLevel:int):Boolean
		{
			return logLevel >= level;   
		}
		
		private function formatDateTime():String
		{
			var date:String = ""
			if (includeDate || includeTime)
			{
				var d:Date = new Date();
				if (includeDate)
				{
					date = Number(d.getMonth() + 1).toString() + "/" +
						d.getDate().toString() + "/" + 
						d.getFullYear() + fieldSeparator;
				}   
				if (includeTime)
				{
					date += padTime(d.getHours()) + ":" +
						padTime(d.getMinutes()) + ":" +
						padTime(d.getSeconds()) + "." +
						padTime(d.getMilliseconds(), true) + fieldSeparator;
				}
			}
			
			return date;
		}
		
		private function padTime(num:Number, millis:Boolean = false):String
		{
			if (millis)
			{
				if (num < 10)
					return "00" + num.toString();
				else if (num < 100)
					return "0" + num.toString();
				else 
					return num.toString();
			}
			else
			{
				return num > 9 ? num.toString() : "0" + num.toString();
			}
		}
		
		private function formatMessage(message:String,rest:Array):String
		{
			for (var i:int = 0; i < rest.length; i++)
			{
				message = message.replace(new RegExp("\\{"+i+"\\}", "g"), rest[i]);
			}
			return message;
		}
		
		private function format(logLevel:int, message:String, rest:Array):String
		{
			var levelString:String = "";
			if (includeLevel)
			{
				levelString = "[" + LogEvent.getLevelString(logLevel) +
					"]" + fieldSeparator;
			}
			
			var nameString:String = includeCategory ? category + fieldSeparator : "";
			
			return formatDateTime() + levelString + nameString + formatMessage(message,rest);
		}
	}
}