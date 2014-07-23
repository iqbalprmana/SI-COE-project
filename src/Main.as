package 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import Screen.ScreenHome;
	import Screen.ScreenPP1;
	import Screen.ScreenPP2;
	import Screen.ScreenAbout1;
	import Screen.ScreenAbout2;
	import Screen.ScreenAbout3;
	import Screen.ScreenAbout4;
	import Screen.ScreenAbout5;
	import Screen.ScreenAbout6;
	import Screen.ScreenFuture;
	import Screen.ScreenTechDev;
	import Screen.ScreenOrg1;
	import Screen.ScreenOrg2;
	import Screen.ScreenOrg3;
	import Screen.ScreenOrg4;
	import Screen.ScreenOrgP;
	import Screen.ScreenSetting1;
	import Screen.ScreenSetting2;
	import Screen.ScreenSetting3;
	import Screen.ScreenAdmin;
	import Screen.ScreenManajemen1;
	import Screen.ScreenManajemen2;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import Asset.BtnDelete;
	import Asset.McBgShd;
	
	// Tween
	import com.greensock.*;
	import com.greensock.easing.*;
	
	/**
	 * ...
	 * @author vikachew
	 */
	public class Main extends Sprite 
	{
		private var _scrHome:ScreenHome;
		private var _scrPP1:ScreenPP1;
		private var _scrPP2:ScreenPP2;
		private var _scrAbout1:ScreenAbout1;
		private var _scrAbout2:ScreenAbout2;
		private var _scrAbout3:ScreenAbout3;
		private var _scrAbout4:ScreenAbout4;
		private var _scrAbout5:ScreenAbout5;
		private var _scrAbout6:ScreenAbout6;
		private var _scrFuture:ScreenFuture;
		private var _scrTechDev:ScreenTechDev;
		private var _scrOrg1:ScreenOrg1;
		private var _scrOrg2:ScreenOrg2;
		private var _scrOrg3:ScreenOrg3;
		private var _scrOrg4:ScreenOrg4;
		private var _scrOrgP:ScreenOrgP;
		private var _scrSet1:ScreenSetting1;
		private var _scrSet2:ScreenSetting2;
		private var _scrSet3:ScreenSetting3;
		private var _scrAdmin:ScreenAdmin;
		private var _scrManajemen1:ScreenManajemen1;
		private var _scrManajemen2:ScreenManajemen2;
		
		private var music:Sound; 
		private var soundChannel:SoundChannel;
		
		public var bahasa:Boolean; // indonesia: true
		//public var loggedIn:Boolean;
		
		public var mcBgShd:McBgShd;
		public var bgTimer:Timer;
		//public var whichBg:Sprite;
		public var whichBg:int;
		public var Bg1:String;
		public var Bg2:String;
		public var Bg3:String;
		public var Bg4:String;
		public var Bg5:String;
		public var Bg6:String;
		private var bgSource:String;
		private var myLoader:Loader;
		
		[Embed(source="../TitilliumWeb-Regular.ttf",
			fontName = "myFont",
			mimeType = "application/x-font",
			fontWeight="normal",
			fontStyle="normal", 
			// unicodeRange='U+0020-U+007E',			// for some reason this makes bullets won't appear. commenting it seems to fix the problem.
			advancedAntiAliasing="true",
			embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			//stage.scaleMode = StageScaleMode.SHOW_ALL;
		
			// Bgs
			Bg1 = "../Images/Bg/Bg1.png";
			Bg2 = "../Images/Bg/Bg2.png";
			Bg3 = "../Images/Bg/Bg3.png";
			Bg4 = "../Images/Bg/Bg4.png";
			Bg5 = "../Images/Bg/Bg5.png";
			Bg6 = "../Images/Bg/Bg6.png";
			
			whichBg = 1;
			bgTimer = new Timer(7000, 0);
			bgTimer.addEventListener("timer", changeBg);
			bgTimer.start();
			
			mcBgShd = new McBgShd;
			stage.addChild(mcBgShd);
			stage.setChildIndex(mcBgShd, 0);
			
			setBackground();
			
			// Home
			showSplash(new ScreenHome(this));
			
			// set language to english
			bahasa = false;
			
			// logged out
			//loggedIn = false;
			
			// play music
			music = new Sound(new URLRequest("easytech_mixed.mp3")); 
			soundChannel = new SoundChannel;
			soundChannel = music.play();
			soundChannel.addEventListener(Event.SOUND_COMPLETE, bgMusicHandler);
		}
		
		public function showSplash(_scene:MovieClip):void
		{
			removeAll();
			addChild(_scene);
		}
		
		public function bgMusicHandler(e:Event):void {
			e.currentTarget.removeEventListener(Event.SOUND_COMPLETE, bgMusicHandler);
			soundChannel = music.play();
			soundChannel.addEventListener(Event.SOUND_COMPLETE, bgMusicHandler);
		}
		
		public function lowerMusicVol():void {
			var lowSoundTransform:SoundTransform = new SoundTransform(0);
			soundChannel.soundTransform = lowSoundTransform;
		}
		
		public function resetMusicVol():void {
			var normalSoundTransform:SoundTransform = new SoundTransform(1);
			soundChannel.soundTransform = normalSoundTransform;
		}
		
		public function removeAll() :void
		{
			_scrHome = removeMovieClip(_scrHome);
			_scrPP1 = removeMovieClip(_scrPP1);
			_scrPP2 = removeMovieClip(_scrPP2);
			_scrAbout1 = removeMovieClip(_scrAbout1);
			_scrAbout2 = removeMovieClip(_scrAbout2);
			_scrAbout3 = removeMovieClip(_scrAbout3);
			_scrAbout4 = removeMovieClip(_scrAbout4);
			_scrAbout5 = removeMovieClip(_scrAbout5);
			_scrAbout6 = removeMovieClip(_scrAbout6);
			
			_scrFuture = removeMovieClip(_scrFuture);
			_scrTechDev = removeMovieClip(_scrTechDev);
			_scrOrg1 = removeMovieClip(_scrOrg1);
			_scrOrg2 = removeMovieClip(_scrOrg2);
			_scrOrg3 = removeMovieClip(_scrOrg3);
			_scrOrg4 = removeMovieClip(_scrOrg4);
			_scrOrgP = removeMovieClip(_scrOrgP);
			_scrSet1 = removeMovieClip(_scrSet1);
			_scrSet2 = removeMovieClip(_scrSet2);
			_scrSet3 = removeMovieClip(_scrSet3);
			_scrAdmin = removeMovieClip(_scrAdmin);
			_scrManajemen1 = removeMovieClip(_scrManajemen1);
			_scrManajemen2 = removeMovieClip(_scrManajemen2);
			
			for(var i:uint = 0; i < numChildren; i++ )
			{
				removeChildAt(i);
			}
			
		}
		
		public function removeMovieClip(mc:*):*
		{
			if (mc) {
				removeChild(mc);
				return mc = null;
			}
		}
		
		private function changeBg(e:TimerEvent) {
			if (whichBg != 6) {
				whichBg++; 
			}
			else {
				whichBg = 1; 
			}
			setBackground();
			
			var evt:Event = new Event("change");
			mcBgShd.dispatchEvent(evt);
		}
		
		private function setBackground():void {
			if (whichBg == "1") {
				bgSource = Bg1;
			}
			else if (whichBg == "2") {
				bgSource = Bg2;
			}
			else if (whichBg == "3") {
				bgSource = Bg3;
			}
			else if (whichBg == "4") {
				bgSource = Bg4;
			}
			else if (whichBg == "5") {
				bgSource = Bg5;
			}
			else if (whichBg == "6") {
				bgSource = Bg6;
			}
			
			myLoader = new Loader();
			var fileRequest:URLRequest = new URLRequest(bgSource);
			myLoader.load(fileRequest);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			
		}
		
		private function onImageLoaded(e:Event):void {
			mcBgShd.mcBg.alpha = 0;
			mcBgShd.mcBg.source = bgSource;
			TweenLite.to(mcBgShd.mcBg, 2.0, { alpha: 1 } );
			
			var tm:Timer = new Timer(2000, 1);
			tm.addEventListener("timer", changeBackgroundBack);
			tm.start();
		}
		
		private function changeBackgroundBack(e:TimerEvent):void {	
			mcBgShd.mcBgBack.source = myLoader;
		}
	}
	
}