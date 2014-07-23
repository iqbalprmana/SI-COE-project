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
	public class ScreenSetting1 extends SCREEN_SETTINGS1
	{
		private var mainClass:Main;
		private var selectStmt:SQLStatement;
		private var conn:SQLConnection;
		private var stringPassDB:String;
		private var stringPassUser:String;
		
		public function ScreenSetting1(passedClass:Main) 
		{
			mainClass = passedClass;
			init();
			conn = new SQLConnection();
			stringPassUser = "";
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
				case "btnBack" : mainClass.showSplash(new ScreenHome(mainClass));
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
				case "btnEnter" : checkPass(); 
								  txtPassword.text = "";
								  stringPassUser = "";
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
			trace(stringPassDB);
			conn.close();
		}
		
		private function getDataError(event:SQLErrorEvent):void {
			
		}
		
		private function checkPass():void {
			if (stringPassDB == stringPassUser) {
				mainClass.showSplash(new ScreenAdmin(mainClass));
			}
			else {
				trace("login failed, tried to compare " + stringPassUser + " and " + stringPassDB);
			}
		}
		
	}

}