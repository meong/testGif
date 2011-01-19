package com.fwang.utils
{
	public class StringUtils
	{
		public function StringUtils()
		{
		}
		public static function conv_filesize( filebytes:String ):String
		{
			var fileLen:Number = filebytes.length;
			trace (fileLen);
			switch( fileLen ) {
				case 0 :	return filebytes;																break;
				case 1 :	return filebytes;																break;
				case 2 :	return filebytes;																break;
				case 3 :	return filebytes;																break;
				
				case 4 :	return filebytes.slice( 0 , -3 ) + "." + filebytes.slice( -3 , -2 ) + "K";		break;
				case 5 :	return filebytes.slice( 0 , -3 ) + "." + filebytes.slice( -3 , -2 ) + "K";		break;
				case 6 :	return filebytes.slice( 0 , -3 ) + "." + filebytes.slice( -3 , -2 ) + "K";		break;
				
				case 7 :	return filebytes.slice( 0 , -6 ) + "." + filebytes.slice( -6 , -5 ) + "M";		break;
				case 8 :	return filebytes.slice( 0 , -6 ) + "." + filebytes.slice( -6 , -5 ) + "M";		break;
				case 9 :	return filebytes.slice( 0 , -6 ) + "." + filebytes.slice( -6 , -5 ) + "M";		break;
				
				case 10 :	return filebytes.slice( 0 , -9 ) + "." + filebytes.slice( -9 , -8 ) + "M";		break;
				case 11 :	return filebytes.slice( 0 , -9 ) + "." + filebytes.slice( -9 , -8 ) + "M";		break;
				case 12 :	return filebytes.slice( 0 , -9 ) + "." + filebytes.slice( -9 , -8 ) + "M";		break;
				
				case 13 :	return filebytes.slice( 0 , -12 ) + "." + filebytes.slice( -12 , -11 ) + "T";	break;
				case 14 :	return filebytes.slice( 0 , -12 ) + "." + filebytes.slice( -12 , -11 ) + "T";	break;
				case 15 :	return filebytes.slice( 0 , -12 ) + "." + filebytes.slice( -12 , -11 ) + "T";	break;
				
				default :	return filebytes;																break;
			}
		}
		public function number_format( c:String , str:String = "" ):String
		{
			var cReturn :String = "";
			for( var ii:Number = 0 ; ii < c.length ; ii++ ) {
				if( ( ( ii % 3 ) == ( c.length % 3 ) ) && ii != 0 )
					cReturn += ",";
				cReturn += c.substr( ii , 1 );
			}
			cReturn += str;
			return cReturn;
		}
		public static function get_extention( file:String ):String
		{
			var file_ext_arr:Array = file.split( "." );
		    var file_ext_tmp:Number = file_ext_arr.length - 1;
		    var file_ext:String = file_ext_arr[ file_ext_tmp ];
		    return file_ext;
		}
	}
}