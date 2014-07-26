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
	public class ScreenAbout4 extends SCREEN_ABOUT4
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
		public function ScreenAbout4(passedClass:Main) 
		{
			mainClass = passedClass;
			init();
			inAnimation();
		}
		public function init():void
		{
			var formatActive:TextFormat = new TextFormat(); 
			formatActive.color = 0xC01F2D; 
			btnPrestasi.txtPrestasi.setTextFormat(formatActive);
			
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
			btnVisiMisi.addEventListener(MouseEvent.CLICK, navHandler);
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
				case "btnSejarah" : mainClass.showSplash(new ScreenAbout1(mainClass)); 
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
			var sql:String = "select * from prestasi";
			selectStmt.text = sql;
			
			selectStmt.addEventListener(SQLEvent.RESULT, getDataSuccess);
			selectStmt.addEventListener(SQLErrorEvent.ERROR, getDataError);
			
			selectStmt.execute();
		}
		
		private function getDataSuccess(event:SQLEvent):void {
			var result:SQLResult = selectStmt.getResult();
			var numResults:int = result.data.length; 
			
			var formatJudul:TextFormat = new TextFormat(); 
			formatJudul.color = 0xFFFFFF; 
			formatJudul.font = "myFont"; 
			formatJudul.size = 20;
			
			var formatLabel:TextFormat = new TextFormat(); 
			formatLabel.color = 0xD4D4D4; 
			formatLabel.font = "myFont"; 
			formatLabel.size = 16;
			
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			format.size = 16;
			
			// container
			container2 = new MovieClip();
			container2.scrollRect = new Rectangle(0, 0, 500, 100 + numResults * 150);
			
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xff0000, 0.0); 
			square.graphics.drawRect(0, 0, 500, 100 + numResults * 150); 
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
			
			
			// Judul
			var txtJudul1:TextField = new TextField();
			if (mainClass.bahasa) txtJudul1.text = "PRESTASI";
			else txtJudul1.text = "ACHIEVEMENTS";
			format.size = 48;
			txtJudul1.setTextFormat(format); 
			txtJudul1.x = 490;
			txtJudul1.y = 170;
			txtJudul1.embedFonts = true;
			txtJudul1.autoSize = "left";
			txtJudul1.selectable = false;
				
			addChild(txtJudul1);
			//container2.addChild(txtJudul1);
			
			var posY:int = 50;
			format.size = 16;
			for (var i:int = 0; i < numResults; i++) 
			{ 
				var row:Object = result.data[i]; 
			
				var txtJudul:TextField = new TextField();
				txtJudul.text = row.judulId;
				txtJudul.setTextFormat(formatJudul); 
				txtJudul.embedFonts = true;
				txtJudul.width = 450;
				txtJudul.autoSize = "left";
				txtJudul.multiline = true;
				txtJudul.wordWrap = true;
				txtJudul.selectable = false;
				txtJudul.y = posY;
				
				// Labels
				var txtLabelJuara:TextField = new TextField();
				txtLabelJuara.text = "JUARA";
				txtLabelJuara.setTextFormat(formatLabel);
				txtLabelJuara.embedFonts = true;
				txtLabelJuara.selectable = false;
				
				/*
				var txtLabelTahun:TextField = new TextField();
				txtLabelTahun.text = "TAHUN";
				txtLabelTahun.setTextFormat(formatLabel);
				txtLabelTahun.embedFonts = true;
				txtLabelTahun.selectable = false;
				*/
				var txtLabelKat:TextField = new TextField();
				txtLabelKat.text = "KATEGORI";
				txtLabelKat.setTextFormat(formatLabel);
				txtLabelKat.embedFonts = true;
				txtLabelKat.selectable = false;
				/*
				var txtLabelKet:TextField = new TextField();
				txtLabelKet.text = "KETUA";
				txtLabelKet.setTextFormat(formatLabel);
				txtLabelKet.embedFonts = true;
				txtLabelKet.selectable = false;
				
				var txtLabelAng:TextField = new TextField();
				txtLabelAng.text = "ANGGOTA";
				txtLabelAng.setTextFormat(formatLabel);
				txtLabelAng.embedFonts = true;
				txtLabelAng.selectable = false;
				*/
				var txtJuara:TextField = new TextField();
				txtJuara.text = row.juara;
				txtJuara.setTextFormat(format); 
				txtJuara.embedFonts = true;
				txtJuara.autoSize = "left";
				txtJuara.selectable = false;
				/*
				var txtTahun:TextField = new TextField();
				txtTahun.text = row.tahun;
				txtTahun.setTextFormat(format); 
				txtTahun.embedFonts = true;
				txtTahun.autoSize = "left";
				txtTahun.selectable = false;
				*/
				var txtKat:TextField = new TextField();
				if (row.kategori == null || row.kategori == "" || row.kategori == "null") txtKat.text = " - ";
				else txtKat.text = row.kategori;
				txtKat.setTextFormat(format); 
				txtKat.embedFonts = true;
				txtKat.selectable = false;
				txtKat.width = 300;
				txtKat.autoSize = "left";
				txtKat.multiline = true;
				txtKat.wordWrap = true;
				txtKat.selectable = false;
				/*
				var txtKet:TextField = new TextField();
				if (row.ketua == null || row.ketua == "" || row.ketua == "null") txtKet.text = " - ";
				else txtKet.text = row.ketua;
				txtKet.setTextFormat(format); 
				txtKet.embedFonts = true;
				txtKet.selectable = false;
				txtKet.width = 300;
				txtKet.autoSize = "left";
				txtKet.multiline = true;
				txtKet.wordWrap = true;
				txtKet.selectable = false;
				
				var txtAng:TextField = new TextField();
				if (row.anggota == null || row.anggota == "" || row.anggota == "null") txtAng.text = " -";
				else txtAng.text = row.anggota;
				txtAng.setTextFormat(format); 
				txtAng.embedFonts = true;
				txtAng.selectable = false;
				txtAng.width = 300;
				txtAng.autoSize = "left";
				txtAng.multiline = true;
				txtAng.wordWrap = true;
				txtAng.selectable = false;
				*/
				// pos
				/*
				txtLabelTahun.y = txtJudul.y + txtJudul.height + 5;
				txtTahun.y = txtLabelTahun.y;
				txtTahun.x = 100;
				*/
				//txtLabelJuara.y = txtTahun.y + txtTahun.height + 5;
				txtLabelJuara.y = txtJudul.y + txtJudul.height + 5;
				txtJuara.y = txtLabelJuara.y;
				txtJuara.x = 100;
				txtLabelKat.y = txtJuara.y + txtJuara.height + 5;
				txtKat.y = txtLabelKat.y;
				txtKat.x = 100;
				/*
				txtLabelKet.y = txtKat.y + txtKat.height + 5;
				txtKet.y = txtLabelKet.y;
				txtKet.x = 100;
				txtLabelAng.y = txtKet.y + txtKet.height + 5;
				txtAng.y = txtLabelAng.y;
				txtAng.x = 100;
				*/
				//posY = (txtAng.y + txtAng.height + 30);
				posY = (txtKat.y + txtKat.height + 30);
				//trace("txtAng.y " + txtAng.y + " txtAng.height " + txtAng.height + " posY " + posY);
			
				if (i == 0) {
					// Gambar
					imageMC = new MovieClip();
					var myLoader:Loader = new Loader();
					var fileRequest:URLRequest = new URLRequest(row.pathImg);
					myLoader.load(fileRequest);
					myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
					imageMC.addChild(myLoader);
					imageMC.y = 180;
					imageMC.x = 0;
				}
			
				// addchild ke movieclip
				container2.addChild(txtJudul);
				//container2.addChild(txtLabelTahun);
				container2.addChild(txtLabelJuara);
				//container2.addChild(txtLabelKet);
				container2.addChild(txtLabelKat);
				//container2.addChild(txtLabelAng);
				//container2.addChild(txtTahun);
				container2.addChild(txtJuara);
				container2.addChild(txtKat);
				//container2.addChild(txtKet);
				//container2.addChild(txtAng);
			}
			addChild(imageMC);
			
			container2.alpha = 0;
			addChild(container2);
			container2.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler2);
			maxY2 = 250;
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
			//targetLoader.height = 380;
			targetLoader.height = (targetLoader.content.height / targetLoader.content.width) * targetLoader.width;
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
			
			TweenLite.to(btnBack, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 1.1, ease:Circ.easeOut, onComplete: inAnim12()} );
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
			TweenLite.to(mcABRed, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.2, ease:Circ.easeOut } );
			conn = new SQLConnection();
			loadDb();
		}
		
		private function container2Animation():void {
			TweenLite.to(container2, 1.5, { alpha:1, delay: 0.9, ease:Circ.easeOut } );
		}
	}

}