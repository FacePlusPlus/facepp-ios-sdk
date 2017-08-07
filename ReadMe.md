##中文文档

* 这个Demo里面的SDK是对官网在线Api接口的封装,需要联网使用.官网接口文档地址: <https://console.faceplusplus.com.cn/documents/4888373>
* 如何运行Demo:
    * 在官网注册账号: <https://www.faceplusplus.com.cn/>
    * 创建APIKey来使用: <https://console.faceplusplus.com.cn/app/apikey/create> (试用的APIKey可以免费使用,可能有并发数错误.正式APIKey需要充值后使用)
    * 配置`FCPPConfig.h`文件,将生成的`APIKey`和`APISecret`写到这个文件,`isChina` 设置为`1`.
    * 运行.   

* 如何集成到自己的项目
  
  * 把`FCPPSDK`和`AFNetworking`这个文件夹拖入到自己的项目即可
  * 配置`FCPPConfig.h`文件,方法同上面第三步.  

* 如果有问题,请加入QQ群`418490173`咨询技术支持

##English Document

* The SDK in the Demo is a package of online api which need to use the network. The api document: <https://console.faceplusplus.com/documents/5679127>
* How to run the Demo ?
    * Register an account in the offcial website: <https://www.faceplusplus.com/>
    * Creating a APIKey and APISecret to use: <https://console.faceplusplus.com/app/apikey/create> (The free APIKey has a limit of on the number of concurrent,and if using the official APIKey, please make sure the account balance is sufficient)
    * Set the `APIKey` and `APISecret` in the file `FCPPConfig.h`. The value of `isChina`  is `0`. 

* To integrate SDK into your iOS project
    
    * Drag `FaceppSDK` and `AFNetworking` into project's file folder.
    * Config the file `FCPPConfig.h` just like the third step above.
* If have any problem please contact us by sending email to support-mc@megvii.com

