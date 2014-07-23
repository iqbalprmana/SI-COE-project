package Screen 
{
	import Asset.McAlert;
	import Asset.McShade;
	import flash.data.SQLResult;
	import flash.display.MovieClip;
	import flash.errors.SQLError;
	import flash.events.MouseEvent;
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.events.Event;
	/**
	 * ...
	 * @author vikachew
	 */
	public class ScreenMgOrganisasi3 extends SCREEN_MG_OR_EDIT
	{
		private var mainClass:Main;
		private var imageAvailable:Boolean;
		
		private var selectStmt:SQLStatement;
		private var conn:SQLConnection;
		
		private var imgFile:File;		
		
		private var numDept:int;
		private var numID:int;
		private var curDept:int;
		private var curSubDept:int;
		
		// delete images & update
		private var originalImg:Boolean; // true if available from the beginning
		private var originalFoto:String;
		private var flagImgBerubah:Boolean;
		
		private var mcAlert = new McAlert;
		private var mcShade = new McShade;
		
		public function ScreenMgOrganisasi3(passedClass:Main, passedDept:int, passedID:int) 
		{
			mainClass = passedClass;
			numDept = passedDept;
			numID = passedID;
			init();
			conn = new SQLConnection();
			loadDb();
		}
		
		public function init():void
		{
			curDept = 0;
			curSubDept = 0;
			
			btnDE.visible = false;
			btnPS.visible = false;
			btnEK.visible = false;
			
			btnDE1.visible = false;
			btnDE2.visible = false;
			btnDE3.visible = false;
			btnDE4.visible = false;
			btnDE5.visible = false;
			
			btnEK1.visible = false;
			btnEK2.visible = false;
			
			originalImg = false;
			flagImgBerubah = false;
			btnDel.visible = false;
			imageAvailable = false;
			btnDel.addEventListener(MouseEvent.CLICK, deleteImage);
			
			btnDD.addEventListener(MouseEvent.CLICK, ddHandler);
			btnDD2.addEventListener(MouseEvent.CLICK, dd2Handler);
			
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			btnSave.addEventListener(MouseEvent.CLICK, navHandler);
			btnAddImage.addEventListener(MouseEvent.CLICK, navHandler);
			
			btnDE.addEventListener(MouseEvent.CLICK, deptHandler);
			btnPS.addEventListener(MouseEvent.CLICK, deptHandler);
			btnEK.addEventListener(MouseEvent.CLICK, deptHandler);
			
			btnDE1.addEventListener(MouseEvent.CLICK, subHandler);
			btnDE2.addEventListener(MouseEvent.CLICK, subHandler);
			btnDE3.addEventListener(MouseEvent.CLICK, subHandler);
			btnDE4.addEventListener(MouseEvent.CLICK, subHandler);
			btnDE5.addEventListener(MouseEvent.CLICK, subHandler);
			
			btnEK1.addEventListener(MouseEvent.CLICK, subHandler);
			btnEK2.addEventListener(MouseEvent.CLICK, subHandler);
		}
		
		private function ddHandler(e:MouseEvent):void {
			if (curDept == 1) {
				if (btnDE1.visible) {
					toggleSubVisible();
				}
			}
			else if (curDept == 3) {
				if (btnEK1.visible) {
					toggleSubVisible();
				}
			}
			
			toggleDeptVisible();
		}
		
		private function toggleDeptVisible():void {
			if (!btnDE.visible) {
				btnDE.visible = true;
				btnPS.visible = true;
				btnEK.visible = true;
				mcKotakSub.visible = false;
				txtFormSub.visible = false;
			}
			else {
				btnDE.visible = false;
				btnPS.visible = false;
				btnEK.visible = false;
				mcKotakSub.visible = true;
				txtFormSub.visible = true;
			}
		}
		
		private function dd2Handler(e:MouseEvent):void {
			if (btnDE.visible) toggleDeptVisible();
			toggleSubVisible();
		}
		
		private function toggleSubVisible():void {
			if (curDept == 1) {
				if(!btnDE1.visible) {
					btnDE1.visible = true;
					btnDE2.visible = true;
					btnDE3.visible = true;
					btnDE4.visible = true;
					btnDE5.visible = true;
				}
				else {
					btnDE1.visible = false;
					btnDE2.visible = false;
					btnDE3.visible = false;
					btnDE4.visible = false;
					btnDE5.visible = false;
				}
			}
			else if(curDept == 3) {
				if(!btnEK1.visible) {
					btnEK1.visible = true;
					btnEK2.visible = true;
				}
				else {
					btnEK1.visible = false;
					btnEK2.visible = false;
				}
			}
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenMgOrganisasi1(mainClass));
										break;
				case "btnSave" : updateTable();
										break;
				case "btnAddImage" : addNewImage(); 
									break;
									
			}
		}
		
		private function deptHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnDE" : curDept = 1; trace("212"); txtFormDept.text = "DESIGN & ENGINEERING";
										break;
				case "btnPS" : curDept = 2; trace("214"); txtFormDept.text = "PROJECT SERVICES";
										break;
				case "btnEK" : curDept = 3; trace("216"); txtFormDept.text = "EN. KNOWLEDGE & INV.";
										break;
			}
			
			toggleDeptVisible();
			toggleFormSubDeptVisible();
			curSubDept = 0;
			txtFormSub.text = "";
		}
		
		private function toggleFormSubDeptVisible():void {
			if (curDept == 1 || curDept == 3) {
				btnDD2.visible = true;
				mcKotakSub.visible = true;
				txtFormSub.visible = true;
			}
			else {
				btnDD2.visible = false;
				mcKotakSub.visible = false;
				txtFormSub.visible = false;
			}
		}
		
		private function subHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnDE1" : curSubDept = 1; txtFormSub.text = "Bureau of Process Design";
										break;
				case "btnDE2" : curSubDept = 2; txtFormSub.text = "Bureau of Civil Design";
										break;
				case "btnDE3" : curSubDept = 3; txtFormSub.text = "Bureau of Mechanical Design";
										break;
				case "btnDE4" : curSubDept = 4; txtFormSub.text = "Bureau of Elct. & Ins. Design";
										break;
				case "btnDE5" : curSubDept = 5; txtFormSub.text = "Bureau of Design Integration";
										break;
				case "btnEK1" : curSubDept = 1; txtFormSub.text = "Bureau of Eng. Rsc. & Inv.";
										break;
				case "btnEK2" : curSubDept = 2; txtFormSub.text = "Bureau of Eng. Rsc. & Inv.";
										break;
			}
			
			toggleSubVisible();
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
			var sql:String = "select * from employee where idemp = " + numID;
			selectStmt.text = sql;
			
			selectStmt.addEventListener(SQLEvent.RESULT, getDataSuccess);
			
			selectStmt.execute();
		}
		
		private function getDataSuccess(event:SQLEvent):void {
			var result:SQLResult = selectStmt.getResult();
			var row:Object = result.data[0]; 
														
			txtFormNama.text = row.nama;
			if (row.jabatanEn != null && row.jabatanEn != "" && row.jabatanEn != "null") txtFormRole.text = row.jabatanEn;
			if (row.kompetensi != null && row.kompetensi != "" && row.kompetensi != "null") txtFormTelp.text = row.kompetensi;
			if (row.since != null && row.since != "" && row.since != "null") txtFormEXT.text = row.since;
			if (row.experience != null && row.experience != "" && row.experience != "null") txtFormBB.text = row.experience;			
			
			if (row.iddept == 0) {
				txtFormDept.text = "DIRECTORATE EN. & PROJECT";
				btnDD.visible = false;
			}
			else if (row.iddept == 1) {
				txtFormDept.text = "DESIGN & ENGINEERING";
				if (row.idsubdept == 1) {
					txtFormSub.text = "Bureau of Process Design";
				}
				else if (row.idsubdept == 2) {
					txtFormSub.text = "Bureau of Civil Design";
				}
				else if (row.idsubdept == 3) {
					txtFormSub.text = "Bureau of Mechanical Design";
				}
				else if (row.idsubdept == 4) {
					txtFormSub.text = "Bureau of Elct. & Ins. Design";
				}
				else if (row.idsubdept == 5) {
					txtFormSub.text = "Bureau of Design Integration";
				}
			}
			else if (row.iddept == 2) {
				txtFormDept.text = "PROJECT SERVICES";
			}
			else if (row.iddept == 3) {
				txtFormDept.text = "EN. KNOWLEDGE & INV.";
				if (row.idsubdept == 1) {
					txtFormSub.text = "Bureau of Eng. Rsc. & Inv.";
				}
				else if (row.idsubdept == 2) {
					txtFormSub.text = "Bureau of Eng. Rsc. & Inv.";
				}
			}
			else if (row.iddept == 6) {
				txtFormDept.text = "PROJECT MANAGEMENT I";
				btnDD.visible = false;
			}
			else if (row.iddept == 7) {
				txtFormDept.text = "PROJECT MANAGEMENT II";
				btnDD.visible = false;
			}
			curDept = row.iddept;
			curSubDept = row.idsubdept;
			toggleFormSubDeptVisible();
			
			trace("Dept dan subdept " + curDept +" "+ curSubDept);
			
			if (row.pathFoto != null && row.pathFoto != "" && row.pathFoto != "null") {
				txtFormImg.text = getImgNameOnly(row.pathFoto);
				originalFoto = row.pathFoto;
				imageAvailable = true;
				originalImg = true;
				btnDel.visible = true;
			}
		}
		
		private function getImgNameOnly(toCut:String):String {
			var newStr:String;
			for (var n:int = 0; n < toCut.length; n++) {
				if (toCut.charAt(n) == "/") newStr = toCut.substring(n + 1, toCut.length);
			}
			return newStr;
		}
		
		private function updateTable():void {
			if(cekFormFull()){
				var updateStmt:SQLStatement = new SQLStatement();
				updateStmt.sqlConnection = conn;
				
				// UPDATE table_name
				// SET column1 = value1, column2 = value2...., columnN = valueN
				// WHERE [condition];
				
				var fileImgName:String;
				if (txtFormImg.text != "") {
					if (flagImgBerubah) fileImgName = "Images/Emp/" + imgFile.name;
					else fileImgName = originalFoto;
				}
				trace("before update " + curDept +" "+ curSubDept);
				var sql:String = "UPDATE EMPLOYEE SET nama = '" + tesPetik(txtFormNama.text) + 
														"', jabatanEn = '" + tesPetik(txtFormRole.text) + 
														"', kompetensi = '" + tesPetik(txtFormTelp.text) + 
														"', since = '" + tesPetik(txtFormEXT.text) + 
														"', experience = '" + tesPetik(txtFormBB.text) + 														
														"', iddept = '" + curDept + 
														"', idsubdept = '" + curSubDept + 
														"', pathFoto = '" + fileImgName +
														"' WHERE idemp = " + numID;
				trace(sql);
					
				updateStmt.text = sql;
				updateStmt.execute();
				
				// conditional: delete old foto file
				if (originalImg == true && flagImgBerubah == true) { // if there exists old photo and it's changed
					var fileToDelete:String = originalFoto;
					var pathToFile:String = File.applicationDirectory.resolvePath(fileToDelete).nativePath;
					var someFile:File = new File(pathToFile);
					someFile.deleteFile();
					
					trace("file yang didelete " + originalFoto);
				}
				
				// conditional: copy new foto file
				if(imageAvailable && flagImgBerubah == true){
					var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName).nativePath;
					var someFile:File = new File(pathToFile);
					imgFile.copyToAsync(someFile);
				}
				
				mainClass.showSplash(new ScreenMgOrganisasi1(mainClass));
			}
		}
		
		private function cekFormFull():Boolean {
			if (txtFormNama.text != "" && curDept != 0) 
			{
				if (curSubDept == 0) {
					if (txtFormRole.text == "General Manager") {
						curSubDept = 0;
						trace("first");
						return true;
					}
					else if (curDept == 2 || curDept == 4 || curDept == 5) {
						curSubDept = 1;
						return true;
					}
					else if (curDept == 6 || curDept == 7) {
						return true;
					}
					else {
						trace("second");
						return false;
					}
				}
				else {
					trace("third " + curDept);
					return true;
				}
			}
			else {
				trace("forth");
				return false;
			}
		}
		
		private function deleteImage(e:MouseEvent):void {
			txtFormImg.text = "";
			btnDel.visible = false;
			imageAvailable = false;
			
			if(originalImg) flagImgBerubah = true;
		}
		
		private function addNewImage():void {
			var imageFilter:FileFilter = new FileFilter("Images", "*.png;*.jpg;*.jpeg" );
			if(txtFormImg.text == "") {
				imgFile = File.desktopDirectory;
				imgFile.addEventListener(Event.SELECT, onSelectedPic);
				imgFile.browseForOpen("Select a picture:", [imageFilter]);
			}
			
			imageAvailable = true;
			if(!originalImg) flagImgBerubah = true;
		}
		private function onSelectedPic(evt:Event):void
		{
			var filePath:String;
			filePath = imgFile.name;
			if (filePath.search("'") != -1) {
				showAlert("Anda tidak dapat memilih foto yang memiliki tanda petik pada nama file.");
				return;
			}
			txtFormImg.text = filePath;
			btnDel.visible = true;
		}
		
		private function tesPetik(input:String):String {
			return(input.replace("'", "\'\'"));
		}
		
		private function showAlert(msg:String):void {
			mcAlert = new McAlert;
			mcAlert.txtMsg.text = msg;
			mcAlert.btnOK.addEventListener(MouseEvent.CLICK, alertDismiss);
			mcAlert.x = 300;
			mcAlert.y = 200;
			mcShade = new McShade;
			
			addChild(mcShade);
			addChild(mcAlert);
			setChildIndex(mcShade, numChildren - 1);
			setChildIndex(mcAlert, numChildren - 1);
		}
		
		private function alertDismiss(e:MouseEvent):void {
			removeChild(mcShade);
			removeChild(mcAlert);
		}
	}

}