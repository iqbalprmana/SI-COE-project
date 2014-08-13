package Screen 
{
	import Asset.McAlert;
	import Asset.McLoading;
	import Asset.McShade;
	import flash.data.SQLResult;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.errors.SQLError;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.events.Event;
	import flash.filesystem.FileMode;
	import flash.utils.ByteArray;
	
	import Asset.BtnDelete;
	
	/**
	 * ...
	 * @author vikachew
	 */
	public class ScreenManajemen2 extends SCREEN_MANAJEMEN2
	{
		private var mainClass:Main;
		private var imageAvailable:Boolean;
		private var videoAvailable:Boolean;
		
		private var selectStmt:SQLStatement;
		private var selectStmt2:SQLStatement;
		private var conn:SQLConnection;
		
		private var numImg:int;
		private var imgFile:File;
		private var imgFile2:File;
		private var imgFile3:File;
		private var imgFile4:File;
		private var imgFile5:File;
		private var imgFile6:File;
		
		private var vidFile:File;
		
		private var txtImg:TextField;
		private var txtImg2:TextField;
		private var txtImg3:TextField;
		private var txtImg4:TextField;
		private var txtImg5:TextField;
		private var txtImg6:TextField;
		
		private var txtVid:TextField;
		private var btnDelImg:BtnDelete;
		private var btnDelImg2:BtnDelete;
		private var btnDelImg3:BtnDelete;
		private var btnDelImg4:BtnDelete;
		private var btnDelImg5:BtnDelete;
		private var btnDelImg6:BtnDelete;
		
		private var btnDelVid:BtnDelete;
		
		private var mcAlert = new McAlert;
		private var mcShade = new McShade;
		
		// progres 
		private var mcLoading:McLoading;
		private var loadTimer:Timer;
		private var flagUpdate:Boolean;
		private var flagCopyVideo:Boolean;
		private var inStream:FileStream;
		private var outStream:FileStream;
		private var progressBar:MC_VID_FILLRED;
		
		// 1: Project Performance
		// 2: Tech Development
		// 3: Future Project
		private var numTable:int;
		
		public function ScreenManajemen2(passedClass:Main, passedTable:int) 
		{
			mainClass = passedClass;
			numTable = passedTable;
			init();
			initEditor();
			imageAvailable = false;
			videoAvailable = false;
		}
		
		public function init():void
		{
			btnPP.visible = false;
			btnFT.visible = false;
			btnTD.visible = false;
			btnSP.visible = false;
			btnSG.visible = false;
			btnST.visible = false;
			btnSTh.visible = false;
			btnSI.visible = false;
			
			btnDD1.addEventListener(MouseEvent.CLICK, dd1Handler);
			btnDD2.addEventListener(MouseEvent.CLICK, dd2Handler);
			
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			btnSave.addEventListener(MouseEvent.CLICK, navHandler);
			btnAddImage.addEventListener(MouseEvent.CLICK, navHandler);
			if (numTable != 3) btnAddVideo.addEventListener(MouseEvent.CLICK, navHandler);
			
			btnPP.addEventListener(MouseEvent.CLICK, tableHandler);
			btnFT.addEventListener(MouseEvent.CLICK, tableHandler);
			btnTD.addEventListener(MouseEvent.CLICK, tableHandler);
			btnSP.addEventListener(MouseEvent.CLICK, sHandler);
			btnSG.addEventListener(MouseEvent.CLICK, sHandler);
			btnST.addEventListener(MouseEvent.CLICK, sHandler);
			btnSTh.addEventListener(MouseEvent.CLICK, sHandler);
			btnSI.addEventListener(MouseEvent.CLICK, sHandler);
			
			txtImg = new TextField();
			txtImg2 = new TextField();
			txtImg3 = new TextField();
			txtImg4 = new TextField();
			txtImg5 = new TextField();
			txtImg6 = new TextField();
			txtImg.text = "";
			txtImg2.text = "";
			txtImg3.text = "";
			txtImg4.text = "";			
			txtImg5.text = "";
			txtImg6.text = "";
			numImg = 0;
			flagUpdate = false;
			flagCopyVideo = false;
		}
		
		private function dd1Handler(e:MouseEvent):void {
			if (btnSP.visible) toggleDD2Visible();
			toggleDD1Visible();
		}
		
		private function toggleDD1Visible():void {
			if (!btnFT.visible) {
				btnFT.visible = true;
				btnPP.visible = true;
				btnTD.visible = true;
				mcKotakSemen.visible = false;
				txtFormSemen.visible = false;
			}
			else {
				btnFT.visible = false;
				btnPP.visible = false;
				btnTD.visible = false;
				mcKotakSemen.visible = true;
				txtFormSemen.visible = true;
			}
		}
		
		private function dd2Handler(e:MouseEvent):void {
			if (btnFT.visible) toggleDD1Visible();
			toggleDD2Visible();
		}
		
		private function toggleDD2Visible():void {
			if (!btnSP.visible) {
				btnSP.visible = true;
				btnSG.visible = true;
				btnST.visible = true;
				btnSTh.visible = true;
				btnSI.visible = true;
			}
			else {
				btnSP.visible = false;
				btnSG.visible = false;
				btnST.visible = false;
				btnSTh.visible = false;
				btnSI.visible = false;
			}
		}
		
		private function initEditor():void {
			if (numTable == 1) {
				txtTable.text = "PROJECT PERFORMANCE";
				txtFormSemen.text = "Semen Gresik";
				txtLabelSum.text = "Outline:";
				txtLabelArt.text = "Outcome:";
			}
			else if (numTable == 2) {
				txtTable.text = "TECH DEVELOPMENT";
				mcKotakLokasi.visible = false;
				txtFormLokasi.visible = false;
				txtLabelLokasi.visible = false;
			}
			else if (numTable == 3) {
				txtTable.text = "FUTURE PROJECT";
			}
		}
		
		private function tableHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnPP" : mainClass.showSplash(new ScreenManajemen2(mainClass, 1));
										break;
				case "btnTD" : mainClass.showSplash(new ScreenManajemen2(mainClass, 2));
										break;
				case "btnFT" : mainClass.showSplash(new ScreenManajemen2(mainClass, 3));
										break;
			}
		}
		private function sHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnSP" : txtFormSemen.text = "Semen Padang";
										break;
				case "btnSG" : txtFormSemen.text = "Semen Gresik";
										break;
				case "btnST" : txtFormSemen.text = "Semen Tonasa";
										break;
				case "btnSTh" : txtFormSemen.text = "Semen Thanglong";
										break;
				case "btnSI" : txtFormSemen.text = "Semen Indonesia";
										break;
			}
			
			toggleDD2Visible();
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenManajemen1(mainClass));
										break;
				case "btnSave" : addNewRecord(); 
									break;	
				case "btnAddImage" : addNewImage(); 
									break;	
				case "btnAddVideo" : addNewVideo(); 
									break;	
			}
		}
		
		private function addNewRecord():void {
			if (cekFormFull()) {
				viewProgress();
			}
		}
		
		private function viewProgress():void {
			// bikin progress
			mcLoading = new McLoading();
			
			// addChild progrees
			addChild(mcLoading);
			
			var myTimer:Timer = new Timer(1000, 1);
			myTimer.start();
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerDone);
			
			loadTimer = new Timer(500, 0);
			loadTimer.addEventListener(TimerEvent.TIMER_COMPLETE, animateLoad);
			loadTimer.start();
		}

		private function animateLoad(e:TimerEvent):void {
			var evt:Event = new Event("next");
			mcLoading.dispatchEvent(evt);
		}
		
		private function timerDone(e:TimerEvent):void {
			startInsert();
		}
		
		private function startInsert():void {
			conn = new SQLConnection();
			conn.addEventListener(SQLEvent.OPEN, openHandler);
			conn.addEventListener(SQLErrorEvent.ERROR, errorHandler);
			
			var folder:File = File.applicationDirectory;
			var dbFile:File = folder.resolvePath("dbase.db");
			
			conn.open(dbFile); //sync
			
			var insertStmt:SQLStatement = new SQLStatement();
			insertStmt.sqlConnection = conn;
			var sql:String;
		
			//var fileVidName:String;
			//if (numTable != 3) if(videoAvailable) fileVidName = "Videos\\" + vidFile.name;

			var idsemen:int;
			if (txtFormSemen.text.charAt(7) == "a") idsemen = 2;
			else if (txtFormSemen.text.charAt(7) == "r") idsemen = 1;
			else if (txtFormSemen.text.charAt(7) == "o") idsemen = 3;
			else if (txtFormSemen.text.charAt(7) == "h") idsemen = 4;
			else if (txtFormSemen.text.charAt(7) == "n") idsemen = 5;
				
			// insert to project performance / future project / techdev
			// tes petik untuk deteksi apostrophe, diganti sama double apostrophe
			var timeNow:Date = new Date();
			if (numTable == 1) {					
				sql =	"INSERT INTO PROJECTPERFORMANCE VALUES ('" + timeNow.getTime() + "','" + tesPetik(txtFormScope.text) + "','" + tesPetik(txtFormStatus.text) + "','" 
						+ tesPetik(txtFormArea.text) + "',NULL," + idsemen + ",'" + tesPetik(txtFormJudul.text) + "','" + tesPetik(txtFormSumId.text) + "','" 
						+ tesPetik(txtFormSumEn.text) + "','','','" 
						+ tesPetik(txtFormStatus.text) + "','" + tesPetik(txtFormLokasi.text) + "','" + tesPetik(txtFormArtId.text) + "','" + tesPetik(txtFormArtEn.text) + "')";
			}
			else if(numTable == 2) {
				sql =	"INSERT INTO TECHDEV VALUES (NULL," + idsemen + ",'" + tesPetik(txtFormJudul.text) + "','" + tesPetik(txtFormScope.text) + "','" 
						+ tesPetik(txtFormStatus.text) + "','" + tesPetik(txtFormArea.text) + "','" + tesPetik(txtFormArtId.text) + "','" + tesPetik(txtFormArtEn.text) + "','"
						+ tesPetik(txtFormSumId.text) + "','" + tesPetik(txtFormSumEn.text) + "','','','" + timeNow.getTime() + "')";
			}
			else if (numTable == 3) {
				sql =	"INSERT INTO FUTUREPROJECT VALUES ('','" + txtFormArtEn.text + "','"
						+ txtFormSumEn.text + "',NULL,'" + txtFormJudul.text + "','" + txtFormSumId.text + "','" + txtFormArtId.text + "')";
			}
				
			insertStmt.text = sql;
			insertStmt.execute();
			
			// what to do with images and video
			// project performance, tech dev
			if (numTable == 1 || numTable == 2) insertImagesRecord();
		}
		
		// images for PROJECT PERFORMANCE, TECH DEV
		private function insertImagesRecord():void {
			// get the id of the project performance
			selectStmt2 = new SQLStatement();
			selectStmt2.sqlConnection = conn;
			
			var sql:String;
			
			if (numTable == 1) {
				sql = "select * from projectperformance where judul = '" + txtFormJudul.text + "' AND scopeOfWork = '"
																				+ txtFormScope.text + "' AND area = '"
																				+ txtFormArea.text + "' AND period = '"
																				+ txtFormStatus.text + "' AND lokasi = '"
																				+ txtFormLokasi.text + "'";
			}
			else if (numTable == 2) {
				sql = "select * from techdev where judul = '" + txtFormJudul.text + "' AND scopeOfWork = '"
																				+ txtFormScope.text + "' AND area = '"
																				+ txtFormArea.text + "' AND period = '"
																				+ txtFormStatus.text + "'";
			}
			selectStmt2.text = sql;
			
			selectStmt2.addEventListener(SQLEvent.RESULT, getData2Success);
			selectStmt2.addEventListener(SQLErrorEvent.ERROR, getData2Error);
			
			selectStmt2.execute();
		}
		
		private function getData2Success(event:SQLEvent):void {
			var result:SQLResult = selectStmt2.getResult();
			var row:Object = result.data[0]; 
			var idppnew:String;
			if (numTable == 1) idppnew = row.idpp;
			else idppnew = row.idtd;
			
			// 1. insert images record to PPIMAGES/TDIMAGES and copy the files
			// 2. copy the video file
			// 3. update the projectperformance/techdev record
			
			// 1. insert images record to PPIMAGES/TDIMAGES and copy the files
			var fileImgName:String;
			var fileImgName2:String;
			var fileImgName3:String;
			var fileImgName4:String;
			var fileImgName5:String;
			var fileImgName6:String;
			var fileImgPP:String = "";
			
			if (txtImg.text != "") {
				if (numTable == 1) {
					fileImgName = "Images/PP/" + idppnew + "/" + imgFile.name;
				}
				else {
					fileImgName = "Images/TD/" + idppnew + "/" + imgFile.name;
				}
			}
			if (txtImg2.text != "") {
				if (numTable == 1) {
					fileImgName2 = "Images/PP/" + idppnew + "/" + imgFile2.name;
				}
				else {
					fileImgName2 = "Images/TD/" + idppnew + "/" + imgFile2.name;
				}
			}
			if (txtImg3.text != "") {
				if (numTable == 1) {
					fileImgName3 = "Images/PP/" + idppnew + "/" + imgFile3.name;
				}
				else {
					fileImgName3 = "Images/TD/" + idppnew + "/" + imgFile3.name;
				}
			}
			if (txtImg4.text != "") {
				if (numTable == 1) {
					fileImgName4 = "Images/PP/" + idppnew + "/" + imgFile4.name;
				}
				else {
					fileImgName4 = "Images/TD/" + idppnew + "/" + imgFile4.name;
				}
			}
			if (txtImg5.text != "") {
				if (numTable == 1) {
					fileImgName5 = "Images/PP/" + idppnew + "/" + imgFile5.name;
				}
				else {
					fileImgName5 = "Images/TD/" + idppnew + "/" + imgFile5.name;
				}
			}
			if (txtImg6.text != "") {
				if (numTable == 1) {
					fileImgName6 = "Images/PP/" + idppnew + "/" + imgFile6.name;
				}
				else {
					fileImgName6 = "Images/TD/" + idppnew + "/" + imgFile6.name;
				}
			}
				
			if (txtImg.text != ""){
				var insertStmt:SQLStatement = new SQLStatement();
				insertStmt.sqlConnection = conn;
				var sql2:String;
				if (numTable == 1) sql2 = "INSERT INTO PPIMAGES VALUES (" + idppnew + ",NULL,'" + fileImgName + "')";
				else sql2 = "INSERT INTO TDIMAGES VALUES (NULL,'" + idppnew + "','" + fileImgName + "')";
				insertStmt.text = sql2;
				insertStmt.execute();
				
				var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName).nativePath;
				var someFile:File = new File(pathToFile);
				imgFile.copyToAsync(someFile);
				if (fileImgPP == "") fileImgPP = fileImgName;
				trace("1" + fileImgPP);
			}
			if (txtImg2.text != ""){
				var insertStmt2:SQLStatement = new SQLStatement();
				insertStmt2.sqlConnection = conn;
				var sql2:String;
				if (numTable == 1) sql2 = "INSERT INTO PPIMAGES VALUES (" + idppnew + ",NULL,'" + fileImgName2 + "')";
				else sql2 = "INSERT INTO TDIMAGES VALUES (NULL,'" + idppnew + "','" + fileImgName2 + "')";
				insertStmt2.text = sql2;
				insertStmt2.execute();
				
				var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName2).nativePath;
				var someFile:File = new File(pathToFile);
				imgFile2.copyToAsync(someFile);
				if (fileImgPP == "") fileImgPP = fileImgName2;
				trace("2" + fileImgPP);
			}
			if (txtImg3.text != ""){
				var insertStmt2:SQLStatement = new SQLStatement();
				insertStmt2.sqlConnection = conn;
				var sql2:String;
				if (numTable == 1) sql2 = "INSERT INTO PPIMAGES VALUES (" + idppnew + ",NULL,'" + fileImgName3 + "')";
				else sql2 = "INSERT INTO TDIMAGES VALUES (NULL,'" + idppnew + "','" + fileImgName3 + "')";
				insertStmt2.text = sql2;
				insertStmt2.execute();
				
				var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName3).nativePath;
				var someFile:File = new File(pathToFile);
				imgFile3.copyToAsync(someFile);
				if (fileImgPP == "") fileImgPP = fileImgName3;
				trace("3" + fileImgPP);
			}
			if (txtImg4.text != ""){
				var insertStmt2:SQLStatement = new SQLStatement();
				insertStmt2.sqlConnection = conn;
				var sql2:String;
				if (numTable == 1) sql2 = "INSERT INTO PPIMAGES VALUES (" + idppnew + ",NULL,'" + fileImgName4 + "')";
				else sql2 = "INSERT INTO TDIMAGES VALUES (NULL,'" + idppnew + "','" + fileImgName4 + "')";
				insertStmt2.text = sql2;
				insertStmt2.execute();
				
				var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName4).nativePath;
				var someFile:File = new File(pathToFile);
				imgFile4.copyToAsync(someFile);
				if (fileImgPP == "") fileImgPP = fileImgName4;
				trace("4" + fileImgPP);
			}
			if (txtImg5.text != ""){
				var insertStmt2:SQLStatement = new SQLStatement();
				insertStmt2.sqlConnection = conn;
				var sql2:String;
				if (numTable == 1) sql2 = "INSERT INTO PPIMAGES VALUES (" + idppnew + ",NULL,'" + fileImgName5 + "')";
				else sql2 = "INSERT INTO TDIMAGES VALUES (NULL,'" + idppnew + "','" + fileImgName5 + "')";
				insertStmt2.text = sql2;
				insertStmt2.execute();
				
				var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName5).nativePath;
				var someFile:File = new File(pathToFile);
				imgFile5.copyToAsync(someFile);
				if (fileImgPP == "") fileImgPP = fileImgName5;
				trace("5" + fileImgPP);
			}
			if (txtImg6.text != ""){
				var insertStmt2:SQLStatement = new SQLStatement();
				insertStmt2.sqlConnection = conn;
				var sql2:String;
				if (numTable == 1) sql2 = "INSERT INTO PPIMAGES VALUES (" + idppnew + ",NULL,'" + fileImgName6 + "')";
				else sql2 = "INSERT INTO TDIMAGES VALUES (NULL,'" + idppnew + "','" + fileImgName6 + "')";
				insertStmt2.text = sql2;
				insertStmt2.execute();
				
				var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName6).nativePath;
				var someFile:File = new File(pathToFile);
				imgFile6.copyToAsync(someFile);
				if (fileImgPP == "") fileImgPP = fileImgName6;
				trace("6" + fileImgPP);
			}
			
			// 2. copy the video file
			var fileVidName:String;
			if (videoAvailable) {
				copyVideoFile(idppnew);
				if (numTable == 1) fileVidName = "Videos\\PP\\" + idppnew + "\\" + vidFile.name;
				else fileVidName = "Videos\\TD\\" + idppnew + "\\" + vidFile.name;
			}
			
			// 3. update the projectperformance record
			var updateStmt:SQLStatement = new SQLStatement();
			updateStmt.sqlConnection = conn;
			
			var sql:String;
			if (numTable == 1) {
				sql = "UPDATE PROJECTPERFORMANCE SET pathVid = '" + fileVidName +
														"', pathImg = '" + fileImgPP +
														"' WHERE idpp = " + idppnew;
			}
			else {
				sql = "UPDATE TECHDEV SET pathVid = '" + fileVidName +
														"', pathImg = '" + fileImgPP +
														"' WHERE idtd = " + idppnew;
			}
					
			updateStmt.text = sql;
			updateStmt.execute();
			flagUpdate = true;
			cekUpdateDone();
		}
		
		private function copyVideoFile(numIdPP:String):void {
			var fileVidName:String;
			if (numTable == 1) {
				fileVidName = "Videos\\PP\\" + numIdPP + "\\" + vidFile.name;
			}
			else {
				fileVidName = "Videos\\TD\\" + numIdPP + "\\" + vidFile.name;
			}
			var pathToFile:String = File.applicationDirectory.resolvePath(fileVidName).nativePath;
			var someFile:File = new File(pathToFile);
			
			// stream
			inStream = new FileStream();
			outStream = new FileStream();
			
			inStream.addEventListener(ProgressEvent.PROGRESS, onProgress);
			inStream.addEventListener(Event.COMPLETE, onReady);
			
			inStream.openAsync(vidFile, FileMode.READ);
			outStream.openAsync(someFile, FileMode.WRITE);
					
			//vidFile.addEventListener(Event.COMPLETE, copyDone);
			//vidFile.copyToAsync(someFile);
			
			mcLoading.txtProgress.width = 200;
			mcLoading.txtProgress.text = "Copying...";
			
			progressBar = new MC_VID_FILLRED();
			progressBar.x = 400;
			progressBar.y = 400;
			progressBar.width = 5;
			
			var progressWhite:Shape = new Shape(); 
			progressWhite.graphics.lineStyle(1, 0x000000, 0.0); 
			progressWhite.graphics.beginFill(0xffffff, 1.0); 
			progressWhite.graphics.drawRect(progressBar.x, progressBar.y, 500, progressBar.height); 
			progressWhite.graphics.endFill(); 
			
			addChild(progressWhite);
			addChild(progressBar);
		}
		
		private function onProgress(e:ProgressEvent):void {
			// calculate the percentage
			var pct:Number = Math.round(e.bytesLoaded/e.bytesTotal*100);

			// if you want to update the progress bar:
			mcLoading.txtProgress.text = "Copying... " + pct.toString() + " %";
			progressBar.width = pct * 5;
			
			// if the ProgressEvent is fired, we have data available in the inStream, so we can start writing data
			var bytes:ByteArray = new ByteArray();
			inStream.readBytes(bytes, 0, inStream.bytesAvailable);
			outStream.writeBytes(bytes, 0, bytes.length);
		}


		private function onReady(e:Event):void {
			// the whole stream is read, so close the files
			inStream.close();
			outStream.close();

			// dispatch a COMPLETE event to let listeners to this object know the copy is done
			copyDone();
		} 
		
		private function copyDone():void {
			flagCopyVideo = true;
			mcLoading.txtProgress.text = "Finalizing...";
			
			var myTimer:Timer = new Timer(1000, 1);
			myTimer.start();
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerVideoDone);
		}
		
		private function timerVideoDone(e:TimerEvent):void {
			cekUpdateDone();
		}
		
		private function cekUpdateDone():void {
			if (videoAvailable){
				if (flagUpdate && flagCopyVideo) {	
					mcLoading.mcLoad.visible = false;
					mcLoading.txtProgress.x -= 90;
					mcLoading.txtProgress.width = 300;
					mcLoading.txtProgress.text = "ARTIKEL BERHASIL DISIMPAN";
					var myTimer:Timer = new Timer(2000, 1);
					myTimer.start();
					myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerAllDone);
				}
			}
			else {
				if (flagUpdate) {
					mcLoading.mcLoad.visible = false;
					mcLoading.txtProgress.x -= 90;
					mcLoading.txtProgress.width = 300;
					mcLoading.txtProgress.text = "ARTIKEL BERHASIL DISIMPAN";
					var myTimer:Timer = new Timer(2000, 1);
					myTimer.start();
					myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerAllDone);
				}
			}
		}
		
		private function timerAllDone(e:TimerEvent):void {
			mainClass.showSplash(new ScreenManajemen1(mainClass));
		}
		
		private function getData2Error(event:SQLErrorEvent):void {
			
		}
		
		private function cekFormFull():Boolean {
			if (numTable == 1) {
				// if english, gambar, and video is optional
				if (txtFormJudul.text != "" && txtFormStatus.text != "" && txtFormLokasi.text != "" && txtFormSemen.text != ""
				&& txtFormArea.text != "" && txtFormScope.text != ""
				&& txtFormSumId.text != "" && txtFormArtId.text != "") 
				{
					return true;
				}
				else {
					return false;
				}
			}
			else if (numTable == 2) {
				// if english, gambar, and video is optional
				if (txtFormJudul.text != "" && txtFormStatus.text != "" && txtFormSemen.text != ""
				&& txtFormArea.text != "" && txtFormScope.text != ""
				&& txtFormSumId.text != "" && txtFormArtId.text != "") 
				{
					return true;
				}
				else {
					return false;
				}
			}
			else if(numTable == 3){
				if (txtFormJudul.text != "" && txtFormSumId.text != "" && txtFormSumEn.text != "" && txtFormArtEn.text != "" && txtFormArtId.text != ""
					&& imageAvailable) {
					return true;
				}
				else {
					return false;
				}
			}
			return false;
		}
		
		private function openHandler(event:SQLEvent):void {
			
		}
		
		private function errorHandler(event:SQLErrorEvent):void {
			
		}
		
		private function addNewImage():void {
			if (numImg < 6) {
				var imageFilter:FileFilter = new FileFilter("Images", "*.png;*.jpg;*.jpeg" );
				if(txtImg.text == "") {
					imgFile = File.desktopDirectory;
					imgFile.addEventListener(Event.SELECT, onSelectedPic);
					imgFile.browseForOpen("Select a picture:", [imageFilter]);
				}
				else if (txtImg2.text == "") {
					imgFile2 = File.desktopDirectory;
					imgFile2.addEventListener(Event.SELECT, onSelectedPic);
					imgFile2.browseForOpen("Select a picture:", [imageFilter]);
				}
				else if (txtImg3.text == "") {
					imgFile3 = File.desktopDirectory;
					imgFile3.addEventListener(Event.SELECT, onSelectedPic);
					imgFile3.browseForOpen("Select a picture:", [imageFilter]);
				}
				else if (txtImg4.text == "") {
					imgFile4 = File.desktopDirectory;
					imgFile4.addEventListener(Event.SELECT, onSelectedPic);
					imgFile4.browseForOpen("Select a picture:", [imageFilter]);
				}
				else if (txtImg5.text == "") {
					imgFile5 = File.desktopDirectory;
					imgFile5.addEventListener(Event.SELECT, onSelectedPic);
					imgFile5.browseForOpen("Select a picture:", [imageFilter]);
				}
				else if (txtImg6.text == "") {
					imgFile6 = File.desktopDirectory;
					imgFile6.addEventListener(Event.SELECT, onSelectedPic);
					imgFile6.browseForOpen("Select a picture:", [imageFilter]);
				}
			}
		}
		
		private function onSelectedPic(evt:Event):void
		{
			// first check if there's a file with same name on other txtImgs
			// TO DO make alert if there is
			
			var fileName:String = evt.currentTarget.name;
			if (fileName == txtImg.text) {
				showAlert("Anda tidak dapat memilih dua gambar yang memiliki nama file yang sama.");
				return;
			}
			if (fileName == txtImg2.text) {
				showAlert("Anda tidak dapat memilih dua gambar yang memiliki nama file yang sama.");
				return;
			}
			if (fileName == txtImg3.text) {
				showAlert("Anda tidak dapat memilih dua gambar yang memiliki nama file yang sama.");
				return;
			}
			if (fileName == txtImg4.text) {
				showAlert("Anda tidak dapat memilih dua gambar yang memiliki nama file yang sama.");
				return;
			}
			if (fileName == txtImg5.text) {
				showAlert("Anda tidak dapat memilih dua gambar yang memiliki nama file yang sama.");
				return;
			}
			if (fileName == txtImg6.text) {
				showAlert("Anda tidak dapat memilih dua gambar yang memiliki nama file yang sama.");
				return;
			}
			if (fileName.search("'") != -1) {
				showAlert("Anda tidak dapat memilih gambar yang memiliki tanda petik pada nama file.");
				return;
			}
			
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			format.size = 16;
			
			var filePath:String;
			if (txtImg.text == "") {
				filePath = imgFile.name;
				txtImg.text = filePath;
				txtImg.setTextFormat(format); 
				txtImg.embedFonts = true;
				txtImg.x = 988.05; 
				txtImg.y = 464.1;
				txtImg.width = 50;
				txtImg.selectable = false;
				addChild(txtImg);
				btnDelImg = new BtnDelete;
				btnDelImg.x = 1043.35; 
				btnDelImg.y = 464.1;
				btnDelImg.addEventListener(MouseEvent.CLICK, deleteImage);
				addChild(btnDelImg);
			}
			else if (txtImg2.text == "") {
				filePath = imgFile2.name;
				txtImg2.text = filePath;
				txtImg2.setTextFormat(format); 
				txtImg2.embedFonts = true;
				txtImg2.x = 988.05; 
				txtImg2.y = 492.1;
				txtImg2.width = 50;
				txtImg2.selectable = false;
				addChild(txtImg2);
				btnDelImg2 = new BtnDelete;
				btnDelImg2.x = 1043.35;
				btnDelImg2.y = 491.9;
				btnDelImg2.addEventListener(MouseEvent.CLICK, deleteImage2);
				addChild(btnDelImg2);
			}
			else if (txtImg3.text == "") {
				filePath = imgFile3.name;
				txtImg3.text = filePath;
				txtImg3.setTextFormat(format); 
				txtImg3.embedFonts = true;
				txtImg3.x = 1078; 
				txtImg3.y = 464.1;
				txtImg3.width = 50;
				txtImg3.selectable = false;
				addChild(txtImg3);
				btnDelImg3 = new BtnDelete;
				btnDelImg3.x = 1127.3; 
				btnDelImg3.y = 464.1;
				btnDelImg3.addEventListener(MouseEvent.CLICK, deleteImage3);
				addChild(btnDelImg3);
			}
			else if (txtImg4.text == "") {
				filePath = imgFile4.name;
				txtImg4.text = filePath;
				txtImg4.setTextFormat(format); 
				txtImg4.embedFonts = true;
				txtImg4.x = 1078; 
				txtImg4.y = 492.1;
				txtImg4.width = 50;
				txtImg4.selectable = false;
				addChild(txtImg4);
				btnDelImg4 = new BtnDelete;
				btnDelImg4.x = 1127.3; 
				btnDelImg4.y = 491.9;
				btnDelImg4.addEventListener(MouseEvent.CLICK, deleteImage4);
				addChild(btnDelImg4);
			}
			else if (txtImg5.text == "") {
				filePath = imgFile5.name;
				txtImg5.text = filePath;
				txtImg5.setTextFormat(format); 
				txtImg5.embedFonts = true;
				txtImg5.x = 1158.1; 
				txtImg5.y = 464.1;
				txtImg5.width = 50;
				txtImg5.selectable = false;
				addChild(txtImg5);
				btnDelImg5 = new BtnDelete;
				btnDelImg5.x = 1214.3; 
				btnDelImg5.y = 464.1;
				btnDelImg5.addEventListener(MouseEvent.CLICK, deleteImage5);
				addChild(btnDelImg5);
			}
			else if (txtImg6.text == "") {
				filePath = imgFile6.name;
				txtImg6.text = filePath;
				txtImg6.setTextFormat(format); 
				txtImg6.embedFonts = true;
				txtImg6.x = 1158.1; 
				txtImg6.y = 492.1;
				txtImg6.width = 50;
				txtImg6.selectable = false;
				addChild(txtImg6);
				btnDelImg6 = new BtnDelete;
				btnDelImg6.x = 1214.3; 
				btnDelImg6.y = 491.9;
				btnDelImg6.addEventListener(MouseEvent.CLICK, deleteImage6);
				addChild(btnDelImg6);
			}
			
			numImg++;
			if(numImg == 6) imageAvailable = true;
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
		
		private function deleteImage(e:MouseEvent):void {
			removeChild(txtImg);
			removeChild(btnDelImg);
			numImg--;
			txtImg.text = "";
		}
		
		private function deleteImage2(e:MouseEvent):void {
			removeChild(txtImg2);
			removeChild(btnDelImg2);
			numImg--;
			txtImg2.text = "";
		}
		
		private function deleteImage3(e:MouseEvent):void {
			removeChild(txtImg3);
			removeChild(btnDelImg3);
			numImg--;
			txtImg3.text = "";
		}
		
		private function deleteImage4(e:MouseEvent):void {
			removeChild(txtImg4);
			removeChild(btnDelImg4);
			numImg--;
			txtImg4.text = "";
		}
		
		private function deleteImage5(e:MouseEvent):void {
			removeChild(txtImg5);
			removeChild(btnDelImg5);
			numImg--;
			txtImg5.text = "";
		}
		
		private function deleteImage6(e:MouseEvent):void {
			removeChild(txtImg6);
			removeChild(btnDelImg6);
			numImg--;
			txtImg6.text = "";
		}
		
		private function addNewVideo():void {
			if (!videoAvailable) {
				var videoFilter:FileFilter = new FileFilter("Videos", "*.mp4;*.flv");
				vidFile = File.desktopDirectory;
				vidFile.addEventListener(Event.SELECT, onVidSelected);
				vidFile.browseForOpen("Select MP4 or FLV video:", [videoFilter]);
			}
		}
		
		private function onVidSelected(evt:Event):void
		{
			var format:TextFormat = new TextFormat(); 
			var filePath:String = vidFile.name;
			
			if (filePath.search("'") != -1) {
				showAlert("Anda tidak dapat memilih video yang memiliki tanda petik pada nama file.");
				return;
			}
			
			// generate txt
			txtVid = new TextField();
			txtVid.text = filePath;
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			format.size = 16;
			
			txtVid.setTextFormat(format); 
			txtVid.embedFonts = true;
			txtVid.x = 990;
			txtVid.y = 580;
			txtVid.width = 200;
			txtVid.selectable = false;
			
			// generate del button
			btnDelVid = new BtnDelete;
			btnDelVid.x = 1200;
			btnDelVid.y = 580;
			btnDelVid.addEventListener(MouseEvent.CLICK, deleteVideo);
			
			addChild(txtVid);
			addChild(btnDelVid);
			
			videoAvailable = true;
		}
		
		private function deleteVideo(e:MouseEvent):void {
			removeChild(txtVid);
			removeChild(btnDelVid);
			videoAvailable = false;
		}
		
		private function tesPetik(input:String):String {
			return(input.replace("'", "\'\'"));
		}
	}
}