package cn.wecoding.component
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 *  
	 * @author yatsen_yang
	 * 
	 */	
	public class RadioButtonGroup extends EventDispatcher
	{
		private var _array:Array;
		private var _selectedData:Object;
		private var _name:String;
		
		public function RadioButtonGroup(name:String)
		{
			_array = [];
			_name = name;
		}
	
		public function addRadioButton(radioButton:RadioButton):void
		{
			_array.push(radioButton);
		}
		
		/**
		 * 改变组内除了参数代表的radiobutton之外，其余radiobutton的状态 
		 * @param radiobutton
		 * 
		 */		
		public function changeMemberState(radioButton:RadioButton):void
		{
			var len:int = _array.length;
			for(var i:int = 0; i < len; i++)
			{
				if(_array[i].value != radioButton.value)
				{
					_array[i].selected = false;
				}
			}
			
			_selectedData = radioButton.value;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get selectedData():Object
		{
			return _selectedData;
		}		
		
		public function get numRadioButtons():int
		{
			return _array.length;
		}
		
		public function getRadioButtonAt(index:int):RadioButton
		{
			return _array[index] as RadioButton;
		}
		
		public function removeRadioButton(radioButton:RadioButton):void
		{
			var len:int = _array.length;
			for(var i:int = 0; i < len; i++)
			{
				if(_array[i].value == radioButton.value)
				{
					break;
				}
			}
			
			_array.splice(_array[i], 1);
		}
		
		public function removeAllRadioButtons():void
		{
			_array = [];
		}
	}
}