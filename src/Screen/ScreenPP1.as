package Screen 
{
	import Asset.McShadeBtm;
	import Asset.McShadeUp;
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
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
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
	public class ScreenPP1 extends SCREEN_PP_1
	{
		private var mainClass:Main;
		private var selectedSemen:int;
		private var selectStmt:SQLStatement;		
		private var conn:SQLConnection;
		
		private var container:MovieClip;
		private var mcShadeBtm:McShadeBtm;
		private var mcShadeUp:McShadeUp;
		private var imageMC:MovieClip;
		private var whichProject:int;
		private var maxY:Number;
		private var minY:Number;
		private var _startY:Number;
		private var _startMouseY:Number;
		private var _clickHandlerY:Number;
		
		public function ScreenPP1(passedClass:Main, passedSemen:int) 
		{
			mainClass = passedClass;
			selectedSemen = passedSemen;
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
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenHome(mainClass));
										break;
			}
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
			
			setTextColor();
			removeChild(container);
			removeChild(mcShadeBtm);
			removeChild(mcShadeUp);
			getData();
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
			var sql:String = "select * from projectperformance where idsemen = " + selectedSemen + " order by lastEdit DESC"
			selectStmt.text = sql;
			
			selectStmt.addEventListener(SQLEvent.RESULT, getDataSuccess);
			selectStmt.addEventListener(SQLErrorEvent.ERROR, getDataError);
			
			selectStmt.execute();
		}
		
		private function getDataSuccess(event:SQLEvent):void {
			var result:SQLResult = selectStmt.getResult();
			var numResults:int;
			if (result.data!=null) {
				numResults = result.data.length; 
			}
			else {
				container = new MovieClip();
				mcShadeBtm = new McShadeBtm();
				mcShadeUp = new McShadeUp();
				mcShadeUp.height = btnBack.height;
				mcShadeUp.width -= 240;
				mcShadeUp.x = 80;
				mcShadeBtm.y = 580;
				addChild(container);
				addChild(mcShadeBtm);
				addChild(mcShadeUp);
				return;
			}
			
			container = new MovieClip();
			container.scrollRect = new Rectangle(0, 0, 650, numResults * 200 + 200);
			
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xff0000, 0.0); 
			square.graphics.drawRect(0, 0, 650, numResults * 200 + 200); 
			square.graphics.endFill(); 

			container.addChild(square);
			
			container.x = 420;
			container.y = 150;
			
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			format.align = "right";
			format.leading = -7;
			for (var i:int = 0; i < numResults; i++) 
			{ 
				var row:Object = result.data[i]; 				
				
				// Judul
				var txtJudul:TextField = new TextField();
				txtJudul.text = row.judul;		
				format.size = 28;
				txtJudul.setTextFormat(format); 
				txtJudul.embedFonts = true;
				txtJudul.y = i * 200;
				txtJudul.width = 300;
				txtJudul.autoSize = "right";
				txtJudul.multiline = true;
				txtJudul.wordWrap = true;
				txtJudul.selectable = false;
				
				container.addChild(txtJudul);
				
				// Summary
				var txtSum:TextField = new TextField();
				if (mainClass.bahasa) {
					txtSum.text = row.sumId;
				}
				else {
					if (row.sumEn == null || row.sumEn == "" || row.sumEn == "null") txtSum.text = row.sumId;
					else txtSum.text = row.sumEn;
				}
				format.size = 16;
				txtSum.setTextFormat(format); 
				txtSum.embedFonts = true;
				txtSum.y = 10 + txtJudul.y + txtJudul.height;
				txtSum.height = 80;
				txtSum.width = 300;
				txtSum.multiline = true;
				txtSum.wordWrap = true;
				txtSum.selectable = false;
				
				container.addChild(txtSum);
				
				// Gambar
				imageMC = new MovieClip();
				var myLoader:Loader = new Loader();
				var fileRequest:URLRequest;
				if (row.pathImg != null && row.pathImg.toString() != "" && row.pathImg.toString() != "null") {
					fileRequest = new URLRequest(row.pathImg);
					myLoader.load(fileRequest);
					myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
					imageMC.name = row.idpp;
					imageMC.addChild(myLoader);
					imageMC.addEventListener(MouseEvent.MOUSE_DOWN, btnProjHandler);
					
					imageMC.x = 320;
					imageMC.y = i * 200;
					
					container.addChild(imageMC);
				}
				else {
					fileRequest = new URLRequest("Images/default-pp.jpg");
					myLoader.load(fileRequest);
					myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
					imageMC.name = row.idpp;
					imageMC.addChild(myLoader);
					imageMC.addEventListener(MouseEvent.MOUSE_DOWN, btnProjHandler);
					
					imageMC.x = 320;
					imageMC.y = i * 200;
					
					container.addChild(imageMC);
				}
			} 
			container.alpha = 0;
			addChild(container);
			mcShadeBtm = new McShadeBtm();
			mcShadeBtm.y = 580;
			mcShadeBtm.mouseEnabled = false;
			addChild(mcShadeBtm);
			
			mcShadeUp = new McShadeUp();
			mcShadeUp.height = btnBack.height;
			mcShadeUp.width -= 240;
			mcShadeUp.x = 80;
			mcShadeUp.mouseEnabled = false;
			addChild(mcShadeUp);
			
			container.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
			//mcShadeBtm.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
			maxY = 150;
			minY = Math.min(0, 720 - container.height);
			
			containerAnimation();
		}
		
		private function onImageLoaded(e:Event):void {			
			var targetLoader:Loader = Loader(e.target.loader);
			targetLoader.width = 220;
			targetLoader.height = 165;
		}
				
		private function getDataError(event:SQLErrorEvent):void {
			
		}

		private function btnProjHandler(e:MouseEvent):void 
		{
			_clickHandlerY = container.y;
			e.currentTarget.addEventListener(MouseEvent.MOUSE_UP, btnClickHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void {
			var currentY:Number = container.y;
			if (_clickHandlerY == currentY) {
				whichProject = e.currentTarget.name;
				mainClass.showSplash(new ScreenPP2(mainClass, selectedSemen, whichProject));
			}
		}

		private function scrollHandler(event:MouseEvent):void {
			_startY = container.y;
			_startMouseY = mouseY;
			container.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}

		private function stage_mouseMoveHandler(event:MouseEvent):void
		{
			var offsetY:Number = mouseY - _startMouseY;
			container.y = Math.max(Math.min(maxY, _startY + offsetY), minY);
		}

		private function stage_mouseUpHandler(event:MouseEvent):void
		{
			container.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
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