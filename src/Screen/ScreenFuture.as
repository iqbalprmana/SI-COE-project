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
	public class ScreenFuture extends SCREEN_FUTURE
	{
		private var mainClass:Main;
		private var smallestID:int;
		
		private var selectStmt:SQLStatement;
		private var selectStmt2:SQLStatement;
		private var conn:SQLConnection;
		
		private var container:MovieClip;
		private var imageMC:MovieClip;
		
		private var container2:MovieClip;
		private var imageMC2:MovieClip;
		
		private var whichProject:int;
		private var maxY:Number;
		private var minY:Number;
		private var _startY:Number;
		private var _startMouseY:Number;
		private var maxY2:Number;
		private var minY2:Number;
		private var _startY2:Number;
		private var _startMouseY2:Number;
		
		private var nc:NetConnection;
		private var ns:NetStream;
		private var vid:Video;
		private var square2:MovieClip;
		public function ScreenFuture(passedClass:Main) 
		{
			mainClass = passedClass;
			init();
			
			var txtUnder:TextField = new TextField;
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			format.size = 40;
			txtUnder.text = "UNDER MAINTENANCE";
			txtUnder.width = 400;
			txtUnder.setTextFormat(format);
			txtUnder.embedFonts = true;
			txtUnder.x = 100;
			txtUnder.y = 90;
			txtUnder.selectable = false;
			addChild(txtUnder);
			
			/*
			smallestID = -1;
			inAnimation();
			*/
		}
		
		public function init():void
		{
			if (mainClass.bahasa) {
				mcFTRed.txtFTRed.text = "PROYEK MENDATANG";
			}
			else {
				mcFTRed.txtFTRed.text = "TO THE FUTURE";
			}
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenHome(mainClass));
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
			var sql:String = "select * from futureproject";
			selectStmt.text = sql;
			
			selectStmt.addEventListener(SQLEvent.RESULT, getDataSuccess);
			selectStmt.addEventListener(SQLErrorEvent.ERROR, getDataError);
			
			selectStmt.execute();
		}
		
		private function getDataSuccess(event:SQLEvent):void {
			var result:SQLResult = selectStmt.getResult();
			var numResults:int = result.data.length; 
			
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			format.size = 16;
			
			container = new MovieClip();
			container.scrollRect = new Rectangle(0, 0, 300, 70 * numResults);
			
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xff0000, 0.0); 
			square.graphics.drawRect(0, 0, 300, 70 * numResults); 
			square.graphics.endFill(); 
			square.name = "square";
			
			container.addChild(square);
			
			// make mask
			var square2:Shape = new Shape(); 
			square2.graphics.lineStyle(1, 0x000000, 0.0); 
			square2.graphics.beginFill(0xff0000); 
			square2.graphics.drawRect(1050, 220, 300, 450); 
			square2.graphics.endFill(); 
			square2.name = "square2";
			
			container.mask = square2;
			
			container.x = 1050;
			container.y = 220;
			
			var btnY:int = 0;
			for (var i:int = 0; i < numResults; i++) 
			{ 
				var row:Object = result.data[i]; 
				var txtTechDev:TextField = new TextField();
				txtTechDev.text = row.judul;
				
				// get the smallest id to be previewed
				if (smallestID == -1) {
					smallestID = int(row.idproyek);
				}
				else {
					if(smallestID > int(row.idproyek)) smallestID = int(row.idproyek);
				}
				
				txtTechDev.setTextFormat(format); 
				txtTechDev.embedFonts = true;
				txtTechDev.width = 215;
				//txtTechDev.y = i * 40;
				txtTechDev.autoSize = "right";
				txtTechDev.mouseEnabled = false;
				txtTechDev.multiline = true;
				txtTechDev.wordWrap = true;
				//txtTechDev.addEventListener(MouseEvent.CLICK, previewTech);
				txtTechDev.name = row.idproyek;
				
				var rectangleShape:Shape = new Shape();
				//rectangleShape.graphics.beginFill(0xFF0000);
				rectangleShape.graphics.drawRect(0, 0, txtTechDev.textWidth, txtTechDev.textHeight);
				//rectangleShape.graphics.endFill();
				
				var buttonSprite:Sprite = new Sprite();
				buttonSprite.addChild(rectangleShape);
				buttonSprite.addChild(txtTechDev);
				buttonSprite.y = btnY;
				btnY += rectangleShape.height + 20;
				buttonSprite.name = row.idproyek;
				buttonSprite.addEventListener(MouseEvent.CLICK, previewTech);
				
				// addchild ke movieclip
				container.addChild(buttonSprite);
			}
			container.alpha = 0;
			addChild(container);
			container.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
			maxY = 220;
			minY = Math.min(0, 720 - container.height);
			
			containerAnimation();
			previewFirstTech();
		}
		
		private function previewFirstTech():void {
			selectStmt2 = new SQLStatement();
			selectStmt2.sqlConnection = conn;
			var sql:String = "select * from futureproject where idproyek = " + smallestID;
			selectStmt2.text = sql;
			selectStmt2.addEventListener(SQLEvent.RESULT, previewDataSuccess);
			selectStmt2.execute();
			colorThat(smallestID.toString());
		}
		
		private function previewTech(e:MouseEvent):void {
			colorThat(e.currentTarget.name);
			removeChild(container2);
			selectStmt2.sqlConnection = conn;
			var sql:String = "select * from futureproject where idproyek = " + e.currentTarget.name;
			trace(sql);
			selectStmt2.text = sql;
			selectStmt2.addEventListener(SQLEvent.RESULT, previewDataSuccess);
			selectStmt2.execute();
		}
		
		private function colorThat(which:String) {
			var buttonSprite:Sprite;
			var txtTechDev:TextField;
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF;
			
			var theName:String;
			// color all white
			for (var i:int = 0; i < container.numChildren; i++) {
				if(container.getChildAt(i).name != "square" &&  container.getChildAt(i).name != "square2"){
					buttonSprite = Sprite(container.getChildAt(i));
					theName = container.getChildAt(i).name;
					txtTechDev = TextField(buttonSprite.getChildByName(theName));
					txtTechDev.setTextFormat(format);
				}
			}
			
			// color RED
			format.color = 0xC01F2D;
			buttonSprite = Sprite(container.getChildByName(which));
			txtTechDev = TextField(buttonSprite.getChildByName(which));
			txtTechDev.setTextFormat(format);
		}
		
		private function previewDataSuccess(e:SQLEvent):void {
			var result:SQLResult = selectStmt2.getResult();
			var row:Object = result.data[0]; 
			
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			format.size = 16;
			
			// Artikel // dibutuhkan untuk menghitung height container
			var txtArt:TextField = new TextField();
			if (mainClass.bahasa) txtArt.text = row.artikelId;
			else txtArt.text = row.artikelEn;
			txtArt.setTextFormat(format); 
			txtArt.embedFonts = true;
			txtArt.width = 400;
			txtArt.autoSize = "left";
			txtArt.multiline = true;
			txtArt.wordWrap = true;
			txtArt.selectable = false;
			
			container2 = new MovieClip();
			container2.scrollRect = new Rectangle(0, 0, 870, 500 + txtArt.height);
			
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xff0000, 0.0); 
			square.graphics.drawRect(0, 0, 870, 500 + txtArt.height); 
			square.graphics.endFill(); 

			container2.addChild(square);
			
			container2.x = 90;
			container2.y = 100;
			
			// Judul
			var txtJudul:TextField = new TextField();
			txtJudul.text = row.judul;
			format.size = 48;
			format.leading = -20;
			format.indent = 0;
			format.align = "left";
			txtJudul.setTextFormat(format); 
			txtJudul.embedFonts = true;
			txtJudul.y = 200;
			txtJudul.x = 470;
			txtJudul.width = 400;
			txtJudul.autoSize = "left";
			txtJudul.multiline = true;
			txtJudul.wordWrap = true;
			txtJudul.selectable = false;
			
			// Summary
			var txtSum:TextField = new TextField();
			if (mainClass.bahasa) txtSum.text = row.sumId;
			else txtSum.text = row.sumEn;
			format.color = 0xFFFFFF; 
			format.align = "right";
			format.size = 21;
			format.leading = 0;
			txtSum.setTextFormat(format); 
			txtSum.embedFonts = true;
			txtSum.x = 55;
			txtSum.y = 325;
			txtSum.width = 400;
			txtSum.autoSize = "right";
			txtSum.multiline = true;
			txtSum.wordWrap = true;
			txtSum.selectable = false;
			
			// Gambar
			imageMC2 = new MovieClip();
			var myLoader:Loader = new Loader();
			var fileRequest:URLRequest = new URLRequest(row.pathImg);
			myLoader.load(fileRequest);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imageMC2.addChild(myLoader);
			imageMC2.y = 10;
			imageMC2.x = 0;
			
			// Artikel
			txtArt.y = txtJudul.y + txtJudul.height + 20;
			txtArt.x = 470;
			
			// addchild ke movieclip
			container2.addChild(txtJudul);
			container2.addChild(txtSum);
			container2.addChild(imageMC2);
			container2.addChild(txtArt);
			
			container2.alpha = 0;
			addChild(container2);
			container2.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler2);
			maxY2 = 150;
			minY2 = Math.min(0, 720 - container2.height);
			
			container2Animation();
		}
		
		private function onImageLoaded(e:Event):void {			
			var targetLoader:Loader = Loader(e.target.loader);
			targetLoader.width = 460;
			targetLoader.height = 300;
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
			mcFTRed.alpha = 0;
			mcLine.alpha = 0;
			
			btnBack.scaleX = 0.8;
			mcFTRed.scaleX = 0.8;
			mcLine.scaleX = 0.8;
			
			btnBack.scaleY = 0.8;
			mcFTRed.scaleY = 0.8;
			mcLine.scaleY = 0.8;
			
			TweenLite.to(btnBack, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.5, ease:Circ.easeOut, onComplete: inAnim2()} );
		}
		
		private function inAnim2():void {
			TweenLite.to(mcLine, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.3, ease:Circ.easeOut, onComplete: inAnim3()} );
		}
		
		private function inAnim3():void {
			TweenLite.to(mcFTRed, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.2, ease:Circ.easeOut } );
			conn = new SQLConnection();
			loadDb();
		}
		
		private function containerAnimation():void {
			TweenLite.to(container, 0.5, { alpha:1, delay: 0.4, ease:Circ.easeOut } );
		}
		private function container2Animation():void {
			TweenLite.to(container2, 0.5, { alpha:1, delay: 0.4, ease:Circ.easeOut } );
		}
	}

}
