package Screen 
{
	import Asset.McOrStruktur4;
	import Asset.McOrStruktur5;
	import Asset.McOrStrukturDEHead;
	import Asset.McOrStrukturDESub;
	import Asset.McOrStrukturPSHead;
	import Asset.McOrStrukturEKHead;
	import Asset.McOrStrukturEKSub;
	import Asset.McOrStrukturPMHead;
	import Asset.McOrStrukturPM2Head;
	
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
	public class ScreenOrgStructure extends SCREEN_ORGS
	{
		private var mainClass:Main;	
		private var whichDept:int;
		
		// db
		private var selectStmt:SQLStatement;		
		private var selectEmpStmt:SQLStatement;
		private var conn:SQLConnection;
		
		// struktur
		private var struktur_container:MovieClip;
		private var struktur_head:McOrStrukturDEHead;
		private var struktur_sub:McOrStrukturDESub;
		private var struktur_head_PS:McOrStrukturPSHead;
		private var struktur_head_EPI:McOrStrukturEKHead;
		private var struktur_sub_EPI:McOrStrukturEKSub;
		//private var struktur_head_PM:McOrStrukturPMHead;
		//private var struktur_head_PM2:McOrStrukturPM2Head;
		private var struktur_PM:McOrStruktur4;
		private var struktur_PM2:McOrStruktur5;
		
		private var nameFormat:TextFormat;
		private var infoFormat:TextFormat;
			
		// scroll
		private var container:MovieClip;
		private var maxY:Number;
		private var minY:Number;
		private var _startY:Number;
		private var _startMouseY:Number;
		private var _clickHandlerY:Number;
		
		public function ScreenOrgStructure(passedClass:Main, passedDept:int) 
		{
			mainClass = passedClass;
			whichDept = passedDept;
			init();
			conn = new SQLConnection();
			loadDb();
		}
		
		public function init():void
		{
			/*
			if (mainClass.bahasa) {
				mcORRed.txtORRed.text = "STRUKTUR\nORGANISASI";
			}
			else {
				mcORRed.txtORRed.text = "ORGANIZATION\nSTRUCTURE";
			}
			*/
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			
			// format
			nameFormat = new TextFormat(); 
			nameFormat.color = 0xFFFFFF; 
			nameFormat.font = "myFont"; 
			nameFormat.size = 16;
			nameFormat.leading = -7;
			
			infoFormat = new TextFormat(); 
			infoFormat.color = 0xFFFFFF; 
			infoFormat.font = "myFont"; 
			infoFormat.size = 15;
		}
		
		private function navHandler(e:MouseEvent):void {
			if (whichDept == 1){mainClass.showSplash(new ScreenOrg1(mainClass));}
			else if (whichDept == 2) { mainClass.showSplash(new ScreenOrg2(mainClass)); }
			else if (whichDept == 3) { mainClass.showSplash(new ScreenOrg3(mainClass)); }
			else if (whichDept == 4) { mainClass.showSplash(new ScreenOrg4(mainClass)); }
			else if (whichDept == 5) { mainClass.showSplash(new ScreenOrg5(mainClass)); }
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
			if (whichDept == 1) getDataEmp1();
			else if (whichDept == 2) getDataEmpPS();
			else if (whichDept == 3) getDataEmpEPI();
			else if (whichDept == 4) getDataEmpPM();
			else if (whichDept == 5) getDataEmpPM2();
		}
		
		private function errorHandler(event:SQLErrorEvent):void {
			
		}
		
		private function getDataEmp1():void {
			selectEmpStmt = new SQLStatement();
			selectEmpStmt.sqlConnection = conn;
			var sql:String = "SELECT * FROM employee WHERE iddept = 1 ORDER BY idsubdept ASC";
			selectEmpStmt.text = sql;
			selectEmpStmt.addEventListener(SQLEvent.RESULT, getDataEmp1Success);
			selectEmpStmt.execute();
			trace("yeah");
		}
		
		private function getDataEmp1Success(event:SQLEvent):void {
			trace("yeahsss");
			var result:SQLResult = selectEmpStmt.getResult();
			var numResults:int = result.data.length; 
			
			struktur_container = new MovieClip;
			struktur_head = new McOrStrukturDEHead;
			struktur_sub = new McOrStrukturDESub;
			
			struktur_head.y = 0;
			struktur_head.x = 500;
			struktur_sub.y = struktur_head.y + struktur_head.height + 55;
			struktur_sub.x = 20;
			
			struktur_container.addChild(struktur_head);
			struktur_container.addChild(struktur_sub);
			
			// sort the employees, make each empButton, add to struktur_container
			var posX:Number = struktur_sub.x;
			var posY:Number = struktur_sub.y + struktur_sub.height + 10;
			var subDept:int = 0;
			var empButton:MovieClip;
			for (var i:int = 0; i < numResults; i++) 
			{ 
				var row:Object = result.data[i]; 
				/*
				// nama
				var empName:TextField = new TextField();
				empName.text = row.nama;
				empName.setTextFormat(nameFormat); 
				empName.embedFonts = true;
				empName.width = 210;
				empName.autoSize = "left";
				empName.multiline = true;
				empName.wordWrap = true;
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
				empRole.autoSize = "left";
				empRole.multiline = true;
				empRole.wordWrap = true;
				empRole.selectable = false;
				empRole.x = 5;
				//empRole.y = empName.y + empName.height;
				empRole.y = 10;
				
				var empBtnBorder:Shape = new Shape();
				empBtnBorder.graphics.lineStyle(1, 0xFFFFFF, 1.0); 
				empBtnBorder.graphics.beginFill(0xFF0000, 0.0);
				empBtnBorder.graphics.drawRect(0, 0, 220, 50);
				empBtnBorder.graphics.endFill();
				
				empButton = new MovieClip();
				empButton.addChild(empBtnBorder);
				//empButton.addChild(empName);
				empButton.addChild(empRole);
				
				if (subDept == int(row.idsubdept)) {
					if (row.idsubdept == "0") { // if general manager
						empButton.x = struktur_head.x;
						empButton.y = struktur_head.y + struktur_head.height + 5;
						//trace(empButton.x + " " + empButton.y);
						subDept++;
					}
					else {
						empButton.x = posX;
						empButton.y = posY;
						posY += 55;
						//trace(empButton.x + " " + empButton.y);
					}
				}
				else {
					posX += 240; // reset posX, posY
					posY = struktur_sub.y + struktur_sub.height + 10;
					empButton.x = posX;
					empButton.y = posY;
					posY += 55;
					//trace(empButton.x + " " + empButton.y);
					subDept++;
				}
				empButton.name = row.idemp;
				empButton.addEventListener(MouseEvent.MOUSE_DOWN, empClickHandler);
				struktur_container.addChild(empButton);
			}
			
			// make container
			container = new MovieClip();
			//container.scrollRect = new Rectangle(0, 0, 1200, struktur_container.height + 100);
			
			/*
			// make scrollable area
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xff0000, 0.0); 
			square.graphics.drawRect(0, 0, 1200, struktur_container.height + 100); 
			square.graphics.endFill(); 
			
			// make mask
			var square2:Shape = new Shape(); 
			square2.graphics.lineStyle(1, 0x000000, 0.0); 
			square2.graphics.beginFill(0xff0000, 0.1); 
			square2.graphics.drawRect(50, 175, 1200, 700); 
			square2.graphics.endFill(); 
			
			container.mask = square2;
			
			container.addChild(square);
			*/
			container.x = 30;
			container.y = 20;
			
			// addchild ke container
			container.addChild(struktur_container);
			addChild(container);
			
			//container.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
			maxY = 175;
			minY = Math.min(0, 720 - container.height);
		}
		
		
		private function getDataEmpPS():void {
			selectEmpStmt = new SQLStatement();
			selectEmpStmt.sqlConnection = conn;
			var sql:String = "SELECT * FROM employee WHERE iddept = 2 ORDER BY idsubdept ASC";
			selectEmpStmt.text = sql;
			selectEmpStmt.addEventListener(SQLEvent.RESULT, getDataEmpPSSuccess);
			selectEmpStmt.execute();
		}
		
		private function getDataEmpPSSuccess(event:SQLEvent):void {
			var result:SQLResult = selectEmpStmt.getResult();
			var numResults:int = result.data.length; 
			
			struktur_container = new MovieClip;
			struktur_head_PS = new McOrStrukturPSHead;
			
			struktur_head_PS.y = 50;
			struktur_head_PS.x = 452;
			
			struktur_container.addChild(struktur_head_PS);
			
			// sort the employees, make each empButton, add to struktur_container
			var posX:Number = struktur_head_PS.x;
			var posY:Number = struktur_head_PS.y + struktur_head_PS.height + 20;
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
				empName.width = 210;
				empName.autoSize = "left";
				empName.multiline = true;
				empName.wordWrap = true;
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
				
				empRole.setTextFormat(nameFormat); 
				//empRole.setTextFormat(infoFormat); 
				empRole.embedFonts = true;
				empRole.width = 200;
				empRole.autoSize = "left";
				empRole.multiline = true;
				empRole.wordWrap = true;
				empRole.selectable = false;
				empRole.x = 5;
				//empRole.y = empName.y + empName.height;
				empRole.y = 3;
				
				var empBtnBorder:Shape = new Shape();
				empBtnBorder.graphics.lineStyle(1, 0xFFFFFF, 1.0); 
				empBtnBorder.graphics.beginFill(0xFF0000, 0.0);
				empBtnBorder.graphics.drawRect(0, 0, 220, 50);
				empBtnBorder.graphics.endFill();
				
				empButton = new MovieClip();
				empButton.addChild(empBtnBorder);
				//empButton.addChild(empName);
				empButton.addChild(empRole);
				
				if (row.idsubdept == "0") { // if general manager
					empButton.x = posX;
					empButton.y = posY;
					posY += 60;
				}
				else {
					empButton.x = posX;
					empButton.y = posY;
					posY += 60;
				}
				
				empButton.name = row.idemp;
				empButton.addEventListener(MouseEvent.MOUSE_DOWN, empClickHandler);
				struktur_container.addChild(empButton);
			}
			
			// make "Staf" employee
			var stafName:TextField = new TextField();
			stafName.text = "Staf";
			stafName.setTextFormat(nameFormat); 
			stafName.embedFonts = true;
			stafName.width = 200;
			stafName.selectable = false;
			stafName.x = 5;
			stafName.y = 5;
				
			var stafBorder:Shape = new Shape();
			stafBorder.graphics.lineStyle(1, 0xFFFFFF, 1.0); 
			stafBorder.graphics.beginFill(0xFF0000, 0.0);
			stafBorder.graphics.drawRect(0, 0, 220, 60);
			stafBorder.graphics.endFill();
			
			empButton = new MovieClip();
			empButton.addChild(stafBorder);
			empButton.addChild(stafName);
			empButton.x = posX;
			empButton.y = posY;
			struktur_container.addChild(empButton);
			
			// make container
			container = new MovieClip();
			/*
			container.scrollRect = new Rectangle(0, 0, 900, struktur_container.height + 100);
			
			// make scrollable area
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xcc0000, 0.0); 
			//trace(struktur_container.width + 100);
			square.graphics.drawRect(0, 0, 900, struktur_container.height + 100); 
			square.graphics.endFill(); 
			
			container.addChild(square);
			
			// make mask
			var square2:Shape = new Shape(); 
			square2.graphics.lineStyle(1, 0x000000, 0.0); 
			square2.graphics.beginFill(0xff0000, 0.0); 
			square2.graphics.drawRect(90, 175, 900, 600); 
			square2.graphics.endFill(); 
			
			container.mask = square2;
			*/
			
			container.x = 90;
			container.y = 175;
			
			// addchild ke container
			container.addChild(struktur_container);
				
			addChild(container);
			
			//container.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
			maxY = 175;
			minY = Math.min(0, 720 - container.height);
		}
		
		private function getDataEmpEPI():void {
			selectEmpStmt = new SQLStatement();
			selectEmpStmt.sqlConnection = conn;
			var sql:String = "SELECT * FROM employee WHERE iddept = 3 ORDER BY idsubdept ASC";
			selectEmpStmt.text = sql;
			selectEmpStmt.addEventListener(SQLEvent.RESULT, getDataEmpEPISuccess);
			selectEmpStmt.execute();
		}
		
		private function getDataEmpEPISuccess(event:SQLEvent):void {
			var result:SQLResult = selectEmpStmt.getResult();
			var numResults:int = result.data.length; 
			
			struktur_container = new MovieClip;
			struktur_head_EPI = new McOrStrukturEKHead;
			struktur_sub_EPI = new McOrStrukturEKSub;
			
			struktur_head_EPI.y = 0;
			struktur_head_EPI.x = 452;
			struktur_sub_EPI.y = struktur_head_EPI.y + struktur_head_EPI.height + 60;
			struktur_sub_EPI.x = 322;
			
			struktur_container.addChild(struktur_head_EPI);
			struktur_container.addChild(struktur_sub_EPI);
			
			// sort the employees, make each empButton, add to struktur_container
			var posX:Number = struktur_sub_EPI.x;
			var posY:Number = struktur_sub_EPI.y + struktur_sub_EPI.height + 10;
			var subDept:int = 0;
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
				empName.width = 210;
				empName.autoSize = "left";
				empName.multiline = true;
				empName.wordWrap = true;
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
				empRole.autoSize = "left";
				empRole.multiline = true;
				empRole.wordWrap = true;
				empRole.selectable = false;
				empRole.x = 5;
				//empRole.y = empName.y + empName.height;
				empRole.y = 3;
				
				var empBtnBorder:Shape = new Shape();
				empBtnBorder.graphics.lineStyle(1, 0xFFFFFF, 1.0); 
				empBtnBorder.graphics.beginFill(0xFF0000, 0.0);
				empBtnBorder.graphics.drawRect(0, 0, 220, 50);
				empBtnBorder.graphics.endFill();
				
				empButton = new MovieClip();
				empButton.addChild(empBtnBorder);
				//empButton.addChild(empName);
				empButton.addChild(empRole);
				
				if (subDept == int(row.idsubdept)) {
					if (row.idsubdept == "0") { // if general manager
						empButton.x = struktur_head_EPI.x;
						empButton.y = struktur_head_EPI.y + struktur_head_EPI.height + 5;
						//trace(empButton.x + " " + empButton.y);
						subDept++;
					}
					else {
						empButton.x = posX;
						empButton.y = posY;
						posY += 60;
						//trace(empButton.x + " " + empButton.y);
					}
				}
				else {
					posX += 260; // reset posX, posY
					posY = struktur_sub_EPI.y + struktur_sub_EPI.height + 10;
					empButton.x = posX;
					empButton.y = posY;
					posY += 60;
					//trace(empButton.x + " " + empButton.y);
					subDept++;
				}
				empButton.name = row.idemp;
				empButton.addEventListener(MouseEvent.MOUSE_DOWN, empClickHandler);
				struktur_container.addChild(empButton);
			}
			
			posX = struktur_sub_EPI.x;
			
			// make "Staf" employee
			var stafName:TextField = new TextField();
			stafName.text = "Staf";
			stafName.setTextFormat(nameFormat); 
			stafName.embedFonts = true;
			stafName.width = 200;
			stafName.selectable = false;
			stafName.x = 5;
			stafName.y = 5;
				
			var stafBorder:Shape = new Shape();
			stafBorder.graphics.lineStyle(1, 0xFFFFFF, 1.0); 
			stafBorder.graphics.beginFill(0xFF0000, 0.0);
			stafBorder.graphics.drawRect(0, 0, 220, 60);
			stafBorder.graphics.endFill();
			
			empButton = new MovieClip();
			empButton.addChild(stafBorder);
			empButton.addChild(stafName);
			empButton.x = posX;
			empButton.y = posY;
			struktur_container.addChild(empButton);
			
			var stafName2:TextField = new TextField();
			stafName2.text = "Staf";
			stafName2.setTextFormat(nameFormat); 
			stafName2.embedFonts = true;
			stafName2.width = 200;
			stafName2.selectable = false;
			stafName2.x = 5;
			stafName2.y = 5;
				
			var stafBorder2:Shape = new Shape();
			stafBorder2.graphics.lineStyle(1, 0xFFFFFF, 1.0); 
			stafBorder2.graphics.beginFill(0xFF0000, 0.0);
			stafBorder2.graphics.drawRect(0, 0, 220, 60);
			stafBorder2.graphics.endFill();
			
			empButton = new MovieClip();
			empButton.addChild(stafBorder2);
			empButton.addChild(stafName2);
			empButton.x = posX + 260;
			empButton.y = posY;
			struktur_container.addChild(empButton);
					
			// make container
			container = new MovieClip();
			/*
			container.scrollRect = new Rectangle(0, 0, 900, struktur_container.height + 100);
			
			// make scrollable area
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xff0000, 0.0); 
			square.graphics.drawRect(0, 0, 900, struktur_container.height + 100); 
			square.graphics.endFill(); 
			
			container.addChild(square);
			
			/*
			// make mask
			var square2:Shape = new Shape(); 
			square2.graphics.lineStyle(1, 0x000000, 0.0); 
			square2.graphics.beginFill(0xff0000, 0.1); 
			square2.graphics.drawRect(90, 175, 900, 600);  
			square2.graphics.endFill(); 
			
			container.mask = square2;
			*/
			
			container.x = 90;
			container.y = 175;
			
			// addchild ke container
			container.addChild(struktur_container);
				
			addChild(container);
			
			//container.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
			maxY = 175;
			minY = Math.min(0, 720 - container.height);
		}
		
		private function getDataEmpPM():void {
			selectEmpStmt = new SQLStatement();
			selectEmpStmt.sqlConnection = conn;
			var sql:String = "SELECT * FROM employee WHERE iddept = 6";
			selectEmpStmt.text = sql;
			selectEmpStmt.addEventListener(SQLEvent.RESULT, getDataEmpPMSuccess);
			selectEmpStmt.execute();
		}
		
		private function getDataEmpPMSuccess(event:SQLEvent):void {
			var result:SQLResult = selectEmpStmt.getResult();
			
			struktur_PM = new McOrStruktur4;
			
			struktur_PM.y = 200;
			struktur_PM.x = 200;
			
			struktur_PM.btnSM1.txtRole.text = result.data[0].jabatanEn;
			struktur_PM.btnCons1.txtRole.text = result.data[1].jabatanEn;
			struktur_PM.btnComm1.txtRole.text = result.data[2].jabatanEn;
			struktur_PM.btnSM2.txtRole.text = result.data[3].jabatanEn;
			struktur_PM.btnCons2.txtRole.text = result.data[4].jabatanEn;
			struktur_PM.btnComm2.txtRole.text = result.data[5].jabatanEn;
			struktur_PM.btnAcc.txtRole.text = result.data[6].jabatanEn;
			struktur_PM.btnPM1.txtRole.text = result.data[7].jabatanEn;
			
			struktur_PM.btnSM1.addEventListener(MouseEvent.CLICK, klikPM1);
			struktur_PM.btnSM2.addEventListener(MouseEvent.CLICK, klikPM1);
			struktur_PM.btnCons1.addEventListener(MouseEvent.CLICK, klikPM1);
			struktur_PM.btnCons2.addEventListener(MouseEvent.CLICK, klikPM1);
			struktur_PM.btnComm1.addEventListener(MouseEvent.CLICK, klikPM1);
			struktur_PM.btnComm2.addEventListener(MouseEvent.CLICK, klikPM1);
			struktur_PM.btnAcc.addEventListener(MouseEvent.CLICK, klikPM1);
			struktur_PM.btnPM1.addEventListener(MouseEvent.CLICK, klikPM1);
			
			addChild(struktur_PM);
		}
		
		private function klikPM1(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnSM1" : mainClass.showSplash(new ScreenOrgP(mainClass, 4, 51));
										break;
				case "btnCons1" : mainClass.showSplash(new ScreenOrgP(mainClass, 4, 52));
										break;
				case "btnComm1" : mainClass.showSplash(new ScreenOrgP(mainClass, 4, 53));
										break
				case "btnSM2" : mainClass.showSplash(new ScreenOrgP(mainClass, 4, 54));
										break;
				case "btnCons2" : mainClass.showSplash(new ScreenOrgP(mainClass, 4, 55));
										break;
				case "btnComm2" : mainClass.showSplash(new ScreenOrgP(mainClass, 4, 56));
										break;
				case "btnAcc" : mainClass.showSplash(new ScreenOrgP(mainClass, 4, 63));
										break;
				case "btnPM1" : mainClass.showSplash(new ScreenOrgP(mainClass, 4, 67));
										break;
			}
		}
		
		private function getDataEmpPM2():void {
			selectEmpStmt = new SQLStatement();
			selectEmpStmt.sqlConnection = conn;
			var sql:String = "SELECT * FROM employee WHERE iddept = 7";
			selectEmpStmt.text = sql;
			selectEmpStmt.addEventListener(SQLEvent.RESULT, getDataEmpPM2Success);
			selectEmpStmt.execute();
		}
		
		private function getDataEmpPM2Success(event:SQLEvent):void {
			var result:SQLResult = selectEmpStmt.getResult();
			struktur_PM2 = new McOrStruktur5;
			
			struktur_PM2.y = 200;
			struktur_PM2.x = 200;
			
			struktur_PM2.btnSM1.txtRole.text = result.data[0].jabatanEn;
			struktur_PM2.btnCons1.txtRole.text = result.data[1].jabatanEn;
			struktur_PM2.btnComm1.txtRole.text = result.data[2].jabatanEn;
			struktur_PM2.btnSM2.txtRole.text = result.data[3].jabatanEn;
			struktur_PM2.btnCons2.txtRole.text = result.data[4].jabatanEn;
			struktur_PM2.btnComm2.txtRole.text = result.data[5].jabatanEn;
			struktur_PM2.btnSM.txtRole.text = result.data[6].jabatanEn;
			struktur_PM2.btnPro.txtRole.text = result.data[7].jabatanEn;
			struktur_PM2.btnExp.txtRole.text = result.data[8].jabatanEn;
			struktur_PM2.btnPM2.txtRole.text = result.data[9].jabatanEn;
			
			struktur_PM2.btnSM1.addEventListener(MouseEvent.CLICK, klikPM2);
			struktur_PM2.btnSM2.addEventListener(MouseEvent.CLICK, klikPM2);
			struktur_PM2.btnCons1.addEventListener(MouseEvent.CLICK, klikPM2);
			struktur_PM2.btnCons2.addEventListener(MouseEvent.CLICK, klikPM2);
			struktur_PM2.btnComm1.addEventListener(MouseEvent.CLICK, klikPM2);
			struktur_PM2.btnComm2.addEventListener(MouseEvent.CLICK, klikPM2);
			struktur_PM2.btnSM.addEventListener(MouseEvent.CLICK, klikPM2);
			struktur_PM2.btnPro.addEventListener(MouseEvent.CLICK, klikPM2);
			struktur_PM2.btnExp.addEventListener(MouseEvent.CLICK, klikPM2);
			struktur_PM2.btnPM2.addEventListener(MouseEvent.CLICK, klikPM2);
			
			addChild(struktur_PM2);
		}
		
		private function klikPM2(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnSM1" : mainClass.showSplash(new ScreenOrgP(mainClass, 5, 57));
										break;
				case "btnCons1" : mainClass.showSplash(new ScreenOrgP(mainClass, 5, 58));
										break;
				case "btnComm1" : mainClass.showSplash(new ScreenOrgP(mainClass, 5, 59));
										break
				case "btnSM2" : mainClass.showSplash(new ScreenOrgP(mainClass, 5, 60));
										break;
				case "btnCons2" : mainClass.showSplash(new ScreenOrgP(mainClass, 5, 61));
										break;
				case "btnComm2" : mainClass.showSplash(new ScreenOrgP(mainClass, 5, 62));
										break;
				case "btnSM" : mainClass.showSplash(new ScreenOrgP(mainClass, 5, 64));
										break;
				case "btnPro" : mainClass.showSplash(new ScreenOrgP(mainClass, 5, 65));
										break;
				case "btnExp" : mainClass.showSplash(new ScreenOrgP(mainClass, 5, 66));
										break;
				case "btnPM2" : mainClass.showSplash(new ScreenOrgP(mainClass, 5, 68));
										break;
			}
		}
		
		private function empClickHandler(e:MouseEvent):void {
			_clickHandlerY = container.y;
			e.currentTarget.addEventListener(MouseEvent.MOUSE_UP, viewEmpHandler);
		}
		
		private function viewEmpHandler(e:MouseEvent):void {
			var currentY:Number = container.y;
			if (_clickHandlerY == currentY) {
				mainClass.showSplash(new ScreenOrgP(mainClass, whichDept, int(e.currentTarget.name)));
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
		
	}

}