/*

AS3 BY JAMES THOMPSON
JAMES THOMPSON DIGITAL
http://www.jamesthompsondigital.com/

*/

package jtd.crypto {
	
	public class Hash {
		
		public function Hash() {
			trace("Test with str \"test\":\n[SHA256]\n"+SHA256("test")+"\n\n[SHA1]\n"+SHA1("test")+"\n\n[MD5]\n"+MD5("test"));
		}
		
		public static function SHA256(plainStr) {
			
			var cs = 8;
			plainStr = enc_utf8(String(plainStr));
			
			var m = convString(plainStr);
			var l = plainStr.length * cs;
			
			function safe_add(x, y) {
				var lsw = (x & 0xFFFF) + (y & 0xFFFF);
				var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
				return msw << 16 | lsw & 0xFFFF;
			}
			function S(X, n) {
				return X >>> n | X << 32 - n;
			}
			function R(X, n) {
				return X >>> n;
			}
			function Ch(x, y, z) {
				return x & y ^ ~ x & z;
			}
			function Maj(x, y, z) {
				return x & y ^ x & z ^ y & z;
			}
			function sig0256(x) {
				return S(x,2) ^ S(x,13) ^ S(x,22);
			}
			function sig1256(x) {
				return S(x,6) ^ S(x,11) ^ S(x,25);
			}
			function gam0256(x) {
				return S(x,7) ^ S(x,18) ^ R(x,3);
			}
			function gam1256(x) {
				return S(x,17) ^ S(x,19) ^ R(x,10);
			}
			function convString(str) {
				var bin = new Array();
				var mask = (1 << cs) - 1;
				for (var i = 0; i < str.length * cs; i += cs) {
					bin[i>>5] |= (str.charCodeAt(i / cs) & mask) << (24 - i%32);
				}
				return bin;
			}
			function binb2hex(binarray) {
				var hex_tab = 0 ? "0123456789ABCDEF" : "0123456789abcdef";
				var str = "";
				for (var i:uint = 0; i < binarray.length * 4; i++) {
					str += hex_tab.charAt((binarray[i>>2] >> ((3 - i%4)*8+4)) & 0xF) + hex_tab.charAt((binarray[i>>2] >> ((3 - i%4)*8)) & 0xF);
				}
				return str;
			}
			var K:Array = new Array(0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5, 0x3956C25B, 0x59F111F1, 0x923F82A4, 0xAB1C5ED5, 0xD807AA98, 0x12835B01, 0x243185BE, 0x550C7DC3, 0x72BE5D74, 0x80DEB1FE, 0x9BDC06A7, 0xC19BF174, 0xE49B69C1, 0xEFBE4786, 0xFC19DC6, 0x240CA1CC, 0x2DE92C6F, 0x4A7484AA, 0x5CB0A9DC, 0x76F988DA, 0x983E5152, 0xA831C66D, 0xB00327C8, 0xBF597FC7, 0xC6E00BF3, 0xD5A79147, 0x6CA6351, 0x14292967, 0x27B70A85, 0x2E1B2138, 0x4D2C6DFC, 0x53380D13, 0x650A7354, 0x766A0ABB, 0x81C2C92E, 0x92722C85, 0xA2BFE8A1, 0xA81A664B, 0xC24B8B70, 0xC76C51A3, 0xD192E819, 0xD6990624, 0xF40E3585, 0x106AA070, 0x19A4C116, 0x1E376C08, 0x2748774C, 0x34B0BCB5, 0x391C0CB3, 0x4ED8AA4A, 0x5B9CCA4F, 0x682E6FF3, 0x748F82EE, 0x78A5636F, 0x84C87814, 0x8CC70208, 0x90BEFFFA, 0xA4506CEB, 0xBEF9A3F7, 0xC67178F2);
			var h_arr:Array = new Array(0x6A09E667, 0xBB67AE85, 0x3C6EF372, 0xA54FF53A, 0x510E527F, 0x9B05688C, 0x1F83D9AB, 0x5BE0CD19);
			var W:Array = new Array(64);
			var a, b, c, d, e, f, g, h, i, j;
			var T1, T2;
			
			m[l >> 5] |= 0x80 << (24 - l % 32);
			m[((l + 64 >> 9) << 4) + 15] = l;
			
			for (var core_i:uint = 0; core_i<m.length; core_i+=16) {
				a = h_arr[0];
				b = h_arr[1];
				c = h_arr[2];
				d = h_arr[3];
				e = h_arr[4];
				f = h_arr[5];
				g = h_arr[6];
				h = h_arr[7];
				
				for (var core_j:uint = 0; core_j<64; core_j++) {
					if (core_j < 16) {
						W[core_j] = m[core_j + core_i];
					} else {
						W[core_j] = safe_add(safe_add(safe_add(gam1256(W[core_j - 2]), W[core_j - 7]), gam0256(W[core_j - 15])), W[core_j - 16]);
					}
					T1 = safe_add(safe_add(safe_add(safe_add(h, sig1256(e)), Ch(e, f, g)), K[core_j]), W[core_j]);
					T2 = safe_add(sig0256(a), Maj(a, b, c));
					h = g;
					g = f;
					f = e;
					e = safe_add(d, T1);
					d = c;
					c = b;
					b = a;
					a = safe_add(T1, T2);
				}
				h_arr[0] = safe_add(a, h_arr[0]);
				h_arr[1] = safe_add(b, h_arr[1]);
				h_arr[2] = safe_add(c, h_arr[2]);
				h_arr[3] = safe_add(d, h_arr[3]);
				h_arr[4] = safe_add(e, h_arr[4]);
				h_arr[5] = safe_add(f, h_arr[5]);
				h_arr[6] = safe_add(g, h_arr[6]);
				h_arr[7] = safe_add(h, h_arr[7]);
			}
			return binb2hex(h_arr);
		}
		
		//----------------------------SHA1
		
		public static function SHA1(plainStr:String) {
			
			var blockstart;
			var i:uint, j;
			var W = new Array(80);
			var H0 = 0x67452301;
			var H1 = 0xEFCDAB89;
			var H2 = 0x98BADCFE;
			var H3 = 0x10325476;
			var H4 = 0xC3D2E1F0;
			var A, B, C, D, E;
			var temp;
			
			plainStr = enc_utf8(plainStr);
			
			var plainStr_len = plainStr.length;
			
			function lsb_hex(val) {
				var str="";
				var i;
				var vh;
				var vl;
				
				for (i=0; i<=6; i+=2) {
					vh = (val>>>(i*4+4))&0x0f;
					vl = (val>>>(i*4))&0x0f;
					str += vh.toString(16) + vl.toString(16);
				}
				return str;
			}
			
			function cvt_hex(val) {
				var str="";
				var i;
				var v;
				
				for (i=7; i>=0; i--) {
					v = (val>>>(i*4))&0x0f;
					str += v.toString(16);
				}
				return str;
			}
			
			var word_array = new Array();
			for (i=0; i<plainStr_len-3; i+=4) {
				j = plainStr.charCodeAt(i)<<24 | plainStr.charCodeAt(i+1)<<16 |
					plainStr.charCodeAt(i+2)<<8 | plainStr.charCodeAt(i+3);
				word_array.push(j);
			}
			switch (plainStr_len % 4) {
				case 0 :
					i = 0x080000000;
					break;
				case 1 :
					i = plainStr.charCodeAt(plainStr_len-1)<<24 | 0x0800000;
					break;
				
				case 2 :
					i = plainStr.charCodeAt(plainStr_len-2)<<24 | plainStr.charCodeAt(plainStr_len-1)<<16 | 0x08000;
					break;
				
				case 3 :
					i = plainStr.charCodeAt(plainStr_len-3)<<24 | plainStr.charCodeAt(plainStr_len-2)<<16 | plainStr.charCodeAt(plainStr_len-1)<<8    | 0x80;
					break;
			}
			word_array.push(i);
			
			while ((word_array.length % 16) != 14) {
				word_array.push(0);
			}
			
			word_array.push(plainStr_len>>>29);
			word_array.push((plainStr_len<<3)&0x0ffffffff);
			
			
			for (blockstart=0; blockstart<word_array.length; blockstart+=16) {
				
				for (i=0; i<16; i++) {
					W[i] = word_array[blockstart+i];
				}
				for (i=16; i<=79; i++) {
					W[i] = rol(W[i-3] ^ W[i-8] ^ W[i-14] ^ W[i-16], 1);
				}
				
				A = H0;
				B = H1;
				C = H2;
				D = H3;
				E = H4;
				
				for (i= 0; i<=19; i++) {
					temp = (rol(A,5) + ((B&C) | (~B&D)) + E + W[i] + 0x5A827999) & 0x0ffffffff;
					E = D;
					D = C;
					C = rol(B,30);
					B = A;
					A = temp;
				}
				for (i=20; i<=39; i++) {
					temp = (rol(A,5) + (B ^ C ^ D) + E + W[i] + 0x6ED9EBA1) & 0x0ffffffff;
					E = D;
					D = C;
					C = rol(B,30);
					B = A;
					A = temp;
				}
				for (i=40; i<=59; i++) {
					temp = (rol(A,5) + ((B&C) | (B&D) | (C&D)) + E + W[i] + 0x8F1BBCDC) & 0x0ffffffff;
					E = D;
					D = C;
					C = rol(B,30);
					B = A;
					A = temp;
				}
				for (i=60; i<=79; i++) {
					temp = (rol(A,5) + (B ^ C ^ D) + E + W[i] + 0xCA62C1D6) & 0x0ffffffff;
					E = D;
					D = C;
					C = rol(B,30);
					B = A;
					A = temp;
				}
				H0 = (H0 + A) & 0x0ffffffff;
				H1 = (H1 + B) & 0x0ffffffff;
				H2 = (H2 + C) & 0x0ffffffff;
				H3 = (H3 + D) & 0x0ffffffff;
				H4 = (H4 + E) & 0x0ffffffff;
				
			}
			temp = cvt_hex(H0) + cvt_hex(H1) + cvt_hex(H2) + cvt_hex(H3) + cvt_hex(H4);
			
			return temp.toLowerCase();
			
		}
		
		//-----------------------------------MD5
		
		public static function MD5(s:String):String {
			//buffers
			var a:int = 1732584193;
			var b:int = -271733879;
			var c:int = -1732584194;
			var d:int = 271733878;
			
			//value vars
			var aa:int;
			var bb:int;
			var cc:int;
			var dd:int;
			
			
			var x:Array = createBlocks(s);
			var len:int = x.length;
			
			for (var i:int = 0; i < len; i += 16) {
				aa = a;
				bb = b;
				cc = c;
				dd = d;				
				
				a = ff(a, b, c, d, x[i+ 0],  7, -680876936);
				d = ff(d, a, b, c, x[i+ 1], 12, -389564586);
				c = ff(c, d, a, b, x[i+ 2], 17, 606105819);
				b = ff(b, c, d, a, x[i+ 3], 22, -1044525330);
				a = ff(a, b, c, d, x[i+ 4],  7, -176418897);
				d = ff(d, a, b, c, x[i+ 5], 12, 1200080426)
				c = ff(c, d, a, b, x[i+ 6], 17, -1473231341);
				b = ff(b, c, d, a, x[i+ 7], 22, -45705983);
				a = ff(a, b, c, d, x[i+ 8],  7, 1770035416);
				d = ff(d, a, b, c, x[i+ 9], 12, -1958414417);
				c = ff(c, d, a, b, x[i+10], 17, -42063);
				b = ff(b, c, d, a, x[i+11], 22, -1990404162);
				a = ff(a, b, c, d, x[i+12],  7, 1804603682);
				d = ff(d, a, b, c, x[i+13], 12, -40341101);
				c = ff(c, d, a, b, x[i+14], 17, -1502002290);
				b = ff(b, c, d, a, x[i+15], 22, 1236535329);
				
				a = gg(a, b, c, d, x[i+ 1],  5, -165796510);
				d = gg(d, a, b, c, x[i+ 6],  9, -1069501632);
				c = gg(c, d, a, b, x[i+11], 14, 643717713);
				b = gg(b, c, d, a, x[i+ 0], 20, -373897302);
				a = gg(a, b, c, d, x[i+ 5],  5, -701558691);
				d = gg(d, a, b, c, x[i+10],  9, 38016083);
				c = gg(c, d, a, b, x[i+15], 14, -660478335);
				b = gg(b, c, d, a, x[i+ 4], 20, -405537848);
				a = gg(a, b, c, d, x[i+ 9],  5, 568446438);
				d = gg(d, a, b, c, x[i+14],  9, -1019803690);
				c = gg(c, d, a, b, x[i+ 3], 14, -187363961);
				b = gg(b, c, d, a, x[i+ 8], 20, 1163531501);
				a = gg(a, b, c, d, x[i+13],  5, -1444681467);
				d = gg(d, a, b, c, x[i+ 2],  9, -51403784);
				c = gg(c, d, a, b, x[i+ 7], 14, 1735328473);
				b = gg(b, c, d, a, x[i+12], 20, -1926607734);
				
				a = hh(a, b, c, d, x[i+ 5],  4, -378558);
				d = hh(d, a, b, c, x[i+ 8], 11, -2022574463);
				c = hh(c, d, a, b, x[i+11], 16, 1839030562);
				b = hh(b, c, d, a, x[i+14], 23, -35309556);
				a = hh(a, b, c, d, x[i+ 1],  4, -1530992060);
				d = hh(d, a, b, c, x[i+ 4], 11, 1272893353);
				c = hh(c, d, a, b, x[i+ 7], 16, -155497632);
				b = hh(b, c, d, a, x[i+10], 23, -1094730640);
				a = hh(a, b, c, d, x[i+13],  4, 681279174);
				d = hh(d, a, b, c, x[i+ 0], 11, -358537222);
				c = hh(c, d, a, b, x[i+ 3], 16, -722521979);
				b = hh(b, c, d, a, x[i+ 6], 23, 76029189);
				a = hh(a, b, c, d, x[i+ 9],  4, -640364487);
				d = hh(d, a, b, c, x[i+12], 11, -421815835);
				c = hh(c, d, a, b, x[i+15], 16, 530742520);
				b = hh(b, c, d, a, x[i+ 2], 23, -995338651);
				
				a = ii(a, b, c, d, x[i+ 0],  6, -198630844);
				d = ii(d, a, b, c, x[i+ 7], 10, 1126891415);
				c = ii(c, d, a, b, x[i+14], 15, -1416354905);
				b = ii(b, c, d, a, x[i+ 5], 21, -57434055);
				a = ii(a, b, c, d, x[i+12],  6, 1700485571);
				d = ii(d, a, b, c, x[i+ 3], 10, -1894986606);
				c = ii(c, d, a, b, x[i+10], 15, -1051523);
				b = ii(b, c, d, a, x[i+ 1], 21, -2054922799);
				a = ii(a, b, c, d, x[i+ 8],  6, 1873313359);
				d = ii(d, a, b, c, x[i+15], 10, -30611744);
				c = ii(c, d, a, b, x[i+ 6], 15, -1560198380);
				b = ii(b, c, d, a, x[i+13], 21, 1309151649);
				a = ii(a, b, c, d, x[i+ 4],  6, -145523070);
				d = ii(d, a, b, c, x[i+11], 10, -1120210379);
				c = ii(c, d, a, b, x[i+ 2], 15, 718787259);
				b = ii(b, c, d, a, x[i+ 9], 21, -343485551);
				
				a += aa;
				b += bb;
				c += cc;
				d += dd;
			}
			
			return toHex(a) + toHex(b) + toHex(c) + toHex(d);
		}
		
		private static function f(x:int, y:int, z:int):int {
			return (x & y) | ((~x) & z);
		}
		
		private static function g(x:int, y:int, z:int):int {
			return (x & z) | (y & (~z));
		}
		
		private static function h(x:int, y:int, z:int):int {
			return x ^ y ^ z;
		}
		
		private static function i(x:int, y:int, z:int):int {
			return y ^ (x | (~z));
		}
		
		private static function transform(func:Function, a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			var tmp:int = a + int(func(b, c, d)) + x + t;
			return rol(tmp, s) +  b;
		}
		
		private static function ff(a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			return transform(f, a, b, c, d, x, s, t);
		}
		
		private static function gg(a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			return transform(g, a, b, c, d, x, s, t);
		}
		
		private static function hh(a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			return transform(h, a, b, c, d, x, s, t);
		}
		
		private static function ii(a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			return transform(i, a, b, c, d, x, s, t);
		}
		
		private static function createBlocks(s:String):Array {
			var blocks:Array = new Array();
			var len:int = s.length * 8;
			var mask:int = 0xFF;
			for(var i:int = 0; i < len; i += 8) {
				blocks[ i >> 5 ] |= (s.charCodeAt(i / 8) & mask) << (i % 32);
			}
			blocks[ len >> 5 ] |= 0x80 << (len % 32);
			blocks[ (((len + 64) >>> 9) << 4) + 14 ] = len;
			return blocks;
		}
		
		private static function rol(x:int, n:int):int {
			return (x << n) | (x >>> (32 - n));
		}
		
		private static function toHex(n:int, bigEndian:Boolean = false):String {
			var str:String = "";
			var hexChars:String = "0123456789abcdef";
			
			if (bigEndian) {
				for (var i:int = 0; i < 4; i++) {
					str += hexChars.charAt((n >> ((3 - i) * 8 + 4)) & 0xF) 
						+ hexChars.charAt((n >> ((3 - i) * 8)) & 0xF);
				}
			} else {
				for (var x:int = 0; x < 4; x++) {
					str += hexChars.charAt((n >> (x * 8 + 4)) & 0xF)
						+ hexChars.charAt((n >> (x * 8)) & 0xF);
				}
			}
			
			return str;
		}
		
		private static function enc_utf8(string) {
			
			var utftext = "";
			
			for (var n:uint = 0; n < string.length; n++) {
				
				var c = string.charCodeAt(n);
				
				if (c < 128) {
					utftext += String.fromCharCode(c);
				} else if ((c > 127) && (c < 2048)) {
					utftext += String.fromCharCode((c >> 6) | 192);
					utftext += String.fromCharCode((c & 63) | 128);
				} else {
					utftext += String.fromCharCode((c >> 12) | 224);
					utftext += String.fromCharCode(((c >> 6) & 63) | 128);
					utftext += String.fromCharCode((c & 63) | 128);
				}
			}
			return utftext;
		}
	}
}