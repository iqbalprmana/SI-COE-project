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
	public class ScreenAbout3 extends SCREEN_ABOUT3
	{
		private var mainClass:Main;		
		private var selectStmt:SQLStatement;		
		private var conn:SQLConnection;
		
		private var container2:MovieClip;
		private var imageMC:MovieClip;
		private var maxY2:Number;
		private var minY2:Number;
		private var _startY2:Number;
		private var _startMouseY2:Number;
		
		private var txtArt:TextField;
		private var txtArt2:TextField;
		
		public function ScreenAbout3(passedClass:Main) 
		{
			trace("Cons1");
			mainClass = passedClass;
			init();
			inAnimation();
			trace("Cons2");
		}
		public function init():void
		{
			trace("Init11");
			var formatActive:TextFormat = new TextFormat(); 
			formatActive.color = 0xC01F2D; 
			btnVisiMisi.txtVisiMisi.setTextFormat(formatActive);
			
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
				mcArrow.visible = false;
			}
			
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			btnProfil.addEventListener(MouseEvent.CLICK, navHandler);
			btnSejarah.addEventListener(MouseEvent.CLICK, navHandler);
			btnPrestasi.addEventListener(MouseEvent.CLICK, navHandler);
			btnKontak.addEventListener(MouseEvent.CLICK, navHandler);
			btnService.addEventListener(MouseEvent.CLICK, navHandler);
			trace("Init2");
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenHome(mainClass));
										break;
				case "btnProfil" : mainClass.showSplash(new ScreenAbout2(mainClass));
										break;
				case "btnSejarah" : mainClass.showSplash(new ScreenAbout1(mainClass)); 
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
			var sql:String = "select * from vision";
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
			
			txtArt = new TextField();
			if (mainClass.bahasa) txtArt.text = row.visiId;
			else txtArt.text = row.visiEn;
			format.size = 16;
			txtArt.setTextFormat(format); 
			txtArt.embedFonts = true;
			txtArt.width = 400;
			txtArt.autoSize = "left";
			txtArt.multiline = true;
			txtArt.wordWrap = true;
			txtArt.selectable = false;
			
			// Gambar
			imageMC = new MovieClip();
			var myLoader:Loader = new Loader();
			var fileRequest:URLRequest = new URLRequest(row.pathImg);
			myLoader.load(fileRequest);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imageMC.addChild(myLoader);
			imageMC.y = 180;
			imageMC.x = 0;
			
			getData2();
		}
		
		private function getData2():void {
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = conn;
			var sql:String = "select * from mission";
			selectStmt.text = sql;
			
			selectStmt.addEventListener(SQLEvent.RESULT, getData2Success);
			
			selectStmt.execute();
		}
		
		private function getData2Success(event:SQLEvent):void {
			var result:SQLResult = selectStmt.getResult();
			var row:Object = result.data[0]; 
			
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			
			var txtJudul0:TextField = new TextField();
			if (mainClass.bahasa) txtJudul0.text = "VISI & MISI";
			else txtJudul0.text = "VISION & MISSION";
			format.size = 48;
			format.indent = 0;
			format.align = "left";
			txtJudul0.setTextFormat(format); 
			txtJudul0.embedFonts = true;
			txtJudul0.width = 400;
			txtJudul0.x = 490;
			txtJudul0.y = 170;
			txtJudul0.selectable = false;
			
			// Judul
			var txtJudul:TextField = new TextField();
			if (mainClass.bahasa) txtJudul.text = "VISI";
			else txtJudul.text = "VISION";
			format.size = 36;
			format.indent = 0;
			format.align = "left";
			txtJudul.setTextFormat(format); 
			txtJudul.embedFonts = true;
			txtJudul.autoSize = "left";
			txtJudul.x = 0;
			txtJudul.selectable = false;
			
			// Artikel
			txtArt.y = 70;
			txtArt.x = txtJudul.x;
			
			var txtJudul2:TextField = new TextField();
			if (mainClass.bahasa) txtJudul2.text = "MISI";
			else txtJudul2.text = "MISSION";
			format.size = 36;
			txtJudul2.setTextFormat(format); 
			txtJudul2.embedFonts = true;
			txtJudul2.autoSize = "left";
			txtJudul2.y = 50 + txtArt.height + txtArt.y;
			txtJudul2.x = txtJudul.x;
			txtJudul2.selectable = false;
			
			txtArt2 = new TextField();
			if (mainClass.bahasa) txtArt2.htmlText = row.misiId;
			else txtArt2.htmlText = row.misiEn;
			
			format.size = 16;
			txtArt2.setTextFormat(format); 
			txtArt2.embedFonts = true;
			txtArt2.width = 400;
			txtArt2.autoSize = "left";
			txtArt2.multiline = true;
			txtArt2.wordWrap = true;
			txtArt2.selectable = false;
			txtArt2.y = txtJudul2.y + txtJudul2.height + 20;
			txtArt2.x = txtJudul2.x;
			
			// container
			container2 = new MovieClip();
			container2.scrollRect = new Rectangle(0, 0, 500, txtArt.height + txtArt2.height + 200);
			
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xff0000, 0.0); 
			square.graphics.drawRect(0, 0, 500, txtArt.height + txtArt2.height + 200); 
			square.graphics.endFill(); 

			container2.addChild(square);
			
			// mask
			var square2:Shape = new Shape(); 
			square2.graphics.lineStyle(1, 0x000000, 0.0); 
			square2.graphics.beginFill(0xff0000, 0.1); 
			square2.graphics.drawRect(490, 250, 500, 470); 
			square2.graphics.endFill(); 
			
			container2.mask = square2;
			
			container2.x = 490;
			container2.y = 250;
			
			// addchild ke movieclip
			addChild(txtJudul0);
			addChild(imageMC);
			container2.addChild(txtJudul);
			container2.addChild(txtArt);
			container2.addChild(txtJudul2);
			container2.addChild(txtArt2);
			
			container2.alpha = 0;
			
			addChild(container2);
			container2.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler2);
			
			maxY2 = 300;
			minY2 = Math.min(0, 720 - container2.height);
			container2Animation();
			
			var mcShade = new McShadeBtm();
			mcShade.mouseEnabled = false;
			mcShade.y = 600;
			addChild(mcShade);
		}
				
		private function onImageLoaded(e:Event):void {			
			var targetLoader:Loader = Loader(e.target.loader);
			targetLoader.width = 450;
			targetLoader.height = (targetLoader.content.height / targetLoader.content.width) * targetLoader.width;
			//targetLoader.height = 370;
			//trace(targetLoader.content.height);
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
			mcArrow2.alpha = 0;
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
			mcArrow2.scaleX = 0.8;
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
			mcArrow2.scaleY = 0.8;
			btnProfil.scaleY = 0.8;
			btnSejarah.scaleY = 0.8;
			btnVisiMisi.scaleY = 0.8;
			btnPrestasi.scaleY = 0.8;
			btnKontak.scaleY = 0.8;
			btnService.scaleY = 0.8;
			
			TweenLite.to(btnBack, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 1.1, ease:Circ.easeOut, onComplete: inAnim12() } );
			trace("IN0");
		}
		
		private function inAnim12():void {
			TweenLite.to(btnService, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 1.0, ease:Circ.easeOut, onComplete: inAnim2()} );
		}
		
		private function inAnim2():void {
			TweenLite.to(btnKontak, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.9, ease:Circ.easeOut, onComplete: inAnim3()} );
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
			TweenLite.to(mcArrow, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.4, ease:Circ.easeOut } );
			TweenLite.to(mcArrow2, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.4, ease:Circ.easeOut, onComplete: inAnim8()} );
		}
		private function inAnim8():void {
			TweenLite.to(mcLine, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.3, ease:Circ.easeOut, onComplete: inAnim9()} );
		}
		
		private function inAnim9():void {
			trace("INLoad1");
			TweenLite.to(mcABRed, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.2, ease:Circ.easeOut } );
			conn = new SQLConnection();
			loadDb();
			trace("INLoad2");
		}
		
		private function container2Animation():void {
			TweenLite.to(container2, 1.5, { alpha:1, delay: 0.9, ease:Circ.easeOut } );
		}
		
	}

}