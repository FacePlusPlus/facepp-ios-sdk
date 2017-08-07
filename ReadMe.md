##中文文档
* 这个Demo里面的SDK是对官网api接口的封装,需要联网使用.官网接口地址: <https://console.faceplusplus.com.cn/documents/4888373>
* 如何运行Demo:
    1. 在官网注册账号: <https://www.faceplusplus.com.cn/>
    2. 创建apikey来使用: <https://console.faceplusplus.com.cn/app/apikey/create> (试用的apikey可以免费使用,可能有并发数错误.正式apikey需要充值后使用)
    3. 配置`FCPPConfig.h`文件,将生成的`apikey`和`apisecret`写到这个文件,`isChina` 设置为`1`.
    4. 运行.   

* 如何集成到自己的项目
  1.把`FCPPSDK`和`AFNetworking`这个文件夹拖入到自己的项目即可
  2.配置`FCPPConfig.h`文件,方法同上面第三步.  

* 如果有问题,请加入QQ群418490173咨询技术支持

##English Document
* The SDK in the Demo is a package of online api which need to use the network. The api document: <https://console.faceplusplus.com/documents/5679127>
* How to run the Demo ?
    1. Register an account in the offcial website: <https://www.faceplusplus.com/>
    2. Creating a apiKey and apiSecret to use: <https://console.faceplusplus.com/app/apikey/create> (The free apikey has a limit of on the number of concurrent,and if using the official apikey, please make sure the account balance is sufficient)
    3. Set the `apiKey` and `apiSecret` in the file `FCPPConfig.h`. The value of `isChina`  is `0`. 

* To integrate SDK into your iOS project
    
    1. Drag `FaceppSDK` and `AFNetworking` into project's file folder.
    2. Config the file `FCPPConfig.h` just like the third step above.
* If have any problem please contact us by sending email to support-mc@megvii.com

