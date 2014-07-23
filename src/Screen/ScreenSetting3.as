package Screen 
{
	import flash.errors.SQLError;
	import flash.events.MouseEvent;
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.events.Event;
	/**
	 * ...
	 * @author vikachew
	 */
	public class ScreenSetting3 extends SCREEN_SETTING3
	{
		private var mainClass:Main;
		private var selectStmt:SQLStatement;
		private var conn:SQLConnection;
		private var stringPassDB:String;
		private var stringPassUser:String;
		private var stringPassNew:String;
		private var step:int;
		
		public function ScreenSetting3(passedClass:Main) 
		{
			mainClass = passedClass;
			init();
			conn = new SQLConnection();
			stringPassUser = "";
			stringPassNew = "";
			step = 1;
			loadPass();
		}
		
		public function init():void
		{
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			
			btn1.addEventListener(MouseEvent.CLICK, passHandler);
			btn2.addEventListener(MouseEvent.CLICK, passHandler);
			btn3.addEventListener(MouseEvent.CLICK, passHandler);
			btn4.addEventListener(MouseEvent.CLICK, passHandler);
			btn5.addEventListener(MouseEvent.CLICK, passHandler);
			btn6.addEventListener(MouseEvent.CLICK, passHandler);
			btn7.addEventListener(MouseEvent.CLICK, passHandler);
			btn8.addEventListener(MouseEvent.CLICK, passHandler);
			btn9.addEventListener(MouseEvent.CLICK, passHandler);
			btn0.addEventListener(MouseEvent.CLICK, passHandler);
			btnClear.addEventListener(MouseEvent.CLICK, passHandler);
			btnEnter.addEventListener(MouseEvent.CLICK, passHandler);
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenAdmin(mainClass));
										break;
			}
		}
		
		private function passHandler(e:MouseEvent):void {
			var pressed:int;
			
			switch(e.currentTarget.name)
			{
				case "btn1" : pressed = 1;
										break;
				case "btn2" : pressed = 2;
										break;
				case "btn3" : pressed = 3;
										break;
				case "btn4" : pressed = 4;
										break;
				case "btn5" : pressed = 5;
										break;
				case "btn6" : pressed = 6;
										break;
				case "btn7" : pressed = 7;
										break;
				case "btn8" : pressed = 8;
										break;
				case "btn9" : pressed = 9;
										break;
				case "btn0" : pressed = 0;
										break;
				case "btnClear" : txtPassword.text = txtPassword.text.substr(0, txtPassword.length - 1); 
								  stringPassUser = stringPassUser.substr(0, stringPassUser.length - 1); 
								  return;
										break;
				case "btnEnter" : checkStep(); 
								  return;
										break;
			}
			
			txtPassword.appendText("*");
			stringPassUser += pressed.toString();
		}
		
		private function loadPass():void {
			conn.addEventListener(SQLEvent.OPEN, openHandler);
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			
			//appicationDirectory is where our AIR app is (in bin)
			var folder:File = File.applicationDirectory;
			var dbFile:File = folder.resolvePath("dbase.db");
			
			conn.open(dbFile); //synchronous
		}
		
		private function openHandler(event:SQLEvent):void {
			getPattern();
		}
		
		private function errorHandler(event:SQLErrorEvent):void {
			
		}
		
		private function getPattern():void {
			selectStmt = new SQLStatement();
			selectStmt.sqlConnection = conn;
			var sql:String = "select pass from passnum";
			selectStmt.text = sql;
			
			selectStmt.addEventListener(SQLEvent.RESULT, getDataSuccess);
			selectStmt.addEventListener(SQLErrorEvent.ERROR, getDataError);
			
			selectStmt.execute();
		}
		
		private function getDataSuccess(event:SQLEvent):void {
			var result:SQLResult = selectStmt.getResult();
			var row:Object = new Object();
			row = result.data[0];
			stringPassDB = row.pass;
		}
		
		private function getDataError(event:SQLErrorEvent):void {
			
		}
		
		private function checkStep():void {
			if(step == 1){
				if (!checkPass(stringPassDB, stringPassUser)) {
					txtMessage.text = "PASSWORD yang Anda masukkan salah. Silakan coba lagi."
					stringPassUser = "";
					txtPassword.text = "";
				}
				else {
					step = 2;
					txtStep.text = "STEP 2. MASUKKAN PASSWORD BARU";
					txtMessage.text = "";
					stringPassUser = "";
					txtPassword.text = "";
				}
			}
			else if (step == 2) {
				// simpan pola di array baru				
				stringPassNew = stringPassUser;
				stringPassUser = "";
				step = 3;
				txtStep.text = "STEP 3. KONFIRMASI PASSWORD BARU";
				txtMessage.text = "";
				txtPassword.text = "";
			}
			else if (step == 3) {
				if (!checkPass(stringPassNew, stringPassUser)) {
					txtMessage.text = "PASSWORD baru tidak sama. Silakan masukkan lagi password baru."
					stringPassUser = "";
					txtPassword.text = "";
				}
				else {
					step = 0;
					txtStep.text = "PASSWORD BARU TELAH DISIMPAN.";
					txtMessage.text = "";
					
					mcKotak.visible = false;
					txtPassword.visible = false;
					btn1.visible = false;
					btn2.visible = false;
					btn3.visible = false;
					btn4.visible = false;
					btn5.visible = false;
					btn6.visible = false;
					btn7.visible = false;
					btn8.visible = false;
					btn9.visible = false;
					btn0.visible = false;
					btnClear.visible = false;
					btnEnter.visible = false;
					
					var updateStmt:SQLStatement = new SQLStatement();
					updateStmt.sqlConnection = conn;
					
					// UPDATE table_name
					// SET column1 = value1, column2 = value2...., columnN = valueN
					// WHERE [condition];
					
					var sql:String = "UPDATE PASSNUM SET pass = " + stringPassNew;
					updateStmt.text = sql;
					updateStmt.execute();
				}
			}
		}
		private function checkPass(pass1:String, pass2:String):Boolean {
			if (pass1 == pass2) {
				return true;
			}
			else {
				trace("login failed, tried to compare " + pass1 + " and " + pass2);
				return false;
			}
		}
		
	}

}