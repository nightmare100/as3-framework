package com.aspectgaming.algo
{
    import flash.geom.*;

	
	/**
	 * Astar寻路 
	 * @author mason
	 * 
	 */	
    public class AStar extends Object
    {
        private var _fatherList:Array;
        private const NOTE_OPEN:int = 1;
        private const NOTE_ID:int = 0;
        private var _noteMap:Array;
        private var _mapModel:IMapModel;
        private var _isOptimize:Boolean = true;
        private const NOTE_CLOSED:int = 2;
        private var _openId:int;
        private var _nodeList:Array;
        private var _openCount:int;
        private var _openList:Array;
        private var _pathScoreList:Array;
        public var maxTry:int = 1000;
        private var _movementCostList:Array;
        private static const COST_STRAIGHT:int = 10;
        private static var _instance:AStar;
        public static const arounds:Array = [new Point(1, 0), new Point(0, 1), new Point(-1, 0), new Point(0, -1), new Point(1, 1), new Point(-1, 1), new Point(-1, -1), new Point(1, -1)];
        private static const COST_DIAGONAL:int = 14;

        public function AStar()
        {
            return;
        }// end function

        private function isThrough(param1:Point, param2:Point) : Boolean
        {
            var _loc_5:Point = null;
            var _loc_3:* = Point.distance(param1, param2);
            var _loc_4:* = Math.atan2(param2.y - param1.y, param2.x - param1.x);
            var _loc_6:int = 1;
            while (_loc_6 < _loc_3)
            {
                
                _loc_5 = param1.add(Point.polar(_loc_6, _loc_4));
                _loc_5.x = int(_loc_5.x);
                _loc_5.y = int(_loc_5.y);
                if (_mapModel.data[_loc_5.x][_loc_5.y] == false)
                {
                    return false;
                }
                _loc_6 = _loc_6 + 1;
            }
            return true;
        }// end function

		/**
		 * 寻路方法 
		 * @param param1 寻路的target角色坐标
		 * @param param2 寻路的重点坐标
		 * @param param3
		 * @return   	返回一个 坐标点集合
		 * 
		 */		
        public function find(param1:Point, param2:Point, param3:Boolean = true) : Array
        {
            var _loc_7:int = 0;
            var _loc_8:Point = null;
            var _loc_9:int = 0;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_12:Array = null;
            var _loc_13:Point = null;
            if (_mapModel == null)
            {
                return null;
            }
            var _loc_4:* = transPoint(param1.clone());
            var _loc_5:* = transPoint(param2.clone());
            if (!isArrive(_loc_5))
            {
                return null;
            }
            if (isThrough(_loc_4, _loc_5))
            {
                return [param1.clone(), param2.clone()];
            }
            _isOptimize = param3;
            initLists();
            _openCount = 0;
            _openId = -1;
            openNote(_loc_4, 0, 0, 0);
            var _loc_6:int = 0;
            while (_openCount > 0)
            {
                
                if (++_loc_6 > maxTry)
                {
                    destroyLists();
                    return null;
                }
                _loc_7 = _openList[0];
                closeNote(_loc_7);
                _loc_8 = _nodeList[_loc_7];
                if (_loc_5.equals(_loc_8))
                {
                    return getPath(_loc_4, _loc_7);
                }
                _loc_12 = getArounds(_loc_8);
                for each (_loc_13 in _loc_12)
                {
                    
                    if (_loc_13.x != _loc_8.x)
                    {
                    }
                    _loc_10 = _movementCostList[_loc_7] + (_loc_13.y == _loc_8.y ? (COST_STRAIGHT) : (COST_DIAGONAL));
                    _loc_11 = _loc_10 + (Math.abs(_loc_5.x - _loc_13.x) + Math.abs(_loc_5.y - _loc_13.y)) * COST_STRAIGHT;
                    if (isOpen(_loc_13))
                    {
                        _loc_9 = _noteMap[_loc_13.y][_loc_13.x][NOTE_ID];
                        if (_loc_10 < _movementCostList[_loc_9])
                        {
                            _movementCostList[_loc_9] = _loc_10;
                            _pathScoreList[_loc_9] = _loc_11;
                            _fatherList[_loc_9] = _loc_7;
                            aheadNote((_openList.indexOf(_loc_9) + 1));
                        }
                        continue;
                    }
                    openNote(_loc_13, _loc_11, _loc_10, _loc_7);
                }
            }
            destroyLists();
            return null;
        }// end function

        private function isOpen(param1:Point) : Boolean
        {
            if (_noteMap[param1.y] == null)
            {
                return false;
            }
            if (_noteMap[param1.y][param1.x] == null)
            {
                return false;
            }
            return _noteMap[param1.y][param1.x][NOTE_OPEN];
        }// end function

        public function init(param1:IMapModel) : void
        {
            _mapModel = param1;
            return;
        }// end function

        private function aheadNote(param1:int) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            while (param1 > 1)
            {
                
                _loc_2 = int(param1 / 2);
                if (getScore(param1) < getScore(_loc_2))
                {
                    _loc_3 = _openList[(param1 - 1)];
                    _openList[(param1 - 1)] = _openList[(_loc_2 - 1)];
                    _openList[(_loc_2 - 1)] = _loc_3;
                    param1 = _loc_2;
                    continue;
                }
                break;
            }
            return;
        }// end function

        private function openNote(param1:Point, param2:int, param3:int, param4:int) : void
        {
            var _loc_6:* = _openCount + 1;
            _openCount = _loc_6;
            var _loc_6:* = _openId + 1;
            _openId = _loc_6;
            if (_noteMap[param1.y] == null)
            {
                _noteMap[param1.y] = [];
            }
            _noteMap[param1.y][param1.x] = [];
            _noteMap[param1.y][param1.x][NOTE_OPEN] = true;
            _noteMap[param1.y][param1.x][NOTE_ID] = _openId;
            _nodeList.push(param1);
            _pathScoreList.push(param2);
            _movementCostList.push(param3);
            _fatherList.push(param4);
            _openList.push(_openId);
            aheadNote(_openCount);
            return;
        }// end function

        private function optimize(param1:Array, param2:int = 0) : void
        {
            var _loc_5:Point = null;
            var _loc_6:int = 0;
            var _loc_7:Number = NaN;
            var _loc_10:int = 0;
            var _loc_11:int = 0;
            var _loc_12:Point = null;
            if (param1 == null)
            {
                return;
            }
            var _loc_3:* = param1.length - 1;
            if (_loc_3 < 2)
            {
                return;
            }
            var _loc_4:* = param1[param2];
            var _loc_8:Array = [];
            var _loc_9:* = _loc_3;
            while (_loc_9 > param2)
            {
                
                _loc_5 = param1[_loc_9];
                _loc_6 = Point.distance(_loc_4, _loc_5);
                _loc_7 = Math.atan2(_loc_5.y - _loc_4.y, _loc_5.x - _loc_4.x);
                _loc_10 = 1;
                while (_loc_10 < _loc_6)
                {
                    
                    _loc_12 = _loc_4.add(Point.polar(_loc_10, _loc_7));
                    _loc_12.x = int(_loc_12.x);
                    _loc_12.y = int(_loc_12.y);
                    if (_mapModel.data[_loc_12.x][_loc_12.y])
                    {
                        _loc_8.push(_loc_12);
                    }
                    else
                    {
                        _loc_8.length = 0;
                        break;
                    }
                    _loc_10 = _loc_10 + 1;
                }
                _loc_11 = _loc_8.length;
                if (_loc_11 > 0)
                {
                    param1.splice((param2 + 1), _loc_9 - param2 - 1);
                    param2 = param2 + (_loc_11 - 1);
                    break;
                }
                _loc_9 = _loc_9 - 1;
            }
            if (param2 < _loc_3)
            {
                optimize(param1, ++param2);
            }
            return;
        }// end function

        private function transPoint(param1:Point) : Point
        {
            param1.x = int(param1.x / _mapModel.gridSize);
            param1.y = int(param1.y / _mapModel.gridSize);
            return param1;
        }// end function

        private function isArrive(param1:Point) : Boolean
        {
            if (param1.x >= 0)
            {
            }
            if (param1.x < _mapModel.gridX)
            {
            }
            if (param1.y >= 0)
            {
            }
            if (param1.y >= _mapModel.gridY)
            {
                return false;
            }
            return _mapModel.data[param1.x][param1.y];
        }// end function

        private function closeNote(param1:int) : void
        {
            var _loc_4:* = _openCount - 1;
            _openCount = _loc_4;
            var _loc_2:* = _nodeList[param1];
            _noteMap[_loc_2.y][_loc_2.x][NOTE_OPEN] = false;
            _noteMap[_loc_2.y][_loc_2.x][NOTE_CLOSED] = true;
            if (_openCount <= 0)
            {
                _openCount = 0;
                _openList.length = 0;
                return;
            }
            _openList[0] = _openList.pop();
            backNote();
            return;
        }// end function

        private function getScore(param1:int) : int
        {
            return _pathScoreList[_openList[(param1 - 1)]];
        }// end function

        private function getArounds(param1:Point) : Array
        {
            var _loc_3:Point = null;
            var _loc_4:Boolean = false;
            var _loc_2:Array = [];
            var _loc_5:int = 0;
            _loc_3 = param1.add(arounds[_loc_5]);
            _loc_5 = _loc_5 + 1;
            var _loc_6:* = isArrive(_loc_3);
            if (_loc_6)
            {
            }
            if (!isClosed(_loc_3))
            {
                _loc_2.push(_loc_3);
            }
            _loc_3 = param1.add(arounds[_loc_5]);
            _loc_5 = _loc_5 + 1;
            var _loc_7:* = isArrive(_loc_3);
            if (_loc_7)
            {
            }
            if (!isClosed(_loc_3))
            {
                _loc_2.push(_loc_3);
            }
            _loc_3 = param1.add(arounds[_loc_5]);
            _loc_5 = _loc_5 + 1;
            var _loc_8:* = isArrive(_loc_3);
            if (_loc_8)
            {
            }
            if (!isClosed(_loc_3))
            {
                _loc_2.push(_loc_3);
            }
            _loc_3 = param1.add(arounds[_loc_5]);
            _loc_5 = _loc_5 + 1;
            var _loc_9:* = isArrive(_loc_3);
            if (_loc_9)
            {
            }
            if (!isClosed(_loc_3))
            {
                _loc_2.push(_loc_3);
            }
            _loc_3 = param1.add(arounds[_loc_5]);
            _loc_5 = _loc_5 + 1;
            _loc_4 = isArrive(_loc_3);
            if (_loc_4)
            {
            }
            if (_loc_6)
            {
            }
            if (_loc_7)
            {
            }
            if (!isClosed(_loc_3))
            {
                _loc_2.push(_loc_3);
            }
            _loc_3 = param1.add(arounds[_loc_5]);
            _loc_5 = _loc_5 + 1;
            _loc_4 = isArrive(_loc_3);
            if (_loc_4)
            {
            }
            if (_loc_8)
            {
            }
            if (_loc_7)
            {
            }
            if (!isClosed(_loc_3))
            {
                _loc_2.push(_loc_3);
            }
            _loc_3 = param1.add(arounds[_loc_5]);
            _loc_5 = _loc_5 + 1;
            _loc_4 = isArrive(_loc_3);
            if (_loc_4)
            {
            }
            if (_loc_8)
            {
            }
            if (_loc_9)
            {
            }
            if (!isClosed(_loc_3))
            {
                _loc_2.push(_loc_3);
            }
            _loc_3 = param1.add(arounds[_loc_5]);
            _loc_5 = _loc_5 + 1;
            _loc_4 = isArrive(_loc_3);
            if (_loc_4)
            {
            }
            if (_loc_6)
            {
            }
            if (_loc_9)
            {
            }
            if (!isClosed(_loc_3))
            {
                _loc_2.push(_loc_3);
            }
            return _loc_2;
        }// end function

        private function getPath(param1:Point, param2:int) : Array
        {
            var _loc_3:Array = [];
            var _loc_4:* = _nodeList[param2];
            while (!param1.equals(_loc_4))
            {
                
                _loc_3.push(_loc_4);
                param2 = _fatherList[param2];
                _loc_4 = _nodeList[param2];
            }
            _loc_3.push(param1);
            destroyLists();
            _loc_3.reverse();
            if (_isOptimize)
            {
                optimize(_loc_3);
            }
            _loc_3.forEach(eachArray);
            return _loc_3;
        }// end function

		/**
		 * 格子点阵 转换到实际坐标 
		 * @param param1
		 * @param param2
		 * @param param3
		 * 
		 */		
        private function eachArray(param1:Point, param2:int, param3:Array) : void
        {
            param1.x = param1.x * _mapModel.gridSize;
            param1.y = param1.y * _mapModel.gridSize;
            return;
        }// end function

        private function initLists() : void
        {
            _openList = [];
            _nodeList = [];
            _pathScoreList = [];
            _movementCostList = [];
            _fatherList = [];
            _noteMap = [];
            return;
        }// end function

        private function isClosed(param1:Point) : Boolean
        {
            if (_noteMap[param1.y] == null)
            {
                return false;
            }
            if (_noteMap[param1.y][param1.x] == null)
            {
                return false;
            }
            return _noteMap[param1.y][param1.x][NOTE_CLOSED];
        }// end function

        private function destroyLists() : void
        {
            _openList = null;
            _nodeList = null;
            _pathScoreList = null;
            _movementCostList = null;
            _fatherList = null;
            _noteMap = null;
            return;
        }// end function

        private function backNote() : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_1:int = 1;
            while (true)
            {
                
                _loc_2 = _loc_1;
                if (2 * _loc_2 <= _openCount)
                {
                    if (getScore(_loc_1) > getScore(2 * _loc_2))
                    {
                        _loc_1 = 2 * _loc_2;
                    }
                    if (2 * _loc_2 + 1 <= _openCount)
                    {
                        if (getScore(_loc_1) > getScore(2 * _loc_2 + 1))
                        {
                            _loc_1 = 2 * _loc_2 + 1;
                        }
                    }
                }
                if (_loc_2 == _loc_1)
                {
                    break;
                    continue;
                }
                _loc_3 = _openList[(_loc_2 - 1)];
                _openList[(_loc_2 - 1)] = _openList[(_loc_1 - 1)];
                _openList[(_loc_1 - 1)] = _loc_3;
            }
            return;
        }// end function

        public static function get instance() : AStar
        {
            if (_instance == null)
            {
                _instance = new AStar;
            }
            return _instance;
        }// end function

    }
}
