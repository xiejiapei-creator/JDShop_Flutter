Flutter完整项目有2GB，GitHub好像限制了大小只能上传100MB...我上传了最关键的lib文件夹和导入外部框架的文件，只需要新建一个项目，对应替换后安装框架即可
运行效果图：
[![列表.png](https://upload-images.jianshu.io/upload_images/9570900-e3fdf46374bf5507.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
](https://upload-images.jianshu.io/upload_images/9570900-c0f008dd325050a9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![分类.png](https://upload-images.jianshu.io/upload_images/9570900-33530db1d40dd9e1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 ![地址列表.png](https://upload-images.jianshu.io/upload_images/9570900-6ab8ff4e22581190.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![属性.png](https://upload-images.jianshu.io/upload_images/9570900-1e9e0f338780aa35.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![新增地址.png](https://upload-images.jianshu.io/upload_images/9570900-c4874d77f198e3cc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![用户中心.png](https://upload-images.jianshu.io/upload_images/9570900-df2d9cf7462523da.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![订单.png](https://upload-images.jianshu.io/upload_images/9570900-6bb37fff5cc79bbc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![详情.png](https://upload-images.jianshu.io/upload_images/9570900-bb5048e5d5dae69b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![购物车.png](https://upload-images.jianshu.io/upload_images/9570900-fd9344104c746ac1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![首页.png](https://upload-images.jianshu.io/upload_images/9570900-3982bf52e5870b38.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

以下是我的开发日记：好好学习，天天向上，每天完成一点点，不知不觉就做完了，要是找女朋友也这么简单就好了...

#### Day1   功能分析、底部导航Tab切换以及路由配置、架构搭建 

#### Day2    首页布局以及不同终端屏幕适配方案
 
#### Day3    封装适配库以及实现左右滑动ListView 
  
#### Day4    首页商品列表布局 
1. Flutter仿照京东商城项目首页布局
2. Flutter 竖向ListView嵌套横向ListView，以及ListView嵌套GridView
3. Flutter 不同终端屏幕适配问题
  
#### Day5  Flutter JSON和序列化反序列化、创建模型类转换Json数据、轮播图数据渲染 
1. Flutter JSON序列化反序列化
2. Flutter JSON字符串和Map类型的转换 dart:convert手动序列化JSON
3. Flutter 在模型类中序列化JSON
4. 使用json_to_dart自动生成模型类
5. 请求轮播图接口渲染轮播图数据
 
#### Day6 Flutter创建商品数据模型 、请求Api接口渲染热门商品 推荐商品 
1. 首页推荐商品动态数据渲染
2. 首页热门商品动态数据渲染
3. json_to_dart自动生成模型类
 
#### Day7    商品分类页面布局 
1. 商品分类页面左右分栏
2. 右侧计算宽度布局
3. 商品分类页面左右分栏

#### Day8    商品分类页面数据渲染 
1. 定义商品分类页面数据模型
2. 请求Api接口渲染左侧分类
3. 点击左侧分类加载右侧分类
 
#### Day9  Flutter底部Tab切换保持页面状态的几种方法 IndexedStack 以及AutomaticKeepAliveClientMixin 
1. IndexedStack 保持页面状态
2. AutomaticKeepAliveClientMixin保持页面状态
 
#### Day10   商品分类跳转到商品列表传值 商品列表页面布局 
1. 商品分类页面路由跳转到商品列表页面传值
2. 商品列表页面内容布局

#### Day11    商品列表页面二级筛选导航布局 
商品列表页面 浮动筛选导航布局
自定义事件打开侧边框
 
#### Day12    商品列表页面请求数据、封装Loading Widget、上拉分页加载更多 
1. 封装公共的Loading Widget
2. 根据商品分类id请求不同的商品列表数据
3. 商品列表页面实现上拉分页加载更多
 
#### Day13    商品列表筛选以及上拉分页加载更多 
1. 根据属性筛选不同的商品数据（实现价格排序、销量排序）
2. ListView回到顶部
3. 筛选排序后 上拉分页加载更多
 
#### Day14    头部搜索导航布局 修改主题 修正ScreenAdapter类 
1. Flutter搜索导航
2. Flutter flutter_screenutil适配字体大小，以及修正ScreenAdapter
3. Flutter 修改主题样式
4. Flutter 首页、分类、购物车页面搜索导航布局
5. Flutter 搜索页面导航布局
 
#### Day15    搜索页面布局 
1. 热门搜索布局
2. 搜索历史记录布局
3. 清空历史记录布局
 
#### Day16    跳转到搜索页面实现搜索功能 以及搜索筛选 
1. 点击搜索实现搜索功能
2. 搜索后按照价格  销量排序
3. 搜索后上拉分页加载更多
 
#### Day17    保存历史搜索记录  删除历史记录  清空历史记录 长按删除 
1. Flutter封装公共的Storage库
2. 保存搜索历史记录
3. 长按弹出Dialog
4. 长按历史记录删除功能
5. 清空历史搜索记录
 
#### Day18   商品详情顶部tab切换  顶部下拉菜单  底部浮动导航 
1. 商品详情顶部tab切换
2. Flutter顶部右侧下拉菜单
3. Flutter浮动导航
 
#### Day19     商品详情 底部浮动导航布局  商品页面布局 
1. 封装公共的按钮组件
2. 底部浮动导航 购物车 加入购物车 立即购买布局
3. 商品详情页面布局
 
#### Day20     商品详情  弹出筛选属性  筛选属性页面布局 GestureDetector事件 
1. 底部弹出筛选属性
2. GestureDetector事件
3. 底部弹出筛选属性布局
#### Day21    商品详情 请求接口渲染数据  商品属性数据渲染 
1. 商品详情 页面布局    
2. 商品详情Api接口    
3. Flutter WebView组件inappbrowser的使用     
4. StatefulBuilder更新Flutter showDialog 、showModalBottomSheet中的状态     
5. json_to_dart自动生成模型类
#### Day22    inappbrowser 加载商品详情、保持页面状态、以及实现属性筛选业务逻辑
#### Day23  Flutter官方推荐的状态管理库provider的使用 
1. Flutter状态管理介绍
2. 关于flutter provider库和flutter provide库的区别
3. flutter provider 的使用
#### Day24 Flutter官方推荐的状态管理库provider的深入使用、初始化修改状态、父子组件同步状态  
#### Day25   购物车页面布局 
#### Day26    购物车之 event_bus事件广播 事件监听 
1. 点击底部加入购物车弹出属性筛选
2. event_bus 介绍    
3. event_bus 使用 事件广播 事件监听    
4. event_bus 取消事件监听
#### Day27    购物车之 实现数量加减 以及获取加入购物车的数据 
#### Day28   购物车之 定义service加入购物车、更新provider、显示购物车数据 
#### Day29   购物车之  购物车数量加减 全选 反选 
#### Day30   计算总价  删除购物车数据  加入购物车toast提示 商品页面跳转到购物车页面 
#### Day31     真机兼容性bug、事件点击穿透问题、禁止详情滑动 
#### Day32     用户中心页面布局  
#### Day33     登录 注册相关页面布局 
#### Day34   用户注册 注册流程 POST发送验证码  倒计时功能  验证验证码 
#### Day35    用户注册 完成注册、保存用户信息、跳转到根、显示用户信息 
#### Day36   用户登录 退出登录 事件广播更新状态 
#### Day37    结算页面布局  
#### Day38    渲染结算页面商品数据 
#### Day39    收货地址列表、增加 修改收货地址布局、弹出省市区选择器 
#### Day40   签名验证原理、签名验证算法 
1. Flutter Md5加密
2. 为什么要签名验证  
3. 签名验证实现原理
4. 签名验证算法
#### Day41  Flutter 仿京东商城项目签名验证 增加收货地址、显示收货地址 事件广播 
#### Day42     修改默认收货地址 显示默认收货地址 
#### Day43     修改收货地址 删除收货地址 
#### Day44     提交订单、去支付页面制作
#### Day45    订单列表、订单详情页面布局 
#### Day46 Flutter 仿京东商城项目 订单列表数据渲染 
