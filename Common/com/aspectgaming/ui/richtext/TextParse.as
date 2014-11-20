package com.aspectgaming.ui.richtext
{
	import com.aspectgaming.ui.iface.IAssetLibrary;
	import com.aspectgaming.utils.DisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;

	/**
	 * 图文解析器
	 * @author mason.li
	 * 
	 */	
	internal class TextParse
	{
		/**
		 * 当前赋值时原始文本
		 */		
		private var _currentSourceText:String;
		
		private var _currentProcessText:String;
		
		/**
		 * 图标 
		 */		
		private var _emoVec:Vector.<EmoInfo>;
		private var _emoRegexp:RegExp = /\[(\w*)\]/g;
		private var _assetLibrary:IAssetLibrary;
		
		private var _richText:RichText;
		
		private var _textList:Vector.<String>;
		
		
		public function TextParse(library:IAssetLibrary, richText:RichText)
		{
			_currentProcessText = "";
			_assetLibrary = library;
			_emoVec = new Vector.<EmoInfo>();
			_textList = new Vector.<String>();
			_richText = richText;
		}
		
		/**
		 * 文本列表 一行一个String 
		 */
		public function get textList():Vector.<String>
		{
			return _textList;
		}

		/**
		 * 当前显示文本 
		 */
		public function set currentProcessText(value:String):void
		{
			_currentProcessText = value;
			if (_textList.length - 1 < 0)
			{
				_textList[0] = _currentProcessText;
			}
			else
			{
				_textList[_textList.length - 1] = _currentProcessText;
			}
		}

		public function get emoVec():Vector.<EmoInfo>
		{
			return _emoVec;
		}
		
		public function get currentLineEmu():Vector.<EmoInfo>
		{
			var result:Vector.<EmoInfo> = new Vector.<EmoInfo>();
			for each (var emu:EmoInfo in _emoVec)
			{
				if (emu.vindex == _textList.length - 1)
				{
					result.push(emu);
				}
			}
			
			return result;
		}
		
		public function get currentLineIndex():uint
		{
			return _textList.length - 1;
		}

		/**
		 * 获取原始文本 
		 * @return 
		 * 
		 */		
		public function get sourceTextVec():Vector.<String>
		{
			var result:Vector.<String> = _textList.concat();
			for (var i:uint = 0 ; i < result.length; i++)
			{
				result[i] = restoreToSource(result[i], i);
			}
			
			return result;
		}
		
		/**
		 * 还原 
		 * @param str
		 * @param idx
		 * @return 
		 * 
		 */		
		private function restoreToSource(str:String, idx:uint):String
		{
			var offsetIndex:uint;
			for (var i:uint = 0; i < _emoVec.length; i++)
			{
				var emu:EmoInfo = _emoVec[i];
				if (emu.vindex == idx)
				{
					str = str.substr(0, emu.hindex + offsetIndex) + emu.sourceName + str.substr(emu.hindex + offsetIndex + 1);
					offsetIndex += emu.sourceName.length - 1;
				}
			}

			return str;
		}
		
		/**
		 * 删除第一行文本 
		 * 返回删除的表情列表
		 * 
		 */		
		public function shiftText():Vector.<EmoInfo>
		{
			var processedText:String = _textList.shift();
			var emos:Vector.<EmoInfo> = new Vector.<EmoInfo>();
			for (var i:uint = 0; i < _emoVec.length; i++)
			{
				if (_emoVec[i].vindex == 0)
				{
					emos.push(_emoVec.splice(i--, 1)[0]);
				}
				else
				{
					_emoVec[i].vindex -= 1;
					_emoVec[i].hindex -= processedText.length + 1;
				}
			}
			return emos;
		}
		
		/**
		 * 获取渲染后的文本 
		 * @return 
		 * 
		 */		
		public function get currentProcessText():String
		{
			return _currentProcessText;
		}

		public function parseText(str:String):void
		{
			_emoVec.length = 0;
			_currentSourceText = str;
			processEmotion();
		}
		
		/**
		 * 追加一行文本 
		 * @param str
		 * 
		 */		
		public function appendText(str:String):void
		{
			_currentSourceText = str;
			processEmotion();
		}
		
		public function appendTextOnly(str:String):void
		{
			_currentSourceText = _currentProcessText = str;
			_textList.push(_currentProcessText);
		}
		
		/**
		 * 插入表情 
		 * @param emuStr 表情符号
		 * @param start	 表情位置
		 * 
		 */		
		public function insertEmo(emuStr:String, start:uint):void
		{
			currentProcessText = _currentProcessText.substr(0, start) + " " + _currentProcessText.substr(start);
			changeEmuIdx(1, start);
			var info:EmoInfo = addEmu(emuStr, _textList.length - 1);
			info.hindex = start;
		}

		public function updateSource(current:String, start:uint, end:uint):void
		{
			var totalChanged:int = current.length - _currentProcessText.length;
			currentProcessText = current;
			if (start >= end)
			{
				if (totalChanged < 0)
				{
					deleteEmu(start - 1, end);
				}
				else
				{
					clearFormat(start, start + 1);
				}
			}
			else
			{
				deleteEmu(start, end);
				
				var selection:uint = end - start;
				var changedIdx:uint = Math.abs( Math.abs(totalChanged) - selection );
				clearFormat(start, start + changedIdx);
			}
			changeEmuIdx(totalChanged, end);
		}
		
		private function clearFormat(s:uint, end:uint):void
		{
			if (s == end)
			{
				return;
			}
			_richText.clearFormat(s, end);
		}
		
		private function deleteEmu(s:uint , e:uint):void
		{
			for (var i:uint = 0; i < _emoVec.length; i++)
			{
				var info:EmoInfo = _emoVec[i];
				if (info.hindex >= s && info.hindex < e)
				{
					_emoVec.splice(_emoVec.indexOf(info), 1);
					DisplayUtil.removeFromParent(info.displayObject);
					i--;
				}
			}
		}
		
		private function changeEmuIdx(len:int, lastIdx:uint):void
		{
			for each (var info:EmoInfo in _emoVec)
			{
				if (info.hindex >= lastIdx)
				{
					info.hindex += len;
				}
			}
		}
		
		public function clear():void
		{
			for each (var info:EmoInfo in _emoVec)
			{
				DisplayUtil.removeFromParent(info.displayObject);
			}
			_textList.length = 0;
			_emoVec.length = 0;
			_currentSourceText = "";
			_currentProcessText = "";
		}
		
		private function processEmotion():void
		{
			var result:Array = _currentSourceText.match(_emoRegexp);
			_currentProcessText = _currentSourceText;
			for (var i:uint = 0; i < result.length; i++)
			{
				var str:String = result[i];
				var emu:EmoInfo = addEmu(str, _textList.length);
				
				if (emu)
				{
					//空格占位
					_currentProcessText = _currentProcessText.replace(str, " ");
				}
			}
			_textList.push(_currentProcessText);
		}
		
		/**
		 * 添加表情 
		 * @param str
		 * @param vidx
		 * @return 
		 * 
		 */		
		private function addEmu(str:String, vidx:uint):EmoInfo
		{
			var clsName:String = str.substring(1, str.length - 1);
			var obj:DisplayObject = _assetLibrary.getDisplayObject(clsName);
			
			if (obj)
			{
				var info:EmoInfo = new EmoInfo();
				info.hindex = getTotalIndex() + _currentProcessText.indexOf(str);
				info.vindex = vidx;
				info.name = clsName;
				info.displayObject = _assetLibrary.getDisplayObject(info.name);
				_emoVec.push(info);
				
				return info;
			}
			else
			{
				return null;
			}
		}
		
		
		private function getTotalIndex():uint
		{
			var r:uint;
			for each (var str:String in _textList)
			{
				r += str.length + 1;
			}
			return r;
		}
	}
}