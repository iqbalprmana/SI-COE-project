package Screen 
{
	import Asset.McShadeBtm;
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
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.events.Event;
	
	// Tween
	import com.greensock.*;
	import com.greensock.easing.*;
	/**
	 * ...
	 * @author vikachew
	 */
	public class ScreenAbout1 extends SCREEN_ABOUT1
	{
		private var mainClass:Main;		
		private var selectStmt:SQLStatement;		
		private var conn:SQLConnection;
		
		private var container2:MovieClip;
		private var imageMC2:MovieClip;
		private var imageMC3:MovieClip;
		private var imageMC4:MovieClip;
		private var maxY2:Number;
		private var minY2:Number;
		private var _startY2:Number;
		private var _startMouseY2:Number;
		private var squareScroll:Shape; 
		
		public function ScreenAbout1(passedClass:Main) 
		{
			mainClass = passedClass;
			init();
			inAnimation();
		}
		public function init():void
		{
			var formatActive:TextFormat = new TextFormat(); 
			formatActive.color = 0xC01F2D; 
			btnSejarah.txtSejarah.setTextFormat(formatActive);
			
			if (mainClass.bahasa) {
				mcABRed.txtABRed.text = "TENTANG KAMI";
				btnProfil.txtProfil.text = "Profil";
				btnSejarah.txtSejarah.text = "Sejarah";
				btnVisiMisi.txtVisiMisi.text = "Visi & Misi";
				btnPrestasi.txtPrestasi.text = "Prestasi";
				btnKontak.txtKontak.text = "Kontak";
				btnService.txtService.text = "Layanan";
			}
			else {
				mcABRed.txtABRed.text = "ABOUT US";
				btnProfil.txtProfil.text = "Profile";
				btnSejarah.txtSejarah.text = "History";
				btnVisiMisi.txtVisiMisi.text = "Vision & Mission";
				btnPrestasi.txtPrestasi.text = "Achievements";
				btnKontak.txtKontak.text = "Contact";
				btnService.txtService.text = "Services";
			}
			
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			btnProfil.addEventListener(MouseEvent.CLICK, navHandler);
			btnVisiMisi.addEventListener(MouseEvent.CLICK, navHandler);
			btnPrestasi.addEventListener(MouseEvent.CLICK, navHandler);
			btnKontak.addEventListener(MouseEvent.CLICK, navHandler);
			btnService.addEventListener(MouseEvent.CLICK, navHandler);
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenHome(mainClass));
										break;
				case "btnProfil" : mainClass.showSplash(new ScreenAbout2(mainClass));
										break;
				case "btnVisiMisi" : mainClass.showSplash(new ScreenAbout3(mainClass)); 
										break;
				case "btnPrestasi" : mainClass.showSplash(new ScreenAbout4(mainClass)); 
										break;
				case "btnKontak" : mainClass.showSplash(new ScreenAbout5(mainClass)); 
										break;
				case "btnService" : mainClass.showSplash(new ScreenAbout6(mainClass)); 
										break;
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
			var sql:String = "select * from sejarah";
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
			
			// Artikel // dibutuhkan untuk menghitung height container
			var txtArt:TextField = new TextField();
			if (mainClass.bahasa) txtArt.text = row.artId;
			else txtArt.text = row.artEn;
			txtArt.setTextFormat(format); 
			txtArt.embedFonts = true;
			txtArt.width = 400;
			txtArt.autoSize = "left";
			txtArt.multiline = true;
			txtArt.wordWrap = true;
			txtArt.selectable = false;
			
			container2 = new MovieClip();
			container2.scrollRect = new Rectangle(0, 0, 500, 600 + txtArt.height);
			
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xff0000, 0.0); 
			square.graphics.drawRect(0, 0, 500, 600 + txtArt.height); 
			square.graphics.endFill(); 

			container2.addChild(square);
			
			// mask
			var square2:Shape = new Shape(); 
			square2.graphics.lineStyle(1, 0x000000, 0.0); 
			square2.graphics.beginFill(0xff0000, 0.1); 
			square2.graphics.drawRect(490, 250, 500, 470); 
			square2.graphics.endFill(); 
			
			container2.mask = square2;
			
			container2.x = 495;
			container2.y = 250;
			
			// Judul
			var txtJudul:TextField = new TextField();
			if (mainClass.bahasa) txtJudul.text = "SEJARAH";
			else txtJudul.text = "HISTORY";
			format.size = 48;
			format.indent = 0;
			format.align = "left";
			txtJudul.setTextFormat(format); 
			txtJudul.embedFonts = true;
			txtJudul.autoSize = "left";
			txtJudul.y = 170;
			txtJudul.x = 490;
			txtJudul.selectable = false;
			
			// Gambar
			imageMC2 = new MovieClip();
			var myLoader:Loader = new Loader();
			var fileRequest:URLRequest = new URLRequest("Images/about-us-sejarah3.jpg");
			myLoader.load(fileRequest);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imageMC2.addChild(myLoader);
			imageMC2.y = 110;
			imageMC2.x = 80;
			
			// Summary
			/*var txtSum:TextField = new TextField();
			if (mainClass.bahasa) txtSum.text = row.sumId;
			else txtSum.text = row.sumEn;
			format.size = 20;
			format.indent = 0;
			format.align = "left";
			txtSum.setTextFormat(format); 
			txtSum.embedFonts = true;
			txtSum.width = 250;
			txtSum.autoSize = "left";
			txtSum.multiline = true;
			txtSum.wordWrap = true;
			txtSum.y = 400;
			txtSum.x = 200;
			txtSum.selectable = false;
			*/
			// Gambar inline 1
			/*imageMC3 = new MovieClip();
			var myLoader3:Loader = new Loader();
			var fileRequest3:URLRequest = new URLRequest("Images/about-us-sejarah2.jpg");
			myLoader3.load(fileRequest3);
			myLoader3.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded3);
			imageMC3.addChild(myLoader3);
			imageMC3.y = 110;
			*/
			// Gambar inline 2
			imageMC4 = new MovieClip();
			var myLoader4:Loader = new Loader();
			var fileRequest4:URLRequest = new URLRequest("Images/about-us-sejarah2.jpg");
			myLoader4.load(fileRequest4);
			myLoader4.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded4);
			imageMC4.addChild(myLoader4);
			if (mainClass.bahasa) imageMC4.y = 300;
			else imageMC4.y = 260;
			
			// addchild ke movieclip
			addChild(txtJudul);
			addChild(imageMC2);
			//addChild(txtSum);
			//container2.addChild(imageMC3);
			container2.addChild(imageMC4);
			container2.addChild(txtArt);
			
			container2.alpha = 0;
			addChild(container2);
			container2.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler2);
			maxY2 = 250;
			minY2 = Math.min(0, 720 - container2.height);
			
			container2Animation();
			
			var mcShade:MovieClip = new McShadeBtm();
			mcShade.mouseEnabled = false;
			mcShade.y = 600;
			addChild(mcShade);
		}
		
		private function onImageLoaded(e:Event):void {			
			var targetLoader:Loader = Loader(e.target.loader);
			targetLoader.width = 350;
			targetLoader.height = 500;
		}
		
		private function onImageLoaded3(e:Event):void {			
			var targetLoader:Loader = Loader(e.target.loader);
			targetLoader.width = 350;
			targetLoader.height = 240;
		}
		
		private function onImageLoaded4(e:Event):void {			
			var targetLoader:Loader = Loader(e.target.loader);
			targetLoader.width = 350;
			targetLoader.height = 240;
		}
				
		private function getDataError(event:SQLErrorEvent):void {
			
		}

		private function scrollHandler2(event:MouseEvent):void {
			_startY2 = container2.y;
			_startMouseY2 = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler2, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler2, false, 0, true);
		}

		private function stage_mouseMoveHandler2(event:MouseEvent):void
		{
			var offsetY2:Number = mouseY - _startMouseY2;
			container2.y = Math.max(Math.min(maxY2, _startY2 + offsetY2), minY2);
		}

		private function stage_mouseUpHandler2(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler2);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler2);
		}
		
		private function inAnimation():void {
			btnBack.alpha = 0;
			mcABRed.alpha = 0;
			mcLine.alpha = 0;
			mcArrow.alpha = 0;
			btnProfil.alpha = 0;
			btnSejarah.alpha = 0;
			btnVisiMisi.alpha = 0;
			btnPrestasi.alpha = 0;
			btnKontak.alpha = 0;
			btnService.alpha = 0;
			
			btnBack.scaleX = 0.8;
			mcABRed.scaleX = 0.8;
			mcLine.scaleX = 0.8;
			mcArrow.scaleX = 0.8;
			btnProfil.scaleX = 0.8;
			btnSejarah.scaleX = 0.8;
			btnVisiMisi.scaleX = 0.8;
			btnPrestasi.scaleX = 0.8;
			btnKontak.scaleX = 0.8;
			btnService.scaleX = 0.8;
			
			btnBack.scaleY = 0.8;
			mcABRed.scaleY = 0.8;
			mcLine.scaleY = 0.8;
			mcArrow.scaleY = 0.8;
			btnProfil.scaleY = 0.8;
			btnSejarah.scaleY = 0.8;
			btnVisiMisi.scaleY = 0.8;
			btnPrestasi.scaleY = 0.8;
			btnKontak.scaleY = 0.8;
			btnService.scaleY = 0.8;
			
			TweenLite.to(btnBack, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 1.1, ease:Circ.easeOut, onComplete: inAnim12()} );
		}
		
		private function inAnim12():void {
			TweenLite.to(btnService, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.9, ease:Circ.easeOut, onComplete: inAnim2()} );
		}
		private function inAnim2():void {
			TweenLite.to(btnKontak, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 1.0, ease:Circ.easeOut, onComplete: inAnim3()} );
		}
		private function inAnim3():void {
			TweenLite.to(btnPrestasi, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.8, ease:Circ.easeOut, onComplete: inAnim4()} );
		}
		private function inAnim4():void {
			TweenLite.to(btnVisiMisi, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.7, ease:Circ.easeOut, onComplete: inAnim5()} );
		}
		private function inAnim5():void {
			TweenLite.to(btnSejarah, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.6, ease:Circ.easeOut, onComplete: inAnim6()} );
		}
		private function inAnim6():void {
			TweenLite.to(btnProfil, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.5, ease:Circ.easeOut, onComplete: inAnim7()} );
		}
		private function inAnim7():void {
			TweenLite.to(mcArrow, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.4, ease:Circ.easeOut, onComplete: inAnim8()} );
		}
		private function inAnim8():void {
			TweenLite.to(mcLine, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.3, ease:Circ.easeOut, onComplete: inAnim9()} );
		}
		
		private function inAnim9():void {
			TweenLite.to(mcABRed, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.2, ease:Circ.easeOut } );
			conn = new SQLConnection();
			loadDb();
		}
		
		private function container2Animation():void {
			TweenLite.to(container2, 1.5, { alpha:1, delay: 0.9, ease:Circ.easeOut } );
		}
	}

}
