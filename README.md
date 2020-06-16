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

#### Day1  功能分析、底部导航Tab切换以及路由配置、架构搭建 

#### Day2  首页布局以及不同终端屏幕适配方案
 
#### Day3  封装适配库以及实现左右滑动ListView 
  
#### Day4  首页商品列表布局 
  
#### Day5  JSON和序列化反序列化、使用json_to_dart自动生成模型类、轮播图数据渲染 
 
#### Day6  创建商品数据模型 、请求Api接口渲染热门商品\推荐商品 
 
#### Day7  商品分类页面左右分栏、右侧计算宽度布局、

#### Day8  定义商品分类页面数据模型、请求Api接口渲染左侧分类、点击左侧分类加载右侧分类
 
#### Day9  底部Tab切换保持页面状态的几种方法 IndexedStack 以及AutomaticKeepAliveClientMixin 
 
#### Day10 商品分类页面路由跳转到商品列表页面传值 商品列表页面内容布局

#### Day11 商品列表页面浮动筛选导航布局、自定义事件打开侧边框
 
#### Day12 根据商品分类id请求不同的商品列表数据、封装公共的Loading Widget、商品列表页面实现上拉分页加载更多
 
#### Day13 根据属性筛选不同的商品数据（实现价格排序、销量排序）
 
#### Day14 首页、分类、购物车页面顶部搜索框、修改主题样式、修正ScreenAdapter类，flutter_screenutil适配字体大小
 
#### Day15 保存历史搜索记录  删除历史记录  清空历史记录
 
#### Day16 搜索后按照价格、销量排序
 
#### Day17 封装公共的Storage库、长按历史记录删除功能
 
#### Day18 商品详情顶部tab切换、底部浮动导航与购物车关联
 
#### Day19 封装公共的按钮组件、商品详情页面布局
 
#### Day20 商品详情请求接口渲染数据、商品属性数据渲染 、WebView组件inappbrowser的使用

#### Day21 StatefulBuilder更新Flutter showDialog 、showModalBottomSheet中的状态   

#### Day22 inappbrowser加载商品详情

#### Day23 Flutter官方推荐的状态管理库provider的使用：父子组件同步状态  

#### Day24 购物车页面布局 

#### Day25 购物车之 event_bus事件广播 事件监听  取消事件监听

#### Day26 购物车之实现数量加减以及获取加入购物车的数据 

#### Day27 购物车之定义service加入购物车

#### Day28 购物车之更新provider显示购物车最新数据 

#### Day29 购物车之全选、反选

#### Day30 计算总价、删除购物车数据、加入购物车toast提示、商品页面跳转到购物车页面 

#### Day31 真机兼容性bug、事件点击穿透问题、禁止详情滑动 

#### Day32 用户中心页面布局 

#### Day33 登录、注册相关页面布局 

#### Day34 用户注册、注册流程、POST发送验证码、倒计时功能、验证验证码 

#### Day35 完成注册、保存用户信息、跳转到根试图、显示用户信息 

#### Day36 用户登录、退出登录、事件广播更新状态 

#### Day37 结算页面布局  

#### Day38 渲染结算页面商品数据 

#### Day39 收货地址列表、弹出省市区选择器 

#### Day40 签名验证算法Md5加密

#### Day41 增加收货地址、显示收货地址、修改收货地址、删除收货地址 

#### Day42 修改默认收货地址 显示默认收货地址 

#### Day43 提交订单

#### Day44 支付页面

#### Day45 订单列表、订单详情页面布局 

#### Day46 订单列表数据渲染 
