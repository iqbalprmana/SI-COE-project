package Asset 
{
	import flash.events.Event;
	/**
	 * ...
	 * @author vikachew
	 */
	public class McLoading extends MC_LOADING
	{
		
		public function McLoading() 
		{
			addEventListener("next", locateFrame);
		}
		
		private function locateFrame(e:Event):void {
			if (currentFrame == 1) gotoAndStop(5);
			else if (currentFrame == 5) gotoAndStop(10);
			else if (currentFrame == 10) gotoAndStop(15);
			else if (currentFrame == 15) gotoAndStop(20);
			else if (currentFrame == 20) gotoAndStop(25);
			else if (currentFrame == 25) gotoAndStop(30);
			else if (currentFrame == 30) gotoAndStop(35);
			else if (currentFrame == 35) gotoAndStop(39);
			else if (currentFrame == 39) gotoAndStop(1);
		}
		
	}

}