package utility
{
	import flash.events.Event;  
	import flash.events.EventDispatcher;  
	
	public class MyEvent extends Event  
	{  
		 
		
		public var data:Object;  
		
		public var dis:EventDispatcher = new EventDispatcher();  
		
		public function MyEvent(type:String,bubbles:Boolean = false,canceable:Boolean = false,data:Object = null)  
		{  
			super(type,bubbles,canceable);  
			this.data = data;  
		}  
		
	}  
}