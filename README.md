as3-framework
=============

as3 framework for customize

details
---------------------------
###		   Feature
		   flash as3系统框架

###		   包简述(com.aspectgaming)
		   -> algo			A star 寻路相关(开源算法 封装了自己的解析 源码丢失 此版本为反编译版本) ImapModel为寻路数据
		   -> animation  	工厂模式 和 模板模式实现的一套 适量动画 & 帧动画 播放解决方案	
		   -> cache  		加载资源缓存 用于读取外部图片 包含外部图片加载器(使用远程代理模式 不用等图片加载完成即可 把容器预先加载到场景中 并可定义一些属性)
		   -> constant   	各类常量定义
		   -> core			系统框架核心接口 其中IServer 为网络协议通用接口 Iparse 为协议解析器通用接口
		   -> data			一些数据模型
		   -> desine 		命令模式 基类 and 派发器
		   -> debug			debug调试UI
		   -> error			服务器异常信息定义 及全局错误处理控制器(老样子 采用观察者模式)
		   -> event 		系统事件定义 其中GameEvent为游戏内部 公用事件 NotifyEvent为消息事件(见NotifyManager)
		   -> game	 		游戏相关支持 提供游戏启动程序基类 游戏和大厅的通信 控制器 游戏类统一接口
		   -> globalization  	提供全局管理类 模块代理
				->manager包
					->GameLayerManager LayerManager 层级管理 清楚划分各类UI级 及游戏界面层次。
					->ModuleManager		模块管理 (该类采用 代理模式管理 所有模块 模块分布加载 管理类内部判断模块是否已加载 已加载的模块是否已被添加)
					还提供了 注册string的方式 访问模块 极大降低了耦合度);
					模块定义了生命周期的 常量LifeCycle 通过当前系统的状态 销毁不属于当前状态的模块
					
					->NewPalyerGuildManager 新手引导管理
					->SharedObjectManager 	本地存储管理
					->NotifyManager			消息管理器(目前支持4种消息 弹窗消息， 标记消息(ios 角标类型), 游戏内部 滚动消息， 聊天消息)
					采用迭代器模式 管理消息集合 分种类派发消息事件。 所有消息体分装成一个NotifyInfo对象 弹窗消息封装为NotifyViewInfo 继承与NotifyInfo
					通过addMessage 和 addMessageViewDirect 2种方式实现 popupmanager功能 (队列添加 和 直接添加)
		   -> item 		物品相关定义封装 
		   -> itertor 	迭代器实现 提供接口 和一个数组迭代器
		   -> model  	model类 可派发事件通知 存储相关数据 提供数据的存取方法
		   -> net 		网络通信 提供 http socket(有PB AMF JSON 等数据协议对应的解析器插件) 等客户端通信工具 并可以由ServerManager统一实现ISERVER接口 
		   				通过Server工厂创建对应类型的 收发器
						ServerManager使用装饰器模式对各类 收发器做封装。
		   		
		   	->notify 	消息定义 对应NotifyManager 提供消息工厂 用于创建各类消息
		   	->popup 	系统级Alert实现 提供Alert Confirm 和 自动关闭的Alert几种基础实现 基于工厂
		   	->tooltip 	游戏鼠标浮动提示 支持多种提示方式
		   	->ui		as3 自写UI组件 与IDE快速结合使用  提供 模块基类 view基类(api简化封装)  
		   	->utils		各种辅助方法类封装
			
			
###		HOW TO USE
		系统框架支持 部分基类基于Robetlegs 可使用依赖注入  MVCS 和 命令模式
		1. 如果你想定义一个模块 请继承 Module基类 模块中的小面板 可以继承BaseView.
		模块类 使用ModuleManager 注册 添加现实。
		2. 需要加载资源 请注册 globaliztgion.controller.AssetLoaderCommand  通过事件即可驱动该控制器
		3. 如果需要使用网络通信 可以直接初始化使用net.ServerManager  设置init方法。
		4. 如需使用UI 可以使用ui包中各类轻量级的实现
		5. 如果要使用 寻路 需要实现 IMapModel 接口 填充 二维数组 地图坐标集(可以遍历一张位图 透明点为不可走区域)  设置格子数等
		然后使用Astar.getInstance().init()； 初始化寻路  然后使用find方法 传入起始点和结束点 获取路径中经过的点的集合
		
		
###		Robot Legs简述
		MVCS框架 内置依赖注入框架swiftsuspenders
		四大组件
		Context   类似 PureMvc Facade 核心类 用于启动 注册 其他3者之间的关联
		View Meditor 面板 & 控制器 不多描述		所有View 和Meditor 映射关系 在MeditorMap中
		Controller && Command 控制器 和命令 Robet legs 用命令模式实现控制器所有命令 也注册到CommandMap中
		Model & Actor 之所以称它为MVCS 是因为Service 部分 和Model具有相同的特性. 所以我的自定义框架中的ServerManager也继承与 Actor
		
		
		

###		SlotMashine(SlotCommon) com.aspectgaming.game
		公司的Slot老虎机 项目引擎
		这边就介绍下轮子的实现 
		com.aspectgaming.game.compoent.reels包
		使用装饰器模式 继承虚构类 AbstractReel 实现 一个横向和纵向 带有相同功能的2种轮子。 其中使用ReelAction命令模式 来完成轮子滚动时候发生的特殊事件
		
		
