package Screen 
{
	import Asset.McOrStrukturDIRHead;
	
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
	public class ScreenOrg0 extends SCREEN_ORG0
	{
		private var mainClass:Main;		
		
		// db
		private var selectStmt:SQLStatement;		
		private var selectEmpStmt:SQLStatement;
		private var conn:SQLConnection;
		
		// gambar dan deskripsi
		private var imageMC:MovieClip;
		
		// struktur
		private var struktur_container:MovieClip;
		private var struktur_head:McOrStrukturDIRHead;
		private var container:MovieClip;
		
		public function ScreenOrg0(passedClass:Main) 
		{
			mainClass = passedClass;
			init();
			inAnimation();
		}
		
		public function init():void
		{
			var formatActive:TextFormat = new TextFormat(); 
			formatActive.color = 0xC01F2D; 
			btnDIR.txtDIR.setTextFormat(formatActive);
			
			if (mainClass.bahasa) {
				mcORRed.txtORRed.text = "STRUKTUR\nORGANISASI";
			}
			else {
				mcORRed.txtORRed.text = "ORGANIZATION\nSTRUCTURE";
			}
			
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			
			btnDE.addEventListener(MouseEvent.CLICK, navHandler);
			btnEPI.addEventListener(MouseEvent.CLICK, navHandler);
			btnPSPM.addEventListener(MouseEvent.CLICK, navHandler);
			btnPM.addEventListener(MouseEvent.CLICK, navHandler);
			btnPM2.addEventListener(MouseEvent.CLICK, navHandler);
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenHome(mainClass));
										break;
				case "btnDE" : mainClass.showSplash(new ScreenOrg1(mainClass));
										break;
				case "btnPSPM" : mainClass.showSplash(new ScreenOrg2(mainClass));
										break;
				case "btnEPI" : mainClass.showSplash(new ScreenOrg3(mainClass));
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
			var sql:String = "select * from department where iddept = 0";
			
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
			imageMC.y = 50;
			imageMC.x = 100;
			
			// struktur organisasi
			// ambil data dari EMPLOYEE
			getDataEmp();
		}
				
		private function onImageLoaded(e:Event):void {			
			var targetLoader:Loader = Loader(e.target.loader);
			targetLoader.width = 300;
			targetLoader.height = 297;
		}
		
		private function getDataError(event:SQLErrorEvent):void {
			
		}
		
		private function getDataEmp():void {
			selectEmpStmt = new SQLStatement();
			selectEmpStmt.sqlConnection = conn;
			var sql:String = "SELECT * FROM employee WHERE iddept = 0 ORDER BY idsubdept ASC";
			selectEmpStmt.text = sql;
			selectEmpStmt.addEventListener(SQLEvent.RESULT, getDataEmpSuccess);
			selectEmpStmt.execute();
		}
		
		private function getDataEmpSuccess(event:SQLEvent):void {
			var result:SQLResult = selectEmpStmt.getResult();
			var numResults:int = result.data.length; 
			
			struktur_container = new MovieClip;
			struktur_head = new McOrStrukturDIRHead;
			
			struktur_head.y = 100;
			struktur_head.x = 550;
			
			struktur_container.addChild(struktur_head);
			
			var nameFormat:TextFormat = new TextFormat(); 
			nameFormat.color = 0xFFFFFF; 
			nameFormat.font = "myFont"; 
			nameFormat.size = 20;
			
			var infoFormat:TextFormat = new TextFormat(); 
			infoFormat.color = 0xFFFFFF; 
			infoFormat.font = "myFont"; 
			infoFormat.size = 15;
			
			// sort the employees, make each empButton, add to struktur_container
			var posX:Number = struktur_head.x;
			var posY:Number = struktur_head.y + struktur_head.height + 20;
			var empButton:MovieClip;
			for (var i:int = 0; i < numResults; i++) 
			{ 
				var row:Object = result.data[i]; 
				
				// nama
				/*
				var empName:TextField = new TextField();
				empName.text = row.nama;
				empName.setTextFormat(nameFormat); 
				empName.embedFonts = true;
				empName.width = 200;
				empName.selectable = false;
				empName.x = 5;
				empName.y = 5;
				*/
				// jabatan
				var empRole:TextField = new TextField();
				if (row.jabatanEn != null && row.jabatanEn != "" && row.jabatanEn != "null") {
					empRole.text = row.jabatanEn;
				}
				else {
					empRole.text = "-";
				}
				
				//empRole.setTextFormat(infoFormat); 
				empRole.setTextFormat(nameFormat); 
				empRole.embedFonts = true;
				empRole.width = 200;
				empRole.selectable = false;
				empRole.x = 5;
				//empRole.y = 25;
				empRole.y = 5;
				
				var empBtnBorder:Shape = new Shape();
				empBtnBorder.graphics.lineStyle(1, 0xFFFFFF, 1.0); 
				empBtnBorder.graphics.beginFill(0xFF0000, 0.0);
				empBtnBorder.graphics.drawRect(0, 0, struktur_head.width, struktur_head.height/2);
				empBtnBorder.graphics.endFill();
				
				empButton = new MovieClip();
				empButton.addChild(empBtnBorder);
				//empButton.addChild(empName);
				empButton.addChild(empRole);
				
				if (row.idsubdept == "0") { // if general manager
					empButton.x = posX;
					empButton.y = posY;
					posY += 130;
				}
				else {
					empButton.x = posX;
					empButton.y = posY;
					posY += 130;
				}
				
				empButton.name = row.idemp;
				empButton.addEventListener(MouseEvent.CLICK, empClickHandler);
				struktur_container.addChild(empButton);
			}
			
			// make container
			container = new MovieClip();
			
			// make scrollable area
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xcc0000, 0.0); 
			trace(struktur_container.width + 100);
			square.graphics.drawRect(0, 0, 900, struktur_container.height + 500); 
			square.graphics.endFill(); 
			
			container.addChild(square);
			
			// make mask
			var square2:Shape = new Shape(); 
			square2.graphics.lineStyle(1, 0x000000, 0.0); 
			square2.graphics.beginFill(0xff0000, 0.0); 
			square2.graphics.drawRect(90, 175, 900, 600); 
			square2.graphics.endFill(); 
			
			container.mask = square2;
			
			container.x = 90;
			container.y = 175;
			
			// addchild ke container
			container.addChild(imageMC);
			container.addChild(struktur_container);
				
			addChild(container);
		}
		
		private function empClickHandler(e:MouseEvent):void {
			mainClass.showSplash(new ScreenOrgP(mainClass, 0, int(e.currentTarget.name)));
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