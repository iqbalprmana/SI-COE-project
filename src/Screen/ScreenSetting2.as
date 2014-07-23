package Screen 
{
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author vikachew
	 */
	public class ScreenSetting2 extends SCREEN_SETTING2
	{
		private var mainClass:Main;
		public function ScreenSetting2(passedClass:Main) 
		{
			mainClass = passedClass;
			init();
		}
		
		public function init():void
		{
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenAdmin(mainClass));
										break;
			}
		}
	}

}