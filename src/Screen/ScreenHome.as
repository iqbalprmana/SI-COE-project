package Screen 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// Tween
	import com.greensock.*;
	import com.greensock.easing.*;
	/**
	 * ...
	 * @author vikachew
	 */
	public class ScreenHome extends SCREEN_HOME
	{
		private var mainClass:Main;
		
		// animation out
		private var outTimeline:TimelineLite;
		private var targetBtn:String;
		
		public function ScreenHome(passedClass:Main) 
		{
			mainClass = passedClass;
			inAnimation();
			init();
			setTrackerPos(); // gallery
		}
		
		public function init():void
		{
			if (!mainClass.bahasa) {
				btnLangId.visible = true;
				btnLangEn.visible = false;
				
				// translate to English
				mcAboutUs.txtAboutUs.text = "ABOUT US";
				mcPP.txtPP.text = "PROJECT\nPERFORMANCE";
				mcTechDev.txtTechDev.text = "TECHNOLOGY\nDEVELOPMENT";
				mcFuture.txtFuture.text = "TO THE FUTURE";
				mcOrgStructure.txtOrgStructure.text = "ORGANIZATION\nSTRUCTURE";
				btnSetting.txtSetting.text = "SETTING";
				mcAboutUs2.txtAboutUs.text = "ABOUT US";
				mcPP2.txtPP.text = "PROJECT\nPERFORMANCE";
				mcTechDev2.txtTechDev.text = "TECHNOLOGY\nDEVELOPMENT";
				mcFuture2.txtFuture.text = "TO THE FUTURE";
				mcOrgStructure2.txtOrgStructure.text = "ORGANIZATION\nSTRUCTURE";
				btnSetting2.txtSetting.text = "SETTING";
			}
			else {
				btnLangId.visible = false;
				btnLangEn.visible = true;
				
				// translate to Indonesia
				mcAboutUs.txtAboutUs.text = "TENTANG KAMI";
				mcPP.txtPP.text = "PERFORMA\nPROYEK";
				mcTechDev.txtTechDev.text = "PENGEMBANGAN\nTEKNOLOGI";
				mcFuture.txtFuture.text = "PROYEK MENDATANG";
				mcOrgStructure.txtOrgStructure.text = "STRUKTUR\nORGANISASI";
				mcAboutUs2.txtAboutUs.text = "TENTANG KAMI";
				mcPP2.txtPP.text = "PERFORMA\nPROYEK";
				mcTechDev2.txtTechDev.text = "PENGEMBANGAN\nTEKNOLOGI";
				mcFuture2.txtFuture.text = "PROYEK MENDATANG";
				mcOrgStructure2.txtOrgStructure.text = "STRUKTUR\nORGANISASI";
				btnSetting.txtSetting.text = "PENGATURAN";
				btnSetting2.txtSetting.text = "PENGATURAN";
			}
			
			mainClass.mcBgShd.addEventListener("change", setTracker);
			
			btnLangEn.addEventListener(MouseEvent.CLICK, langHandler);
			btnLangId.addEventListener(MouseEvent.CLICK, langHandler);
			
			mcPP.addEventListener(MouseEvent.CLICK, navHandler);
			mcAboutUs.addEventListener(MouseEvent.CLICK, navHandler);
			mcTechDev.addEventListener(MouseEvent.CLICK, navHandler);
			mcFuture.addEventListener(MouseEvent.CLICK, navHandler);
			mcOrgStructure.addEventListener(MouseEvent.CLICK, navHandler);
			btnSetting.addEventListener(MouseEvent.CLICK, navHandler);
		}
		
		private function navHandler(e:MouseEvent):void {
			switch(e.currentTarget.name)
			{
				case "mcPP" : mcPP2.visible = true;
										break;
				case "mcAboutUs" : mcAboutUs2.visible = true;
										break;
				case "mcTechDev" : mcTechDev2.visible = true;
										break;
				case "mcFuture" : mcFuture2.visible = true;
										break;
				case "mcOrgStructure" : mcOrgStructure2.visible = true;
										break;
				case "btnSetting" : btnSetting2.visible = true;
										break;
			}
			
			targetBtn = e.currentTarget.name
			outTimeline = new TimelineLite( { onComplete:outOfPage } );
			if (targetBtn == "mcFuture") outTimeline.append(new TweenLite(mcFuture2, 0.15, { alpha:0.5, ease:Circ.easeOut } )); outTimeline.append(new TweenLite(mcFuture2, 0.1, { alpha:1, ease:Circ.easeOut } ));
			if (targetBtn == "mcTechDev") outTimeline.append(new TweenLite(mcTechDev2, 0.15, { alpha:0.5, ease:Circ.easeOut } )); outTimeline.append(new TweenLite(mcTechDev2, 0.1, { alpha:1, ease:Circ.easeOut } ));
			if (targetBtn == "mcAboutUs") outTimeline.append(new TweenLite(mcAboutUs2, 0.15, { alpha:0.5, ease:Circ.easeOut } )); outTimeline.append(new TweenLite(mcAboutUs2, 0.1, { alpha:1, ease:Circ.easeOut } ));
			if (targetBtn == "mcPP") outTimeline.append(new TweenLite(mcPP2, 0.15, { alpha:0.5, ease:Circ.easeOut } )); outTimeline.append(new TweenLite(mcPP2, 0.1, { alpha:1, ease:Circ.easeOut } ));
			if (targetBtn == "mcOrgStructure") outTimeline.append(new TweenLite(mcOrgStructure2, 0.15, { alpha:0.5, ease:Circ.easeOut } )); outTimeline.append(new TweenLite(mcOrgStructure2, 0.1, { alpha:1, ease:Circ.easeOut } ));
			if (targetBtn == "btnSetting") outTimeline.append(new TweenLite(btnSetting2, 0.15, { alpha:0.5, ease:Circ.easeOut } )); outTimeline.append(new TweenLite(btnSetting2, 0.1, { alpha:1, ease:Circ.easeOut } ));
			outTimeline.append(new TweenLite(txtTitle, 0.2, { alpha:0, scaleY:0.8, scaleX:0.8, ease:Circ.easeOut } ));
			outTimeline.append(new TweenLite(mcLogo, 0.2, { alpha:0, scaleY:0.8, scaleX:0.8, ease:Circ.easeOut } ));
			if(targetBtn != "mcFuture") outTimeline.append(new TweenLite(mcFuture, 0.2, { alpha:0, scaleY:0.8, scaleX:0.8, ease:Circ.easeOut } ));
			if(targetBtn != "mcTechDev") outTimeline.append(new TweenLite(mcTechDev, 0.2, { alpha:0, scaleY:0.8, scaleX:0.8, ease:Circ.easeOut } ));
			if(targetBtn != "mcAboutUs") outTimeline.append(new TweenLite(mcAboutUs, 0.2, { alpha:0, scaleY:0.8, scaleX:0.8, ease:Circ.easeOut } ));
			if(targetBtn != "mcPP") outTimeline.append(new TweenLite(mcPP, 0.2, { alpha:0, scaleY:0.8, scaleX:0.8, ease:Circ.easeOut } ));
			if (targetBtn != "mcOrgStructure") outTimeline.append(new TweenLite(mcOrgStructure, 0.2, { alpha:0, scaleY:0.8, scaleX:0.8, ease:Circ.easeOut } ));
			if(targetBtn != "btnSetting") outTimeline.append(new TweenLite(btnSetting, 0.2, { alpha:0, scaleY:0.8, scaleX:0.8, ease:Circ.easeOut } ));
			
			switch(targetBtn)
			{
				case "mcPP" : mcPP.visible = false;
							  outTimeline.append(new TweenLite(mcPP2, 0.2, { alpha:0, scaleX: 0.8, scaleY: 0.8, ease:Circ.easeOut} ));
										break;
				case "mcAboutUs" : mcAboutUs.visible = false;
							  outTimeline.append(new TweenLite(mcAboutUs2, 0.2, { alpha:0, scaleX: 0.8, scaleY: 0.8, ease:Circ.easeOut} ));
										break;
				case "mcTechDev" : mcTechDev.visible = false;
							  outTimeline.append(new TweenLite(mcTechDev2, 0.2, { alpha:0, scaleX: 0.8, scaleY: 0.8, ease:Circ.easeOut} ));
										break;
				case "mcFuture" : mcFuture.visible = false;
							  outTimeline.append(new TweenLite(mcFuture2, 0.2, { alpha:0, scaleX: 0.8, scaleY: 0.8, ease:Circ.easeOut} ));
										break;
				case "mcOrgStructure" : mcOrgStructure.visible = false;
							  outTimeline.append(new TweenLite(mcOrgStructure2, 0.2, { alpha:0, scaleX: 0.8, scaleY: 0.8, ease:Circ.easeOut} ));
										break;
				case "btnSetting" : btnSetting.visible = false;
							  outTimeline.append(new TweenLite(btnSetting2, 0.2, { alpha:0, scaleX: 0.8, scaleY: 0.8, ease:Circ.easeOut} ));
										break;
			}
		}
		
		private function langHandler(e:MouseEvent):void {
			if (!mainClass.bahasa) {
				btnLangEn.visible = true;
				btnLangId.visible = false;
				mainClass.bahasa = true;
				
				// translate to Indonesia
				mcAboutUs.txtAboutUs.text = "TENTANG KAMI";
				mcPP.txtPP.text = "PERFORMA\nPROYEK";
				mcTechDev.txtTechDev.text = "PENGEMBANGAN\nTEKNOLOGI";
				mcFuture.txtFuture.text = "PROYEK MENDATANG";
				mcOrgStructure.txtOrgStructure.text = "STRUKTUR\nORGANISASI";
				mcAboutUs2.txtAboutUs.text = "TENTANG KAMI";
				mcPP2.txtPP.text = "PERFORMA\nPROYEK";
				mcTechDev2.txtTechDev.text = "PENGEMBANGAN\nTEKNOLOGI";
				mcFuture2.txtFuture.text = "PROYEK MENDATANG";
				mcOrgStructure2.txtOrgStructure.text = "STRUKTUR\nORGANISASI";
				btnSetting.txtSetting.text = "PENGATURAN";
				btnSetting2.txtSetting.text = "PENGATURAN";
			}
			else {
				btnLangId.visible = true;
				btnLangEn.visible = false;
				mainClass.bahasa = false;
				
				// translate to English
				mcAboutUs.txtAboutUs.text = "ABOUT US";
				mcPP.txtPP.text = "PROJECT\nPERFORMANCE";
				mcTechDev.txtTechDev.text = "TECHNOLOGY\nDEVELOPMENT";
				mcFuture.txtFuture.text = "TO THE FUTURE";
				mcOrgStructure.txtOrgStructure.text = "ORGANIZATION\nSTRUCTURE";
				mcAboutUs2.txtAboutUs.text = "ABOUT US";
				mcPP2.txtPP.text = "PROJECT\nPERFORMANCE";
				mcTechDev2.txtTechDev.text = "TECHNOLOGY\nDEVELOPMENT";
				mcFuture2.txtFuture.text = "TO THE FUTURE";
				mcOrgStructure2.txtOrgStructure.text = "ORGANIZATION\nSTRUCTURE";
				btnSetting.txtSetting.text = "SETTING";
				btnSetting2.txtSetting.text = "SETTING";
			}
		}
		
		private function setTracker(e:Event):void {
			setTrackerPos();
		}
		
		private function setTrackerPos():void {
			if (mainClass.whichBg == 1) {
				mcBgTrack.mcBgPos.x = 0;
			}
			else if (mainClass.whichBg == 2) {
				mcBgTrack.mcBgPos.x = 58;
			}
			else if (mainClass.whichBg == 3) {
				mcBgTrack.mcBgPos.x = 116;
			}
			else if (mainClass.whichBg == 4) {
				mcBgTrack.mcBgPos.x = 174;
			}
			else if (mainClass.whichBg == 5) {
				mcBgTrack.mcBgPos.x = 232;
			}
			else if (mainClass.whichBg == 6) {
				mcBgTrack.mcBgPos.x = 290;
			}
		}
		
		private function inAnimation():void {
			mcOrgStructure.alpha = 0;
			mcAboutUs.alpha = 0;
			mcLogo.alpha = 0;
			mcTechDev.alpha = 0;
			mcPP.alpha = 0;
			mcFuture.alpha = 0;
			txtTitle.alpha = 0;
			
			mcOrgStructure.scaleX = 0.8;
			mcAboutUs.scaleX = 0.8;
			mcLogo.scaleX = 0.8;
			mcTechDev.scaleX = 0.8;
			mcPP.scaleX = 0.8;
			mcFuture.scaleX = 0.8;
			txtTitle.scaleX = 0.8;
			
			mcOrgStructure.scaleY = 0.8;
			mcAboutUs.scaleY = 0.8;
			mcLogo.scaleY = 0.8;
			mcTechDev.scaleY = 0.8;
			mcPP.scaleY = 0.8;
			mcFuture.scaleY = 0.8;
			txtTitle.scaleY = 0.8;

			mcOrgStructure2.visible = false;
			mcAboutUs2.visible = false;
			mcTechDev2.visible = false;
			mcPP2.visible = false;
			mcFuture2.visible = false;
			btnSetting2.visible = false;
			
			TweenLite.to(txtTitle, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.9, ease:Circ.easeOut, onComplete: inAnim2()} );
		}
		
		private function inAnim2():void {
			TweenLite.to(mcFuture, 0.5, { alpha:1, scaleX:1, scaleY:1, delay: 0.8, ease:Circ.easeOut, onComplete: inAnim3()} );
		}
		
		private function inAnim3():void {
			TweenLite.to(mcLogo, 0.5, {alpha:1, scaleX:1, scaleY:1, delay: 0.7, ease:Circ.easeOut, onComplete: inAnim4()});
		}
		
		private function inAnim4():void {
			TweenLite.to(mcTechDev, 0.5, {alpha:1, scaleX:1, scaleY:1, delay: 0.6, ease:Circ.easeOut, onComplete: inAnim5()});
		}
		
		private function inAnim5():void {
			TweenLite.to(mcAboutUs, 0.5, {alpha:1, scaleX:1, scaleY:1, delay: 0.5, ease:Circ.easeOut, onComplete: inAnim6()});
		}
		
		private function inAnim6():void {
			TweenLite.to(mcPP, 0.5, {alpha:1, scaleX:1, scaleY:1, delay: 0.4, ease:Circ.easeOut, onComplete: inAnim7()});
		}
		
		private function inAnim7():void {
			TweenLite.to(mcOrgStructure, 0.5, {alpha:1, scaleY:1, scaleX:1, delay: 0.3});
		}
		
		private function outOfPage():void {
			switch(targetBtn)
			{
				case "mcPP" : mainClass.showSplash(new ScreenPP1(mainClass, 5));
										break;
				case "mcAboutUs" : mainClass.showSplash(new ScreenAbout2(mainClass));
										break;
				//case "mcTechDev" : mainClass.showSplash(new ScreenTechDev(mainClass, 5));
				case "mcTechDev" : mainClass.showSplash(new ScreenTechDev1(mainClass));
										break;
				case "mcFuture" : mainClass.showSplash(new ScreenFuture(mainClass));
										break;
				case "mcOrgStructure" : mainClass.showSplash(new ScreenOrg0(mainClass));
										break;
				case "btnSetting" : mainClass.showSplash(new ScreenSetting1(mainClass));
									break;
			}
		}
	}

}