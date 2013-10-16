##2013.10.16 update
* Compatible with new API(new attributes, landmarks etc.) 

##2.0 update
* Compatible with 2.0 API
* Modify the initialize function to change region between CN and US 
	- Example: `[FaceppAPI initWithApiKey: @"YOUR_KEY" andApiSecret: @"YOUR_SECRET" andRegion: API_SERVER_REGION]`

------------------------------------------------------
##To integrate FacePlusPlus SDK into your iOS project

1. In the finder, drag FaceppSDK into project's file folder.

2. Add it to your project: 
	- File -> Add Files to "your project"
	- Choose 'Recursively create groups for any added folders'

3. In xcodeproj -> Build Settings, set **"Objective-C Automatic Reference Counting"** to **NO**
	- If you want to use automatic reference counting, you can use "FaceppSDK_ARC" instead of "FaceppSDK" which in step 1&2.

4. In your Application Delegate:
	- Import FaceppAPI
	- Add: `[FaceppAPI initWithApiKey: @"YOUR_KEY" andApiSecret: @"YOUR_SECRET"]`
	- Sample code:
	<pre><code>\#import "FaceppAPI.h"
	\- (BOOL)application:(UIApplication \*)application didFinishLaunchingWithOptions:(NSDictionary \*)launchOptions {
		[FaceppAPI initWithApiKey:API_KEY andApiSecret:API_SECRET];
		...
	}</code></pre>

5. Call FaceppAPI to do anything you want, it will return a struct called `FaceppResult`
	- Examples: 
	<pre><code>FaceppResult\* result = [[FaceppAPI detection] detectWithURL:nil 
							imageData:[NSData dataWithContentsOfFile:@"LOCAL_FILE_PATH"]];
FaceppResult\* result = [[FaceppAPI group] deleteWithGroupName: @"GROUP_NAME" orGroupId: nil];</code></pre>
6. Get value from FaceppResult
	- Examples:
		- Get image's width in pixel from a detection result - `detectLocalFileResult`:
	<pre><code>double img_width = [[detectLocalFileResult content][@"img_width"] doubleValue];</code></pre>
		- Get the first face_id from result:
			<pre><code>NSString \*face_id = [detectLocalFileResult content][@"face"][0][@"face_id"];</code></pre>

7. Optional: enable debug mode	
	- Set debug mode on to display all http request packages and response raw JSON result on console output.
		<pre><code>[FaceppAPI setDebugMode: TRUE];</code></pre>

-- More sample codes would be found in "FaceppDemo" --

-------------------------------------------------------------------------------------

##您只需要做以下几个步骤就可以将FacePlusPlus SDK集成到您的iOS工程中

1. 在finder中，将FaceppSDK目录拖入工程目录下

2. 将FaceppSDK添加至您的工程中
	- 在菜单中选择File -> AddFiles to "YOUR_PROJECT"
	- 将'Recursively create groups for any added folders'选项钩上

3. 在工程设置文件中的Build Settings内，将**"Objective-C Automatic Reference Counting"**设置为**NO**
	- 注：如果需要使用自动引用计数，请用FaceppSDK_ARC替换FaceppSDK，并重新执行步骤1和2

4. 在您的应用程序入口处添加以下代码：
	- import FaceppAPI
	- 添加`[FaceppAPI initWithApiKey: @"YOUR_KEY" andApiSecret: @"YOUR_SECRET"]`
	- 举例来说，具体工程入口的代码如下所示:
	<pre><code>\#import "FaceppAPI.h"
	\- (BOOL)application:(UIApplication \*)application didFinishLaunchingWithOptions:(NSDictionary \*)launchOptions {
		[FaceppAPI initWithApiKey:API_KEY andApiSecret:API_SECRET];
		...
	}</code></pre>

5. 使用 FaceppAPI接口来调用任何您想调用的接口，在获得数据以后其将返回一个`FaceppResult`结构
	－例子：
	<pre><code>FaceppResult\* result = [[FaceppAPI detection] detectWithURL:nil 
							imageData:[NSData dataWithContentsOfFile:@"LOCAL_FILE_PATH"]];
FaceppResult\* result = [[FaceppAPI group] deleteWithGroupName: @"GROUP_NAME" orGroupId: nil];</code></pre>

6. 从FaceppResult中获取结果：
	- 例子:
		- 从返回的检测结果(`detectLocalFileResult`)中获得图像的宽度：
	<pre><code>double img_width = [[detectLocalFileResult content][@"img_width"] doubleValue];</code></pre>
		- 获得第一张脸的face_id：
			<pre><code>NSString \*face_id = [detectLocalFileResult content][@"face"][0][@"face_id"];</code></pre>

7. 使用调试模式：
	- 开启调试模式之后，程序将向控制台输出所有http请求的url，以及返回json的原始数据，以供调试使用。
		<pre><code>[FaceppAPI setDebugMode: TRUE];</code></pre>

-- 更多的使用方法样例可以在“FaceppDemo”工程中发现 --

