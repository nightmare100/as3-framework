package com.aspectgaming.data.newplayerguide
{
	import com.aspectgaming.net.vo.PlayerDTO;

	public class StepListInfo
	{
		
		public var listName:String;
		public var stepVec:Vector.<StepInfo>;
		public var listRes:String;
		public var openId:int;
		public var playerDTO:PlayerDTO;
		
		public var dependAtModule:String;
		
		public function StepListInfo(xml:XML)
		{
			stepVec = new Vector.<StepInfo>();
			listRes = String(xml.@res);
			listName = String(xml.@id);
			openId=int(xml.@openId);
			dependAtModule=xml.@depend
			for (var i:int = 0; i < xml["step"].length(); i++)
			{
				stepVec.push(new StepInfo(xml.step[i], i));
			}
			
			initPlayerDTO(xml.PlayerDTO);
			
			
		}
		private function initPlayerDTO(xml:XMLList):void{
			var pdtoXML:XML=xml[0];
			if(pdtoXML!=null){
				playerDTO=new PlayerDTO();
				playerDTO.dragonDollars=pdtoXML.@dragonDollars;
				playerDTO.totalAmount=pdtoXML.@totalAmount;
				trace(">>>>>>>>>>>>>>>",pdtoXML);
			}
						
		}
		
		
		
		
		
		
	}
}