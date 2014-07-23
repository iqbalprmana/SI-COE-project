package Screen 
{
	import Asset.McOrStrukturEKHead;
	import Asset.McOrStrukturEKSub;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author vikachew
	 */
	public class ScreenOrg3 extends SCREEN_ORG3
	{
		private var mainClass:Main;		
		
		// db
		private var selectStmt:SQLStatement;		
		private var selectEmpStmt:SQLStatement;
		private var conn:SQLConnection;
		
		// gambar dan deskripsi
		private var imageMC:MovieClip;
		private var txtDesk:TextField;
		
		// struktur
		private var struktur_container:MovieClip;
		private var struktur_head_EPI:McOrStrukturEKHead;
		
		// scroll
		private var container:MovieClip;
		private var maxY:Number;
		private var minY:Number;
		private var _startY:Number;
		private var _startMouseY:Number;
		
		public function ScreenOrg3(passedClass:Main) 
		{
			mainClass = passedClass;
			init();
			inAnimation();
		}
		
		public function init():void
		{
			var formatActive:TextFormat = new TextFormat(); 
			formatActive.color = 0xC01F2D; 
			btnEPI.txtEPI.setTextFormat(formatActive);
			if (mainClass.bahasa) {
				mcORRed.txtORRed.text = "STRUKTUR\nORGANISASI";
			}
			else {
				mcORRed.txtORRed.text = "ORGANIZATION\nSTRUCTURE";
			}
			
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			
			btnDIR.addEventListener(MouseEvent.CLICK, navHandler);
			btnDE.addEventListener(MouseEvent.CLICK, navHandler);
			btnPSPM.addEventListener(MouseEvent.CLICK, navHandler);
			btnPM.addEventListener(MouseEvent.CLICK, navHandler);
			btnPM2.addEventListener(MouseEvent.CLICK, navHandler);
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenHome(mainClass));
										break;
				case "btnDIR" : mainClass.showSplash(new ScreenOrg0(mainClass));
										break;
				case "btnDE" : mainClass.showSplash(new ScreenOrg1(mainClass));
										break;
				case "btnPSPM" : mainClass.showSplash(new ScreenOrg2(mainClass));
										break;
				case "btnPM" : mainClass.showSplash(new ScreenOrg4(mainClass));
										break;
				case "btnPM2" : mainClass.showSplash(new ScreenOrg5(mainClass));
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
			var sql:String = "select * from department where iddept = 3";
			
			selectStmt.text = sql;
			
			selectStmt.addEventListener(SQLEvent.RESULT, getDataSuccess);
			selectStmt.addEventListener(SQLErrorEvent.ERROR, getDataError);
			
			selectStmt.execute();
		}
		
		private function getDataSuccess(event:SQLEvent):void {
			var result:SQLResult = selectStmt.getResult();
			var row:Object = result.data[0]; 
			
			// Gambar
			imageMC = new MovieClip();
			var myLoader:Loader = new Loader();
			var fileRequest:URLRequest = new URLRequest(row.pathImg);
			myLoader.load(fileRequest);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imageMC.addChild(myLoader);
			imageMC.y = 100;
			imageMC.x = 30;
			
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			format.size = 16;
			
			// Deskripsi
			txtDesk = new TextField();
			if (mainClass.bahasa) txtDesk.htmlText = row.artikelId;
			else {
				if (row.artikelEn == null || row.artikelEn == "" || row.artikelEn == "null") txtDesk.htmlText = row.artikelId;
				else txtDesk.htmlText = row.artikelEn;
			}
			
			txtDesk.setTextFormat(format); 
			txtDesk.embedFonts = true;
			txtDesk.x = 450;
			txtDesk.y = 100;
			txtDesk.width = 400;
			txtDesk.autoSize = "left";
			txtDesk.multiline = true;
			txtDesk.wordWrap = true;
			txtDesk.selectable = false;
					
			// struktur organisasi
			// bikin tombol
			struktur_head_EPI = new McOrStrukturEKHead;
			struktur_head_EPI.y = Math.max(txtDesk.y + txtDesk.height, 300) + 50;
			struktur_head_EPI.x = 522;
			
			struktur_head_EPI.addEventListener(MouseEvent.CLICK, strukturClickHandler);
			
			// make container
			container = new MovieClip();
			container.scrollRect = new Rectangle(0, 0, 1000, Math.max(txtDesk.height, 297) + 200);
			
			// make scrollable area
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xff0000, 0.0); 
			square.graphics.drawRect(0, 0, 1000, Math.max(txtDesk.height, 297) + 200);
			square.graphics.endFill(); 
			
			container.addChild(square);
			
			// make mask
			var square2:Shape = new Shape(); 
			square2.graphics.lineStyle(1, 0x000000, 0.0); 
			square2.graphics.beginFill(0xff0000, 0.1); 
			square2.graphics.drawRect(90, 175, 1000, 600); 
			square2.graphics.endFill(); 
			
			container.mask = square2;
			
			container.x = 90;
			container.y = 175;
			
			// addchild ke container
			container.addChild(imageMC);
			container.addChild(txtDesk);
			container.addChild(struktur_head_EPI);
				
			addChild(container);
			
			//container.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
			maxY = 175;
			minY = Math.min(0, 720 - container.height);
		}
				
		private function onImageLoaded(e:Event):void {			
			var targetLoader:Loader = Loader(e.target.loader);
			targetLoader.width = 400;
			targetLoader.height = 280;
		}
		
		private function getDataError(event:SQLErrorEvent):void {
			
		}
		
		private function strukturClickHandler(e:MouseEvent):void {
			mainClass.showSplash(new ScreenOrgStructure(mainClass, 3));
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
			mcORRed.alpha = 0;
			mcLine.alpha = 0;
			mcArrow.alpha = 0;
			btnDIR.alpha = 0;
			btnDE.alpha = 0;
			btnEPI.alpha = 0;
			btnPSPM.alpha = 0;
			btnPM.alpha = 0;
			btnPM2.alpha = 0;
			
			btnBack.scaleX = 0.8;
			mcORRed.scaleX = 0.8;
			mcLine.scaleX = 0.8;
			mcArrow.scaleX = 0.8;
			btnDE.scaleX = 0.8;
			btnDIR.scaleX = 0.8;
			btnEPI.scaleX = 0.8;
			btnPSPM.scaleX = 0.8;
			btnPM.scaleX = 0.8;
			btnPM2.scaleX = 0.8;
			
			btnBack.scaleY = 0.8;
			mcORRed.scaleY = 0.8;
			mcLine.scaleY = 0.8;
			mcArrow.scaleY = 0.8;
			btnDE.scaleY = 0.8;
			btnDIR.scaleY = 0.8;
			btnEPI.scaleY = 0.8;
			btnPSPM.scaleY = 0.8;
			btnPM.scaleY = 0.8;
			btnPM2.scaleY = 0.8;
			
			TweenLite.to(btnBack, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 1.0, ease:Circ.easeOut, onComplete: inAnim21()} );
		}
		
		private function inAnim21():void {
			TweenLite.to(btnPM2, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.9, ease:Circ.easeOut, onComplete: inAnim22()} );
		}
		
		private function inAnim22():void {
			TweenLite.to(btnPM, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.8, ease:Circ.easeOut, onComplete: inAnim2()} );
		}
		private function inAnim2():void {
			TweenLite.to(btnEPI, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.7, ease:Circ.easeOut, onComplete: inAnim31()} );
		}
		
		private function inAnim31():void {
			TweenLite.to(btnPSPM, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.7, ease:Circ.easeOut, onComplete: inAnim3()} );
		}
		private function inAnim3():void {
			TweenLite.to(btnDE, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.6, ease:Circ.easeOut, onComplete: inAnim4()} );
		}
		private function inAnim4():void {
			TweenLite.to(btnDIR, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.5, ease:Circ.easeOut, onComplete: inAnim5()} );
		}
		private function inAnim5():void {
			TweenLite.to(mcArrow, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.4, ease:Circ.easeOut, onComplete: inAnim6()} );
		}
		private function inAnim6():void {
			TweenLite.to(mcLine, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.3, ease:Circ.easeOut, onComplete: inAnim7()} );
		}
		private function inAnim7():void {
			TweenLite.to(mcORRed, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.2, ease:Circ.easeOut } );
			conn = new SQLConnection();
			loadDb();
		}
	}

}