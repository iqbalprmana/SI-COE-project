package Screen 
{
	import Asset.McAlert;
	import Asset.McLoading;
	import Asset.McShade;
	import flash.data.SQLResult;
	import flash.display.MovieClip;
	import flash.errors.SQLError;
	import flash.events.MouseEvent;
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.events.OutputProgressEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.events.Event;
	
	import Asset.BtnDelete;
	/**
	 * ...
	 * @author vikachew
	 */
	public class ScreenManajemen3 extends SCREEN_MANAJEMEN3
	{
		private var mainClass:Main;
		private var imageAvailable:Boolean;
		private var videoAvailable:Boolean;
		
		private var selectStmt:SQLStatement;
		private var selectStmt2:SQLStatement;
		private var selectImages:SQLStatement;
		private var deleteImages:SQLStatement;
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
		
		// 1: Project Performance
		// 2: Tech Development
		// 3: Future Project
		private var numTable:int;
		private var numID:int;
		
		// delete images & update
		private var arIdImg:Array;
		private var arPathImg:Array;
		private var flagIdImgBerubah:Array;
		private var idVid:int;
		private var pathOldVid:String;
		private var flagVidBerubah:Boolean;
		
		private var mcAlert = new McAlert;
		private var mcShade = new McShade;
		
		// progres 
		private var mcLoading:McLoading;
		private var loadTimer:Timer;
		private var flagUpdate:Boolean;
		private var flagCopyVideo:Boolean;
		private var isCopying:Boolean;
		
		public function ScreenManajemen3(passedClass:Main, passedTable:int, passedID:int) 
		{
			mainClass = passedClass;
			numTable = passedTable;
			numID = passedID;
			arIdImg = new Array();
			for (var i:int = 0; i < 6; i++) {
				arIdImg[i] = 0;
			}
			arPathImg = new Array();
			for (var i:int = 0; i < 6; i++) {
				arPathImg[i] = "";
			}
			flagIdImgBerubah = new Array();
			for (var i:int = 0; i < 6; i++) {
				flagIdImgBerubah[i] = false;
			}
			pathOldVid = "";
			flagVidBerubah = false;
			isCopying = false;
			
			init();
			conn = new SQLConnection();
			loadDb();
		}
		
		public function init():void
		{
			btnSP.visible = false;
			btnSG.visible = false;
			btnST.visible = false;
			btnSTh.visible = false;
			btnSI.visible = false;
			
			btnDD2.addEventListener(MouseEvent.CLICK, dd2Handler);
			
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			btnSave.addEventListener(MouseEvent.CLICK, navHandler);
			btnAddImage.addEventListener(MouseEvent.CLICK, navHandler);
			if (numTable != 3) btnAddVideo.addEventListener(MouseEvent.CLICK, navHandler);
			
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
			flagUpdate = false;
			flagCopyVideo = false;
		}
		
		private function dd2Handler(e:MouseEvent):void {
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
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : mainClass.showSplash(new ScreenManajemen1(mainClass));
										break;
				case "btnSave" : updateTable();
										break;
				case "btnAddImage" : addNewImage(); 
									break;	
				case "btnAddVideo" : addNewVideo(); 
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
			if (numTable == 1) {
				sql = "select * from projectperformance where idpp = " + numID;
			}
			else if (numTable == 2) {
				sql = "select * from techdev where idtd = " + numID;
			}
			selectStmt.text = sql;
			
			selectStmt.addEventListener(SQLEvent.RESULT, getDataSuccess);
			
			selectStmt.execute();
		}
		
		private function getDataSuccess(event:SQLEvent):void {
			var result:SQLResult = selectStmt.getResult();
			var row:Object = result.data[0]; 
			
			txtFormJudul.text = row.judul;
			if (numTable == 1) {
				txtFormLokasi.text = row.lokasi;
			}
			else if (numTable == 2) {
				txtFormLokasi.visible = false;
				mcKotakLokasi.visible = false;
				txtLabelLokasi.visible = false;
			}
			txtFormScope.text = row.scopeOfWork;
			txtFormArea.text = row.area;
			txtFormStatus.text = row.period;
			if (numTable == 1) {
				txtFormSumId.text = row.sumId;
				txtFormArtId.text = row.artikelId;
				if (row.sumEn != null && row.sumEn != "" && row.sumEn != "null") txtFormSumEn.text = row.sumEn;
				if (row.artikelEn != null && row.artikelEn != "" && row.artikelEn != "null") txtFormArtEn.text = row.artikelEn;
			}
			else if (numTable == 2) {
				txtFormSumId.text = row.outlineId;
				txtFormArtId.text = row.outcomeId;
				if (row.outlineEn != null && row.outlineEn != "" && row.outlineEn != "null") txtFormSumEn.text = row.outlineEn;
				if (row.outcomeEn != null && row.outcomeEn != "" && row.outcomeEn != "null") txtFormArtEn.text = row.outcomeEn;
			}
			
			
			if (row.idsemen == 1) txtFormSemen.text = "Semen Gresik";
			else if (row.idsemen == 2) txtFormSemen.text = "Semen Padang";
			else if (row.idsemen == 3) txtFormSemen.text = "Semen Tonasa";
			else if (row.idsemen == 4) txtFormSemen.text = "Semen Thanglong";
			else if (row.idsemen == 5) txtFormSemen.text = "Semen Indonesia";
			
			if (row.pathImg != null && row.pathImg != "" && row.pathImg != "null") {
				selectImages = new SQLStatement();
				selectImages.sqlConnection = conn;
				var sql:String;
				if (numTable == 1) {
					sql = "select * from ppimages where idpp = " + numID;
				}
				else if (numTable == 2) {
					sql = "select * from tdimages where idtd = " + numID;
				}
				trace(sql);
				selectImages.text = sql;
				
				selectImages.addEventListener(SQLEvent.RESULT, getImgSuccess);
				selectImages.execute();
			}
			
			if (row.pathVid != null && row.pathVid != "" && row.pathVid != "null") {
				var format:TextFormat = new TextFormat(); 
				
				// generate txt
				txtVid = new TextField();
				txtVid.text = getVidNameOnly(row.pathVid);
				pathOldVid = row.pathVid;
				format.color = 0xFFFFFF; 
				format.font = "myFont"; 
				format.size = 16;
				
				txtVid.setTextFormat(format); 
				txtVid.embedFonts = true;
				txtVid.x = 990;
				txtVid.y = 580;
				txtVid.width = 200;
				txtVid.height = 50;
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
		}
		
		private function getImgSuccess(event:SQLEvent):void {
			var result:SQLResult = selectImages.getResult();
			
			numImg = 0;
			if (result.data != null) {
				numImg = result.data.length; 
			}
			
			if (numImg == 0) return;
			
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			format.size = 16;
			
			trace(numImg);
			
			if (numImg >= 1) {
				arIdImg[0] = result.data[0].idimg;
				arPathImg[0] = result.data[0].pathImg;
				//txtImg.text = result.data[0].pathImg;
				txtImg.text = getImgNameOnly(result.data[0].pathImg);
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
			if (numImg >= 2) {
				arIdImg[1] = result.data[1].idimg;
				arPathImg[1] = result.data[1].pathImg;
				txtImg2.text = getImgNameOnly(result.data[1].pathImg);
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
			if (numImg >= 3) {
				arIdImg[2] = result.data[2].idimg;
				arPathImg[2] = result.data[2].pathImg;
				txtImg3.text = getImgNameOnly(result.data[2].pathImg);
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
			if (numImg >= 4) {
				arIdImg[3] = result.data[3].idimg;
				arPathImg[3] = result.data[3].pathImg;
				txtImg4.text = getImgNameOnly(result.data[3].pathImg);
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
			if (numImg >= 5) {
				arIdImg[4] = result.data[4].idimg;
				arPathImg[4] = result.data[4].pathImg;
				txtImg5.text = getImgNameOnly(result.data[4].pathImg);
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
			if (numImg >= 6) {
				arIdImg[5] = result.data[5].idimg;
				arPathImg[5] = result.data[5].pathImg;
				txtImg6.text = getImgNameOnly(result.data[5].pathImg);
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
			
			trace("arPathImg");
			for (var k:int = 0; k < 6; k++) {
				trace(arPathImg[k]);
			}
			
			if(numImg == 6) imageAvailable = true;			
		}
		
		private function getImgNameOnly(toCut:String):String {
			var newStr:String;
			for (var n:int = 0; n < toCut.length; n++) {
				if (toCut.charAt(n) == "/") newStr = toCut.substring(n + 1, toCut.length);
			}
			return newStr;
		}
		
		private function getVidNameOnly(toCut:String):String {
			var newStr:String;
			for (var n:int = 0; n < toCut.length; n++) {
				if (toCut.charAt(n) == "\\") newStr = toCut.substring(n + 1, toCut.length);
			}
			return newStr;
		}
		
		private function deleteImage(e:MouseEvent):void {
			removeChild(txtImg);
			removeChild(btnDelImg);
			numImg--;
			txtImg.text = "";
			flagIdImgBerubah[0] = true;
		}
		
		private function deleteImage2(e:MouseEvent):void {
			removeChild(txtImg2);
			removeChild(btnDelImg2);
			numImg--;
			txtImg2.text = "";
			flagIdImgBerubah[1] = true;
		}
		
		private function deleteImage3(e:MouseEvent):void {
			removeChild(txtImg3);
			removeChild(btnDelImg3);
			numImg--;
			txtImg3.text = "";
			flagIdImgBerubah[2] = true;
		}
		
		private function deleteImage4(e:MouseEvent):void {
			removeChild(txtImg4);
			removeChild(btnDelImg4);
			numImg--;
			txtImg4.text = "";
			flagIdImgBerubah[3] = true;
		}
		
		private function deleteImage5(e:MouseEvent):void {
			removeChild(txtImg5);
			removeChild(btnDelImg5);
			numImg--;
			txtImg5.text = "";
			flagIdImgBerubah[4] = true;
		}
		
		private function deleteImage6(e:MouseEvent):void {
			removeChild(txtImg6);
			removeChild(btnDelImg6);
			numImg--;
			txtImg6.text = "";
			flagIdImgBerubah[5] = true;
		}
		
		private function updateTable():void {
			if(cekFormFull()){
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
			startUpdate();
		}
		
		private function startUpdate():void {
			var updateStmt:SQLStatement = new SQLStatement();
			updateStmt.sqlConnection = conn;
			
			// UPDATE table_name
			// SET column1 = value1, column2 = value2...., columnN = valueN
			// WHERE [condition];
			
			// menentukan idsemen
			var idsemen:int;
			if (txtFormSemen.text.charAt(7) == "a") idsemen = 2;
			else if (txtFormSemen.text.charAt(7) == "r") idsemen = 1;
			else if (txtFormSemen.text.charAt(7) == "o") idsemen = 3;
			else if (txtFormSemen.text.charAt(7) == "h") idsemen = 4;
			else if (txtFormSemen.text.charAt(7) == "n") idsemen = 5;
				
			// menentukan apakah perlu mengupdate pathVid?
			// kalau video berubah, maka 
			// 1. delete video lama (nanti di bawah)
			// 2. update pathVid dengan path yang baru (sekarang)
			var fileVidName:String;
			if (videoAvailable) {
				if (flagVidBerubah || pathOldVid == "") {
					if (numTable == 1) fileVidName = "Videos\\PP\\" + numID + "\\" + txtVid.text;
					else if(numTable == 2) fileVidName = "Videos\\TD\\" + numID + "\\" + txtVid.text;
				}
				else fileVidName = pathOldVid;
			}

			// lakukan update kecuali untuk pathImg because they're such a pain
			var timeNow:Date = new Date();
			var sql:String;
			if (numTable == 1) {
				sql = "UPDATE PROJECTPERFORMANCE SET judul = '" + tesPetik(txtFormJudul.text) + 
													"', idsemen = '" + idsemen + 
													"', sumId = '" + tesPetik(txtFormSumId.text) + 
													"', sumEn = '" + tesPetik(txtFormSumEn.text) + 
													"', artikelId = '" + tesPetik(txtFormArtId.text) + 
													"', artikelEn = '" + tesPetik(txtFormArtEn.text) + 
													"', lokasi = '" + tesPetik(txtFormLokasi.text) + 
													"', scopeOfWork = '" + tesPetik(txtFormScope.text) + 
													"', period = '" + tesPetik(txtFormStatus.text) + 
													"', area = '" + tesPetik(txtFormArea.text) + 
													"', pathVid = '" + fileVidName +
													"', lastEdit = '" + timeNow.getTime() +
													"' WHERE idpp = " + numID;
			}
			else {
				sql = "UPDATE TECHDEV SET judul = '" + tesPetik(txtFormJudul.text) + 
													"', idsemen = '" + idsemen + 
													"', outlineId = '" + tesPetik(txtFormSumId.text) + 
													"', outlineEn = '" + tesPetik(txtFormSumEn.text) + 
													"', outcomeId = '" + tesPetik(txtFormArtId.text) + 
													"', outcomeEn = '" + tesPetik(txtFormArtEn.text) + 
													"', scopeOfWork = '" + tesPetik(txtFormScope.text) + 
													"', period = '" + tesPetik(txtFormStatus.text) + 
													"', area = '" + tesPetik(txtFormArea.text) + 
													"', pathVid = '" + fileVidName +
													"', lastEdit = '" + timeNow.getTime() +
													"' WHERE idtd = " + numID;
			}
				
			updateStmt.text = sql;
			updateStmt.execute();
			
			trace("txtImgs: " + txtImg.text + " " + txtImg2.text + " " + txtImg3.text + " " + txtImg4.text + " " + txtImg5.text + " " + txtImg6.text);
			trace("flag berubah mulai indeks 0: " + flagIdImgBerubah[0] + " " + flagIdImgBerubah[1] + " " + flagIdImgBerubah[2]
							+ " " + flagIdImgBerubah[3] + " " + flagIdImgBerubah[4] + " " + flagIdImgBerubah[5]);
			trace("ARpathImg mulai indeks 0: " + arPathImg[0] + " " + arPathImg[1] + " " + arPathImg[2]
							+ " " + arPathImg[3] + " " + arPathImg[4] + " " + arPathImg[5]);
			trace("num Img " + numImg);
			
			// this is the fun part!!
			// tentukan apakah perlu mengupdate pathImg
			// caranya: cari gambar yang berubah saja...
			// 1. delete gambar lama
			for (var n:int = 0; n < 6; n++) {
				if (flagIdImgBerubah[n] == true && arPathImg[n] != "") {
					//delete file from arPathImg
					var fileToDelete:String = arPathImg[n];
					var pathToFile:String = File.applicationDirectory.resolvePath(fileToDelete).nativePath;
					var someFile:File = new File(pathToFile);
					someFile.deleteFile();
					
					trace("file yang didelete " + arPathImg[n]);
					
					//delete record with ID arIdImg
					deleteImages = new SQLStatement();
					deleteImages.sqlConnection = conn;	
					
					var sql:String;
					if (numTable == 1) sql = "DELETE FROM PPIMAGES WHERE idimg = '" + arIdImg[n] + "'";
					else sql = "DELETE FROM TDIMAGES WHERE idimg = '" + arIdImg[n] + "'";
					deleteImages.text = sql;
					deleteImages.execute();
				}
			}
			
			// 2. insert record gambar baru/yang berubah saja
			var fileImgName:String;
			var fileImgName2:String;
			var fileImgName3:String;
			var fileImgName4:String;
			var fileImgName5:String;
			var fileImgName6:String;
			
			// 1
			if (txtImg.text != "" && flagIdImgBerubah[0]) {
				if (numTable == 1) fileImgName = "Images/PP/" + numID + "/" + imgFile.name;
				else fileImgName = "Images/TD/" + numID + "/" + imgFile.name;
				trace("// 1");
				
				//insert new record to PPIMAGES
				var insertStmt:SQLStatement = new SQLStatement();
				insertStmt.sqlConnection = conn;
				var sql:String;
				if (numTable == 1) sql = "INSERT INTO PPIMAGES VALUES (" + numID + ",NULL,'" + fileImgName + "')";
				else sql = "INSERT INTO TDIMAGES VALUES (NULL,'" + numID + "','" + fileImgName + "')";
				insertStmt.text = sql;
				insertStmt.execute();
			
				//copy new image txtimg
				var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName).nativePath;
				var someFile:File = new File(pathToFile);
				imgFile.copyToAsync(someFile);
			}
			
			// 2
			if (txtImg2.text != "" && flagIdImgBerubah[1]) {
				if (numTable == 1) fileImgName2 = "Images/PP/" + numID + "/" + imgFile2.name;
				else fileImgName2 = "Images/TD/" + numID + "/" + imgFile2.name;
				trace("// 2");
				
				//insert new record to PPIMAGES
				var insertStmt2:SQLStatement = new SQLStatement();
				insertStmt2.sqlConnection = conn;
				var sql2:String;
				if (numTable == 1) sql2 = "INSERT INTO PPIMAGES VALUES (" + numID + ",NULL,'" + fileImgName2 + "')";
				else sql2 = "INSERT INTO TDIMAGES VALUES (NULL,'" + numID + "','" + fileImgName2 + "')";
				insertStmt2.text = sql2;
				insertStmt2.execute();
			
				//copy new image txtimg
				var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName2).nativePath;
				var someFile:File = new File(pathToFile);
				imgFile2.copyToAsync(someFile);
			}
			
			// 2
			if (txtImg3.text != "" && flagIdImgBerubah[2]) {
				if (numTable == 1) fileImgName3 = "Images/PP/" + numID + "/" + imgFile3.name;
				else fileImgName3 = "Images/TD/" + numID + "/" + imgFile3.name;
				trace("// 3");
				
				//insert new record to PPIMAGES
				var insertStmt3:SQLStatement = new SQLStatement();
				insertStmt3.sqlConnection = conn;
				var sql3:String;
				if (numTable == 1) sql3 = "INSERT INTO PPIMAGES VALUES (" + numID + ",NULL,'" + fileImgName3 + "')";
				else sql3 = "INSERT INTO TDIMAGES VALUES (NULL,'" + numID + "','" + fileImgName3 + "')";
				insertStmt3.text = sql3;
				insertStmt3.execute();
			
				//copy new image txtimg
				var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName3).nativePath;
				var someFile:File = new File(pathToFile);
				imgFile3.copyToAsync(someFile);
			}
			
			// 4
			if (txtImg4.text != "" && flagIdImgBerubah[3]) {
				if (numTable == 1) fileImgName4 = "Images/PP/" + numID + "/" + imgFile4.name;
				else fileImgName4 = "Images/TD/" + numID + "/" + imgFile4.name;
				trace("// 4");
				
				//insert new record to PPIMAGES
				var insertStmt4:SQLStatement = new SQLStatement();
				insertStmt4.sqlConnection = conn;
				var sql4:String;
				if (numTable == 1) sql4 = "INSERT INTO PPIMAGES VALUES (" + numID + ",NULL,'" + fileImgName4 + "')";
				else sql4 = "INSERT INTO TDIMAGES VALUES (NULL,'" + numID + "','" + fileImgName4 + "')";
				insertStmt4.text = sql4;
				insertStmt4.execute();
			
				//copy new image txtimg
				var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName4).nativePath;
				var someFile:File = new File(pathToFile);
				imgFile4.copyToAsync(someFile);
			}
			
			// 5
			if (txtImg5.text != "" && flagIdImgBerubah[4]) {
				if (numTable == 1) fileImgName5 = "Images/PP/" + numID + "/" + imgFile5.name;
				else fileImgName5 = "Images/TD/" + numID + "/" + imgFile5.name; 
				trace("// 5");
				
				//insert new record to PPIMAGES
				var insertStmt5:SQLStatement = new SQLStatement();
				insertStmt5.sqlConnection = conn;
				var sql5:String;
				if (numTable == 1) sql5 = "INSERT INTO PPIMAGES VALUES (" + numID + ",NULL,'" + fileImgName5 + "')";
				else sql5 = "INSERT INTO TDIMAGES VALUES (NULL,'" + numID + "','" + fileImgName5 + "')";
				insertStmt5.text = sql5;
				insertStmt5.execute();
			
				//copy new image txtimg
				var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName5).nativePath;
				var someFile:File = new File(pathToFile);
				imgFile5.copyToAsync(someFile);
			}
			
			// 6
			if (txtImg6.text != "" && flagIdImgBerubah[5]) {
				if (numTable == 1) fileImgName6 = "Images/PP/" + numID + "/" + imgFile6.name;
				else fileImgName6 = "Images/TD/" + numID + "/" + imgFile6.name;
				trace("// 6");
				
				//insert new record to PPIMAGES
				var insertStmt6:SQLStatement = new SQLStatement();
				insertStmt6.sqlConnection = conn;
				var sql6:String;
				if (numTable == 1) sql6 = "INSERT INTO PPIMAGES VALUES (" + numID + ",NULL,'" + fileImgName6 + "')";
				else sql6 = "INSERT INTO TDIMAGES VALUES (NULL,'" + numID + "','" + fileImgName6 + "')";
				insertStmt6.text = sql6;
				insertStmt6.execute();
			
				//copy new image txtimg
				var pathToFile:String = File.applicationDirectory.resolvePath(fileImgName6).nativePath;
				var someFile:File = new File(pathToFile);
				imgFile6.copyToAsync(someFile);
			}
				
			// tentukan pathImg yang baru untuk project performance ini
			var fileImgPP:String = "";
			if (txtImg.text != "") {
				if (numTable == 1) fileImgPP = "Images/PP/" + numID + "/" + txtImg.text;
				else fileImgPP = "Images/TD/" + numID + "/" + txtImg.text;
			}
			else if (txtImg2.text != "") {
				if (numTable == 1) fileImgPP = "Images/PP/" + numID + "/" + txtImg2.text;
				else fileImgPP = "Images/TD/" + numID + "/" + txtImg2.text;
			}
			else if (txtImg3.text != "") {
				if (numTable == 1) fileImgPP = "Images/PP/" + numID + "/" + txtImg3.text;
				else fileImgPP = "Images/TD/" + numID + "/" + txtImg3.text;
			}
			else if (txtImg4.text != "") {
				if (numTable == 1) fileImgPP = "Images/PP/" + numID + "/" + txtImg4.text;
				else fileImgPP = "Images/TD/" + numID + "/" + txtImg4.text;
			}
			else if (txtImg5.text != "") {
				if (numTable == 1) fileImgPP = "Images/PP/" + numID + "/" + txtImg5.text;
				else fileImgPP = "Images/TD/" + numID + "/" + txtImg5.text;
			}
			else if (txtImg6.text != "") {
				if (numTable == 1) fileImgPP = "Images/PP/" + numID + "/" + txtImg6.text;
				else fileImgPP = "Images/TD/" + numID + "/" + txtImg6.text;
			}
				
			// update pathImg
			var updateStmt2:SQLStatement = new SQLStatement();
			updateStmt2.sqlConnection = conn;
			
			var sqlUpdate2:String;
			if (numTable == 1) {
				sqlUpdate2 = "UPDATE PROJECTPERFORMANCE SET pathImg = '" + fileImgPP +
														"' WHERE idpp = " + numID;
			}
			else {
				sqlUpdate2 = "UPDATE TECHDEV SET pathImg = '" + fileImgPP +
														"' WHERE idtd = " + numID;
			}
					
			updateStmt2.text = sqlUpdate2;
			updateStmt2.execute();
		
			// delete video jika
			if (flagVidBerubah || pathOldVid == "") {
				// user punya video di pathOldVid
				if (pathOldVid != "") {
					
					var fileToDelete:String = pathOldVid;
					var pathToFile:String = File.applicationDirectory.resolvePath(fileToDelete).nativePath;
					var someFile:File = new File(pathToFile);
					someFile.deleteFile();
				}
				
				// lalu copy video baru
				if (videoAvailable) {
					isCopying = true;
					var pathToFile:String = File.applicationDirectory.resolvePath(fileVidName).nativePath;
					var someFile:File = new File(pathToFile);
					vidFile.addEventListener(Event.COMPLETE, copyDone);
					vidFile.copyToAsync(someFile, true);
					mcLoading.txtProgress.text = "Copying file...";
				}
			}
			
			flagUpdate = true;
			cekUpdateDone();
		}
		
		private function ProgressHandler(e:OutputProgressEvent):void 
		{
			trace("Uploaded : " + e.bytesPending, e.bytesTotal);
		}
		
		private function copyDone(event:Event):void {
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
			if (isCopying) {
				if (flagUpdate && flagCopyVideo){
					mcLoading.mcLoad.visible = false;
					mcLoading.txtProgress.width = 300;
					mcLoading.txtProgress.text = "ARTIKEL BERHASIL DISIMPAN";
					var myTimer:Timer = new Timer(2000, 1);
					myTimer.start();
					myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerAllDone);
				}
			}
			else {
				if (flagUpdate){
					mcLoading.mcLoad.visible = false;
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
		
		private function cekFormFull():Boolean {
			if(numTable ==1){
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
			else {
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
				flagIdImgBerubah[0] = true;
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
				flagIdImgBerubah[1] = true;
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
				flagIdImgBerubah[2] = true;
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
				flagIdImgBerubah[3] = true;
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
				flagIdImgBerubah[4] = true;
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
				flagIdImgBerubah[5] = true;
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
			txtVid.height = 50;
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
			flagVidBerubah = true;
		}
		
		private function tesPetik(input:String):String {
			return(input.replace("'", "\'\'"));
		}
	}

}