package Screen 
{
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
	public class ScreenAbout2 extends SCREEN_ABOUT2
	{
		private var mainClass:Main;		
		private var selectStmt:SQLStatement;		
		private var conn:SQLConnection;
		
		private var container2:MovieClip;
		private var imageMC2:MovieClip;
		private var maxY2:Number;
		private var minY2:Number;
		private var _startY2:Number;
		private var _startMouseY2:Number;
		public function ScreenAbout2(passedClass:Main) 
		{
			mainClass = passedClass;
			init();
			inAnimation();
		}
		public function init():void
		{
			var formatActive:TextFormat = new TextFormat(); 
			formatActive.color = 0xC01F2D; 
			btnProfil.txtProfil.setTextFormat(formatActive);
			
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
			btnSejarah.addEventListener(MouseEvent.CLICK, navHandler);
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
				case "btnSejarah" : mainClass.showSplash(new ScreenAbout1(mainClass));
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
			var sql:String = "select * from profil";
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
			/*
			container2.scrollRect = new Rectangle(0, 0, 870, 100 + txtArt.height);
			
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xff0000, 0.0); 
			square.graphics.drawRect(0, 0, 870, 100 + txtArt.height); 
			square.graphics.endFill(); 

			container2.addChild(square);
			
			// mask
			var square2:Shape = new Shape(); 
			square2.graphics.lineStyle(1, 0x000000, 0.0); 
			square2.graphics.beginFill(0xff0000, 0.1); 
			square2.graphics.drawRect(90, 280, 870, 460); 
			square2.graphics.endFill(); 
			
			container2.mask = square2;
			*/
			container2.x = 490;
			container2.y = 250;
			
			// Judul
			var txtJudul:TextField = new TextField();
			if (mainClass.bahasa) txtJudul.text = "PROFIL";
			else txtJudul.text = "PROFILE";
			format.size = 48;
			format.indent = 0;
			format.align = "left";
			txtJudul.setTextFormat(format); 
			txtJudul.embedFonts = true;
			txtJudul.autoSize = "left";
			txtJudul.y = 170;
			txtJudul.x = 490;
			txtJudul.selectable = false;
			
			// Summary
			/*
			var txtSum:TextField = new TextField();
			if (mainClass.bahasa) txtSum.text = row.sumId;
			else txtSum.text = row.sumEn;
			format.color = 0xFFFFFF; 
			format.align = "right";
			format.size = 21;
			format.leading = -7;
			txtSum.setTextFormat(format); 
			txtSum.embedFonts = true;
			txtSum.y = 325;
			txtSum.x = 55;
			txtSum.width = 400;
			txtSum.autoSize = "right";
			txtSum.multiline = true;
			txtSum.wordWrap = true;
			txtSum.selectable = false;
			*/
			
			// Gambar
			imageMC2 = new MovieClip();
			var myLoader:Loader = new Loader();
			var fileRequest:URLRequest = new URLRequest(row.pathImg);
			myLoader.load(fileRequest);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imageMC2.addChild(myLoader);
			imageMC2.y = 110;
			imageMC2.x = 150;
			
			// addchild ke movieclip
			addChild(txtJudul);
			addChild(imageMC2);
			//container2.addChild(txtJudul);
			//container2.addChild(txtSum);
			//container2.addChild(imageMC2);
			container2.addChild(txtArt);
			
			container2.alpha = 0;
			addChild(container2);
			//container2.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler2);
			//maxY2 = 350;
			//minY2 = Math.min(0, 720 - container2.height);
			container2Animation();
		}
		
		private function onImageLoaded(e:Event):void {			
			var targetLoader:Loader = Loader(e.target.loader);
			targetLoader.width = 300;
			targetLoader.height = 297;
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