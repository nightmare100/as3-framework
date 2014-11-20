package  com.aspectgaming.data.configuration.vo
{
	/**
	 * ...
	 * @author 1
	 */
	public  class RewardData
	{
		public static const BONUS:String = "bonus";
		public static const UNLOCK:String = "unlock";
		
		private var _type:String;
		private var _name:String;
		private var _value:uint;
		public function RewardData(mtype:String, mname:String, mvalue:Number) 
		{
			_type = mtype;
			_name = mname;
			_value = mvalue;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get value():uint 
		{
			return _value;
		}
	}

}