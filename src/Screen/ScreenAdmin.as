package Screen 
{
	import flash.events.MouseEvent;
	import flash.desktop.NativeApplication;
	// Tween
	import com.greensock.*;
	import com.greensock.easing.*;
	/**
	 * ...
	 * @author vikachew
	 */
	public class ScreenAdmin extends SCREEN_ADMIN
	{
		private var mainClass:Main;
		public function ScreenAdmin(passedClass:Main) 
		{
			mainClass = passedClass;
			init();
			inAnimation();
		}
		
		public function init():void
		{
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			btnBackup.addEventListener(MouseEvent.CLICK, navHandler);
			btnChangePass.addEventListener(MouseEvent.CLICK, navHandler);
			btnKonten.addEventListener(MouseEvent.CLICK, navHandler);
			btnStruktur.addEventListener(MouseEvent.CLICK, navHandler);
			btnExit.addEventListener(MouseEvent.CLICK, navHandler);
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenHome(mainClass));
										break;
				case "btnBackup" : mainClass.showSplash(new ScreenSetting2(mainClass));
										break;
				case "btnChangePass" : mainClass.showSplash(new ScreenSetting3(mainClass));
										break;
				case "btnKonten" : mainClass.showSplash(new ScreenManajemen1(mainClass));
										break;
				case "btnStruktur" : mainClass.showSplash(new ScreenMgOrganisasi1(mainClass));
										break;
				case "btnExit" : NativeApplication.nativeApplication.exit();
										break;
			}
		}
		
		private function inAnimation():void {
			btnBack.alpha = 0;
			btnKonten.alpha = 0;
			btnStruktur.alpha = 0;
			btnBackup.alpha = 0;
			btnChangePass.alpha = 0;
			btnExit.alpha = 0;
			
			btnBack.scaleX = 0.8;
			btnKonten.scaleX = 0.8;
			btnStruktur.scaleX = 0.8;
			btnBackup.scaleX = 0.8;
			btnChangePass.scaleX = 0.8;
			btnExit.scaleX = 0.8;
			
			btnBack.scaleY = 0.8;
			btnKonten.scaleY = 0.8;
			btnStruktur.scaleY = 0.8;
			btnBackup.scaleY = 0.8;
			btnChangePass.scaleY = 0.8;
			btnExit.scaleY = 0.8;
			
			btnKonten.x = btnKonten.x - 20;
			btnStruktur.x = btnStruktur.x - 20;
			btnBackup.x = btnBackup.x - 20;
			btnChangePass.x = btnChangePass.x - 20;
			btnExit.x = btnExit.x - 20;
			
			TweenLite.to(btnBack, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.5, ease:Circ.easeOut, onComplete: inAnim2()} );
		}
		
		private function inAnim2():void {
			TweenLite.to(btnKonten, 0.5, { alpha:1, scaleX:1, scaleY:1, x: btnKonten.x + 20, delay: 0.4, ease:Circ.easeOut, onComplete: inAnim21()} );
		}
		
		private function inAnim21():void {
			TweenLite.to(btnStruktur, 0.5, { alpha:1, scaleX:1, scaleY:1, x: btnStruktur.x + 20, delay: 0.4, ease:Circ.easeOut, onComplete: inAnim3()} );
		}
		
		private function inAnim3():void {
			TweenLite.to(btnBackup, 0.5, { alpha:1, scaleX:1, scaleY:1, x: btnBackup.x + 20, delay: 0.3, ease:Circ.easeOut, onComplete: inAnim4()} );
		}
		
		private function inAnim4():void {
			TweenLite.to(btnChangePass, 0.5, { alpha:1, scaleX:1, scaleY:1, x: btnChangePass.x + 20, delay: 0.2, ease:Circ.easeOut, onComplete: inAnim5() } );
		}
		
		private function inAnim5():void {
			TweenLite.to(btnExit, 0.5, { alpha:1, scaleX:1, scaleY:1, x: btnExit.x + 20, delay: 0.2, ease:Circ.easeOut } );
		}
	}

}