package com.aspectgaming.algo
{
	/**
	 * 寻路地图接口 
	 * @author mason
	 * 
	 */	
    public interface IMapModel
    {
		/**
		 * 地图横向格子数 
		 * @return 
		 * 
		 */		
        function get gridX() : uint;

		/**
		 * 地图纵向格子数 
		 * @return 
		 * 
		 */		
        function get gridY() : uint;

		/**
		 * 地图宽 
		 * @return 
		 * 
		 */		
        function get width() : int;

        function get height() : int;

		/**
		 * 二维数组 point 集合 true 为可走 false 为不可走 
		 * @return 
		 * 
		 */		
        function get data() : Array;

		/**
		 * 每一个格子对应的缩放比率 
		 * @return 
		 * 
		 */		
        function get gridSize() : uint;

    }
}
