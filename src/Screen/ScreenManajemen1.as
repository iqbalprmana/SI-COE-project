package Screen 
{
	import Asset.McConfirm;
	import Asset.McShade;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.errors.SQLError;
	import flash.events.MouseEvent;
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.events.Event;
	
	import Asset.BtnDelete;
	import Asset.BtnEdit;
	
	/**
	 * ...
	 * @author vikachew
	 */
	public class ScreenManajemen1 extends SCREEN_MANAJEMEN1
	{
		private var mainClass:Main;
		private var numTable:int;
		
		// db
		private var selectStmt:SQLStatement;		
		private var selectStmt2:SQLStatement;		
		private var selectVidStmt:SQLStatement;
		private var deleteStmt:SQLStatement;
		private var deleteImgStmt:SQLStatement;
		private var conn:SQLConnection;
		
		// scroll
		private var container:MovieClip;
		private var maxY:Number;
		private var minY:Number;
		private var _startY:Number;
		private var _startMouseY:Number;
		
		// delete confirmation
		private var idToDelete:String;
		private var mcShade:McShade;
		private var mcConfirm:McConfirm;
		
		public function ScreenManajemen1(passedClass:Main) 
		{
			mainClass = passedClass;
			numTable = 1;
			init();
			conn = new SQLConnection();
			loadDb();
		}
		
		public function init():void
		{
			txtTable.text = "PROJECT PERFORMANCE";
			
			btnFT.visible = false;
			btnPP.visible = false;
			btnTD.visible = false;
			
			btnDD.addEventListener(MouseEvent.CLICK, ddHandler);
			
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			btnAdd.addEventListener(MouseEvent.CLICK, navHandler);
			
			btnPP.addEventListener(MouseEvent.CLICK, navHandler);
			btnTD.addEventListener(MouseEvent.CLICK, navHandler);
			btnFT.addEventListener(MouseEvent.CLICK, navHandler);
		}
		
		private function ddHandler(e:MouseEvent):void {
			toggleDDVisible();
		}
		
		private function toggleDDVisible():void {
			if (!btnFT.visible) {
				btnFT.visible = true;
				btnPP.visible = true;
				btnTD.visible = true;
			}
			else {
				btnFT.visible = false;
				btnPP.visible = false;
				btnTD.visible = false;
			}
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenAdmin(mainClass));
										break;
				case "btnAdd" : mainClass.showSplash(new ScreenManajemen2(mainClass, numTable));
										break;
				case "btnPP" : numTable = 1; removeChild(container); toggleDDVisible(); getData(); txtTable.text = "PROJECT PERFORMANCE";
										break;
				case "btnTD" : numTable = 2; removeChild(container); toggleDDVisible(); getData(); txtTable.text = "TECHNOLOGY DEVELOPMENT";
										break;
				case "btnFT" : numTable = 3; removeChild(container); toggleDDVisible(); getData(); txtTable.text = "FUTURE PROJECT";
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
			var sql:String;
			if (numTable == 1) sql = "select idpp, idsemen, judul, period, lokasi from projectperformance order by lastEdit DESC";
			else if (numTable == 2) sql = "select idtd, idsemen, judul, period from techdev order by lastEdit DESC";
			else if (numTable == 3) sql = "select idproyek, judul from futureproject";
			
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
				addChild(container);
				return;
			}
			
			// make container
			container = new MovieClip();
			container.scrollRect = new Rectangle(0, 0, 720, numResults * 58);
			
			// make scrollable area
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1, 0x000000, 0.0); 
			square.graphics.beginFill(0xff0000, 0.0); 
			square.graphics.drawRect(0, 0, 720, numResults * 58); 
			square.graphics.endFill(); 
			
			container.addChild(square);
			
			// make mask
			var square2:Shape = new Shape(); 
			square2.graphics.lineStyle(1, 0x000000, 0.0); 
			square2.graphics.beginFill(0xff0000, 0.1); 
			square2.graphics.drawRect(420, 345, 720, 335); 
			square2.graphics.endFill(); 
			
			container.mask = square2;
			
			container.x = 420;
			container.y = 350;
			
			for (var i:int = 0; i < numResults; i++) 
			{ 
				var row:Object = result.data[i]; 
				var format:TextFormat = new TextFormat(); 
				
				// Judul
				var txtJudul:TextField = new TextField();
				//textField.name = i.toString();
				//textField.mouseEnabled = false;
				txtJudul.text = row.judul;
				format.color = 0xFFFFFF; 
				format.font = "myFont"; 
				format.size = 24;
				
				txtJudul.setTextFormat(format); 
				txtJudul.embedFonts = true;
				txtJudul.y = i * 50;
				txtJudul.height = 50;
				txtJudul.width = 300;
				txtJudul.selectable = false;
				
				if(numTable!= 3){
					// Status
					var txtStat:TextField = new TextField();
					if (numTable == 1 || numTable == 2) txtStat.text = row.period;
					else txtStat.text = row.status;
					txtStat.setTextFormat(format); 
					txtStat.embedFonts = true;
					txtStat.x = 350;
					txtStat.y = i * 50;
					txtStat.height = 50;
					txtStat.width = 150;
					txtStat.selectable = false;
					
					// Lokasi
					var txtLok:TextField = new TextField();
					if (numTable == 1) {
						txtLok.text = row.lokasi;
					}
					else if (numTable == 2) {
						if (row.idsemen == 1) txtLok.text = "SEMEN GRESIK";
						else if (row.idsemen == 2) txtLok.text = "SEMEN PADANG";
						else if (row.idsemen == 3) txtLok.text = "SEMEN TONASA";
						else if (row.idsemen == 4) txtLok.text = "SEMEN THANGLONG";
						else if (row.idsemen == 5) txtLok.text = "SEMEN INDONESIA";
					}
					txtLok.setTextFormat(format); 
					txtLok.embedFonts = true;
					txtLok.x = 500;
					txtLok.y = i * 50;
					txtLok.height = 50;
					txtLok.width = 130;
					txtLok.selectable = false;
				}
				// Btn Edit
				var btnEdit:BtnEdit = new BtnEdit();
				btnEdit.x = 645;
				btnEdit.y = 8 + i * 50;
				
				if (numTable == 1) btnEdit.name = row.idpp;
				else if (numTable == 2) btnEdit.name = row.idtd;
				else if (numTable == 3) btnEdit.name = row.idproyek;
				
				btnEdit.addEventListener(MouseEvent.CLICK, btnEditHandler);
				
				// Btn Delete
				var btnDel:BtnDelete = new BtnDelete();
				btnDel.x = 670;
				btnDel.y = 8 + i * 50;
				
				if (numTable == 1) btnDel.name = row.idpp;
				else if (numTable == 2) btnDel.name = row.idtd;
				else if (numTable == 3) btnDel.name = row.idproyek;
				
				btnDel.addEventListener(MouseEvent.CLICK, btnDelHandler);

				// addchild ke container
				container.addChild(txtJudul);
				if (numTable != 3) {
					container.addChild(txtStat);
					container.addChild(txtLok);
				}
				container.addChild(btnEdit);
				container.addChild(btnDel);
			} 
			addChild(container);			
			container.addEventListener(MouseEvent.MOUSE_DOWN, scrollHandler);
			maxY = 350;
			minY = Math.min(0, 720 - container.height);
		}
		
		private function getDataError(event:SQLErrorEvent):void {
			
		}
			
		private function btnEditHandler(e:MouseEvent):void 
		{
			if (numTable == 1) {
				mainClass.showSplash(new ScreenManajemen3(mainClass, numTable, e.currentTarget.name));
			}
			else if (numTable == 2) {
				mainClass.showSplash(new ScreenManajemen3(mainClass, numTable, e.currentTarget.name));
			}
		}
		
		private function btnDelHandler(e:MouseEvent):void 
		{
			idToDelete = e.currentTarget.name;
			mcConfirm = new McConfirm;
			mcConfirm.txtMsg.text = "Apakah Anda yakin akan menghapus konten ini?";
			mcConfirm.btnYes.addEventListener(MouseEvent.CLICK, deleteConfirm);
			mcConfirm.btnNo.addEventListener(MouseEvent.CLICK, deleteConfirm);
			mcConfirm.x = 300;
			mcConfirm.y = 200;
			mcShade = new McShade;
			
			addChild(mcShade);
			addChild(mcConfirm);
			setChildIndex(mcShade, numChildren - 1);
			setChildIndex(mcConfirm, numChildren - 1);
		}
		
		private function deleteConfirm(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnYes" : deleteContent();
										break;
			}
			removeChild(mcShade);
			removeChild(mcConfirm);
		}
		
		private function deleteContent():void {
			var sql:String;
			
			// delete images
			// delete the whole directory
			var dirLocation:String;
			if (numTable == 1) {
				dirLocation = "Images/PP/" + idToDelete + "/";
			}
			else if (numTable == 2) {
				dirLocation = "Images/TD/" + idToDelete + "/";
			}
			else if (numTable == 3) {
				dirLocation = "Images/FT/" + idToDelete + "/";
			}
			var pathToDir:String = File.applicationDirectory.resolvePath(dirLocation).nativePath;
			var testDir:File = File.applicationDirectory.resolvePath(dirLocation);
			
			if(testDir.isDirectory) {
				var someDir:File = new File(pathToDir);
				someDir.addEventListener(Event.COMPLETE, rmDirHandler);
				someDir.deleteDirectoryAsync(true);
			}
			
			// delete images record in PPIMAGES
			if (numTable == 1) {
				deleteImgStmt = new SQLStatement();
				deleteImgStmt.sqlConnection = conn;
				sql = "delete from ppimages where idpp = " + idToDelete;
				deleteImgStmt.text = sql;
				deleteImgStmt.execute();
			}
			else if (numTable == 2) {
				deleteImgStmt = new SQLStatement();
				deleteImgStmt.sqlConnection = conn;
				sql = "delete from tdimages where idtd = " + idToDelete;
				deleteImgStmt.text = sql;
				deleteImgStmt.execute();
			}
			
			// delete videos
			// delete the whole directory
			if(numTable!=3){
				if (numTable == 1) {
					dirLocation = "Videos\\PP\\" + idToDelete + "\\";
				}
				else if (numTable == 2) {
					dirLocation = "Videos\\TD\\" + idToDelete + "\\";
				}
			}
			var pathToDir:String = File.applicationDirectory.resolvePath(dirLocation).nativePath;
			testDir = File.applicationDirectory.resolvePath(dirLocation);
			
			if(testDir.isDirectory) {
				var someDir:File = new File(pathToDir);
				someDir.addEventListener(Event.COMPLETE, rmDirHandler);
				someDir.deleteDirectoryAsync(true);
			}
			
			// delete record from database
			deleteStmt = new SQLStatement();
			deleteStmt.sqlConnection = conn;
			if (numTable == 1) sql = "delete from projectperformance where idpp = " + idToDelete;
			else if (numTable == 2) sql = "delete from techdev where idtd = " + idToDelete;
			else if (numTable == 3) sql = "delete from futureproject where idproyek = " + idToDelete;
			trace(sql);
			deleteStmt.text = sql;
			deleteStmt.execute();
			
			removeChild(container);
			getData();
		}
		
		private function rmDirHandler(event:Event):void { 
			trace("Deleted.") 
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
		
	}

}