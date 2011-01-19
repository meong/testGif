package com.mcard.Setting
{
	

	public class Preset
	{
		public static const SITE_URL:String = "";
		//public static const SITE_URL:String = "http://222.120.91.57:8080/mcard/";
		//public static const SITE_URL:String = "http://project.fwangmeong.com/mcard/";
		public static const LOAD_URL:String = "remote/load.xml";
		public static const DOCUMENT_WH:Array = [ 900 , 700 ];
		public static const JPEG_QUALITY:Number = 100;
		public static const TEL_TYPE:Array = [ "010" , "011" , "016" , "017" , "018" , "019" ];
		
		public static const FILE_EXT:String = "*.jpg; *.gif; *.png;";	//포토갤러리 파일 업로드 페이지
		public static const FILE_MAX_UPLOAD:Number = 10;	//포토갤러리 파일 업로드 수 제한
		
		public static const SKIN_WH:Array = [ 640 , 1460 ];
		public static const SKIN_SIZE_RATE:Number = 3.63;	// 실 사이즈의  1/3.63 로 보인다.
		public static const SKIN_SIZE_RATE2:Number = 1.26;	// 실 사이즈의  1/1.26 로 보인다.
		public static const SKIN_SIZE_RATE3:Number = 2;	// 실 사이즈의  1/1.26 로 보인다.
		public static const SKIN_MIN_COUNT:Number = 6;	// 스킨 갯수 최소 6개 이상일때 정상 작동.
				
		// tweening config
		public static const EFF_TIME:Number = 0.3;
		
		// skin clip name set
		public static const SKIN_MAIN_BOX:String = "mainBox";
		public static const SKIN_SUB1_BOX:String = "subBox1";
		public static const SKIN_SUB2_BOX:String = "subBox2";
		public static const SKIN_SUB3_BOX:String = "subBox3";
		public static const SKIN_SUB4_BOX:String = "subBox4";
		public static const EVENT_STR_SAVE_DOWN:String = "ImageSaveMouseDown";
		public static const EVENT_STR_SAVE_UP:String = "ImageSaveMouseUp";
		public static const EVENT_STR_SAVE_COMPLETE:String = "ImageSaveComplete";
		public static const EVENT_STR_UPLOAD_COMPLETE:String = "ImageUploadComplete";
		public static const BODYBOX_MASK_XYWH:Array = [ 9 , 198 , 883 , 500 ];
		
		// Mcard Main
		public static const DISPATCH_STAGEINIT_COMPLETE:String = "stageInitComplete";
		// Top Navi
		public static const TOPNAVI_CLIP_XY:Array = [ 20 , 54 ] ;
		public static const TOPNAVI_BOX_XY:Array = [ 12 , 24 ] ;
		public static const TOPNAVI_WH:Array = [80 , 60];
		public static const TOPNAVI_GAP:Number = 2;
		public static const TOPNAVI_GAP2:Number = 9;
		public static const TOPNAVI_ITEM_BITMAP_NAME:String = "topNaviItemBitmap";
		public static const TOPNAVI_ITEM_NAME:String = "topNaviItem";
		
		// stage 01
		public static const BODY01_XY:Array = [ 20 , 209 ];
		public static const IMGVIEWER_MASK_WH:Array = [ 780 , 440 ];
		public static const IMGVIEWER_XY:Array = [ 40 , 5 ] ;
		public static const IMGVIEWER00_XY:Array = [ -150 , 62 ];
		public static const IMGVIEWER01_XY:Array = [ 0 , 62 ];
		public static const IMGVIEWER02_XY:Array = [ 150 , 62 ];
		public static const IMGVIEWER03_XY:Array = [ 300 ,  0 ];
		public static const IMGVIEWER04_XY:Array = [ 492 , 62 ];
		public static const IMGVIEWER05_XY:Array = [ 642 , 62 ];           
		public static const IMGVIEWER06_XY:Array = [ 792 , 62 ];
		
		//public static const IMGVIEWER01_WH:Array = [ 106.5 , 244.5 ];
		//public static const IMGVIEWER02_WH:Array = [ 213 , 489 ];
		//public static const IMGVIEWER03_WH:Array = [ 106.5 , 244.5 ];
		public static const IMGVIEWER01_RATE:Number = 1 / ( SKIN_SIZE_RATE * SKIN_SIZE_RATE2 );
		public static const IMGVIEWER02_RATE:Number = 1 / SKIN_SIZE_RATE;
		public static const IMGVIEWER03_RATE:Number = 1 / ( SKIN_SIZE_RATE * SKIN_SIZE_RATE2 );
		public static const IMGVIEWER_NAVI_Y:Number = 407;
		
		// stage 02
		public static const BODY02_XY:Array = [ 900 , 198 ];
		public static const BODY02_POSITION_GAP:Number= 9;
		public static const EDIT_BODY:Array = [ 6 , 447 , 6 ];
		public static const SBAR_CLIP:Array = [ 322 , 11 ];
		public static const SBAR_CLIP_MOVE_HEIGHT:Number = 406;
		public static const STAGE02_SKIN_WH:Array = [ 320 , 441 ];
		public static const TITLE_COMPONENT_XY:Array = [ 356.5 , 55.5 ];
		public static const TITLE_BOX_GAP:Number = 5;
		public static const MAN_COMPONENT_XY:Array = [ 365 , 170.5 ];
		public static const MAN_BOX_GAP:Number = 5;
		public static const GIRL_COMPONENT_XY:Array = [ 625 , 170.5 ];
		public static const GIRL_BOX_GAP:Number = 5;
		public static const TEL1_XY:Array = [ 16 , 11 ];
		public static const TEL1_MC_NAME:String = "tel1Mc";
		public static const TEL1_LIST_HEIGHT:Number = 108;
		public static const COPYBOX_COMBOBOX_FONTSIZE_PEOD:Array = [ 16 , 32 ] ;
		public static const COPYBOX_COLORPICKER_COLOR:Array = [ 
			0x000000 , 0x000055 , 0x0000AA , 0x0000FF , 0x009900 , 0x009955 , 0x0099AA , 0x0099FF , 0x00FF00 , 0x00FF55 , 0x00FFAA , 0x00FFFF ,
			0x550000 , 0x550055 , 0x5500AA , 0x5500FF , 0x559900 , 0x559955 , 0x5599AA , 0x5599FF , 0x55FF00 , 0x55FF55 , 0x55FFAA , 0x55FFFF ,
			0xAA0000 , 0xAA0055 , 0xAA00AA , 0xAA00FF , 0xAA9900 , 0xAA9955 , 0xAA99AA , 0xAA99FF , 0xAAFF00 , 0xAAFF55 , 0xAAFFAA , 0xAAFFFF , 
			0xFF0000 , 0xFF0055 , 0xFF00AA , 0xFF00FF , 0xFF9900 , 0xFF9955 , 0xFF99AA , 0xFF99FF , 0xFFFF00 , 0xFFFF55 , 0xFFFFAA , 0xFFFFFF
		] ;
		public static const COPYBOX_COMBOBOX_LETTERSPACING:Array = [ -5 , 5 ] ;
		public static const COPYBOX_TEXT_FONTSIZE_RATE:Number = 4;
		public static const BODY01_CLASS_STRING:String = "stage01";
		public static const BODY02_CLASS_STRING:String = "stage02";
		public static const EDIT_POP_CLASS_STRING:String = "editPop";
		public static const TOP_NAVI_CLASS_STRING:String = "topNavi";
		public static const TITLE_ITEM_STRING:String = "title";
		public static const MAN_ITEM_STRING:String = "man";
		public static const GIRL_ITEM_STRING:String = "girl";
		public static const ITEM_SLIDE_RESIZE_RATE:Number = 2;
		//viewer
		public static const VIEWERITEM_MAN_NAME:String = "ViewerItemTitleMc";
		public static const VIEWERITEM_TITLE_NAME:String = "ViewerItemManMc";
		public static const VIEWERITEM_GIRL_NAME:String = "ViewerItemGirlMc";
		public static const VIEWERITEM_TEXTFIELD_NAME:String = "ViewerItemTextFieldMc";
		public static const VIEWERITEM_TEXTFIELD_BG_NAME:String = "ViewerItemTextFieldBgMc";
		
		// edit pop
		public static const EDIT_POP_TOPNAVI_BOX_XY:Array = [ 42 , 93 ];
		public static const EDIT_POP_TOPNAVI_WH:Array = [ 78 , 58 ];
		public static const EDIT_POP_TOPNAVI_GAP:Number = 4;
		public static const EDIT_POP_LOMOBOX_XYWH:Array = [ 790 , 430 , 50 ];
		public static const EDIT_POP_LOMOBOX_DATA:Array = [ 0.7 , 0.8 , 0.9 , 1 , 1.1 , 1.2 , 1.3 , 1.4 , 1.5 , 1.6 , 1.7 , 1.8 , 1.9 , 2 ];
		public static const EDIT_POP_LOMOBOX_NAME:String = "lomoComboBox";
		public static const EDIT_POP_CANVAS_XY:Array = [ 100 , 180 ];
		public static const EDIT_POP_CANVAS_WH:Array = [ 600 , 500 ];
		public static const EDIT_POP_TOPNAVI_PREFIX:String = "topNavi_";
		public static const EDIT_POP_CANVAS_IMAGE_PREFIX:String = "editImage";
		//public static const EDIT_POP_CANVAS_WRAP_WHXY:Vector.<Number> = new Vector.<Number>( 1400 , 1000 , 362 , 384 );
		public static const EDIT_POP_CANVAS_WRAP_WHXY:Array = [ 1400 , 1000 , 362 , 384 ];
		public static const EDIT_POP_GRAY_PREFIX:String = "Gray";
		public static const EDIT_POP_SEPIA_PREFIX:String = "Sepia";
		public static const EDIT_POP_OLD_PREFIX:String = "Old";
		public static const EDIT_POP_LUXURY_PREFIX:String = "Luxury";
		public static const EDIT_POP_LOMO_PREFIX:String = "Lomo";
		
		//preview set
		public static const QR_XY:Array = [ 613 , 348 ];
		public static const DISPATCH_GET_TEL:String = "GetTelNumber";
		
		// common pop set
		public static const COMMONPOP_SHOW_DISPATCH_STR:String = "CommonPopDispatch";
		public static const COMMONPOP_FILEMAX_ERROR:Number = 1;	// 파일 업로드 10개 제한  예외상황
		public static const COMMONPOP_SKIN_COUNT_ERROR:Number = 2;	// 스킨 갯수 제한  예외상황
		public static const COMMONPOP_SMS_SEND_OK:Number = 3;	// sms 발송 되었습니다. alert
		
		// save pop 
		public static const SAVEPOP_DISPATCH_REQUEST_BITMAP:String = "RequestBitmap";
	}
}