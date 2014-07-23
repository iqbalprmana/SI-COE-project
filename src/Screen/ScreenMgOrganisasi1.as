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
	public class ScreenMgOrganisasi1 extends SCREEN_MG_OR
	{
		private var mainClass:Main;
		private var numDept:int;
		
		// db
		private var selectStmt:SQLStatement;		
		private var selectImgStmt:SQLStatement;
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
		
		public function ScreenMgOrganisasi1(passedClass:Main) 
		{
			mainClass = passedClass;
			numDept = 1;
			init();
			conn = new SQLConnection();
			loadDb();
		}
		public function init():void
		{
			txtDept.text = "DESIGN & ENGINEERING";
			
			btnDIR.visible = false;
			btnDE.visible = false;
			btnPS.visible = false;
			btnEK.visible = false;
			btnPM.visible = false;
			btnPM2.visible = false;
			
			btnDD.addEventListener(MouseEvent.CLICK, ddHandler);
			
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			btnAdd.addEventListener(MouseEvent.CLICK, navHandler);
			
			btnDIR.addEventListener(MouseEvent.CLICK, deptHandler);
			btnDE.addEventListener(MouseEvent.CLICK, deptHandler);
			btnPS.addEventListener(MouseEvent.CLICK, deptHandler);
			btnEK.addEventListener(MouseEvent.CLICK, deptHandler);
			btnPM.addEventListener(MouseEvent.CLICK, deptHandler);
			btnPM2.addEventListener(MouseEvent.CLICK, deptHandler);
		}
		
		private function ddHandler(e:MouseEvent):void {
			toggleDDVisible();
		}
		
		private function toggleDDVisible():void {
			if (!btnDE.visible) {
				btnDIR.visible = true;
				btnDE.visible = true;
				btnPS.visible = true;
				btnEK.visible = true;
				btnPM.visible = true;
				btnPM2.visible = true;
			}
			else {
				btnDIR.visible = false;
				btnDE.visible = false;
				btnPS.visible = false;
				btnEK.visible = false;
				btnPM.visible = false;
				btnPM2.visible = false;
			}
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenAdmin(mainClass));
										break;
				case "btnAdd" : mainClass.showSplash(new ScreenMgOrganisasi2(mainClass, numDept));
										break;
			}
		}
		
		private function deptHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnDIR" : numDept = 0; removeChild(container); toggleDDVisible(); getData(); txtDept.text = "DIRECTORATE EN. & PROJECT";
										break;
				case "btnDE" : numDept = 1; removeChild(container); toggleDDVisible(); getData(); txtDept.text = "DESIGN & ENGINEERING";
										break;
				case "btnPS" : numDept = 2; removeChild(container); toggleDDVisible(); getData(); txtDept.text = "PROJECT SERVICES";
										break;
				case "btnEK" : numDept = 3; removeChild(container); toggleDDVisible(); getData(); txtDept.text = "EN. KNOWLEDGE & INV.";
										break;
				case "btnPM" : numDept = 6; removeChild(container); toggleDDVisible(); getData(); txtDept.text = "PROJECT MANAGEMENT I";
										break;
				case "btnPM2" : numDept = 7; removeChild(container); toggleDDVisible(); getData(); txtDept.text = "PROJECT MANAGEMENT II";
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
			sql = "select * from employee where iddept = " + numDept + " order by idsubdept ASC";
			
			selectStmt.text = sql;
			
			selectStmt.addEventListener(SQLEvent.RESULT, getDataSuccess);
			selectStmt.addEventListener(SQLErrorEvent.ERROR, getDataError);
			
			selectStmt.execute();
		}
		
		private function getDataSuccess(event:SQLEvent):void {
			var result:SQLResult = selectStmt.getResult();
			var numResults:int = result.data.length; 
			
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
			
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			format.size = 24;
			
			for (var i:int = 0; i < numResults; i++) 
			{ 
				var row:Object = result.data[i]; 
				
				// Nama
				var txtNama:TextField = new TextField();
				txtNama.text = row.nama;
				txtNama.setTextFormat(format); 
				txtNama.embedFonts = true;
				txtNama.y = i * 50;
				txtNama.height = 50;
				txtNama.width = 300;
				txtNama.selectable = false;
				
				// Role
				var txtRole:TextField = new TextField();
				if (row.jabatanEn != null && row.jabatanEn != "" && row.jabatanEn != "null") txtRole.text = row.jabatanEn;
				else txtRole.text = "-";
				txtRole.setTextFormat(format); 
				txtRole.embedFonts = true;
				txtRole.x = 310;
				txtRole.y = i * 50;
				txtRole.height = 50;
				txtRole.width = 300;
				txtRole.selectable = false;

				// Btn Edit
				var btnEdit:BtnEdit = new BtnEdit();
				btnEdit.x = 645;
				btnEdit.y = 8 + i * 50;
				
				btnEdit.name = row.idemp;
				btnEdit.addEventListener(MouseEvent.CLICK, btnEditHandler);
				
				// Btn Delete
				if(numDept != 0 && numDept != 6 && numDept != 7){
					var btnDel:BtnDelete = new BtnDelete();
					btnDel.x = 670;
					btnDel.y = 8 + i * 50;
					
					btnDel.name = row.idemp;
					btnDel.addEventListener(MouseEvent.CLICK, btnDelHandler);
				}

				// addchild ke container
				container.addChild(txtNama);
				container.addChild(txtRole);
				container.addChild(btnEdit);
				if(numDept != 0 && numDept != 6 && numDept != 7) container.addChild(btnDel);
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
			mainClass.showSplash(new ScreenMgOrganisasi3(mainClass, numDept, e.currentTarget.name));
		}
		
		private function btnDelHandler(e:MouseEvent):void 
		{
			idToDelete = e.currentTarget.name;
			mcConfirm = new McConfirm;
			mcConfirm.txtMsg.text = "Apakah Anda yakin akan menghapus pegawai ini?";
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
				case "btnYes" : deleteEmp();
										break;
			}
			removeChild(mcShade);
			removeChild(mcConfirm);
		}
		
		private function deleteEmp():void {
			selectImgStmt = new SQLStatement();
			selectImgStmt.sqlConnection = conn;
			var sql:String;
			
			// delete image
			sql = "select pathFoto from employee where idemp = " + idToDelete;
			selectImgStmt.text = sql;
			selectImgStmt.addEventListener(SQLEvent.RESULT, delImage);
			selectImgStmt.execute();	
			
			// delete record from database
			deleteStmt = new SQLStatement();
			deleteStmt.sqlConnection = conn;
			sql = "delete from employee where idemp = " + idToDelete;
			deleteStmt.text = sql;
			deleteStmt.execute();
			
			removeChild(container);
			getData();
		}
		
		private function delImage(event:SQLEvent):void {
			var result:SQLResult = selectImgStmt.getResult();
			var row:Object = result.data[0];
			
			var fileToDelete:String = row.pathFoto;
			var pathToFile:String = File.applicationDirectory.resolvePath(fileToDelete).nativePath;
			var someFile:File = new File(pathToFile);
			someFile.deleteFile();
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