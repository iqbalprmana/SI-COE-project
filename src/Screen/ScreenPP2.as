package Screen 
{
	import Asset.BtnVidFullscreen;
	import Asset.BtnVidMute;
	import Asset.BtnVidPause;
	import Asset.BtnVidPlay;
	import Asset.BtnVidStop;
	import Asset.BtnVidUnmute;
	import Asset.BtnZoomClose;
	import Asset.BtnZoomIn;
	import Asset.BtnZoomOut;
	import Asset.McVidFillRed;
	import Asset.McVidScrubber;
	import fl.video.VideoPlayer;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.errors.SQLError;
	import flash.events.MouseEvent;
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.events.Event;
	
	import Asset.McPlayVideo;
	import Asset.McShade;
	import flash.events.NetStatusEvent;
	
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TransformGestureEvent;
	// Tween
	import com.greensock.*;
	import com.greensock.easing.*;
	/**
	 * ...
	 * @author vikachew
	 */
	public class ScreenPP2 extends SCREEN_PP2
	{
		private var mainClass:Main;
		private var selectedSemen:int;
		private var selectedPP:int;
		
		private var selectStmt:SQLStatement;	
		private var selectImages:SQLStatement;
		private var conn:SQLConnection;
		
		private var container:MovieClip;
		private var imageMC:MovieClip;
		private var imageMC2:MovieClip;
		private var imageMC3:MovieClip;
		private var imageMC4:MovieClip;
		private var imageMC5:MovieClip;
		private var imageMC6:MovieClip;
		private var previewImgAll:MovieClip;
		private var previewImg:MovieClip;
		private var previewImg2:MovieClip;
		private var previewImg3:MovieClip;
		private var previewImg4:MovieClip;
		private var previewImg5:MovieClip;
		private var previewImg6:MovieClip;
		private var mcShade:McShade;
		private var btnZoomIn:BtnZoomIn;
		private var btnZoomOut:BtnZoomOut;
		private var btnZoomClose:BtnZoomClose;
		private var zoomInc:Number;
		private var zoomInLimit:Number;
		private var zoomOutLimit:Number;
		private var moveX:Number;
		private var moveY:Number;
		private var minImgY:Number;
		private var maxImgY:Number;
		private var minImgX:Number;
		private var maxImgX:Number;
		
		private var maxY:Number;
		private var minY:Number;
		private var _startY:Number;
		private var _startMouseY:Number;
		private var _startX:Number;
		private var _startMouseX:Number;
		
		// video
		private var customClient:Object
		private var nc:NetConnection;
		private var ns:NetStream;
		private var vid:Video;
		//private var square2:MovieClip;
		private var btnVidPlay:BtnVidPlay;
		private var btnVidPause:BtnVidPause;
		private var btnVidStop:BtnVidStop;
		private var btnVidMute:BtnVidMute;
		private var btnVidUnmute:BtnVidUnmute;
		private var isMuted:Boolean;
		private var btnVidFullscreen:BtnVidFullscreen;
		private var isFullscreen:Boolean;
		private var soundTransform:SoundTransform;
		private var mcShadeVideo:McShade;
		private var mcVidVolumeFill:McVidFillRed;
		private var mcVidVolScrubber:McVidScrubber;
		private var bolVolumeScrub:Boolean; 		// is volume scruber pressed?
		private var intLastVolume:Number;			// last known volume
		private var widthVidVolume:Number;
		private var mcVidProgFill:McVidFillRed;
		private var mcVidProgScrubber:McVidScrubber;
		private var bolProgScrub:Boolean; 		
		private var widthVidProg:Number;
		private var lblTimeDuration:TextField;
		private var tmrVidDisplay:Timer;
		
		private var mcPlay:McPlayVideo;
		private var posYImage:Number;
		
		public function ScreenPP2(passedClass:Main, passedSemen:int, passedPP:int) 
		{
			mainClass = passedClass;
			selectedSemen = passedSemen;
			selectedPP = passedPP;
			inAnimation();
		}
		public function init():void
		{
			if (mainClass.bahasa) {
				mcPPRed.txtPPRed.text = "PERFORMA\nPROYEK";
			}
			else {
				mcPPRed.txtPPRed.text = "PROJECT\nPERFORMANCE";
			}
			
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			btnSemenGresik.addEventListener(MouseEvent.CLICK, semenHandler);
			btnSemenPadang.addEventListener(MouseEvent.CLICK, semenHandler);
			btnSemenThanglong.addEventListener(MouseEvent.CLICK, semenHandler);
			btnSemenTonasa.addEventListener(MouseEvent.CLICK, semenHandler);
			btnSemenInd.addEventListener(MouseEvent.CLICK, semenHandler);
		}
		
		private function navHandler(e:MouseEvent):void {
			if(getChildByName("vid") != null) ns.close();
			mainClass.showSplash(new ScreenPP1(mainClass, selectedSemen));
		}
		
		private function semenHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnSemenPadang" : selectedSemen = 2; 
										break;
				case "btnSemenGresik" : selectedSemen = 1;
										break;
				case "btnSemenTonasa" : selectedSemen = 3; 
										break;
				case "btnSemenThanglong" : selectedSemen = 4; 
										break;
				case "btnSemenInd" : selectedSemen = 5; 
										break;
			}
			if(getChildByName("vid") != null) ns.close();
			mainClass.showSplash(new ScreenPP1(mainClass, selectedSemen));
		}
		
		private function setTextColor():void {
			var formatSelected:TextFormat = new TextFormat(); 
			var formatNotSelected:TextFormat = new TextFormat(); 
			formatSelected.color = 0xC01F2D; 
			formatNotSelected.color = 0xD4D4D4; 
			
			if (selectedSemen == 1) {
				mcArrow.y = 288; 
				btnSemenPadang.txtSemenPadang.setTextFormat(formatNotSelected);
				btnSemenGresik.txtSemenGresik.setTextFormat(formatSelected);
				btnSemenTonasa.txtSemenTonasa.setTextFormat(formatNotSelected);
				btnSemenThanglong.txtSemenThanglong.setTextFormat(formatNotSelected);
				btnSemenInd.txtSemenTonasa.setTextFormat(formatNotSelected);
			}
			else if(selectedSemen == 2) {
				mcArrow.y = 329.6; 
				btnSemenPadang.txtSemenPadang.setTextFormat(formatSelected);
				btnSemenGresik.txtSemenGresik.setTextFormat(formatNotSelected);
				btnSemenTonasa.txtSemenTonasa.setTextFormat(formatNotSelected);
				btnSemenThanglong.txtSemenThanglong.setTextFormat(formatNotSelected);
				btnSemenInd.txtSemenTonasa.setTextFormat(formatNotSelected);
			}
			else if(selectedSemen == 3) {
				mcArrow.y = 365.6; 
				btnSemenPadang.txtSemenPadang.setTextFormat(formatNotSelected);
				btnSemenGresik.txtSemenGresik.setTextFormat(formatNotSelected);
				btnSemenTonasa.txtSemenTonasa.setTextFormat(formatSelected);
				btnSemenThanglong.txtSemenThanglong.setTextFormat(formatNotSelected);
				btnSemenInd.txtSemenTonasa.setTextFormat(formatNotSelected);
			}
			else if(selectedSemen == 4) {
				mcArrow.y = 405.6; 
				btnSemenPadang.txtSemenPadang.setTextFormat(formatNotSelected);
				btnSemenGresik.txtSemenGresik.setTextFormat(formatNotSelected);
				btnSemenTonasa.txtSemenTonasa.setTextFormat(formatNotSelected);
				btnSemenThanglong.txtSemenThanglong.setTextFormat(formatSelected);
				btnSemenInd.txtSemenTonasa.setTextFormat(formatNotSelected);
			}
			else if(selectedSemen == 5) {
				mcArrow.y = 250; 
				btnSemenPadang.txtSemenPadang.setTextFormat(formatNotSelected);
				btnSemenGresik.txtSemenGresik.setTextFormat(formatNotSelected);
				btnSemenTonasa.txtSemenTonasa.setTextFormat(formatNotSelected);
				btnSemenThanglong.txtSemenThanglong.setTextFormat(formatNotSelected);
				btnSemenInd.txtSemenTonasa.setTextFormat(formatSelected);
			}
		}
		
		private function loadDb():void {
			conn.addEventListener(SQLEvent.OPEN, openHandler);
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			
			//appicationDirectory is where our AIR app is (in bin)
			var folder:File = File.applicationDirectory;
			var dbFile:File = folder.resolvePath("dbase.db");
			
			conn.open(dbFile); //synchronous
		}
		
		private function openHandler(event:SQLEvent):void {
			getData();
		}
		
		private function errorHandler(event:SQLErrorEvent):void {
			
		}
		
		private function getData():void {
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = conn;
			var sql:String = "select * from projectperformance where idpp = " + selectedPP;
			selectStmt.text = sql;
			
			selectStmt.addEventListener(SQLEvent.RESULT, getDataSuccess);
			selectStmt.addEventListener(SQLErrorEvent.ERROR, getDataError);
			
			selectStmt.execute();
		}
		
		private function getDataSuccess(event:SQLEvent):void {
			var result:SQLResult = selectStmt.getResult();
			var row:Object = result.data[0]; 
			
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			format.size = 16;
			format.leading = -7;
			
			// Judul
			var txtJudul:TextField = new TextField();
			txtJudul.text = row.judul;
			format.size = 48;
			format.leading = -20;
			txtJudul.setTextFormat(format); 
			txtJudul.embedFonts = true;
			txtJudul.width = 500;
			txtJudul.autoSize = "left";
			txtJudul.multiline = true;
			txtJudul.wordWrap = true;
			txtJudul.selectable = false;
			txtJudul.x = 90;
			txtJudul.y = 100;
			
			// Artikel/ Outline
			format.size = 21;
			var txtLabelArt:TextField = new TextField();
			txtLabelArt.text = "OUTLINE"
			format.color = 0xD4D4D4; 
			txtLabelArt.setTextFormat(format); 
			txtLabelArt.embedFonts = true;
			txtLabelArt.width = 300;
			txtLabelArt.selectable = false;
			
			var txtArt:TextField = new TextField();
			if (mainClass.bahasa) txtArt.text = row.artikelId;
			else {
				if (row.artikelEn == null || row.artikelEn == "" || row.artikelEn == "null") txtArt.text = row.artikelId;
				else txtArt.text = row.artikelEn;
			}
			format.size = 16;
			format.leading = 0;
			format.align = "left";
			format.color = 0xFFFFFF; 
			txtArt.setTextFormat(format); 
			txtArt.embedFonts = true;
			
			txtArt.width = 400;
			txtArt.autoSize = "left";
			txtArt.multiline = true;
			txtArt.wordWrap = true;
			txtArt.selectable = false;
			
			// OUTCOME
			format.size = 21;
			var txtLabelOut:TextField = new TextField();
			txtLabelOut.text = "OUTCOME"
			format.color = 0xD4D4D4; 
			format.indent = 0;
			txtLabelOut.setTextFormat(format); 
			txtLabelOut.embedFonts = true;
			txtLabelOut.width = 300;
			txtLabelOut.selectable = false;
			
			var txtOut:TextField = new TextField();
			if (mainClass.bahasa) txtOut.text = row.sumId;
			else {
				if (row.sumEn == null || row.sumEn == "" || row.sumEn == "null") txtOut.text = row.sumId;
				else  txtOut.text = row.sumEn;
			}
			format.color = 0xFFFFFF; 
			format.align = "left";
			format.size = 16;
			txtOut.setTextFormat(format); 
			txtOut.embedFonts = true;
			txtOut.autoSize = "left";
			txtOut.width = 400;
			txtOut.multiline = true;
			txtOut.wordWrap = true;
			txtOut.selectable = false;
			
			container = new MovieClip();
			container.scrollRect = new Rectangle(0, 0, 500, 700 + txtArt.height + txtOut.height);
			
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xff0000, 0.0); 
			square.graphics.drawRect(0, 0, 500, 700 + txtArt.height + txtOut.height); 
			square.graphics.endFill(); 

			container.addChild(square);
			
			// mask
			var squaremask:Shape = new Shape(); 
			squaremask.graphics.lineStyle(1, 0x000000, 0.0); 
			squaremask.graphics.beginFill(0xff0000, 0.1); 
			squaremask.graphics.drawRect(600, 420, 500, 720 - (txtJudul.y + txtJudul.height + 20)); 
			squaremask.graphics.endFill(); 
			
			container.mask = squaremask;
			
			container.x = 600;
			container.y = 420;
			
			// LOCATION, AREA, PERIOD, SCOPE
			var txtHeaderLok:TextField = new TextField();
			var txtHeaderArea:TextField = new TextField();
			var txtHeaderPer:TextField = new TextField();
			var txtHeaderScope:TextField = new TextField();
			format.color = 0xD4D4D4; 
			format.size = 18;
			format.leading = -7;
			format.indent = 0;
			if (mainClass.bahasa) {
				txtHeaderLok.text = "LOKASI";
				txtHeaderArea.text = "AREA";
				txtHeaderPer.text = "PERIODE";
				txtHeaderScope.text = "SCOPE";
			}
			else {
				txtHeaderLok.text = "LOCATION";
				txtHeaderArea.text = "AREA";
				txtHeaderPer.text = "PERIOD";
				txtHeaderScope.text = "SCOPE";
			}
			
			txtHeaderArea.setTextFormat(format); 
			txtHeaderLok.setTextFormat(format); 
			txtHeaderScope.setTextFormat(format); 
			txtHeaderPer.setTextFormat(format); 
			txtHeaderArea.embedFonts = true;
			txtHeaderLok.embedFonts = true;
			txtHeaderPer.embedFonts = true;
			txtHeaderScope.embedFonts = true;
			txtHeaderLok.selectable = false;
			txtHeaderArea.selectable = false;
			txtHeaderPer.selectable = false;
			txtHeaderScope.selectable = false;
			
			// LOCATION, AREA, PERIOD, SCOPE (isi)
			var txtLok:TextField = new TextField();
			var txtArea:TextField = new TextField();
			var txtPer:TextField = new TextField();
			var txtScope:TextField = new TextField();
			format.color = 0xFFFFFF; 
			txtArea.text = row.area;
			txtLok.text = row.lokasi;
			txtPer.text = row.period;
			txtScope.text = row.scopeOfWork;
			txtArea.setTextFormat(format); 
			txtPer.setTextFormat(format); 
			txtScope.setTextFormat(format); 
			txtLok.setTextFormat(format); 
			txtArea.embedFonts = true;
			txtLok.embedFonts = true;
			txtPer.embedFonts = true;
			txtScope.embedFonts = true;
			
			txtLok.autoSize = "left";
			txtScope.autoSize = "left";
			txtPer.autoSize = "left";
			txtArea.autoSize = "left";
			txtLok.width = 300;
			txtScope.width = 300;
			txtPer.width = 300;
			txtArea.width = 300;
			txtScope.multiline = true;
			txtArea.multiline = true;
			txtScope.wordWrap = true;
			txtArea.wordWrap = true;
			txtLok.selectable = false;
			txtScope.selectable = false;
			txtPer.selectable = false;
			txtArea.selectable = false;
			
			txtHeaderLok.y = txtJudul.y + txtJudul.height + 20;
			txtHeaderLok.x = 90;
			txtLok.y = txtHeaderLok.y;
			txtLok.x = 190;
			
			txtHeaderArea.y = txtHeaderLok.y + 30;
			txtHeaderArea.x = txtHeaderLok.x;
			txtArea.y = txtHeaderArea.y;
			txtArea.x = txtLok.x;
			
			txtHeaderPer.y = txtArea.y + txtArea.height + 5;
			txtHeaderPer.x = txtHeaderLok.x;
			txtPer.y = txtHeaderPer.y;
			txtPer.x = txtLok.x;
			
			txtHeaderScope.y = txtHeaderPer.y + 30;
			txtHeaderScope.x = txtHeaderLok.x;
			txtScope.y = txtHeaderScope.y;
			txtScope.x = txtLok.x;
			
			posYImage = txtScope.y + txtScope.height + 30;
			
			// Gambar
			selectImages = new SQLStatement();
			selectImages.sqlConnection = conn;
			var sql:String = "select * from ppimages where idpp = " + selectedPP;
			selectImages.text = sql;
			
			selectImages.addEventListener(SQLEvent.RESULT, getImgSuccess);
			selectImages.execute();
			
			// Artikel
			txtLabelArt.y = 0;
			txtArt.y = txtLabelArt.y + 40;
			txtLabelOut.y = txtArt.y + txtArt.height + 50;
			txtOut.y = txtLabelOut.y + 40;
			
			// Video
			// play video
			if (row.pathVid != null && row.pathVid.toString() != "" && row.pathVid.toString() != "null") {
				// create timer for updating all visual parts of player and add
				// event listener
				tmrVidDisplay = new Timer(10);
				tmrVidDisplay.addEventListener(TimerEvent.TIMER, updateVidDisplay);
	
				customClient = new Object(); 
				customClient.onMetaData = metaDataHandler;
				
				nc = new NetConnection(); 
				nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				nc.connect(null); 
				
				ns = new NetStream(nc); 
				ns.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				ns.client = customClient;
				
				ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler); 
				ns.play(row.pathVid); 
				
				vid = new Video(); 
				vid.name = "vid";
				vid.attachNetStream(ns); 
				
				vid.x = 600;
				vid.y = 100;
				vid.width = 360; 
				vid.height = 240; 
				widthVidVolume = 100;
				widthVidProg = 600;
				
				// stop video
				ns.pause();
				ns.seek(0);
				
				// Play
				mcPlay = new McPlayVideo;
				mcPlay.y = 100;
				mcPlay.x = 600;
				mcPlay.width = 360;
				mcPlay.height = 240;
				mcPlay.addEventListener(MouseEvent.CLICK, toggleVidPlay);
				
				// Other controls
				btnVidPlay = new BtnVidPlay();
				btnVidPlay.x = mcPlay.x + 40;
				btnVidPlay.y = mcPlay.y + 245;
				btnVidPlay.addEventListener(MouseEvent.CLICK, playVideo);
				
				btnVidPause = new BtnVidPause();
				btnVidPause.x = btnVidPlay.x + btnVidPlay.width + 5;
				btnVidPause.y = btnVidPlay.y;
				btnVidPause.addEventListener(MouseEvent.CLICK, pauseVideo);
				
				btnVidStop = new BtnVidStop();
				btnVidStop.x = btnVidPause.x + btnVidPause.width + 5;
				btnVidStop.y = btnVidPlay.y;
				btnVidStop.addEventListener(MouseEvent.CLICK, stopVideo);
				
				mcVidProgFill = new McVidFillRed();
				mcVidProgFill.mcFillRed.width = widthVidProg;
				mcVidProgFill.width = widthVidProg;
				mcVidProgFill.visible = false;
				
				mcVidProgScrubber = new McVidScrubber();
				mcVidProgScrubber.btnVolumeScrubber.addEventListener(MouseEvent.MOUSE_DOWN, progressScrubberClicked);
				mcVidProgScrubber.btnVolumeScrubber.addEventListener(MouseEvent.MOUSE_UP, progressScrubberReleased);
				mcVidProgScrubber.visible = false;
				
				var formatLabelTime:TextFormat = new TextFormat(); 
				formatLabelTime.size = 16; 	
				lblTimeDuration = new TextField();
				lblTimeDuration.text = "";
				lblTimeDuration.setTextFormat(formatLabelTime);
				lblTimeDuration.visible = false;
				lblTimeDuration.selectable = false;
				
				btnVidMute = new BtnVidMute();
				btnVidMute.x = btnVidStop.x + btnVidStop.width + 5;
				btnVidMute.y = btnVidPlay.y;
				btnVidMute.addEventListener(MouseEvent.CLICK, muteVideo);
				
				btnVidUnmute = new BtnVidUnmute();
				btnVidUnmute.x = btnVidMute.x;
				btnVidUnmute.y = btnVidPlay.y;
				btnVidUnmute.addEventListener(MouseEvent.CLICK, unmuteVideo);
				btnVidUnmute.visible = false;
				isMuted = false;
				
				mcVidVolumeFill = new McVidFillRed();
				mcVidVolumeFill.mcFillRed.width = widthVidVolume;
				mcVidVolumeFill.visible = false;
				
				mcVidVolScrubber = new McVidScrubber();
				mcVidVolScrubber.btnVolumeScrubber.addEventListener(MouseEvent.MOUSE_DOWN, volumeScrubberClicked);
				mcVidVolScrubber.btnVolumeScrubber.addEventListener(MouseEvent.MOUSE_UP, volumeScrubberReleased);
				mcVidVolScrubber.visible = false;
				
				btnVidFullscreen = new BtnVidFullscreen();
				//btnVidFullscreen.x = mcVidVolumeFill.x + mcVidVolumeFill.width + 30;
				btnVidFullscreen.x = btnVidMute.x + btnVidMute.width + 5;
				btnVidFullscreen.y = btnVidPlay.y;
				btnVidFullscreen.addEventListener(MouseEvent.CLICK, toggleVidFullscreen);
				isFullscreen = false;
				
				soundTransform = new SoundTransform();
				soundTransform.volume = 1;
				ns.soundTransform = soundTransform;
				
				mcShadeVideo = new McShade();
				mcShadeVideo.visible = false;
			}
			
			// addchild ke movieclip
			addChild(txtJudul);
			addChild(txtHeaderArea);
			addChild(txtHeaderLok);
			addChild(txtHeaderPer);
			addChild(txtHeaderScope);
			addChild(txtArea);
			addChild(txtLok);
			addChild(txtPer);
			addChild(txtScope);
			//addChild(imageMC);
			container.addChild(txtLabelArt);
			container.addChild(txtArt);
			container.addChild(txtLabelOut);
			container.addChild(txtOut);
			
			container.alpha = 0;
			addChild(container);
			container.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
			maxY = 420;
			minY = Math.min(0, 720 - container.height);
			
			if (row.pathVid != null && row.pathVid.toString() != "" && row.pathVid.toString() != "null") {
				addChild(mcShadeVideo);
				addChild(vid);
				//addChild(square2);
				addChild(mcPlay);
				addChild(btnVidPlay);
				addChild(btnVidPause);
				addChild(btnVidStop);
				addChild(mcVidProgFill);
				addChild(mcVidProgScrubber);
				addChild(lblTimeDuration);
				addChild(btnVidMute);
				addChild(btnVidUnmute);
				addChild(mcVidVolumeFill);
				addChild(mcVidVolScrubber);
				addChild(btnVidFullscreen);
			}
			
			containerAnimation();
			if (contains(mcShade)) setChildIndex(mcShade, numChildren - 1);
			if (contains(previewImgAll)) setChildIndex(previewImgAll, numChildren - 1);
			if (contains(btnZoomIn)) setChildIndex(btnZoomIn, numChildren - 1);
			if (contains(btnZoomOut)) setChildIndex(btnZoomOut, numChildren - 1);
			if (contains(btnZoomClose)) setChildIndex(btnZoomClose, numChildren - 1);
		}
		
		private function getImgSuccess(event:SQLEvent):void {
			var result:SQLResult = selectImages.getResult();
			var numResult:int;
			if (result.data != null) {
				numResult = result.data.length;
			}
			
			imageMC = new MovieClip();
			imageMC2 = new MovieClip();
			imageMC3 = new MovieClip();
			imageMC4 = new MovieClip();
			imageMC5 = new MovieClip();
			imageMC6 = new MovieClip();
			previewImg = new MovieClip();
			previewImg2 = new MovieClip();
			previewImg3 = new MovieClip();
			previewImg4 = new MovieClip();
			previewImg5 = new MovieClip();
			previewImg6 = new MovieClip();
			previewImgAll = new MovieClip();
			imageMC.name = "imageMC";
			imageMC2.name = "imageMC2";
			imageMC3.name = "imageMC3";
			imageMC4.name = "imageMC4";
			imageMC5.name = "imageMC5";
			imageMC6.name = "imageMC6";
			
			var myLoader:Loader = new Loader();
			var myLoader2:Loader = new Loader();
			var myLoader3:Loader = new Loader();
			var myLoader4:Loader = new Loader();
			var myLoader5:Loader = new Loader();
			var myLoader6:Loader = new Loader();
			var myPrevLoader:Loader = new Loader();
			var myPrevLoader2:Loader = new Loader();
			var myPrevLoader3:Loader = new Loader();
			var myPrevLoader4:Loader = new Loader();
			var myPrevLoader5:Loader = new Loader();
			var myPrevLoader6:Loader = new Loader();
			var fileRequest:URLRequest;
			
			// 1
			if (numResult >= 1) {
				fileRequest = new URLRequest(result.data[0].pathImg);
				myLoader.load(fileRequest);
				myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				imageMC.addChild(myLoader);
				imageMC.y = posYImage;
				imageMC.x = 89.95;
				imageMC.addEventListener(MouseEvent.CLICK, showImgMC);
				
				myPrevLoader.load(fileRequest);
				myPrevLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPrevLoaded);
				previewImg.addChild(myPrevLoader);
				previewImg.visible = false;
				
				addChild(imageMC);
				previewImgAll.addChild(previewImg);
			}
			/*
			else {
				fileRequest = new URLRequest("Images/default-pp.jpg");
				myLoader.load(fileRequest);
				myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				imageMC.addChild(myLoader);
				imageMC.y = 456.8;
				imageMC.x = 89.95;
				
				addChild(imageMC);
			}
			*/
			
			// 2
			if (numResult >= 2) {
				fileRequest = new URLRequest(result.data[1].pathImg);
				myLoader2.load(fileRequest);
				myLoader2.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				imageMC2.addChild(myLoader2);
				imageMC2.y = posYImage;
				imageMC2.x = 219.95;
				imageMC2.addEventListener(MouseEvent.CLICK, showImgMC);
				
				myPrevLoader2.load(fileRequest);
				myPrevLoader2.contentLoaderInfo.addEventListener(Event.COMPLETE, onPrevLoaded);
				previewImg2.addChild(myPrevLoader2);
				previewImg2.visible = false;
				
				addChild(imageMC2);
				previewImgAll.addChild(previewImg2);
			}
			
			// 3
			if (numResult >= 3) {
				fileRequest = new URLRequest(result.data[2].pathImg);
				myLoader3.load(fileRequest);
				myLoader3.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				imageMC3.addChild(myLoader3);
				imageMC3.y = posYImage;
				imageMC3.x = 350;
				imageMC3.addEventListener(MouseEvent.CLICK, showImgMC);
				
				myPrevLoader3.load(fileRequest);
				myPrevLoader3.contentLoaderInfo.addEventListener(Event.COMPLETE, onPrevLoaded);
				previewImg3.addChild(myPrevLoader3);
				previewImg3.visible = false;
				
				addChild(imageMC3);
				previewImgAll.addChild(previewImg3);
			}
			
			// 4
			if (numResult >= 4) {
				fileRequest = new URLRequest(result.data[3].pathImg);
				myLoader4.load(fileRequest);
				myLoader4.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				imageMC4.addChild(myLoader4);
				imageMC4.y = posYImage + 97;
				imageMC4.x = 89.95;
				imageMC4.addEventListener(MouseEvent.CLICK, showImgMC);
				
				myPrevLoader4.load(fileRequest);
				myPrevLoader4.contentLoaderInfo.addEventListener(Event.COMPLETE, onPrevLoaded);
				previewImg4.addChild(myPrevLoader4);
				previewImg4.visible = false;
				
				addChild(imageMC4);
				previewImgAll.addChild(previewImg4);
			}
			
			// 5
			if (numResult >= 5) {
				fileRequest = new URLRequest(result.data[4].pathImg);
				myLoader5.load(fileRequest);
				myLoader5.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				imageMC5.addChild(myLoader5);
				imageMC5.y = posYImage + 97;
				imageMC5.x = 219.95;
				imageMC5.addEventListener(MouseEvent.CLICK, showImgMC);
				
				myPrevLoader5.load(fileRequest);
				myPrevLoader5.contentLoaderInfo.addEventListener(Event.COMPLETE, onPrevLoaded);
				previewImg5.addChild(myPrevLoader5);
				previewImg5.visible = false;
				
				addChild(imageMC5);
				previewImgAll.addChild(previewImg5);
			}
			
			// 6
			if (numResult >= 6) {
				fileRequest = new URLRequest(result.data[5].pathImg);
				myLoader6.load(fileRequest);
				myLoader6.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				imageMC6.addChild(myLoader6);
				imageMC6.y = posYImage + 97;
				imageMC6.x = 350;
				imageMC6.addEventListener(MouseEvent.CLICK, showImgMC);
				
				myPrevLoader6.load(fileRequest);
				myPrevLoader6.contentLoaderInfo.addEventListener(Event.COMPLETE, onPrevLoaded);
				previewImg6.addChild(myPrevLoader6);
				previewImg6.visible = false;
				
				addChild(imageMC6);
				previewImgAll.addChild(previewImg6);
			}
			previewImgAll.y = 115;
			previewImgAll.x = 230;
			
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			previewImgAll.addEventListener(TransformGestureEvent.GESTURE_ZOOM , zoomPreviewImg); 
			previewImgAll.addEventListener(MouseEvent.MOUSE_DOWN, movePreviewImg);			
			addChild(previewImgAll);
			
			// Zoom in, zoom out, Pan
			zoomInc = 0.02;			// kecepatan scale
			zoomInLimit = 3;		// maksimal zoom in 300%
			zoomOutLimit = 0.8		// minimal zoom out 80%
			moveX = 8;				// kecepatan move bidang X, perhatikan zoomInc juga
			moveY = 5;				// idem
			
			btnZoomIn = new BtnZoomIn();
			btnZoomIn.x = 1190;
			btnZoomIn.y = 220;
			btnZoomIn.addEventListener(MouseEvent.MOUSE_DOWN, onBtnZoomInDown);
			btnZoomIn.addEventListener(MouseEvent.MOUSE_UP, onBtnZoomInUp);
			
			btnZoomOut = new BtnZoomOut();
			btnZoomOut.x = btnZoomIn.x;
			btnZoomOut.y = btnZoomIn.y + btnZoomIn.height + 10;
			btnZoomOut.addEventListener(MouseEvent.MOUSE_DOWN, onBtnZoomOutDown);
			btnZoomOut.addEventListener(MouseEvent.MOUSE_UP, onBtnZoomOutUp);
			
			btnZoomClose = new BtnZoomClose();
			btnZoomClose.x = btnZoomIn.x;
			btnZoomClose.y = 10;
			btnZoomClose.addEventListener(MouseEvent.CLICK, onBtnZoomClose);
			
			btnZoomIn.visible = false;
			btnZoomOut.visible = false;
			btnZoomClose.visible = false;
			addChild(btnZoomIn);
			addChild(btnZoomOut);
			addChild(btnZoomClose);
			
			mcShade = new McShade();
			mcShade.visible = false;
			addChild(mcShade);
		}
		
		private function showImgMC(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "imageMC" : previewImg.visible = true; 
										break;
				case "imageMC2" : previewImg2.visible = true;
										break;
				case "imageMC3" : previewImg3.visible = true;
										break;
				case "imageMC4" : previewImg4.visible = true;
										break;
				case "imageMC5" : previewImg5.visible = true;
										break;
				case "imageMC6" : previewImg6.visible = true;
										break;
			}
			btnZoomIn.visible = true;
			btnZoomOut.visible = true;
			btnZoomClose.visible = true;
			
			mcShade.visible = true;
		}
		
		private function closeImgMC(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "previewImg" : previewImg.visible = false;
										break;
				case "previewImg2" : previewImg2.visible = false;
										break;
				case "previewImg3" : previewImg3.visible = false;
										break;
				case "previewImg4" : previewImg4.visible = false;
										break;
				case "previewImg5" : previewImg5.visible = false;
										break;
				case "previewImg6" : previewImg6.visible = false;
										break;
			}
			mcShade.visible = false;
		}
		
		private function onBtnZoomInDown(e:MouseEvent):void {
			// zoom in
			addEventListener(Event.ENTER_FRAME, zoomIn);
		}
		
		private function zoomIn(e:Event):void {
			var prevScaleX:Number;
			var prevScaleY:Number;
			
			prevScaleX = previewImgAll.scaleX;
			prevScaleY = previewImgAll.scaleY;
			
			if (previewImgAll.scaleX < zoomInLimit) {
				previewImgAll.scaleX += zoomInc;
				previewImgAll.scaleY += zoomInc;
				previewImgAll.x -= moveX;
				previewImgAll.y -= moveY;
				minImgY = stage.stageHeight - previewImgAll.height;
				maxImgY = previewImgAll.height;
				minImgX = stage.stageWidth - previewImgAll.width;
				maxImgX = previewImgAll.width;
			}
			else {
				previewImgAll.scaleX = prevScaleX;
				previewImgAll.scaleY = prevScaleY;
			}
		}
		
		private function onBtnZoomInUp(e:MouseEvent):void {
			// zoom in stop
			removeEventListener(Event.ENTER_FRAME, zoomIn);
			trace("previewImgAll.height = " + previewImgAll.height + "\n" +
				  "stage.stageHeight = " + stage.stageHeight + "\n" +
				  "minImgY = " + minImgY + "\n" +
				  "maxImgY = " + maxImgY);
		}
		
		private function onBtnZoomOutDown(e:MouseEvent):void {
			// zoom Out
			addEventListener(Event.ENTER_FRAME, zoomOut);
		}
		
		private function zoomOut(e:Event):void {
			var prevScaleX:Number;
			var prevScaleY:Number;
			
			prevScaleX = previewImgAll.scaleX;
			prevScaleY = previewImgAll.scaleY;
			
			if (previewImgAll.scaleX > zoomOutLimit) {
				previewImgAll.scaleX -= zoomInc;
				previewImgAll.scaleY -= zoomInc;
				previewImgAll.x += moveX;
				previewImgAll.y += moveY;
			}
			else {
				previewImgAll.scaleX = prevScaleX;
				previewImgAll.scaleY = prevScaleY;
			}
		}
		
		private function onBtnZoomOutUp(e:MouseEvent):void {
			// zoom OUt stop
			removeEventListener(Event.ENTER_FRAME, zoomOut);
		}
		
		private function zoomPreviewImg(e:TransformGestureEvent):void {
			var prevScaleX:Number = previewImgAll.scaleX;
			var prevScaleY:Number = previewImgAll.scaleY;
						
			if(e.scaleX > 1){
				if(previewImgAll.scaleX > zoomInLimit){
					previewImgAll.scaleX=prevScaleX;
					previewImgAll.scaleY=prevScaleY;
				}
				else{
					previewImgAll.x -= moveX;
					previewImgAll.y -= moveY;
					previewImgAll.scaleX += zoomInc;
					previewImgAll.scaleY += zoomInc;
					minImgY = stage.stageHeight - previewImgAll.height;
					maxImgY = previewImgAll.height;
					minImgX = stage.stageWidth - previewImgAll.width;
					maxImgX = previewImgAll.width;
				}
			}

			if(e.scaleX < 1){		
				if(previewImgAll.scaleX < zoomOutLimit){
					previewImgAll.scaleX=prevScaleX;
					previewImgAll.scaleY=prevScaleY;
				}
				else{
					previewImgAll.x += moveX;
					previewImgAll.y += moveY;
					previewImgAll.scaleX -= zoomInc;
					previewImgAll.scaleY -= zoomInc;
				}
			} 
		}
		
		private function onBtnZoomClose(e:MouseEvent):void {
			if (previewImg.visible) previewImg.visible = false;
			else if (previewImg2.visible) previewImg2.visible = false;
			else if (previewImg3.visible) previewImg3.visible = false;
			else if (previewImg4.visible) previewImg4.visible = false;
			else if (previewImg5.visible) previewImg5.visible = false;
			else if (previewImg6.visible) previewImg6.visible = false;
			
			btnZoomIn.visible = false;
			btnZoomOut.visible = false;
			btnZoomClose.visible = false;
			mcShade.visible = false;
			previewImgAll.scaleX = 1;
			previewImgAll.scaleY = 1;
			previewImgAll.y = 115;
			previewImgAll.x = 230;
		}
		
		private function movePreviewImg(e:MouseEvent):void {
			_startY = previewImgAll.y;
			_startMouseY = mouseY;
			_startX = previewImgAll.x;
			_startMouseX = mouseX;
			previewImgAll.addEventListener(MouseEvent.MOUSE_MOVE, prevImgAll_mouseMoveHandler);
			addEventListener(MouseEvent.MOUSE_UP, stage_img_mouseUpHandler);
		}

		private function prevImgAll_mouseMoveHandler(event:MouseEvent):void
		{
			var offsetY:Number = mouseY - _startMouseY;
			var offsetX:Number = mouseX - _startMouseX;
			var newY:Number = Math.max(Math.min(maxImgY, _startY + offsetY), minImgY);
			var newX:Number = Math.max(Math.min(maxImgX, _startX + offsetX), minImgX);
			if ((newY > stage.stageHeight - previewImgAll.height && newY <= 0) ||
				(previewImgAll.y + previewImgAll.height > stage.stageHeight && offsetY < 0) ||
				(previewImgAll.y + previewImgAll.height < stage.stageHeight && previewImgAll.y < 0 && offsetY > 0)) {
					previewImgAll.y = newY;
				}
			if ((newX > stage.stageWidth - previewImgAll.width && newX <= 0) ||
				(previewImgAll.x + previewImgAll.width > stage.stageWidth && offsetX < 0) ||
				(previewImgAll.x + previewImgAll.width < stage.stageWidth && previewImgAll.x < 0 && offsetX > 0)) {
					previewImgAll.x = newX;
				}
		}

		private function stage_img_mouseUpHandler(event:MouseEvent):void
		{
			trace("stage.stageHeight - previewImgAll.height = " + (stage.stageHeight - previewImgAll.height));
			trace("previewImgAll.y = " + previewImgAll.y);
			previewImgAll.removeEventListener(MouseEvent.MOUSE_MOVE, prevImgAll_mouseMoveHandler);
			removeEventListener(MouseEvent.MOUSE_UP, stage_img_mouseUpHandler);
		}
		
		private function onPrevLoaded(e:Event):void {			
			var targetLoader:Loader = Loader(e.target.loader);
			targetLoader.width = 800;
			targetLoader.height = 480;
		}
		
		private function toggleVidPlay(e:MouseEvent):void {
			if (mcPlay.alpha == 0) { // pause
				ns.pause();
				mcPlay.alpha = 1;
			}
			else {
				ns.resume();
				mcPlay.alpha = 0;
			}
		}
		
		private function playVideo(e:MouseEvent):void {
			//ns.togglePause();
			ns.resume();
			mcPlay.alpha = 0;
			mainClass.lowerMusicVol();
		}
		
		private function pauseVideo(e:MouseEvent):void {
			ns.pause();
			mcPlay.alpha = 1;
			mainClass.resetMusicVol();
		}
		
		private function stopVideo(e:MouseEvent):void {
			ns.pause(); 
			ns.seek(0);
			mcPlay.alpha = 1;
			mainClass.resetMusicVol();
		}
		
		private function muteVideo(e:MouseEvent):void {
			btnVidMute.visible = false;
			btnVidUnmute.visible = true;
			var muteSoundTransform:SoundTransform = new SoundTransform(0);
			ns.soundTransform = muteSoundTransform;
			isMuted = true;
		}
		
		private function unmuteVideo(e:MouseEvent):void {
			btnVidMute.visible = true;
			btnVidUnmute.visible = false;
			ns.soundTransform = soundTransform;
			isMuted = false;
		}
		
		private function volumeScrubberClicked(e:MouseEvent):void {
			bolVolumeScrub = true;
			
			// start drag
			mcVidVolScrubber.startDrag(false, new Rectangle(mcVidVolumeFill.x, mcVidVolumeFill.y - 10, widthVidVolume, 0));
		}

		private function volumeScrubberReleased(e:MouseEvent):void {
			bolVolumeScrub = false;
			mcVidVolScrubber.stopDrag();
			
			mcVidVolumeFill.mcFillRed.width	= mcVidVolScrubber.x - mcVidVolumeFill.x;
			
			soundTransform.volume = mcVidVolumeFill.mcFillRed.width / widthVidVolume;
			
			if(!isMuted){
				ns.soundTransform = soundTransform;
			}
		}
		
		private function progressScrubberClicked(e:MouseEvent):void {
			bolProgScrub = true;
			
			// start drag
			mcVidProgScrubber.startDrag(false, new Rectangle(mcVidProgFill.x, mcVidProgFill.y - 10, widthVidProg, 0));
		}

		private function progressScrubberReleased(e:MouseEvent):void {
			bolProgScrub = false;
			mcVidProgScrubber.stopDrag();
			
			mcVidProgFill.mcFillRed.width	= mcVidProgScrubber.x - mcVidProgFill.x;
		}
		
		private function toggleVidFullscreen(e:MouseEvent):void {
			if (isFullscreen) {
				mcShadeVideo.visible = false;
				isFullscreen = false;
				mcVidVolScrubber.visible = false;
				mcVidVolumeFill.visible = false;
				mcVidProgScrubber.visible = false;
				mcVidProgFill.visible = false;
				lblTimeDuration.visible = false;
				
				vid.x = 600;
				vid.y = 100;
				vid.width = 360; 
				vid.height = 240; 
				
				mcPlay.y = vid.y;
				mcPlay.x = vid.x;
				mcPlay.width = vid.width;
				mcPlay.height = vid.height;
				
				btnVidPlay.x = mcPlay.x + 40;
				btnVidPlay.y = mcPlay.y + 245;
				
				btnVidPause.x = btnVidPlay.x + btnVidPlay.width + 5;
				btnVidPause.y = btnVidPlay.y;
				
				btnVidStop.x = btnVidPause.x + 
				btnVidPause.width + 5;
				btnVidStop.y = btnVidPlay.y;
				
				btnVidMute.x = btnVidStop.x + btnVidStop.width + 5;
				btnVidMute.y = btnVidPlay.y;
				
				btnVidUnmute.x = btnVidMute.x;
				btnVidUnmute.y = btnVidPlay.y;
				
				if (isMuted) {
					btnVidUnmute.visible = true;
					btnVidMute.visible = false;
				}
				else {
					btnVidUnmute.visible = false;
					btnVidMute.visible = true;
				}
				
				btnVidFullscreen.x = btnVidMute.x + btnVidMute.width + 5;
				btnVidFullscreen.y = btnVidPlay.y;
			}
			else {
				mcShadeVideo.visible = true;
				isFullscreen = true;
				mcVidVolScrubber.visible = true;
				mcVidVolumeFill.visible = true;
				mcVidProgScrubber.visible = true;
				mcVidProgFill.visible = true;
				lblTimeDuration.visible = true;
				
				vid.width = 1000; 
				vid.height = 650; 
				vid.x = (1280 - vid.width) / 2;
				vid.y = 5;

				mcPlay.y = vid.y;
				mcPlay.x = vid.x;
				mcPlay.width = vid.width;
				mcPlay.height = vid.height;
				
				btnVidPlay.x = 50;
				btnVidPlay.y = 660;
				
				btnVidPause.x = btnVidPlay.x + btnVidPlay.width + 5;
				btnVidPause.y = btnVidPlay.y;
				
				btnVidStop.x = btnVidPause.x + btnVidPause.width + 5;
				btnVidStop.y = btnVidPlay.y;

				mcVidProgFill.x = btnVidStop.x + btnVidStop.width + 20;
				mcVidProgFill.y = btnVidPlay.y + 10;
				
				mcVidProgScrubber.x = mcVidProgFill.x + widthVidProg;
				mcVidProgScrubber.y = btnVidPlay.y;
				
				lblTimeDuration.x = mcVidProgScrubber.x + 20;
				lblTimeDuration.y = mcVidProgScrubber.y + 20;
				
				btnVidMute.x = lblTimeDuration.x + 100;
				btnVidMute.y = btnVidPlay.y;
				
				btnVidUnmute.x = btnVidMute.x;
				btnVidUnmute.y = btnVidPlay.y;
				
				if (isMuted) {
					btnVidUnmute.visible = true;
					btnVidMute.visible = false;
				}
				else {
					btnVidUnmute.visible = false;
					btnVidMute.visible = true;
				}
				
				mcVidVolumeFill.x = btnVidMute.x + btnVidMute.width + 20;
				mcVidVolumeFill.y = btnVidPlay.y + 10;
				
				mcVidVolScrubber.x = mcVidVolumeFill.x + mcVidVolumeFill.width;
				mcVidVolScrubber.y = btnVidPlay.y;
				
				btnVidFullscreen.x = mcVidVolumeFill.x + mcVidVolumeFill.width + 30;
				btnVidFullscreen.y = btnVidPlay.y;
			}
		}
		
		private function updateVidDisplay(e:TimerEvent):void {
			// checks, if user is scrubbing. if so, seek in the video
			// if not, just update the position of the scrubber according
			// to the current time
			if(bolProgScrub)
				ns.seek(Math.round((mcVidProgScrubber.x - mcVidProgFill.x)* metaData.duration / widthVidProg))
			else
				mcVidProgScrubber.x = (ns.time * widthVidProg / metaData.duration) + mcVidProgFill.x; 
			
			// set time and duration label
			lblTimeDuration.htmlText = "<font color='#ffffff' size='16px'>" + formatTime(ns.time) + "</font> / " + 
									   "<font color='#ffffff' size='16px'>" + formatTime(metaData.duration) + "</font>";
			
			// update the width from the progress bar
			mcVidProgFill.mcFillRed.width	= mcVidProgScrubber.x - mcVidProgFill.x;
			
			// update volume and the red fill width when user is scrubbing
			if(bolVolumeScrub) {
				if(!isMuted) setVidVolume((mcVidVolScrubber.x - mcVidVolumeFill.x) / widthVidVolume);
				mcVidVolumeFill.mcFillRed.width = mcVidVolScrubber.x - mcVidVolumeFill.x;
			}
		}
		
		private function formatTime(t:int):String {
			// returns the minutes and seconds with leading zeros
			// for example: 70 returns 01:10
			var s:int = Math.round(t);
			var m:int = 0;
			if (s > 0) {
				while (s > 59) {
					m++;
					s -= 60;
				}
				return String((m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s);
			} else {
				return "00:00";
			}
		}

		private function setVidVolume(intVolume:Number = 0):void {
			// create soundtransform object with the volume from
			// the parameter
			var sndTransform = new SoundTransform(intVolume);
			// assign object to netstream sound transform object
			ns.soundTransform	= sndTransform;
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			// handles net status events
			switch (event.info.code) {
				case "NetStream.Play.StreamNotFound":
					trace("Stream not found");
				break;
				
				// when the video reaches its end, we stop the player
				case "NetStream.Play.Stop":
					ns.pause(); 
					ns.seek(0);
					mcPlay.alpha = 1;
					mainClass.resetMusicVol();
				break;
			}
		}

		private function metaDataHandler(infoObject:Object):void {
			metaData = infoObject; //?
			
			tmrVidDisplay.start();
			/*
			vid.x = 600;
			vid.y = 100;
			vid.width = 360; 
			vid.height = 240; 
			*/
		}
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void 
		{ 
			// ignore error 
		} 
		
		private function onImageLoaded(e:Event):void {			
			var targetLoader:Loader = Loader(e.target.loader);
			targetLoader.width = 120;
			targetLoader.height = 90;
		}
				
		private function getDataError(event:SQLErrorEvent):void {
			
		}

		private function scrollHandler(event:MouseEvent):void {
			_startY = container.y;
			_startMouseY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler, false, 0, true);
		}

		private function stage_mouseMoveHandler(event:MouseEvent):void
		{
			var offsetY:Number = mouseY - _startMouseY;
			container.y = Math.max(Math.min(maxY, _startY + offsetY), minY);
		}

		private function stage_mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		private function inAnimation():void {
			btnBack.alpha = 0;
			mcPPRed.alpha = 0;
			mcArrow.alpha = 0;
			mcLine.alpha = 0;
			btnSemenPadang.alpha = 0;
			btnSemenGresik.alpha = 0;
			btnSemenTonasa.alpha = 0;
			btnSemenThanglong.alpha = 0;
			btnSemenInd.alpha = 0;
			
			btnBack.scaleX = 0.8;
			mcPPRed.scaleX = 0.8;
			mcArrow.scaleX = 0.8;
			mcLine.scaleX = 0.8;
			btnSemenPadang.scaleX = 0.8;
			btnSemenGresik.scaleX = 0.8;
			btnSemenTonasa.scaleX = 0.8;
			btnSemenThanglong.scaleX = 0.8;
			btnSemenInd.scaleX = 0.8;
			
			btnBack.scaleY = 0.8;
			mcPPRed.scaleY = 0.8;
			mcArrow.scaleY = 0.8;
			mcLine.scaleY = 0.8;
			btnSemenPadang.scaleY = 0.8;
			btnSemenGresik.scaleY = 0.8;
			btnSemenTonasa.scaleY = 0.8;
			btnSemenThanglong.scaleY = 0.8;
			btnSemenInd.scaleY = 0.8;
			
			TweenLite.to(btnSemenInd, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.9, ease:Circ.easeOut, onComplete: inAnim21()} );
		}
		
		private function inAnim21():void {
			TweenLite.to(btnSemenThanglong, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.8, ease:Circ.easeOut, onComplete: inAnim2()} );
		}
		
		private function inAnim2():void {
			TweenLite.to(btnSemenTonasa, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.8, ease:Circ.easeOut, onComplete: inAnim3()} );
		}
		
		private function inAnim3():void {
			TweenLite.to(btnSemenGresik, 0.5, {alpha:1, scaleX:1, scaleY:1, delay: 0.7, ease:Circ.easeOut, onComplete: inAnim4()});
		}
		
		private function inAnim4():void {
			TweenLite.to(btnSemenPadang, 0.5, {alpha:1, scaleX:1, scaleY:1, delay: 0.6, ease:Circ.easeOut, onComplete: inAnim5()});
		}
		
		private function inAnim5():void {
			TweenLite.to(mcLine, 0.5, {alpha:1, scaleX:1, scaleY:1, delay: 0.5, ease:Circ.easeOut, onComplete: inAnim6()});
		}
		
		private function inAnim6():void {
			TweenLite.to(mcArrow, 0.5, {alpha:1, scaleX:1, scaleY:1, delay: 0.4, ease:Circ.easeOut, onComplete: inAnim7()});
		}
		
		private function inAnim7():void {
			TweenLite.to(btnBack, 0.5, {alpha:1, scaleX:1, scaleY:1, delay: 0.4, ease:Circ.easeOut, onComplete: inAnim8()});
		}
		
		private function inAnim8():void {
			TweenLite.to(mcPPRed, 0.5, { alpha:1, scaleY:1, scaleX:1, delay: 0.3 } );
			setTextColor();
			init();
			conn = new SQLConnection();
			loadDb();
		}
		
		private function containerAnimation():void {
			TweenLite.to(container, 0.5, {alpha:1, delay: 1.0, ease:Circ.easeOut});
		}
	}

}