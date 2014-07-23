package Screen 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.errors.SQLError;
	import flash.events.MouseEvent;
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.events.Event;
	
	// Tween
	import com.greensock.*;
	import com.greensock.easing.*;
	/**
	 * ...
	 * @author vikachew
	 */
	public class ScreenOrgP extends SCREEN_ORGP
	{
		private var mainClass:Main;
		private var selectedOrg:int;
		private var selectedEmp:int;
		
		private var selectStmt:SQLStatement;		
		private var selectStmt2:SQLStatement;
		private var conn:SQLConnection;
		
		private var container:MovieClip;
		private var imageMC:MovieClip;
		
		public function ScreenOrgP(passedClass:Main, passedOrg:int, passedEmp:int) 
		{
			mainClass = passedClass;
			selectedOrg = passedOrg;
			selectedEmp = passedEmp;
			inAnimation();
		}
		
		public function init():void
		{
			if (mainClass.bahasa) {
				mcORRed.txtORRed.text = "STRUKTUR\nORGANISASI";
			}
			else {
				mcORRed.txtORRed.text = "ORGANIZATION\nSTRUCTURE";
			}
			btnBack.addEventListener(MouseEvent.CLICK, navHandler);
			btnDIR.addEventListener(MouseEvent.CLICK, navHandler);
			btnDE.addEventListener(MouseEvent.CLICK, navHandler);
			btnEPI.addEventListener(MouseEvent.CLICK, navHandler);
			btnPSPM.addEventListener(MouseEvent.CLICK, navHandler);
			btnPM.addEventListener(MouseEvent.CLICK, navHandler);
			btnPM2.addEventListener(MouseEvent.CLICK, navHandler);
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "btnBack" : if (selectedOrg == 0){mainClass.showSplash(new ScreenOrg0(mainClass));}
								 else {mainClass.showSplash(new ScreenOrgStructure(mainClass, selectedOrg));}
										break;
				case "btnDIR" : mainClass.showSplash(new ScreenOrg0(mainClass));
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
		
		private function setTextColor():void {
			var formatSelected:TextFormat = new TextFormat(); 
			var formatNotSelected:TextFormat = new TextFormat(); 
			formatSelected.color = 0xC01F2D; 
			formatNotSelected.color = 0xD4D4D4; 
			
			if (selectedOrg == 0) {
				mcArrow.y = btnDIR.y; 
				btnDIR.txtDIR.setTextFormat(formatSelected);
				btnDE.txtDE.setTextFormat(formatNotSelected);
				btnPSPM.txtPSPM.setTextFormat(formatNotSelected);
				btnEPI.txtEPI.setTextFormat(formatNotSelected);		
				btnPM.txtPM.setTextFormat(formatNotSelected);
				btnPM2.txtPM2.setTextFormat(formatNotSelected);
			}
			else if(selectedOrg == 1) {
				mcArrow.y = btnDE.y; 
				btnDIR.txtDIR.setTextFormat(formatNotSelected);
				btnDE.txtDE.setTextFormat(formatSelected);
				btnPSPM.txtPSPM.setTextFormat(formatNotSelected);
				btnEPI.txtEPI.setTextFormat(formatNotSelected);		
				btnPM.txtPM.setTextFormat(formatNotSelected);
				btnPM2.txtPM2.setTextFormat(formatNotSelected);
			}
			else if(selectedOrg == 2) {
				mcArrow.y = btnPSPM.y; 
				btnDIR.txtDIR.setTextFormat(formatNotSelected);
				btnDE.txtDE.setTextFormat(formatNotSelected);
				btnPSPM.txtPSPM.setTextFormat(formatSelected);
				btnEPI.txtEPI.setTextFormat(formatNotSelected);
				btnPM.txtPM.setTextFormat(formatNotSelected);
				btnPM2.txtPM2.setTextFormat(formatNotSelected);
			}
			else if(selectedOrg == 3) {
				mcArrow.y = btnEPI.y; 
				btnDIR.txtDIR.setTextFormat(formatNotSelected);
				btnDE.txtDE.setTextFormat(formatNotSelected);
				btnPSPM.txtPSPM.setTextFormat(formatNotSelected);
				btnEPI.txtEPI.setTextFormat(formatSelected);
				btnPM.txtPM.setTextFormat(formatNotSelected);
				btnPM2.txtPM2.setTextFormat(formatNotSelected);
			}
			else if(selectedOrg == 4) {
				mcArrow.y = btnPM.y; 
				btnDIR.txtDIR.setTextFormat(formatNotSelected);
				btnDE.txtDE.setTextFormat(formatNotSelected);
				btnPSPM.txtPSPM.setTextFormat(formatNotSelected);
				btnEPI.txtEPI.setTextFormat(formatNotSelected);
				btnPM.txtPM.setTextFormat(formatSelected);
				btnPM2.txtPM2.setTextFormat(formatNotSelected);
			}
			else if(selectedOrg == 5) {
				mcArrow.y = btnPM2.y; 
				btnDIR.txtDIR.setTextFormat(formatNotSelected);
				btnDE.txtDE.setTextFormat(formatNotSelected);
				btnPSPM.txtPSPM.setTextFormat(formatNotSelected);
				btnEPI.txtEPI.setTextFormat(formatNotSelected);
				btnPM.txtPM.setTextFormat(formatNotSelected);
				btnPM2.txtPM2.setTextFormat(formatSelected);
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
			selectStmt2 = new SQLStatement();
			selectStmt.sqlConnection = conn;
			selectStmt2.sqlConnection = conn;
			
			var sql:String = "select * from employee where idemp = " + selectedEmp;
			selectStmt.text = sql;
			selectStmt.addEventListener(SQLEvent.RESULT, getDataSuccess);
			selectStmt.execute();
		}
		
		private function getDataSuccess(event:SQLEvent):void {
			var result:SQLResult = selectStmt.getResult();
			var row:Object = result.data[0]; 
			
			var format:TextFormat = new TextFormat(); 
			format.color = 0xFFFFFF; 
			format.font = "myFont"; 
			format.size = 48;
			
			container = new MovieClip();
			
			// Gambar
			imageMC = new MovieClip();
			var myLoader:Loader = new Loader();
			var fileRequest:URLRequest;
			if (row.pathFoto == null || row.pathFoto == "" || row.pathFoto == "null") fileRequest = new URLRequest("Images/Emp/default-emp.png");
			else fileRequest = new URLRequest(row.pathFoto);
			myLoader.load(fileRequest);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			imageMC.addChild(myLoader);
			imageMC.y = 145;
			imageMC.x = 90;
			
			// nama
			var txtNama:TextField = new TextField();
			txtNama.text = row.nama;
			txtNama.setTextFormat(format); 
			txtNama.embedFonts = true;
			txtNama.autoSize = "left";
			txtNama.selectable = false;
			txtNama.x = 250;
			txtNama.y = 227.65;
			
			// Label Jabatan
			var txtLabelJabatan:TextField = new TextField();
			if (mainClass.bahasa) txtLabelJabatan.text = "Jabatan";
			else txtLabelJabatan.text = "Role";
			format.size = 21;
			txtLabelJabatan.setTextFormat(format);
			txtLabelJabatan.embedFonts = true;
			txtLabelJabatan.autoSize = "left";
			txtLabelJabatan.selectable = false;
			txtLabelJabatan.x = 250;
			txtLabelJabatan.y = 357.9;
			
			// Jabatan
			var txtJabatan:TextField = new TextField();
			trace(row.nama + " " + row.jabatanId + " " + row.jabatanEn);
			if (row.jabatanEn == null || row.jabatanEn == "" || row.jabatanEn == "null") txtJabatan.text = "-";
			else txtJabatan.text = row.jabatanEn;
			format.size = 21;
			txtJabatan.setTextFormat(format);
			txtJabatan.embedFonts = true;
			txtJabatan.autoSize = "left";
			txtJabatan.selectable = false;
			txtJabatan.x = 407.85;
			txtJabatan.y = 357.9;
			
			// Label Kompetensi
			var txtLabelKomp:TextField = new TextField();
			if (mainClass.bahasa) txtLabelKomp.text = "Kompetensi";
			else txtLabelKomp.text = "Competence";
			txtLabelKomp.setTextFormat(format);
			txtLabelKomp.embedFonts = true;
			txtLabelKomp.autoSize = "left";
			txtLabelKomp.selectable = false;
			txtLabelKomp.x = 250;
			txtLabelKomp.y = 393.55;
			
			// Kompetensi
			var txtKomp:TextField = new TextField();
			if (row.kompetensi == null || row.kompetensi == "" || row.kompetensi == "null") txtKomp.text = " -";
			else txtKomp.text = row.kompetensi;
			txtKomp.setTextFormat(format);
			txtKomp.embedFonts = true;
			txtKomp.width = 600;
			txtKomp.autoSize = "left";
			txtKomp.multiline = true;
			txtKomp.wordWrap = true;
			txtKomp.selectable = false;
			txtKomp.x = 407.85;
			txtKomp.y = 393.55;
			
			// Label Since
			var txtLabelSince:TextField = new TextField();
			if (mainClass.bahasa) txtLabelSince.text = "Sejak";
			else txtLabelSince.text = "Since";
			txtLabelSince.setTextFormat(format);
			txtLabelSince.embedFonts = true;
			txtLabelSince.autoSize = "left";
			txtLabelSince.selectable = false;
			txtLabelSince.x = 250;
			txtLabelSince.y = txtKomp.y + txtKomp.height + 5;
			trace("txtLabelSince " + txtLabelSince.x + " " + txtLabelSince.y);
			
			// Since
			var txtSince:TextField = new TextField();
			if (row.since == null || row.since == "" || row.since == "null") txtSince.text = " -";
			else txtSince.text = row.since;
			txtSince.setTextFormat(format);
			txtSince.embedFonts = true;
			txtSince.autoSize = "left";
			txtSince.selectable = false;
			txtSince.x = 407.85;
			txtSince.y = txtLabelSince.y;
			
			// Label Experience
			var txtLabelExp:TextField = new TextField();
			if (mainClass.bahasa) txtLabelExp.text = "Pengalaman";
			else txtLabelExp.text = "Experience";
			txtLabelExp.setTextFormat(format);
			txtLabelExp.embedFonts = true;
			txtLabelExp.autoSize = "left";
			txtLabelExp.selectable = false;
			txtLabelExp.x = 250;
			txtLabelExp.y = txtSince.y + txtSince.height + 5;
			
			// Experience
			var txtExp:TextField = new TextField();
			if (row.experience == null || row.experience == "" || row.experience == "null") txtExp.text = " -";
			else txtExp.text = row.experience;
			txtExp.setTextFormat(format);
			txtExp.embedFonts = true;
			txtExp.width = 600;
			txtExp.autoSize = "left";
			txtExp.multiline = true;
			txtExp.wordWrap = true;
			txtExp.selectable = false;
			txtExp.x = 407.85;
			txtExp.y = txtLabelExp.y;
			
			/*
			// LabelEmail
			var txtLabelEmail:TextField = new TextField();
			txtLabelEmail.text = "Email";
			txtLabelEmail.setTextFormat(format);
			txtLabelEmail.embedFonts = true;
			txtLabelEmail.autoSize = "left";
			txtLabelEmail.selectable = false;
			txtLabelEmail.x = 250;
			txtLabelEmail.y = 513.55;
			
			// Email
			var txtEmail:TextField = new TextField();
			if (row.email == null || row.email == "" || row.email == "null") txtEmail.text = " -";
			else txtEmail.text = row.email;
			txtEmail.setTextFormat(format);
			txtEmail.embedFonts = true;
			txtEmail.autoSize = "left";
			txtEmail.selectable = false;
			txtEmail.x = 407.85;
			txtEmail.y = 513.55;
			*/
			
			// ADD
			container.addChild(imageMC);
			container.addChild(txtNama);
			container.addChild(txtLabelJabatan);
			container.addChild(txtJabatan);
			container.addChild(txtLabelKomp);
			container.addChild(txtKomp);
			container.addChild(txtLabelSince);
			container.addChild(txtSince);
			container.addChild(txtLabelExp);
			container.addChild(txtExp);
			//container.addChild(txtLabelEmail);
			//container.addChild(txtEmail);
			
			container.alpha = 0;
			addChild(container);
			containerAnimation();
		}
		
		private function onImageLoaded(e:Event):void {			
			var targetLoader:Loader = Loader(e.target.loader);
			targetLoader.width = 100;
			targetLoader.height = 120;
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
			setTextColor();
			init();
			conn = new SQLConnection();
			loadDb();
		}
		
		private function containerAnimation():void {
			TweenLite.to(container, 0.5, { alpha:1, delay: 0.9, ease:Circ.easeOut } );
		}
	}

}