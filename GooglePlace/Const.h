//
//  Const.h
//  GooglePlace
//
//  Created by Liu Lei on 12-3-27.
//  Copyright (c) 2012年 Coolinsoft. All rights reserved.
//

#ifndef GooglePlace_Const_h
#define GooglePlace_Const_h

//Google API Key
#define API_KEY                  @"AIzaSyCdxf5WLhuyJWchZuGUk9terB_AzQAFlzI"

//Place Search 请求
#define PLACEAPI_SEARCHURL_JSON  @"https://maps.googleapis.com/maps/api/place/search/json?"
#define PLACEAPI_SEARCHURL_XML   @"https://maps.googleapis.com/maps/api/place/search/xml?"

//位置详情 请求
#define PLACEAPI_DETAILURL_JSON  @"https://maps.googleapis.com/maps/api/place/details/json?"
#define PLACEAPI_DETAILURL_XML   @"https://maps.googleapis.com/maps/api/place/details/xml?"


/*Place Search 请求

位置搜索请求是采用以下形式的 HTTP 网址：

https://maps.googleapis.com/maps/api/place/search/output?parameters
其中，output 可能是以下任何一个值：

json（建议）表示以 JavaScript 对象表示法 (JSON) 的形式输出
xml 表示以 XML 的形式输出
需要用某些参数来发起位置搜索请求。根据网址的标准，所有参数均使用字符 & (&) 分隔。下面枚举了这些参数及其可能的值。

location（必填）– 在其周围检索“地方”信息的纬度/经度。此参数必须作为 google.maps.LatLng 对象提供。
radius（必填）– 要在其范围内返回的“地方”结果的距离（以米为单位）。推荐的最佳做法是根据位置传感器指定的地方信号的精确度来设置 radius。请注意，您可以将 radius 偏向结果设为指定的区域，但无法将结果完全限制在指定区域中。
types（可选）– 将结果限制为至少匹配一种指定类型的“地方”。类型应使用竖线符号 (type1|type2|etc) 进行分隔。请参见支持的类型列表。
language（可选）– 语言代码，表示返回结果时应使用的语言（如果可能的话）。请参见支持的语言列表及其代码。请注意，我们会经常更新支持的语言，因此该列表可能并不详尽。
name（可选）– 要与“地方”的名称进行匹配的字词。这会将结果限制为包含传递的 name 值的结果。当加入名称时，系统可能会扩大搜索范围，以确保获得适量的结果。
sensor（必填）- 表示位置请求是否来自于使用位置传感器（如 GPS）的设备，从而确定此请求中发送的位置。该值必须为 true 或 false。
key（必填）– 您的应用程序的 API 密钥。此密钥用于标识您的应用程序，以便管理配额，从而让您的应用程序添加的“地方”可立即在该应用程序中使用。要创建 API 项目并获取密钥，请访问 API 控制台。
以下是一个请求示例，展示了在以澳大利亚悉尼的一点为中心，半径 500 米的范围内搜索名称中包含“harbour”一词且类型为“food”的“地方”。

https://maps.googleapis.com/maps/api/place/search/json?location=-33.8670522,151.1957362&radius;=500&types;=food&name;=harbour&sensor;=false&key;=AIzaSyAiFpFd85eMtfbvmVNEYuNds5TEF9FjIPI
请注意，您需要将此示例中的密钥替换为自己的密钥，这样请求才能在您的应用程序中发挥作用。
https://maps.googleapis.com/maps/api/place/search/output?parameters*/



/*位置详情
 
 一旦您获得来自位置搜索请求的 reference，便可以通过发起位置详情请求来请求有关特定场所或感兴趣地点的更多详情。位置详情请求将会传回有关指定位置的更为全面的信息，如其完整的地址、电话号码、用户评级等。
 
 位置详情请求
 
 位置详情请求是采用以下形式的 HTTP 网址：
 
 https://maps.googleapis.com/maps/api/place/details/output?parameters
 其中，output 可能是以下任何一个值：
 
 json（建议）表示以 JavaScript 对象表示法 (JSON) 的形式输出
 xml 表示以 XML 的形式输出
 需要用某些参数来发起搜索请求。根据网址的标准，所有参数均使用字符 & (&) 分隔。下面枚举了这些参数及其可能的值。
 
 reference（必填）– 唯一标识某地方的文本标识符，返回自地方搜索请求。
 language（可选）– 语言代码，表示返回结果时应使用的语言（如果可能的话）。请参见支持的语言列表及其代码。请注意，我们会经常更新支持的语言，因此该列表可能并不详尽。
 sensor（必填）– 表示发送“位置详情”请求的设备是否使用了位置传感器（如 GPS）。该值只能是 true 或 false
 key（必填）– 您的应用程序的 API 密钥。此密钥用于标识您的应用程序，以便管理配额，从而让您的应用程序添加的“地方”可立即在该应用程序中使用。要创建 API 项目并获取密钥，请访问 API 控制台。
 以下显示了一个请求示例：
 
 https://maps.googleapis.com/maps/api/place/details/json?reference=CmRYAAAAciqGsTRX1mXRvuXSH2ErwW-jCINE1aLiwP64MCWDN5vkXvXoQGPKldMfmdGyqWSpm7BEYCgDm-iv7Kc2PF7QA7brMAwBbAcqMr5i1f4PwTpaovIZjysCEZTry8Ez30wpEhCNCXpynextCld2EBsDkRKsGhSLayuRyFsex6JA6NPh9dyupoTH3g&sensor;=true&key;=AIzaSyAiFpFd85eMtfbvmVNEYuNds5TEF9FjIPI
 请注意，您需要将此示例中的密钥替换为自己的密钥，这样请求才能在您的应用程序中发挥作用。*/

#endif
