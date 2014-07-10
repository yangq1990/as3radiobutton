package cn.wecoding.component
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.core.MovieClipLoaderAsset;
	
	/**
	 * 自定义RadioButton类 
	 * @author yatsen_yang
	 * 
	 */	
	public class RadioButton extends Sprite
	{
		/** skin of icon **/
		[Embed(source="../../../../assets/skin.swf")]
		private var EmbeddedSkin:Class;
		
		private var _icon:MovieClip;
		/** label of RadioButton **/
		private var _tf:TextField;
		
		private var _format:TextFormat;
		
		private var _selected:Boolean;
		
		/** 文本和图标之间的距离 **/
		private var _textPadding:int = 5;
		
		private var _value:Object;
		
		private var _group:RadioButtonGroup;
		
		/**
		 * 
		 * @param font 字体
		 * @param color 字体颜色
		 * @param size 字体大小
		 * 
		 */		
		public function RadioButton(font:String, color:uint, size:int)
		{
			super();
			
			_format = new TextFormat();
			_format.font = font;
			_format.color = color;
			_format.size = size;
			
			_tf = new TextField();
			addChild(_tf);
			
			var skinObj:MovieClipLoaderAsset = new EmbeddedSkin() as MovieClipLoaderAsset;
			try {
				var embeddedLoader:Loader = Loader(skinObj.getChildAt(0));
				embeddedLoader.contentLoaderInfo.addEventListener(Event.INIT, loadComplete);
				embeddedLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadError);
			} catch (e:Error) {}
		}
		
		protected function loadComplete(evt:Event):void 
		{
			try {
				var loader:LoaderInfo = LoaderInfo(evt.target);				
				loader.removeEventListener(Event.INIT, loadComplete);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
				var skinClip:MovieClip = MovieClip(loader.content);
		
				/** _icon is a movieclip which contains 4 frames
				 * frame1 default(or mouse out)
 				 * frame2 mouse over
				 * frame3 mouse down
				 * frame4 mouse click(or selected);
				 * **/				
				_icon = skinClip.getChildByName('radiobutton') as MovieClip ;				
				_icon.addEventListener(MouseEvent.MOUSE_OVER, overIconHandler);
				_icon.addEventListener(MouseEvent.MOUSE_DOWN, downIconHandler);
				_icon.addEventListener(MouseEvent.CLICK, clickIconHandler);
				_icon.addEventListener(MouseEvent.MOUSE_OUT, outIconHandler);
				_icon.mouseEnabled = _icon.buttonMode = true;
				addChild(_icon);
				
				locate();
				
			} catch (e:Error) {
				
			}
		}
		
		protected function loadError(evt:IOErrorEvent):void 
		{
			
		}
		
		/** locate textfield when skin was loaded completely **/
		private function locate():void
		{
			if(_icon != null)
			{
				_tf.x = _icon.width + 5;
			}			
		}
		
		private function overIconHandler(evt:MouseEvent):void
		{
			!_selected && _icon.gotoAndStop(2);
		}
		
		private function downIconHandler(evt:MouseEvent):void
		{
			!_selected && _icon.gotoAndStop(3);
		}
		
		private function clickIconHandler(evt:MouseEvent):void
		{
			if(_selected)
				return;
			
			_icon.gotoAndStop(4);
			_selected = true;
			if(_group != null)
			{
				_group.changeMemberState(this);
			}
		}
		
		private function outIconHandler(evt:MouseEvent):void
		{
			!_selected && _icon.gotoAndStop(1); 
		}
		
		public function get label():String
		{
			return _tf.text;
		}
		
		public function set label(str:String):void
		{
			_tf.text = str;
			_tf.setTextFormat(_format);
			_tf.width = _tf.textWidth + 10;
			_tf.height = _tf.textHeight + 5;
			locate();
		}
		
		override public function get width():Number
		{
			return _icon.width + _textPadding + _tf.width;
		}
		
		override public function get height():Number
		{
			return _tf.height;
		}
		
		public function get value():Object
		{
			return _value;
		}
		
		public function set value(value:Object):void
		{
			_value = value;
		}

		public function get group():RadioButtonGroup
		{
			return _group;
		}

		public function set group(g:RadioButtonGroup):void
		{
			if(g == null)
			{
				throw Error("RadioButtonGroup should not be null");
				return;
			}
			
			_group = g;
			_group.addRadioButton(this);
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(v:Boolean):void
		{
			_selected = v;
			_selected ? _icon.gotoAndStop(4) : _icon.gotoAndStop(1);
		}
	}
}