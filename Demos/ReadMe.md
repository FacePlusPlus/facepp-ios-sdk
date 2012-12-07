#示例
工程包含两个demo:

- 程序调用FaceppAPI的实例集合（FaceppDemo）
- 从相册和摄像头中获取图像并进行检测的实例（FaceppPhotoPickerDemo）

##使用方法
首先将工程的Bundle Identifier前缀改为您的provisioning所对应的字符串

###FaceppDemo
将FaceppDemo/AppDelegate.m中的`API_KEY`和`API_SECRET`改为您app的KEY与SECRET之后运行即可。
###FaceppPhotoPickerDemo
填写FaceppPhotoPickerDemo/ViewController.m内的`API_KEY`和`API_SECRET`，并将编译target设置为FaceppPhotoPickerDemo之后运行即可。