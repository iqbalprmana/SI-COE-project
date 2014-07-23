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
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
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
	public class ScreenTechDev1 extends SCREEN_TECHDEV1
	{
		private var mainClass:Main;
		
		private var imageMC:MovieClip;			// images
		private var container:MovieClip;		// the rectangle container containing images
		private var containerAll:MovieClip;		// container containing container and texts
		private var viewedChildIndex:int;		// index of viewed Tech Dev
		private var originalX:Number;
		
		private var selectStmt:SQLStatement;		
		private var conn:SQLConnection;
		
		// scroll tech dev
		private var whichProject:int;
		private var viewedProject:int;
		private var maxX:Number;
		private var minX:Number;
		private var _startX:Number;
		private var _startMouseX:Number;
		private var _clickHandlerX:Number;
		
		public function ScreenTechDev1(passedClass:Main) 
		{
			mainClass = passedClass;
			inAnimation();
		}
		
		public function init():void
		{
			if (mainClass.bahasa) {
				mcTDRed.txtTDRed.text = "PENGEMBANGAN\nTEKNOLOGI";
			}
			else {
				mcTDRed.txtTDRed.text = "TECHNOLOGY\nDEVELOPMENT";
			}
			
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : /*ns.close(); */mainClass.showSplash(new ScreenHome(mainClass));
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
			var sql:String = "select * from techdev order by lastEdit DESC"
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
				btnPrev.visible = false;
				btnNext.visible = false;
				return;
			}
			
			container = new MovieClip();
			containerAll = new MovieClip();
			containerAll.scrollRect = new Rectangle(0, 0, numResults * 800, 700);
			
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xff0000, 0.0); 
			square.graphics.drawRect(0, 0, numResults * 800, 700);
			square.graphics.endFill(); 

			containerAll.addChild(square);
			containerAll.addChild(container);
			
			containerAll.x = 360;
			containerAll.y = 100;
			
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			format.leading = -7;
			for (var i:int = 0; i < numResults; i++) 
			{ 
				var row:Object = result.data[i]; 				
				
				// Gambar
				imageMC = new MovieClip();
				var myLoader:Loader = new Loader();
				var fileRequest:URLRequest;
				if (row.pathImg != null && row.pathImg.toString() != "" && row.pathImg.toString() != "null") {
					fileRequest = new URLRequest(row.pathImg);
				}
				else {
					fileRequest = new URLRequest("Images/default-td.jpg");
				}
				myLoader.load(fileRequest);
				myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				imageMC.name = row.idtd;
				imageMC.addChild(myLoader);
				imageMC.addEventListener(MouseEvent.MOUSE_DOWN, btnProjHandler);
				
				imageMC.x = i * 700;
				imageMC.y = 50;
				
				container.addChild(imageMC);
				
				// Judul
				var txtJudul:TextField = new TextField();
				txtJudul.text = row.judul;		
				format.size = 18;
				txtJudul.setTextFormat(format); 
				txtJudul.embedFonts = true;
				txtJudul.y = 450;
				txtJudul.x = imageMC.x;
				txtJudul.width = 520;
				txtJudul.autoSize = "left";
				txtJudul.multiline = true;
				txtJudul.wordWrap = true;
				txtJudul.selectable = false;
				
				containerAll.addChild(txtJudul);
				
				// Semen
				var txtSemen:TextField = new TextField();
				if (row.idsemen == 1) txtSemen.text = "SEMEN GRESIK";
				else if (row.idsemen == 2) txtSemen.text = "SEMEN PADANG";
				else if (row.idsemen == 3) txtSemen.text = "SEMEN TONASA";
				else if (row.idsemen == 4) txtSemen.text = "SEMEN THANGLONG";
				else if (row.idsemen == 5) txtSemen.text = "SEMEN INDONESIA";
				
				txtSemen.setTextFormat(format); 
				txtSemen.embedFonts = true;
				txtSemen.y = 5 + txtJudul.y + txtJudul.height;
				txtSemen.x = imageMC.x;
				txtSemen.width = 200;
				txtSemen.autoSize = "left";
				txtSemen.selectable = false;
				
				containerAll.addChild(txtSemen);
				
				// Label Period
				var txtLabelPeriod:TextField = new TextField();
				txtLabelPeriod.text = "PERIOD";
				format.color = 0xD4D4D4;
				format.size = 16;
				txtLabelPeriod.setTextFormat(format); 
				txtLabelPeriod.embedFonts = true;
				txtLabelPeriod.y = 5 + txtSemen.y + txtSemen.height;
				txtLabelPeriod.x = imageMC.x;
				txtLabelPeriod.selectable = false;
				
				containerAll.addChild(txtLabelPeriod);
				
				// Period
				var txtPeriod:TextField = new TextField();
				txtPeriod.text = row.period;
				format.color = 0xFFFFFF;
				txtPeriod.setTextFormat(format); 
				txtPeriod.embedFonts = true;
				txtPeriod.y = txtLabelPeriod.y;
				txtPeriod.x = txtLabelPeriod.x + 100;
				txtPeriod.selectable = false;
				
				containerAll.addChild(txtPeriod);
			} 
			containerAll.alpha = 0;
			addChild(containerAll);
			
			if(container.numChildren > 1){
				containerAll.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
				maxX = containerAll.x;
				minX = Math.min(0, 1280 - containerAll.width);
			}
			
			// customize the look of container
			toggleBtnNavigationVisible();
			originalX = 0;
			//viewedProject = 0;
			btnPrev.addEventListener(MouseEvent.CLICK, viewImgPrev);
			btnNext.addEventListener(MouseEvent.CLICK, viewImgNext);
			
			viewedChildIndex = 0;	// view the first Tech Dev
			container.getChildAt(0).y = 0;
			container.getChildAt(0).scaleX = 1.2;
			container.getChildAt(0).scaleY = 1.2;
			
			setChildIndex(containerAll, numChildren - 1);
			setChildIndex(btnPrev, numChildren - 1);
			setChildIndex(btnNext, numChildren - 1);
			setChildIndex(btnBack, numChildren - 1);
			setChildIndex(mcTDRed, numChildren - 1);
			
			containerAllAnimation();
			container.cacheAsBitmap = true;
			containerAll.cacheAsBitmap = true;
		}
		
		private function onImageLoaded(e:Event):void {			
			var targetLoader:Loader = Loader(e.target.loader);
			targetLoader.width = 520;
			targetLoader.height = 350;
		}
		
		private function getDataError(event:SQLErrorEvent):void {
			
		}
		
		private function viewImgPrev(e:MouseEvent):void 
		{
			var toBePreviewed:int = viewedChildIndex - 1;
			animateShrink(viewedChildIndex);
			originalX = toBePreviewed * 700;
			animateExpand(toBePreviewed);
			viewedChildIndex--;
			var newX:Number = getXPosMiddle();
			TweenLite.to(containerAll, 1, { x:newX, delay: 0.2, ease:Circ.easeOut } );
			toggleBtnNavigationVisible();
		}
		
		private function viewImgNext(e:MouseEvent):void 
		{
			var toBePreviewed:int = viewedChildIndex + 1;
			animateShrink(viewedChildIndex);
			originalX = toBePreviewed * 700;
			animateExpand(toBePreviewed);
			viewedChildIndex++;
			var newX:Number = getXPosMiddle();
			TweenLite.to(containerAll, 1, { x:newX, delay: 0.2, ease:Circ.easeOut } );
			toggleBtnNavigationVisible();
		}
		
		private function getXPosMiddle():Number {
			if (viewedChildIndex == 0) return 360;
			else if (viewedChildIndex == 1) return (-340);
			else {
				return (0 - 340 - ((viewedChildIndex - 1) * 700));
			}
		}
		
		private function toggleBtnNavigationVisible():void {
			if (viewedChildIndex < container.numChildren - 1) {
				btnNext.visible = true;
			}
			else {
				btnNext.visible = false;
			}
			
			if (viewedChildIndex > 0) {
				btnPrev.visible = true;
			}
			else {
				btnPrev.visible = false;
			}
		}
		
		private function animateExpand(which:int):void 
		{
			TweenLite.to(container.getChildAt(which), 1, { y:0, x:originalX - 50, scaleX:1.2, scaleY:1.2, delay: 0.2, ease:Circ.easeOut } );
		}
		
		private function animateShrink(which:int):void 
		{
			TweenLite.to(container.getChildAt(which), 1, { y:50, x:originalX, scaleX:1, scaleY:1, delay: 0.2, ease:Circ.easeOut } );
		}
		
		private function btnProjHandler(e:MouseEvent):void 
		{
			_clickHandlerX = containerAll.x;
			e.currentTarget.addEventListener(MouseEvent.MOUSE_UP, btnClickHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void {
			var currentX:Number = containerAll.x;
			if (_clickHandlerX == currentX) {
				whichProject = e.currentTarget.name;
				mainClass.showSplash(new ScreenTechDev2(mainClass, e.currentTarget.name));
			}
		}
		
		private function scrollHandler(event:MouseEvent):void {
			_startX = containerAll.x;
			_startMouseX = mouseX;
			containerAll.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}

		private function stage_mouseMoveHandler(event:MouseEvent):void
		{
			var offsetX:Number = mouseX - _startMouseX;
			containerAll.x = Math.max(Math.min(maxX, _startX + offsetX), minX);
			
			// tentukan nomor tech dev yang lagi di tengah
			if (containerAll.x >= 0 || containerAll.x > -200) {
				var toBePreviewed:int = 0;
				if (toBePreviewed != viewedChildIndex) {
					animateShrink(viewedChildIndex);
					originalX = 0;
					animateExpand(toBePreviewed);
					viewedChildIndex--;
					toggleBtnNavigationVisible();
				}
			}
			else {
				var nanana:Number = 0 - containerAll.x + 340;
				var toBePreviewed:int = Math.round(nanana / 700);
				if(toBePreviewed >= 0 && toBePreviewed < container.numChildren){
					if (toBePreviewed < viewedChildIndex) {
						animateShrink(viewedChildIndex);
						originalX = toBePreviewed * 700;
						animateExpand(toBePreviewed);
						viewedChildIndex--;
						toggleBtnNavigationVisible();
					}
					else if (toBePreviewed > viewedChildIndex) {
						animateShrink(viewedChildIndex);
						originalX = toBePreviewed * 700;
						animateExpand(toBePreviewed);
						viewedChildIndex++;
						toggleBtnNavigationVisible();
					}
				}
			}
		}

		private function stage_mouseUpHandler(event:MouseEvent):void
		{
			containerAll.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		private function inAnimation():void {
			btnBack.alpha = 0;
			mcTDRed.alpha = 0;
			
			btnBack.scaleX = 0.8;
			mcTDRed.scaleX = 0.8;
			
			btnBack.scaleY = 0.8;
			mcTDRed.scaleY = 0.8;
			
			TweenLite.to(btnBack, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.3, ease:Circ.easeOut, onComplete: inAnim2()} );
		}
		
		private function inAnim2():void {
			TweenLite.to(mcTDRed, 0.5, { alpha:1, scaleY:1, scaleX:1, delay: 0.2 } );
			init();
			conn = new SQLConnection();
			loadDb();
		}
		
		private function containerAllAnimation():void {
			TweenLite.to(containerAll, 0.5, {alpha:1, delay: 1.0, ease:Circ.easeOut});
		}
		
	}

}