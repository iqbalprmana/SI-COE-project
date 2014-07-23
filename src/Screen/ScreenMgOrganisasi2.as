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
	
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author vikachew
	 */
	public class ScreenMgOrganisasi2 extends SCREEN_MG_OR_ADD
	{
		private var mainClass:Main;
		private var imageAvailable:Boolean;
		
		private var selectStmt:SQLStatement;
		private var conn:SQLConnection;
		
		private var imgFile:File;		
		
		private var curDept:int;
		private var curSubDept:int;
		
		private var mcAlert = new McAlert;
		private var mcShade = new McShade;
		
		public function ScreenMgOrganisasi2(passedClass:Main, passedDept:int) 
		{
			mainClass = passedClass;
			curDept = passedDept;
			init();
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
				case "btnSave" : addNewEmp();
										break;
				case "btnAddImage" : addNewImage(); 
									break;
									
			}
		}
		
		private function deptHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnDE" : curDept = 1; txtFormDept.text = "DESIGN & ENGINEERING";
										break;
				case "btnPS" : curDept = 2; txtFormDept.text = "PROJECT SERVICES";
										break;
				case "btnEK" : curDept = 3; txtFormDept.text = "EN. KNOWLEDGE & INV.";
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
		
		private function addNewEmp():void {
			if(cekFormFull()){
				conn = new SQLConnection();
				
				conn.addEventListener(SQLEvent.OPEN, openHandler);
				conn.addEventListener(SQLErrorEvent.ERROR, errorHandler);
				
				var folder:File = File.applicationDirectory;
				var dbFile:File = folder.resolvePath("dbase.db");
				
				conn.open(dbFile); //sync
				
				var insertStmt:SQLStatement = new SQLStatement();
				insertStmt.sqlConnection = conn;
				var sql:String;
				
				var fileImgName:String;
				if (txtFormImg.text != "") fileImgName = "Images/Emp/" + imgFile.name;
				
				sql =	"INSERT INTO EMPLOYEE VALUES (" + curSubDept + ",'" + tesPetik(txtFormEXT.text) + "','" + tesPetik(txtFormBB.text) + "',NULL,'"		// email is null 
						+ tesPetik(txtFormTelp.text) + "',NULL," + curDept + ",'" + tesPetik(txtFormNama.text) + "','" 
						+ tesPetik(txtFormRole.text) + "','" + tesPetik(txtFormRole.text) + "','" + fileImgName + "')";
				
				insertStmt.text = sql;
				insertStmt.execute();
				
				// optional: copy image file
				if(imageAvailable){
					var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName).nativePath;
					var someFile:File = new File(pathToFile);
					imgFile.copyToAsync(someFile);
				}
				
				mainClass.showSplash(new ScreenMgOrganisasi1(mainClass));
			}
			
		}
		
		private function openHandler(event:SQLEvent):void {
			
		}
		
		private function errorHandler(event:SQLErrorEvent):void {
			
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
		}
		
		private function addNewImage():void {
			var imageFilter:FileFilter = new FileFilter("Images", "*.png;*.jpg;*.jpeg" );
			if(txtFormImg.text == "") {
				imgFile = File.desktopDirectory;
				imgFile.addEventListener(Event.SELECT, onSelectedPic);
				imgFile.browseForOpen("Select a picture:", [imageFilter]);
			}
			
			imageAvailable = true;
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